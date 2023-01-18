# Jurassic Park

```
Author: Aaron Jacobs
Email: aaron8153@gmail.com
Phone: 314.749.2604
Git Repository: https://github.com/aaron8153/JurassicParkVegasVelociraptors
```

## Vegas Velociraptors

This is a code test for PrizePicks that implements a simple system of Species, Dinosaurs, and Cages.

###The Problem

It's 1993 and you're the lead software developer for the new Jurassic Park! Park
operations needs a system to keep track of the different cages around the park and the
different dinosaurs in each one. You'll need to develop a JSON formatted RESTful API
to allow the builders to create new cages. It will also allow doctors and scientists the
ability to edit/retrieve the statuses of dinosaurs and cages.

###Setup
Ruby version: `3.1.3p185`

Rails Version: `7`

Database: `postgres v13`

Initialize the database:
`rails db:migrate`

Seed the database:
`rails db:seed`

###API Endpoints
####Species
```
v1_species_index GET    /v1/species(.:format)             v1/species#index
                 POST   /v1/species(.:format)             v1/species#create
  new_v1_species GET    /v1/species/new(.:format)         v1/species#new
 edit_v1_species GET    /v1/species/:id/edit(.:format)    v1/species#edit
      v1_species GET    /v1/species/:id(.:format)         v1/species#show
                 PATCH  /v1/species/:id(.:format)         v1/species#update
                 PUT    /v1/species/:id(.:format)         v1/species#update
                 DELETE /v1/species/:id(.:format)         v1/species#destroy
```

####Dinosaur
```
    v1_dinosaurs GET    /v1/dinosaurs(.:format)           v1/dinosaurs#index
                 POST   /v1/dinosaurs(.:format)           v1/dinosaurs#create
 new_v1_dinosaur GET    /v1/dinosaurs/new(.:format)       v1/dinosaurs#new
edit_v1_dinosaur GET    /v1/dinosaurs/:id/edit(.:format)  v1/dinosaurs#edit
     v1_dinosaur GET    /v1/dinosaurs/:id(.:format)       v1/dinosaurs#show
                 PATCH  /v1/dinosaurs/:id(.:format)       v1/dinosaurs#update
                 PUT    /v1/dinosaurs/:id(.:format)       v1/dinosaurs#update
                 DELETE /v1/dinosaurs/:id(.:format)       v1/dinosaurs#destroy

```

####Cage
```
    v1_cages GET    /v1/cages(.:format)                   v1/cages#index
             POST   /v1/cages(.:format)                   v1/cages#create
 new_v1_cage GET    /v1/cages/new(.:format)               v1/cages#new
edit_v1_cage GET    /v1/cages/:id/edit(.:format)          v1/cages#edit
     v1_cage GET    /v1/cages/:id(.:format)               v1/cages#show
             PATCH  /v1/cages/:id(.:format)               v1/cages#update
             PUT    /v1/cages/:id(.:format)               v1/cages#update
             DELETE /v1/cages/:id(.:format)               v1/cages#destroy
```

###Filters

Cages are filterable on `power_status`. Dinosaurs are filterable on `species_id`. Species are filterable on `carnivorous`.

###Notes

All tasks have been completed, bonus tasks included.

Tests are written for all models to satisfy each requirement.

Tests are written for all controllers excluding a few routes which are stubbed.

If I had more time, I would have added routes and controller actions to utilize the Cage.add_dinosaur() method.
I also wanted to add some dinosaur battles to play over under with.
