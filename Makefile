ALL_GO_MOD_DIRS := $(shell find . -type f -name 'go.mod' -exec dirname {} \; | sort)

test:
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  echo "go test in $${dir}"; \
	  (cd "$${dir}" && \
	    go test ./... && \
	    go vet); \
	done

tag:
	go mod edit -require github.com/uptrace/bun@v$(VERSION) dialect/pgdialect/go.mod
	go mod edit -require github.com/uptrace/bun@v$(VERSION) dialect/mysqldialect/go.mod
	go mod edit -require github.com/uptrace/bun@v$(VERSION) dialect/sqlitedialect/go.mod
	go mod edit -require github.com/uptrace/bun@v$(VERSION) driver/pgdriver/go.mod
	go mod edit -require github.com/uptrace/bun@v$(VERSION) dbfixture/go.mod
	go mod edit -require github.com/uptrace/bun@v$(VERSION) extra/bundebug/go.mod
	go mod edit -require github.com/uptrace/bun@v$(VERSION) extra/bunotel/go.mod
	git add \*.mod
	git commit -m "Bump to version $(VERSION)"
	git tag $(VERSION)
	git tag dialect/pgdialect/$(VERSION)
	git tag dialect/mysqldialect/$(VERSION)
	git tag dialect/sqlitedialect/$(VERSION)
	git tag driver/pgdriver/$(VERSION)
	git tag driver/sqliteshim/$(VERSION)
	git tag dbfixture/$(VERSION)
	git tag extra/bundebug/$(VERSION)
	git tag extra/bunotel/$(VERSION)

go_mod_tidy:
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  echo "go mod tidy in $${dir}"; \
	  (cd "$${dir}" && \
	    go get -d ./... && \
	    go mod tidy); \
	done

fmt:
	gofmt -w -s ./
	goimports -w  -local github.com/uptrace/bun ./
