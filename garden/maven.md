# ok so how does maven work...

There's a plugin architecture. This seems weird at first ("you need a plugin to compile java? i thought maven was the java build tool") but I think it does make sense with the model

## build lifecycle

there are three builtin lifecycles - default, clean, site

each lifecycle consists of a number of phases https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Lifecycle_Reference . when you execute a phase, you also execute all the phases before it.

for example the `initialize` phase is responsible for creating the target directory. this must happen before the `compile` phase, which populates that directory, and the `test` phase, which requires the project be compiled first. so when you run `mvn test` it will first initialize, then compile, then test.

another simpler example is, say, the `site` lifecycle. first you prepare to generate the site, then you generate the site, then you deploy the site.

ANNOYING: there is no way to hook more phases onto an existing build lifecycle. maybe the reduced complexity cost is worth it

## goals

what does it mean to "run a phase"? when maven "runs the `test` phase" what does it actually *do*?

the answer is that phases have a list of *goals* bound to them. running a phase means executing all of the goals.

there are a handful of ways to assign goals to phases:

* explicitly, in a `<phases>` block in your pom
* by adding a plugin - plugins can bind their own goals to a phase (?)
  * or maybe the `<executions>` tag is relevant here
* by setting a `<packaging>` type, which sets up a predefined set of goals from a handful of plugins https://maven.apache.org/ref/3.9.8/maven-core/default-bindings.html
  * all projects that don't otherwise set a packaging type default to `jar`. which is why maven can build simple java proejcts with little other configuration.
  
### the command line

typical maven invocation: `mvn clean package`

* first runs `clean` from the `clean` lifecycle
* then runs `package` from the `default` lifecycle

you can also mix in goals (which have the form `plugin-id:goal-name` i think). uhhh.

## the pom

The pom: https://maven.apache.org/guides/introduction/introduction-to-the-pom.html

required things are `modelVersion` (which is `4.0.0`, other values are reserved for furuter expansion/back-compat), and the famous "maven coordinates", groupId artifactId and version.