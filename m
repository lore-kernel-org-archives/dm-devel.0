Return-Path: <SRS0=/8Iv=JS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7151AC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:46:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E11F060232
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:46:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E11F060232
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-XB3M5eQyPfK6Q97Jc-yoSw-1; Wed, 21 Apr 2021 12:46:48 -0400
X-MC-Unique: XB3M5eQyPfK6Q97Jc-yoSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1392A192205F;
	Wed, 21 Apr 2021 16:46:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC78F6085A;
	Wed, 21 Apr 2021 16:46:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE5F81806D1C;
	Wed, 21 Apr 2021 16:46:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13LGkUjP013378 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Apr 2021 12:46:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A770820FD3BC; Wed, 21 Apr 2021 16:46:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0CCA20FD3B8
	for <dm-devel@redhat.com>; Wed, 21 Apr 2021 16:46:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42760858EFF
	for <dm-devel@redhat.com>; Wed, 21 Apr 2021 16:46:28 +0000 (UTC)
Received: from mx2.veeam.com (mx2.veeam.com [64.129.123.6]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-356-xk2P7MXoOWOcwHK3RsIUYA-1;
	Wed, 21 Apr 2021 12:46:21 -0400
X-MC-Unique: xk2P7MXoOWOcwHK3RsIUYA-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.veeam.com (Postfix) with ESMTPS id 55116424B9;
	Wed, 21 Apr 2021 12:46:16 -0400 (EDT)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.858.5; Wed, 21 Apr 2021 18:46:00 +0200
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, 
	<dm-devel@redhat.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 21 Apr 2021 19:45:45 +0300
Message-ID: <1619023545-23431-5-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1619023545-23431-1-git-send-email-sergei.shtepa@veeam.com>
References: <1619023545-23431-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx02.amust.local (172.24.0.172) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29D2A50B59677566
X-Veeam-MMEX: True
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: pavel.tide@veeam.com, sergei.shtepa@veeam.com
Subject: [dm-devel] [PATCH v9 4/4] Using dm_get_device_ex() instead of
	dm_get_device()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Not every DM target needs the ability to attach via blk_interposer.
A DM target can attach and detach 'on the fly' only if the DM
target works as a filter without changing the location of the blocks
on the block device.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/dm-cache-target.c | 5 +++--
 drivers/md/dm-delay.c        | 3 ++-
 drivers/md/dm-dust.c         | 3 ++-
 drivers/md/dm-era-target.c   | 4 +++-
 drivers/md/dm-flakey.c       | 3 ++-
 drivers/md/dm-linear.c       | 3 ++-
 drivers/md/dm-log-writes.c   | 3 ++-
 drivers/md/dm-snap.c         | 3 ++-
 drivers/md/dm-writecache.c   | 3 ++-
 9 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 541c45027cc8..885a6fde1b9b 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2140,8 +2140,9 @@ static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
 	if (!at_least_one_arg(as, error))
 		return -EINVAL;
 
-	r = dm_get_device(ca->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
-			  &ca->origin_dev);
+	r = dm_get_device_ex(ca->ti, dm_shift_arg(as), FMODE_READ | FMODE_WRITE,
+			     dm_table_is_interposer(ca->ti->table),
+			     &ca->origin_dev);
 	if (r) {
 		*error = "Error opening origin device";
 		return r;
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 2628a832787b..1b051a023a5d 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -153,7 +153,8 @@ static int delay_class_ctr(struct dm_target *ti, struct delay_class *c, char **a
 		return -EINVAL;
 	}
 
-	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &c->dev);
+	ret = dm_get_device_ex(ti, argv[0], dm_table_get_mode(ti->table),
+			       dm_table_is_interposer(ti->table), &c->dev);
 	if (ret) {
 		ti->error = "Device lookup failed";
 		return ret;
diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index cbe1058ee589..5eb930ea8034 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -366,7 +366,8 @@ static int dust_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -ENOMEM;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &dd->dev)) {
+	if (dm_get_device_ex(ti, argv[0], dm_table_get_mode(ti->table),
+			     dm_table_is_interposer(ti->table), &dd->dev)) {
 		ti->error = "Device lookup failed";
 		kfree(dd);
 		return -EINVAL;
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index d9ac7372108c..db8791981605 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1462,7 +1462,9 @@ static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[1], FMODE_READ | FMODE_WRITE, &era->origin_dev);
+	r = dm_get_device_ex(ti, argv[1], FMODE_READ | FMODE_WRITE,
+			     dm_table_is_interposer(ti->table),
+			     &era->origin_dev);
 	if (r) {
 		ti->error = "Error opening data device";
 		era_destroy(era);
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b7fee9936f05..89bb77545757 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -243,7 +243,8 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	r = dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev);
+	r = dm_get_device_ex(ti, devname, dm_table_get_mode(ti->table),
+			     dm_table_is_interposer(ti->table), &fc->dev);
 	if (r) {
 		ti->error = "Device lookup failed";
 		goto bad;
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 92db0f5e7f28..1301b11dd2af 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -51,7 +51,8 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	lc->start = tmp;
 
-	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
+	ret = dm_get_device_ex(ti, argv[0], dm_table_get_mode(ti->table),
+			       dm_table_is_interposer(ti->table), &lc->dev);
 	if (ret) {
 		ti->error = "Device lookup failed";
 		goto bad;
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 57882654ffee..32a389ea4eb1 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -554,7 +554,8 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	atomic_set(&lc->pending_blocks, 0);
 
 	devname = dm_shift_arg(&as);
-	ret = dm_get_device(ti, devname, dm_table_get_mode(ti->table), &lc->dev);
+	ret = dm_get_device_ex(ti, devname, dm_table_get_mode(ti->table),
+			       dm_table_is_interposer(ti->table), &lc->dev);
 	if (ret) {
 		ti->error = "Device lookup failed";
 		goto bad;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 11890db71f3f..eab96db253e1 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2646,7 +2646,8 @@ static int origin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_alloc;
 	}
 
-	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &o->dev);
+	r = dm_get_device_ex(ti, argv[0], dm_table_get_mode(ti->table),
+			     dm_table_is_interposer(ti->table), &o->dev);
 	if (r) {
 		ti->error = "Cannot get target device";
 		goto bad_open;
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 4f72b6f66c3a..bb0801fe4c63 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2169,7 +2169,8 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	string = dm_shift_arg(&as);
 	if (!string)
 		goto bad_arguments;
-	r = dm_get_device(ti, string, dm_table_get_mode(ti->table), &wc->dev);
+	r = dm_get_device_ex(ti, string, dm_table_get_mode(ti->table),
+			     dm_table_is_interposer(ti->table), &wc->dev);
 	if (r) {
 		ti->error = "Origin data device lookup failed";
 		goto bad;
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

