alias InstagramForAnimals.Repo
alias InstagramForAnimals.Share.Comment

Repo.insert! %Comment{
  content: "Indeed a super cool photo!",
  photo_id: 1
}
Repo.insert! %Comment{
  content: "Not so cool...",
  photo_id: 2
}
Repo.insert! %Comment{
  content: "Idk what to think 'bout it.",
  photo_id: 3
}