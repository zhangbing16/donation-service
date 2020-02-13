# Copyright Arxan Chain Ltd. 2020 All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#                  http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

BINARY=donation-service
VERSION=0.1.0
BUILD=`date +%FT%T%z`

BUILDPATH=build
BUILDBINPATH=${BUILDPATH}/bin

PACKAGES=`go list ./... | grep -v /sampleconfig/ | grep -v /scripts/`
VETPACKAGES=`go list ./... | grep -v /sampleconfig/ | grep -v /scripts/`
GOFILES=`find . -name "*.go"`

default:
	@go build -o ${BUILDBINPATH}/${BINARY} -tags=jsoniter
	@cp sampleconfig/donation-service.yaml ${BUILDBINPATH}

list:
	@echo ${PACKAGES}
	@echo ${VETPACKAGES}
	@echo ${GOFILES}

fmt:
	@gofmt -s -w ${GOFILES}

fmt-check:
	@diff=$$(gofmt -s -d $(GOFILES)); \
	if [ -n "$$diff" ]; then \
		echo "Please run 'make fmt' and commit the result:"; \
		echo "$${diff}"; \
		exit 1; \
	fi;

mod:
	@go mod tidy

test:
	@go test -cpu=1,2,4 -v -tags integration ./...

vet:
	@go vet $(VETPACKAGES)

#docker:
#   @docker build -t csiabb/donation-service:${VERSION} .

clean:
	@rm -rf ${BUILDPATH}

.PHONY: default fmt fmt-check mod test vet docker clean
