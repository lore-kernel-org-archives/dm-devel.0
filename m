Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4872BC4707F
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:10:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C247961417
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C247961417
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-EhOnhtTvO7Onk3a5cZHZYw-1; Tue, 25 May 2021 21:10:06 -0400
X-MC-Unique: EhOnhtTvO7Onk3a5cZHZYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6932107ACC7;
	Wed, 26 May 2021 01:10:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB6EA101E24A;
	Wed, 26 May 2021 01:10:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7862655348;
	Wed, 26 May 2021 01:10:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q19jiO020101 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 21:09:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4573E208AB66; Wed, 26 May 2021 01:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EF00208AB75
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDC8480D0E1
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-261-H8L96rZJNvWBKumkfMYogw-1;
	Tue, 25 May 2021 21:09:39 -0400
X-MC-Unique: H8L96rZJNvWBKumkfMYogw-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 00D0C20B8010;
	Tue, 25 May 2021 18:00:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 00D0C20B8010
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com
Date: Tue, 25 May 2021 17:59:53 -0700
Message-Id: <20210526005954.31564-7-tusharsu@linux.microsoft.com>
In-Reply-To: <20210526005954.31564-1-tusharsu@linux.microsoft.com>
References: <20210526005954.31564-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	zohar@linux.ibm.com, snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [RFC 6/7] dm: update target specific status functions to
	measure data
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For device mapper targets to take advantage of IMA's measurement
capabilities, the status functions for the individual targets need to be
updated to handle the status_type_t case for value STATUSTYPE_IMA.

Update status functions for the following target types, to log their
respective attributes to be measured using IMA.
 01. cache
 02. crypt
 03. integrity
 04. linear
 05. mirror
 06. multipath
 07. raid
 08. snapshot
 09. striped
 10. verity 

For rest of the targets, handle the STATUSTYPE_IMA case by setting the 
measurement buffer to NULL.

For IMA to measure the data on a given system, the IMA policy on the
system needs to be updated to have the following line, and the system 
needs to be restarted for the measurements to take effect.

/etc/ima/ima-policy
 measure func=CRITICAL_DATA label=device-mapper template=ima-buf

The measurements will be reflected in the IMA logs, which are located at:

/sys/kernel/security/integrity/ima/ascii_runtime_measurements
/sys/kernel/security/integrity/ima/binary_runtime_measurements

These IMA logs can later be consumed by various attestation clients
running on the system, and send them to external services for attesting
the system.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm-cache-target.c               | 30 +++++++++++++
 drivers/md/dm-clone-target.c               |  7 +++
 drivers/md/dm-crypt.c                      | 50 ++++++++++++++++++++++
 drivers/md/dm-delay.c                      |  4 ++
 drivers/md/dm-dust.c                       |  4 ++
 drivers/md/dm-ebs-target.c                 |  3 ++
 drivers/md/dm-era-target.c                 |  4 ++
 drivers/md/dm-flakey.c                     |  4 ++
 drivers/md/dm-integrity.c                  | 38 ++++++++++++++++
 drivers/md/dm-linear.c                     |  8 ++++
 drivers/md/dm-log-userspace-base.c         |  3 ++
 drivers/md/dm-log-writes.c                 |  4 ++
 drivers/md/dm-log.c                        | 10 +++++
 drivers/md/dm-mpath.c                      | 29 +++++++++++++
 drivers/md/dm-ps-historical-service-time.c |  3 ++
 drivers/md/dm-ps-io-affinity.c             |  3 ++
 drivers/md/dm-ps-queue-length.c            |  3 ++
 drivers/md/dm-ps-round-robin.c             |  4 ++
 drivers/md/dm-ps-service-time.c            |  3 ++
 drivers/md/dm-raid.c                       | 42 ++++++++++++++++++
 drivers/md/dm-raid1.c                      | 18 ++++++++
 drivers/md/dm-snap-persistent.c            |  4 ++
 drivers/md/dm-snap-transient.c             |  4 ++
 drivers/md/dm-snap.c                       | 16 +++++++
 drivers/md/dm-stripe.c                     | 15 +++++++
 drivers/md/dm-switch.c                     |  4 ++
 drivers/md/dm-thin.c                       |  8 ++++
 drivers/md/dm-unstripe.c                   |  4 ++
 drivers/md/dm-verity-target.c              | 46 ++++++++++++++++++++
 drivers/md/dm-writecache.c                 |  3 ++
 drivers/md/dm-zoned-target.c               |  3 ++
 include/linux/device-mapper.h              |  4 ++
 32 files changed, 385 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 6ab01ff25747..7cb089fd416e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3192,6 +3192,36 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" %s", cache->ctr_args[i]);
 		if (cache->nr_ctr_args)
 			DMEMIT(" %s", cache->ctr_args[cache->nr_ctr_args - 1]);
+		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		if (get_cache_mode(cache) == CM_FAIL)
+			DMEMIT("metadata_mode=fail;");
+		else if (get_cache_mode(cache) == CM_READ_ONLY)
+			DMEMIT("metadata_mode=ro;");
+		else
+			DMEMIT("metadata_mode=rw;");
+
+		format_dev_t(buf, cache->metadata_dev->bdev->bd_dev);
+		DMEMIT("cache_metadata_device=%s;", buf);
+		format_dev_t(buf, cache->cache_dev->bdev->bd_dev);
+		DMEMIT("cache_device=%s;", buf);
+		format_dev_t(buf, cache->origin_dev->bdev->bd_dev);
+		DMEMIT("cache_origin_device=%s;", buf);
+
+		for (i = 0; i < cache->nr_ctr_args - 1; i++) {
+			if (!strcmp(cache->ctr_args[i], "writethrough"))
+				DMEMIT("writethrough=y;");
+			else if (!strcmp(cache->ctr_args[i], "passthrough"))
+				DMEMIT("passthrough=y;");
+			else if (!strcmp(cache->ctr_args[i], "metadata2"))
+				DMEMIT("metadata2=y;");
+			else if (!strcmp(cache->ctr_args[i], "no_discard_passdown"))
+				DMEMIT("no_discard_passdown=y;");
+		}
+		break;
 	}
 
 	return;
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index a90bdf9b2ca6..e5dc68f18ee6 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1499,6 +1499,13 @@ static void clone_status(struct dm_target *ti, status_type_t type,
 
 		for (i = 0; i < clone->nr_ctr_args; i++)
 			DMEMIT(" %s", clone->ctr_args[i]);
+
+		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+
+		break;
 	}
 
 	return;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b0ab080f2567..5d179c57a55a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3473,6 +3473,56 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 				DMEMIT(" iv_large_sectors");
 		}
 
+		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		if (ti->num_discard_bios)
+			DMEMIT("allow_discards=y;");
+		else
+			DMEMIT("allow_discards=n;");
+
+		if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
+			DMEMIT("same_cpu=y;");
+		else
+			DMEMIT("same_cpu=n;");
+
+		if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))
+			DMEMIT("submit_from_crypt_cpus=y;");
+		else
+			DMEMIT("submit_from_crypt_cpus=n;");
+
+		if (test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags))
+			DMEMIT("no_read_workqueue=y;");
+		else
+			DMEMIT("no_read_workqueue=n;");
+
+		if (test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))
+			DMEMIT("no_write_workqueue=y;");
+		else
+			DMEMIT("no_write_workqueue=n;");
+
+		if (cc->on_disk_tag_size)
+			DMEMIT("integrity_tag_size=%u;cipher_auth=%s;",
+				cc->on_disk_tag_size, cc->cipher_auth);
+
+		if (cc->sector_size != (1 << SECTOR_SHIFT))
+			DMEMIT("sector_size=%d;", cc->sector_size);
+
+		if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
+			DMEMIT("iv_large_sectors=y;");
+		else
+			DMEMIT("iv_large_sectors=y;");
+
+		if (cc->cipher_string)
+			DMEMIT("cipher_string=%s;", cc->cipher_string);
+
+		DMEMIT("key_size=%u;", cc->key_size);
+		DMEMIT("key_parts=%u;", cc->key_parts);
+		DMEMIT("key_extra_size=%u;", cc->key_extra_size);
+		DMEMIT("key_mac_size=%u;", cc->key_mac_size);
+
 		break;
 	}
 }
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 2628a832787b..76c0bed73840 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -326,6 +326,10 @@ static void delay_status(struct dm_target *ti, status_type_t type,
 			DMEMIT_DELAY_CLASS(&dc->flush);
 		}
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index cbe1058ee589..5e455da70678 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -527,6 +527,10 @@ static void dust_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%s %llu %u", dd->dev->name,
 		       (unsigned long long)dd->start, dd->blksz);
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 71475a2410be..6b42bdaf0ce2 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -401,6 +401,9 @@ static void ebs_status(struct dm_target *ti, status_type_t type,
 		snprintf(result, maxlen, ec->u_bs_set ? "%s %llu %u %u" : "%s %llu %u",
 			 ec->dev->name, (unsigned long long) ec->start, ec->e_bs, ec->u_bs);
 		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index d9ac7372108c..9d2d072729c0 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1640,6 +1640,10 @@ static void era_status(struct dm_target *ti, status_type_t type,
 		format_dev_t(buf, era->origin_dev->bdev->bd_dev);
 		DMEMIT("%s %u", buf, era->sectors_per_block);
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 
 	return;
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b7fee9936f05..8720e1a4873b 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -440,6 +440,10 @@ static void flakey_status(struct dm_target *ti, status_type_t type,
 			       fc->corrupt_bio_value, fc->corrupt_bio_flags);
 
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 781942aeddd1..df234575dda4 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3310,6 +3310,44 @@ static void dm_integrity_status(struct dm_target *ti, status_type_t type,
 		EMIT_ALG(journal_mac_alg, "journal_mac");
 		break;
 	}
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+		DMEMIT("dev_name=%s;start=%llu;tag_size=%u;mode=%c;",
+			ic->dev->name, ic->start, ic->tag_size, ic->mode);
+
+		if (ic->meta_dev)
+			DMEMIT("meta_device=%s;", ic->meta_dev->name);
+		if (ic->sectors_per_block != 1)
+			DMEMIT("block_size=%u;", ic->sectors_per_block << SECTOR_SHIFT);
+		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
+			DMEMIT("recalculate=y;");
+		else
+			DMEMIT("recalculate=n;");
+
+		if (ic->discard)
+			DMEMIT("allow_discards=y;");
+		else
+			DMEMIT("allow_discards=n;");
+
+		DMEMIT("journal_sectors=%u;", ic->initial_sectors - SB_SECTORS);
+		DMEMIT("interleave_sectors=%u;", 1U << ic->sb->log2_interleave_sectors);
+		DMEMIT("buffer_sectors=%u;", 1U << ic->log2_buffer_sectors);
+		DMEMIT("mode=%c;", ic->mode);
+		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_PADDING)) != 0)
+			DMEMIT("fix_padding=y;");
+		else
+			DMEMIT("fix_padding=n;");
+
+		if ((ic->sb->flags & cpu_to_le32(SB_FLAG_FIXED_HMAC)) != 0)
+			DMEMIT("fix_hmac=y;");
+		else
+			DMEMIT("fix_hmac=n;");
+
+		if (ic->legacy_recalculate)
+			DMEMIT("legacy_recalculate=y;");
+		else
+			DMEMIT("legacy_recalculate=n;");
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 92db0f5e7f28..42acf4ed3b39 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -106,6 +106,7 @@ static void linear_status(struct dm_target *ti, status_type_t type,
 			  unsigned status_flags, char *result, unsigned maxlen)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
+	size_t sz = 0;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -116,6 +117,13 @@ static void linear_status(struct dm_target *ti, status_type_t type,
 		snprintf(result, maxlen, "%s %llu", lc->dev->name,
 				(unsigned long long)lc->start);
 		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		DMEMIT("device_name=%s;start=%llu;", lc->dev->name,
+		       (unsigned long long)lc->start);
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 52090bee17c2..15cfe33ea68c 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -820,6 +820,9 @@ static int userspace_status(struct dm_dirty_log *log, status_type_t status_type,
 			DMEMIT("integrated_flush ");
 		DMEMIT("%s ", table_args);
 		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 	return (r) ? 0 : (int)sz;
 }
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 57882654ffee..f3a6a0d3bf2d 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -834,6 +834,10 @@ static void log_writes_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		DMEMIT("%s %s", lc->dev->name, lc->logdev->name);
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 33e71ea6cc14..e0bcdf339df7 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -793,6 +793,11 @@ static int core_status(struct dm_dirty_log *log, status_type_t status,
 		DMEMIT("%s %u %u ", log->type->name,
 		       lc->sync == DEFAULTSYNC ? 1 : 2, lc->region_size);
 		DMEMIT_SYNC;
+		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 
 	return sz;
@@ -817,6 +822,11 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
+		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 
 	return sz;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..4d9af76fb6e8 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1904,6 +1904,35 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			}
 		}
 		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		list_for_each_entry(pg, &m->priority_groups, list) {
+			if (pg->bypassed)
+				state = 'D';	/* Disabled */
+			else if (pg == m->current_pg)
+				state = 'A';	/* Currently Active */
+			else
+				state = 'E';	/* Enabled */
+
+			DMEMIT("state=%c;", state);
+
+			list_for_each_entry(p, &pg->pgpaths, list) {
+				DMEMIT("path_name=%s;is_active=%s;fail_count=%u;",
+					p->path.dev->name,
+					p->is_active ? "A" : "F",
+					p->fail_count);
+				if (pg->ps.type->status) {
+					DMEMIT("path_selector_status=");
+					sz += pg->ps.type->status(&pg->ps,
+					      &p->path, type, result + sz,
+					      maxlen - sz);
+					DMEMIT(";");
+				}
+			}
+		}
+		break;
 	}
 
 	spin_unlock_irqrestore(&m->lock, flags);
diff --git a/drivers/md/dm-ps-historical-service-time.c b/drivers/md/dm-ps-historical-service-time.c
index 186f91e2752c..0ad613e12b22 100644
--- a/drivers/md/dm-ps-historical-service-time.c
+++ b/drivers/md/dm-ps-historical-service-time.c
@@ -255,6 +255,9 @@ static int hst_status(struct path_selector *ps, struct dm_path *path,
 		case STATUSTYPE_TABLE:
 			DMEMIT("0 ");
 			break;
+		case STATUSTYPE_IMA:
+			result[0] = '\0';
+			break;
 		}
 	}
 
diff --git a/drivers/md/dm-ps-io-affinity.c b/drivers/md/dm-ps-io-affinity.c
index 077655cd4fae..618179028c13 100644
--- a/drivers/md/dm-ps-io-affinity.c
+++ b/drivers/md/dm-ps-io-affinity.c
@@ -171,6 +171,9 @@ static int ioa_status(struct path_selector *ps, struct dm_path *path,
 		pi = path->pscontext;
 		DMEMIT("%*pb ", cpumask_pr_args(pi->cpumask));
 		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 
 	return sz;
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index 5fd018d18418..5988f52b5a6e 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -102,6 +102,9 @@ static int ql_status(struct path_selector *ps, struct dm_path *path,
 		case STATUSTYPE_TABLE:
 			DMEMIT("%u ", pi->repeat_count);
 			break;
+		case STATUSTYPE_IMA:
+			result[0] = '\0';
+			break;
 		}
 	}
 
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index bdbb7e6e8212..8b47949454e9 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -100,6 +100,10 @@ static int rr_status(struct path_selector *ps, struct dm_path *path,
 			pi = path->pscontext;
 			DMEMIT("%u ", pi->repeat_count);
 			break;
+
+		case STATUSTYPE_IMA:
+			result[0] = '\0';
+			break;
 		}
 	}
 
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 9cfda665e9eb..3ec9c33265c5 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -99,6 +99,9 @@ static int st_status(struct path_selector *ps, struct dm_path *path,
 			DMEMIT("%u %u ", pi->repeat_count,
 			       pi->relative_throughput);
 			break;
+		case STATUSTYPE_IMA:
+			result[0] = '\0';
+			break;
 		}
 	}
 
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index bf4a467fc73a..67d7f9e5b89b 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3671,6 +3671,48 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		for (i = 0; i < rs->raid_disks; i++)
 			DMEMIT(" %s %s", __get_dev_name(rs->dev[i].meta_dev),
 					 __get_dev_name(rs->dev[i].data_dev));
+		break;
+
+	case STATUSTYPE_IMA:
+		/* *Should* always succeed */
+		rt = get_raid_type_by_ll(mddev->new_level, mddev->new_layout);
+		if (!rt)
+			return;
+
+		DMEMIT_NAME_VERSION(ti->type);
+
+		DMEMIT("raid_type=%s;raid_disks=%d;", rt->name, mddev->raid_disks);
+
+		/* Access most recent mddev properties for status output */
+		smp_rmb();
+		state = decipher_sync_action(mddev, recovery);
+		DMEMIT("raid_state=%s;", sync_str(state));
+
+		for (i = 0; i < rs->raid_disks; i++) {
+			DMEMIT("raid_device_%d_status=", i);
+			DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev));
+			DMEMIT(";");
+		}
+
+		if (rt_is_raid456(rt)) {
+			DMEMIT("journal_dev_mode=");
+			switch (rs->journal_dev.mode) {
+			case R5C_JOURNAL_MODE_WRITE_THROUGH:
+				DMEMIT("%s",
+				       _raid456_journal_mode[R5C_JOURNAL_MODE_WRITE_THROUGH].param);
+				break;
+			case R5C_JOURNAL_MODE_WRITE_BACK:
+				DMEMIT("%s",
+				       _raid456_journal_mode[R5C_JOURNAL_MODE_WRITE_BACK].param);
+				break;
+			default:
+				DMEMIT("invalid");
+				break;
+			}
+			DMEMIT(";");
+		}
+		break;
+
 	}
 }
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index b0a82f29a2e4..ecfc6d4c41e3 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1435,6 +1435,24 @@ static void mirror_status(struct dm_target *ti, status_type_t type,
 		}
 
 		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		DMEMIT("mirrors=%d;", ms->nr_mirrors);
+		for (m = 0; m < ms->nr_mirrors; m++) {
+			DMEMIT("mirror_device_%d=%s;", m, ms->mirror[m].dev->name);
+			DMEMIT("mirror_device_%d_status=%c;",
+			       m, device_status_char(&(ms->mirror[m])));
+		}
+
+		DMEMIT("%s", errors_handled(ms) ? "handle_errors=y;" : "handle_errors=n;");
+		DMEMIT("%s", keep_log(ms) ? "keep_log=y;" : "keep_log=n;");
+
+		DMEMIT("log_type_status=");
+		sz += log->type->status(log, type, result+sz, maxlen-sz);
+		DMEMIT(";");
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 9ab4bf651ca9..ed7e903c5b44 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -908,6 +908,10 @@ static unsigned persistent_status(struct dm_exception_store *store,
 	case STATUSTYPE_TABLE:
 		DMEMIT(" %s %llu", store->userspace_supports_overflow ? "PO" : "P",
 		       (unsigned long long)store->chunk_size);
+		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 
 	return sz;
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index 4d50a12cf00c..f6d46610ae77 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -95,6 +95,10 @@ static unsigned transient_status(struct dm_exception_store *store,
 		break;
 	case STATUSTYPE_TABLE:
 		DMEMIT(" N %llu", (unsigned long long)store->chunk_size);
+		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 
 	return sz;
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index a2acb014c13a..daebbc92016d 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2389,6 +2389,19 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 				DMEMIT(" discard_passdown_origin");
 		}
 		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		DMEMIT("snap_origin_name=%s;", snap->origin->name);
+		DMEMIT("snap_cow_name=%s;", snap->cow->name);
+		DMEMIT("%s", snap->valid ? "snap_valid=y;" : "snap_valid=n;");
+		DMEMIT("%s", snap->merge_failed ?
+		       "snap_merge_failed=y;" : "snap_merge_failed=n;");
+		DMEMIT("%s", snap->snapshot_overflowed ?
+		       "snapshot_overflowed=y;" : "snapshot_overflowed=n");
+		break;
+
 	}
 }
 
@@ -2733,6 +2746,9 @@ static void origin_status(struct dm_target *ti, status_type_t type,
 	case STATUSTYPE_TABLE:
 		snprintf(result, maxlen, "%s", o->dev->name);
 		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index df359d33cda8..65352c6005f3 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -428,6 +428,21 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" %s %llu", sc->stripe[i].dev->name,
 			    (unsigned long long)sc->stripe[i].physical_start);
 		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		DMEMIT("stripes=%d;chunk_size=%llu;",
+			sc->stripes,
+			(unsigned long long)sc->chunk_size);
+		for (i = 0; i < sc->stripes; i++) {
+			DMEMIT("stripe_%d_device_name=%s;", i, sc->stripe[i].dev->name);
+			DMEMIT("stripe_%d_physical_start=%llu;", i,
+			       (unsigned long long)sc->stripe[i].physical_start);
+			DMEMIT("stripe_%d_status=%c;", i,
+			       atomic_read(&(sc->stripe[i].error_count)) ? 'D' : 'A');
+		}
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-switch.c b/drivers/md/dm-switch.c
index 262e2b0fd975..028a92ff6d57 100644
--- a/drivers/md/dm-switch.c
+++ b/drivers/md/dm-switch.c
@@ -504,6 +504,10 @@ static void switch_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" %s %llu", sctx->path_list[path_nr].dmdev->name,
 			       (unsigned long long)sctx->path_list[path_nr].start);
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 985baee3a678..fc299cf90135 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4012,6 +4012,10 @@ static void pool_status(struct dm_target *ti, status_type_t type,
 		       (unsigned long long)pt->low_water_blocks);
 		emit_flags(&pt->requested_pf, result, sz, maxlen);
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 	return;
 
@@ -4423,6 +4427,10 @@ static void thin_status(struct dm_target *ti, status_type_t type,
 			if (tc->origin_dev)
 				DMEMIT(" %s", format_dev_t(buf, tc->origin_dev->bdev->bd_dev));
 			break;
+
+		case STATUSTYPE_IMA:
+			result[0] = '\0';
+			break;
 		}
 	}
 
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index 7357c1bd5863..c04be1f6d059 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -156,6 +156,10 @@ static void unstripe_status(struct dm_target *ti, status_type_t type,
 		       uc->stripes, (unsigned long long)uc->chunk_size, uc->unstripe,
 		       uc->dev->name, (unsigned long long)uc->physical_start);
 		break;
+
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index d3e76aefc1a6..38c991eb5069 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -772,6 +772,52 @@ static void verity_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" " DM_VERITY_ROOT_HASH_VERIFICATION_OPT_SIG_KEY
 				" %s", v->signature_key_desc);
 		break;
+
+	case STATUSTYPE_IMA:
+		DMEMIT_NAME_VERSION(ti->type);
+
+		DMEMIT("hash_failed=%c;", v->hash_failed ? 'C' : 'V');
+
+		DMEMIT("verity_version=%u;", v->version);
+		DMEMIT("data_device_name=%s;", v->data_dev->name);
+		DMEMIT("hash_device_name=%s;", v->hash_dev->name);
+		DMEMIT("verity_algorithm=%s;", v->alg_name);
+
+		DMEMIT("root_digest=");
+		for (x = 0; x < v->digest_size; x++)
+			DMEMIT("%02x", v->root_digest[x]);
+		DMEMIT(";");
+
+		DMEMIT("salt=");
+		if (!v->salt_size)
+			DMEMIT("-");
+		else
+			for (x = 0; x < v->salt_size; x++)
+				DMEMIT("%02x", v->salt[x]);
+		DMEMIT(";");
+
+		DMEMIT("%s", v->zero_digest ? "ignore_zero_blocks=y;" : "ignore_zero_blocks=n;");
+		DMEMIT("%s", v->validated_blocks ? "check_at_most_once=y;" :
+		       "check_at_most_once=n;");
+
+		if (v->mode != DM_VERITY_MODE_EIO) {
+			DMEMIT("verity_mode=");
+			switch (v->mode) {
+			case DM_VERITY_MODE_LOGGING:
+				DMEMIT(DM_VERITY_OPT_LOGGING);
+				break;
+			case DM_VERITY_MODE_RESTART:
+				DMEMIT(DM_VERITY_OPT_RESTART);
+				break;
+			case DM_VERITY_MODE_PANIC:
+				DMEMIT(DM_VERITY_OPT_PANIC);
+				break;
+			default:
+				DMEMIT("invalid");
+			}
+			DMEMIT(";");
+		}
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index aecc246ade26..02bb1019bdc6 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2536,6 +2536,9 @@ static void writecache_status(struct dm_target *ti, status_type_t type,
 		if (wc->writeback_fua_set)
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
 		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 }
 
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 7e88df64d197..b1d311238b5b 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1119,6 +1119,9 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(" %s", buf);
 		}
 		break;
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
 	}
 	return;
 }
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 738a7d023650..61ac0fcec7d4 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -596,6 +596,10 @@ void dm_destroy_keyslot_manager(struct blk_keyslot_manager *ksm);
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
 			  0 : scnprintf(result + sz, maxlen - sz, x))
 
+#define DMEMIT_NAME_VERSION(y) \
+		DMEMIT("target_type_name=%s;target_type_version=%u.%u.%u;", \
+			y->name, y->version[0], y->version[1], y->version[2])
+
 /*
  * Definitions of return values from target end_io function.
  */
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

