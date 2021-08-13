Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6E6C432BE
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5680C610CC
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5680C610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-rjDHJu0UOxyIcF1rCDHO7g-1; Fri, 13 Aug 2021 17:38:40 -0400
X-MC-Unique: rjDHJu0UOxyIcF1rCDHO7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8296B185302F;
	Fri, 13 Aug 2021 21:38:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A0D160BD8;
	Fri, 13 Aug 2021 21:38:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 11D1B181A0F8;
	Fri, 13 Aug 2021 21:38:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17DLcKJe015535 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 17:38:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E84AB205B060; Fri, 13 Aug 2021 21:38:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E13D7205B093
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84F94800677
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:18 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-170-WUlZQpWENJuGOkpfeWJNLQ-1;
	Fri, 13 Aug 2021 17:38:11 -0400
X-MC-Unique: WUlZQpWENJuGOkpfeWJNLQ-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id DBDE320C1715;
	Fri, 13 Aug 2021 14:38:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DBDE320C1715
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Fri, 13 Aug 2021 14:37:56 -0700
Message-Id: <20210813213801.297051-2-tusharsu@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17DLcKJe015535
X-loop: dm-devel@redhat.com
Cc: sfr@canb.auug.org.au, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	public@thson.de, tusharsu@linux.microsoft.com,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 1/6] dm ima: prefix dm table hashes in ima log
	with hash algorithm
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

The active/inactive table hashes measured in the ima log do not contain
the information about hash algorithm.  This information is useful for the
attestation servers to recreate the hashes and compare them with the ones
present in the ima log to verify the table contents.

Prefix the table hashes in various DM events in ima log with the hash
algorithm used to compute those hashes.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
---
 drivers/md/dm-ima.c | 15 ++++++++++++---
 drivers/md/dm-ima.h |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 91ea4a7202ab..4bab35c8f0c7 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -186,6 +186,12 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	struct crypto_shash *tfm = NULL;
 	u8 *digest = NULL;
 	bool noio = false;
+	const size_t hash_alg_prefix_len = strlen(DM_IMA_TABLE_HASH_ALG) + 1;
+				/*
+				 * +1 for the additional char (':'), when prefixing
+				 * the hash value with the hash algorithm name.
+				 * e.g. sha256:<hash_value>.
+				 */
 
 	ima_buf = dm_ima_alloc(DM_IMA_MEASUREMENT_BUF_LEN, GFP_KERNEL, noio);
 	if (!ima_buf)
@@ -204,7 +210,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	if (dm_ima_alloc_and_copy_device_data(table->md, &device_data_buf, num_targets, noio))
 		goto error;
 
-	tfm = crypto_alloc_shash("sha256", 0, 0);
+	tfm = crypto_alloc_shash(DM_IMA_TABLE_HASH_ALG, 0, 0);
 	if (IS_ERR(tfm))
 		goto error;
 
@@ -315,12 +321,15 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	if (r < 0)
 		goto error;
 
-	digest_buf = dm_ima_alloc((digest_size*2)+1, GFP_KERNEL, noio);
+	digest_buf = dm_ima_alloc((digest_size*2) + hash_alg_prefix_len + 1, GFP_KERNEL, noio);
+
 	if (!digest_buf)
 		goto error;
 
+	snprintf(digest_buf, hash_alg_prefix_len + 1, "%s:", DM_IMA_TABLE_HASH_ALG);
+
 	for (i = 0; i < digest_size; i++)
-		snprintf((digest_buf+(i*2)), 3, "%02x", digest[i]);
+		snprintf((digest_buf + hash_alg_prefix_len + (i*2)), 3, "%02x", digest[i]);
 
 	if (table->md->ima.active_table.hash != table->md->ima.inactive_table.hash)
 		kfree(table->md->ima.inactive_table.hash);
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 6e6f18bf05b4..0731a51565d6 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -16,6 +16,7 @@
 #define DM_IMA_TARGET_METADATA_BUF_LEN	128
 #define DM_IMA_TARGET_DATA_BUF_LEN	2048
 #define DM_IMA_DEVICE_CAPACITY_BUF_LEN	128
+#define DM_IMA_TABLE_HASH_ALG		"sha256"
 
 #ifdef CONFIG_IMA
 
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

