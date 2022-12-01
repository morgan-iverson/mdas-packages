For clarification, To create the package I would create a folder containing profile.d setup.d, Docker file and build.sh (https://github.com/vmware-tanzu-labs/educates-extension-packages/tree/main/packages/tce-0.12) . Then modify the publish-packages.yaml (which is a github workflow and will update automatically on push to main) to deploy them to GHCR (using imgpkg from Carvel)

**Note:** profile.d is process AFTER setup.d when building packages unlike Workshop repo profile.d -setup.d processing order (as of 10/27/2022)

## Recommended Workfow
1. Set Up Package Files
    1. Create folder with desired package name
    2. Create structure 
        ```
        cd package-name
        mkdir setup.d profile.d 
        touch setup.d/setup.sh profile.d post-setup.sh
        touch Dockerfile build.sh
        ```

        Dockerfile - instructions on building package image
        build.sh - Script to run on package creation (in container)
        setup.d & profile.d - Script files to run on workshop start up

    3. Complete Dockerfile

        **Dockerfile**

        ```
        FROM fedora:37

        COPY . /opt/packages/package-name/

        WORKDIR /opt/packages/package-name

        RUN ./build.sh
        ```

    4. When complete build your Docker Image and Run the container to make sure files have been copied correctly
        ```
        cd packages/package-name
        docker build -t package-name .
        docker run -it package-name
        ```

2. Test scripts in actual workshop
    1. Add scripts to workshop `workshop/profile.d` & `workshop/setup.d` folders to test scripts 
        **Note:** `workshop/profile.d` processed BEFORE `workshop/setup.d`
    2. Run a workshop in a separate terminal/editor & Test that scripts work as expected
        ```
        make
        make open-workshop
        ```


3. When scripts run correctly in workshop terminal and Dockerfile is configured correctly move your scripts to `package-name/profile.d` & `package-name/setup.d` keeping in mind the following notes:

    * `package-name/profile.d` processes AFTER `package-name/setup.d` during package creation (as of 10/27/2022)
    * Environment variables defined in `package-name/profile.d` (not `package-name/setup.d`)will exist in the workshop terminal (include path)
    * Files in `package-name/setup.d` MUST be made **executable** before publishing (**Note:** They will not run in workshop otherwise)
        ```
        cd package-name/setup.d; chmod +x $(find . -type f -name "*.sh");
        ```
    * Files in `package-name/profild.d` MUST be made **readable** before publishing (**Note:** They will not run in workshop otherwise)
        ```
        cd package-name/profile.d; chmod +r $(find . -type f -name "*.sh");
        ```

        - Check if file has read permissions: `test -r script.sh && echo $?` (1=false, 0=true)
        - Check if file has execute permissions: `test -x script.sh && echo $?` (1=false, 0=true)

        - Remove Permisson `chmod -rx script.sh`

        **Note:** Educates runs `test -r *.sh` or `[ -r *.sh]` (or -x) on specific script files to check if they are readable or executeable befor sourceing or executing.

    * Files in `package-name/setup.d` MUST have `#!/bin/bash` at top of file
    * All scripts should start with the following lines (after `#!/bin/bash` if applicable)
        ```
        set -x
        set -eo pipefail
        ```
    * To reference the current directory decrat a local environment variable with value `$(cd "$(dirname $BASH_SOURCE)/.."; pwd)`

        For example,
        ```
        PROJECT_DIR=$(cd "$(dirname $BASH_SOURCE)/.."; pwd) # /opt/packages/package-name
        mkdir -p $PROJECT_DIR/dir-in-workshop
        ```

7. When packages are ready publish them

    In this repo there exists a github action in `.github/workflows/publish-packages.yaml`. This automatically publishes packages to your GitHub Container registry.

    1. Open `.github/workflows/publish-packages.yaml` in editor
    2. Add a Job to publish your package called `package-name` by copying the following into the publish-packages.yaml under `jobs:`
        
        **Note:** Replace every instance of 'package-name' with your package name.

        ```
        publish-package-name:
        name: Publish package-name
        runs-on: ubuntu-20.04

        steps:
        - name: Check out the repo
            uses: actions/checkout@v2

        - name: Install imgpkg
            shell: bash
            run: |
            wget -nv -O- https://github.com/vmware-tanzu/carvel-imgpkg/releases/download/v0.28.0/imgpkg-linux-amd64 > /tmp/imgpkg
            chmod 755 /tmp/imgpkg

        - name: Calculate variables
            run: |
            echo "REPOSITORY_SHA7=${GITHUB_SHA::7}" >>${GITHUB_ENV}

        - name: Build and publish package-name
            shell: bash
            run: |
            packages/package-name/build.sh
            /tmp/imgpkg push -i ghcr.io/${{github.repository}}/package-name:sha-${REPOSITORY_SHA7} -f packages/postgres-12 --registry-username=${{github.actor}} --registry-password=${{secrets.GITHUB_TOKEN}}
            /tmp/imgpkg push -i ghcr.io/${{github.repository}}/package-name:latest -f packages/package-name --registry-username=${{github.actor}} --registry-password=${{secrets.GITHUB_TOKEN}}
        ```

    3. Add, Commit & Push
    
8. See Published Packages & Add to Workshop

    1. Open your repository in browser and navigate to teh `Actions` tab. Here you can see your package being build. Specifically, the output of `build.sh`.
    2. Once build you can add to your workshop by adding it to `lab-labName/resources/workshop.yaml` under  `spec.workshop.packages`. 
    
        For example,

        **lab-mdas-base/resources/workshop.yaml**

        ```
        apiVersion: training.educates.dev/v1beta1
        kind: Workshop
        metadata:
            name: lab-mdas-base
        spec:
            ...
            workshop:
                image: jdk17-environment:*
                ...
                packages:
                - name: postgres-12
                files:
                - image:
                    url: ghcr.io/morgan-iverson/mdas-packages/postgres-12:latest
                ...
        ```
        
        **Note:** In this case the package is called `postgres-12` and was created in the `morgan-iverson/mdas-packages` repository and is stored at `ghcr.io/morgan-iverson/mdas-packages/postgres-12:latest`

        **Note:** Be sure to use the `:latest` tag so you work have to update tag in the `wokrshop.yaml` every time you modify the package files in the package rep (this repo)

6. Now you can test with your workshop! 
    * Find your files in `/opt/packages` in the workshop terminal (in browser)
    * Make sure your PATH is set with `echo $PATH`
    * Check log files in workshop terminal at `~/.local/share/workshop/` (**Note:** Failed processes will have extension `.failed` and you can see log in corresponding log file)

If your workshop is stuck on 'Waiting for deployment...' you will need to find the logs for the workshop
1. Open the terminal on your computer
2. Find your workshop namespace
    ```
    kubectl get 
    ```
    
    **Note:** Your workshop name space will end with `-w##` NOT `w##-s###`
3. Save your namespace
    ```
    ns=lab-my-lab-w01
    ```
4. Find your workshop pod
    ```
    kubectl get pod -n $ns
    ```
5. Save pod
    ```
    pod=lab-mdas-base-w02-s001-#####-####
    ```
6. Watch pod logs live
    ```
    kubectl logs $pod -n $ns --follow
    ```

    **Note:** Use CNTRL + C to exit log
7. Find what is slowing down or stopping your deployment

<hr>

## How to build image
1. cd into package folder
    ```
    cd packages/package-name
    ```
2. Build with docker
    ```
    docker build -t package .
    ```

## How to test package image creation 
Make sure all necessary files have been copied in the correct locations. Files that exist in your image will exist in the `/opt/package/package-name` folder in your workshop.
1. Run Image as Container 
    ```
    <!-- docker run -it --name gemfire $REGISTRY/gemfire-image:latest  -->
    ```

## Add environment variables
In `setup.d` you can append export statments or aliases to `$HOME/.bash_profile` 

**setup.d/setup.sh**

```
echo "export ENV_VAR=value" >> .bash_profile
echo "alias psql='kubectl exec -it $POD_NAME -- psql'" >> .bash_profile
```

