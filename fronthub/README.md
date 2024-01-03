# Fronthub

An example structure of `input-port.json`:
```json
{
  "zones": [
    {
      "domain": "example.guru",
      "endpoints": [
        {
          "url": "app.example.guru/*",
          "cluster": "cluster-id-on-idp"
        }
      ]
    }
  ]
}

```
