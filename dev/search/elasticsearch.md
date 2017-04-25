Elasticsearch is a search server based on Lucene. It provides a distributed, multitenant-capable full-text search engine with a RESTful web interface and schema-free JSON documents.

Elasticsearch is a powerful open source search and analytics engine that makes data easy to explore.

## [aliyun images](https://dev.aliyun.com/detail.html?spm=5176.1972343.2.2.t3h8Li&repoId=1209)
docker pull elasticsearch

docker run --name myelasticsearch -p 9200:9200 -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -d elasticsearch

Elasticsearch is a distributed RESTful search engine built for the cloud. Features include:

Distributed and Highly Available Search Engine.
  Each index is fully sharded with a configurable number of shards.
  Each shard can have one or more replicas.
  Read / Search operations performed on any of the replica shards.
Multi Tenant with Multi Types.
  Support for more than one index.
  Support for more than one type per index.
  Index level configuration (number of shards, index storage, …).
Various set of APIs
  HTTP RESTful API
  Native Java API.
  All APIs perform automatic node operation rerouting.
Document oriented
  No need for upfront schema definition.
  Schema can be defined per type for customization of the indexing process.
Reliable, Asynchronous Write Behind for long term persistency.
(Near) Real Time Search.
Built on top of Lucene
  Each shard is a fully functional Lucene index
  All the power of Lucene easily exposed through simple configuration / plugins.
Per operation consistency
  Single document level operations are atomic, consistent, isolated and durable.
Open Source under the Apache License, version 2 (“ALv2”)

store
  index
  types
search
  _serach
  query match

Kibana is an open source data visualization plugin for Elasticsearch. It provides visualization capabilities on top of the content indexed on an Elasticsearch cluster. Users can create bar, line and scatter plots, or pie charts and maps on top of large volumes of data.

Kibana is a registered trademark of Elasticsearch BV.

## [aliyun images](https://dev.aliyun.com/detail.html?spm=5176.1972343.2.2.K2EpoL&repoId=1231)
docker pull kibana

docker run --name mykibana --link myelasticsearch:elasticsearch -p 5601:5601 -d kibana


## 注释
-e　设置环境变量
-d　后台运行

Logstash is a tool for managing events and logs.
Logstash is a tool that can be used to collect, process and forward events and log messages. Collection is accomplished via number of configurable input plugins including raw socket/packet communication, file tailing and several message bus clients. Once an input plugin has collected data it can be processed by any number of filters which modify and annotate the event data. Finally events are routed to output plugins which can forward the events to a variety of external programs including Elasticsearch, local files and several message bus implementations.

docker pull logstash


Solr (pronounced "solar") is an open source enterprise search platform, written in Java, from the Apache Lucene project. Its major features include full-text search, hit highlighting, faceted search, real-time indexing, dynamic clustering, database integration, NoSQL features[1] and rich document (e.g., Word, PDF) handling. Providing distributed search and index replication, Solr is designed for scalability and fault tolerance.[2] Solr is the second-most popular enterprise search engine after Elasticsearch.[3]
