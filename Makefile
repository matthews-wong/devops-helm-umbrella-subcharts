CHART := chart
ENVS := dev prod

.PHONY: validate lint render toggle-tests

validate: lint render toggle-tests

lint:
	helm lint $(CHART)
	@for e in $(ENVS); do helm lint $(CHART) -f $(CHART)/values-$$e.yaml || exit 1; done

render:
	@for e in $(ENVS); do \
		helm template t $(CHART) -f $(CHART)/values-$$e.yaml | kubeconform -strict -summary || exit 1; \
	done

toggle-tests:
	tests/toggles.sh
