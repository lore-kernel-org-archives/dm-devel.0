Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C8F207DE2
	for <dm-devel@lists.linux.dev>; Thu,  6 Mar 2025 08:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741250538; cv=none; b=WR9AAmjPDwwkOlq6T4Y5+RccejREVBaNZ70AW2jEmbv0WyVecrhsC0E5RxMuQvh4hPR5NnBb6JDt8WUAl56LOPDHcHbci+QHd4Zza0Vc2IPKu+8XJJErhpalQvAUxI7j9r9aYb+DBEdhkBfVUjncLD6VtTufPl3nlhq3lJRDgcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741250538; c=relaxed/simple;
	bh=movOdMLVk1g2ahfGdAn0oI/QZx5w0fU7w79vlhTPiFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hVv2EpYCoTOFNi4dRr/uJQTyY3t2KFtY3ldGE1fPcAlCT+HaZg5Wydps64R7jQATCGbjLLsxlrUF3a1jTvYj9Npn+MzztciARS1EeiZXAuAUm7SskPfFfn/9DbWYDiHJQuV857KMFtBGh604mIC3dzcyVcygrG29YSu8Km2ZcH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dNjuQFG3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dNjuQFG3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741250535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ivBZHnz6Qi50odKEW+nseJ8kl+/UWUd1Tx7nCqI/tqs=;
	b=dNjuQFG3ovNygymk9m14yZC6o4xpgKdyBM8uCNutUsYg+tsQRJAm7/V++4VZW6WG1oCPUK
	xn0lo0jY2+e2O2mMX27CQpa73MTW/UndvpNnH7oBOyBJtG6j29y5Px/BHFN9HrxLZPZX6d
	sDKRcxUPDWkJQokQqb3KHCX34x/bX7k=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-7SLr-3tPO1mgMLAUB6Zw4w-1; Thu,
 06 Mar 2025 03:42:13 -0500
X-MC-Unique: 7SLr-3tPO1mgMLAUB6Zw4w-1
X-Mimecast-MFC-AGG-ID: 7SLr-3tPO1mgMLAUB6Zw4w_1741250533
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C911E1955DCD;
	Thu,  6 Mar 2025 08:42:12 +0000 (UTC)
Received: from thinkpad.redhat.com (unknown [10.67.24.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 372BB300070B;
	Thu,  6 Mar 2025 08:42:08 +0000 (UTC)
From: Ming-Hung Tsai <mtsai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Joe Thornber <thornber@redhat.com>,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Ming-Hung Tsai <mtsai@redhat.com>
Subject: [PATCH v3 1/2] dm cache: prevent BUG_ON by blocking retries on failed device resumes
Date: Thu,  6 Mar 2025 16:41:50 +0800
Message-ID: <20250306084151.371591-2-mtsai@redhat.com>
In-Reply-To: <20250306084151.371591-1-mtsai@redhat.com>
References: <20250306084151.371591-1-mtsai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N2Lnfg0lfaM9uk3l2vuTsvVC0gu1yHX7co2IQFETDHA_1741250533
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

A cache device failing to resume due to mapping errors should not be
retried, as the failure leaves a partially initialized policy object.
Repeating the resume operation risks triggering BUG_ON when reloading
cache mappings into the incomplete policy object.

Reproduce steps:

1. create a cache metadata consisting of 512 or more cache blocks,
   with some mappings stored in the first array block of the mapping
   array. Here we use cache_restore v1.0 to build the metadata.

cat <<EOF >> cmeta.xml
<superblock uuid="" block_size="128" nr_cache_blocks="512" \
policy="smq" hint_width="4">
  <mappings>
    <mapping cache_block="0" origin_block="0" dirty="false"/>
  </mappings>
</superblock>
EOF
dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=2
dmsetup remove cmeta

2. wipe the second array block of the mapping array to simulate
   data degradations.

mapping_root=$(dd if=/dev/sdc bs=1c count=8 skip=192 \
2>/dev/null | hexdump -e '1/8 "%u\n"')
ablock=$(dd if=/dev/sdc bs=1c count=8 skip=$((4096*mapping_root+2056)) \
2>/dev/null | hexdump -e '1/8 "%u\n"')
dd if=/dev/zero of=/dev/sdc bs=4k count=1 seek=$ablock

3. try bringing up the cache device. The resume is expected to fail
   due to the broken array block.

dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
dmsetup create cache --notable
dmsetup load cache --table "0 524288 cache /dev/mapper/cmeta \
/dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
dmsetup resume cache

4. try resuming the cache again. An unexpected BUG_ON is triggered
   while loading cache mappings.

dmsetup resume cache

Kernel logs:

(snip)
------------[ cut here ]------------
kernel BUG at drivers/md/dm-cache-policy-smq.c:752!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 332 Comm: dmsetup Not tainted 6.13.4 #3
RIP: 0010:smq_load_mapping+0x3e5/0x570

Fix by disallowing resume operations for devices that failed the
initial attempt.

Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
---
 drivers/md/dm-cache-target.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 9cb797a561d6..6cee5eac8b9e 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2899,6 +2899,27 @@ static dm_cblock_t get_cache_dev_size(struct cache *cache)
 	return to_cblock(size);
 }
 
+static bool can_resume(struct cache *cache)
+{
+	/*
+	 * Disallow retrying the resume operation for devices that failed the
+	 * first resume attempt, as the failure leaves the policy object partially
+	 * initialized. Retrying could trigger BUG_ON when loading cache mappings
+	 * into the incomplete policy object.
+	 */
+	if (cache->sized && !cache->loaded_mappings) {
+		if (get_cache_mode(cache) != CM_WRITE)
+			DMERR("%s: unable to resume a failed-loaded cache, please check metadata.",
+			      cache_device_name(cache));
+		else
+			DMERR("%s: unable to resume cache due to missing proper cache table reload",
+			      cache_device_name(cache));
+		return false;
+	}
+
+	return true;
+}
+
 static bool can_resize(struct cache *cache, dm_cblock_t new_size)
 {
 	if (from_cblock(new_size) > from_cblock(cache->cache_size)) {
@@ -2947,6 +2968,9 @@ static int cache_preresume(struct dm_target *ti)
 	struct cache *cache = ti->private;
 	dm_cblock_t csize = get_cache_dev_size(cache);
 
+	if (!can_resume(cache))
+		return -EINVAL;
+
 	/*
 	 * Check to see if the cache has resized.
 	 */
-- 
2.47.0

