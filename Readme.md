# SystemTap perf image

This is an image intended that extends RHEL8 support tools in the right way so that both `stap` and `perf` can be run inside it. This means downloading all the required kernel debug symbols, etc. for a concrete target version.

## Warnings

Let's start with the ugly part, the warnings:
- Building this image requires access to internal Red Hat resources so **this repository mustn't be shared with customers**. Build the image for them and provide it (either exporting and attaching or via some repo).
- These images take very long to build.
- These images are huge in size (don't be surprised it one image is ~4G).
- Each image can target one OCP version only, basically because it needs to install packages with specific versions that match the kernel and linux-firmware packages on the RHCOS system.

## Build

**Builds must be done inside Red Hat network and/or VPN**. Either buildah, podman or docker is required to build this image (if many of those is available, one of them will be chosen in this order of preference).

Also note that builds may take long and produce very big images.

### Build method 1: Fully automatic

```
./build-auto.sh ${OCP_VERSION} ${TAG}
```

### Build method 2: Not that automatic

```
./build.sh ${KERNEL_RPM_VERSION} ${LINUX_FIRMWARE_RPM_VERSION} ${RHEL_VERSION} ${TAG}
```

## Usage

There are many ways to use this image. The most comfortable one is to use it as a replacement of Support Tools image in either `toolbox` or `oc debug node/${SOME_NODE}`. Once the debug shell is opened, instead of chrooting to `/host`, you can just run the desired `stap` or `perf` command and gather the output.

You can also create the pod in any way you want though (`oc run`, `podman run`, manually creating a manifest, a daemonset...), just bear in mind:
- Pod must be **privileged**
- If no command is specified, it runs stap with the example `probe.stap` SystemTap script (exact command is `stap -g --all-modules /usr/local/bin/probe.stap`) instead of opening a shell. Instead, you might want to run another command of your choice in a similar way.
- Pod must be in the host network (unless you do want to do some test in a non-host pod network namespace). You may need to also adjust other namespaces to be the host ones.

Regarding where to store the results of perf or stap runs, by default, workdir is set to `/workdir` folder inside the container, which is a volume. If you want to store results in a persistent volume, for example, you should just mount it at `/workdir`.