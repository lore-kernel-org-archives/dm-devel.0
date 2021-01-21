Return-Path: <SRS0=L0Bp=GY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A582C433E9
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 17:51:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DECE23A03
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jan 2021 17:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DECE23A03
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-BY-CVwbUNoy2X_cEZdPHnw-1; Thu, 21 Jan 2021 12:51:28 -0500
X-MC-Unique: BY-CVwbUNoy2X_cEZdPHnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 603F151A2;
	Thu, 21 Jan 2021 17:51:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFBF41002382;
	Thu, 21 Jan 2021 17:51:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 313E3180954D;
	Thu, 21 Jan 2021 17:51:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10LHpJgL009248 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 21 Jan 2021 12:51:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F6282166B2A; Thu, 21 Jan 2021 17:51:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A8862166B32
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 17:51:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFBFB187504C
	for <dm-devel@redhat.com>; Thu, 21 Jan 2021 17:51:16 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-126-CaIPpPESNQiJpqDuVRhgUg-1;
	Thu, 21 Jan 2021 12:51:14 -0500
X-MC-Unique: CaIPpPESNQiJpqDuVRhgUg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id B7037ABD6;
	Thu, 21 Jan 2021 17:51:12 +0000 (UTC)
From: mwilck@suse.com
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
	Hannes Reinecke <hare@suse.de>
Date: Thu, 21 Jan 2021 18:50:56 +0100
Message-Id: <20210121175056.20078-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10LHpJgL009248
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH v2] dm: avoid filesystem lookup in dm_get_dev_t()
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

From: Hannes Reinecke <hare@suse.de>

This reverts commit
644bda6f3460 ("dm table: fall back to getting device using name_to_dev_t()")

dm_get_dev_t() is just used to convert an arbitrary 'path' string
into a dev_t. It doesn't presume that the device is present; that
check will be done later, as the only caller is dm_get_device(),
which does a dm_get_table_device() later on, which will properly
open the device.
So if the path string already _is_ in major:minor representation
we can convert it directly, avoiding a recursion into the filesystem
to lookup the block device.
This avoids a hang in multipath_message() when the filesystem is
inaccessible.

Fixes: 644bda6f3460 ("dm table: fall back to getting device using name_to_dev_t()")

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/md/dm-table.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 188f41287f18..4acf2342f7ad 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -363,14 +363,23 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 {
 	int r;
 	dev_t dev;
+	unsigned int major, minor;
+	char dummy;
 	struct dm_dev_internal *dd;
 	struct dm_table *t = ti->table;
 
 	BUG_ON(!t);
 
-	dev = dm_get_dev_t(path);
-	if (!dev)
-		return -ENODEV;
+	if (sscanf(path, "%u:%u%c", &major, &minor, &dummy) == 2) {
+		/* Extract the major/minor numbers */
+		dev = MKDEV(major, minor);
+		if (MAJOR(dev) != major || MINOR(dev) != minor)
+			return -EOVERFLOW;
+	} else {
+		dev = dm_get_dev_t(path);
+		if (!dev)
+			return -ENODEV;
+	}
 
 	dd = find_device(&t->devices, dev);
 	if (!dd) {
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

