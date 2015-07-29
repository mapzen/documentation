
define serve-mkdocs
	# Wait a second to let mkdocs have time to build
	# Then open a browser on local machine
	# This is spun off as a child processs
	@(sleep 1; open http://127.0.0.1:8000) &
	# Build, serve and watch is the main thread
	env/bin/mkdocs serve
endef

# Build and serve tangram docs
tangram: virtualenv
	ln -sf config/tangram.yml ./mkdocs.yml
	$(serve-mkdocs)

# Build and serve metro-extracts docs
metro-extracts: virtualenv
	ln -sf config/metro-extracts.yml ./mkdocs.yml
	$(serve-mkdocs)

# Build and serve metro-extracts docs
valhalla: virtualenv
	ln -sf config/valhalla.yml ./mkdocs.yml
	$(serve-mkdocs)

# Set virtual environment & install dependencies
virtualenv:
	test -d env || virtualenv env
	env/bin/pip install -Ur requirements.txt

.PHONY: tangram
