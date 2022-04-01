Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31FFC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  1 Apr 2022 14:40:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-RYGeKP1mPxCxv1S7VeSxpg-1; Fri, 01 Apr 2022 10:40:27 -0400
X-MC-Unique: RYGeKP1mPxCxv1S7VeSxpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EC9310666B3;
	Fri,  1 Apr 2022 14:40:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6490840E8848;
	Fri,  1 Apr 2022 14:40:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D13E31947BBF;
	Fri,  1 Apr 2022 14:40:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E65B11947BBE
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Apr 2022 14:40:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C69CDC2810C; Fri,  1 Apr 2022 14:40:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C268DC28106
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 14:40:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A98A9100FBC3
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 14:40:13 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-LcBp-85sNACaU2jWh0q0jg-1; Fri, 01 Apr 2022 10:40:12 -0400
X-MC-Unique: LcBp-85sNACaU2jWh0q0jg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 14798611BC;
 Fri,  1 Apr 2022 14:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050B6C2BBE4;
 Fri,  1 Apr 2022 14:40:09 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Date: Fri,  1 Apr 2022 10:36:54 -0400
Message-Id: <20220401143742.1952163-50-sashal@kernel.org>
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH AUTOSEL 5.15 50/98] dm: requeue IO if mapping
 table not yet available
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
Cc: Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
 Zhang Yi <yi.zhang@huawei.com>, snitzer@kernel.org, dm-devel@redhat.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2809166382420356505=="

--===============2809166382420356505==
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream; x-default=true

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit fa247089de9936a46e290d4724cb5f0b845600f5 ]

Update both bio-based and request-based DM to requeue IO if the
mapping table not available.

This race of IO being submitted before the DM device ready is so
narrow, yet possible for initial table load given that the DM device's
request_queue is created prior, that it best to requeue IO to handle
this unlikely case.

Reported-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-rq.c |  7 ++++++-
 drivers/md/dm.c    | 11 +++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a896dea9750e..53a9b16c7b2e 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -500,8 +500,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ct=
x *hctx,
=20
 =09if (unlikely(!ti)) {
 =09=09int srcu_idx;
-=09=09struct dm_table *map =3D dm_get_live_table(md, &srcu_idx);
+=09=09struct dm_table *map;
=20
+=09=09map =3D dm_get_live_table(md, &srcu_idx);
+=09=09if (unlikely(!map)) {
+=09=09=09dm_put_live_table(md, srcu_idx);
+=09=09=09return BLK_STS_RESOURCE;
+=09=09}
 =09=09ti =3D dm_table_find_target(map, 0);
 =09=09dm_put_live_table(md, srcu_idx);
 =09}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5f33700d1247..73046fd21e47 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1570,15 +1570,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 =09struct dm_table *map;
=20
 =09map =3D dm_get_live_table(md, &srcu_idx);
-=09if (unlikely(!map)) {
-=09=09DMERR_LIMIT("%s: mapping table unavailable, erroring io",
-=09=09=09    dm_device_name(md));
-=09=09bio_io_error(bio);
-=09=09goto out;
-=09}
=20
-=09/* If suspended, queue this IO for later */
-=09if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
+=09/* If suspended, or map not yet available, queue this IO for later */
+=09if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
+=09    unlikely(!map)) {
 =09=09if (bio->bi_opf & REQ_NOWAIT)
 =09=09=09bio_wouldblock_error(bio);
 =09=09else if (bio->bi_opf & REQ_RAHEAD)
--=20
2.34.1


--===============2809166382420356505==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2809166382420356505==--

