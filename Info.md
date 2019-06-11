### Manual Build

```
git clone --recursive https://github.com/uber/horovod.git
cd horovod
python setup.py clean
python setup.py bdist_wheel
```

When the build process success, .whl package is in ./dist/ directory, then install:

```
pip install ./dist/horovod-<version>-cp27-cp27mu-linux_x86_64.whl
```


### Note:

```bdist_wheel``` will build you a wheel file on that can be installed on a server with exactly the same build flags (e.g. HOROVOD_GPU_ALLREDUCE)
and version of TensorFlow, MPI, CUDA, and NCCL as the server you built the wheel on.

```sdist``` provides source tarball that you can install on a target server with build flags and versions of dependencies available on the server
that you're installing the tarball.

If ```python setup.py sdist``` option was used in the build, intstall horovod as following:

```
HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 pip install --no-cache-dir dist/horovod*.tar.gz
```

### Advice: 

Use python setup.py sdist instead of bdist_wheel, because it gives this "late binding" benefits.

https://github.com/horovod/horovod/issues/155
