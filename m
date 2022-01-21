Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21137C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jan 2022 10:17:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-66Q5WNdIOwqgkFJji6da7w-1; Fri, 21 Jan 2022 05:17:27 -0500
X-MC-Unique: 66Q5WNdIOwqgkFJji6da7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2861284B9A6;
	Fri, 21 Jan 2022 10:17:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ACDE6F948;
	Fri, 21 Jan 2022 10:17:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D372A4CA9B;
	Fri, 21 Jan 2022 10:17:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20L5PETS012239 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 Jan 2022 00:25:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6A6AA1457F07; Fri, 21 Jan 2022 05:25:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 665B41457F05
	for <dm-devel@redhat.com>; Fri, 21 Jan 2022 05:25:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0CED22BD19E8
	for <dm-devel@redhat.com>; Fri, 21 Jan 2022 05:25:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-261-NTituHL3NB-SraN0TLxp0w-1; Fri, 21 Jan 2022 00:25:11 -0500
X-MC-Unique: NTituHL3NB-SraN0TLxp0w-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 43B0A1F380;
	Fri, 21 Jan 2022 05:25:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E069E139C3;
	Fri, 21 Jan 2022 05:25:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 7LrdKLFD6mEOdQAAMHmgww
	(envelope-from <wqu@suse.com>); Fri, 21 Jan 2022 05:25:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, dm-devel@redhat.com
Date: Fri, 21 Jan 2022 13:24:45 +0800
Message-Id: <20220121052445.37692-1-wqu@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20L5PETS012239
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 21 Jan 2022 05:16:34 -0500
Subject: [dm-devel] [PATCH RFC] btrfs: sysfs: add
	<uuid>/debug/io_accounting/ directory
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[BACKGROUND]
There is a series of btrfs autodefrag bugs in v5.16, that would cause
way more IO than previous kernels.

Unfortunately there isn't any test case covering autodefrag, nor there
is anyway to show the io accounting of a btrfs.

[WORKAROUND]
I originally want to implement a dm target to do the io accounting for
all filesystems, but can not find a good enough interface (the status
interface has only 3 pre-defined workload).

Thus I turned to btrfs specific io accounting first.
One thing specific to btrfs is its integrated volume management/RAID.

Without proper profiles specification, default profile will cause
metadata IO to be accounted twice (DUP profile) and only data IO is
accounted correctly.

So for btrfs this patch will introduce a new sysfs directory in
/sys/fs/btrfs/<uuid>/debug/io_accounting/

And have the following files:

- meta_read:	Metadata bytes read
- meta_write:	Metadata bytes written
- data_read:	Data bytes read
- data_write:	Data bytes written
		(including both zoned append and regular write)

And all these accounting is in logical address space, meaning profile
will not affect the values.

All those values can be reset by simply "echo 0".

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:

- (To DM guys) Is there any good way to implement a dm target to do the IO
  accounting?
  A more generic one can help more filesystems.

- (To Btrfs guys) Is the sysfs interface fine?
---
 fs/btrfs/ctree.h   | 11 +++++++
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/sysfs.c   | 77 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c | 24 +++++++++++++++
 4 files changed, 113 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b4a9b1c58d22..3983bceaef7f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1035,10 +1035,21 @@ struct btrfs_fs_info {
 #ifdef CONFIG_BTRFS_DEBUG
 	struct kobject *debug_kobj;
 	struct kobject *discard_debug_kobj;
+	struct kobject *io_accounting_debug_kobj;
 	struct list_head allocated_roots;
 
 	spinlock_t eb_leak_lock;
 	struct list_head allocated_ebs;
+
+	spinlock_t io_accounting_lock;
+	/*
+	 * The IO accounting unit are all in byte, and are in logical address
+	 * space, which is before the RAID/DUP mapping.
+	 */
+	u64 meta_read;
+	u64 meta_write;
+	u64 data_read;
+	u64 data_write;
 #endif
 };
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 87a5addbedf6..41b56fde6e97 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3065,6 +3065,7 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	INIT_LIST_HEAD(&fs_info->allocated_roots);
 	INIT_LIST_HEAD(&fs_info->allocated_ebs);
 	spin_lock_init(&fs_info->eb_leak_lock);
+	spin_lock_init(&fs_info->io_accounting_lock);
 #endif
 	extent_map_tree_init(&fs_info->mapping_tree);
 	btrfs_init_block_rsv(&fs_info->global_block_rsv,
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index beb7f72d50b8..dfdef93bdeab 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -40,6 +40,7 @@
  * btrfs_debug_feature_attrs		/sys/fs/btrfs/debug
  * btrfs_debug_mount_attrs		/sys/fs/btrfs/<uuid>/debug
  * discard_debug_attrs			/sys/fs/btrfs/<uuid>/debug/discard
+ * io_accounting_debug_attrs		/sys/fs/btrfs/<uuid>/debug/io_accounting
  */
 
 struct btrfs_feature_attr {
@@ -616,6 +617,62 @@ static const struct attribute_group btrfs_debug_feature_attr_group = {
 	.attrs = btrfs_debug_feature_attrs,
 };
 
+/* IO accounting */
+#define io_accounting_to_fs_info(_kobj)	to_fs_info((_kobj)->parent->parent)
+
+#define DECLARE_IO_ACCOUNTING_OPS(name)					\
+static ssize_t io_accounting_##name##_show(struct kobject *kobj,	\
+					   struct kobj_attribute *a,	\
+					   char *buf)			\
+{									\
+	struct btrfs_fs_info *fs_info = io_accounting_to_fs_info(kobj);	\
+	u64 result;							\
+									\
+	spin_lock(&fs_info->io_accounting_lock);			\
+	result = fs_info->name;						\
+	spin_unlock(&fs_info->io_accounting_lock);			\
+	return sysfs_emit(buf, "%llu\n", result);			\
+}									\
+static ssize_t io_accounting_##name##_store(struct kobject *kobj,	\
+					    struct kobj_attribute *a,	\
+					    const char *buf,		\
+					    size_t count) 		\
+{									\
+	struct btrfs_fs_info *fs_info = io_accounting_to_fs_info(kobj);	\
+	u64 value;							\
+	int ret;							\
+									\
+	ret = kstrtoull(skip_spaces(buf), 0, &value);			\
+	if (ret)							\
+		return ret;						\
+	spin_lock(&fs_info->io_accounting_lock);			\
+	fs_info->name = value;						\
+	spin_unlock(&fs_info->io_accounting_lock);			\
+	return count;							\
+}
+
+DECLARE_IO_ACCOUNTING_OPS(meta_read);
+DECLARE_IO_ACCOUNTING_OPS(meta_write);
+DECLARE_IO_ACCOUNTING_OPS(data_read);
+DECLARE_IO_ACCOUNTING_OPS(data_write);
+
+BTRFS_ATTR_RW(io_accounting, meta_read, io_accounting_meta_read_show,
+	      io_accounting_meta_read_store);
+BTRFS_ATTR_RW(io_accounting, meta_write, io_accounting_meta_write_show,
+	      io_accounting_meta_write_store);
+BTRFS_ATTR_RW(io_accounting, data_read, io_accounting_data_read_show,
+	      io_accounting_data_read_store);
+BTRFS_ATTR_RW(io_accounting, data_write, io_accounting_data_write_show,
+	      io_accounting_data_write_store);
+
+static const struct attribute *io_accounting_debug_attrs[] = {
+	BTRFS_ATTR_PTR(io_accounting, meta_read),
+	BTRFS_ATTR_PTR(io_accounting, meta_write),
+	BTRFS_ATTR_PTR(io_accounting, data_read),
+	BTRFS_ATTR_PTR(io_accounting, data_write),
+	NULL,
+};
+
 #endif
 
 static ssize_t btrfs_show_u64(u64 *value_ptr, spinlock_t *lock, char *buf)
@@ -1219,6 +1276,12 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 		kobject_del(fs_info->discard_debug_kobj);
 		kobject_put(fs_info->discard_debug_kobj);
 	}
+	if (fs_info->io_accounting_debug_kobj) {
+		sysfs_remove_files(fs_info->io_accounting_debug_kobj,
+				   io_accounting_debug_attrs);
+		kobject_del(fs_info->io_accounting_debug_kobj);
+		kobject_put(fs_info->io_accounting_debug_kobj);
+	}
 	if (fs_info->debug_kobj) {
 		sysfs_remove_files(fs_info->debug_kobj, btrfs_debug_mount_attrs);
 		kobject_del(fs_info->debug_kobj);
@@ -1804,6 +1867,20 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 				   discard_debug_attrs);
 	if (error)
 		goto failure;
+
+	/* io_accounting directory */
+	fs_info->io_accounting_debug_kobj =
+		kobject_create_and_add("io_accounting",fs_info->debug_kobj);
+	if (!fs_info->io_accounting_debug_kobj) {
+		error = -ENOMEM;
+		goto failure;
+	}
+
+	error = sysfs_create_files(fs_info->io_accounting_debug_kobj,
+				   io_accounting_debug_attrs);
+	if (error)
+		goto failure;
+
 #endif
 
 	error = addrm_unknown_feature_attrs(fs_info, true);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2332e3026efa..58f2ec0a611a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6763,6 +6763,29 @@ static void bioc_error(struct btrfs_io_context *bioc, struct bio *bio, u64 logic
 	}
 }
 
+static void update_io_accounting(struct btrfs_fs_info *fs_info, struct bio *bio)
+{
+	u32 length = bio->bi_iter.bi_size;
+	bool metadata = bio->bi_opf & REQ_META;
+
+#ifdef	CONFIG_BTRFS_DEBUG
+	spin_lock(&fs_info->io_accounting_lock);
+	if (bio_op(bio) == REQ_OP_READ) {
+		if (metadata)
+			fs_info->meta_read += length;
+		else
+			fs_info->data_read += length;
+	} else {
+		if (metadata)
+			fs_info->meta_write += length;
+		else
+			fs_info->data_write += length;
+	}
+	spin_unlock(&fs_info->io_accounting_lock);
+#endif
+	return;
+}
+
 blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			   int mirror_num)
 {
@@ -6776,6 +6799,7 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	int total_devs;
 	struct btrfs_io_context *bioc = NULL;
 
+	update_io_accounting(fs_info, bio);
 	length = bio->bi_iter.bi_size;
 	map_length = length;
 
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

