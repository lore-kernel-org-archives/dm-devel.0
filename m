Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E2AC7EE33
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684901717;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HlNbCZ8MJeUY5v76fPpy0nukfSChZEJ88JBrObb4rC8=;
	b=Ttt8wMazhogvNoYQ43zDreuRIT6NASHtqMSBlaqr6KsXf0Lw86sIddqZ6gQIt5lRqiKLex
	/FhmuyVmojNGy1gqnYehR4RjOxtczSvNThz5GUr6mwhmoMOltGxE26FMGpd0hVTt2tM9U0
	X+l6JlITba1PjF8GngxXHm2eGCxQRiM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-hs9aVKfHPtyraQ66DVQBVg-1; Wed, 24 May 2023 00:15:15 -0400
X-MC-Unique: hs9aVKfHPtyraQ66DVQBVg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2843538035CF;
	Wed, 24 May 2023 04:15:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3CFB31121314;
	Wed, 24 May 2023 04:15:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00B0C19465A8;
	Wed, 24 May 2023 04:15:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A40219465A8
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 04:15:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 04A407AE4; Wed, 24 May 2023 04:15:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F13909E63
 for <dm-devel@redhat.com>; Wed, 24 May 2023 04:15:10 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3836811E78
 for <dm-devel@redhat.com>; Wed, 24 May 2023 04:15:10 +0000 (UTC)
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-1kfyonEDP8iJOgSogoNFBw-1; Wed, 24 May 2023 00:15:09 -0400
X-MC-Unique: 1kfyonEDP8iJOgSogoNFBw-1
Received: by mail-qv1-f71.google.com with SMTP id
 6a1803df08f44-5eee6742285so5148766d6.2
 for <dm-devel@redhat.com>; Tue, 23 May 2023 21:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684901708; x=1687493708;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=NQYbukEXmJqsQv219sGU9nwPv609hkGR4fvvkmIJr6s=;
 b=hbm9HvBX/1PgVOPh8jCh5Xt0/3f/cdUS0XTahfP35TCBN6MhRmmTXsNbICnfpfOjx8
 Mf3bkYZZ4OLwF7TTF8n3HFzEYKGzGj9GmP0vsGmACh3oOFGQybr6jgmYQ111Bp5X+t3K
 dgcOnGYqeu9EulD6V1HoUlSlyOdAuMnWV4XART6eJ6gd97TOVQxOpr+8wlFEmxYl7kK0
 lO6tSDgwhWfLEvVOfjHUTd6mcHhzNhfyOduq1wMgiPO9C338bD8JtyuLE6ZxPNdffCuN
 OBpnw3ZjC9gFUpxuTyLVUwIzF9b6JXRbls9QsN96fQLpuyRqWiXw1o9J5n3TS2xYLrpB
 a21Q==
X-Gm-Message-State: AC+VfDwcpJsII6FZq3naw05dZZ3+n3IFr5NlRhfB4PH+8MB2h0iSla4Q
 hJNSwq3DQIQuTYTXHT80n29NETVwOdLDWMkmiTRvq0PcWKRUaZl9xtDArT2uPJPxkdWLqMw3zrW
 VXbN8XsGMrmNvf0c=
X-Received: by 2002:a05:6214:19cf:b0:5e9:2d8c:9a21 with SMTP id
 j15-20020a05621419cf00b005e92d8c9a21mr29531260qvc.32.1684901708503; 
 Tue, 23 May 2023 21:15:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4yCBQ1TjFSdD8FirTE/qQ3gu1yt5ZIj7oIsJ14PAcarSxaUsxRMUrNR/TCGjHAY9fNbgsKag==
X-Received: by 2002:a05:6214:19cf:b0:5e9:2d8c:9a21 with SMTP id
 j15-20020a05621419cf00b005e92d8c9a21mr29531241qvc.32.1684901708189; 
 Tue, 23 May 2023 21:15:08 -0700 (PDT)
Received: from [172.16.2.39]
 (173-166-2-198-newengland.hfc.comcastbusiness.net. [173.166.2.198])
 by smtp.gmail.com with ESMTPSA id
 z8-20020ac84548000000b003e4c6b2cc35sm3400874qtn.24.2023.05.23.21.15.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 23 May 2023 21:15:07 -0700 (PDT)
Message-ID: <8fd4a274-1ec1-7e4a-f8e9-0990d342ce58@redhat.com>
Date: Wed, 24 May 2023 00:15:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
To: Eric Biggers <ebiggers@kernel.org>
References: <20230523214539.226387-1-corwin@redhat.com>
 <20230523214539.226387-3-corwin@redhat.com>
 <20230523220618.GA888341@google.com>
 <0d3d1835-d945-9fa2-f3b7-6a60aae3d1df@redhat.com>
 <20230523222501.GD888341@google.com> <20230523230624.GF888341@google.com>
From: corwin <corwin@redhat.com>
In-Reply-To: <20230523230624.GF888341@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 02/39] Add the MurmurHash3 fast hashing
 algorithm.
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
Cc: linux-block@vger.kernel.org, vdo-devel@redhat.com, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/23/23 7:06 PM, Eric Biggers wrote:
 > On Tue, May 23, 2023 at 10:25:01PM +0000, Eric Biggers wrote:
 >> On Tue, May 23, 2023 at 06:13:08PM -0400, corwin wrote:
 >>> On 5/23/23 6:06 PM, Eric Biggers wrote:
 >>>> On Tue, May 23, 2023 at 05:45:02PM -0400, J. corwin Coburn wrote:
 >>>>> MurmurHash3 is a fast, non-cryptographic, 128-bit hash. It was 
originally
 >>>>> written by Austin Appleby and placed in the public domain. This 
version has
 >>>>> been modified to produce the same result on both big endian and 
little
 >>>>> endian processors, making it suitable for use in portable 
persistent data.
 >>>>>
 >>>>> Signed-off-by: J. corwin Coburn <corwin@redhat.com>
 >>>>> ---
 >>>>>    drivers/md/dm-vdo/murmurhash3.c | 175 
++++++++++++++++++++++++++++++++
 >>>>>    drivers/md/dm-vdo/murmurhash3.h |  15 +++
 >>>>>    2 files changed, 190 insertions(+)
 >>>>>    create mode 100644 drivers/md/dm-vdo/murmurhash3.c
 >>>>>    create mode 100644 drivers/md/dm-vdo/murmurhash3.h
 >>>>
 >>>> Do we really need yet another hash algorithm?
 >>>>
 >>>> xxHash is another very fast non-cryptographic hash algorithm that 
is already
 >>>> available in the kernel (lib/xxhash.c).
 >>>>
 >>>> - Eric
 >>>
 >>> The main reason why vdo uses Murmur3 and not xxHash is that vdo has 
been in
 >>> deployment since 2013, and, if I am reading correctly, xxHash did 
not have a
 >>> 128 bit variant until 2019.

Before I dive into the more technical details of the index, let me
elaborate a bit as well. One of the key ideas in the design of vdo is
that the index is largely independent of the data store. The index is
used only for deduplication hints and is not required to read and
write data.

As such, switching hash algorithms is not out of the question. It
would be inconvenient for existing deployments as their existing
indexes would cease to work after an upgrade, and so they would lose
deduplication on new writes against data written before the
upgrade. However, there would be no loss of data. As such, if we
determine that avoiding this issue for existing deployments is not
worth the cost of supporting another hash algorithm, we are open to
making that change.

The on disk format of the data store portion of vdo is more amenable
to upgrade, so nothing is set in stone.

 >>
 >> Why do you need a 128-bit non-cryptographic hash algorithm?  What 
problem are
 >> you trying to solve?
 >
 > To elaborate a bit: the reason this seems strange to me is that when 
people say
 > they need a 128-bit (or larger) non-cryptographic hash function, 
usually they
 > are either mistaken and 64-bit would suffice, or they actually need a
 > cryptographic hash function.
 >
 > In this case, the hash function seems to be used for data 
deduplication.  This
 > is unusual, since data deduplication normally requires a 
cryptographic hash
 > algorithm.
 >
 > I see that this is touched on by the following paragraph in 
vdo-design.rst
 > (though it incorrectly calls the hash an "identifier for the block"):
 >
 >      Each block of data is hashed to produce a 16-byte block name 
which serves as
 >      an identifier for the block. An index record consists of this 
block name
 >      paired with the presumed location of that data on the underlying 
storage.
 >      However, it is not possible to guarantee that the index is 
accurate. Most
 >      often, this occurs because it is too costly to update the index 
when a block
 >      is over-written or discarded. Doing so would require either 
storing the
 >      block name along with the blocks, which is difficult to do 
efficiently in
 >      block-based storage, or reading and rehashing each block before 
overwriting
 >      it. Inaccuracy can also result from a hash collision where two 
different
 >      blocks have the same name. In practice, this is extremely 
unlikely, but
 >      because vdo does not use a cryptographic hash, a malicious 
workload can be
 >      constructed. Because of these inaccuracies, vdo treats the 
locations in the
 >      index as hints, and reads each indicated block to verify that it 
is indeed a
 >      duplicate before sharing the existing block with a new one.
 >
 > So, dm-vdo handles hash collisions by reading back and verifying that 
the data
 > matches before allowing deduplication.
 >
 > That solves the security problem.  However, it does seem strange, and 
it's more
 > complex than the usual solution of just using a cryptographic hash. 
Note that
 > cryptographic hashing is very fast on modern CPUs with modern algorithms.

Merely using a cryptographic hash doesn't solve the overwrite problem
(detailed in the paragraph you quote above). Since vdo has to do a
read-verify anyway, there is no benefit to using a stronger hash.

 >
 > So, some more details about the rationale for designing the data 
deduplication
 > in this (IMO unusual) way should be included.
 >
 > - Eric
 >

The design of the index is intended to provide sufficient performance
without using too much memory. The index lookup for old records (those
not so new that they haven't been written out yet) is detailed in
vdo-design.rst:

       In order to find records in older chapters, the index also
       maintains a higher level structure called the volume index,
       which contains entries mapping a block name to the chapter
       containing its newest record. This mapping is updated as records
       for the block name are copied or updated, ensuring that only the
       newer record for a given block name is findable. Older records
       for a block name can no longer be found even though they have
       not been deleted. Like the chapter index, the volume index uses
       only a subset of the block name as its key and can not
       definitively say that a record exists for a name. It can only
       say which chapter would contain the record if a record
       exists. The volume index is stored entirely in memory and is
       saved to storage only when the vdo target is shut down.

       From the viewpoint of a request for a particular block name,
       first it will look up the name in the volume index which will
       indicate either that the record is new, or which chapter to
       search. If the latter, the request looks up its name in the
       chapter index to determine if the record is new, or which record
       page to search. Finally, if not new, the request will look for
       its record on the indicated record page. This process may
       require up to two page reads per request (one for the chapter
       index page and one for the request page). However, recently
       accessed pages are cached so that these page reads can be
       amortized across many block name requests.

       The volume index and the chapter indexes are implemented using a
       memory-efficient structure called a delta index. Instead of
       storing the entire key (the block name) for each entry, the
       entries are sorted by name and only the difference between
       adjacent keys (the delta) is stored. Because we expect the
       hashes to be evenly distributed, the size of the deltas follows
       an exponential distribution. Because of this distribution, the
       deltas are expressed in a Huffman code to take up even less
       space. The entire sorted list of keys is called a delta
       list. This structure allows the index to use many fewer bytes
       per entry than a traditional hash table, but it is slightly more
       expensive to look up entries, because a request must read every
       entry in a delta list to add up the deltas in order to find the
       record it needs. The delta index reduces this lookup cost by
       splitting its key space into many sub-lists, each starting at a
       fixed key value, so that each individual list is short.

Even with the compression inherent in the delta list structure,
keeping the entire delta for each entry in memory is too costly. The
multi-level structure of the index allows us to reduce the memory size
while still achieving acceptable performance. The volume index is
computed on only a portion of the full hash, greatly reducing the size
of each entry. Similarly, the chapter index is computed on a different
subset of the full hash thereby reducing the amount of data that needs
to be read and cached. These savings come at the cost of false
positives in both the volume index and the chapter index, each of
which result in spurious reads and hence reduced performance.

In order to bound the reading required for each lookup, when the
volume index needs to store multiple entries whose volume index bits
collide (but whose full hashed do not), all but the first entry are
stored not as deltas but as "collision records" which contain the full
128 bit hash. These records ensure that any lookup requires reading at
most one index page and one record page. However, collision records
consume much more memory than normal entries.

The number of bits used by the volume and chapter index are tuned to
balance memory against the false positive rate (note that the false
positive rate in the chapter index would be significantly higher if
the chapter index bits were to overlap with the volume index bits). We
have found that 8 bytes for the volume index and 6 for the chapter
index give good performance with an acceptable memory budget
(approximately 3 bytes per entry).

The index also supports a "sparse" mode which uses ten times as many
chapters as the default, "dense" mode with a volume index of the same
size. This mode leverages the temporal locality which is usually
present in workloads with high dedupe rates. Rather than keeping every
entry in the volume index, only 1/32 of entries in most of the index
are retained in the volume index. On lookup, if a hash is not found in
the volume index, the cached chapter indexes are also searched before
deciding the entry is new. 5 of the remainin bits of the hash are used
to select which entries are retained in the sparse portion of the
volume index.

corwin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

