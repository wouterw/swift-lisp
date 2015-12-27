lisp
====

https://github.com/kanaka/mal/blob/master/process/guide.md

```
docker-machine default start
eval "$(docker-machine env default)"
docker build -t swift ./
docker run --rm -v $(pwd):/swift-lisp -it swift /bin/bash
```

To build this package:

```
cd swift-lisp
swift build
.build/debug/Lisp
```
