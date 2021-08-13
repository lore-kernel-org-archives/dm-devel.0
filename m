Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEE2C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3209660F51
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3209660F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-BRYtnsJ6P8G0hirnZnHwKA-1; Fri, 13 Aug 2021 17:38:38 -0400
X-MC-Unique: BRYtnsJ6P8G0hirnZnHwKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51DCE344B2;
	Fri, 13 Aug 2021 21:38:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 399D260BD8;
	Fri, 13 Aug 2021 21:38:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0FA094A7CA;
	Fri, 13 Aug 2021 21:38:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17DLcGWh015497 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 17:38:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C29C911F4D0; Fri, 13 Aug 2021 21:38:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BABA914E781
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26223185A794
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:14 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-309-2YsdAk-GM_GNtOsmzCEm6Q-1;
	Fri, 13 Aug 2021 17:38:11 -0400
X-MC-Unique: 2YsdAk-GM_GNtOsmzCEm6Q-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id AA2B220C171A;
	Fri, 13 Aug 2021 14:38:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AA2B220C171A
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Fri, 13 Aug 2021 14:37:58 -0700
Message-Id: <20210813213801.297051-4-tusharsu@linux.microsoft.com>
In-Reply-To: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
References: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17DLcGWh015497
X-loop: dm-devel@redhat.com
Cc: sfr@canb.auug.org.au, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	public@thson.de, tusharsu@linux.microsoft.com,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 3/6] dm ima: prefix ima event name related to
	device mapper with dm_
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The event names for the DM events recorded in the ima log do not contain
any information to indicate the events are part of the DM devices/targets.

Prefix the event names for DM events with "dm_" to indicate that they
are part of device-mapper.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Suggested-by: Thore Sommer <public@thson.de>
---
 drivers/md/dm-ima.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 458a3a1d78bc..81a574129a80 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -193,6 +193,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 				 * the hash value with the hash algorithm name.
 				 * e.g. sha256:<hash_value>.
 				 */
+	char table_load_event_name[] = "dm_table_load";
 
 	ima_buf = dm_ima_alloc(DM_IMA_MEASUREMENT_BUF_LEN, GFP_KERNEL, noio);
 	if (!ima_buf)
@@ -272,7 +273,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 		 * targets by prefixing the device metadata again.
 		 */
 		if (unlikely(cur_total_buf_len >= DM_IMA_MEASUREMENT_BUF_LEN)) {
-			dm_ima_measure_data("table_load", ima_buf, l, noio);
+			dm_ima_measure_data(table_load_event_name, ima_buf, l, noio);
 			r = crypto_shash_update(shash, (const u8 *)ima_buf, l);
 			if (r < 0)
 				goto error;
@@ -281,8 +282,8 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 			l = 0;
 
 			/*
-			 * Each new "table_load" entry in IMA log should have device data
-			 * prefix, so that multiple records from the same table_load for
+			 * Each new "dm_table_load" entry in IMA log should have device data
+			 * prefix, so that multiple records from the same "dm_table_load" for
 			 * a given device can be linked together.
 			 */
 			memcpy(ima_buf + l, DM_IMA_VERSION_STR, table->md->ima.dm_version_str_len);
@@ -293,7 +294,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 
 			/*
 			 * If this iteration of the for loop turns out to be the last target
-			 * in the table, dm_ima_measure_data("table_load", ...) doesn't need
+			 * in the table, dm_ima_measure_data("dm_table_load", ...) doesn't need
 			 * to be called again, just the hash needs to be finalized.
 			 * "last_target_measured" tracks this state.
 			 */
@@ -312,7 +313,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	}
 
 	if (!last_target_measured) {
-		dm_ima_measure_data("table_load", ima_buf, l, noio);
+		dm_ima_measure_data(table_load_event_name, ima_buf, l, noio);
 
 		r = crypto_shash_update(shash, (const u8 *)ima_buf, l);
 		if (r < 0)
@@ -461,7 +462,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	memcpy(device_table_data + l, capacity_str, capacity_len);
 	l += capacity_len;
 
-	dm_ima_measure_data("device_resume", device_table_data, l, noio);
+	dm_ima_measure_data("dm_device_resume", device_table_data, l, noio);
 
 	kfree(dev_name);
 	kfree(dev_uuid);
@@ -578,7 +579,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	memcpy(device_table_data + l, capacity_str, capacity_len);
 	l += capacity_len;
 
-	dm_ima_measure_data("device_remove", device_table_data, l, noio);
+	dm_ima_measure_data("dm_device_remove", device_table_data, l, noio);
 
 error:
 	kfree(device_table_data);
@@ -659,7 +660,7 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	memcpy(device_table_data + l, capacity_str, capacity_len);
 	l += capacity_len;
 
-	dm_ima_measure_data("table_clear", device_table_data, l, noio);
+	dm_ima_measure_data("dm_table_clear", device_table_data, l, noio);
 
 	if (new_map) {
 		if (md->ima.inactive_table.hash &&
@@ -734,7 +735,7 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 		  "%s%snew_name=%s,new_uuid=%s;%s", DM_IMA_VERSION_STR, old_device_data,
 		  new_dev_name, new_dev_uuid, capacity_str);
 
-	dm_ima_measure_data("device_rename", combined_device_data, strlen(combined_device_data),
+	dm_ima_measure_data("dm_device_rename", combined_device_data, strlen(combined_device_data),
 			    noio);
 
 	goto exit;
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

