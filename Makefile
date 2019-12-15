generate_resume:
	ruby ./pages/print/resume.pdf.prawn

run_local:
	@make generate_resume
	bundle exec jekyll serve
