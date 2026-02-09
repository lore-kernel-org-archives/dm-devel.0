Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B06339843
	for <dm-devel@lists.linux.dev>; Mon,  9 Feb 2026 07:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623745; cv=none; b=OQ+u4wfT4PFjpo9jIWgwU6it+M0Yl/ubHwm+W6bQOknwrjQ7oj8ZofuVbitacdvNXMYgA+NM83BjBOz1vIp8/rZqveFBW+UgDtFGmqyLsYeRO0bOEUk5DHThi6eU5VYjphVkF2Sp3keYrZ26V5vmkRCXTzW+gAszwThXnfzUbXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623745; c=relaxed/simple;
	bh=cYsGHfFOy92pfklJi5M7Neohh+U0Y4pMhdlLWTD5jJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oHAoxfPGk89UoIHo4eI1kReUCVfs31A/2LqnLVAgfkn0w88q/y+rvZDIN8OfDIV3jVljO/4WhxhCc9vQC9BFBZpeUm7p/YoyPNlBeyHnGGUQ270/wqLBHcXrDYY+VnYYtl7iToDcVBj16by17cr6a8uSPhKOjxeheqaPZ6+nWNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K5vIvTEF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K5vIvTEF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770623745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krOnQbkq2seY6bRXbQFjVFGP09oeyXWWWuDGLkZK58Y=;
	b=K5vIvTEFOLqtrUmCL6eraJdrc2euKV5ZcHXgkReDfBBXctQjvRj6nOUb2swqJnqpF+BgZs
	loBeaP2OfsoSCO8o72syAfqqs5bbJssIZx/LAmAYSE9EXAxx+kHcjzlcb3k2x98HchU/lb
	rwKGMahRr3w0TQ99eSCtnx7bbDZiYnw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-hIHDwPB0PRK2-avBo9V6BA-1; Mon,
 09 Feb 2026 02:55:41 -0500
X-MC-Unique: hIHDwPB0PRK2-avBo9V6BA-1
X-Mimecast-MFC-AGG-ID: hIHDwPB0PRK2-avBo9V6BA_1770623740
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A499D1955F20;
	Mon,  9 Feb 2026 07:55:40 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.64.240.53])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7633930001A8;
	Mon,  9 Feb 2026 07:55:37 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH 7/7] dm cache: prevent entering passthrough mode after unclean shutdown
Date: Mon,  9 Feb 2026 15:54:11 +0800
Message-ID: <20260209075411.860418-8-mtsai@redhat.com>
In-Reply-To: <20260209075411.860418-1-mtsai@redhat.com>
References: <20260209075411.860418-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y4zNLLOSU80uLvC7VnrfeGByBwhoFt8YbgGl9GxL8WU_1770623740
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm-cache assumes all cache blocks are dirty when it recovers from an
unclean shutdown. Given that the passthrough mode doesn't handle dirty
blocks, we should not load a cache in passthrough mode if it was not
cleanly shut down; or we'll risk data loss while updating an actually
dirty block.

Also bump the target version to 2.4.0 to mark completion of passthrough
mode fixes.

Reproduce steps:

1. Create a writeback cache with zero migration_threshold to produce
   dirty blocks.

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/zero of=/dev/mapper/cmeta bs=4k count=1 oflag=direct
dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writeback smq \
2 migration_threshold 0"

2. Write the first cache block dirty

fio --filename=/dev/mapper/cache --name=populate --rw=write --bs=4k \
--direct=1 --size=64k

3. Ensure the number of dirty blocks is 1. This status query triggers
   metadata commit without flushing the dirty bitset, setting up the
   unclean shutdown state.

dmsetup status cache | awk '{print $14}'

4. Force reboot, leaving the cache uncleanly shutdown.

echo b > /proc/sysrq-trigger

5. Activate the above cache components, and verify the first data block
   remains dirty.

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
dmsetup create corig --table "0 262144 linear /dev/sdc 262144"
dd if=/dev/mapper/cdata of=/tmp/cb0.bin bs=64k count=1
dd if=/dev/mapper/corig of=/tmp/ob0.bin bs=64k count=1
md5sum /tmp/cb0.bin /tmp/ob0.bin # expected to be different

6. Try bringing up the cache in passthrough mode. It succeeds, while the
   first cache block was loaded dirty due to unclean shutdown, violates
   the passthrough mode's constraints.

dmsetup create cache --table "0 262144 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 passthrough smq 0"
dmsetup status cache | awk '{print $14}'

7. (Optional) Demonstrate the integrity issue: invalidating the dirty
   block in passthrough mode doesn't write back the dirty data, causing
   data loss.

fio --filename=/dev/mapper/cache --name=invalidate --rw=write --bs=4k \
--direct=1 --size=4k  # overwrite the first 4k to trigger invalidation
dmsetup remove cache
dd if=/dev/mapper/corig of=/tmp/ob0new.bin bs=64k count=1
cb0sum=$(dd if=/tmp/cb0.bin bs=4k count=15 skip=1 | md5sum | \
awk '{print $1}')
ob0newsum=$(dd if=/tmp/ob0new.bin bs=4k count=15 skip=1 | md5sum | \
awk '{print $1}')
echo "$cb0sum, $ob0newsum"  # remaining 60k should differ (data loss)

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-metadata.c |  9 +++++++++
 drivers/md/dm-cache-metadata.h |  5 +++++
 drivers/md/dm-cache-target.c   | 19 ++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index cf491c8508a4..24a6eea5579f 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1813,3 +1813,12 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 
 	return r;
 }
+
+int dm_cache_metadata_clean_when_opened(struct dm_cache_metadata *cmd, bool *result)
+{
+	READ_LOCK(cmd);
+	*result = cmd->clean_when_opened;
+	READ_UNLOCK(cmd);
+
+	return 0;
+}
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index 2f107e7c67d0..91f8706b41fd 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -141,6 +141,11 @@ void dm_cache_metadata_set_read_only(struct dm_cache_metadata *cmd);
 void dm_cache_metadata_set_read_write(struct dm_cache_metadata *cmd);
 int dm_cache_metadata_abort(struct dm_cache_metadata *cmd);
 
+/*
+ * Query method.  Was the metadata cleanly shut down when opened?
+ */
+int dm_cache_metadata_clean_when_opened(struct dm_cache_metadata *cmd, bool *result);
+
 /*----------------------------------------------------------------*/
 
 #endif /* DM_CACHE_METADATA_H */
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 17f37db57b5e..51453f01a7ea 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2958,6 +2958,9 @@ static dm_cblock_t get_cache_dev_size(struct cache *cache)
 
 static bool can_resume(struct cache *cache)
 {
+	bool clean_when_opened;
+	int r;
+
 	/*
 	 * Disallow retrying the resume operation for devices that failed the
 	 * first resume attempt, as the failure leaves the policy object partially
@@ -2974,6 +2977,20 @@ static bool can_resume(struct cache *cache)
 		return false;
 	}
 
+	if (passthrough_mode(cache)) {
+		r = dm_cache_metadata_clean_when_opened(cache->cmd, &clean_when_opened);
+		if (r) {
+			DMERR("%s: failed to query metadata flags", cache_device_name(cache));
+			return false;
+		}
+
+		if (!clean_when_opened) {
+			DMERR("%s: unable to resume into passthrough mode after unclean shutdown",
+			      cache_device_name(cache));
+			return false;
+		}
+	}
+
 	return true;
 }
 
@@ -3539,7 +3556,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type cache_target = {
 	.name = "cache",
-	.version = {2, 3, 0},
+	.version = {2, 4, 0},
 	.module = THIS_MODULE,
 	.ctr = cache_ctr,
 	.dtr = cache_dtr,
-- 
2.49.0

