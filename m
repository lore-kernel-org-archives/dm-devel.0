Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2333EB64DA
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jul 2023 15:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689695518;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=g4gPX0DDSmTw3XchYl/F3DjxFQ/9WkyNyLuuDAsLK1Y=;
	b=jG+zA61NUWS9isy33jOfbiC1nsIc4EYFFAtJgnX0VBZtN9IXypTdf1+zKZTtqvnyUTvpia
	ZjI7kwhUjqsZmUmzBg13bjMUGBl21j1kWz37PO1meEIjvRJ4v5L4kz1krtTUYtS44DFbRb
	zQaTBoxHFsRnFcxyP6EhhUdWAm8O/vo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-ub6ARZIdPhuX4sQB89muOw-1; Tue, 18 Jul 2023 11:51:54 -0400
X-MC-Unique: ub6ARZIdPhuX4sQB89muOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03899936D32;
	Tue, 18 Jul 2023 15:51:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7352A4087C62;
	Tue, 18 Jul 2023 15:51:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2FC40194658F;
	Tue, 18 Jul 2023 15:51:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6BFE9194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 18 Jul 2023 15:51:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 49EC6200C0C4; Tue, 18 Jul 2023 15:51:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 412B2200BA8B
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 15:51:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85E42800B35
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 15:51:44 +0000 (UTC)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com
 [209.85.217.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-JmZyCe3iMxa0Z0NZbYtXwQ-1; Tue, 18 Jul 2023 11:51:27 -0400
X-MC-Unique: JmZyCe3iMxa0Z0NZbYtXwQ-1
Received: by mail-vs1-f53.google.com with SMTP id
 ada2fe7eead31-440afc96271so1995280137.3
 for <dm-devel@redhat.com>; Tue, 18 Jul 2023 08:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689695477; x=1692287477;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=PEsrKwQ0yBQPJi1sFyHx3Lu43C4VlNpiatAnbsXOgTk=;
 b=Odu80OgNyPiylmNc4eJbUy0TeD6nbzzAEHNrznX45l9f+U0021KKc6xx0limMTMI7a
 2WyVWf1q6JX7DYpKOBt19j6P5nhianfoc0EbEVAiaX/IlKfuKzMwUqVfP+d5v6AYHq5E
 ++MfonmpkFnuDokROj+uLfymbNNVVKBcz9JoyXtujlQNYSDt2CcED9F+CkuL+5A552WT
 9nA/Wj1aP8ZFzhZ507zyAhHLSZUZkLJ0BSEpneH9kwKJQwFOfhsACFHNeOlA3Ior/M+r
 026uso/dj6IcxvQXscl02pmpkpdonbfhaaTZsuPpsWngzKglJAu01NSxFxhO9kF7++JW
 /TkQ==
X-Gm-Message-State: ABy/qLa6vAF8DR0USlMB3C36zX1uQbIUXd2TZD/EpJ834caRmpxu+CW2
 EgYut3QE9mjZtRoINWzJWuAEcFwcBRpVNuWJfKNWEqoI5WBWtZN/UNjx/sAqObV9FJHu0+TGGuH
 IaJXcVxkmHi9Wy4NAfFb7Y92X4usH7OqvecXijAV4zR9qzRsRnmsiO42YOkKFp/PLl8A4r8PQ
X-Google-Smtp-Source: APBJJlFhNEO6a6HZw8k5gmiU+d2l9Dfd3aB0eRVl9hv59Ymtkls9VcNrmss+29PjjXtY47fe8dIMjw==
X-Received: by 2002:a67:ba0d:0:b0:443:3d62:77a with SMTP id
 l13-20020a67ba0d000000b004433d62077amr8529253vsn.1.1689695477373; 
 Tue, 18 Jul 2023 08:51:17 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 e13-20020a0cf74d000000b0062626bd3683sm815010qvo.59.2023.07.18.08.51.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Jul 2023 08:51:16 -0700 (PDT)
Date: Tue, 18 Jul 2023 11:51:15 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com, linux-block@vger.kernel.org, vdo-devel@redhat.com
Message-ID: <ZLa086NuWiMkJKJE@redhat.com>
References: <20230523214539.226387-1-corwin@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20230523214539.226387-1-corwin@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2 00/39] Add the dm-vdo deduplication and
 compression device mapper target.
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
Cc: tj@kernel.org, ebiggers@kernel.org, msakai@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[Top-posting to provide general update and historic context]

Hi all,

Corwin has decided to leave Red Hat, I want to thank Corwin for his
efforts in developing and/or leading the development of changes to the
VDO codebase (including those that were a prereq for VDO's upstream
submission).

Matt Sakai (cc'd) and I will be meeting regularly to continue the work
of driving VDO changes needed for the code to be what I consider
"ready" for upstream Linux inclusion.  Matt has a lot of learning to
do about Linux kernel development (most of his work was in userspace
since VDO can be compiled and used in userspace).  Conversely, I
still have much to learn about the VDO codebase.  Hopefully we get
over our respective learning curves quicker by working together.

My following email is nearly 6 years old and reflects the list of
VDO changes initially determined to be needed soon after Red Hat
acquired Permabit:

On Wed, Aug 30 2017 at 11:52P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> The following list covers what Joe and I feel is a good first step at
> starting to prepare the permabit kernel code for upstream.  This will be
> an iterative process but working through these issues is a start:
> 
> 1) coding style must adhere to the Linux kernel coding style, see
>    Documentation/process/coding-style.rst
>    - camelCase needs to be converted to lower_case_with_under_scores
>    - spaces must be converted to tabs with tab-width of 8
>    - those are the 2 big style issues but scripts/checkpatch.pl will
>      obviously complain about many other issues that will likely need
>      addressing.
> 
> 2) use GPL interfaces that the permabit kernel code previously was
>    unable to use due to licensing
>    - please work through the ones you are aware of
>    - but other more complex data structures will need to be gone over at
>      some point (e.g. Permabit's workqueue, rcu, linked-list, etc)
> 
> 3) the test harness abstraction code needs to be removed
>    - this obviously will require engineering an alternative to having an
>      in kernel abstraction for compiling in userspace.  That could take
>      the form of just switching test coverage to more traditional DM
>      tests against the permabit device interfaces with IO workloads and
>      ioctls (e.g. device-mapper-test-suite's testing for dm-thinp and
>      dm-cache).
>      Or some new novel way to elevate the kernel code up to userspace
>      for userspace testing.  In any case, this level of test harness is
>      _not_ going to fly in the context of upstream inclusion.
>    - the intermediate data type wrappers must be removed; native kernel
>      types must be used
> 
> 4) rename the Permabit DM target
>    - switch from dm-dedupe to dm-vdo?
>    - dm-vdo would seem to reduce renaming throughout the DM target given
>      "VDO" is used extensively
> 
> bonus for the first round of work items:
> 
> 5) the ioctl interfaces need to be reviewed/refactored
>    - not aware why the Permabit DM target cannot just use the ioctl
>      interfaces that every other kernel DM target uses.
>    - though obviously the traditional DM status output is less than
>      ideal given it is positional rather than name=value pairs, etc.
>    - it could be that we can compromise by adding name=value pair
>      support to aide this effort
> 
> 6) extensive in-kernel code comment blocks need to be reduced/removed
>    - quite a few ramble without _really_ saying much
> 
> Obviously some of the above work items are more involved than others
> (e.g. item #3 above).  We're happy to discuss.
> 
> Thanks,
> Mike

The bulk of the above list (and more that wasn't on it) has been
resolved.  It took ~6 years because corwin and the VDO team were also
supporting the VDO in production, with historic and new customers,
while also working on incrementally addressing the above list (and
more).

But the long-standing dependency on VDO's work-queue data
struct is still lingering (drivers/md/dm-vdo/work-queue.c). At a
minimum we need to work toward pinning down _exactly_ why that is, and
I think the best way to answer that is by simply converting the VDO
code over to using Linux's workqueues.  If doing so causes serious
inherent performance (or functionality) loss then we need to
understand why -- and fix Linux's workqueue code accordingly. (I've
cc'd Tejun so he is aware).

Also, VDO's historic use of murmurhash3 predates there being any
alternative hash that met their requirements.  There was discussion of
valid alternatives briefly, see:
https://listman.redhat.com/archives/dm-devel/2023-May/054267.html
So improving the interface so that the chosen hash is selectable
(while still allowing murmurhash3 to be selected for backward compat)
would be ideal.

Lastly, one of the most challenging problems that VDO currently has
is: discard performance is very slow.  VDO isn't a fast target in
general (born out of its need for 4K IO to achieve best dedup results)
but the discard support is a well-known VDO pain-point that I need to
understand more clearly.

I'm sure there will be other things that elevate to needing further
review and scrutiny.  This will _not_ be a _quick_ process.

But I've always wanted the VDO team to be extremely successful and
look forward to working closer with them on trying to prepare VDO for
upstream inclusion so it can stick the landing.

All said, I really would welcome review for others on the dm-devel and
linux-block mailing list.  I'll take any and all technical concerns
under advisement and work through them.

Thanks,
Mike


On Tue, May 23 2023 at  5:45P -0400,
J. corwin Coburn <corwin@redhat.com> wrote:

> The dm-vdo target provides inline deduplication, compression, zero-block
> elimination, and thin provisioning. A dm-vdo target can be backed by up to
> 256TB of storage, and can present a logical size of up to 4PB. This target
> was originally developed at Permabit Technology Corp. starting in 2009. It
> was first released in 2013 and has been used in production environments
> ever since. It was made open-source in 2017 after Permabit was acquired by
> Red Hat.
> 
> Because deduplication rates fall drastically as the block size increases, a
> vdo target has a maximum block size of 4KB. However, it can achieve
> deduplication rates of 254:1, i.e. up to 254 copies of a given 4KB block
> can reference a single 4KB of actual storage. It can achieve compression
> rates of 14:1. All zero blocks consume no storage at all.
> 
> Design Summary
> --------------
> 
> This is a high-level summary of the ideas behind dm-vdo. For details about
> the implementation and various design choices, refer to vdo-design.rst
> included in this patch set.
> 
> Deduplication is a two-part problem. The first part is recognizing
> duplicate data; the second part is avoiding multiple copies of the
> duplicated data. Therefore, vdo has two main sections: a deduplication
> index that is used to discover potential duplicate data, and a data store
> with a reference counted block map that maps from logical block addresses
> to the actual storage location of the data.
> 
> Hashing:
> 
> In order to identify blocks, vdo hashes each 4KB block to produce a 128-bit
> block name. Since vdo only requires these names to be evenly distributed,
> it uses MurmurHash3, a non-cryptographic hash algorithm which is faster
> than cryptographic hashes.
> 
> The Deduplication Index:
> 
> The index is a set of mappings between a block name (the hash of its
> contents) and a hint indicating where the block might be stored. These
> mappings are stored in temporal order because groups of blocks that are
> written together (such as a large file) tend to be rewritten together as
> well. The index uses a least-recently-used (LRU) scheme to keep frequently
> used names in the index while older names are discarded.
> 
> The index uses a structure called a delta-index to store its mappings,
> which is more space-efficient than using a hashtable. It uses a variable
> length encoding with the property that the average size of an entry
> decreases as the number of entries increases, resulting in a roughly
> constant size as the index fills.
> 
> Because storing hashes along with the data, or rehashing blocks on
> overwrite is expensive, entries are never explicitly deleted from the
> index. Instead, the vdo must always check the data at the physical location
> provided by the index to ensure that the hint is still valid.
> 
> The Data Store:
> 
> The data store is implemented by three main data structures: the block map,
> the slab depot, and the recovery journal. These structures work in concert
> to amortize metadata updates across as many data writes as possible.
> 
> The block map contains the mapping from logical addresses to physical
> locations. For each logical address it indicates whether that address is
> unused, all zeros, or which physical block holds its contents and whether
> or not it is compressed. The array of mappings is represented as a tree,
> with nodes that are allocated as needed from the available physical space.
> 
> The slab depot tracks the physical space available for storing user data.
> The depot also maintains a reference count for each physical block. Each
> block can have up to 254 logical references.
> 
> The recovery journal is a transaction log of the logical-to-physical
> mappings made by data writes. Committing this journal regularly allows a
> vdo to reduce the frequency of other metadata writes and allows it to
> reconstruct its metadata in the event of a crash.
> 
> Zones and Threading:
> 
> Due to the complexity of deduplication, the number of metadata structures
> involved in a single write operation to a vdo target is larger than most
> other targets. Furthermore, because vdo operates on small block sizes in
> order to achieve good deduplication rates, parallelism is key to good
> performance. The deduplication index, the block map, and the slab depot are
> all designed to be easily divided into disjoint zones such that any piece
> of metadata is handled by a single zone. Each zone is then assigned to a
> single thread so that all metadata operations in that zone can proceed
> without locking. Each bio is associated with a request object which can be
> enqueued on each zone thread it needs to access. The zone divisions are not
> reflected in the on-disk representation of the data structures, so the
> number of zones, and hence the number of threads, can be configured each
> time a vdo target is started.
> 
> Existing facilities
> -------------------
> 
> In a few cases, we found that existing kernel facilities did not meet vdo's
> needs, either because of performance or due to a mismatch of semantics.
> These are detailed here:
> 
> Work Queues:
> 
> Handling a single bio requires a number of small operations across a number
> of zones. The per-zone worker threads can be very busy, often using upwards
> of 30% CPU time. Kernel work queues seem targeted for lighter work loads.
> They do not let us easily prioritize individual tasks within a zone, and
> make CPU affinity control at a per-thread level more difficult.
> 
> The threads scanning and updating the in-memory portion of the
> deduplication index process a large number of queries through a single
> function. It uses its own "request queue" mechanism to process these
> efficiently in dedicated threads. In experiments using kernel work queues
> for the index lookups, we observed an overall throughput drop of up to
> almost 10%. In the following table, randwrite% and write% represent the
> change in throughput when switching to kernel work queues for random and
> sequential write workloads, respectively.
> 
> | compression% | deduplication% | randwrite% | write% |
> |--------------+----------------+------------+--------|
> |            0 |              0 |       -8.3 |   -6.4 |
> |           55 |              0 |       -7.9 |   -8.5 |
> |           90 |              0 |       -9.3 |   -8.9 |
> |            0 |             50 |       -4.9 |   -4.5 |
> |           55 |             50 |       -4.4 |   -4.4 |
> |           90 |             50 |       -4.2 |   -4.7 |
> |            0 |             90 |       -1.0 |    0.7 |
> |           55 |             90 |        0.2 |   -0.4 |
> |           90 |             90 |       -0.5 |    0.2 |
> 
> Mempools:
> 
> There are two types of object pools in the vdo implementation for which the
> existing mempool structure was not appropriate. The first of these are
> pools of structures wrapping the bios used for vdo's metadata I/O. Since
> each of these pools is only accessed from a single thread, the locking done
> by mempool is a needless cost. The second of these, the single pool of the
> wrappers for incoming bios, has more complicated locking semantics than
> mempool provides. When a thread attempts to submit a bio to vdo, but the
> pool is exhausted, the thread is put to sleep. The pool is designed to only
> wake that thread once, when it is certain that that thread's bio will be
> processed. It is not desirable to merely allocate more wrappers as a number
> of other vdo structures are designed to handle only a fixed number of
> concurrent requests. This limit is also necessary to bound the amount of
> work needed when recovering after a crash.
> 
> MurmurHash:
> 
> MurmurHash3 was selected for its hash quality, performance on 4KB blocks,
> and its 128-bit output size (vdo needs significantly more than 64 uniformly
> distributed bits for its in-memory and on-disk indexing). For
> cross-platform compatibility, vdo uses a modified version which always
> produces the same output as the original x64 variant, rather than being
> optimized per platform. There is no such hash function already in the
> kernel.
> 
> J. corwin Coburn (39):
>   Add documentation for dm-vdo.
>   Add the MurmurHash3 fast hashing algorithm.
>   Add memory allocation utilities.
>   Add basic logging and support utilities.
>   Add vdo type declarations, constants, and simple data structures.
>   Add thread and synchronization utilities.
>   Add specialized request queueing functionality.
>   Add basic data structures.
>   Add deduplication configuration structures.
>   Add deduplication index storage interface.
>   Implement the delta index.
>   Implement the volume index.
>   Implement the open chapter and chapter indexes.
>   Implement the chapter volume store.
>   Implement top-level deduplication index.
>   Implement external deduplication index interface.
>   Add administrative state and scheduling for vdo.
>   Add vio, the request object for vdo metadata.
>   Add data_vio, the request object which services incoming bios.
>   Add flush support to vdo.
>   Add the vdo io_submitter.
>   Add hash locks and hash zones.
>   Add use of the deduplication index in hash zones.
>   Add the compressed block bin packer.
>   Add vdo_slab.
>   Add the slab summary.
>   Add the block allocators and physical zones.
>   Add the slab depot itself.
>   Add the vdo block map.
>   Implement the vdo block map page cache.
>   Add the vdo recovery journal.
>   Add repair (crash recovery and read-only rebuild) of damaged vdos.
>   Add the vdo structure itself.
>   Add the on-disk formats and marshalling of vdo structures.
>   Add statistics tracking.
>   Add sysfs support for setting vdo parameters and fetching statistics.
>   Add vdo debugging support.
>   Add dm-vdo-target.c
>   Enable configuration and building of dm-vdo.
> 
>  .../admin-guide/device-mapper/vdo-design.rst  |  390 ++
>  .../admin-guide/device-mapper/vdo.rst         |  386 ++
>  drivers/md/Kconfig                            |   16 +
>  drivers/md/Makefile                           |    2 +
>  drivers/md/dm-vdo-target.c                    | 2983 ++++++++++
>  drivers/md/dm-vdo/action-manager.c            |  410 ++
>  drivers/md/dm-vdo/action-manager.h            |  117 +
>  drivers/md/dm-vdo/admin-state.c               |  512 ++
>  drivers/md/dm-vdo/admin-state.h               |  180 +
>  drivers/md/dm-vdo/block-map.c                 | 3381 +++++++++++
>  drivers/md/dm-vdo/block-map.h                 |  392 ++
>  drivers/md/dm-vdo/chapter-index.c             |  304 +
>  drivers/md/dm-vdo/chapter-index.h             |   66 +
>  drivers/md/dm-vdo/completion.c                |  141 +
>  drivers/md/dm-vdo/completion.h                |  155 +
>  drivers/md/dm-vdo/config.c                    |  389 ++
>  drivers/md/dm-vdo/config.h                    |  125 +
>  drivers/md/dm-vdo/constants.c                 |   15 +
>  drivers/md/dm-vdo/constants.h                 |  102 +
>  drivers/md/dm-vdo/cpu.h                       |   58 +
>  drivers/md/dm-vdo/data-vio.c                  | 2076 +++++++
>  drivers/md/dm-vdo/data-vio.h                  |  683 +++
>  drivers/md/dm-vdo/dedupe.c                    | 3073 ++++++++++
>  drivers/md/dm-vdo/dedupe.h                    |  119 +
>  drivers/md/dm-vdo/delta-index.c               | 2018 +++++++
>  drivers/md/dm-vdo/delta-index.h               |  292 +
>  drivers/md/dm-vdo/dump.c                      |  288 +
>  drivers/md/dm-vdo/dump.h                      |   17 +
>  drivers/md/dm-vdo/encodings.c                 | 1523 +++++
>  drivers/md/dm-vdo/encodings.h                 | 1307 +++++
>  drivers/md/dm-vdo/errors.c                    |  316 +
>  drivers/md/dm-vdo/errors.h                    |   83 +
>  drivers/md/dm-vdo/flush.c                     |  563 ++
>  drivers/md/dm-vdo/flush.h                     |   44 +
>  drivers/md/dm-vdo/funnel-queue.c              |  169 +
>  drivers/md/dm-vdo/funnel-queue.h              |  110 +
>  drivers/md/dm-vdo/geometry.c                  |  205 +
>  drivers/md/dm-vdo/geometry.h                  |  137 +
>  drivers/md/dm-vdo/hash-utils.h                |   66 +
>  drivers/md/dm-vdo/index-layout.c              | 1775 ++++++
>  drivers/md/dm-vdo/index-layout.h              |   42 +
>  drivers/md/dm-vdo/index-page-map.c            |  181 +
>  drivers/md/dm-vdo/index-page-map.h            |   54 +
>  drivers/md/dm-vdo/index-session.c             |  815 +++
>  drivers/md/dm-vdo/index-session.h             |   84 +
>  drivers/md/dm-vdo/index.c                     | 1403 +++++
>  drivers/md/dm-vdo/index.h                     |   83 +
>  drivers/md/dm-vdo/int-map.c                   |  710 +++
>  drivers/md/dm-vdo/int-map.h                   |   40 +
>  drivers/md/dm-vdo/io-factory.c                |  458 ++
>  drivers/md/dm-vdo/io-factory.h                |   66 +
>  drivers/md/dm-vdo/io-submitter.c              |  483 ++
>  drivers/md/dm-vdo/io-submitter.h              |   52 +
>  drivers/md/dm-vdo/logger.c                    |  304 +
>  drivers/md/dm-vdo/logger.h                    |  112 +
>  drivers/md/dm-vdo/logical-zone.c              |  378 ++
>  drivers/md/dm-vdo/logical-zone.h              |   87 +
>  drivers/md/dm-vdo/memory-alloc.c              |  447 ++
>  drivers/md/dm-vdo/memory-alloc.h              |  181 +
>  drivers/md/dm-vdo/message-stats.c             | 1222 ++++
>  drivers/md/dm-vdo/message-stats.h             |   13 +
>  drivers/md/dm-vdo/murmurhash3.c               |  175 +
>  drivers/md/dm-vdo/murmurhash3.h               |   15 +
>  drivers/md/dm-vdo/numeric.h                   |   78 +
>  drivers/md/dm-vdo/open-chapter.c              |  433 ++
>  drivers/md/dm-vdo/open-chapter.h              |   79 +
>  drivers/md/dm-vdo/packer.c                    |  794 +++
>  drivers/md/dm-vdo/packer.h                    |  123 +
>  drivers/md/dm-vdo/permassert.c                |   35 +
>  drivers/md/dm-vdo/permassert.h                |   65 +
>  drivers/md/dm-vdo/physical-zone.c             |  650 ++
>  drivers/md/dm-vdo/physical-zone.h             |  115 +
>  drivers/md/dm-vdo/pointer-map.c               |  691 +++
>  drivers/md/dm-vdo/pointer-map.h               |   81 +
>  drivers/md/dm-vdo/pool-sysfs-stats.c          | 2063 +++++++
>  drivers/md/dm-vdo/pool-sysfs.c                |  193 +
>  drivers/md/dm-vdo/pool-sysfs.h                |   19 +
>  drivers/md/dm-vdo/priority-table.c            |  226 +
>  drivers/md/dm-vdo/priority-table.h            |   48 +
>  drivers/md/dm-vdo/radix-sort.c                |  349 ++
>  drivers/md/dm-vdo/radix-sort.h                |   28 +
>  drivers/md/dm-vdo/recovery-journal.c          | 1772 ++++++
>  drivers/md/dm-vdo/recovery-journal.h          |  313 +
>  drivers/md/dm-vdo/release-versions.h          |   20 +
>  drivers/md/dm-vdo/repair.c                    | 1775 ++++++
>  drivers/md/dm-vdo/repair.h                    |   14 +
>  drivers/md/dm-vdo/request-queue.c             |  284 +
>  drivers/md/dm-vdo/request-queue.h             |   30 +
>  drivers/md/dm-vdo/slab-depot.c                | 5210 +++++++++++++++++
>  drivers/md/dm-vdo/slab-depot.h                |  594 ++
>  drivers/md/dm-vdo/sparse-cache.c              |  595 ++
>  drivers/md/dm-vdo/sparse-cache.h              |   49 +
>  drivers/md/dm-vdo/statistics.h                |  279 +
>  drivers/md/dm-vdo/status-codes.c              |  126 +
>  drivers/md/dm-vdo/status-codes.h              |  112 +
>  drivers/md/dm-vdo/string-utils.c              |   28 +
>  drivers/md/dm-vdo/string-utils.h              |   23 +
>  drivers/md/dm-vdo/sysfs.c                     |   84 +
>  drivers/md/dm-vdo/thread-cond-var.c           |   46 +
>  drivers/md/dm-vdo/thread-device.c             |   35 +
>  drivers/md/dm-vdo/thread-device.h             |   19 +
>  drivers/md/dm-vdo/thread-registry.c           |   93 +
>  drivers/md/dm-vdo/thread-registry.h           |   33 +
>  drivers/md/dm-vdo/time-utils.h                |   28 +
>  drivers/md/dm-vdo/types.h                     |  403 ++
>  drivers/md/dm-vdo/uds-sysfs.c                 |  185 +
>  drivers/md/dm-vdo/uds-sysfs.h                 |   12 +
>  drivers/md/dm-vdo/uds-threads.c               |  189 +
>  drivers/md/dm-vdo/uds-threads.h               |  126 +
>  drivers/md/dm-vdo/uds.h                       |  334 ++
>  drivers/md/dm-vdo/vdo.c                       | 1846 ++++++
>  drivers/md/dm-vdo/vdo.h                       |  381 ++
>  drivers/md/dm-vdo/vio.c                       |  525 ++
>  drivers/md/dm-vdo/vio.h                       |  221 +
>  drivers/md/dm-vdo/volume-index.c              | 1272 ++++
>  drivers/md/dm-vdo/volume-index.h              |  192 +
>  drivers/md/dm-vdo/volume.c                    | 1792 ++++++
>  drivers/md/dm-vdo/volume.h                    |  174 +
>  drivers/md/dm-vdo/wait-queue.c                |  223 +
>  drivers/md/dm-vdo/wait-queue.h                |  129 +
>  drivers/md/dm-vdo/work-queue.c                |  659 +++
>  drivers/md/dm-vdo/work-queue.h                |   53 +
>  122 files changed, 58741 insertions(+)
>  create mode 100644 Documentation/admin-guide/device-mapper/vdo-design.rst
>  create mode 100644 Documentation/admin-guide/device-mapper/vdo.rst
>  create mode 100644 drivers/md/dm-vdo-target.c
>  create mode 100644 drivers/md/dm-vdo/action-manager.c
>  create mode 100644 drivers/md/dm-vdo/action-manager.h
>  create mode 100644 drivers/md/dm-vdo/admin-state.c
>  create mode 100644 drivers/md/dm-vdo/admin-state.h
>  create mode 100644 drivers/md/dm-vdo/block-map.c
>  create mode 100644 drivers/md/dm-vdo/block-map.h
>  create mode 100644 drivers/md/dm-vdo/chapter-index.c
>  create mode 100644 drivers/md/dm-vdo/chapter-index.h
>  create mode 100644 drivers/md/dm-vdo/completion.c
>  create mode 100644 drivers/md/dm-vdo/completion.h
>  create mode 100644 drivers/md/dm-vdo/config.c
>  create mode 100644 drivers/md/dm-vdo/config.h
>  create mode 100644 drivers/md/dm-vdo/constants.c
>  create mode 100644 drivers/md/dm-vdo/constants.h
>  create mode 100644 drivers/md/dm-vdo/cpu.h
>  create mode 100644 drivers/md/dm-vdo/data-vio.c
>  create mode 100644 drivers/md/dm-vdo/data-vio.h
>  create mode 100644 drivers/md/dm-vdo/dedupe.c
>  create mode 100644 drivers/md/dm-vdo/dedupe.h
>  create mode 100644 drivers/md/dm-vdo/delta-index.c
>  create mode 100644 drivers/md/dm-vdo/delta-index.h
>  create mode 100644 drivers/md/dm-vdo/dump.c
>  create mode 100644 drivers/md/dm-vdo/dump.h
>  create mode 100644 drivers/md/dm-vdo/encodings.c
>  create mode 100644 drivers/md/dm-vdo/encodings.h
>  create mode 100644 drivers/md/dm-vdo/errors.c
>  create mode 100644 drivers/md/dm-vdo/errors.h
>  create mode 100644 drivers/md/dm-vdo/flush.c
>  create mode 100644 drivers/md/dm-vdo/flush.h
>  create mode 100644 drivers/md/dm-vdo/funnel-queue.c
>  create mode 100644 drivers/md/dm-vdo/funnel-queue.h
>  create mode 100644 drivers/md/dm-vdo/geometry.c
>  create mode 100644 drivers/md/dm-vdo/geometry.h
>  create mode 100644 drivers/md/dm-vdo/hash-utils.h
>  create mode 100644 drivers/md/dm-vdo/index-layout.c
>  create mode 100644 drivers/md/dm-vdo/index-layout.h
>  create mode 100644 drivers/md/dm-vdo/index-page-map.c
>  create mode 100644 drivers/md/dm-vdo/index-page-map.h
>  create mode 100644 drivers/md/dm-vdo/index-session.c
>  create mode 100644 drivers/md/dm-vdo/index-session.h
>  create mode 100644 drivers/md/dm-vdo/index.c
>  create mode 100644 drivers/md/dm-vdo/index.h
>  create mode 100644 drivers/md/dm-vdo/int-map.c
>  create mode 100644 drivers/md/dm-vdo/int-map.h
>  create mode 100644 drivers/md/dm-vdo/io-factory.c
>  create mode 100644 drivers/md/dm-vdo/io-factory.h
>  create mode 100644 drivers/md/dm-vdo/io-submitter.c
>  create mode 100644 drivers/md/dm-vdo/io-submitter.h
>  create mode 100644 drivers/md/dm-vdo/logger.c
>  create mode 100644 drivers/md/dm-vdo/logger.h
>  create mode 100644 drivers/md/dm-vdo/logical-zone.c
>  create mode 100644 drivers/md/dm-vdo/logical-zone.h
>  create mode 100644 drivers/md/dm-vdo/memory-alloc.c
>  create mode 100644 drivers/md/dm-vdo/memory-alloc.h
>  create mode 100644 drivers/md/dm-vdo/message-stats.c
>  create mode 100644 drivers/md/dm-vdo/message-stats.h
>  create mode 100644 drivers/md/dm-vdo/murmurhash3.c
>  create mode 100644 drivers/md/dm-vdo/murmurhash3.h
>  create mode 100644 drivers/md/dm-vdo/numeric.h
>  create mode 100644 drivers/md/dm-vdo/open-chapter.c
>  create mode 100644 drivers/md/dm-vdo/open-chapter.h
>  create mode 100644 drivers/md/dm-vdo/packer.c
>  create mode 100644 drivers/md/dm-vdo/packer.h
>  create mode 100644 drivers/md/dm-vdo/permassert.c
>  create mode 100644 drivers/md/dm-vdo/permassert.h
>  create mode 100644 drivers/md/dm-vdo/physical-zone.c
>  create mode 100644 drivers/md/dm-vdo/physical-zone.h
>  create mode 100644 drivers/md/dm-vdo/pointer-map.c
>  create mode 100644 drivers/md/dm-vdo/pointer-map.h
>  create mode 100644 drivers/md/dm-vdo/pool-sysfs-stats.c
>  create mode 100644 drivers/md/dm-vdo/pool-sysfs.c
>  create mode 100644 drivers/md/dm-vdo/pool-sysfs.h
>  create mode 100644 drivers/md/dm-vdo/priority-table.c
>  create mode 100644 drivers/md/dm-vdo/priority-table.h
>  create mode 100644 drivers/md/dm-vdo/radix-sort.c
>  create mode 100644 drivers/md/dm-vdo/radix-sort.h
>  create mode 100644 drivers/md/dm-vdo/recovery-journal.c
>  create mode 100644 drivers/md/dm-vdo/recovery-journal.h
>  create mode 100644 drivers/md/dm-vdo/release-versions.h
>  create mode 100644 drivers/md/dm-vdo/repair.c
>  create mode 100644 drivers/md/dm-vdo/repair.h
>  create mode 100644 drivers/md/dm-vdo/request-queue.c
>  create mode 100644 drivers/md/dm-vdo/request-queue.h
>  create mode 100644 drivers/md/dm-vdo/slab-depot.c
>  create mode 100644 drivers/md/dm-vdo/slab-depot.h
>  create mode 100644 drivers/md/dm-vdo/sparse-cache.c
>  create mode 100644 drivers/md/dm-vdo/sparse-cache.h
>  create mode 100644 drivers/md/dm-vdo/statistics.h
>  create mode 100644 drivers/md/dm-vdo/status-codes.c
>  create mode 100644 drivers/md/dm-vdo/status-codes.h
>  create mode 100644 drivers/md/dm-vdo/string-utils.c
>  create mode 100644 drivers/md/dm-vdo/string-utils.h
>  create mode 100644 drivers/md/dm-vdo/sysfs.c
>  create mode 100644 drivers/md/dm-vdo/thread-cond-var.c
>  create mode 100644 drivers/md/dm-vdo/thread-device.c
>  create mode 100644 drivers/md/dm-vdo/thread-device.h
>  create mode 100644 drivers/md/dm-vdo/thread-registry.c
>  create mode 100644 drivers/md/dm-vdo/thread-registry.h
>  create mode 100644 drivers/md/dm-vdo/time-utils.h
>  create mode 100644 drivers/md/dm-vdo/types.h
>  create mode 100644 drivers/md/dm-vdo/uds-sysfs.c
>  create mode 100644 drivers/md/dm-vdo/uds-sysfs.h
>  create mode 100644 drivers/md/dm-vdo/uds-threads.c
>  create mode 100644 drivers/md/dm-vdo/uds-threads.h
>  create mode 100644 drivers/md/dm-vdo/uds.h
>  create mode 100644 drivers/md/dm-vdo/vdo.c
>  create mode 100644 drivers/md/dm-vdo/vdo.h
>  create mode 100644 drivers/md/dm-vdo/vio.c
>  create mode 100644 drivers/md/dm-vdo/vio.h
>  create mode 100644 drivers/md/dm-vdo/volume-index.c
>  create mode 100644 drivers/md/dm-vdo/volume-index.h
>  create mode 100644 drivers/md/dm-vdo/volume.c
>  create mode 100644 drivers/md/dm-vdo/volume.h
>  create mode 100644 drivers/md/dm-vdo/wait-queue.c
>  create mode 100644 drivers/md/dm-vdo/wait-queue.h
>  create mode 100644 drivers/md/dm-vdo/work-queue.c
>  create mode 100644 drivers/md/dm-vdo/work-queue.h
> 
> -- 
> 2.40.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

