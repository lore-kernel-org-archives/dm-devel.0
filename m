Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0935D2144C7
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 10:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765188464; cv=none; b=PIWjD7SKQM6414IGbuaXo8h3N1ted+qOyEE/r7FvhTIWXv8TOa2iMlD9kO0Q9egUzXM34kNp5mCztggKDaV9xQyzebxZDDa8VECAlzItOj5Um+oMcEyCkUTjcLgq6nY9C05wgwTD9UGaICUrOMSBavBUg0erOtrGjkXNkm8T9oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765188464; c=relaxed/simple;
	bh=A0LDqK3J4MV4yZ+LoBAmVkd0Szp44FLyhXvr8p7gtUg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JSzPDRP3JDt1erpSPAjEZEOUK+JeTTdEOPEpiayY5KNAsdWe58Jfk+Yt2OGwx4t5nyMU+6UC4sfxu+2nYVVDAaMbEphhnIFBgz/g8P7J8WRrdcMlq/93yPOPX9TeqLazja0hXvr4wpTvUtiwo3K/qlrcvH6Nv1yHD55FNrNbwnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W1EBzd9E; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W1EBzd9E"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-340bcc92c7dso2884016a91.0
        for <dm-devel@lists.linux.dev>; Mon, 08 Dec 2025 02:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765188462; x=1765793262; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XFu3GSn0C+i9PCfJZeSywpKEXcq95Sm5vKrrD7lUgnc=;
        b=W1EBzd9Eg14gjq0LCrQjDnXSAidSTOO/C7RHPlD5cqyDViNdsuBGUF/h5bygN23LsD
         bqx/WnScWuNzayqGs+8xgDZGD/yj5du9Hepyp01keb641cRc+Rg61D+SjQJcFu1aABh1
         aOi5yjAVh9UubZXV788iPCG3C21IB8YKVrMWEoZeNIbpelVRMeQubfE3wWB9gLjk2svH
         eYwkPobFkIoCUVjGXC5YrGbZXlDLLkuMPThxx2AAPQ9qfB1LPYDZ+bDJ+GeNODlMMtkx
         qK4esmWmAir6qPzV1+lj3/FmPNHOvA/AUmzskJst5JUzNEcDaAIwcEN2cujy1EJfa2je
         lFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765188462; x=1765793262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XFu3GSn0C+i9PCfJZeSywpKEXcq95Sm5vKrrD7lUgnc=;
        b=wVoXbQ4X/Uz2Zv1B4dldfm5UUPvsN8cBwt7WNbEQ7hWfJZr3IVoogsXAmf5ekQTkTj
         7hNILNg7xN5u3ZrZjBRoIu+ZPGPELK7g5b4P5bHRIg/l3Yx5D8iqJ9weERf7FKGtuhL9
         w8BihSxXA9RYBZ2/U3zAo/TRFvLouc/eo/jy1f3MpiCfToOBVoDoW3Ynlc/NjuS89Fst
         tR/qFH1yfrmt1UmI2UwQ1x/gcvoOlY4J51IWWy2qt+u0XdA1WPN6I/QEhysm4Fw0FYgl
         xQa0F5Xz+NeYSP9oMNF4iBo9dp0oAh5RZjnMkrH+66L/n4s9D8D3AzESQawEI9UZt7LD
         9Iaw==
X-Gm-Message-State: AOJu0YyT/PC7aEcZrvquFDYBleW7aaIBcl4Q2Fh/Ht1Nf6HGRShCcUNy
	a7MKzqjuG2kJH2zsMAX8tIEfVn42rR30JZeagwWDDi0nG0AsVGN25zZc
X-Gm-Gg: ASbGnctwrzpgSV10R5MVtMeM5wDoXsYJYPwdmn7c++n+LQFhkZkRFUoFg77Y5KoMbdP
	4tSYSPQ8L9MnNcj7ln6ldatc0ACJsR8K9zqEESY+sjl0j3O27N+B2nyBBvddz22ZF78lSbA9A/v
	wxbG4YsqiAmb6y3X4l2kLCVwz9yVrm3s8n1/qmvZeEy5SJ0ymS0k2fd7kRLPHLijmyMlVGmkdeq
	p9nAY6i2673fICWKRPRA+Vm5QaO+yiifEU00pQtdrVxrCU35ITVt9SQFHnh4L+q8J/kXzneOsvu
	sjFw0FXL408fvID8KGh7swY2MtvVB0NOeVxdQJvu9Rvz8H+nIOLU756NXLxIjp/fUROmbn6Y/Bi
	4XpLNmn1C6oI/ZfixGkEu6wCEKvqwNHXtEFFr/GQqyTld0KfZ9UgkTOTksvbo7RepPnPuTXduld
	YPE53Pt7HxPXHCw9OEMYWZ2ROJ2F1ORxn5Gps56tYjALG+UCnmOIuIwV5pTA==
X-Google-Smtp-Source: AGHT+IHzeE2i429hb+drAPS0xTiLbqdO9FhnxW1yeLH6rUqTHDeoSq8awwBO0CXxhO9PNaz4hASAHg==
X-Received: by 2002:a17:90b:48cd:b0:340:29a3:800f with SMTP id 98e67ed59e1d1-349439278bbmr13656087a91.15.1765188462207;
        Mon, 08 Dec 2025 02:07:42 -0800 (PST)
Received: from xiaomi-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3494e852262sm11665369a91.8.2025.12.08.02.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 02:07:41 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH 1/1] dm-stripe: adjust max_hw_discard_sectors to avoid unnecessary discard bio splitting
Date: Mon,  8 Dec 2025 18:07:14 +0800
Message-ID: <20251208100713.697542-2-yangyongpeng.storage@gmail.com>
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
 drivers/md/dm-stripe.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 1461dc740dae..799d6def699b 100644
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
 
@@ -465,6 +477,8 @@ static void stripe_io_hints(struct dm_target *ti,
 		limits->io_min = io_min;
 		limits->io_opt = io_opt;
 	}
+	if (!check_mul_overflow(sc->max_hw_discard_sectors, sc->stripes, &max_hw_discard_sectors))
+		limits->max_hw_discard_sectors = max_hw_discard_sectors;
 }
 
 static struct target_type stripe_target = {
-- 
2.43.0

