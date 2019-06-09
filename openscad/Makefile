OPENSCAD := openscad-nightly
MONTAGE := montage
targets :=  $(wildcard macintosh-mini-part*.scad)
stls := $(targets:.scad=.stl)
image_dir := images
thumbnails := $(targets:%.scad=${image_dir}/%_s.png)
img_models := ${image_dir}/models.png

.PHONY: all clean images
all: ${stls}
	@echo done

${stls}: %.stl: %.scad
	@echo Building $@ from $<
	${OPENSCAD} -o $@ $<

clean:
	rm -f ${stls}

images: $(thumbnails) ${img_models}
	@echo done

$(thumbnails): ${image_dir}/%_s.png: %.scad
	@echo Generating $@ from $<
	${OPENSCAD} -o $@ \
		--imgsize=640,480 --colorscheme=Tomorrow \
		--projection o --camera -200,-200,280,0,0,40 $<

${img_models}: ${thumbnails}
	@echo Generating $@ from $^
	${MONTAGE} -label '%t' -geometry 320x240 $(sort $^) $@
