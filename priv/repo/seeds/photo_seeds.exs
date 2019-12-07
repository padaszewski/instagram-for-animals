alias InstagramForAnimals.Repo
alias InstagramForAnimals.Share.Photo

Repo.insert! %Photo{
  description: "Super cool photo!",
  path: "coolPhoto.jpg"
}
Repo.insert! %Photo{
  description: "Super uncool photo!",
  path: "uncoolPhoto.jpg"
}
Repo.insert! %Photo{
  description: "Semi cool semi uncool photo!",
  path: "semiCoolSemiUncoolPhoto.jpg"
}