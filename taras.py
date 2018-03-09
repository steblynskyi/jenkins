  ota-expedia-reservation-api-dev:
    Container ID:   docker://9d572b75afafa60cc970c211b69d024c72031b6122da4917801a36a0eb6f125e
    Image:          innroad-docker.jfrog.io/ota-expedia-reservationapi:dfd671
    Image ID:       docker-pullable://innroad-docker.jfrog.io/ota-expedia-reservationapi@sha256:046188cb23b67d30665b153a953268fb33eb19bd0cc97d487d40312b8570472d
    Port:           8080/TCP
    State:          Running
      Started:      Thu, 22 Feb 2018 11:12:15 -0500
    Ready:          True
    Restart Count:  0
    Environment:
      AWS_ACCESS_KEY_ID:             AKIAIT4XBBEQHTZCBXHQ
      AWS_SECRET_ACCESS_KEY:         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
      AWS_DEFAULT_REGION:            us-east-1
      INN_OTA_ID:                    expedia
      INN_LAMBDA_ARN:                arn:aws:lambda:us-east-1:960031658638:function:ota-expedia-reservationadapter
      INN_EXP_PING_USERNAME:         Expedia$Prod
      INN_EXP_PING_PASS:             Expedi@123
      INN_EXP_RSV_USERNAME:          InnRoad
      INN_EXP_RSV_PASS:              exp8dia4dc
      INN_TOKEN_API_URL:             https://payment-token.inrd.io/api/v1/token
      INN_S3_BUCKET:                 ir-dev.us-standard.ota.message
      INN_S3_CIPHER_BUCKET:          ir-dev.us-standard.ota.encrypted-message
      INN_SNS_TOPIC:                 arn:aws:sns:us-east-1:960031658638:ota-reservation-not-processed
      INN_KMS_ID:                    f559d7d5-8219-4d54-ac92-3ffab3b496db
      INN_CIPHER_ACCESS_KEY_ID:      AKIAIT4XBBEQHTZCBXHQ
      INN_CIPHER_SECRET_ACCESS_KEY:  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
      INN_CIPHER_DEFAULT_REGION:     us-east-1
      INN_LOG_LEVEL:                 DEBUG
      INN_LOG_FLUENT_HOST:           localhost
      INN_LOG_FLUENT_PORT:           24224
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-n26bk (ro)
Conditions:
  Type           Status
  Initialized    True 
  Ready          True 
  PodScheduled   True 
Volumes:
  default-token-n26bk:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-n26bk
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.alpha.kubernetes.io/notReady:NoExecute for 300s
                 node.alpha.kubernetes.io/unreachable:NoExecute for 300s
Events:          <none>
  onditions:
  Type           Status
  Initialized    True 
  Ready          True 
  PodScheduled   True 
Volumes:
  default-token-n26bk: