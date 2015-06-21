From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 3/3] dm-crypt: Adds support for wiping key when doing suspend/hibernation
Date: Sun, 21 Jun 2015 13:20:34 +0200
Message-ID: <1434885634-19895-4-git-send-email-pali.rohar@gmail.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
List-Id: dm-devel.ids

This patch adds dm message commands and option strings to optionally wi=
pe key
from dm-crypt device before entering suspend or hibernate state.

Before key is wiped dm device must be suspended. To prevent race condit=
ions with
I/O and userspace processes, wiping action must be called after process=
es are
freezed. Otherwise userspace processes could start reading/writing to d=
isk after
dm device is suspened and freezing processes before suspend/hibernate a=
ction
will fail.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
Changes since v1:
* Use "retain_on_hibernation" message instead "wipe_on_hibernation 0"
* In crypt_suspend_and_wipe_key() check for errors and return status
* In crypt_status() show also key_wipe_on_hibernation/key_wipe_on_suspe=
nd
---
 drivers/md/dm-crypt.c |  126 +++++++++++++++++++++++++++++++++++++++++=
++++----
 1 file changed, 118 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5503e43..f8536fb 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -23,6 +23,7 @@
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <linux/rbtree.h>
+#include <linux/suspend.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
@@ -31,6 +32,8 @@
=20
 #include <linux/device-mapper.h>
=20
+#include "dm.h"
+
 #define DM_MSG_PREFIX "crypt"
=20
 /*
@@ -112,13 +115,18 @@ struct iv_tcw_private {
  * and encrypts / decrypts at the same time.
  */
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
-	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
+	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
+	     DM_CRYPT_KEY_WIPE_ON_HIBERNATION,
+	     DM_CRYPT_KEY_WIPE_ON_SUSPEND,
+};
=20
 /*
  * The fields in here must be read only after initialization.
  */
 struct crypt_config {
 	struct dm_dev *dev;
+	struct dm_target *ti;
+	struct list_head entry;
 	sector_t start;
=20
 	/*
@@ -181,6 +189,9 @@ struct crypt_config {
=20
 #define MIN_IOS        16
=20
+static LIST_HEAD(crypt_list);
+static DEFINE_MUTEX(crypt_list_mtx);
+
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_reques=
t *dmreq);
@@ -1497,12 +1508,33 @@ out:
=20
 static int crypt_wipe_key(struct crypt_config *cc)
 {
+	int ret;
+
+	if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
+		ret =3D cc->iv_gen_ops->wipe(cc);
+		if (ret)
+			return ret;
+	}
+
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
=20
 	return crypt_setkey_allcpus(cc);
 }
=20
+static int crypt_suspend_and_wipe_key(struct crypt_config *cc)
+{
+	int ret;
+
+	if (!dm_suspended(cc->ti)) {
+		ret =3D dm_suspend_md(dm_table_get_md(cc->ti->table));
+		if (ret)
+			return ret;
+	}
+
+	return crypt_wipe_key(cc);
+}
+
 static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc =3D ti->private;
@@ -1512,6 +1544,10 @@ static void crypt_dtr(struct dm_target *ti)
 	if (!cc)
 		return;
=20
+	mutex_lock(&crypt_list_mtx);
+	list_del(&cc->entry);
+	mutex_unlock(&crypt_list_mtx);
+
 	if (cc->write_thread)
 		kthread_stop(cc->write_thread);
=20
@@ -1738,6 +1774,7 @@ static int crypt_ctr(struct dm_target *ti, unsign=
ed int argc, char **argv)
 	cc->key_size =3D key_size;
=20
 	ti->private =3D cc;
+	cc->ti =3D ti;
 	ret =3D crypt_ctr_cipher(ti, argv[0], argv[1]);
 	if (ret < 0)
 		goto bad;
@@ -1833,7 +1870,14 @@ static int crypt_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
 			else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))
 				set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
=20
+			else if (!strcasecmp(opt_string, "key_wipe_on_hibernation"))
+				set_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags);
+
+			else if (!strcasecmp(opt_string, "key_wipe_on_suspend"))
+				set_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags);
+
 			else {
+				ret =3D -EINVAL;
 				ti->error =3D "Invalid feature arguments";
 				goto bad;
 			}
@@ -1872,6 +1916,10 @@ static int crypt_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
 	ti->num_flush_bios =3D 1;
 	ti->discard_zeroes_data_unsupported =3D true;
=20
+	mutex_lock(&crypt_list_mtx);
+	list_add(&cc->entry, &crypt_list);
+	mutex_unlock(&crypt_list_mtx);
+
 	return 0;
=20
 bad:
@@ -1937,6 +1985,10 @@ static void crypt_status(struct dm_target *ti, s=
tatus_type_t type,
 		num_feature_args +=3D !!ti->num_discard_bios;
 		num_feature_args +=3D test_bit(DM_CRYPT_SAME_CPU, &cc->flags);
 		num_feature_args +=3D test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
+		num_feature_args +=3D test_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION,
+					     &cc->flags);
+		num_feature_args +=3D test_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND,
+					     &cc->flags);
 		if (num_feature_args) {
 			DMEMIT(" %d", num_feature_args);
 			if (ti->num_discard_bios)
@@ -1945,6 +1997,10 @@ static void crypt_status(struct dm_target *ti, s=
tatus_type_t type,
 				DMEMIT(" same_cpu_crypt");
 			if (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags))
 				DMEMIT(" submit_from_crypt_cpus");
+			if (test_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags))
+				DMEMIT(" key_wipe_on_hibernation");
+			if (test_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags))
+				DMEMIT(" key_wipe_on_suspend");
 		}
=20
 		break;
@@ -1980,6 +2036,10 @@ static void crypt_resume(struct dm_target *ti)
 /* Message interface
  *	key set <key>
  *	key wipe
+ *	key wipe_on_hibernation
+ *	key retain_on_hibernation
+ *	key wipe_on_suspend
+ *	key retain_on_suspend
  */
 static int crypt_message(struct dm_target *ti, unsigned argc, char **a=
rgv)
 {
@@ -1990,6 +2050,22 @@ static int crypt_message(struct dm_target *ti, u=
nsigned argc, char **argv)
 		goto error;
=20
 	if (!strcasecmp(argv[0], "key")) {
+		if (argc =3D=3D 2 && !strcasecmp(argv[1], "wipe_on_hibernation")) {
+			set_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags);
+			return 0;
+		}
+		if (argc =3D=3D 2 && !strcasecmp(argv[1], "retain_on_hibernation")) =
{
+			clear_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags);
+			return 0;
+		}
+		if (argc =3D=3D 2 && !strcasecmp(argv[1], "wipe_on_suspend")) {
+			set_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags);
+			return 0;
+		}
+		if (argc =3D=3D 2 && !strcasecmp(argv[1], "retain_on_suspend")) {
+			clear_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags);
+			return 0;
+		}
 		if (!test_bit(DM_CRYPT_SUSPENDED, &cc->flags)) {
 			DMWARN("not suspended during key manipulation.");
 			return -EINVAL;
@@ -2003,11 +2079,6 @@ static int crypt_message(struct dm_target *ti, u=
nsigned argc, char **argv)
 			return ret;
 		}
 		if (argc =3D=3D 2 && !strcasecmp(argv[1], "wipe")) {
-			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-				ret =3D cc->iv_gen_ops->wipe(cc);
-				if (ret)
-					return ret;
-			}
 			return crypt_wipe_key(cc);
 		}
 	}
@@ -2056,19 +2127,58 @@ static struct target_type crypt_target =3D {
 	.iterate_devices =3D crypt_iterate_devices,
 };
=20
+static int dm_crypt_pm_notifier_call(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct crypt_config *cc;
+	int r;
+
+	mutex_lock(&crypt_list_mtx);
+
+	list_for_each_entry(cc, &crypt_list, entry) {
+		if ((action =3D=3D PM_HIBERNATION_AFTER_FREEZE &&
+		     test_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags)) ||
+		    (action =3D=3D PM_SUSPEND_AFTER_FREEZE &&
+		     test_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags))) {
+			r =3D crypt_suspend_and_wipe_key(cc);
+			if (r) {
+				DMWARN("wiping key failed %d", r);
+			}
+		}
+	}
+
+	mutex_unlock(&crypt_list_mtx);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block dm_crypt_pm_notifier_block =3D {
+	.notifier_call =3D dm_crypt_pm_notifier_call,
+};
+
 static int __init dm_crypt_init(void)
 {
 	int r;
=20
 	r =3D dm_register_target(&crypt_target);
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
=20
-	return r;
+	r =3D register_pm_notifier(&dm_crypt_pm_notifier_block);
+	if (r) {
+		DMERR("register_pm_notifier failed %d", r);
+		dm_unregister_target(&crypt_target);
+		return r;
+	}
+
+	return 0;
 }
=20
 static void __exit dm_crypt_exit(void)
 {
+	unregister_pm_notifier(&dm_crypt_pm_notifier_block);
 	dm_unregister_target(&crypt_target);
 }
=20
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-pm" in
