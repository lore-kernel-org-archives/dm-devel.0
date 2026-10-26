Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793012671;
	b=cww1UTpNAulcfM4tBrHK+eld2cKll6eY7iQ26arKd+9IZbVGMy/SJmF+yWDC5M9fgwcQ
	 5wSVXHNW8KwDwvlcpm7zXlKrA1YNUbnwOqQ4+ye/i81IXeTC2HP51PZi5pUOmtNT3nEXz
	 QGdTTJ65feZvDUd++KFKTn3QrocoR/TyRup6qmgHRafCEamxHgzZoF+WMuIxQ1FdabZIv
	 WJNCPoHecnNid92KvsUlQho7Mgjiyfp9IMpGUQjrFGj1ikDRT/vYUqaibtx06yE9lUXNh
	 wB7ilMqo4sp7CeBIgqgd+sGdAWKGqT1O/jtFqjF6jF814+pEpY2sqpxa5eZ8/LBC76g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793012671;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=eQulDPAhSJ3VfZ/4ogb1s3vm11tJrOqeW6KyN89YN3g=;
	b=PRGlwFnnd5xp6F14jt0T5VUZEOlV9jCWDzTx7Aj8l/emPUhM+WhHlu5HIGwC4Nix3wlt
	 5seEaBBzw2qohBGIIMnqIF8KGRw3nh/rmxsG/rsX2Zca/RP8HUxwWGjKIJJJ/SJ1i207q
	 18tR670VvquiiU6b3YUlAaEkMImXfBAlYUSieQdRyetRMk7xGif9ZksEqqEPqYevGNwai
	 72lQ8iYK0MLyaNkgzM+/Z0CpEf/vaSSqWsWxxMlRWtmUY1Cc/fC92ahTb78vLr3tX3WPt
	 l7+Zh6+45zRXJCmKnp39jY8JOJsqpeB+P38bQwt7BjYaJ0He7oCEwi6by/SWfB4MisA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aUF9Y4Qn;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D36606A31B
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 11:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64D36606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aUF9Y4Qn
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-353804b591eso5271819eec.0
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 04:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793012671; x=1793617471; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eQulDPAhSJ3VfZ/4ogb1s3vm11tJrOqeW6KyN89YN3g=;
        b=aUF9Y4Qn0WiuFIzyKQ1CUJWY+gGl1bIgzo5NnHghbv0gP/h2rylS4qwOV3J+atGThU
         YVmMrOAWhFNbwfyRp/vrVAEzOXtWJW4GkBPd0WH51qF9Lh7APXk6IRGz/+9IyyG1vOpx
         DEIWrc6HonbRzCw7ROffdtTJn5af26MTAECElfjV7HeYN+F/+mv1nTE9HByVW5m/gWvK
         7rPcPOfGKAJUmUcCKsZbhqPJ9jAgTqLYsTRmunR9pBUwMPxZywWVG0iZcAGjhbiUaqPF
         K+An0UQb3D1PGAH8JHwy8YP2Ak/CGZlRrTu4/kgmVeaECIPne27g9HZWhoh/bbNDJbTm
         HLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793012671; x=1793617471;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eQulDPAhSJ3VfZ/4ogb1s3vm11tJrOqeW6KyN89YN3g=;
        b=hZP1bUPzwcuqAmpvNRMYsnpV9Ls8X8MLKSbw30ca/NJU/TFahyDKVscecR6tGerzpZ
         Pf9i/XaeHGlINY9FPC+DbgSELgn2Bh3U+kcGoBJk+hY6LAoLHBME67kcVH1ar1R0zGGm
         wIK/DWRPwhOgLKZtu+MnHSbDdT/ztI6pbI7qTrr79R2ewC3jMs7J2YD+jIb7Dw8SOms6
         oUC0RML1aQfKpo1VitQc24P2EBf2yxPbEKTZ2v2A6B/Js27XeUMpBn7jY4k1leiGE4e0
         HU15BBccx2vglwmKVmAxuVOAn0KiTsNevL9l8fGKuVnQxV0IRSBSQ/4QOI3D//DkxMZo
         HPhA==
X-Forwarded-Encrypted: i=1; AKwUvBykhHGbxovOV0k5i6PcQeOXZUfjaiFj4T3qLJGqWDJC265HXRPp1zxX0KPrXaeyaM6iLlTArnOxlw==@lists.linux.dev
X-Gm-Message-State: AFq9FYKwUPpKpN/adOjrECod31lsBOYuDuQ938fLXC1YoebB3rt+u7Bg
	8MgBFOuO3L/6IU/yAIDFJdG4kUT539lazlWS4xflj9lFZqqXvGVEtFnB
X-Gm-Gg: AYBFou1CPizWMioMdYKz4Zmi+OS+8QY16gNOKcayXBvrZT+9EBzIRq/uH6q5/x5YCm1
	FX33CieKVg5hvw8/v74ieW4PDF/45gibZUmCrScHaN0p4u5TpijIOnnl/dfjQ427yDV4tQv272L
	HdaxrEXFShBQbWRlm1i/WhnpfA9WO4IRniZc+uc0JGuBiJzEYlILYEeLAaCAB1MMQinISzd87eT
	MAMPeuxXj/dbyQ5+Xta5CqXZHqsHEW90wW7hcDF0BDKwEaMcXXk+sKpdSHtAiSRVz9rCV6x4z+p
	fNS+LCdWUNaXKPa/3LVkW2oWa50o0QNz9rWeq2fjjSKVOgs9jeJGShp8DYTX6zlbrlxv3/wfIZF
	XyUFxqRVba8W+4wWaZeSVMx+PUsl7k6A6e4MbXtI9AXAwEkFQlgiGttl/IrBjLdrTjjjzctB4BY
	g5Nr1OxJzOXe717P5OA94B3C4YEyvu35o9H2C6IqAuNgR9gy9OSInBO1l9j5stPRzCC13dsUe6A
	YmHtmlOFvww/kIut+sEAEdZf3ZOoORXGUetqYVl3Mq1/DL75g0fbsH03p14vAJL7V7U3zWseas3
	y4w2j0oAXEcU
X-Received: by 2002:a05:7300:ec0a:b0:35f:8c5d:5927 with SMTP id 5a478bee46e88-369e849d9e3mr12626709eec.14.1793012670428;
        Mon, 26 Oct 2026 04:04:30 -0700 (PDT)
Received: from Hruday.lan ([2409:4091:903b:c404:624b:425f:9d48:c5a8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369ef6a71easm22985134eec.5.2026.10.26.04.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:04:30 -0700 (PDT)
From: Rahul Rao <shreeramrahul94@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com,
	Rahul Rao <shreeramrahul94@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] dm thin: prevent use-after-free when metadata and data devices alias
Date: Mon, 26 Oct 2026 16:34:02 +0530
Message-ID: <20261026110402.103622-1-shreeramrahul94@gmail.com>
X-Mailer: git-send-email 2.43.0
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

pool_ctr() takes separate specification strings for the metadata and data
devices. However, different strings (or format representations such as
/dev/ram0 and 1:0) can resolve to the same underlying block device.

When the read_only feature is requested, the metadata device is opened
read-only before the data device is opened read-write. If the devices
alias, the second dm_get_device() call upgrades the existing device's
mode. upgrade_mode() replaces the dm_dev and drops the old table device,
leaving pool_ctr() with a stale metadata_dev pointer. The subsequent
metadata_dev->bdev access triggers a KASAN use-after-free report.

Acquire the read-write data device first so that acquiring the metadata
device cannot trigger this mode upgrade. Then reject matching block
devices, including those specified through different names, and release
the devices in reverse acquisition order on error.

Reported-by: syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83827f9a59abe148bff4
Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Cc: stable@vger.kernel.org
Signed-off-by: Rahul Rao <shreeramrahul94@gmail.com>
---
 drivers/md/dm-thin.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 59392de7a477..52e47874048d 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3326,18 +3326,24 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	metadata_mode = BLK_OPEN_READ |
 		((pf.mode == PM_READ_ONLY) ? 0 : BLK_OPEN_WRITE);
-	r = dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
+	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev);
 	if (r) {
-		ti->error = "Error opening metadata block device";
+		ti->error = "Error getting data device";
 		goto out_unlock;
 	}
-	warn_if_metadata_device_too_big(metadata_dev->bdev);
 
-	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev);
+	r = dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
 	if (r) {
-		ti->error = "Error getting data device";
-		goto out_metadata;
+		ti->error = "Error opening metadata block device";
+		goto out_data;
+	}
+
+	if (metadata_dev->bdev == data_dev->bdev) {
+		ti->error = "Metadata and data devices must be different";
+		r = -EINVAL;
+		goto out;
 	}
+	warn_if_metadata_device_too_big(metadata_dev->bdev);
 
 	if (kstrtoul(argv[2], 10, &block_size) || !block_size ||
 	    block_size < DATA_DEV_BLOCK_SIZE_MIN_SECTORS ||
@@ -3426,9 +3432,9 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 out_free_pt:
 	kfree(pt);
 out:
-	dm_put_device(ti, data_dev);
-out_metadata:
 	dm_put_device(ti, metadata_dev);
+out_data:
+	dm_put_device(ti, data_dev);
 out_unlock:
 	mutex_unlock(&dm_thin_pool_table.mutex);
 
-- 
2.43.0

