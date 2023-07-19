@echo off
if not exist "./Wiki/*.md" (
	git clone https://github.com/WolfNet-Computing/WolfNet-Computing-Boot-Tools.wiki.git "./Wiki"
) else (
	pushd ./Wiki
	git pull
	popd
)