#!/bin/bash

QTUS=https://github.com/qt/
TAG=5.10

if [[ ! $(git remote -v | grep upstream) == "" ]]; then
    echo "Base repo already has upstream set"
else
    echo "Adding upstream to base repo"
    git remote add ${QTUS}qt5.git
fi

git fetch upstream
git checkout ${TAG}
git merge upstream/${TAG}
git push


for MODULE in ./qt*; do
    MODULE=$(echo ${MODULE} | sed 's/\.\///')
    if [[ ! -d ./${MODULE} ]]; then
        echo "${MODULE} is not a submodule. Skipping"
        continue
    else
        echo "Updating submodule ${MODULE} tag ${TAG} from upstream"

        cd ${MODULE}
            if [[ ! $(git remote -v | grep upstream) == "" ]]; then
                echo "${MODULE} already has upstream set"
            else
                echo "Adding upstream to ${MODULE}"
                git remote add upstream ${QTUS}${MODULE}.git
            fi

            git fetch upstream
            git checkout ${TAG}
            git merge upstream/${TAG}
            git push
        cd ..

    fi
done
