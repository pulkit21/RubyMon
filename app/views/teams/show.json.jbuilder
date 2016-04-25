json.extract! @team, :id, :name
json.user do
  json.id @team.user.id
  json.name @team.user.name
  json.uid @team.user.uid
  json.email @team.user.email
  json.image @team.user.image
end
