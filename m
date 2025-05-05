Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FAF3628D8;
	Mon,  5 May 2025 23:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486020; cv=none; b=Dsnn7vD8R8YTCN+NsaHeXq5h+s0R+V9r7JwPLUTHhsWf3NxRTs3KsGysd4ShSiF7NtH4iuk06YxwrpanLgB3w1Ng+rd8QAa6lwqcLoWr0Ucrz0HXCcV2rn240baJfobQb8zx2+9CTsC5dVdO5SvFx1oyD9Idi+LkgZa/puacNUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486020; c=relaxed/simple;
	bh=w77OVwFOBIqkTQWSAcVJmtejwe6G3YJjUFKC8U+KbCg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aZWszP5BNybiu71Gf70DKHr2iLDoWN1CtOUj67OSwcpMZ4CqfnFcDR/9/YIbz4JK9rr7KH8U/HQv+2GFNjOuk85NQdFAxwGf4d+KS+tE2mpfSQrDmz7Jw0sbY3279EAeSW8TVZynGT8lGHQOGc76JwyY08VqUXI7BQJQXE59ns4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2SVAg/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2SVAg/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3957C4CEE4;
	Mon,  5 May 2025 23:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486018;
	bh=w77OVwFOBIqkTQWSAcVJmtejwe6G3YJjUFKC8U+KbCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2SVAg/NHbVvYZ/9hOsmJeFs1BuC7dgrFcemi4y0eeat2OEKVQ9q7VNM/M2F/ZHLW
	 F/jlOgVMKMRSjTTKXnHtFgj6NGxGtnUVuSOtCtQyv0aHOAZR9Z4c0OD3ruEO5qygMY
	 bksoYpZVzftZcSljh1C1nHMGVZCEtyTLFq/hr5pvQGsymwtDHxwS85z9khdrzrjJir
	 N0BiVJ61q2WZVTCayj1G25rJx3WUwX9ttkFuc0m6YZtJVq8JDWJZevYdHV+sM3Zd+e
	 S3ZSeL+Wd5RVSU7Sl7cLnY4hOHRb9YdGHWPWC3fiG/cCw7nidvrcu0NxozH8qHHXs7
	 i/GhkEVTK/8Bg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.6 113/294] dm cache: prevent BUG_ON by blocking retries on failed device resumes
Date: Mon,  5 May 2025 18:53:33 -0400
Message-Id: <20250505225634.2688578-113-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
Content-Transfer-Encoding: 8bit

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 5da692e2262b8f81993baa9592f57d12c2703dea ]

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
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index c5851c9f7ec04..0d002d50329da 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2903,6 +2903,27 @@ static dm_cblock_t get_cache_dev_size(struct cache *cache)
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
@@ -2951,6 +2972,9 @@ static int cache_preresume(struct dm_target *ti)
 	struct cache *cache = ti->private;
 	dm_cblock_t csize = get_cache_dev_size(cache);
 
+	if (!can_resume(cache))
+		return -EINVAL;
+
 	/*
 	 * Check to see if the cache has resized.
 	 */
-- 
2.39.5

