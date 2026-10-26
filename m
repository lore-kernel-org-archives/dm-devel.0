Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793010466;
	b=UEd4vcWqy5SSEXu35ET10WuoRvZ1Es7xAA0z0hK2+9s1cePHvwLgadcPfU58qBsbwqay
	 I+/T7I0pBdeRxAm831n0AjhHammM7TBHwUTBn0gYb658GnWibIEcwiyPJE0EW53woKjjX
	 8YkTM8xBhQhl6+coIsw7E+oJShU/naBzJAkpzqpB8pGJBbAfkocj9Bfi9+BR7pIAeoH/d
	 Ac5O+qXfZF2S+NNBv4Iop2VxUbLkQwfanQq+SX2T89D4D/9k2RGyUpXKrTzQa5Nfg0Crs
	 KrQD9hiiMdNOOpgxwZSAiFRMFq01YVAL9E/tM4467/P+LhfsDcjNaQqxM4rEH5FW7lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793010466;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=OHmmP4G3FNF0AZ9sxLL3Yqo6u3L/FIebdoKe+DJDIgk=;
	b=pc+o1EbxEdjHx7D8DwuHl0PmR+eO9GEA9a5MOGf4qSFzMiYTBfXvcHbHw1IecVRid3EJ
	 m0PdjlerrL7dVlUdHpe2hV+ghWaAbj1Bq8frEGZmkL2WQAAGMXmgUEQI2cGyhumwgmxxu
	 iGix/4Jb54RsCHbs49cFX3fMhIIkOX+VOV37/PUDDl2MYEQst9o6nqNQO1CSEc3KdLhjy
	 9BRoVh2UhUWjwo80vdkLfl+oNwN7Buopj2Wdi4ayD6uvNSjAAhphwQrdoZGC4PcqQf2nI
	 XHgMY6z8di6CCC51ruh1Iic+lj/SE8/ZcKzc1lNapHP4mrFCOGW+6kWPWER6/cf/l1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="bb9Ws0p/";
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E0C606A31B
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 10:27:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5E0C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bb9Ws0p/
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so7173475e9.3
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 03:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793010464; x=1793615264; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OHmmP4G3FNF0AZ9sxLL3Yqo6u3L/FIebdoKe+DJDIgk=;
        b=bb9Ws0p/9awydtP7L7YE9JY/y0yF1oXjyNxGeou1wXb+ukKpoOlh7iMgE6fScB2Pfm
         eek6LuWtNXGL1zh0FfeF5in+pgNmcliZmSzHBC/jYG8rzzmcJKxvD1y1enXPvYIfo5B5
         k9dT14inUyg6yxKgC1PgiCHgeXFrDsQte3TNnSQ7jaFfAN3RZErPC11Kkb3nekk6sVE2
         OZm0vyA44Kz9/N5+0JnIVLY2Moed/bs+EE6AnbtGCpBkyMGZy+an7RVF0ZQNTAj+reK1
         v86O5B0RhX1ZtM8bKsO/0mD5SiQgcv+5sh9g3LM4wmsvFXxt8edBzMRm5AdnOUttbxBC
         NjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793010464; x=1793615264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OHmmP4G3FNF0AZ9sxLL3Yqo6u3L/FIebdoKe+DJDIgk=;
        b=L6E3YSqwpXtVQCoAT8Ft2iRAkyFyP/hnhba/kgGzd3OllnAO6ZMP7MuS+ymUf+04Pw
         9aA0eoq/wD+5EVtRGjGFxrW+l1eeKmDbwaqizDzCV4/1bXdvrZo05ypXeJL0QsNdQjN2
         R+3r9tKf/yRm0aIU4pekK7wJv/hwp98DycYioPyfOvppJLHA7gC4xxAE7tuntdchWcW3
         +FOBZ/9ZFl5144/4yUCEzKimNcpvkq8KKFoBDOI8wNRqcYOYRlPBVRipHImmFMdXQeqX
         mmLtKOHHBH+lsjtTLNXFpAkkwbA9KScQgVBMBkwCaUVwLmp9wh0d+1BAq1ds2hJ+PE6l
         wSLA==
X-Gm-Message-State: AFq9FYLzX/ypXYikjWHN1DaFcwOj6vXPLGhpqk3k3HDUlvRFQRVbphht
	MLvkcEzQ/xpquIQ7p5me9KdiLKgEcz8w2Xqs2FglQlBDiIDoRYJ9mg5WtL1S3sznhhiQ78K4
X-Gm-Gg: AYBFou0x3qKyqJ+tQjJoTCWsKW/KzxTPe8Ibq8ObVd3CLtRpmbDM7SjzkUmox1EQjoA
	jdPwv9bYqbXS8zuCnTm0mcytNEyYXzrySefvWKFGqnWVB4FIW/OxKjrvRoo3l4QIETCSrug84Ph
	RSL5kfufWyQb97RDOA0sD8JvokfvkJpgOALgNSqB13kxJFzmmLtW50u0gHtMiPYDrcvMt3PZx6l
	/RHbnTWOqeCfTWJQ3bb+UtP1+szO5Sax34nkkghnTav9l3Ym7FWDZDUNP5zyk4TlC/Jle1xfwnv
	eVM9HueWj/CA5nORNTFZWl3byzvfeoUlpmEtwI7BYAGNVHCy+ykl3FxPn36q6/eE4wGnVRGZ1/N
	POePWHHpIM8cFoaSiwishltj4o/v5Jvv4gw60WMF5S9acahV1GWtRm+kTxbEf834TIidS9LGaR/
	pIFu58mvySu/aIwGHGEZHxEY8FV7LzBpCUlgcd7jmOpA6Lla795iKQohR3tpfgWf8K5+2RdLtAH
	3t+UP95vDiHvhctK/lVkq2N/qmj0R5f/pMJJqUTLz5EqR4NAATMznVgkf4yknsBt7s/Lz6gaQqq
	o1hZH//84M/xPpyTFYART4KLPcpMN+lSwcsHEw==
X-Received: by 2002:a05:600c:1992:b0:4a3:59c9:a743 with SMTP id 5b1f17b1804b1-4a35acaaac3mr125431505e9.27.1793010463866;
        Mon, 26 Oct 2026 03:27:43 -0700 (PDT)
Received: from localhost ([217.150.74.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a04ad39sm493684375e9.1.2026.10.26.03.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 03:27:43 -0700 (PDT)
From: Eduard Zateev <hackerowskiy@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org,
	syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
Subject: [PATCH] dm thin: reject metadata and data device aliases
Date: Mon, 26 Oct 2026 20:27:40 +1000
Message-ID: <20261026102740.241243-1-hackerowskiy@gmail.com>
X-Mailer: git-send-email 2.56.0
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

From: angel <angel@localhost.localdomain>

The thin-pool target rejects identical argument strings, but two names for
the same block device bypass the check. In read-only metadata mode, opening
metadata first and data with write mode invokes dm_get_device()
upgrade_mode().
That swaps and frees the old dm_dev while pool_ctr retains metadata_dev,
causing a slab-use-after-free when __pool_find() reads metadata_dev->bdev.

Open the data device before metadata so an alias cannot trigger a mode
upgrade between the two references. Compare the opened block devices
and reject aliases before using either device. Adjust the error paths to
release the devices in the matching order.

Reported-by: syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83827f9a59abe148bff4
Fixes: 70de2cbda8a5 ("dm thin: add sanity checks to thin-pool and external snapshot creation")
Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
---
 drivers/md/dm-thin.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 358ed77ff..0899cbaf9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3326,17 +3326,24 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	metadata_mode = BLK_OPEN_READ |
 		((pf.mode == PM_READ_ONLY) ? 0 : BLK_OPEN_WRITE);
+	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev);
+	if (r) {
+		ti->error = "Error getting data device";
+		goto out_unlock;
+	}
+
 	r = dm_get_device(ti, argv[0], metadata_mode, &metadata_dev);
 	if (r) {
 		ti->error = "Error opening metadata block device";
-		goto out_unlock;
+		goto out_data;
 	}
 	warn_if_metadata_device_too_big(metadata_dev->bdev);
 
-	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev);
-	if (r) {
-		ti->error = "Error getting data device";
-		goto out_metadata;
+	/* make sure metadata and data are different devices */
+	if (metadata_dev->bdev == data_dev->bdev) {
+		ti->error = "Error setting metadata or data device";
+		r = -EINVAL;
+		goto out;
 	}
 
 	if (kstrtoul(argv[2], 10, &block_size) || !block_size ||
@@ -3426,9 +3433,9 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
 

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
-- 
2.56.0

