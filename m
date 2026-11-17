Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921614;
	b=xQeDDTd/Eoc2dTlcSU/xfNdqhAfV7PI/vVY5JuoBkRDeKzxW2YKF+jPTo/juAMIM4oF1
	 GSvD3LWvcumH5L5xILQGjDBEwFQeCUXeGBKqbSJd6Z6TGX+UIUwT/OlsxsZY3k+WpVZwq
	 382gziDVDBBktAg+Z7rjpK7zgIi1oXOvPPYD15zaIkA1m/SiScVBkE8alHflFYOYoap5m
	 5B/NMRa17j8nga5AWTTZaZjwUELfoFtUwqfA9vjjp55pzKwS1JOv7KaWGhEGm1vb8AeNQ
	 surQ4dI8KohT//O7oJPFkxL7V8fVqmtuVQ8P06s/CimbaA3Aq/T6x4FzkTYstqxO2zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921614;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=b4OFzIpt+JkN9gwkTTZElpkbcD6v6n6GsIMD8rYgg8w=;
	b=R7y/wcgegN7h6QNQZe3eH8ogFsYOSfAvYk2q89C4pOatoHD7Tt4YzoXyas8AhosAELYu
	 LgaE7Q4e4kahYgVFSTaYNe3PvTY4AECLmHE4UQafqcUH3EPWFNI6cdHQvKe0bxNZn98Cd
	 eV+49WoJrZPGi7TLkBseSac4wYtwkbUYwSUky6SCLyI8juoQALr9jOmRl5bGvIXbJ1sZl
	 5VwOvB4ylELs1oYUdxeYDy2Dp9keh/O8Ndu7rlkGAU/JCBqC99HCVoy49cRNhA9UOuAVX
	 pOt9d7X6xAyFAJ8+EdF8DZkT35WQmuym+G4IAzHCpJIsuiGxK1DFHJYVZQmnRAtG/Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aTr4s4XZ;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1CD606A31C
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C1CD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aTr4s4XZ
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e96502e447so46341555ad.1
        for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 05:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794921614; x=1795526414; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4OFzIpt+JkN9gwkTTZElpkbcD6v6n6GsIMD8rYgg8w=;
        b=aTr4s4XZJdmfJbNH00n8XcU5ucpicpMP2lMc8/WSIAtlKSma7cqK+THVjwBrRS2/Zu
         wBvyfXI0NrYCWNAS3fVGR0DX3HTQ9ICxchQo8knsqKQD40C9/Zakv4hDNNipm33jOzZa
         DiXAmyFEhozneWzH7rfSRArJRTVSIwTq0QhhV9f5xoqaAj/d89l4Ycd/KdLM08/GXgtJ
         fEfGHxK9T31j1gJ0eISL5HbMpmxSU64o+/9+TRcIF9nsntZlZqeFTHD24CCovJYwFv++
         CGl8d1LE9UVu50MrRRRpBy3DyXSPOmyqzuVbtIP9Egf3gUQaBzMa0ejpyfyI/AY6ThI0
         7pVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794921614; x=1795526414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b4OFzIpt+JkN9gwkTTZElpkbcD6v6n6GsIMD8rYgg8w=;
        b=sEGP8LzUMKb20uzH13FCogoWQYA8d0JA8OAa1VMvSfbDXMrxnUy4IRvtM4wZWCrdAs
         U0Y+TX1ZSl8eF7rzKSpAHmj+thsgjkK+8VO0uKjHt3nhW2oi+4IIkbUiXBhM807fuWU+
         NdWo+UGsU3EctcKFq1KuKTmuhCFaxUusaP40pxbZyu3AbKF2Xj9MJUgcUFbz1oz3LjRA
         K398ZztIQ68Clc9LWMVcO8KdnCRW1bZn9PYDGIzuTzMuPUMtQR+7S27gSXIbljIMGlNS
         XJ5RVuMTcXhabi+ArdacbVZvTW2zGdBPfy6x1dajpf/LhaimH+Gle6gABPpxBPjlRh3z
         IrVQ==
X-Gm-Message-State: APuU4Z/JxIuodXswCUePhVttE8g2JxKt44HTMqaTp1IjRRYFY998dxtR
	/gmbB80OSexeh6VF/TRXZVFbvOJHe9qBORg5xrKyBVYwTz+38up0nMv5
X-Gm-Gg: AZFdTZdzrinvDAp1V4TGiQxlpJoEGZLScVScFURQyJW0H8a+G987YoiHxqhYhN74xCU
	sAZjt1guWpkquvzqttI1B9U2kUppL8rryfreawQCji9lmkB8Vb9wlt379Hub1k+Qo8giAuLWTk9
	S59s1OVSX6GNmRKdyxB+PveaZMymLs7lLVrvUK0zab9hie3y0XoIi8IYuyT97yt3W9fuD8MFGFB
	krvMdRNUSw20riGcqZuM9bZT+GydXOggPmfSUJwHIx5eFKLpRwUngIEyac6DZtCGudFloUXDAwz
	MM+oJkR9P6FNZbZ8VZbcs+11/GCG5fghzBBCDuhCwWqWCaPFbCjSu8sr9LGsARGhl/+pH3TbaU7
	NDvEvdEcNsAh7eRO7w4XQU1KT2K2fHeDnn9A7p0U5BNSt82PUm9BSyWi5wIAgJSYq5nxlEPuohV
	T8U2kG6mnoGaWH4y1z48yyYpXwdvEn7kLvOoalCT+edQLGdKUMsKpW8KKCBMIpnmMFH11VmOqR+
	2EXHLZ6/UCpzqQR1/AHp2xXDEAThncRg6Z7IVd1HwID0+k1qgWjYeh9rbTh/DDNzCKa8JivWU/u
	k1Yz9xRJi55aWVdLYlvfA3JPNAtAi4qM5AiBVgknZmbEmJcoExix9E8/Jj63+5uhlNBqNOGTKAR
	rEkF4/8vz
X-Received: by 2002:a17:903:2285:b0:2e9:a16b:c251 with SMTP id d9443c01a7336-2ee0d6726e2mr134994625ad.3.1794921613568;
        Tue, 17 Nov 2026 05:20:13 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a5f754sm16064915ad.52.2026.11.17.05.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:20:12 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH 3/4] dm-verity: size the hash retain target from the hash area
Date: Tue, 17 Nov 2026 21:19:19 +0800
Message-ID: <20261117131918.2745193-6-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

With the dm-bufio default of 256 KiB a large device re-reads hash
blocks evicted under memory pressure, while a small device holds far
more than it needs.

Set the hash client's target to hash_retain_percent (default 10) of
the hash area, computed with mult_frac().  A percentage above 100 is
ignored, leaving the dm-bufio default.

Publish the clients under /sys/block/dm-N/dm-bufio/<name>.
Registration runs from ->resume because the dm device's block device
does not exist until the table is loaded.  The parameter only affects
devices created afterwards.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
 drivers/md/dm-verity-target.c | 60 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-verity.h        |  2 ++
 2 files changed, 62 insertions(+)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 451c75e30a8f..3ae1b25fdbf6 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -32,6 +32,8 @@
 #define DM_VERITY_DEFAULT_PREFETCH_SIZE	262144
 #define DM_VERITY_USE_BH_DEFAULT_BYTES	8192
 
+#define DM_VERITY_DEFAULT_HASH_RETAIN_PERCENT	10
+
 #define DM_VERITY_MAX_CORRUPTED_ERRS	100
 
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
@@ -50,6 +52,13 @@ static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
+/* Default fraction of the hash tree that dm-bufio is asked to keep cached. */
+static unsigned int dm_verity_hash_retain_percent = DM_VERITY_DEFAULT_HASH_RETAIN_PERCENT;
+
+module_param_named(hash_retain_percent, dm_verity_hash_retain_percent, uint, 0644);
+MODULE_PARM_DESC(hash_retain_percent,
+	"Percentage of the hash area to keep cached by default");
+
 static unsigned int dm_verity_use_bh_bytes[4] = {
 	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_NONE
 	DM_VERITY_USE_BH_DEFAULT_BYTES,	// IOPRIO_CLASS_RT
@@ -1092,6 +1101,9 @@ static void verity_dtr(struct dm_target *ti)
 
 	verity_fec_dtr(v);
 
+	if (v->bufio_kobj)
+		kobject_put(v->bufio_kobj);
+
 	kfree(v->signature_key_desc);
 
 	if (v->use_bh_wq)
@@ -1421,6 +1433,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct dm_verity_sig_opts verify_args = {0};
 	struct dm_arg_set as;
 	unsigned int num;
+	unsigned int hash_retain_percent;
 	unsigned long long num_ll;
 	int r;
 	int i;
@@ -1638,6 +1651,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	hash_retain_percent = READ_ONCE(dm_verity_hash_retain_percent);
+	if (hash_retain_percent <= 100)
+		dm_bufio_set_retain_bytes(v->bufio,
+			mult_frac((u64)(v->hash_end - v->hash_start) <<
+				  v->hash_dev_block_bits,
+				  hash_retain_percent, 100));
+
 	/*
 	 * Using WQ_HIGHPRI improves throughput and completion latency by
 	 * reducing wait times when reading from a dm-verity device.
@@ -1815,6 +1835,45 @@ static void verity_postsuspend(struct dm_target *ti)
 	verity_security_clear_integrity(ti);
 }
 
+/*
+ * Publish the bufio clients under /sys/block/dm-N/dm-bufio/.  Runs from
+ * ->resume because the dm device's block device does not exist in ->ctr.
+ */
+static void verity_register_bufio_sysfs(struct dm_verity *v)
+{
+	struct mapped_device *md = dm_table_get_md(v->ti->table);
+	struct kobject *parent;
+
+	if (v->bufio_kobj)
+		return;
+
+	parent = &disk_to_dev(dm_disk(md))->kobj;
+	/*
+	 * On a table reload the old table's directory is still there; it is
+	 * removed only after this resume returns.  We retry on the next one.
+	 */
+	v->bufio_kobj = kobject_create_and_add("dm-bufio", parent);
+	if (!v->bufio_kobj) {
+		DMERR("cannot create dm-bufio sysfs directory, will retry on next resume");
+		return;
+	}
+
+	if (dm_bufio_client_sysfs_add(v->bufio, v->bufio_kobj, "hash"))
+		DMERR("cannot register hash bufio client in sysfs");
+
+	if (verity_fec_is_enabled(v)) {
+		if (dm_bufio_client_sysfs_add(v->fec->bufio, v->bufio_kobj, "fec"))
+			DMERR("cannot register FEC bufio client in sysfs");
+		if (dm_bufio_client_sysfs_add(v->fec->data_bufio, v->bufio_kobj, "fec-data"))
+			DMERR("cannot register FEC data bufio client in sysfs");
+	}
+}
+
+static void verity_resume(struct dm_target *ti)
+{
+	verity_register_bufio_sysfs(ti->private);
+}
+
 static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
@@ -1825,6 +1884,7 @@ static struct target_type verity_target = {
 	.dtr		= verity_dtr,
 	.map		= verity_map,
 	.postsuspend	= verity_postsuspend,
+	.resume		= verity_resume,
 	.status		= verity_status,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index e104a651c657..1bd625f5b45a 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -82,6 +82,8 @@ struct dm_verity {
 
 	struct dm_io_client *io;
 	mempool_t recheck_pool;
+
+	struct kobject *bufio_kobj;	/* /sys/block/dm-N/dm-bufio, or NULL */
 };
 
 struct pending_block {
-- 
2.43.0

