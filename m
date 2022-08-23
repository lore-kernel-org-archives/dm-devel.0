Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7685C32774
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 12:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661257163;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3LL+f4cbT6rsq5qe9nigbY7ms+8YbvTlDVxAuid6Rbk=;
	b=SnLy9LJyJs8tgt+VvRWyuXBiRlXeuvZyHuDeF+Fj3sgIgMJ6l0oGSNmKQB+hZ20UqHJJo+
	RsB3hudy/MonJ1w25esfpC+964J70Ya91Lm0yLTWLOILWs5Go7MWVSRvpfILIJldKJcMAe
	w7w4CAdJIz5Rn6eHysGL2wZAVcEL3OM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-O2sDYvWENjS5if4YuOSDrQ-1; Tue, 23 Aug 2022 08:19:20 -0400
X-MC-Unique: O2sDYvWENjS5if4YuOSDrQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 261C03C0D857;
	Tue, 23 Aug 2022 12:19:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12BACC15BB3;
	Tue, 23 Aug 2022 12:19:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 009731946A47;
	Tue, 23 Aug 2022 12:19:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A98461946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E31CC15BBA; Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9904FC15BC0
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EE83382ECCE
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:17 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-jOla4S1XMzuupGRy8GYsJQ-1; Tue, 23 Aug 2022 08:19:15 -0400
X-MC-Unique: jOla4S1XMzuupGRy8GYsJQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20220823121914euoutp0149a2e25708f5e5623124248028337898~N_JSfFQ4U1942519425euoutp01g
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 12:19:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20220823121914euoutp0149a2e25708f5e5623124248028337898~N_JSfFQ4U1942519425euoutp01g
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220823121912eucas1p2e8f19f59fde5e7242ae317e574bfe0ec~N_JQo_25C2219222192eucas1p2f;
 Tue, 23 Aug 2022 12:19:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 51.92.29727.0C5C4036; Tue, 23
 Aug 2022 13:19:12 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220823121912eucas1p18223e1b04b65a8a10f6c50187e7474ea~N_JP-yQ0B1882018820eucas1p1W;
 Tue, 23 Aug 2022 12:19:12 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220823121912eusmtrp25ede222dcc699b75396ed2ec6947dd4e~N_JP_5LBT2723427234eusmtrp2l;
 Tue, 23 Aug 2022 12:19:12 +0000 (GMT)
X-AuditID: cbfec7f2-21dff7000001741f-97-6304c5c0c0c5
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 3A.12.07473.FB5C4036; Tue, 23
 Aug 2022 13:19:12 +0100 (BST)
Received: from localhost (unknown [106.210.248.52]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220823121911eusmtip21e834d44802a27da7ae0b65ee5c12be9~N_JPr2CtE1999619996eusmtip2Q;
 Tue, 23 Aug 2022 12:19:11 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, hch@lst.de
Date: Tue, 23 Aug 2022 14:18:56 +0200
Message-Id: <20220823121859.163903-11-p.raghav@samsung.com>
In-Reply-To: <20220823121859.163903-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7djP87oHjrIkG9yZpmOx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBEcdmkpOZklqUW6dslcGVcvn+HteAI
 b8Wqhy2MDYwfuLoYOTkkBEwkPiw4xNjFyMUhJLCCUeLZuu9QzhdGiYMbbrJBOJ8ZJU73H2ft
 YuQAazk2LR0ivpxR4lvzHFYI5wWjxNsNh1lAitgEtCQaO9lBVogIpEt8/boBbCqzwDYmiV93
 L7GAJIQFIiVW/z/CBGKzCKhK/Gp+DxbnFbCW+HGlgQniPnmJmZe+gw3iBIrPW3qKEaJGUOLk
 zCdg9cxANc1bZzODLJAQ2MwpsfLHfRaIZheJu5ceMkLYwhKvjm9hh7BlJP7vnA+1oFri6Y3f
 UM0tjBL9O9ezQbxpLdF3JgfEZBbQlFi/Sx+i3FFi35rzTBAVfBI33gpCnMAnMWnbdGaIMK9E
 R5sQRLWSxM6fT6CWSkhcbpoDdZiHxJIn21gmMCrOQvLMLCTPzELYu4CReRWjeGppcW56arFh
 Xmq5XnFibnFpXrpecn7uJkZgGjz97/inHYxzX33UO8TIxMF4iFGCg1lJhLf6IkOyEG9KYmVV
 alF+fFFpTmrxIUZpDhYlcd7kzA2JQgLpiSWp2ampBalFMFkmDk6pBiaFrpdR5ckHDm6ev3WP
 ukWLs8Cvc6t2mcrJLDH1/RB9MWx1uozwy7MmNmmn38ypLr44a9Zd+UxWzoi8wEaZlus/9Vm2
 mv27vmPxSpErTz2Elq2bMo2vdZkY151TU9bNbos12CfOdWxqccjBr5V6rF7XD665FfIpheOf
 eoW0PWvG9ebE0sKMj0c2PipVD+vc4X489bZfm1r+Fo2rNwrylm479bVB/dz1wEaOKRkRVyW2
 BZxuLeU/eMb8d+jWeScKnJXXP0k8fkhw2c+Km5c2R8dFfeVOUTg5wTTPu9J7LtPTc4LVnA0T
 qg8Zvy/8VCuhpHKr9o8b/49E3QXsfRLvl1rs6JL54r04ujU0qNdaW0uJpTgj0VCLuag4EQCz
 d4wH8gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xe7oHjrIkG+yYyGSx/tQxZovVd/vZ
 LKZ9+Mls8fvseWaLve9ms1rcPLCTyWLPoklMFitXH2WyeLJ+FrPF3657TBZ7b2lbXN41h81i
 /rKn7BYT2r4yW3xe2sJusebmUxaLE7ekHQQ9Ll/x9tg56y67x+WzpR6bVnWyeWxeUu+x+2YD
 m8fO1vusHu/3XWXz6NuyitFj8+lqj8+b5DzaD3QzBfBE6dkU5ZeWpCpk5BeX2CpFG1oY6Rla
 WugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GVcvn+HteAIb8Wqhy2MDYwfuLoYOTgkBEwk
 jk1L72Lk4hASWMoo8fblP5YuRk6guITE7YVNjBC2sMSfa11sEEXPGCXOz9nMBtLMJqAl0djJ
 DlIjIpArcXjzBCaQGmaBI0wSqxvXsoIkhAXCJSZfPMUEYrMIqEr8an4PtoBXwFrix5UGJogF
 8hIzL30HG8QJFJ+39BTYYiEBK4n5tz6xQdQLSpyc+QSslxmovnnrbOYJjAKzkKRmIUktYGRa
 xSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERix24793LyDcd6rj3qHGJk4GA8xSnAwK4nwVl9k
 SBbiTUmsrEotyo8vKs1JLT7EaAp090RmKdHkfGDKyCuJNzQzMDU0MbM0MLU0M1YS5/Us6EgU
 EkhPLEnNTk0tSC2C6WPi4JRqYNr2N3V3WdvXH3GSXyqOF0xe9u7xw3lzzhus2GwTb6Xv5hhR
 Xnsq+TTjlf/fLRj6/lp+PHRQPjLkwG8tzSN2mu0vpnZNK3n85sDjHYyZhx6rlrKzh3YFXz2z
 4GBU65s5H47YW2v07fg5vXa75QXtlZMcz2rMLQhssdfe2JtxO2+N7tHXm20znkUk9Eositlf
 4SbYVjDt6/frEsqlv3blXPLkZT4/U7SM7yp7l7j1xoc3zx6ISfv5sU25IG3KXre/7Dxh9x9V
 5Jz6Uv/OTWzdSemcf599zvnHfvXdd8f+e9wa9dh3/723cSfKn5yUZxOy8e6z/S0F5Vtv3+H+
 /+h71ZurK+qfTvVZVXel+89GpV3eSizFGYmGWsxFxYkAvoYeHWEDAAA=
X-CMS-MailID: 20220823121912eucas1p18223e1b04b65a8a10f6c50187e7474ea
X-Msg-Generator: CA
X-RootMTR: 20220823121912eucas1p18223e1b04b65a8a10f6c50187e7474ea
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220823121912eucas1p18223e1b04b65a8a10f6c50187e7474ea
References: <20220823121859.163903-1-p.raghav@samsung.com>
 <CGME20220823121912eucas1p18223e1b04b65a8a10f6c50187e7474ea@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v12 10/13] dm-table: allow zoned devices with non
 power-of-2 zone sizes
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, bvanassche@acm.org,
 pankydev8@gmail.com, Johannes.Thumshirn@wdc.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, gost.dev@samsung.com, jaegeuk@kernel.org,
 matias.bjorling@wdc.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Allow dm to support zoned devices with non power-of-2(po2) zone sizes as
the block layer now supports it.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/md/dm-table.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 332f96b58252..31eb1d29d136 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -250,7 +250,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
-		if (start & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, start)) {
 			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)start,
@@ -267,7 +267,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, len)) {
 			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
 			       dm_device_name(ti->table->md),
 			       (unsigned long long)len,
@@ -1642,8 +1642,7 @@ static int validate_hardware_zoned_model(struct dm_table *t,
 		return -EINVAL;
 	}
 
-	/* Check zone size validity and compatibility */
-	if (!zone_sectors || !is_power_of_2(zone_sectors))
+	if (!zone_sectors)
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(t, device_not_matches_zone_sectors, &zone_sectors)) {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

