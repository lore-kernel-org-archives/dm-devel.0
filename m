Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6108022337
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 22:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmm3ZX0W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698101637;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xVLmoGXdb1ispXWh0Lo9SfBZrTP+nXAThvFnHzoXWAk=;
	b=bmm3ZX0WmLHM3EG106Q1vwhQuU4MpmO4XLFI+cvvniLinUa+J1RHG9mgLbpyVEDoRQnRu1
	DCDcbOlEaa/4zWr2f9HQ9LcG07xygWF9wY7EAz0ZC+yB8lS+pMf7ya5kVmvVxLF5eV844O
	P/MJqYF6FwoTRyFtDvW9EkbuvJ3Zpwc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-qOJqOu-xMvGi17aUNH1JxQ-1; Mon, 23 Oct 2023 18:53:56 -0400
X-MC-Unique: qOJqOu-xMvGi17aUNH1JxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1D3C837220
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 22:53:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA63D2166B26
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 22:53:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 643461946589
	for <dm-devel@lists.linux.dev>; Mon, 23 Oct 2023 22:53:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6ECC21946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 Oct 2023 22:53:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2B37F123; Mon, 23 Oct 2023 22:53:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2445825C0
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 22:53:54 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 007B72808FCB
 for <dm-devel@redhat.com>; Mon, 23 Oct 2023 22:53:54 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-bQINmv3wPhivHBzorVaQUA-1; Mon,
 23 Oct 2023 18:53:52 -0400
X-MC-Unique: bQINmv3wPhivHBzorVaQUA-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by ams.source.kernel.org (Postfix) with ESMTP id 99344B81F26;
 Mon, 23 Oct 2023 22:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A2FC433C8;
 Mon, 23 Oct 2023 22:45:14 +0000 (UTC)
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: error: Add support for zoned block devices
Date: Tue, 24 Oct 2023 07:45:13 +0900
Message-ID: <20231023224513.344380-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"; x-default=true

dm-error is used in several test cases in the xfstests test suite to
check the handling of IO errors in file syatems. However, with several
file systems getting native support for zoned block devices (e.g. btrfs
and f2fs), dm-error lack of zoned block device support creates problems
as the file system attempt executing zone commands (e.g. a zone append
operation) against a dm-error non-zoned block device, which causes
various issues in the block layer (e.g. WARN_ON triggers).

This patch adds supports for zoned block devices to dm-error, allowing
an error table to be exposed as a zoned block device. This is done by
relying on the first argument passed to dmsetup when creating the device
table: if that first argument is a path to a backing block device, the
dm-error device is created by copying the limits of the backing device,
thus also copying its zone model. This is consistent with how xfstests
creates dm-error devices (always passing the path to the backing device
as the first argument).

The zone support for dm-error requires the definition of the
report_zones target type method, which is done by introducing the
function io_err_report_zones(). Given that this function fails report
zones operations (similarly to any other command issued to the dm-error
device), dm_set_zones_restrictions() is tweaked to do nothing for a
wildcard target to avoid failing zone revalidation. As the dm-error
target does not implemt the iterate_devices method,
dm_table_supports_zoned_model() is also changed to return true.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-table.c  |  3 +++
 drivers/md/dm-target.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm-zone.c   |  9 +++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 37b48f63ae6a..5e4d887063d3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm_t=
able *t,
 =09for (unsigned int i =3D 0; i < t->num_targets; i++) {
 =09=09struct dm_target *ti =3D dm_table_get_target(t, i);
=20
+=09=09if (dm_target_is_wildcard(ti->type))
+=09=09=09continue;
+
 =09=09if (dm_target_supports_zoned_hm(ti->type)) {
 =09=09=09if (!ti->type->iterate_devices ||
 =09=09=09    ti->type->iterate_devices(ti, device_not_zoned_model,
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 27e2992ff249..1bf4ecda3012 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -118,6 +118,21 @@ EXPORT_SYMBOL(dm_unregister_target);
  */
 static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args=
)
 {
+=09struct dm_dev *ddev;
+=09int ret;
+
+=09/*
+=09 * If we have an argument, assume it is the path to the target
+=09 * block device we are replacing. In this case, get the device
+=09 * so that we can copy its limits in io_err_io_hints().
+=09 */
+=09if (argc) {
+=09=09ret =3D dm_get_device(tt, args[0], dm_table_get_mode(tt->table),
+=09=09=09=09    &ddev);
+=09=09if (ret =3D=3D 0)
+=09=09=09tt->private =3D ddev;
+=09}
+
 =09/*
 =09 * Return error for discards instead of -EOPNOTSUPP
 =09 */
@@ -129,7 +144,10 @@ static int io_err_ctr(struct dm_target *tt, unsigned i=
nt argc, char **args)
=20
 static void io_err_dtr(struct dm_target *tt)
 {
-=09/* empty */
+=09struct dm_dev *ddev =3D tt->private;
+
+=09if (ddev)
+=09=09dm_put_device(tt, ddev);
 }
=20
 static int io_err_map(struct dm_target *tt, struct bio *bio)
@@ -149,8 +167,27 @@ static void io_err_release_clone_rq(struct request *cl=
one,
 {
 }
=20
+#ifdef CONFIG_BLK_DEV_ZONED
+static int io_err_report_zones(struct dm_target *ti,
+=09=09struct dm_report_zones_args *args, unsigned int nr_zones)
+{
+=09return -EIO;
+}
+#else
+#define io_err_report_zones NULL
+#endif
+
 static void io_err_io_hints(struct dm_target *ti, struct queue_limits *lim=
its)
 {
+=09struct dm_dev *ddev =3D ti->private;
+
+=09/* If we have a target device, copy its limits */
+=09if (ddev) {
+=09=09struct request_queue *q =3D bdev_get_queue(ddev->bdev);
+
+=09=09memcpy(limits, &q->limits, sizeof(*limits));
+=09}
+
 =09limits->max_discard_sectors =3D UINT_MAX;
 =09limits->max_hw_discard_sectors =3D UINT_MAX;
 =09limits->discard_granularity =3D 512;
@@ -166,7 +203,7 @@ static long io_err_dax_direct_access(struct dm_target *=
ti, pgoff_t pgoff,
 static struct target_type error_target =3D {
 =09.name =3D "error",
 =09.version =3D {1, 6, 0},
-=09.features =3D DM_TARGET_WILDCARD,
+=09.features =3D DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
 =09.ctr  =3D io_err_ctr,
 =09.dtr  =3D io_err_dtr,
 =09.map  =3D io_err_map,
@@ -174,6 +211,7 @@ static struct target_type error_target =3D {
 =09.release_clone_rq =3D io_err_release_clone_rq,
 =09.io_hints =3D io_err_io_hints,
 =09.direct_access =3D io_err_dax_direct_access,
+=09.report_zones =3D io_err_report_zones,
 };
=20
 int __init dm_target_init(void)
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index eb9832b22b14..9b77ee05e8dd 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -297,6 +297,15 @@ int dm_set_zones_restrictions(struct dm_table *t, stru=
ct request_queue *q)
 =09WARN_ON_ONCE(queue_is_mq(q));
 =09md->disk->nr_zones =3D bdev_nr_zones(md->disk->part0);
=20
+=09/*
+=09 * With dm-error (wildcard target), report zones will fail, so do
+=09 * nothing. dm-error will copy the zones limits itself.
+=09 */
+=09if (dm_table_get_wildcard_target(t)) {
+=09=09md->nr_zones =3D md->disk->nr_zones;
+=09=09return 0;
+=09}
+
 =09/* Check if zone append is natively supported */
 =09if (dm_table_supports_zone_append(t)) {
 =09=09clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
--=20
2.41.0

