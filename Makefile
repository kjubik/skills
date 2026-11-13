.PHONY: skill

# Usage: make skill my-skill
# Second goal is taken as the skill name; a no-op rule stops make building it.
ifeq (skill,$(firstword $(MAKECMDGOALS)))
  name := $(word 2,$(MAKECMDGOALS))
  ifneq ($(name),)
    $(eval $(name):;@:)
  endif
endif

skill:
	@test -n "$(name)" || { echo "usage: make skill <skill-name>"; exit 1; }
	@test ! -e "skills/$(name)" || { echo "skills/$(name) already exists"; exit 1; }
	@mkdir -p "skills/$(name)/agents"
	@title=$$(echo "$(name)" | sed -E 's/(^|-)(.)/\1\U\2/g; s/-/ /g'); \
	printf '%s\n' \
		'---' \
		'name: $(name)' \
		'description: TODO' \
		'disable-model-invocation: true' \
		'---' \
		'' \
		"# $$title" > "skills/$(name)/SKILL.md"; \
	printf '%s\n' \
		'interface:' \
		"  display_name: \"$$title\"" \
		'  short_description: "TODO"' \
		'policy:' \
		'  allow_implicit_invocation: false' > "skills/$(name)/agents/openai.yaml"
	@echo "created skills/$(name)"
