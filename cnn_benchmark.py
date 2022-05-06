# ******************************************************************************
# Copyright (c) 2021 Advanced Micro Devices, Inc. All rights reserved.
# ******************************************************************************

# This script can be used to benchmark CNN models with Pytorch + ZenDNN
import sys
import torch, time, argparse
import torchvision.models as models

from rich.progress import track
from rich.console import Console
from rich.table import Table


def get_model(model_name, batch_size, use_trained=True):
    model = models.__dict__[model_name](pretrained=use_trained).eval()
    desc_strs = [model_name]
    desc_strs.append("bs" + str(batch_size))

    # Prepare model
    model = torch.jit.script(model)
    try:
        model = torch.jit.optimize_for_inference(model)
    except:
        try:
            model = torch.jit.freeze(model)
        except:
            print("Unable to freeze the model", flush=True)
            return model, "_".join(desc_strs)
        print("model is frozen but not optimized ", flush=True)
    return model, "_".join(desc_strs)


def benchmark_inference(mod, inp, desc, warmup_cnt, iterations):
    batch_size = inp.shape[0]

    table = Table(title=f"{desc} Benchmark")
    table.add_column("Type", justify="right", style="cyan", no_wrap=True)
    table.add_column("Latency (s) ↓", justify="right", style="magenta")
    table.add_column("Throughput (qps) ↑", justify="right", style="green", no_wrap=True)

    # print("*" * 80, flush=True)
    # print("*" + desc.center(78) + "*", flush=True)
    # print("*" * 80, flush=True)
    # desc += ":"

    # Warm up
    start = time.time()
    for i in track(range(warmup_cnt), description="Warmup |".rjust(12), transient=True):
        out = mod(inp)
    end = time.time()
    dur = (end - start) / warmup_cnt
    # print(
    #     desc.ljust(30)
    #     + "Warm up time".rjust(15)
    #     + ": {0:7.3f}s".format(dur)
    #     + "QPS".rjust(10)
    #     + ": {0:7.2f}".format(batch_size / dur),
    #     flush=True,
    # )

    table.add_row("Warmup", f"{dur:.4f}s", f"{(batch_size / dur):.4f}")

    # Final runs
    start = time.time()
    for i in track(
        range(iterations), description="Benchmark |".rjust(12), transient=True
    ):
        out = mod(inp)
    end = time.time()
    dur = (end - start) / iterations
    # print(
    #     desc.ljust(30)
    #     + "Inference time".rjust(15)
    #     + ": {0:7.3f}s".format(dur)
    #     + "QPS".rjust(10)
    #     + ": {0:7.2f}".format(batch_size / dur),
    #     flush=True,
    # )
    table.add_row("Inference", f"{dur:.4f}s", f"{(batch_size / dur):.4f}")

    console = Console()
    console.print(table)

    return


if __name__ == "__main__":

    # Input Dimensions (C, H, W)
    dimensions = {}
    dimensions["alexnet"] = [3, 224, 224]
    dimensions["vgg11"] = [3, 224, 224]
    dimensions["googlenet"] = [3, 224, 224]
    dimensions["inception_v3"] = [3, 299, 299]
    dimensions["resnet50"] = [3, 224, 224]
    dimensions["resnet152"] = [3, 224, 224]
    dimensions["squeezenet1_0"] = [3, 224, 224]
    dimensions["mobilenet_v2"] = [3, 224, 224]

    # Benchmark Settings
    parser = argparse.ArgumentParser(description="PyTorch Convnet Benchmark")

    parser.add_argument(
        "--arch",
        action="store",
        default="resnet50",
        help="model name (default is ResNet50) can be specified as any of these models : "
        + ", ".join(dimensions.keys()),
    )
    parser.add_argument(
        "--batch_size",
        action="store",
        default=192,
        type=int,
        help="batch size is 1 (default)",
    )
    parser.add_argument(
        "--warmups", action="store", default=5, type=int, help="warmups are 5 (default)"
    )
    parser.add_argument(
        "--iterations",
        action="store",
        default=100,
        type=int,
        help="iterations are 10 (default)",
    )

    args = parser.parse_args()
    if not args.arch in dimensions.keys():
        print("unsupported model is specified")
        sys.exit

    c, h, w = dimensions[args.arch]
    # Random Input
    inp = torch.randn(args.batch_size, c, h, w)

    # Generate Model
    model, desc = get_model(model_name=args.arch, batch_size=args.batch_size)

    # Execute the Benchmark
    benchmark_inference(
        model, inp, desc, warmup_cnt=args.warmups, iterations=args.iterations
    )
