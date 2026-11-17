Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921610;
	b=h68VT/mRehi+N40sG8s0+aWcZ39N10b4PSl35PK8KYZuCZ4m3dXHU0oSUkldQp5VUAdy
	 SJBuO0Hc+G27YwTz2PAEer9STtddkX5XFhqBYocu0AyWpiJKmmu0arxUQ4+XZpIvrCvLb
	 01i6DnHfXGcP1U0SJMZDKvM8/cfkzEnqwRq/4z2nmC5myrPSu7aSLPffsDTAa69StMbTd
	 AT8B7jE+xLCpzCYH1iOrpBPJtC/6N14dVQ3R8qQkAbeBYQITiTtmlOIQ1Relc+QFTqBur
	 43KJeW6VPAc/m9y16cTArScBoITm+cPWWyc0F++/g4g8z0xzKaZuNF/qT98EwX6TR3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921610;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WDy5yESA6PaIXbfffGDq84tqey99qt29TAilAEf+lLA=;
	b=aHr8ogNgAmri8hWXLXuIQR9I6+X+jq3htErPIxXCNk764nxHyK0IM20a0HC4uUYZtDvz
	 H1UQxUIzFPC031NJNkAyFzYu/eJHg7A59GcjrhC5brGbh5LUZtQr6E1voI85wnMCNxYHE
	 OjZSYzZcB+Yt026taZsuS7eubEQA7i07M7AIUsYq7Hick5m7yTVzcB1ad/wcjdsebgCHA
	 82ZllBHIZ31LmhRlaPIVjxAq5eC8QiWJlCdq3iDRD8XreG0DELCf2ncAdKB6k833BbI68
	 bdoTdpkEtbi8lpzyBXw+O0MfFadR+5Tx+1wM8S+xk18ugFbAEzXRoPyRvoDjIlCT4Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dZmtqevU;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1CC606A329
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F1CC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dZmtqevU
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e9eb579c0eso26740455ad.3
        for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 05:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794921609; x=1795526409; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WDy5yESA6PaIXbfffGDq84tqey99qt29TAilAEf+lLA=;
        b=dZmtqevUI1XjksT4yagI5dt5iN3re1g6XN3ckvLTqSz/pxgDcQHh52TIEmT5eHunfl
         CPNuNu0TEI6pdt4RpDNjArdmzrB5aUVoQE0gURp17xmqb13e8iWiAnoJFwoVAFiNCEpq
         gcv8atwfmtCEVMX6nNHZy7tC0ujPtFbpAFbxUKitFANXe59dR99gANe0PRnG3oFn9YGS
         f/Fq1b6umqFWF99jX9hBIYtCaMWdXhtZ7l1FFo2uIDbK08u8uh6YdlFk4dTY+60Xi5iZ
         TdfrkzD8H9zmYoMofHgFesVTFxB5IlAZdDOLoyQDlcnNZy6J7p1OUDN9wnPPD1agriZJ
         49eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794921609; x=1795526409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WDy5yESA6PaIXbfffGDq84tqey99qt29TAilAEf+lLA=;
        b=MFI7EQN8b4GtgpbcF1BJve0Hl2pX0ebpMSA91pMJKRlL7CcBESQpHfq5gVix5dwBAY
         rERZ0yJyZf6iKxEWgmMccKw4dk7icEvKSBRXkFb4wz/yhKY6Fahp+d6KdSSJ2EzXEJ/h
         WurtDye9kwQlsOPjyVqILDCB9whNLQolCP0fBQJ6UcV/D4RaRodJzxRgc+RSuL5bK7Ox
         8qeEKK5coIyv5QOzefLkgNOJREg2qZa/RNrJe2d/i7kymmxEoEW+fuYNZFbON4LyyW5V
         7bvqaEihn4gumn0Q8l1mPxKlb/1xqb5dtQHALzVSbwpOJNgxABSc2u1NGLi9zBVKIAdn
         qiOA==
X-Gm-Message-State: APuU4Z8xXBNswkazsZ089YyXcukYgOo26F9cU10fAGahjRD3FIRmPsIq
	3Ii4Pac4WAhDW89nFVYTrFmKPolorSJiHwwREBjemNYVJwEp9p+SUMKI
X-Gm-Gg: AZFdTZcuXvWjfK5r33WshOLKJEiKVrufmcpHofal6J9Y9gqz46t58K19QxX/SUhxbX0
	cLC3nKUfVA+M8V4+FZ61+LegMxCyOy6lJvz7HBxJ08m2MDpsMf0YmrHO1KuHgonEEUVHRMkH78l
	FABgH7/aNxEjHbiehWUpeZwNRugfXoTEFpAWXsWG9v6MibaWpjWjl5IXjpMawpuYbtDmO/rvrJD
	vnJybV+TD3D2FuMfAWJFpiDmNRjdSLbOy7kXCFahBGTnrOMwOTN6ea4mJxVctzl/fGa8eY3Eyrf
	IZGXUv0orvsw1SBGh0MoxvWgmLhX8Q8g79XCxWkd/nBeUYhBvj0eluxRHy8nV27uzRBkMaz1YiX
	LaevNL0ruKDHUYeD5Lsp+N5lB2B34QIKIg1kSpCh11/WdA7idsbUOUnFWCNC8gfnjUQlWJ86Vet
	YQXvqV8RCgf9uJJT6gTIDeDzMaw73Rh4BbqWPjLS30yN0DXUIhd9VhjZ/PTNkQ63DfzSItT4Mco
	q2jEriQqTSy43IHzJTpqPGNz7yX7DjxazLgnMsgS1ZPfVBt0Ai1bF64JLRDlaOTTuMOkevkBzJu
	eMfoXy2rMawXO80ozk18lmFb0XSzOfrKsI1L1BUlXBjc22/yXPSLkOQpj8mXTIIgIVUu8o5GUE0
	n/eLrZCi5VRTI5Q19qrApzf13l/yEGA==
X-Received: by 2002:a17:902:d48c:b0:2e9:5c55:c472 with SMTP id d9443c01a7336-2ee0dc06323mr122842245ad.42.1794921609305;
        Tue, 17 Nov 2026 05:20:09 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a5f754sm16064915ad.52.2026.11.17.05.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:20:08 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a caller-chosen kobject
Date: Tue, 17 Nov 2026 21:19:18 +0800
Message-ID: <20261117131918.2745193-5-yangyongpeng.storage@gmail.com>
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

There is no way to see how much memory a particular dm-bufio client is
using, or to change one client's retain target without also affecting
every future client.

Add dm_bufio_client_sysfs_add(), which publishes a client as <name>
under a kobject supplied by its user, with the retain target writable
and the rest of its state read-only.  Callers that have no use for it
simply never call it.

The kobject is embedded in the client, which is therefore freed only
after the release method runs, as in dm-sysfs.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
 .../ABI/testing/sysfs-kernel-dm-bufio         |  76 +++++++++
 .../admin-guide/device-mapper/dm-bufio.rst    |  54 +++++++
 .../admin-guide/device-mapper/index.rst       |   1 +
 drivers/md/dm-bufio.c                         | 147 ++++++++++++++++++
 include/linux/dm-bufio.h                      |   8 +
 5 files changed, 286 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-dm-bufio
 create mode 100644 Documentation/admin-guide/device-mapper/dm-bufio.rst

diff --git a/Documentation/ABI/testing/sysfs-kernel-dm-bufio b/Documentation/ABI/testing/sysfs-kernel-dm-bufio
new file mode 100644
index 000000000000..f514e7a6a019
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-dm-bufio
@@ -0,0 +1,76 @@
+What:		/sys/block/<dm-device>/dm-bufio/<name>/
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Directory exposing one dm-bufio client whose user opted in
+		through dm_bufio_client_sysfs_add().  <name> is chosen by that
+		user; dm-verity, which places the directory under the block
+		device of its own dm device, uses <name> "hash" for the hash
+		tree client, "fec" for the FEC parity client and "fec-data"
+		for the FEC data client.  The directory lives from
+		registration until the client is destroyed, independently of
+		any device-mapper table loaded on the device, so a suspend or
+		table reload never leaves dangling entries behind.  The
+		read-only counters are instantaneous snapshots and may be
+		approximate.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/bdev
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Major and minor of the client's block device, in the form
+		<major>:<minor>.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/bdev_name
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Name of the client's block device.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/block_size
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Block size of the client in bytes.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/retain_bytes
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Number of bytes dm-bufio tries to keep cached for this
+		client.  It is a floor applied by the memory shrinker, not a
+		cap, so the cache may grow past it when memory is plentiful.
+
+		Writable.  A non-zero value is rounded to a block
+		boundary (but at least one block); zero restores the
+		dm-bufio default.  Writing it affects only this client,
+		not the retain_bytes module parameter and not other
+		clients.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/current_bytes
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Number of bytes currently cached by this client.  Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/buffers
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Number of buffers currently cached by this client.
+		Read-only.
+
+What:		/sys/block/<dm-device>/dm-bufio/<name>/minimum_buffers
+Date:		November 2026
+KernelVersion:	7.4
+Contact:	dm-devel@lists.linux.dev
+Description:
+		Minimum number of buffers the client keeps before cleanup
+		happens.  Read-only.
diff --git a/Documentation/admin-guide/device-mapper/dm-bufio.rst b/Documentation/admin-guide/device-mapper/dm-bufio.rst
new file mode 100644
index 000000000000..c35e415acacd
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/dm-bufio.rst
@@ -0,0 +1,54 @@
+========
+dm-bufio
+========
+
+dm-bufio caches small metadata blocks on block devices for several
+device-mapper targets (dm-verity, dm-thin, dm-cache, dm-integrity and
+dm-ebs among others).  Each user creates clients on a block device; the
+caches are independent, even for clients on the same device.
+
+Retain target
+=============
+
+dm-bufio bounds nothing by itself: buffers live until the memory shrinker
+evicts them, and the shrinker stops once a client is back down to its
+retain target.  The target is a floor under memory pressure, not a cap,
+so a fully warmed cache may hold far more.
+
+The default is the ``retain_bytes`` module parameter of dm_bufio
+(256 KiB), which only affects clients created after it is changed.  One
+client changes its own target through the ``retain_bytes`` attribute of
+its sysfs directory or a target-specific message.
+
+sysfs interface
+===============
+
+A client may be published in sysfs with dm_bufio_client_sysfs_add(),
+passing the parent kobject and the directory name; dm-bufio does not
+choose where it lives.  The directory lives until the client is
+destroyed.  dm-verity registers its clients under the block device of
+its own dm device::
+
+  /sys/block/dm-N/dm-bufio/hash/        the hash tree client
+  /sys/block/dm-N/dm-bufio/fec/         the FEC parity client
+  /sys/block/dm-N/dm-bufio/fec-data/    the FEC data client
+
+The attributes, including the read-write ``retain_bytes``, are documented
+in Documentation/ABI/testing/sysfs-kernel-dm-bufio.
+
+Example
+=======
+
+Inspect the hash client of a dm-verity device::
+
+  # ls /sys/block/dm-1/dm-bufio/
+  fec  fec-data  hash
+
+  # cat /sys/block/dm-1/dm-bufio/hash/retain_bytes
+  2535424
+
+  # echo 8388608 > /sys/block/dm-1/dm-bufio/hash/retain_bytes
+  # cat /sys/block/dm-1/dm-bufio/hash/retain_bytes
+  8388608
+
+The other clients keep their own targets.
diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index 73c1f2002134..3b6c348f71f5 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -8,6 +8,7 @@ Device Mapper
     cache-policies
     cache
     delay
+    dm-bufio
     dm-clone
     dm-crypt
     dm-dust
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 75b6e5c027ae..627a64f981c5 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -20,6 +20,9 @@
 #include <linux/rbtree.h>
 #include <linux/stacktrace.h>
 #include <linux/jump_label.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/completion.h>
 
 #include "dm.h"
 
@@ -995,6 +998,9 @@ struct dm_bufio_client {
 	unsigned int minimum_buffers;
 
 	unsigned long retain_bytes;	/* READ_ONCE/WRITE_ONCE, no lock needed */
+	bool sysfs_added;
+	struct kobject kobj;
+	struct completion kobj_unregister;
 
 	sector_t start;
 
@@ -2504,6 +2510,144 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
 	return count;
 }
 
+/*
+ * A client may be published in sysfs with dm_bufio_client_sysfs_add();
+ * the directory lives until the client is destroyed.
+ */
+
+static ssize_t dm_bufio_attr_show(struct kobject *kobj, struct attribute *attr,
+				  char *buf);
+static ssize_t dm_bufio_attr_store(struct kobject *kobj, struct attribute *attr,
+				   const char *buf, size_t size);
+
+#define DM_BUFIO_ATTR_RO(_name)						\
+	static struct attribute dm_bufio_attr_##_name =			\
+		{ .name = #_name, .mode = 0444 }
+
+#define DM_BUFIO_ATTR_RW(_name)						\
+	static struct attribute dm_bufio_attr_##_name =			\
+		{ .name = #_name, .mode = 0644 }
+
+DM_BUFIO_ATTR_RO(bdev);
+DM_BUFIO_ATTR_RO(bdev_name);
+DM_BUFIO_ATTR_RO(block_size);
+DM_BUFIO_ATTR_RW(retain_bytes);
+DM_BUFIO_ATTR_RO(current_bytes);
+DM_BUFIO_ATTR_RO(buffers);
+DM_BUFIO_ATTR_RO(minimum_buffers);
+
+static ssize_t dm_bufio_attr_show(struct kobject *kobj, struct attribute *attr,
+				  char *buf)
+{
+	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
+
+	if (attr == &dm_bufio_attr_bdev)
+		return sysfs_emit(buf, "%d:%d\n", MAJOR(c->bdev->bd_dev),
+				  MINOR(c->bdev->bd_dev));
+	if (attr == &dm_bufio_attr_bdev_name)
+		return sysfs_emit(buf, "%pg\n", c->bdev);
+	if (attr == &dm_bufio_attr_block_size)
+		return sysfs_emit(buf, "%u\n", c->block_size);
+	if (attr == &dm_bufio_attr_retain_bytes)
+		return sysfs_emit(buf, "%lu\n", READ_ONCE(c->retain_bytes));
+	if (attr == &dm_bufio_attr_current_bytes)
+		return sysfs_emit(buf, "%llu\n",
+				  (u64)cache_total(&c->cache) * c->block_size);
+	if (attr == &dm_bufio_attr_buffers)
+		return sysfs_emit(buf, "%lu\n", cache_total(&c->cache));
+	if (attr == &dm_bufio_attr_minimum_buffers)
+		return sysfs_emit(buf, "%u\n", c->minimum_buffers);
+
+	return -EINVAL;
+}
+
+static ssize_t dm_bufio_attr_store(struct kobject *kobj, struct attribute *attr,
+				   const char *buf, size_t size)
+{
+	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
+
+	if (attr == &dm_bufio_attr_retain_bytes) {
+		unsigned long new;
+
+		if (kstrtoul(buf, 0, &new))
+			return -EINVAL;
+
+		dm_bufio_set_retain_bytes(c, new);
+
+		return size;
+	}
+
+	return -EINVAL;
+}
+
+static struct attribute *dm_bufio_attrs[] = {
+	&dm_bufio_attr_bdev,
+	&dm_bufio_attr_bdev_name,
+	&dm_bufio_attr_block_size,
+	&dm_bufio_attr_retain_bytes,
+	&dm_bufio_attr_current_bytes,
+	&dm_bufio_attr_buffers,
+	&dm_bufio_attr_minimum_buffers,
+	NULL,
+};
+ATTRIBUTE_GROUPS(dm_bufio);
+
+static const struct sysfs_ops dm_bufio_sysfs_ops = {
+	.show	= dm_bufio_attr_show,
+	.store	= dm_bufio_attr_store,
+};
+
+static void dm_bufio_kobj_release(struct kobject *kobj)
+{
+	struct dm_bufio_client *c = container_of(kobj, struct dm_bufio_client, kobj);
+
+	/*
+	 * The client is freed only after this completes, as in dm-sysfs.
+	 */
+	complete(&c->kobj_unregister);
+}
+
+static const struct kobj_type dm_bufio_ktype = {
+	.sysfs_ops	= &dm_bufio_sysfs_ops,
+	.default_groups	= dm_bufio_groups,
+	.release	= dm_bufio_kobj_release,
+};
+
+static int dm_bufio_kobj_add(struct dm_bufio_client *c, struct kobject *parent,
+			     const char *name)
+{
+	init_completion(&c->kobj_unregister);
+
+	return kobject_init_and_add(&c->kobj, &dm_bufio_ktype, parent, "%s",
+				    name);
+}
+
+/* Drop the sysfs reference and wait for the release method to run. */
+static void dm_bufio_kobj_del(struct dm_bufio_client *c)
+{
+	kobject_put(&c->kobj);
+	wait_for_completion(&c->kobj_unregister);
+}
+
+int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject *parent,
+			      const char *name)
+{
+	int r;
+
+	if (c->sysfs_added)
+		return -EBUSY;
+
+	r = dm_bufio_kobj_add(c, parent, name);
+	if (r) {
+		dm_bufio_kobj_del(c);
+		return r;
+	}
+
+	c->sysfs_added = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_bufio_client_sysfs_add);
+
 /*
  * Create the buffering interface
  */
@@ -2660,6 +2804,9 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 {
 	unsigned int i;
 
+	if (c->sysfs_added)
+		dm_bufio_kobj_del(c);
+
 	drop_buffers(c);
 
 	shrinker_free(c->shrinker);
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 9bf3f805c43c..6d82f1200aeb 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -17,6 +17,7 @@
 
 struct dm_bufio_client;
 struct dm_buffer;
+struct kobject;
 
 /*
  * Flags for dm_bufio_client_create
@@ -165,6 +166,13 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
 void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes);
 unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c);
 
+/*
+ * Publish the client as <name> under <parent> in sysfs; removed in
+ * dm_bufio_client_destroy().
+ */
+int dm_bufio_client_sysfs_add(struct dm_bufio_client *c, struct kobject *parent,
+			      const char *name);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
-- 
2.43.0

