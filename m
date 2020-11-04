Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E781C4741F
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:35:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C3CC92080D
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3CC92080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-aiHjliaePXCHQHTrjb6UZA-1; Wed, 04 Nov 2020 02:35:03 -0500
X-MC-Unique: aiHjliaePXCHQHTrjb6UZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B700804750;
	Wed,  4 Nov 2020 07:34:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E96260C84;
	Wed,  4 Nov 2020 07:34:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D57C8181A06E;
	Wed,  4 Nov 2020 07:34:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A43w6tL027697 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 22:58:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 721831016D99; Wed,  4 Nov 2020 03:58:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D2E41134CD2
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 03:58:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AA898582A0
	for <dm-devel@redhat.com>; Wed,  4 Nov 2020 03:58:04 +0000 (UTC)
Received: from out30-43.freemail.mail.aliyun.com
	(out30-43.freemail.mail.aliyun.com [115.124.30.43]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-315-qBYb8FcIPkSIJbsl3imFXg-1;
	Tue, 03 Nov 2020 22:58:01 -0500
X-MC-Unique: qBYb8FcIPkSIJbsl3imFXg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R111e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UE9brMc_1604462276
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UE9brMc_1604462276) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 04 Nov 2020 11:57:56 +0800
From: Jeffle Xu <jefflexu@linux.alibaba.com>
To: snitzer@redhat.com
Date: Wed,  4 Nov 2020 11:57:56 +0800
Message-Id: <20201104035756.127056-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 04 Nov 2020 02:34:40 -0500
Cc: joseph.qi@linux.alibaba.com, dm-devel@redhat.com, neilb@suse.com
Subject: [dm-devel] [PATCH] dm: remove unnecessary bio_list check when
	submitting split bio
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The depth-first splitting is introduced in commit 18a25da84354 ("dm:
ensure bio submission follows a depth-first tree walk"), which is used
to fix the potential deadlock in case of the misordering handling of
bios caused by bio_list. There're two paths submitting split bios,
dm_wq_work() from worker thread and submit_bio() from application. Back
upon that time, dm_wq_work() thread calls __split_and_process_bio()
directly and thus will not trigger this issue since bio_list doesn't
exist here. So this issue will only be triggered from application
calling submit_bio(), and the fix has to check if current->bio_list is
non-NULL to distinguish this case.

However since commit 0c2915b8c6db1 ("dm: fix missing imposition of
queue_limits from dm_wq_work() thread"), dm_wq_work() thread calls
submit_bio_noacct() and thus also uses bio_list. Since then all entries
into __split_and_process_bio() are under protection of bio_list, and
thus the checking of current->bio_list when determinning if the
depth-first principle should be used, seems kind of nonsense. After all
the checking always succeeds now.

But the check should be there from the perspective of design, to make
it a complete fix. So all the details and notes are explained thoroughly
in comments.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c18fc2548518..56f65a5b90f4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1589,7 +1589,15 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 		ci.sector_count = bio_sectors(bio);
 		while (ci.sector_count && !error) {
 			error = __split_and_process_non_flush(&ci);
-			if (current->bio_list && ci.sector_count && !error) {
+			/*
+			 * Depth-first splitting to fix the potential deadlock caused by
+			 * reordering of handling bios because of bio_list. We should enable
+			 * this feature only when bio_list enabled, but the check of
+			 * current->bio_list is not needed any more since all entries into
+			 * __split_and_process_bio (dm_wq_work() from thread and submit_bio()
+			 * from application) are under bio_list now.
+			 */
+			if (ci.sector_count && !error) {
 				/*
 				 * Remainder must be passed to submit_bio_noacct()
 				 * so that it gets handled *after* bios already submitted
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

