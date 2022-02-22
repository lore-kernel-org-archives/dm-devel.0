Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F224C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 07:41:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-2N2JRPlkOlqiVR1y3FaXhQ-1; Tue, 22 Feb 2022 02:41:03 -0500
X-MC-Unique: 2N2JRPlkOlqiVR1y3FaXhQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 212E5801AAD;
	Tue, 22 Feb 2022 07:40:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B6FE1053B13;
	Tue, 22 Feb 2022 07:40:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EE20F3795;
	Tue, 22 Feb 2022 07:40:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21M7cfpd002998 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 02:38:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 95BED400E114; Tue, 22 Feb 2022 07:38:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9206A400C849
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 07:38:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 092243C01C04
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 07:38:41 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-623-Vgbuqb7bOc-LDLSythMumw-1; Tue, 22 Feb 2022 02:38:38 -0500
X-MC-Unique: Vgbuqb7bOc-LDLSythMumw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0947C67373; Tue, 22 Feb 2022 08:38:33 +0100 (CET)
Date: Tue, 22 Feb 2022 08:38:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Message-ID: <20220222073833.GA4979@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
	<20220209082828.2629273-8-hch@lst.de>
	<yq135kefh5j.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
In-Reply-To: <yq135kefh5j.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, manoj@linux.ibm.com, linux-scsi@vger.kernel.org,
	philipp.reisner@linbit.com, linux-block@vger.kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	haris.iqbal@ionos.com, ukrishn@linux.ibm.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	jinpu.wang@ionos.com, Christoph Hellwig <hch@lst.de>, mrochs@linux.ibm.com
Subject: Re: [dm-devel] [PATCH 7/7] block: remove REQ_OP_WRITE_SAME support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Feb 19, 2022 at 08:44:18PM -0500, Martin K. Petersen wrote:
> > -static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
> > -{
> > -	return sprintf(page, "%llu\n",
> > -		(unsigned long long)q->limits.max_write_same_sectors << 9);
> > -}
> > -
> 
> This tripped one of my test scripts. We should probably return 0 here
> like we did for discard_zeroes_data and leave the sysfs entry in place.

The maybe fold this in?

---
>From eae8e9b8cff5ee8522b00430a4aabd01ebc7c55a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 22 Feb 2022 08:35:59 +0100
Subject: block: restore the write_same_max sysfs attribute

Some userspace breaks if this attribute is gone.  Restore it and always
return 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4a5bb47bee3ce..431fdd036f65a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -212,6 +212,11 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
 	return queue_var_show(0, page);
 }
 
+static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
+{
+	return sprintf(page, "%llu\n", 0ULL);
+}
+
 static ssize_t queue_write_zeroes_max_show(struct request_queue *q, char *page)
 {
 	return sprintf(page, "%llu\n",
@@ -581,6 +586,7 @@ QUEUE_RO_ENTRY(queue_discard_max_hw, "discard_max_hw_bytes");
 QUEUE_RW_ENTRY(queue_discard_max, "discard_max_bytes");
 QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
 
+QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
 QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_write_granularity, "zone_write_granularity");
@@ -636,6 +642,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_discard_max_entry.attr,
 	&queue_discard_max_hw_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
 	&queue_zone_write_granularity_entry.attr,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

