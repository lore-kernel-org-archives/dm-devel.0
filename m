Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792858545;
	b=Qrk+cF5BfSYq5yyiaUHIDmi7luyzVmUXkizvNCNVZwy/vp3AqBdhQWjchAceed5YmWog
	 tzKajXJ/+0DoI9zNGB77rgKEScEAe2/5fhCMHbdgIgRvGECrwOm2/hBqqyicmwd7CI4Cr
	 d7ASogakfw6Q82Jvc+PGLKSRZAuPEfcU9sHi/8J7/6C6DEVBP10xd3LugD4rQ8FEVz933
	 kH3RRagzgi+WeRx2VJsxgJVhuXiMhGStEdjW/k1KflKtKUNMnaHgIQpZi+VgcfAALBUV3
	 /luihRO/z6tYVabMtWXzxpQduis5sOgkVr8PN8ehYu12kBWHPmN3pVa+ZZadgzv3zKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792858545;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sWPRyWlGaMNiQpJpvF0wXPtyt8f20HZGodlR95AlKmA=;
	b=sEo00xwxslvF89EbgffaRaA/aUOmDO7VoQgJv3KCumY0PRpEJUh4FZ3LQ3qOJ2llL0dS
	 spjJPaQ++1Vi8oPcoLjNyCzki+ubHWDBBTQVzNljtE3IUoyWxAdWF97ryWaLcuvmmb8j1
	 bceJZvIay26k7fOmJVBQxEXV/R5teFp/Qz6R30CSbtRjyn4nsyrNanMtiPVd4JAD/P5ms
	 qMeQqFalk/jkVmQNgS/1iM3H3ZhYM46oGmXTWyceOQll/frzG+GbgYqoKGJtnjO2xQIFf
	 SShApEKoc5Jae90oSwBgjbLzA3hzIWA5gKiSdqXCMmAcExjbjWyiLsgh3t1jm1MhMxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TnAc5K1w;
	arc=none smtp.remote-ip=209.85.208.178
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA08D606A320
	for <dm-devel@lists.linux.dev>; Sat, 24 Oct 2026 16:15:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA08D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TnAc5K1w
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3a9787a156eso14579011fa.3
        for <dm-devel@lists.linux.dev>; Sat, 24 Oct 2026 09:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792858543; x=1793463343; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sWPRyWlGaMNiQpJpvF0wXPtyt8f20HZGodlR95AlKmA=;
        b=TnAc5K1wJOo/Tucp9dI7LvocRNL4SA5kgAYwFnhnpaB/lNkRJ/wKrJmKMpfR14JIvU
         DpZYJoapS0ZCBfe5X9daRMYsOU4eR3s2su2DmjN2hStNLi7jz75nu+zNQ7NSCxEj2S7v
         /mbahDGGl+K5+APfu2EYZ1dN22Hz4OXo+yYwwFH7UWYnmbr0ogFNbU4V8mJemZUbhZZs
         PTMOWubom18eAqQe1tahf7ku0L4eedkbnuiU5YSX4BikdtQK9uXpcm0hgSSte4zqsxvT
         dgqzYjlQBJNszcnAAou9Wm5EwWhe1PfXoVgMu6gmk5/rRofxNdqEjMfeMvSEH02VCrq4
         1p5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792858543; x=1793463343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sWPRyWlGaMNiQpJpvF0wXPtyt8f20HZGodlR95AlKmA=;
        b=SYwE2safZlkdWOHC0EnXd3gVkdi3CXAWmyg/AaL539O90lwPdGYZy8cJez3Qgcqtke
         KHGjtlmFBZ09pu6tCkWd3AC/BqxFusuhUTUo9ezuXevzhzyydqPNUr6y2xZp4VbuXXx6
         HK5AeKNmX3z3FvipJF1WDuBF81B3ZUxjnkIWtGyNW0B7ANTcqlgfYUJ6S2YviDBhPc1z
         TUjgHTlaGTyjz1RabsEQX5WH3dgPzShbOpKRP410dyEIyJcYG4TGzYb9HAYw2frkvo4c
         smyNbmJEOtKOQNdbT/aGAbGoGikSt0J3Zh/cWDV9eATkJOVBIPwEIEhUo/bzdF2kBigm
         8ZPg==
X-Forwarded-Encrypted: i=1; AKwUvBwEIqH8JxZMrwQdHlZLVosxVw4cDzlQG36um/gjCt80QACxoAFM9+PUHA8Tl6bYDA0roSJgKGHW7Q==@lists.linux.dev
X-Gm-Message-State: AFq9FYL/571gNEzklboVXVSj/RYEykkvUfbT9IHZs7PcHSR4JTlLTIQJ
	ryh/Z7RcMRP1YlMY8djVs3+ioDdk4nPpZcZc2Qiyzxa17oQ1h8656lj5
X-Gm-Gg: AYBFou1SXHoBPrAK9vy1Ae+ZHg1euo+e6jacVHIadrTMreH9b0JvAbSPPhLdXrM5DYL
	yEguqWx73QQDMHARJjxez9naFPhEijowPj5Ey7OwA9P/mkZClqD9SZSlQHs+5rMIuvcQvWiNncF
	2Z55Qq1B47P+4V4zFJsOg0koBiDZPYNPO50cdk/IAayHcGLYbA5Wx/pMnmsYNCKt6SuKRs9WNUZ
	aUo4ttpfHzVe84Vj+ZmfSVIUrfgrdK/P0fx+HmYDo7BtZ+GevGvnqrhB9Lhc+s8CXYjDcsAhpC3
	3Bcrd4vqZEIQbCrdPzBKVdBzbVPF5/uRcyzj9hkSjUKGV2AdUqweOVi6t9hmSzkPohPIryC3qfv
	TlyLAAOpZxu/mXss+OmVEyQ4vdC+7RgaNTwPVSgiqjo3AuTPFv5yzqlY1bxWUJAAZ4lUg79yK6O
	lQkG0nzQ25+v/BQs4vYuiNnP03nOAEECA/zkdl2WRgUBv5GHGhbJ0LMjEXOGKW8S3uSJ9mK/4lR
	UUVdJh0V6nLup/0kGW6dLJk+bady6BzXYB6smE98l6ocPUX3jVSdYo7MD8/+wHJBqBF41L3oYYG
	P9KhVQHA0NqMQbPglSC9Y0rhzlqlocWwoqGqiNQpByCH6qn6fT/g2e2YV1BY
X-Received: by 2002:a05:651c:211c:b0:3a6:553d:cb1c with SMTP id 38308e7fff4ca-3ac6fceb510mr5573981fa.12.1792858542702;
        Sat, 24 Oct 2026 09:15:42 -0700 (PDT)
Received: from x870steellegend.lan (95-25-165-240.broadband.corbina.ru. [95.25.165.240])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ac70a493b6sm5645121fa.37.2026.10.24.09.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 09:15:42 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: Mike Snitzer <snitzer@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+8e6fc64255334ccf3ab3@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH] dm snap: fix use-after-free when origin and COW devices match
Date: Sat, 24 Oct 2026 19:14:59 +0300
Message-ID: <20261024161459.5539-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When snapshot_ctr() parses target arguments where both origin and COW
paths resolve to the same underlying block device, a slab-use-after-free
occurs.

The origin device is acquired first with origin_mode (e.g. BLK_OPEN_READ
or BLK_OPEN_WRITE). When opening the COW device with dm_table_get_mode()
(typically BLK_OPEN_READ | BLK_OPEN_WRITE), dm_get_device() sees that
the device is already in the table list and calls upgrade_mode() because
the requested mode is broader than the existing one.

upgrade_mode() opens a new table_device, points dd->dm_dev to it, and
calls dm_put_table_device() on the previous one. Since the refcount drops
to zero, the old table_device is freed. However, s->origin still holds a
pointer to that freed table_device. The subsequent check:

    if (s->cow->bdev && s->cow->bdev == s->origin->bdev)

dereferences s->origin->bdev, tripping a KASAN slab-use-after-free read.
Furthermore, under the bad_store error path, dm_put_device(ti, s->origin)
fails to find s->origin in ti->table->devices because dd->dm_dev was
replaced, leaking the device reference count.

Fix this by resolving cow_path to a dev_t via dm_devt_from_path() and
verifying that it does not match s->origin->bdev->bd_dev before calling
dm_get_device() for the COW device.

Fixes: 26110d5afe81 ("dm-snap: simplify the origin_dev == cow_dev check in snapshot_ctr")
Reported-by: syzbot+8e6fc64255334ccf3ab3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8e6fc64255334ccf3ab3
Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 drivers/md/dm-snap.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7c3725e4ac54..4a7c04c780d1 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1232,6 +1232,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	int i;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
+	dev_t cow_dev;
 	unsigned int args_used, num_flush_bios = 1;
 	blk_mode_t origin_mode = BLK_OPEN_READ;
 
@@ -1274,15 +1275,21 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv++;
 	argc--;
 
-	r = dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow);
+	r = dm_devt_from_path(cow_path, &cow_dev);
 	if (r) {
 		ti->error = "Cannot get COW device";
 		goto bad_cow;
 	}
-	if (s->cow->bdev && s->cow->bdev == s->origin->bdev) {
+	if (cow_dev == s->origin->bdev->bd_dev) {
 		ti->error = "COW device cannot be the same as origin device";
 		r = -EINVAL;
-		goto bad_store;
+		goto bad_cow;
+	}
+
+	r = dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow);
+	if (r) {
+		ti->error = "Cannot get COW device";
+		goto bad_cow;
 	}
 
 	r = dm_exception_store_create(ti, argc, argv, s, &args_used, &s->store);
-- 
2.47.3

