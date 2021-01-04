Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53CCC433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 260E7206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 260E7206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-MB9FsxDHO7moPZwR4o4OHA-1; Mon, 04 Jan 2021 14:04:47 -0500
X-MC-Unique: MB9FsxDHO7moPZwR4o4OHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E69BE800D55;
	Mon,  4 Jan 2021 19:04:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C49761001281;
	Mon,  4 Jan 2021 19:04:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 95F481809CA4;
	Mon,  4 Jan 2021 19:04:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104Am4op002629 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 05:48:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A5022111C4BE; Mon,  4 Jan 2021 10:48:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A096C111C4AF
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 10:48:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4680C811E85
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 10:48:02 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-553-9Y4cCBAzM4WSXlDm8nrlCA-1; Mon, 04 Jan 2021 05:48:00 -0500
X-MC-Unique: 9Y4cCBAzM4WSXlDm8nrlCA-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id
	20210104104757epoutp01d436e45c96dd9adeaa6f2814a1190a82~XAbcA3zI92201622016epoutp01U
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 10:47:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
	20210104104757epoutp01d436e45c96dd9adeaa6f2814a1190a82~XAbcA3zI92201622016epoutp01U
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20210104104756epcas5p2463d7073352e6e05c863a2e0fa5e6c3e~XAbbZzIUP1369413694epcas5p2K;
	Mon,  4 Jan 2021 10:47:56 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	54.EB.15682.C52F2FF5; Mon,  4 Jan 2021 19:47:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7~XAW5TGqSH1410114101epcas5p2B;
	Mon,  4 Jan 2021 10:42:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210104104245epsmtrp26734063a694e2facc96f3b410277c463~XAW5L3Al02765227652epsmtrp2a;
	Mon,  4 Jan 2021 10:42:45 +0000 (GMT)
X-AuditID: b6c32a49-8bfff70000013d42-ee-5ff2f25c2282
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E8.49.13470.421F2FF5; Mon,  4 Jan 2021 19:42:44 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20210104104241epsmtip117c7fe2b1a2f9988eaeba82911994104~XAW2Q7Njl1453914539epsmtip1b;
	Mon,  4 Jan 2021 10:42:41 +0000 (GMT)
From: SelvaKumar S <selvakuma.s1@samsung.com>
To: linux-nvme@lists.infradead.org
Date: Mon,  4 Jan 2021 16:11:57 +0530
Message-Id: <20210104104159.74236-2-selvakuma.s1@samsung.com>
In-Reply-To: <20210104104159.74236-1-selvakuma.s1@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGc+69vb0tKbsWMo7dB9Aom5DyETc9Wza3xLndxX/MMrO5oKzC
	DcWVj7QwUDZlgiJVCzYOpaJgZYpFC9auVrTLUgQFQxBaKOLAGgvJrNgKzAkIDHpr5n/P+z7P
	e37nPTkULi4jJVRWTj6rypErpaSQsLateleWOjGRlrzvVDRqGq4kUXVgGkf7yp9hyP7kBA9d
	N+gwdL6pHUMP/5rkoznNCIbaF8ZJpHMMAGQfSkDO1loS1Z0d5aODbhuJzt2cx9CRA/0Yss7W
	4ch11IAjk89PII/fzUe+550k2n/pH/Dp64zTtZG5qh/mMz0jlwjG2V3AmI0VJHO5YQ9z7W4J
	yTwdHSIY/x/9JKO1GAFz+XYxM2l+myn/8yC2SfSd8KMMVpn1I6tKWve9UOE/PsDPqwovap9q
	wUpAV5gGCChIvwc7DvmABggpMX0NwIaxoVAxAeBJU3WoeAbgea2F93KkaspJcIYdwKML0yRX
	TAKor19yBBRJy+BAgzmoI2kpnGveG5zA6bs47JuZ4C8ZETSC023a4LEEvRLWLpTiS1pEfwxv
	/XIM53DRsKbv32BeQK+Dut4RHpdZBjtrvEEAvpgp/f0EvgSAdKUAuuc1obt+Bp2BbsDpCPjo
	poXPaQmcfGInOV0IxyqqMU6XAKj1F3L6E9h7fW6xTy0CVsHm1iSu/Rb8tcuEcdxweHjWGxoV
	QdspbzAO6TjYdWUN134TBtpaQyQGGi6OhR7rCIBlY2aiCsToX1lH/8o6+v/J9QA3guVsnjo7
	k1W/n5eSwxYmquXZ6oKczMT03GwzCH7U+C9tYNgTSHQAjAIOAClcGikquhNIE4sy5Dt3sarc
	NFWBklU7wBsUIY0S2ZI9aWI6U57P/sCyeazqpYtRAkkJFrE5Zvy1M8Tgtx483bet+N5WWYbV
	FnflflR0pCRMMZVrsmlelO7t9/y02rsz8/nf2kaXtskY/dvatalK4eeuD6KKzxXFpLu6hsYt
	j4+fnEp8VEd2bGml989b6kt1CYbtFO0ji3vmktjRGzyJ9fYunTN2ueVxVqxq5mf4UNe4w9zL
	+3Bw02ysOHmwOX91U0vGA3G57FDkmZGvuosku+35nTVr/CJlXP0txwWrJ15m2DaTsv2GwtRR
	G9GyQ+7s2ZNt++a0uW5LWGPhF4qY9cr1XrbiqnTD7gP37pStVPRprA+OJbj7X6Su6D1bHc5W
	VjVI4y5u2NgpdT995/DXCfeNulwpoVbIU+JxlVr+H94mhXkXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWy7bCSnK7Kx0/xBj1XTCxW3+1ns5j24Sez
	RWv7NyaLve9ms1rsWTSJyWLl6qNMFo/vfGa3+Nt1j8ni6P+3bBaTDl1jtNh7S9vi8q45bBbz
	lz1lt+i+voPNYvnxf0wWEzuuMlls+z2f2eLKlEXMFutev2exePD+OrvF6x8n2SzaNn5ldBDz
	uHzF22PnrLvsHufvbWTxuHy21GPTqk42j81L6j1232xg8/j49BaLx/t9V9k8+rasYvTYfLra
	4/MmOY/2A91MAbxRXDYpqTmZZalF+nYJXBnvZ1xjL5jAV3H0ywamBsZT3F2MnBwSAiYSE75c
	Zuli5OIQEtjNKDH19zMmiISMxNq7nWwQtrDEyn/P2SGKPjJK3Fx8GizBJqArcW3JJhYQW0RA
	SeLv+iawScwCn5kl5u9qA0sIC1hI/DzcxwpiswioSsz538wMYvMK2EqcaJzODLFBXmLmpe/s
	IDangJ3EpIv3gOo5gLbZSixqFYYoF5Q4OfMJ2EhmoPLmrbOZJzAKzEKSmoUktYCRaRWjZGpB
	cW56brFhgWFearlecWJucWleul5yfu4mRnDMamnuYNy+6oPeIUYmDsZDjBIczEoivBUXPsQL
	8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwHT5W7mz2e6T
	ky+knWLJuV+ldKnq7tzyTrsFaS+E89Tyly+M1mUW2DIj5EtfoULmiZA3B7/WOgU5sXUZ3e/v
	/3vDjHFqpn9a+t6eZ1MqwxTjSycwrhGLOLmf9Rszm5HmrlhrQct7i39+PsVx8+k075Kcn7w7
	PwoZyjvUT7vtffRwq8GBpxJHnb5+4Ln01vq9I7PubNWNbgu2/FixmWHHyr/22Sd396W+3JB+
	3WLJinfntlUE+nH7zrRw5Gd46Xj9+ERuN8tf7Qsj9nxMnzfr5irZL+dmpUe6iMpMDCrKyHxl
	v8TyzZ6U1uKoCZ1aujXrlN99cDyi7tQ6LSNpdyPX1j/fRfVMDCoOSV87tG7t5HAlluKMREMt
	5qLiRADXL7wrSAMAAA==
X-CMS-MailID: 20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
	<CGME20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 104Am4op002629
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Cc: axboe@kernel.dk, damien.lemoal@wdc.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	linux-scsi@vger.kernel.org, selvajove@gmail.com,
	Johannes.Thumshirn@wdc.com, snitzer@redhat.com,
	linux-kernel@vger.kernel.org, nj.shetty@samsung.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	mpatocka@redhat.com, joshi.k@samsung.com,
	martin.petersen@oracle.com, kbusch@kernel.org,
	javier.gonz@samsung.com, hch@lst.de, bvanassche@acm.org
Subject: [dm-devel] [RFC PATCH v4 1/3] block: export bio_map_kern()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Export bio_map_kern() so that copy offload emulation can use
it to add vmalloced memory to bio.

Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
---
 block/blk-map.c        | 3 ++-
 include/linux/blkdev.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 21630dccac62..50d61475bb68 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -378,7 +378,7 @@ static void bio_map_kern_endio(struct bio *bio)
  *	Map the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_map_kern(struct request_queue *q, void *data,
+struct bio *bio_map_kern(struct request_queue *q, void *data,
 		unsigned int len, gfp_t gfp_mask)
 {
 	unsigned long kaddr = (unsigned long)data;
@@ -428,6 +428,7 @@ static struct bio *bio_map_kern(struct request_queue *q, void *data,
 	bio->bi_end_io = bio_map_kern_endio;
 	return bio;
 }
+EXPORT_SYMBOL(bio_map_kern);
 
 static void bio_copy_kern_endio(struct bio *bio)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 070de09425ad..81f9e7bec16c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -936,6 +936,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
 extern int blk_rq_unmap_user(struct bio *);
+extern struct bio *bio_map_kern(struct request_queue *q, void *data,
+				unsigned int len, gfp_t gfp_mask);
 extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, const struct iov_iter *,
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

