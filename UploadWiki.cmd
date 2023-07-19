@echo off
if not exist "./Wiki/*.md" (
	echo ERROR: Wiki directory has no files to synchronize!
) else (
	pushd ./Wiki
	git push
	popd
)