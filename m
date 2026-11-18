Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022529;
	b=uqY9HIMS3tt2ve6NZfaEmuspHR9EjLPRp8JGu42RR0uCJQ8nykxT2JDJjJ2eR9DyuQOR
	 pg53S/xm1y34VSNGQqch8WcCrmu83bLFL7GRGetGh8LJQ/JA5iD9vw/q6xIZ3MqhYKPXD
	 X6b2uhDHGV1sVDt5KjZ+miQkHkol1ZlIjmg7oetjgDDtzRBSRE3gVZfiJLhwqwi/j6vNr
	 aVNakvB6eAuBW/tSYeWb3nBG8uUQjirg9WoV24VUZ4V7Yto5gbzXFoPkLkBgHXqoTsVwB
	 Cn6lXiFMQieyywZ56xx8t7DhUjH6bkLxR76jI4PmI7e1XJk4xRrCu/mhKXHHKAwdpgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022529;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5760WBpqW28SthV7ha4JpTO3lv6G1wiA/QaZuKa6JhY=;
	b=C2Ax9xPvfnBnFBKwl6c2FIHys43xowbA/f3oXdX0xnjzbGMfmaH+4AR9P/aYytRGT49n
	 jJbEusRiavuuzRbSIeH/p8CGxiUpeabWR0PK8KNwt8Ce9fnbmanXpByBYO48HmKxH8vxI
	 z/pEzkTz5yRSLKxkf4mdCovHcoRYgvDPZYqGJ1riChLt0SXdhvql0XKnmvgVfBYKPDqtH
	 wPfq3377TDaVldpmlssP4t/dNAz7CG+A7kWAheL9IxOwFaAD9QURcFs2psWmDBq4T1O32
	 puZ88YLASx2j0AscN+1N+7vJl22zUkuPZlgZDqLbNCuai9pfHjtgWRyLHVtbataLvQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZxZbp76+;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D63606A330
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6D63606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZxZbp76+
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso674919a12.2
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022528; x=1795627328; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5760WBpqW28SthV7ha4JpTO3lv6G1wiA/QaZuKa6JhY=;
        b=ZxZbp76+MuQXQWVs13xEAjXIPE92tw3PjwayasZd0N0Rv1Y6eV37l+6wq2EC4neZkk
         PfBMHpHJi9VsZc20j2mYi7Q+/kPyDZJWTJ8lM6x3teFW/ByuzIusJv4xXF/Nw86fokW2
         fAAAKNi9dowagExAgrxMWh8xIb1RijzVmMu8XeYS+cyLEsIIkiMMppPVqvwbqnnhBPJ/
         l4ky693qYyY68b/wZYWnOusOrhfCtr2si1A2/eGK/ug157tz0AZCxhTRS5AL+ncx+hso
         jLfGdA7/aNU9RPEvyDgCYcVzmSP7HtjhsjL0sJ+TP1DVAeAC5dv50/oOa3sHT8sztPDt
         P4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022528; x=1795627328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5760WBpqW28SthV7ha4JpTO3lv6G1wiA/QaZuKa6JhY=;
        b=y4a3W9aokQqvLJRJDfSuD1Ixy0Z2Fj+KAHxD4Bg8OAWB02SyrTxit0pjYgVsfqQu3o
         m8HxNVqGwBiAGAKYjCcLbxRozuywwOZ2DLGZtuuisDejCcZqVdjhcrJE3vwsDy9D5Zo7
         v5HJg13B+EjpWcxyMcnO0lAl4Y1r7naHji/sr9gmWvd4vuXsYp5+wBYWui+/yfvhr/ia
         bT3s/bQl8zci7/ezqwOqXsOfcLYWjwPdfZAfrgqvNrwPJsepbg3CZHEVZ0jdV5zsh473
         zQVYP1q8i+6nhlf+L7HmKweB5al/8gmYr+aqGMNu8wMFNq4FGBY0ZhxR3Vhf7+e9PE1v
         Z6sQ==
X-Forwarded-Encrypted: i=1; AL+hErHdWSNWs7x/IUfMK1KMI8On/A5BcfVV6Vq8V0OCT7osOqMYVYUE1QdM7vPP9Mv1JUHuoxIFzmEW5Q==@lists.linux.dev
X-Gm-Message-State: APuU4Z8kBaVlm1SxLNiGGcF4XU5bWsrltI0LIH5byhwWdmkjR78co9EN
	ars/nyVXyiD3LMVg7ClF9ct9ilh35Yepo2dy+NwM2/gRloS6bCoJrqjR
X-Gm-Gg: AZFdTZftEpbNt6zuLrc+jO1aEqmdrwHAfsyTOdUdBBfSVpKi6+bX9qoxc9C9F8PKA8e
	i0NHHQGrDd9pESHDNPLu5nJTGhimwlVGR0YVUTwJsYlWk6H8hpWwrW319mEM+P00ALpkN6it6YB
	8CaAjkhLE0VvccW+npiI8Do3ciBarQPAaF0/HjrJPegzve8fbtzIFU1NcWelJBzSYHifqqd36tD
	obouQZl++NTllsq76uRHw1G9Ks0NTKeTG7Qb3PMYUV/q+hadNSihB9Rcm4XjvPYN20DGMIpyXjo
	sZPpjblIp8tvbI4mteqG+IJOIM5eOVm7lZZNqiLFZN5gPNN6KngYMRymw8/M2Sim44cH/4PCim8
	8wLvZoq4W2Gqkhj8FQTuNS4//KeV4R7g2IGe8A0eXMST33T2pJUwk3zxko7JmoOAF9eLablIVzD
	K+L+8s4gJGPb9BPidrPNHZjfY1843AmlpE0aavlNwXKQVWVFBN+MM+K2AFTBFhZVhXWhYcySpoU
	pAoJ0hVXbU6hc/k9I8dMgQQPITVzY2LdNA87IMNyarXAEqiwzuGgDgQgMqpi9Q4ElnMBK6O8Vpn
	V96RNJS6wkJEv1MJwIqQxKeVeAgUfLzx+4GC6zvYKqr0VmCg+vNCN9f6/RHehmQi3zOxyF2t5Nb
	LujTPE6v9
X-Received: by 2002:a17:90b:3f83:b0:3b3:af8e:ea8d with SMTP id 98e67ed59e1d1-3b3d07aa083mr3356899a91.39.1795022527861;
        Wed, 18 Nov 2026 09:22:07 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f7067012sm135659a91.12.2026.11.18.09.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:22:07 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v2 3/4] dm-verity: size the hash retain target from the hash area
Date: Thu, 19 Nov 2026 01:21:33 +0800
Message-ID: <20261118172133.689163-5-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
References: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
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
the hash area, computed with mul_u64_u32_div() and clamped at
ULONG_MAX so a large area cannot truncate to near-zero on 32-bit.  A
percentage above 100 is ignored, leaving the dm-bufio default.

Publish the clients under /sys/block/dm-N/dm-bufio/<name>.
Registration runs from ->resume, not ->ctr, because the dm device's
block device does not exist until the table is loaded; the directories
are detached again in ->presuspend, which frees the names but keeps
the kobjects until the table is destroyed.  A reloaded table can then
publish its own directories synchronously from ->resume, with no
collision and no kernfs drain while the queue is frozen.  The
parameter only affects devices created afterwards.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v2:
- Destroy the FEC bufio clients before putting the data and hash
  devices in verity_dtr().
- Compute the percentage with mul_u64_u32_div() and clamp it at
  ULONG_MAX, so a large area cannot truncate to near-zero on 32-bit.
- Detach the sysfs directories in ->presuspend (names freed, kobjects
  kept until the table is destroyed) so a table reload publishes its
  directories synchronously from ->resume; add
  dm_bufio_client_sysfs_detach() and re-attachment in
  dm_bufio_client_sysfs_add().
- Document dm_verity.hash_retain_percent= in kernel-parameters.txt.
---
 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/md/dm-verity-target.c                 | 123 +++++++++++++++++-
 drivers/md/dm-verity.h                        |   2 +
 3 files changed, 130 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..914da403c5de 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1351,6 +1351,12 @@ Kernel parameters
 			For details see:
 			Documentation/admin-guide/hw-vuln/reg-file-data-sampling.rst
 
+	dm_verity.hash_retain_percent=
+			[DM] Percentage of the hash area that dm-verity
+			asks dm-bufio to keep cached for a new device.
+			Defaults to 10; 0 or a value above 100 leaves the
+			dm-bufio default.
+
 	dm_verity.keyring_unsealed=
 			[KNL] When set to 1, leave the dm-verity keyring
 			unsealed after initialization so userspace can
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 451c75e30a8f..8059c842b9f9 100644
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
@@ -1084,13 +1093,19 @@ static void verity_dtr(struct dm_target *ti)
 
 	kfree(v->alg_name);
 
+	verity_fec_dtr(v);
+
 	if (v->hash_dev)
 		dm_put_device(ti, v->hash_dev);
 
 	if (v->data_dev)
 		dm_put_device(ti, v->data_dev);
 
-	verity_fec_dtr(v);
+	if (v->bufio_kobj) {
+		if (v->bufio_kobj->state_in_sysfs)
+			kobject_del(v->bufio_kobj);
+		kobject_put(v->bufio_kobj);
+	}
 
 	kfree(v->signature_key_desc);
 
@@ -1421,6 +1436,7 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct dm_verity_sig_opts verify_args = {0};
 	struct dm_arg_set as;
 	unsigned int num;
+	unsigned int hash_retain_percent;
 	unsigned long long num_ll;
 	int r;
 	int i;
@@ -1638,6 +1654,18 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
+	/* Keep a configurable fraction of the hash tree cached by default. */
+	hash_retain_percent = READ_ONCE(dm_verity_hash_retain_percent);
+	if (hash_retain_percent <= 100) {
+		u64 retain = mul_u64_u32_div((u64)(v->hash_end - v->hash_start) <<
+					     v->hash_dev_block_bits,
+					     hash_retain_percent, 100);
+
+		if (retain > ULONG_MAX)
+			retain = ULONG_MAX;
+		dm_bufio_set_retain_bytes(v->bufio, retain);
+	}
+
 	/*
 	 * Using WQ_HIGHPRI improves throughput and completion latency by
 	 * reducing wait times when reading from a dm-verity device.
@@ -1806,6 +1834,49 @@ static inline void verity_security_clear_integrity(struct dm_target *ti)
 
 #endif /* CONFIG_SECURITY */
 
+/* Detach the dm-bufio directories from sysfs, keeping the kobjects. */
+static void verity_detach_bufio_sysfs(struct dm_verity *v)
+{
+	dm_bufio_client_sysfs_detach(v->bufio);
+	if (verity_fec_is_enabled(v)) {
+		dm_bufio_client_sysfs_detach(v->fec->bufio);
+		dm_bufio_client_sysfs_detach(v->fec->data_bufio);
+	}
+
+	if (v->bufio_kobj && v->bufio_kobj->state_in_sysfs)
+		kobject_del(v->bufio_kobj);
+}
+
+/*
+ * Free the directory names before a table reload resumes a new
+ * instance.  Presuspend runs before the queue is frozen, so the kernfs
+ * drain cannot block on I/O.
+ */
+static void verity_presuspend(struct dm_target *ti)
+{
+	verity_detach_bufio_sysfs(ti->private);
+}
+
+static void verity_presuspend_undo(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+	struct mapped_device *md = dm_table_get_md(v->ti->table);
+	struct kobject *parent = &disk_to_dev(dm_disk(md))->kobj;
+
+	if (!v->bufio_kobj)
+		return;
+
+	if (!v->bufio_kobj->state_in_sysfs &&
+	    kobject_add(v->bufio_kobj, parent, "%s", "dm-bufio"))
+		DMERR("cannot re-attach dm-bufio sysfs directory");
+
+	(void)dm_bufio_client_sysfs_add(v->bufio, v->bufio_kobj, "hash");
+	if (verity_fec_is_enabled(v)) {
+		(void)dm_bufio_client_sysfs_add(v->fec->bufio, v->bufio_kobj, "fec");
+		(void)dm_bufio_client_sysfs_add(v->fec->data_bufio, v->bufio_kobj, "fec-data");
+	}
+}
+
 static void verity_postsuspend(struct dm_target *ti)
 {
 	struct dm_verity *v = ti->private;
@@ -1815,6 +1886,53 @@ static void verity_postsuspend(struct dm_target *ti)
 	verity_security_clear_integrity(ti);
 }
 
+/*
+ * Publish the bufio clients under /sys/block/dm-N/dm-bufio/.  This runs
+ * from ->resume, not ->ctr, because the dm device's block device does not
+ * exist until the table is loaded.
+ */
+static void verity_register_bufio_sysfs(struct dm_verity *v)
+{
+	struct mapped_device *md = dm_table_get_md(v->ti->table);
+	struct kobject *parent = &disk_to_dev(dm_disk(md))->kobj;
+
+	if (v->bufio_kobj)
+		return;
+
+	v->bufio_kobj = kobject_create_and_add("dm-bufio", parent);
+	if (!v->bufio_kobj) {
+		DMERR("cannot create dm-bufio sysfs directory");
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
+	struct dm_verity *v = ti->private;
+
+	if (v->bufio_kobj) {
+		/* detached by presuspend, or re-attached by presuspend_undo */
+		if (v->bufio_kobj->state_in_sysfs)
+			kobject_del(v->bufio_kobj);
+		kobject_put(v->bufio_kobj);
+		v->bufio_kobj = NULL;
+	}
+
+	verity_register_bufio_sysfs(v);
+}
+
+static void verity_register_bufio_sysfs(struct dm_verity *v);
+
 static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
@@ -1824,7 +1942,10 @@ static struct target_type verity_target = {
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
 	.map		= verity_map,
+	.presuspend	= verity_presuspend,
+	.presuspend_undo = verity_presuspend_undo,
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

