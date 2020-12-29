Return-Path: <SRS0=56Wl=GB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02423C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5703D208BA
	for <dm-devel@archiver.kernel.org>; Tue, 29 Dec 2020 09:29:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5703D208BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-UYN2D8pMMoq40F1yqqgixw-1; Tue, 29 Dec 2020 04:29:07 -0500
X-MC-Unique: UYN2D8pMMoq40F1yqqgixw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16FB7800D53;
	Tue, 29 Dec 2020 09:29:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED39671D55;
	Tue, 29 Dec 2020 09:29:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8E5E1809CA2;
	Tue, 29 Dec 2020 09:29:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BT9Sdbd013097 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 29 Dec 2020 04:28:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4AD032026D11; Tue, 29 Dec 2020 09:28:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 459842026D47
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:28:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAF64858284
	for <dm-devel@redhat.com>; Tue, 29 Dec 2020 09:28:36 +0000 (UTC)
Received: from synology.com (mail.synology.com [211.23.38.101]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-475-3LTxNB2XOhC4z2WJx48IHw-1;
	Tue, 29 Dec 2020 04:28:31 -0500
X-MC-Unique: 3LTxNB2XOhC4z2WJx48IHw-1
Received: from localhost.localdomain (unknown [10.17.198.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by synology.com (Postfix) with ESMTPSA id 07179CE781A0;
	Tue, 29 Dec 2020 17:21:11 +0800 (CST)
From: dannyshih <dannyshih@synology.com>
To: axboe@kernel.dk
Date: Tue, 29 Dec 2020 17:18:38 +0800
Message-Id: <1609233522-25837-1-git-send-email-dannyshih@synology.com>
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, snitzer@redhat.com, linux-block@vger.kernel.org,
	song@kernel.org, dm-devel@redhat.com,
	Danny Shih <dannyshih@synology.com>, agk@redhat.com
Subject: [dm-devel] [PATCH 0/4] Fix order when split bio and send remaining
	back to itself
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Danny Shih <dannyshih@synology.com>

We found out that split bios might handle not in order when a big bio
had split by blk_queue_split() and also split in stacking block device,
such as md device because chunk size boundary limit.

Stacking block device normally use submit_bio_noacct() add the remaining
bio to current->bio_list's tail after they split original bio. Therefore,
when bio split first time, the last part of bio was add to bio_list.
After then, when bio split second time, the middle part of bio was add to
bio_list. Results that the middle part is now behind the last part of bio.

For example:
	There is a RAID0 md device, with max_sectors_kb = 2 KB,
	and chunk_size = 1 KB

	1. a read bio come to md device wants to read 0-7 KB
	2. In blk_queue_split(), bio split into (0-1), (2-7),
	   and send (2-7) back to md device

	   current->bio_list = bio_list_on_stack[0]: (md 2-7)
	3. RAID0 split bio (0-1) into (0) and (1), since chunk size is 1 KB
	   and send (1) back to md device

	   bio_list_on_stack[0]: (md 2-7) -> (md 1)
	4. remap and send (0) to lower layer device

	   bio_list_on_stack[0]: (md 2-7) -> (md 1) -> (lower 0)
	5. __submit_bio_noacct() sorting bio let lower bio handle firstly
	   bio_list_on_stack[0]: (lower 0) -> (md 2-7) -> (md 1)
	   pop (lower 0)
	   move bio_list_on_stack[0] to bio_list_on_stack[1]

	   bio_list_on_stack[1]: (md 2-7) -> (md 1)
	6. after handle lower bio, it handle (md 2-7) firstly, and split
	   in blk_queue_split() into (2-3), (4-7), send (4-7) back

	   bio_list_on_stack[0]: (md 4-7)
	   bio_list_on_stack[1]: (md 1)
	7. RAID0 split bio (2-3) into (2) and (3) and send (3) back

	   bio_list_on_stack[0]: (md 4-7) -> (md 3)
	   bio_list_on_stack[1]: (md 1)
	...
	In the end, the split bio handle's order will become
	0 -> 2 -> 4 -> 6 -> 7 -> 5 -> 3 -> 1

Reverse the order of same queue bio when sorting bio in
__submit_bio_noacct() can solve this issue, but it might influence
too much. So we provide alternative version of submit_bio_noacct(),
named submit_bio_noacct_add_head(), for the case which need to add bio
to the head of current->bio_list. And replace submit_bio_noacct() with
submit_bio_noacct_add_head() in block device layer when we want to
split bio and send remaining back to itself.

Danny Shih (4):
  block: introduce submit_bio_noacct_add_head
  block: use submit_bio_noacct_add_head for split bio sending back
  dm: use submit_bio_noacct_add_head for split bio sending back
  md: use submit_bio_noacct_add_head for split bio sending back

 block/blk-core.c       | 44 +++++++++++++++++++++++++++++++++-----------
 block/blk-merge.c      |  2 +-
 block/bounce.c         |  2 +-
 drivers/md/dm.c        |  2 +-
 drivers/md/md-linear.c |  2 +-
 drivers/md/raid0.c     |  4 ++--
 drivers/md/raid1.c     |  4 ++--
 drivers/md/raid10.c    |  4 ++--
 drivers/md/raid5.c     |  2 +-
 include/linux/blkdev.h |  1 +
 10 files changed, 45 insertions(+), 22 deletions(-)

-- 
2.7.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

