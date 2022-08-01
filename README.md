# experimental_serialize_models
Mejorar la construcción de estructuras para iOS

La intención de esta librería es poder facilitar la decodificación de json a structurs.

````Swift

struct MockModels: Serialize {
    @SerializeName("names_group")
    var namesGroup: [MockModel]?
    @SerializeName("date")
    var date: Date?
    @SerializeTransform("Simple_date", TransformOf.toSimpleDate())
    var simpleDate: Date?
}

struct MockModel: Serialize {
    @SerializeName("name")
    var name: String?
    
    @SerializeName("last_Name")
    var lastName: String?
    
    @SerializeName("Age")
    var age: Int?
}

````

Output

````Ruby

{
  "date" : 681023634.65059698,
  "names_group" : [
    {
      "name" : "Francisco",
      "Age" : 28,
      "last_Name" : "Saldivar Rubbio"
    },
    {
      "name" : "Javier",
      "Age" : 28,
      "last_Name" : "Saldivar Rubbio"
    },
    {
      "name" : "Francisco Javier",
      "Age" : 28,
      "last_Name" : "Saldivar Rubbio"
    }
  ],
  "Simple_date" : "01\/08\/2022"
}

````
