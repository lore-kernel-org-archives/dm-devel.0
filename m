Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793734846;
	b=sm4naDHTO1/ifGauKWn5P2lr/4hhAHpTikm9RFG+sYD2cHWutM4Qx7c/GB8eLC6g8f0N
	 dQAS9oHuO7n15+IUiZNjnKAW/usooguzi4kMCw69nEGdvffMzkmdmwHhjCP3kPBdbJ6bO
	 84fl+ZXOBBO5rVT/qHHYyL4CscES0VRJqch4eUI+yQoOhjr+pN7ExdKSgJHVVYPszpXeU
	 UfZ1PHSkblVvIi0K98AGl5mbxrjsGq7bOhVqD0asLu5WxtRw/La1IXiyAAjfJGpZS/Ic9
	 fEPYW7iiVkaC9+qoM3TMIKiRfiMKTCzkPl+ZEs3QDGfbGi1KzTp2R32ETC7DsMpDhwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793734846;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=oJsaIKd5l9uiGNbvOYkLF4O3e4NVImhPcBxcGBYx/v8=;
	b=xqhL7v1TW9P+dO0FkJQR+bsOx7BuCibZv7LjYhEpYDivaKUr0dQfQDrwWXVXVX37hJPL
	 /M1JK/G/7N7i+G6bmQ7UspabbfCJteRYAeK+uID4l2hdiny6/24YTVd8+Za2ZYO2tkkcR
	 TqOJL07Q4S3okTaku0zVZhJWzAYBxlabe31cCqAwiOtu9Xz5XAZjikOv6Vax9Cp882PbX
	 wpdpbiO3zhdmvgvhyQrLqaWnZn6pC9saukuQ81d2ARBDVqNtYuGrqrKMWqx8a36tYpYjb
	 VpDdBahi78p4lKDM4vXdimjVQ33P/OkQlCajSdWbCwwFvwUD4TWun1vuCH6tBsg5juQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oNReCmM5;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595B0606A326
	for <dm-devel@lists.linux.dev>; Tue,  3 Nov 2026 19:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 595B0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oNReCmM5
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e0d1c095dso2423555f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 03 Nov 2026 11:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793734845; x=1794339645; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oJsaIKd5l9uiGNbvOYkLF4O3e4NVImhPcBxcGBYx/v8=;
        b=oNReCmM5tctPAdzdhQx6Bqyz1PNI0sNDs71DX2xhufwo4qKHtG4fWqmdfTPmoaQfvj
         eeAWpYngVIkYZbgqKKbibDhdOmScg2Wo86JozmD7DUXF+gokv8JKr9Swn9yUeQB3ivTK
         IW28RsMhO6rVqztV1RhJyThq9+26C3MfYrPDj7nNwNDB0trNA54qfk8E4PLIux1F8KzG
         G7ErRZ1Kh+XLXp3/D/52g6pjT5g7WxsvQFZKGbhX6J0rFbcPhbJ5UUn17eAwPvImOAnZ
         2s4Mf8Lj980CgFoKKq1c9tdOn5/TCBfOup0ZQHjPq4ukqHx6r6qfRfxxcyzMhkonzL60
         g9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793734845; x=1794339645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oJsaIKd5l9uiGNbvOYkLF4O3e4NVImhPcBxcGBYx/v8=;
        b=zjidTCrmzwy7Rxiyv2dNp2ltHcDEZTYbtI0/55TiDjuCmlpwv8dDEpLLsPpaaQMP9W
         ajc1ywzjOW+8Boj1yw9KtyKI36kjfP0rOH6QSCMH2XWzEKS1N2U/9J/kZN3CGkJbWpA3
         bKu0H684yAgfThCVH1VKXF0WfeRtMG01BdRcsWsMKepAFoGF2XCAdcAV+bV/7vtAD+cF
         rHtuctZKTtyko6YMlg30RyzlWGo6TyOk8vjywL7bYSvAU4bqLblohT5iSyJ7khbcGqwI
         QTuBR5r68FOkf+911UVpbt8IY58JyMOHdLHL3i51viFAmCqS8K5TBaffCnaWdZNjP04b
         DNKQ==
X-Gm-Message-State: APuU4Z9t3pEgus070UG/CPL7ev6kI0i0IbpT85ZQnH6ztM2iLWhuKW5E
	5/cJvw4245zcWm/fa9M6Lo7ZB3a3K8vhuZeIH8vuc60Fh63zhW15AkXm
X-Gm-Gg: AYBFou34992SADy0dJ7W6AV5dUWoymbibaIyA1uPW4/sksuTiT7iiHhzbOrYvn27FAQ
	d2yBcV+UaSJ8oQpkK9rGbbgN6w2hLFphk3x6WjbPcF2CWlYLWiPBWuYtjyVs/xmoiNJmXXlgUqI
	Y1me1MlQxbfxEOW/W9gQZQ1cuePzToaGA+MiCvw5kwubUlEFDeyEQA1Mfhz5VEHjUGoEI+5aEE5
	VG/LOt4exvpdEv45ZDRDilRIEMFJZkRcoNUxsdr+9s7ossWuzaGrNIrRCZlfUu8aBvU00O30O5r
	R7cjROmnUCEnhL/czfr/uioYEbXLdDbSEThftNhTqBxxUcffwbehRDsW9bZSpg82b55T2OjU8V2
	9TiRQV5M+8X9E2oBS4ljLli5Hkw8DFlWY+hLwTe2Xs2DTxwMfbz1dkLd5QnXBgT2T87p3v/JJ9C
	Bvb5eUe3VgOz95+XZWJJVrRy93cqmvaA97XscSWa2E+E5/cf977feUg4WySLHO5OovXl6tJaY2s
	bqW2mAVE8uM84NKLFObrxMpcpis5id7Rt4KonRWmd+KTwY2XWrP4vgidxn4MrsiCAvpgvQ99IDT
	dPqJWAI0oeEBzHwbiB5Q99U69m3s3m9LHptvChdZB1OF7lQBlcNMgPAAqjmwwI7Dh0b+/lMOzFS
	fSMp8Dci+O5gfgFKeu0thF7rPfT51Ys3RihlZGnX9wvxWxMFz04cAmeoCY6lPGIIjnYCzfHFc46
	RwgmcXv+6APOeH4wGfoMKK8m9k0fV7aO1m
X-Received: by 2002:a05:600c:19c8:b0:4a3:59c9:a743 with SMTP id 5b1f17b1804b1-4ac1913ef8fmr336456765e9.27.1793734844772;
        Tue, 03 Nov 2026 11:40:44 -0800 (PST)
Received: from 5xvn.l.time4vps.cloud (5xvn.l.time4vps.cloud. [2a02:7b40:b0df:86e7::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2ab00ff3dsm153637215e9.14.2026.11.03.11.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:40:44 -0800 (PST)
From: Mohammad Pishdar <mohamadpishdar@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mohammad Pishdar <mohamadpishdar@gmail.com>,
	syzbot+9519233e6d144970bbc2@syzkaller.appspotmail.com
Subject: [PATCH] dm thin: reject metadata and data devices that resolve to the same device
Date: Tue,  3 Nov 2026 21:39:56 +0200
Message-Id: <20261103193956.63354-1-mohamadpishdar@gmail.com>
X-Mailer: git-send-email 2.34.1
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

pool_ctr() checks that the metadata and data devices differ by comparing
the two argument strings. Two different strings can name the same block
device, for example "/dev/ram1" and "1:1". The check is then bypassed.

With the "read_only" feature the metadata device is opened with
BLK_OPEN_READ only, while the data device is requested with
BLK_OPEN_READ | BLK_OPEN_WRITE. dm_get_device() finds the already
present entry by dev_t, sees that the mode differs and calls
upgrade_mode(). That opens a new table device, points dd->dm_dev at it
and releases the old one. pool_ctr() however still holds the old
struct dm_dev in metadata_dev. When pool_ctr() later fails,
dm_put_device(ti, metadata_dev) does not find the stale pointer in the
table's device list and reads d->name from the freed table_device to
print an error:

  BUG: KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:650
  Read of size 1
  dm_put_device+... drivers/md/dm-table.c:467
  pool_ctr+... drivers/md/dm-thin.c:3431
  Freed by:  close_table_device <- dm_put_table_device <- upgrade_mode
             <- dm_get_device <- pool_ctr
  Allocated by: open_table_device <- dm_get_table_device

Resolve both paths with dm_devt_from_path() and reject the table if they
refer to the same device. If either path cannot be resolved, keep the
existing behaviour and let dm_get_device() report the error.

This only fixes pool_ctr(). Any target that calls dm_get_device() twice
for the same device with different modes while keeping the first result
can hit the same stale pointer through upgrade_mode(); that would need a
change in the dm core and is not attempted here.

Testing: on v7.4-rc1 built with KASAN, in QEMU (software emulation), the
syzbot C reproducer triggers the slab-use-after-free before this patch.
After the patch the table load is rejected with -EINVAL ("Error setting
metadata or data device") and there is no KASAN report. A regular
thin-pool with two different devices still loads, and both a
"/dev/ramN" + "major:minor" spelling of the same device and two identical
strings are rejected with -EINVAL. The kernel config was generated from
x86_64_defconfig plus KASAN and dm-thin, not taken from syzbot.

Fixes: 86f1152b117a ("dm: allow active and inactive tables to share dm_devs")
Reported-by: syzbot+9519233e6d144970bbc2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9519233e6d144970bbc2

Tooling: the root cause analysis, this patch and the test scripts were
drafted with an AI assistant (Claude), based on the syzbot report and the
reproducer. The tests described above were run by the submitter.

Signed-off-by: Mohammad Pishdar <mohamadpishdar@gmail.com>
---
 drivers/md/dm-thin.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 358ed77ff..6285bbc8c 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3292,6 +3292,7 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	dm_block_t low_water_blocks;
 	struct dm_dev *metadata_dev;
 	blk_mode_t metadata_mode;
+	dev_t metadata_devt, data_devt;
 
 	/*
 	 * FIXME Remove validation from scope of lock.
@@ -3307,8 +3308,17 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	as.argc = argc;
 	as.argv = argv;
 
-	/* make sure metadata and data are different devices */
-	if (!strcmp(argv[0], argv[1])) {
+	/*
+	 * Make sure metadata and data are different devices. Comparing the
+	 * strings is not enough: "/dev/foo" and "major:minor" can name the
+	 * same device, which would make dm_get_device() upgrade the open
+	 * mode of the already acquired metadata device and free the
+	 * struct dm_dev we are still holding.
+	 */
+	if (!strcmp(argv[0], argv[1]) ||
+	    (!dm_devt_from_path(argv[0], &metadata_devt) &&
+	     !dm_devt_from_path(argv[1], &data_devt) &&
+	     metadata_devt == data_devt)) {
 		ti->error = "Error setting metadata or data device";
 		r = -EINVAL;
 		goto out_unlock;
-- 
2.34.1

