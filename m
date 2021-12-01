Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A86C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 16:38:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-vVWv5RVTME6X-sNDD-hCCw-1; Wed, 01 Dec 2021 11:38:20 -0500
X-MC-Unique: vVWv5RVTME6X-sNDD-hCCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A15A81015DA5;
	Wed,  1 Dec 2021 16:38:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 889BA79446;
	Wed,  1 Dec 2021 16:38:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6FA8A1809C89;
	Wed,  1 Dec 2021 16:38:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1Gc2da015939 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 11:38:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DE31E1121314; Wed,  1 Dec 2021 16:38:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A20B91121315
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 16:37:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD8461066682
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 16:37:59 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-295-dc_PnFx2PteDb0Zlz62W3Q-1; Wed, 01 Dec 2021 11:37:56 -0500
X-MC-Unique: dc_PnFx2PteDb0Zlz62W3Q-1
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4J44Vk07Fjz67ts3;
	Thu,  2 Dec 2021 00:37:02 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
	fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Wed, 1 Dec 2021 17:37:51 +0100
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <deven.desai@linux.microsoft.com>, <corbet@lwn.net>, <axboe@kernel.dk>,
	<agk@redhat.com>, <snitzer@redhat.com>, <ebiggers@kernel.org>,
	<tytso@mit.edu>, <paul@paul-moore.com>, <eparis@redhat.com>,
	<jmorris@namei.org>, <serge@hallyn.com>
Date: Wed, 1 Dec 2021 17:37:08 +0100
Message-ID: <20211201163708.3578176-1-roberto.sassu@huawei.com>
In-Reply-To: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
References: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
MIME-Version: 1.0
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
	fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1Gc2da015939
X-loop: dm-devel@redhat.com
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	jannh@google.com, Roberto Sassu <roberto.sassu@huawei.com>,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-audit@redhat.com, tusharsu@linux.microsoft.com,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [RFC][PATCH] device mapper: Add builtin function
	dm_get_status()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Users of the device mapper driver might want to obtain a device status,
with status types defined in the status_type_t enumerator.

If a function to get the status is exported by the device mapper, when
compiled as a module, it is not suitable to use by callers compiled builtin
in the kernel.

Introduce the real function to get the status, _dm_get_status(), in the
device mapper module, and add the stub dm_get_status() in dm-builtin.c, so
that it can be invoked by builtin callers.

The stub calls the real function if the device mapper is compiled builtin
or the module has been loaded. Calls to the real function are safely
disabled if the module is unloaded. The race condition is avoided by
incrementing the reference count of the module.

_dm_get_status() invokes the status() method for each device mapper table,
which writes a string to the supplied buffer as output. The buffer might
contain multiple strings concatenated together. If there is not enough
space available, the string is truncated and a termination character is put
at the end.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 drivers/md/dm-builtin.c       | 13 +++++++
 drivers/md/dm-core.h          |  5 +++
 drivers/md/dm.c               | 71 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  3 ++
 4 files changed, 92 insertions(+)

diff --git a/drivers/md/dm-builtin.c b/drivers/md/dm-builtin.c
index 8eb52e425141..cc1e9c27ab41 100644
--- a/drivers/md/dm-builtin.c
+++ b/drivers/md/dm-builtin.c
@@ -47,3 +47,16 @@ void dm_kobject_release(struct kobject *kobj)
 }
 
 EXPORT_SYMBOL(dm_kobject_release);
+
+dm_get_status_fn status_fn;
+EXPORT_SYMBOL(status_fn);
+
+ssize_t dm_get_status(dev_t dev, status_type_t type, const char *target_name,
+		      u8 *buf, size_t buf_len)
+{
+	if (status_fn)
+		return status_fn(dev, type, target_name, buf, buf_len);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(dm_get_status);
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index b855fef4f38a..6600ec260558 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -259,4 +259,9 @@ extern atomic_t dm_global_event_nr;
 extern wait_queue_head_t dm_global_eventq;
 void dm_issue_global_event(void);
 
+typedef ssize_t (*dm_get_status_fn)(dev_t dev, status_type_t type,
+				    const char *target_name, u8 *buf,
+				    size_t buf_len);
+
+extern dm_get_status_fn status_fn;
 #endif
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 662742a310cb..55e59a4e3661 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -192,6 +192,74 @@ static unsigned dm_get_numa_node(void)
 					 DM_NUMA_NODE, num_online_nodes() - 1);
 }
 
+static ssize_t _dm_get_status(dev_t dev, status_type_t type,
+			      const char *target_name, u8 *buf, size_t buf_len)
+{
+	struct mapped_device *md;
+	struct dm_table *table;
+	u8 *buf_ptr = buf;
+	ssize_t len, res = 0;
+	int srcu_idx, num_targets, i;
+
+	if (buf_len > INT_MAX)
+		return -EINVAL;
+
+	if (!buf_len)
+		return buf_len;
+
+	if (!try_module_get(THIS_MODULE))
+		return -EBUSY;
+
+	md = dm_get_md(dev);
+	if (!md) {
+		res = -ENOENT;
+		goto out_module;
+	}
+
+	table = dm_get_live_table(md, &srcu_idx);
+	if (!table) {
+		res = -ENOENT;
+		goto out_md;
+	}
+
+	memset(buf, 0, buf_len);
+
+	num_targets = dm_table_get_num_targets(table);
+
+	for (i = 0; i < num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(table, i);
+
+		if (!ti)
+			continue;
+
+		if (target_name && strcmp(ti->type->name, target_name))
+			continue;
+
+		if (!ti->type->status)
+			continue;
+
+		ti->type->status(ti, type, 0, buf_ptr, buf + buf_len - buf_ptr);
+
+		if (!*buf_ptr)
+			continue;
+
+		len = strlen(buf_ptr);
+		buf_ptr += len + 1;
+
+		if (buf_ptr == buf + buf_len)
+			break;
+
+		res += len + 1;
+	}
+
+	dm_put_live_table(md, srcu_idx);
+out_md:
+	dm_put(md);
+out_module:
+	module_put(THIS_MODULE);
+	return res;
+}
+
 static int __init local_init(void)
 {
 	int r;
@@ -275,6 +343,7 @@ static int __init dm_init(void)
 			goto bad;
 	}
 
+	status_fn = _dm_get_status;
 	return 0;
 bad:
 	while (i--)
@@ -287,6 +356,8 @@ static void __exit dm_exit(void)
 {
 	int i = ARRAY_SIZE(_exits);
 
+	status_fn = NULL;
+
 	while (i--)
 		_exits[i]();
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index a7df155ea49b..d97b296d3104 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -487,6 +487,9 @@ int dm_report_zones(struct block_device *bdev, sector_t start, sector_t sector,
 		    struct dm_report_zones_args *args, unsigned int nr_zones);
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+ssize_t dm_get_status(dev_t dev, status_type_t type, const char *target_name,
+		      u8 *buf, size_t buf_len);
+
 /*
  * Device mapper functions to parse and create devices specified by the
  * parameter "dm-mod.create="
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

