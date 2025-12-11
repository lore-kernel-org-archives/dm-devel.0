Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFA023D7FD
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 07:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765439713; cv=none; b=W27epqRnd3qLfcQYie2d0BC25gaXqdQKS4p/lh5XkyU/S1huIutriz56Y+x0Wreuw7+N2Zvv+wRN1XXqAcRXDj12wMVAkms2zAZOB/vc5UTvgvgLcDOb3GqqbtpVVcLXwZNQbQ4EuNLTRSouyY4Y0J04ilcSUj4l0L/5r8tfYC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765439713; c=relaxed/simple;
	bh=bj207h8uSrkffWH5qP68+umP1OYkPLT3VDTtGSJMO6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WuSVyDSx/hbICp8u+jqcZmePEBprQ0N/4rJBkzKpFUl2dvoKjoi+VFQoM+aha4FBsuLSasQymTRGiufW13a64y69xFtpM422itt1wIpqVrjI183yonLqlXoETE4ihSzM44B30Z6iRINKO8CkT1rDRRzVrNVLJ1ULdbCqawM2b5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLmQmAaM; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLmQmAaM"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-297e239baecso11895395ad.1
        for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 23:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765439711; x=1766044511; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qKWVKPzLuhfTBWpFzVu/LiiVmYESEYcE/zJYLXlYBTg=;
        b=GLmQmAaM04foIdrtM+S1fa65iDT9cTFxIlnbWLhmML7G1sviKUVkMsviruh15NjOi6
         WmDPH1xQiwc0xf7pnqZztWOueOU7fGpqx2UZGYXxO1JZb9EHmx0YZjcVoOQgarCu5qOU
         ECtNNaY77iXrhHroRcEsMgUGkhaGV5es0mAbTvuW8hbVLyEr7K+oV6/hfgDsJlyCT3u0
         Q6nBfv+ELWMDTu3yAf0DPLdV99F6G0t/vds1dfnANwyN8BoeHUtafYif9FqSTT+hfdfb
         6+/Kh9QPXHakzLhmw5e7lSdiz2KXsesiNEfMBKUvqzTYNcGDGxHvyMmB+Oe3vy/p9Hj8
         EHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765439711; x=1766044511;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKWVKPzLuhfTBWpFzVu/LiiVmYESEYcE/zJYLXlYBTg=;
        b=cRF4MTX+TZYfTH0d1YA7rMDj37fCgqOw4qw5yPt3pXMxsUai2M6Y0MYB+547Nhgbkx
         iBEyaMrRLDsmx958Z1CS0rg72Gd+Z6+xbintItwL92HPUvRkqofXhkLLkQO1lKzrx5Jg
         QvJXcinhLeUoosrxov7M98e7WaYUiA+nroCyBNQvQuzOCIzKUelfJuHsCYmi0qQzq6Mb
         Xa2ugRvMY1R+LhuFdTicT+QvQceUZpq9DPEb/XIcgTfzOOejgnMNjUPy/EqhjGOVxL8b
         0Hl9pMopOhQsJ7syy690poxXzsTs6CED7olFh+LgjIaQfhNwbXfPRWnxK2qy5oTc+u5b
         WRMg==
X-Gm-Message-State: AOJu0YyjXKNo/tO6QIjebhRCfgDWViJvpJbx626D1Q9cLx9KqkhS69O2
	Ik5DmM3tYKPCq7vzw9k0AEJo47jiwZX2qRE7fmt+eoTdvLN4kM5nRgoN
X-Gm-Gg: AY/fxX4m4Y4t3zsInVbSo2nCDvj7QkGDHUR0TCzmr9N7ZX5HMrp6cyX9C7N+vERfVfl
	Wd51FcNwuOzPxqIOXwjZ8Sdq+SF+EWn74llS1rqshdinLrStGwH+vBu4oSEG0v6lnNEvW/YfRjj
	zrRIm1/fhevQ9akzD+RxitHUgSKeM4pFL23opEn6ZSAxABlNh5B4LAONWL25IOGQI4mzgyuLt6e
	hVIrWfaIsMFMxF5aJl5Z3IdyuKHBQ3V3TADGPFA9yvj03hmHRGO1ljRt7N0nNmYCRgDBQ+lqLJP
	6eczJKH/B4fyl91bWwaV/LXyEOOVqQRbyjZ17EnzPxIEkjly1Dxchk8pjulLHb2gQyer7REwZOV
	ugdDfQd9NQfBttFIlkM2CpZwDwZBsQPZv/HvFz0alRDedwkx9MEVOGi0rMlXL8GDgnEoEfKGmek
	nGi+SA1qSTzgoAXqgaP642xUqiqUf0ZzPa5V0e7ZgxEvst4aLKiO9FgEMdAw==
X-Google-Smtp-Source: AGHT+IGICY+vE8znVGhyg/DjeurKj6Nf71EO9cfHtYq7oz0zyHxY+MfSsX5SWHhSsipxTgItK7+m4g==
X-Received: by 2002:a17:902:ef49:b0:29d:7f69:2853 with SMTP id d9443c01a7336-29eeef628cfmr13840115ad.28.1765439710771;
        Wed, 10 Dec 2025 23:55:10 -0800 (PST)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b374a9sm15930095ad.11.2025.12.10.23.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 23:55:10 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH v2 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid unnecessary discard bio splitting
Date: Thu, 11 Dec 2025 15:55:02 +0800
Message-ID: <20251211075502.160737-1-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

Currently, the max_hw_discard_sectors of a stripe target is set to the
minimum max_hw_discard_sectors among all sub devices. When the discard
bio is larger than max_hw_discard_sectors, this may cause the stripe
device to split discard bios unnecessarily, because the value of
max_hw_discard_sectors affects max_discard_sectors, which equal to
min(max_hw_discard_sectors, max_user_discard_sectors).

For example:
root@vm:~# echo '0 33554432 striped 2 256 /dev/vdd 0 /dev/vde 0' | dmsetup create stripe_dev
root@vm:~# cat /sys/block/dm-1/queue/discard_max_bytes
536870912
root@vm:~# cat /sys/block/dm-1/slaves/vdd/queue/discard_max_bytes
536870912
root@vm:~# blkdiscard -o 0 -l 1073741824 -p 1073741824 /dev/mapper/stripe_dev

dm-1 is the stripe device, and its discard_max_bytes is equal to
each sub device’s discard_max_bytes. Since the requested discard
length exceeds discard_max_bytes, the block layer splits the discard bio:

block_bio_queue: 252,1 DS 0 + 2097152 [blkdiscard]
block_split: 252,1 DS 0 / 1048576 [blkdiscard]
block_rq_issue: 253,48 DS 268435456 () 0 + 524288 be,0,4 [blkdiscard]
block_bio_queue: 253,64 DS 524288 + 524288 [blkdiscard]

However, both vdd and vde can actually handle a discard bio of 536870912
bytes, so this split is not necessary.

This patch updates the stripe target’s q->limits.max_hw_discard_sectors
to be the minimum max_hw_discard_sectors of the sub devices multiplied
by the # of stripe devices. This enables the stripe device to handle
larger discard bios without incurring unnecessary splitting.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
---
v2:
- When an overflow occurs, assign (UINT_MAX >> SECTOR_SHIFT) to
limits->max_hw_discard_sectors.
---
 drivers/md/dm-stripe.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 1461dc740dae..4b25cf09e3ac 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -38,6 +38,9 @@ struct stripe_c {
 	uint32_t chunk_size;
 	int chunk_size_shift;
 
+	/* The minimum max_hw_discard_sectors of all sub devices. */
+	unsigned int max_hw_discard_sectors;
+
 	/* Needed for handling events */
 	struct dm_target *ti;
 
@@ -169,6 +172,8 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * Get the stripe destinations.
 	 */
 	for (i = 0; i < stripes; i++) {
+		struct request_queue *q;
+
 		argv += 2;
 
 		r = get_stripe(ti, sc, i, argv);
@@ -180,6 +185,13 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			return r;
 		}
 		atomic_set(&(sc->stripe[i].error_count), 0);
+
+		q = bdev_get_queue(sc->stripe[i].dev->bdev);
+		if (i == 0)
+			sc->max_hw_discard_sectors = q->limits.max_hw_discard_sectors;
+		else
+			sc->max_hw_discard_sectors = min_not_zero(sc->max_hw_discard_sectors,
+					q->limits.max_hw_discard_sectors);
 	}
 
 	ti->private = sc;
@@ -456,7 +468,7 @@ static void stripe_io_hints(struct dm_target *ti,
 			    struct queue_limits *limits)
 {
 	struct stripe_c *sc = ti->private;
-	unsigned int io_min, io_opt;
+	unsigned int io_min, io_opt, max_hw_discard_sectors;
 
 	limits->chunk_sectors = sc->chunk_size;
 
@@ -465,6 +477,10 @@ static void stripe_io_hints(struct dm_target *ti,
 		limits->io_min = io_min;
 		limits->io_opt = io_opt;
 	}
+	if (!check_mul_overflow(sc->max_hw_discard_sectors, sc->stripes, &max_hw_discard_sectors))
+		limits->max_hw_discard_sectors = max_hw_discard_sectors;
+	else
+		limits->max_hw_discard_sectors = UINT_MAX >> SECTOR_SHIFT;
 }
 
 static struct target_type stripe_target = {
-- 
2.43.0

