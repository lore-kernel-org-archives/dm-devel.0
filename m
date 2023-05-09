Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 342CAC7EE22
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 01:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683594414;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Npm1uijNweTXImMDFbgJhlYq/mNN4uW+kTflNEhXqDg=;
	b=GRWoyQLP82ZAjJC4uo6o3IGKyo2gC32Y7ht3Y5Auj//sWqiCG8067X546zAeolWth6Cngv
	4/p154r9EYYfamhVEMpn+BMUjzI7K8Vzh3tqojPGyJvWA+eZFHBe5Zpw1gIYMpS3mE+rRh
	2tQ3ZdGzPJl/wuesZjESm4TtajTwvqY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-2P6GFfi2PAysRBUPZsMEVQ-1; Mon, 08 May 2023 21:06:50 -0400
X-MC-Unique: 2P6GFfi2PAysRBUPZsMEVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B320E1881425;
	Tue,  9 May 2023 01:06:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9D14A40E8B23;
	Tue,  9 May 2023 01:06:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8451019451C2;
	Tue,  9 May 2023 01:06:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B7F019452C4
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 May 2023 01:06:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 11569492B08; Tue,  9 May 2023 01:06:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.22.11.68])
 by smtp.corp.redhat.com (Postfix) with ESMTP id C18EF492C13;
 Tue,  9 May 2023 01:06:41 +0000 (UTC)
From: "J. corwin Coburn" <corwin@redhat.com>
To: dm-devel@redhat.com,
	linux-block@vger.kernel.org
Date: Mon,  8 May 2023 21:05:41 -0400
Message-Id: <20230509010545.72448-2-corwin@redhat.com>
In-Reply-To: <20230509010545.72448-1-corwin@redhat.com>
References: <20230509010545.72448-1-corwin@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/5] Add documentation for dm-vdo.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: corwin <corwin@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: corwin <corwin@redhat.com>

This adds the admin-guide documentation for dm-vdo.

vdo.rst is the guide to using dm-vdo. vdo-design is an overview of the
design of dm-vdo.

Signed-off-by: corwin <corwin@redhat.com>
---
 .../admin-guide/device-mapper/vdo-design.rst  | 390 ++++++++++++++++++
 .../admin-guide/device-mapper/vdo.rst         | 386 +++++++++++++++++
 2 files changed, 776 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/vdo-design.rst
 create mode 100644 Documentation/admin-guide/device-mapper/vdo.rst

diff --git a/Documentation/admin-guide/device-mapper/vdo-design.rst b/Documentation/admin-guide/device-mapper/vdo-design.rst
new file mode 100644
index 00000000000..aa26901feb9
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/vdo-design.rst
@@ -0,0 +1,390 @@
+================
+Design of dm-vdo
+================
+
+The dm-vdo (virtual data optimizer) target provides inline deduplication,
+compression, zero-block elimination, and thin provisioning. A dm-vdo target
+can be backed by up to 256TB of storage, and can present a logical size of
+up to 4PB. This target was originally developed at Permabit Technology
+Corp. starting in 2009. It was first released in 2013 and has been used in
+production environments ever since. It was made open-source in 2017 after
+Permabit was acquired by Red Hat. This document describes the design of
+dm-vdo. For usage, see vdo.rst in the same directory as this file.
+
+Because deduplication rates fall drastically as the block size increases, a
+vdo target has a maximum block size of 4K. However, it can achieve
+deduplication rates of 254:1, i.e. up to 254 copies of a given 4K block can
+reference a single 4K of actual storage. It can achieve compression rates
+of 14:1. All zero blocks consume no storage at all.
+
+Theory of Operation
+===================
+
+The design of dm-vdo is based on the idea that deduplication is a two-part
+problem. The first is to recognize duplicate data. The second is to avoid
+storing multiple copies of those duplicates. Therefore, dm-vdo has two main
+parts: a deduplication index (called UDS) that is used to discover
+duplicate data, and a data store with a reference counted block map that
+maps from logical block addresses to the actual storage location of the
+data.
+
+Zones and Threading
+-------------------
+
+Due to the complexity of data optimization, the number of metadata
+structures involved in a single write operation to a vdo target is larger
+than most other targets. Furthermore, because vdo must operate on small
+block sizes in order to achieve good deduplication rates, acceptable
+performance can only be achieved through parallelism. Therefore, vdo's
+design attempts to be lock-free. Most of a vdo's main data structures are
+designed to be easily divided into "zones" such that any given bio must
+only access a single zone of any zoned structure. Safety with minimal
+locking is achieved by ensuring that during normal operation, each zone is
+assigned to a specific thread, and only that thread will access the portion
+of that data structure in that zone. Associated with each thread is a work
+queue. Each bio is associated with a request object which can be added to a
+work queue when the next phase of its operation requires access to the
+structures in the zone associated with that queue. Although each structure
+may be divided into zones, this division is not reflected in the on-disk
+representation of each data structure. Therefore, the number of zones for
+each structure, and hence the number of threads, is configured each time a
+vdo target is started.
+
+The Deduplication Index
+-----------------------
+
+In order to identify duplicate data efficiently, vdo was designed to
+leverage some common characteristics of duplicate data. From empirical
+observations, we gathered two key insights. The first is that in most data
+sets with significant amounts of duplicate data, the duplicates tend to
+have temporal locality. When a duplicate appears, it is more likely that
+other duplicates will be detected, and that those duplicates will have been
+written at about the same time. This is why the index keeps records in
+temporal order. The second insight is that new data is more likely to
+duplicate recent data than it is to duplicate older data and in general,
+there are diminishing returns to looking further back in time. Therefore,
+when the index is full, it should cull its oldest records to make space for
+new ones. Another important idea behind the design of the index is that the
+ultimate goal of deduplication is to reduce storage costs. Since there is a
+trade-off between the storage saved and the resources expended to achieve
+those savings, vdo does not attempt to find every last duplicate block. It
+is sufficient to find and eliminate most of the redundancy.
+
+Each block of data is hashed to produce a 16-byte block name which serves
+as an identifier for the block. An index record consists of this block name
+paired with the presumed location of that data on the underlying storage.
+However, it is not possible to guarantee that the index is accurate. Most
+often, this occurs because it is too costly to update the index when a
+block is over-written or discarded. Doing so would require either storing
+the block name along with the blocks, which is difficult to do efficiently
+in block-based storage, or reading and rehashing each block before
+overwriting it. Inaccuracy can also result from a hash collision where two
+different blocks have the same name. In practice, this is extremely
+unlikely, but because vdo does not use a cryptographic hash, a malicious
+workload can be constructed. Because of these inaccuracies, vdo treats the
+locations in the index as hints, and reads each indicated block to verify
+that it is indeed a duplicate before sharing the existing block with a new
+one.
+
+Records are collected into groups called chapters. New records are added to
+the newest chapter, called the open chapter. This chapter is stored in a
+format optimized for adding and modifying records, and the content of the
+open chapter is not finalized until it runs out of space for new records.
+When the open chapter fills up, it is closed and a new open chapter is
+created to collect new records.
+
+Closing a chapter converts it to a different format which is optimized for
+writing. The records are written to a series of record pages based on the
+order in which they were received. This means that records with temporal
+locality should be on a small number of pages, reducing the I/O required to
+retrieve them. The chapter also compiles an index that indicates which
+record page contains any given name. This index means that a request for a
+name can determine exactly which record page may contain that record,
+without having to load the entire chapter from storage. This index uses
+only a subset of the block name as its key, so it cannot guarantee that an
+index entry refers to the desired block name. It can only guarantee that if
+there is a record for this name, it will be on the indicated page. The
+contents of a closed chapter are never altered in any way; these chapters
+are read-only structures.
+
+Once enough records have been written to fill up all the available index
+space, the oldest chapter gets removed to make space for new chapters. Any
+time a request finds a matching record in the index, that record is copied
+to the open chapter. This ensures that useful block names remain available
+in the index, while unreferenced block names are forgotten.
+
+In order to find records in older chapters, the index also maintains a
+higher level structure called the volume index, which contains entries
+mapping a block name to the chapter containing its newest record. This
+mapping is updated as records for the block name are copied or updated,
+ensuring that only the newer record for a given block name is findable.
+Older records for a block name can no longer be found even though they have
+not been deleted. Like the chapter index, the volume index uses only a
+subset of the block name as its key and can not definitively say that a
+record exists for a name. It can only say which chapter would contain the
+record if a record exists. The volume index is stored entirely in memory
+and is saved to storage only when the vdo target is shut down.
+
+From the viewpoint of a request for a particular block name, first it will
+look up the name in the volume index which will indicate either that the
+record is new, or which chapter to search. If the latter, the request looks
+up its name in the chapter index to determine if the record is new, or
+which record page to search. Finally, if not new, the request will look for
+its record on the indicated record page. This process may require up to two
+page reads per request (one for the chapter index page and one for the
+request page). However, recently accessed pages are cached so that these
+page reads can be amortized across many block name requests.
+
+The volume index and the chapter indexes are implemented using a
+memory-efficient structure called a delta index. Instead of storing the
+entire key (the block name) for each entry, the entries are sorted by name
+and only the difference between adjacent keys (the delta) is stored.
+Because we expect the hashes to be evenly distributed, the size of the
+deltas follows an exponential distribution. Because of this distribution,
+the deltas are expressed in a Huffman code to take up even less space. The
+entire sorted list of keys is called a delta list. This structure allows
+the index to use many fewer bytes per entry than a traditional hash table,
+but it is slightly more expensive to look up entries, because a request
+must read every entry in a delta list to add up the deltas in order to find
+the record it needs. The delta index reduces this lookup cost by splitting
+its key space into many sub-lists, each starting at a fixed key value, so
+that each individual list is short.
+
+The default index size can hold 64 million records, corresponding to about
+256GB. This means that the index can identify duplicate data if the
+original data was written within the last 256GB of writes. This range is
+called the deduplication window. If new writes duplicate data that is older
+than that, the index will not be able to find it because the records of the
+older data have been removed. So when writing a 200 GB file to a vdo
+target, and then immediately writing it again, the two copies will
+deduplicate perfectly. Doing the same with a 500 GB file will result in no
+deduplication, because the beginning of the file will no longer be in the
+index by the time the second write begins (assuming there is no duplication
+within the file itself).
+
+If you anticipate a data workload that will see useful deduplication beyond
+the 256GB threshold, vdo can be configured to use a larger index with a
+correspondingly larger deduplication window. (This configuration can only
+be set when the target is created, not altered later. It is important to
+consider the expected workload for a vdo target before configuring it.)
+There are two ways to do this.
+
+One way is to increase the memory size of the index, which also increases
+the amount of backing storage required. Doubling the size of the index will
+double the length of the deduplication window at the expense of doubling
+the storage size and the memory requirements.
+
+The other way is to enable sparse indexing. Sparse indexing increases the
+deduplication window by a factor of 10, at the expense of also increasing
+the storage size by a factor of 10. However with sparse indexing, the
+memory requirements do not increase; the trade-off is slightly more
+computation per request, and a slight decrease in the amount of
+deduplication detected. (For workloads with significant amounts of
+duplicate data, sparse indexing will detect 97-99% of the deduplication
+that a standard, or "dense", index will detect.)
+
+The Data Store
+--------------
+
+The data store is implemented by three main data structures, all of which
+work in concert to reduce or amortize metadata updates across as many data
+writes as possible.
+
+*The Slab Depot*
+
+Most of the vdo volume belongs to the slab depot. The depot contains a
+collection of slabs. The slabs can be up to 32GB, and are divided into
+three sections. Most of a slab consists of a linear sequence of 4K blocks.
+These blocks are used either to store data, or to hold portions of the
+block map (see below). In addition to the data blocks, each slab has a set
+of reference counters, using 1 byte for each data block. Finally each slab
+has a journal. Reference updates are written to the slab journal, which is
+written out one block at a time as each block fills. A copy of the
+reference counters are kept in memory, and are written out a block at a
+time, in oldest-dirtied-order whenever there is a need to reclaim slab
+journal space. The journal is used both to ensure that the main recovery
+journal (see below) can regularly free up space, and also to amortize the
+cost of updating individual reference blocks.
+
+Each slab is independent of every other. They are assigned to "physical
+zones" in round-robin fashion. If there are P physical zones, then slab n
+is assigned to zone n mod P.
+
+The slab depot maintains an additional small data structure, the "slab
+summary," which is used to reduce the amount of work needed to come back
+online after a crash. The slab summary maintains an entry for each slab
+indicating whether or not the slab has ever been used, whether it is clean
+(i.e. all of its reference count updates have been persisted to storage),
+and approximately how full it is. During recovery, each physical zone will
+attempt to recover at least one slab, stopping whenever it has recovered a
+slab which has some free blocks. Once each zone has some space (or has
+determined that none is available), the target can resume normal operation
+in a degraded mode. Read and write requests can be serviced, perhaps with
+degraded performance, while the remainder of the dirty slabs are recovered.
+
+*The Block Map*
+
+The block map contains the logical to physical mapping. It can be thought
+of as an array with one entry per logical address. Each entry is 5 bytes,
+36 bits of which contain the physical block number which holds the data for
+the given logical address. The other 4 bits are used to indicate the nature
+of the mapping. Of the 16 possible states, one represents a logical address
+which is unmapped (i.e. it has never been written, or has been discarded),
+one represents an uncompressed block, and the other 14 states are used to
+indicate that the mapped data is compressed, and which of the compression
+slots in the compressed block this logical address maps to (see below).
+
+In practice, the array of mapping entries is divided into "block map
+pages," each of which fits in a single 4K block. Each block map page
+consists of a header, and 812 mapping entries (812 being the number that
+fit). Each mapping page is actually a leaf of a radix tree which consists
+of block map pages at each level. There are 60 radix trees which are
+assigned to "logical zones" in round robin fashion (if there are L logical
+zones, tree n will belong to zone n mod L). At each level, the trees are
+interleaved, so logical addresses 0-811 belong to tree 0, logical addresses
+812-1623 belong to tree 1, and so on. The interleaving is maintained all
+the way up the forest. 60 was chosen as the number of trees because it is
+highly composite and hence results in an evenly distributed number of trees
+per zone for a large number of possible logical zone counts. The storage
+for the 60 tree roots is allocated at format time. All other block map
+pages are allocated out of the slabs as needed. This flexible allocation
+avoids the need to pre-allocate space for the entire set of logical
+mappings and also makes growing the logical size of a vdo easy to
+implement.
+
+In operation, the block map maintains two caches. It is prohibitive to keep
+the entire leaf level of the trees in memory, so each logical zone
+maintains its own cache of leaf pages. The size of this cache is
+configurable at target start time. The second cache is allocated at start
+time, and is large enough to hold all the non-leaf pages of the entire
+block map. This cache is populated as needed.
+
+*The Recovery Journal*
+
+The recovery journal is used to amortize updates across the block map and
+slab depot. Each write request causes an entry to be made in the journal.
+Entries are either "data remappings" or "block map remappings." For a data
+remapping, the journal records the logical address affected and its old and
+new physical mappings. For a block map remapping, the journal records the
+block map page number and the physical block allocated for it (block map
+pages are never reclaimed, so the old mapping is always 0). Each journal
+entry and the data write it represents must be stable on disk before the
+other metadata structures may be updated to reflect the operation.
+
+*Write Path*
+
+A write bio is first assigned a "data_vio," the request object which will
+operate on behalf of the bio. (A "vio," from Vdo I/O, is vdo's wrapper for
+bios; metadata operations use a vio, whereas submitted bios require the
+much larger data_vio.) There is a fixed pool of 2048 data_vios. This number
+was chosen both to bound the amount of work that is required to recover
+from a crash, and because measurements indicate that increasing it consumes
+more resources, but does not improve performance. These measurements have
+been, and should continue to be, revisited over time.
+
+Once a data_vio is assigned, the following steps are performed:
+
+1. The bio's data is checked to see if it is all zeros, and copied if not.
+2. A lock is obtained on the logical address of the bio. Because
+   deduplication involves sharing blocks, it is vital to prevent
+   simultaneous modifications of the same block.
+3. The block map tree is traversed, loading any non-leaf pages which cover
+   the logical address and are not already in memory. If any of these
+   pages, or the leaf page which covers the logical address have not been
+   allocated, and the block is not all zeros, they are allocated at this
+   time.
+4. If the block is a zero block, skip to step 9. Otherwise, an attempt is
+   made to allocate a free data block.
+5. If an allocation was obtained, the bio is acknowledged.
+6. The bio's data is hashed.
+7. The data_vio obtains or joins a "hash lock," which represents all of the
+   bios currently writing the same data.
+8. If the hash lock does not already have a data_vio acting as its agent,
+   the current one assumes that role. As the agent:
+	a) The index is queried.
+	b) If an entry is found, the indicated block is read and compared
+           to the data being written.
+	c) If the data matches, we have identified duplicate data. As many
+           of the data_vios as there are references available for that
+           block (including the agent) are shared. If there are more
+           data_vios in the hash lock than there are references available,
+           one of them becomes the new agent and continues as if there was
+           no duplicate found.
+	d) If no duplicate was found, the data being written will be
+           compressed. If the compressed size is sufficiently small, the
+           data_vio will go to the packer where it may be placed in a bin
+           along with other data_vios.
+	e) Once a bin is full, either because it is out of space, or
+           because all 14 of its slots are in use, it is written out.
+	f) Each data_vio from the bin just written is the agent of some
+           hash lock, it will now proceed to treat the just written
+           compressed block as if it were a duplicate and share it with as
+           many other data_vios in its hash lock as possible.
+	g) If the agent is not a duplicate, and it got an allocation in
+           step 3, it will write its data to the block it was allocated. If
+           the agent does not have an allocation, but another data_vio in
+           the hash lock does, that data_vio will become the agent and
+           write the data.
+	h) If the data was written, this new block is treated as a
+           duplicate and shared as much as possible with any other
+           data_vios in the hash lock.
+	i) If the agent did write new data (whether compressed or not), the
+           index is updated to reflect the new entry.
+9. If a non-zero data_vio was not shared and not able to write its data,
+   the bio is acknowledged with an out-of-space error. Otherwise, the block
+   map is queried to determine the previous mapping of the logical address.
+10. An entry is made in the recovery journal. The data_vio will block in
+    the journal until a flush has completed to ensure the data it may have
+    written is stable. It must also wait until its journal entry is stable
+    on disk. (Journal writes are all issued with the FUA bit set.)
+11. Once the recovery journal entry is stable, the data_vio makes slab
+    journal entries, an increment entry for the new mapping, and a
+    decrement entry for the old mapping, if that mapping was non-zero. For
+    correctness during recovery, the slab journal entries in any given slab
+    journal must be in the same order as the corresponding recovery journal
+    entries. Therefore, if the two entries are in different zones, they are
+    made concurrently, and if they are in the same zone, the increment is
+    always made before the decrement in order to avoid underflow. After
+    each slab journal entry is made in memory, the associated reference
+    count is also updated in memory. Each of these updates will get written
+    out as needed. (Slab journal blocks are written out either when they
+    are full, or when the recovery journal requests they do so in order to
+    allow the recovery journal to free up space; reference count blocks are
+    written out whenever the associated slab journal requests they do so in
+    order to free up slab journal space.)
+12. Once all the reference count updates are done, the block map is updated
+    and the write is complete.
+13. If the data_vio did not use its allocation, it releases the allocated
+    block. The data_vio then returns to the pool.
+
+*Read Path*
+
+Reads are much simpler than writes. After a data_vio is assigned to the
+bio, and the logical lock is obtained, the block map is queried. If the
+block is mapped, the appropriate physical block is read, and if necessary,
+decompressed.
+
+*Recovery*
+
+When a vdo is restarted after a crash, it will attempt to recover from the
+recovery journal. During the pre-resume phase of the next start, the
+recovery journal is read. The increment portion of valid entries are played
+into the block map. Next, valid entries are played, in order as required,
+into the slab journals. Finally, each physical zone attempts to replay at
+least one slab journal to reconstruct the reference counts of one slab.
+Once each zone has some free space (or has determined that it has none),
+the vdo comes back online, while the remainder of the slab journals are
+used to reconstruct the rest of the reference counts.
+
+*Read-only Rebuild*
+
+If a vdo encounters an unrecoverable error, it will enter read-only mode.
+This mode indicates that some previously acknowledged data may have been
+lost. The vdo may be instructed to rebuild as best it can in order to
+return to a writable state. However, this is never done automatically due
+to the likelihood that data has been lost. During a read-only rebuild, the
+block map is recovered from the recovery journal as before. However, the
+reference counts are not rebuilt from the slab journals. Rather, the
+reference counts are zeroed, and then the entire block map is traversed,
+and the reference counts are updated from it. While this may lose some
+data, it ensures that the block map and reference counts are consistent.
diff --git a/Documentation/admin-guide/device-mapper/vdo.rst b/Documentation/admin-guide/device-mapper/vdo.rst
new file mode 100644
index 00000000000..30e6f3d60d9
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/vdo.rst
@@ -0,0 +1,386 @@
+dm-vdo
+======
+
+The dm-vdo (virtual data optimizer) device mapper target provides
+block-level deduplication, compression, and thin provisioning. As a device
+mapper target, it can add these features to the storage stack, compatible
+with any file system. The vdo target does not protect against data
+corruption, relying instead on integrity protection of the storage below
+it. It is strongly recommended that lvm be used to manage vdo volumes. See
+lvmvdo(7).
+
+Userspace component
+===================
+
+Formatting a vdo volume requires the use of the 'vdoformat' tool, available
+at:
+
+https://github.com/dm-vdo/vdo/
+
+In most cases, a vdo target will recover from a crash automatically the
+next time it is started. In cases where it encountered an unrecoverable
+error (either during normal operation or crash recovery) the target will
+enter or come up in read-only mode. Because read-only mode is indicative of
+data-loss, a positive action must be taken to bring vdo out of read-only
+mode. The 'vdoforcerebuild' tool, available from the same repo, is used to
+prepare a read-only vdo to exit read-only mode. After running this tool,
+the vdo target will rebuild its metadata the next time it is
+started. Although some data may be lost, the rebuilt vdo's metadata will be
+internally consistent and the target will be writable again.
+
+The repo also contains additional userspace tools which can be used to
+inspect a vdo target's on-disk metadata. Fortunately, these tools are
+rarely needed except by dm-vdo developers.
+
+Target interface
+================
+
+Table line
+----------
+
+::
+
+	<offset> <logical device size> vdo V4 <storage device>
+	<storage device size> <minimum I/O size> <block map cache size>
+	<block map era length> [optional arguments]
+
+
+Required parameters:
+
+	offset:
+		The offset, in sectors, at which the vdo volume's logical
+		space begins.
+
+	logical device size:
+		The size of the device which the vdo volume will service,
+		in sectors. Must match the current logical size of the vdo
+		volume.
+
+	storage device:
+		The device holding the vdo volume's data and metadata.
+
+	storage device size:
+		The size of the device holding the vdo volume, as a number
+		of 4096-byte blocks. Must match the current size of the vdo
+		volume.
+
+	minimum I/O size:
+		The minimum I/O size for this vdo volume to accept, in
+		bytes. Valid values are 512 or 4096. The recommended value
+		is 4096.
+
+	block map cache size:
+		The size of the block map cache, as a number of 4096-byte
+		blocks. The minimum and recommended value is 32768 blocks.
+		If the logical thread count is non-zero, the cache size
+		must be at least 4096 blocks per logical thread.
+
+	block map era length:
+		The speed with which the block map cache writes out
+		modified block map pages. A smaller era length is likely to
+		reduce the amount of time spent rebuilding, at the cost of
+		increased block map writes during normal operation. The
+		maximum and recommended value is 16380; the minimum value
+		is 1.
+
+Optional parameters:
+--------------------
+Some or all of these parameters may be specified as <key> <value> pairs.
+
+Thread related parameters:
+
+Different categories of work are assigned to separate thread groups, and
+the number of threads in each group can be configured separately.
+
+If <hash>, <logical>, and <physical> are all set to 0, the work handled by
+all three thread types will be handled by a single thread. If any of these
+values are non-zero, all of them must be non-zero.
+
+	ack:
+		The number of threads used to complete bios. Since
+		completing a bio calls an arbitrary completion function
+		outside the vdo volume, threads of this type allow the vdo
+		volume to continue processing requests even when bio
+		completion is slow. The default is 1.
+
+	bio:
+		The number of threads used to issue bios to the underlying
+		storage. Threads of this type allow the vdo volume to
+		continue processing requests even when bio submission is
+		slow. The default is 4.
+
+	bioRotationInterval:
+		The number of bios to enqueue on each bio thread before
+		switching to the next thread. The value must be greater
+		than 0 and not more than 1024; the default is 64.
+
+	cpu:
+		The number of threads used to do CPU-intensive work, such
+		as hashing and compression. The default is 1.
+
+	hash:
+		The number of threads used to manage data comparisons for
+		deduplication based on the hash value of data blocks. The
+		default is 0.
+
+	logical:
+		The number of threads used to manage caching and locking
+		based on the logical address of incoming bios. The default
+		is 0; the maximum is 60.
+
+	physical:
+		The number of threads used to manage administration of the
+		underlying storage device. At format time, a slab size for
+		the vdo is chosen; the vdo storage device must be large
+		enough to have at least 1 slab per physical thread. The
+		default is 0; the maximum is 16.
+
+Miscellaneous parameters:
+
+	maxDiscard:
+		The maximum size of discard bio accepted, in 4096-byte
+		blocks. I/O requests to a vdo volume are normally split
+		into 4096-byte blocks, and processed up to 2048 at a time.
+		However, discard requests to a vdo volume can be
+		automatically split to a larger size, up to <maxDiscard>
+		4096-byte blocks in a single bio, and are limited to 1500
+		at a time. Increasing this value may provide better overall
+		performance, at the cost of increased latency for the
+		individual discard requests. The default and minimum is 1;
+		the maximum is UINT_MAX / 4096.
+
+	deduplication:
+		Whether deduplication is enabled. The default is 'on'; the
+		acceptable values are 'on' and 'off'.
+
+	compression:
+		Whether compression is enabled. The default is 'off'; the
+		acceptable values are 'on' and 'off'.
+		
+Device modification
+-------------------
+
+A modified table may be loaded into a running, non-suspended vdo volume.
+The modifications will take effect when the device is next resumed. The
+modifiable parameters are <logical device size>, <physical device size>,
+<maxDiscard>, <compression>, and <deduplication>.
+
+If the logical device size or physical device size are changed, upon
+successful resume vdo will store the new values and require them on future
+startups. These two parameters may not be decreased. The logical device
+size may not exceed 4 PB. The physical device size must increase by at
+least 32832 4096-byte blocks if at all, and must not exceed the size of the
+underlying storage device. Additionally, when formatting the vdo device, a
+slab size is chosen: the physical device size may never increase above the
+size which provides 8192 slabs, and each increase must be large enough to
+add at least one new slab.
+
+Examples:
+
+Start a previously-formatted vdo volume with 1 GB logical space and 1 GB
+physical space, storing to /dev/dm-1 which has more than 1 GB of space.
+
+::
+
+	dmsetup create vdo0 --table \
+	"0 2097152 vdo V4 /dev/dm-1 262144 4096 32768 16380"
+
+Grow the logical size to 4 GB.
+
+::
+
+	dmsetup reload vdo0 --table \
+	"0 8388608 vdo V4 /dev/dm-1 262144 4096 32768 16380"
+	dmsetup resume vdo0
+
+Grow the physical size to 2 GB.
+
+::
+
+	dmsetup reload vdo0 --table \
+	"0 8388608 vdo V4 /dev/dm-1 524288 4096 32768 16380"
+	dmsetup resume vdo0
+
+Grow the physical size by 1 GB more and increase max discard sectors.
+
+::
+
+	dmsetup reload vdo0 --table \
+	"0 10485760 vdo V4 /dev/dm-1 786432 4096 32768 16380 maxDiscard 8"
+	dmsetup resume vdo0
+
+Stop the vdo volume.
+
+::
+
+	dmsetup remove vdo0
+
+Start the vdo volume again. Note that the logical and physical device sizes
+must still match, but other parameters can change.
+
+::
+
+	dmsetup create vdo1 --table \
+	"0 10485760 vdo V4 /dev/dm-1 786432 512 65550 5000 hash 1 logical 3 physical 2"
+
+Messages
+--------
+All vdo devices accept messages in the form:
+
+::
+        dmsetup message <target-name> 0 <message-name> <message-parameters>
+
+The messages are:
+
+        stats:
+		Outputs the current view of the vdo statistics. Mostly used
+		by the vdostats userspace program to interpret the output
+		buffer.
+
+        dump:
+		Dumps many internal structures to the system log. This is
+		not always safe to run, so it should only be used to debug
+		a hung vdo. Optional parameters to specify structures to
+		dump are:
+
+			viopool: The pool of I/O requests incoming bios
+			pools: A synonym of 'viopool'
+			vdo: Most of the structures managing on-disk data 
+			queues: Basic information about each vdo thread
+			threads: A synonym of 'queues'
+			default: Equivalent to 'queues vdo' 
+			all: All of the above.
+        
+        dump-on-shutdown:
+		Perform a default dump next time vdo shuts down.
+
+
+Status
+------
+
+::
+
+    <device> <operating mode> <in recovery> <index state>
+    <compression state> <physical blocks used> <total physical blocks>
+
+	device:
+		The name of the vdo volume.
+
+	operating mode:
+		The current operating mode of the vdo volume; values may be
+		'normal', 'recovering' (the volume has detected an issue
+		with its metadata and is attempting to repair itself), and
+		'read-only' (an error has occurred that forces the vdo
+		volume to only support read operations and not writes).
+
+	in recovery:
+		Whether the vdo volume is currently in recovery mode;
+		values may be 'recovering' or '-' which indicates not
+		recovering.
+
+	index state:
+		The current state of the deduplication index in the vdo
+		volume; values may be 'closed', 'closing', 'error',
+		'offline', 'online', 'opening', and 'unknown'.
+
+	compression state:
+		The current state of compression in the vdo volume; values
+		may be 'offline' and 'online'.
+
+	used physical blocks:
+		The number of physical blocks in use by the vdo volume.
+
+	total physical blocks:
+		The total number of physical blocks the vdo volume may use;
+		the difference between this value and the
+		<used physical blocks> is the number of blocks the vdo
+		volume has left before being full.
+
+Memory Requirements
+===================
+
+A vdo target requires a fixed 38 MB of RAM along with the following amounts
+that scale with the target:
+
+- 1.15 MB of RAM for each 1 MB of configured block map cache size. The
+  block map cache requires a minimum of 150 MB.
+- 1.6 MB of RAM for each 1 TB of logical space.
+- 268 MB of RAM for each 1 TB of physical storage managed by the volume.
+
+The deduplication index requires additional memory which scales with the
+size of the deduplication window. For dense indexes, the index requires 1
+GB of RAM per 1 TB of window. For sparse indexes, the index requires 1 GB
+of RAM per 10 TB of window. The index configuration is set when the target
+is formatted and may not be modified.
+
+Run-time Usage
+==============
+
+When using dm-vdo, it is important to be aware of the ways in which its
+behavior differs from other storage targets.
+
+- There is no guarantee that over-writes of existing blocks will succeed.
+  Because the underlying storage may be multiply referenced, over-writing
+  an existing block generally requires a vdo to have a free block
+  available.
+  
+- When blocks are no longer in use, sending a discard request for those
+  blocks lets the vdo release references for those blocks. If the vdo is
+  thinly provisioned, discarding unused blocks is essential to prevent the
+  target from running out of space. However, due to the sharing of
+  duplicate blocks, no discard request for any given logical block is
+  guaranteed to reclaim space.
+
+- Assuming the underlying storage properly implements flush requests, vdo
+  is resilient against crashes, however, unflushed writes may or may not
+  persist after a crash.
+
+- Each write to a vdo target entails a significant amount of processing.
+  However, much of the work is paralellizable. Therefore, vdo targets
+  achieve better throughput at higher I/O depths, and can support up 2048
+  requests in parallel.
+
+Tuning
+======
+
+The vdo device has many options, and it can be difficult to make optimal
+choices without perfect knowledge of the workload. Additionally, most
+configuration options must be set when a vdo target is started, and cannot
+be changed without shutting it down completely; the configuration cannot be
+changed while the target is active. Ideally, tuning with simulated
+workloads should be performed before deploying vdo in production
+environments.
+
+The most important value to adjust is the block map cache size. In order to
+service a request for any logical address, a vdo must load the portion of
+the block map which holds the relevant mapping. These mappings are cached.
+Performance will suffer when the working set does not fit in the cache. By
+default, a vdo allocates 128 MB of metadata cache in RAM to support
+efficient access to 100 GB of logical space at a time. It should be scaled
+up proportionally for larger working sets.
+
+The logical and physical thread counts should also be adjusted. A logical
+thread controls a disjoint section of the block map, so additional logical
+threads increase parallelism and can increase throughput. Physical threads
+control a disjoint section of the data blocks, so additional physical
+threads can also increase throughput. However, excess threads can waste
+resources and increase contention.
+
+Bio submission threads control the parallelism involved in sending I/O to
+the underlying storage; fewer threads mean there is more opportunity to
+reorder I/O requests for performance benefit, but also that each I/O
+request has to wait longer before being submitted.
+
+Bio acknowledgment threads are used for finishing I/O requests. This is
+done on dedicated threads since the amount of work required to execute a
+bio's callback can not be controlled by the vdo itself. Usually one thread
+is sufficient but additional threads may be beneficial, particularly when
+bios have CPU-heavy callbacks.
+
+CPU threads are used for hashing and for compression; in workloads with
+compression enabled, more threads may result in higher throughput.
+
+Hash threads are used to sort active requests by hash and determine whether
+they should deduplicate; the most CPU intensive actions done by these
+threads are comparison of 4096-byte data blocks. In most cases, a single
+hash thread is sufficient.
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

