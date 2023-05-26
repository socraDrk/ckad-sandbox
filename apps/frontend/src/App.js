import React, { useState } from "react";
import "./App.css";
import {
  Button,
  Flex,
  Heading,
  TextField,
  View,
} from "@aws-amplify/ui-react";

function App () {
  const [data, setData] = useState(null);

  async function createNote(event) {
    event.preventDefault();
    const form = new FormData(event.target);
    const datas = {
      prompt: form.get("prompt"),
    };
    fetch('http://backend-microservice.backend:8000/prompt/', {
       method: 'POST',
       headers: {
         'Content-Type': 'application/json',
       },
       body: JSON.stringify(datas),
     })
       .then((res) => res.json())
       .then((result) => setData(result))
       .catch((err) => console.log('error'))
    event.target.reset();
  }

  return (
    <View className="App">
      <Heading level={1}>My Prompt Generator App</Heading>
      <View as="form" margin="3rem 0" onSubmit={createNote}>
        <Flex direction="row" justifyContent="center">
          <TextField
            name="prompt"
            placeholder="Prompt"
            label="Prompt"
            labelHidden
            variation="quiet"
            required
          />
          <Button type="submit" variation="primary">
            Submit Prompt
          </Button>
        </Flex>
      </View>
      <div>
       {data ? <pre>{data.response}</pre> : '...'}
     </div>
    </View>
  );
};

export default App;