Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC4E0C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 10:20:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-YaHeieBFNEujWqK3MrYiEw-1; Wed, 15 Jun 2022 06:20:16 -0400
X-MC-Unique: YaHeieBFNEujWqK3MrYiEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2714E1C1CB84;
	Wed, 15 Jun 2022 10:20:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 161E140D2853;
	Wed, 15 Jun 2022 10:20:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD6721947B84;
	Wed, 15 Jun 2022 10:20:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1050D194705C
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 10:20:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2B2C2026D07; Wed, 15 Jun 2022 10:20:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE7352026D64
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C431A802D1F
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:12 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-FckpJMhNNU27MGB1RVUsfQ-1; Wed, 15 Jun 2022 06:20:10 -0400
X-MC-Unique: FckpJMhNNU27MGB1RVUsfQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220615102009euoutp0293bb7f49f9cc738229d7e98071bea759~4xAne4n5z2870528705euoutp02k
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 10:20:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220615102009euoutp0293bb7f49f9cc738229d7e98071bea759~4xAne4n5z2870528705euoutp02k
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220615102008eucas1p2e85d5e1cf2fc269992852614bac65244~4xAl5vWjX0710507105eucas1p2n;
 Wed, 15 Jun 2022 10:20:08 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id DD.4B.09664.752B9A26; Wed, 15
 Jun 2022 11:20:07 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b~4xAlg-xfo0963309633eucas1p1M;
 Wed, 15 Jun 2022 10:20:07 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220615102007eusmtrp2669d4daff88954051642382b44d5908f~4xAlgN9xL0361403614eusmtrp2O;
 Wed, 15 Jun 2022 10:20:07 +0000 (GMT)
X-AuditID: cbfec7f2-d81ff700000025c0-42-62a9b2577ce6
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id 96.34.09038.752B9A26; Wed, 15
 Jun 2022 11:20:07 +0100 (BST)
Received: from localhost (unknown [106.210.248.244]) by eusmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220615102006eusmtip2a812fe6e28f7649ef0489c27adfb5e9f~4xAkoisYR0472904729eusmtip2d;
 Wed, 15 Jun 2022 10:20:06 +0000 (GMT)
From: Pankaj Raghav <p.raghav@samsung.com>
To: hch@lst.de, snitzer@redhat.com, damien.lemoal@opensource.wdc.com,
 axboe@kernel.dk
Date: Wed, 15 Jun 2022 12:19:19 +0200
Message-Id: <20220615101920.329421-13-p.raghav@samsung.com>
In-Reply-To: <20220615101920.329421-1-p.raghav@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsWy7djP87rhm1YmGXTvMLdYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBY3D+xkstizaBKTxcrVR5ksnqyfxWzRc+ADi8XfrntAsZaHQMW3
 tC0u75rDZjF/2VN2i89LW9gt1tx8ymLRtvEro4OQx+Ur3h7/Tqxh89g56y67x+WzpR6bVnWy
 eSxsmMrssXlJvcfumw1Audb7rB7v911l8+jbsorRY/2Wqywem09Xe3zeJOfRfqCbKYA/issm
 JTUnsyy1SN8ugStj0d925oK/vBWr2neyNTDu4O5i5OSQEDCR6J+/lLmLkYtDSGAFo8SpXcvY
 IJwvjBJzpi1kgXA+M0psObycHabl372/rBCJ5YwSM/5eh+p/CVT1fxFQPwcHm4CWRGMnWIOI
 QLjE0T33mEBqmAVeMEksvj2XFSQhLJAicXXhHyYQm0VAVaJjYgczSC+vgLXE/Wd1EMvkJWZe
 +g42hxMovGN2D1grr4CgxMmZT1hAbGagmuats8FukBA4xSmxtesBE0Szi8T3N9PYIGxhiVfH
 t0B9ICPxf+d8qJpqiac3fkM1tzBK9O9cD/aABNC2vjM5ICazgKbE+l36EOWOEgtP9jJDVPBJ
 3HgrCHECn8SkbdOhwrwSHW1CENVKEjt/PoFaKiFxuWkOC4TtIdE0/QXLBEbFWUiemYXkmVkI
 excwMq9iFE8tLc5NTy02zEst1ytOzC0uzUvXS87P3cQITJin/x3/tINx7quPeocYmTgYDzFK
 cDArifCaBa9MEuJNSaysSi3Kjy8qzUktPsQozcGiJM6bnLkhUUggPbEkNTs1tSC1CCbLxMEp
 1cAk53D78Q5e9lOP5svpTrEoLRTfKP1uUnquzel76cGbZJPCw2+kCr2veqH898GS8Cbdr982
 KJ1Rbvq0YsGOj4cCF/YX/Kor3W2QrD9rxo63vGLd+a8nL+mRzow6N/fhrTuhmy2UHIyd5XVP
 P3tyyqJ0YkVKC1uO8RSXF5u37WF8VLNacepc8wO1KevkSud6iZ+v1nB5LBf9MCRgQaF3hdy+
 b3x7FhirXhGb2Ga73KWG5cNUho1z1TKPlsrFHCl+eVTvUMUMAf/i+cfciycuO8uqazArw1Sg
 7NY2k4L+hC0zFFcf0/024Xvw+dUKs8+v4VDIUep//65f8sPjGQxP3Ov9Vktb3T/+//CvU8z/
 F7S7KLEUZyQaajEXFScCABH8nUgHBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t/xe7rhm1YmGbycqmCx+m4/m8W0Dz+Z
 LX6fPc9ssffdbFaLCz8amSxuHtjJZLFn0SQmi5WrjzJZPFk/i9mi58AHFou/XfeAYi0PgYpv
 aVtc3jWHzWL+sqfsFp+XtrBbrLn5lMWibeNXRgchj8tXvD3+nVjD5rFz1l12j8tnSz02repk
 81jYMJXZY/OSeo/dNxuAcq33WT3e77vK5tG3ZRWjx/otV1k8Np+u9vi8Sc6j/UA3UwB/lJ5N
 UX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7Gor/tzAV/
 eStWte9ka2Dcwd3FyMkhIWAi8e/eX9YuRi4OIYGljBKb/jxlhEhISNxe2ARlC0v8udbFBlH0
 nFGit/kuSxcjBwebgJZEYyc7SI2IQLRE5833YDXMAj+YJCYsWguWEBZIkvgx9xmYzSKgKtEx
 sYMZpJdXwFri/rM6iPnyEjMvfQcr4QQK75jdwwpSIiRgJbHrXTxImFdAUOLkzCcsIDYzUHnz
 1tnMExgFZiFJzUKSWsDItIpRJLW0ODc9t9hIrzgxt7g0L10vOT93EyMwsrcd+7llB+PKVx/1
 DjEycTAeYpTgYFYS4TULXpkkxJuSWFmVWpQfX1Sak1p8iNEU6OqJzFKiyfnA1JJXEm9oZmBq
 aGJmaWBqaWasJM7rWdCRKCSQnliSmp2aWpBaBNPHxMEp1cAk9VNiWqrwemXl45Prs6r3zCi/
 u2pPkuiEiS/l9xbuuGrAxaya+vtrdPAH3ob8qxN6b8TV214164gM+cuaJal97Ozs6o2NHaZV
 e45+Ws6qEfztqm78dGVfj2OfDaepH5kjfauE836TGuPppa8uuLS0n5mxQ0+wZOWh3qjHnFf+
 NEp5Lo1czx+6N0nA7N+Eh7eu7E/5bJFYrRL5/6AFm7b3weZ7OUuvFS7znqNdavDqyrM3ZZOa
 f/Cqfu5LrowynrF0zuKbkwN4FgbZuJx5d8Phdeb0nV17AwVWPl38/Puh2Upd5ZPNPBbVPc+V
 SKk7Et3+RVLaYMdTpvtMH6f0uJRNs/0XPmMrb7TuPMPfm7YHKrEUZyQaajEXFScCAJiYyIR1
 AwAA
X-CMS-MailID: 20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b
X-Msg-Generator: CA
X-RootMTR: 20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102007eucas1p1106f9520e2a86beb3792107dffd8071b@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v7 12/13] dm: call dm_zone_endio after the target
 endio callback for zoned devices
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
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_zone_endio() updates the bi_sector of orig bio for zoned devices that
uses either native append or append emulation and it is called before the
endio of the target. But target endio can still update the clone bio
after dm_zone_endio is called, thereby, the orig bio does not contain
the updated information anymore. Call dm_zone_endio for zoned devices
after calling the target's endio function

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
@Damien and @Hannes: I couldn't come up with a testcase that uses endio callback and
zone append or append emulation for zoned devices to test for
regression in this change. It would be great if you can suggest
something. This change is required for the npo2 target as we update the
clone bio sector in the endio callback function and the orig bio should
be updated only after the endio callback for zone appends.

 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3f17fe1de..3a74e1038 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1025,10 +1025,6 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (static_branch_unlikely(&zoned_enabled) &&
-	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
-		dm_zone_endio(io, bio);
-
 	if (endio) {
 		int r = endio(ti, bio, &error);
 		switch (r) {
@@ -1057,6 +1053,10 @@ static void clone_endio(struct bio *bio)
 		}
 	}
 
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    unlikely(blk_queue_is_zoned(bdev_get_queue(bio->bi_bdev))))
+		dm_zone_endio(io, bio);
+
 	if (static_branch_unlikely(&swap_bios_enabled) &&
 	    unlikely(swap_bios_limit(ti, bio)))
 		up(&md->swap_bios_semaphore);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

