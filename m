Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED574301493
	for <dm-devel@lists.linux.dev>; Mon,  3 Aug 2026 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766344; cv=none; b=En+fGJhXi/vmIO8HEBPDL9qf8QcUVuHDzrekpBnCcqo9QLdPKdMfKlZYEZ+JPMpDn+Jy82UKziXMtQJokEFJwrx/+Cg5gcAYheFeiCPsKvcSXrzp5ahQXmE96MLwTQwd+FHmPBHg7lgde7tx2CsLj0ge8hsI5JdAC6H1BF+8Mxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766344; c=relaxed/simple;
	bh=BbpslXywfD0iTpZteroQReQ4uidHwvn2ta6HC9rpZn4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qUhOdd6kZPvUgffdjRyN4cWyfoDtUjRw4rIRfPcEh3kIQ004xowQA2+vYV/EE+PGPQEe/9IBbAIZuT+MHGc8ULy9rM6i2fKQt7Ne1uzRrOh2gqkQLJOyODstHRF0MIM4J/Ji6YJ5kQYmZpcvcZsyyzdlFgs5+9Z/WzqvjS1/Ze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=dYMbaPF8; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="dYMbaPF8"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e6a434cabso154765685a.1
        for <dm-devel@lists.linux.dev>; Mon, 03 Aug 2026 07:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1785766341; x=1786371141; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qAleDQ8MfrNQGQUDixmHN9nrOWbjKoQY0SCnYduBErY=;
        b=dYMbaPF8XXMv+4dMh7YJ2UMx0jH9XqYWvcd4eP/U/zL0EMU3u+C4+hJziWQBsicTln
         hznZXj3VjGZpLncsO1Ki7KxKflFzBQtIt5AQEQ0lYJHxc8jBw6MdFRNMovsR8hfqoR2W
         cC08eOT5v3Vr4ByXIonS+OzWBF1rLSCu4Vnn0LPYA8xyIs5MgqS9rjmUy/vdXjwrJ9Nq
         bGHAVhCy2h3iUeNRczbUL2kEn4o/Pe/ECnwLsvGzPqXo0RrVnsN7r2dtjYdiEZ7+Bdka
         wEsj3vOVppETBCWCXEkShmmZAxgx9K3OdBvl1ahsc81CUYKKpYZLgGpWdvjRd8HwSYEA
         n2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785766341; x=1786371141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qAleDQ8MfrNQGQUDixmHN9nrOWbjKoQY0SCnYduBErY=;
        b=JcRd9ZBe2p3j3pslFyy+GZ4BRMqXq0bj7HRgXuQOwrbAuWoc59PStMhccUgUbUaHn/
         cZ+sSCqq7f1PWA5V3QNnLT7d40tEJXZMp0JVx+f/Prh2d5/skNCLv1vGwDkgoyUkL27I
         JSFt4wWqv23SYBKhVslsgwBUle7fEsffI8aaD3ZfyaUijLtnVFXg69O0ZVz7yHmpKrBa
         3ESOIf62ojPXaiFCGYt2l+ZJp5ZpSklTRmkRGO6ysQ7UEMLfMY3DL4GoFVBxRmxF7awZ
         OGeWzST4cn8ayJIlY5kj8Lwx+tPdaizromxInehnozuekUkoPjcrecDLPHDZ0oEFaQN7
         RUiw==
X-Forwarded-Encrypted: i=1; AHgh+Rpm7jj+QdYD+shQIwPe09FTN29A2Tuo518SBvRPnGEuJ22IiMSSuJhtUgnnh1p8BPfS2mCt6yzdfw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxCyobwlWxbFgd3xMNq5D/PwzRhtRxu8cAPAWQucwb/3T0XD//r
	PGxVhYoz5a41v/PLRgbbKd0YPRyO8pkALfU5R9wKcmCuUO6CDUYt2mPsYmU0j4eu0LA=
X-Gm-Gg: AR+sD12I0xQgcpB6r2dHNlxfSyrdkf5b6R7QYg/Pkej1qc2vuT2ptZn6s6+ILvnvudf
	NzYon4RACQhO9lapw+OfwVQG+iqPQrRaZ/ZGsYEz21BUQP9yMbuQ5h68BiFfK7SvyB73oWjrsJ6
	oCJcS3tThXAp764KWXzhZ/dRD6Hy/nlmtrQVv0JQFcVIi7OeAjBbplANeiHVRDVFa622nktGPpg
	BiKJGR2fK9OIteXWdYHm8242NvcQqmhakUnLY1Vz1FJr/sosLhRT9vQh34xvDynwQd7fO/ns22Z
	yokwDcwXerXlToylgTEWDPseS7sp8kOsY8l4HHQldTX/Qb2/VnR4rD9+EqP7PJcMyDIIAPFjAPJ
	bnQYuKmG8ST+RrKsfYe4jWUg0Cfw22cKvHt/1O5XjjowjKSJ4UVrbs1R7UkHGs82eS7YmY6ewt7
	DgP2fuqtSauBDR8J6m6xxCZ1gBYZyvCT0ESbGtJRE6k8RHgTZ6LewGqrnJJsVpmz5i
X-Received: by 2002:a05:620a:2988:b0:92f:199:b035 with SMTP id af79cd13be357-934a06d57f7mr1631563185a.3.1785766340716;
        Mon, 03 Aug 2026 07:12:20 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9349c19f881sm677024385a.29.2026.08.03.07.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 07:12:19 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] dm dust: make badblock messages target-relative
Date: Mon,  3 Aug 2026 14:09:13 +0000
Message-ID: <20260803140905.383600.be823861719c.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-dust currently treats addbadblock, removebadblock and queryblock
arguments as block numbers on the underlying device. That is surprising
for a device-mapper target: a dm-dust table with a non-zero backing
offset can add bad blocks that are outside the mapped target, and a
badblock added for logical block 0 is missed because the I/O path checks
the remapped backing-device block instead.

Interpret badblock message arguments as blocks relative to the start of
the dm-dust target instead. Bound the arguments by the target length and
perform badblock lookup using target-relative sectors before remapping
the bio to the underlying device.

This intentionally changes the non-zero backing-offset behavior to make
the badblock control interface match the mapped dm-dust device, rather
than the underlying device.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
Changes in v2:
  - Revise commit message
  - Remove call to sector_div() in __dust_map_write()

 drivers/md/dm-dust.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index c7e3077fb1f5..954f4ec5a51c 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -196,7 +196,6 @@ static int __dust_map_write(struct dust_device *dd, sector_t thisblock)
 		dd->badblock_count--;
 		kfree(bblk);
 		if (!dd->quiet_mode) {
-			sector_div(thisblock, dd->sect_per_block);
 			DMINFO("block %llu removed from badblocklist by write",
 			       (unsigned long long)thisblock);
 		}
@@ -224,15 +223,16 @@ static int dust_map_write(struct dust_device *dd, sector_t thisblock,
 static int dust_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dust_device *dd = ti->private;
+	sector_t dust_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 	int r;
 
 	bio_set_dev(bio, dd->dev->bdev);
-	bio->bi_iter.bi_sector = dd->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
+	bio->bi_iter.bi_sector = dd->start + dust_sector;
 
 	if (bio_data_dir(bio) == READ)
-		r = dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
+		r = dust_map_read(dd, dust_sector, dd->fail_read_on_bb);
 	else
-		r = dust_map_write(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
+		r = dust_map_write(dd, dust_sector, dd->fail_read_on_bb);
 
 	return r;
 }
@@ -415,7 +415,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			char *result, unsigned int maxlen)
 {
 	struct dust_device *dd = ti->private;
-	sector_t size = bdev_nr_sectors(dd->dev->bdev);
+	sector_t size = dm_sector_div_up(ti->len, dd->sect_per_block);
 	bool invalid_msg = false;
 	int r = -EINVAL;
 	unsigned long long tmp, block;
@@ -462,8 +462,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			return r;
 
 		block = tmp;
-		sector_div(size, dd->sect_per_block);
-		if (block > size) {
+		if (block >= size) {
 			DMERR("selected block value out of range");
 			return r;
 		}
@@ -490,8 +489,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			return r;
 		}
 		wr_fail_cnt = tmp_ui;
-		sector_div(size, dd->sect_per_block);
-		if (block > size) {
+		if (block >= size) {
 			DMERR("selected block value out of range");
 			return r;
 		}
-- 
2.43.0

