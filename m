Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9767AC6FD1D
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680158042;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=k9EFDLNKYt6tgPLxSMT69iyvpu4tHLes7W9Ss6xclrU=;
	b=XIJurq4/5tjeSV+l590yPDm1RGPpSWFD+byFbbhhfAeIsNaEFPSAMzOzG8Q/L0yIfwJiPZ
	LMYpux+PJdVVwFLheaOrD1/DMWvBG0UaJQvjGhtrq0+iYo9oH8NimlEwZ0SVF+mWp71kpl
	25ySgscAnmSgOieh5Y8ckYrZo35YMUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-h1I5hYlzPuOq5mh7pCyfHQ-1; Thu, 30 Mar 2023 02:33:03 -0400
X-MC-Unique: h1I5hYlzPuOq5mh7pCyfHQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA2D9185A7AD;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A02C492B0C;
	Thu, 30 Mar 2023 06:32:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AED171946A43;
	Thu, 30 Mar 2023 06:32:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD905194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 08:26:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 90629202701F; Wed, 29 Mar 2023 08:26:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 88BD5202701E
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AC6B3C025AC
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:26:21 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-yxybhZsCNU-6NyY8acY3mw-1; Wed, 29 Mar 2023 04:26:13 -0400
X-MC-Unique: yxybhZsCNU-6NyY8acY3mw-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230329081634epoutp03808cece50b221d5d1a93698671794cb0~Q1dpT4LtU0379203792epoutp03S
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 08:16:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230329081634epoutp03808cece50b221d5d1a93698671794cb0~Q1dpT4LtU0379203792epoutp03S
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230329081634epcas5p384a60fc6e935d5677d4fd6fdae0febc5~Q1do1vqoW1882518825epcas5p3E;
 Wed, 29 Mar 2023 08:16:34 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4PmfXJ2dzfz4x9Q9; Wed, 29 Mar
 2023 08:16:32 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 C1.20.06765.0E3F3246; Wed, 29 Mar 2023 17:16:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230327084331epcas5p2510ed79d04fe3432c2ec84ce528745c6~QOimo1dPU0968909689epcas5p21;
 Mon, 27 Mar 2023 08:43:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230327084331epsmtrp2fb8c9870f1fe27704e0328bf8f28bf73~QOimnxreA2690426904epsmtrp2Q;
 Mon, 27 Mar 2023 08:43:31 +0000 (GMT)
X-AuditID: b6c32a4b-46dfa70000011a6d-23-6423f3e00c8b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 A9.4C.18071.33751246; Mon, 27 Mar 2023 17:43:31 +0900 (KST)
Received: from green5.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230327084327epsmtip160db9f1d1db73f5d72d3f78f49ac1595~QOijROTfK3005130051epsmtip15;
 Mon, 27 Mar 2023 08:43:27 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike
 Snitzer <snitzer@kernel.org>, dm-devel@redhat.com, Keith Busch
 <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Chaitanya
 Kulkarni <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Date: Mon, 27 Mar 2023 14:10:57 +0530
Message-Id: <20230327084103.21601-10-anuj20.g@samsung.com>
In-Reply-To: <20230327084103.21601-1-anuj20.g@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH87u3vRRI3eVh9pNlrrkbYTh5KZQfaHUPt90EXRqXSOJmSkdv
 CoM+1tuObbJZxlAeARSQuIIylZGAmUBhrDxqWBFYOx6aCgiZwrSIHfIQzESYspbC5n+fc873
 5Jzz/eXHw/3PeAXxUpVaRqOUplOED6elKzQ0bGLxVVnk0qIvqrf14Ojbk09xdOlWMYGmuxYA
 Kp9/gqOV/kEcmWcruGi0sxVDHRdKMFR7qRtD7ecfYqh7dYZAJZZhgCaHDBgyj72BOsxWDrK3
 VRKoqmbSC1lKszFkcmQB1LJShaPL03Mc9NvYS+huQS5Ag097uW9uoe03EmjDeD9BtxpuedGD
 txs5tL1fRxvr8gi6qfoY3T6qJ+jC7FmXIGecS89dGSLoouY6QDf9fpReNG6ljY4ZTPzC4bTd
 KYxUxmgEjDJZJUtVykVUwoeSdyQxwsiosKg4FEsJlFIFI6L27ReHvZea7jKDEnwuTde5UmIp
 y1IRe3ZrVDotI0hRsVoRxahl6epodTgrVbA6pTxcyWjjoyIjd8S4hElpKTd7sgh1VvAXlpZO
 oAc3t+YDbx4ko6EpX++VD3x4/mQ7gI+WywhPsACg80wx7gn+BvBGcy53o2X0bCvHUzAD2FLk
 XA+yMVjzpBe4VQQZAq9O5QB3IZA8jsOHk3lrKpzMwaGj0+TlVgWQe+C9yuK1Dg4ZDB8s5HLc
 zCfj4Yy92qXhueZFwOJxP3fa25WuNNm4HokftH7vWJPj5Csw++eKtV0hWe8Ns8obOZ5d98Hl
 Cifu4QD4V2+zl4eD4OKsmfCwHC7ZJzEPq2F2zxXg4b0wx+Y2gOcaEArr2yI86ZfhadtlzDN3
 Eyxccay38qHp3AZT8ERt5TpDaB7QrzMNa0uG1g0uBPBi6SpxEggMz91jeO4ew/+jfwB4HdjC
 qFmFnGFj1DuVTMZ/75ysUhjB2hfZlmACdybmwy0A4wELgDycCuSvDFMyf75M+uVXjEYl0ejS
 GdYCYlx+n8KDNierXH9MqZVERcdFRguFwui4ncIo6kV+iMia7E/KpVomjWHUjGajD+N5B+kx
 MpXutB/elbHaydrbdlivNpKiB9gH1WXL796BpyXbq0JNzpkfhwt+3XV8WmG1HvLdzt178TMM
 tzYcva6IOzD3S9LrbWevOQcO+Y4smI0ZIwESWH9BCrKLngXmKaR9iY63BhwnQpfePhCXlsn/
 mq2YbeqoKDvvVNret7ApMzF+xoa6ubGPk3jlR1qmM5uonxqmDROncq6F8CLvHxxZnkr+VCSA
 /lN5jzfdTqqfbPVXPy44do9rDG40xOYNqkvrz3X/08XVfhKf2KfiBXFe436XKH7EyJdtfqN4
 7p99YtGR+Tbhviy8SVyz3+dZpk2XFrt6v/EjPX4w/Y+7Dd9cZzeHUhw2RRq1Ddew0n8BLZKS
 8asEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02RXUhTcRjG+59zPDtKq9NM+qtlOVyR0aYk9q+p1YV1TBCjiyAJPbTDFOca
 W2bZhZpFaphiaDQtrURwluY0dX5kbM38QK1Mc5UOvyl11srIrMwpgXfP+/ye93kvXgoX9BAe
 VJzyPKdWsgoh6ULUmYRee/ed8pb5WeY8UVVnG46u5P7BUcVQDommTXaACr4s4GixuxdHLbZC
 J2R5bsBQ84M8DJVXmDHUdP8rhsxLsyTKMw4ANNGvxVDL+z2ouaWDQH2NRSQqLpvgIeOtdAw1
 jKcBVLdYjKPK6TkCtb/3RGM3MgDq/fPS6bA70/c2nNFau0nGoB3iMb3D1QTT153I6HWZJFNT
 msI0WVJJJjvdthy4ZnVi5p71k8zNWh1garouM9/0Xox+fBaL3HjaJUjGKeIucGpJSIxL7GBb
 GqlKE1001j0HqWDQKws4U5AOgJa7BiILuFACugnAYesgbxVA2PmpDKxqV1j+d4q3GkrD4HD9
 B9IBSHoXfDF1DTjAZjoXh2+sqaRjwOl8HM43zaykXOkQOFmUs1JF0CI4Y88gHJpPH4SzfaXL
 tdTyCQnMsW5y2M7LdlFDp5NDC+gDMOd6I7Ya3wQ77oyvrOL0dpj+tBDPBbR2DdKuQSUA0wF3
 TqVJkCdo/FX+Si5JrGETNIlKufjsuQQ9WHm57+4GUK/7IjYCjAJGAClcuJlfE+4tE/Bl7KVk
 Tn0uWp2o4DRG4EkRwi38V1kd0QJazp7n4jlOxan/U4xy9kjFfN1c3UoOKddlB2dazPkege1s
 qymmIyoyv2ubfGS96d1o9IawHb9TQntCjmbunxjpnFL4iVKyg1UvfJZih47n9e+sPKHXLurm
 I+JLXonrJFXxrDnF0h7m7i7de+90cfXV2xHeW1WJvTLFR1FrHvXWZrvbKOVL9/+OSBaN5i6x
 twbehc5vYUft/d+NlqSBRw/fFMRUdr3OL7vsE1JwhCf80Rr0aPikMPSMZN5kLRz5Fbh0TDnX
 fHAGuXlMTk9Mnj159adVabQ9wb3k5YZZXpv08RCK66GlmF4XXiEB3+szx0oDxFFhBrvZ78T1
 NkXSgn477RwVGfvZPr4QXR9VKyQ0say/L67WsP8A07UlKmEDAAA=
X-CMS-MailID: 20230327084331epcas5p2510ed79d04fe3432c2ec84ce528745c6
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084331epcas5p2510ed79d04fe3432c2ec84ce528745c6
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084331epcas5p2510ed79d04fe3432c2ec84ce528745c6@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: [dm-devel] [PATCH v8 9/9] null_blk: add support for copy offload
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
Cc: Vincent Fu <vincent.fu@samsung.com>, bvanassche@acm.org,
 joshi.k@samsung.com, gost.dev@samsung.com, anuj20.g@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, nitheshshetty@gmail.com,
 linux-fsdevel@vger.kernel.org, damien.lemoal@opensource.wdc.com,
 Nitesh Shetty <nj.shetty@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nitesh Shetty <nj.shetty@samsung.com>

Implementaion is based on existing read and write infrastructure.

Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 drivers/block/null_blk/main.c     | 94 +++++++++++++++++++++++++++++++
 drivers/block/null_blk/null_blk.h |  7 +++
 2 files changed, 101 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 9e6b032c8ecc..84c5fbcd67a5 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1257,6 +1257,81 @@ static int null_transfer(struct nullb *nullb, struct page *page,
 	return err;
 }
 
+static inline int nullb_setup_copy_read(struct nullb *nullb,
+		struct bio *bio)
+{
+	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
+
+	memcpy(token->subsys, "nullb", 5);
+	token->sector_in = bio->bi_iter.bi_sector;
+	token->nullb = nullb;
+	token->sectors = bio->bi_iter.bi_size >> SECTOR_SHIFT;
+
+	return 0;
+}
+
+static inline int nullb_setup_copy_write(struct nullb *nullb,
+		struct bio *bio, bool is_fua)
+{
+	struct nullb_copy_token *token = bvec_kmap_local(&bio->bi_io_vec[0]);
+	sector_t sector_in, sector_out;
+	void *in, *out;
+	size_t rem, temp;
+	unsigned long offset_in, offset_out;
+	struct nullb_page *t_page_in, *t_page_out;
+	int ret = -EIO;
+
+	if (unlikely(memcmp(token->subsys, "nullb", 5)))
+		return -EOPNOTSUPP;
+	if (unlikely(token->nullb != nullb))
+		return -EOPNOTSUPP;
+	if (WARN_ON(token->sectors != bio->bi_iter.bi_size >> SECTOR_SHIFT))
+		return -EOPNOTSUPP;
+
+	sector_in = token->sector_in;
+	sector_out = bio->bi_iter.bi_sector;
+	rem = token->sectors << SECTOR_SHIFT;
+
+	spin_lock_irq(&nullb->lock);
+	while (rem > 0) {
+		temp = min_t(size_t, nullb->dev->blocksize, rem);
+		offset_in = (sector_in & SECTOR_MASK) << SECTOR_SHIFT;
+		offset_out = (sector_out & SECTOR_MASK) << SECTOR_SHIFT;
+
+		if (null_cache_active(nullb) && !is_fua)
+			null_make_cache_space(nullb, PAGE_SIZE);
+
+		t_page_in = null_lookup_page(nullb, sector_in, false,
+			!null_cache_active(nullb));
+		if (!t_page_in)
+			goto err;
+		t_page_out = null_insert_page(nullb, sector_out,
+			!null_cache_active(nullb) || is_fua);
+		if (!t_page_out)
+			goto err;
+
+		in = kmap_local_page(t_page_in->page);
+		out = kmap_local_page(t_page_out->page);
+
+		memcpy(out + offset_out, in + offset_in, temp);
+		kunmap_local(out);
+		kunmap_local(in);
+		__set_bit(sector_out & SECTOR_MASK, t_page_out->bitmap);
+
+		if (is_fua)
+			null_free_sector(nullb, sector_out, true);
+
+		rem -= temp;
+		sector_in += temp >> SECTOR_SHIFT;
+		sector_out += temp >> SECTOR_SHIFT;
+	}
+
+	ret = 0;
+err:
+	spin_unlock_irq(&nullb->lock);
+	return ret;
+}
+
 static int null_handle_rq(struct nullb_cmd *cmd)
 {
 	struct request *rq = cmd->rq;
@@ -1267,6 +1342,14 @@ static int null_handle_rq(struct nullb_cmd *cmd)
 	struct req_iterator iter;
 	struct bio_vec bvec;
 
+	if (rq->cmd_flags & REQ_COPY) {
+		if (op_is_write(req_op(rq)))
+			return nullb_setup_copy_write(nullb, rq->bio,
+						rq->cmd_flags & REQ_FUA);
+		else
+			return nullb_setup_copy_read(nullb, rq->bio);
+	}
+
 	spin_lock_irq(&nullb->lock);
 	rq_for_each_segment(bvec, rq, iter) {
 		len = bvec.bv_len;
@@ -1294,6 +1377,14 @@ static int null_handle_bio(struct nullb_cmd *cmd)
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 
+	if (bio->bi_opf & REQ_COPY) {
+		if (op_is_write(bio_op(bio)))
+			return nullb_setup_copy_write(nullb, bio,
+							bio->bi_opf & REQ_FUA);
+		else
+			return nullb_setup_copy_read(nullb, bio);
+	}
+
 	spin_lock_irq(&nullb->lock);
 	bio_for_each_segment(bvec, bio, iter) {
 		len = bvec.bv_len;
@@ -2146,6 +2237,9 @@ static int null_add_dev(struct nullb_device *dev)
 	list_add_tail(&nullb->list, &nullb_list);
 	mutex_unlock(&lock);
 
+	blk_queue_max_copy_sectors_hw(nullb->disk->queue, 1024);
+	blk_queue_flag_set(QUEUE_FLAG_COPY, nullb->disk->queue);
+
 	pr_info("disk %s created\n", nullb->disk_name);
 
 	return 0;
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index eb5972c50be8..94e524e7306a 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -67,6 +67,13 @@ enum {
 	NULL_Q_MQ	= 2,
 };
 
+struct nullb_copy_token {
+	char subsys[5];
+	struct nullb *nullb;
+	u64 sector_in;
+	u64 sectors;
+};
+
 struct nullb_device {
 	struct nullb *nullb;
 	struct config_item item;
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

