Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD9BC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  1 Apr 2022 14:44:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-4fLG1Ig2PXmvZrTDrwXZzQ-1; Fri, 01 Apr 2022 10:44:06 -0400
X-MC-Unique: 4fLG1Ig2PXmvZrTDrwXZzQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BF3C280523A;
	Fri,  1 Apr 2022 14:44:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9045E2166B13;
	Fri,  1 Apr 2022 14:43:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 921681940349;
	Fri,  1 Apr 2022 14:43:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 475C41940349
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Apr 2022 14:43:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0D5D040D2969; Fri,  1 Apr 2022 14:43:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0971B40D2962
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 14:43:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E13C23C01DAA
 for <dm-devel@redhat.com>; Fri,  1 Apr 2022 14:43:42 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-UDSHTx-FPvaKodVBBSTP8A-1; Fri, 01 Apr 2022 10:43:34 -0400
X-MC-Unique: UDSHTx-FPvaKodVBBSTP8A-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8DB4260AC9;
 Fri,  1 Apr 2022 14:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14029C34111;
 Fri,  1 Apr 2022 14:43:31 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Date: Fri,  1 Apr 2022 10:41:32 -0400
Message-Id: <20220401144206.1953700-31-sashal@kernel.org>
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH AUTOSEL 5.10 31/65] dm: requeue IO if mapping
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============0956402302171909367=="

--===============0956402302171909367==
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
index b1e867feb4f6..4833f4b20b2c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -492,8 +492,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ct=
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
index 6030cba5b038..2836d44094ab 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1692,15 +1692,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
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


--===============0956402302171909367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0956402302171909367==--

