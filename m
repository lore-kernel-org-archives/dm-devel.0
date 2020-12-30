Return-Path: <SRS0=/4vF=GC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E9BC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 23:40:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 30C52207A6
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 23:40:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30C52207A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609371656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zAGbayTNe3HJlaZRyheZIckDxUCGR9m2eWj4vWSWCpY=;
	b=PvLgMa3T60ly+9vb1EYAMRpy7jxw6ytS/4MDskp00hwYweZJtP3kzrLoLEMHs1IRfXGKsi
	/keoEEBRUy2BcRxwe7tFDRdLkQtTr5UtyNoQRoMkWCfHEopWbC0g70IWG3thlLHpN2SqCH
	TcSbnZaOgzWAnyw/PN65EAHXBy1k+wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-SSBijyqCNh6rkk142PFG1g-1; Wed, 30 Dec 2020 18:40:54 -0500
X-MC-Unique: SSBijyqCNh6rkk142PFG1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EBC6107ACE6;
	Wed, 30 Dec 2020 23:40:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4AA260C5F;
	Wed, 30 Dec 2020 23:40:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B0EE1809C9F;
	Wed, 30 Dec 2020 23:40:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BUNYYiC025597 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Dec 2020 18:34:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F0495D9DD; Wed, 30 Dec 2020 23:34:34 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 689955D9CC;
	Wed, 30 Dec 2020 23:34:30 +0000 (UTC)
Date: Wed, 30 Dec 2020 18:34:29 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: dannyshih <dannyshih@synology.com>
Message-ID: <20201230233429.GA6456@redhat.com>
References: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
MIME-Version: 1.0
In-Reply-To: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 0/4] Fix order when split bio and send
 remaining back to itself
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 29 2020 at  4:18am -0500,
dannyshih <dannyshih@synology.com> wrote:

> From: Danny Shih <dannyshih@synology.com>
> 
> We found out that split bios might handle not in order when a big bio
> had split by blk_queue_split() and also split in stacking block device,
> such as md device because chunk size boundary limit.
> 
> Stacking block device normally use submit_bio_noacct() add the remaining
> bio to current->bio_list's tail after they split original bio. Therefore,
> when bio split first time, the last part of bio was add to bio_list.
> After then, when bio split second time, the middle part of bio was add to
> bio_list. Results that the middle part is now behind the last part of bio.
> 
> For example:
> 	There is a RAID0 md device, with max_sectors_kb = 2 KB,
> 	and chunk_size = 1 KB
> 
> 	1. a read bio come to md device wants to read 0-7 KB
> 	2. In blk_queue_split(), bio split into (0-1), (2-7),
> 	   and send (2-7) back to md device
> 
> 	   current->bio_list = bio_list_on_stack[0]: (md 2-7)
> 	3. RAID0 split bio (0-1) into (0) and (1), since chunk size is 1 KB
> 	   and send (1) back to md device
> 
> 	   bio_list_on_stack[0]: (md 2-7) -> (md 1)
> 	4. remap and send (0) to lower layer device
> 
> 	   bio_list_on_stack[0]: (md 2-7) -> (md 1) -> (lower 0)
> 	5. __submit_bio_noacct() sorting bio let lower bio handle firstly
> 	   bio_list_on_stack[0]: (lower 0) -> (md 2-7) -> (md 1)
> 	   pop (lower 0)
> 	   move bio_list_on_stack[0] to bio_list_on_stack[1]
> 
> 	   bio_list_on_stack[1]: (md 2-7) -> (md 1)
> 	6. after handle lower bio, it handle (md 2-7) firstly, and split
> 	   in blk_queue_split() into (2-3), (4-7), send (4-7) back
> 
> 	   bio_list_on_stack[0]: (md 4-7)
> 	   bio_list_on_stack[1]: (md 1)
> 	7. RAID0 split bio (2-3) into (2) and (3) and send (3) back
> 
> 	   bio_list_on_stack[0]: (md 4-7) -> (md 3)
> 	   bio_list_on_stack[1]: (md 1)
> 	...
> 	In the end, the split bio handle's order will become
> 	0 -> 2 -> 4 -> 6 -> 7 -> 5 -> 3 -> 1
> 
> Reverse the order of same queue bio when sorting bio in
> __submit_bio_noacct() can solve this issue, but it might influence
> too much. So we provide alternative version of submit_bio_noacct(),
> named submit_bio_noacct_add_head(), for the case which need to add bio
> to the head of current->bio_list. And replace submit_bio_noacct() with
> submit_bio_noacct_add_head() in block device layer when we want to
> split bio and send remaining back to itself.

Ordering aside, you cannot split more than once.  So your proposed fix
to insert at head isn't valid because you're still implicitly allocating
more than one bio from the bioset which could cause deadlock in a low
memory situation.

I had to deal with a comparable issue with DM core not too long ago, see
this commit:

commit ee1dfad5325ff1cfb2239e564cd411b3bfe8667a
Author: Mike Snitzer <snitzer@redhat.com>
Date:   Mon Sep 14 13:04:19 2020 -0400

    dm: fix bio splitting and its bio completion order for regular IO

    dm_queue_split() is removed because __split_and_process_bio() _must_
    handle splitting bios to ensure proper bio submission and completion
    ordering as a bio is split.

    Otherwise, multiple recursive calls to ->submit_bio will cause multiple
    split bios to be allocated from the same ->bio_split mempool at the same
    time. This would result in deadlock in low memory conditions because no
    progress could be made (only one bio is available in ->bio_split
    mempool).

    This fix has been verified to still fix the loss of performance, due
    to excess splitting, that commit 120c9257f5f1 provided.

    Fixes: 120c9257f5f1 ("Revert "dm: always call blk_queue_split() in dm_process_bio()"")
    Cc: stable@vger.kernel.org # 5.0+, requires custom backport due to 5.9 changes
    Reported-by: Ming Lei <ming.lei@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Basically you cannot split the same bio more than once without
recursing.  Your elaborate documentation shows things going wrong quite
early in step 3.  That additional split and recursing back to MD
shouldn't happen before the first bio split completes.

Seems the proper fix is to disallow max_sectors_kb to be imposed, via
blk_queue_split(), if MD has further splitting constraints, via
chunk_sectors, that negate max_sectors_kb anyway.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

