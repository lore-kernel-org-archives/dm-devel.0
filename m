From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 1/5] multipathd: move set_no_path_retry() back
 to libmultipath
Date: Wed, 20 Nov 2019 12:55:01 +0000
Message-ID: <20191120125437.19372-2-martin.wilck@suse.com>
References: <20191120125437.19372-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191120125437.19372-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This function is useful elsewhere, too. No code changes except
for changing the linkage.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 30 ++++++++++++++++++++++++++++++
 libmultipath/structs_vec.h |  1 +
 multipathd/main.c          | 30 ------------------------------
 3 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 6991f9ac..fbe97662 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -308,6 +308,36 @@ void enter_recovery_mode(struct multipath *mpp)
 =09=09mpp->alias, mpp->no_path_retry);
 }
=20
+void set_no_path_retry(struct multipath *mpp)
+{
+=09char is_queueing =3D 0;
+
+=09mpp->nr_active =3D pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST)=
;
+=09if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
+=09=09is_queueing =3D 1;
+
+=09switch (mpp->no_path_retry) {
+=09case NO_PATH_RETRY_UNDEF:
+=09=09break;
+=09case NO_PATH_RETRY_FAIL:
+=09=09if (is_queueing)
+=09=09=09dm_queue_if_no_path(mpp->alias, 0);
+=09=09break;
+=09case NO_PATH_RETRY_QUEUE:
+=09=09if (!is_queueing)
+=09=09=09dm_queue_if_no_path(mpp->alias, 1);
+=09=09break;
+=09default:
+=09=09if (mpp->nr_active > 0) {
+=09=09=09mpp->retry_tick =3D 0;
+=09=09=09if (!is_queueing)
+=09=09=09=09dm_queue_if_no_path(mpp->alias, 1);
+=09=09} else if (is_queueing && mpp->retry_tick =3D=3D 0)
+=09=09=09enter_recovery_mode(mpp);
+=09=09break;
+=09}
+}
+
 void
 sync_map_state(struct multipath *mpp)
 {
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index f8b9f63e..d3219278 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -11,6 +11,7 @@ struct vectors {
 =09vector mpvec;
 };
=20
+void set_no_path_retry(struct multipath *mpp);
 void enter_recovery_mode(struct multipath *mpp);
=20
 int adopt_paths (vector pathvec, struct multipath * mpp);
diff --git a/multipathd/main.c b/multipathd/main.c
index bb5c1f1d..a21d96e4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -409,36 +409,6 @@ set_multipath_wwid (struct multipath * mpp)
 =09dm_get_uuid(mpp->alias, mpp->wwid, WWID_SIZE);
 }
=20
-static void set_no_path_retry(struct multipath *mpp)
-{
-=09char is_queueing =3D 0;
-
-=09mpp->nr_active =3D pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOST)=
;
-=09if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
-=09=09is_queueing =3D 1;
-
-=09switch (mpp->no_path_retry) {
-=09case NO_PATH_RETRY_UNDEF:
-=09=09break;
-=09case NO_PATH_RETRY_FAIL:
-=09=09if (is_queueing)
-=09=09=09dm_queue_if_no_path(mpp->alias, 0);
-=09=09break;
-=09case NO_PATH_RETRY_QUEUE:
-=09=09if (!is_queueing)
-=09=09=09dm_queue_if_no_path(mpp->alias, 1);
-=09=09break;
-=09default:
-=09=09if (mpp->nr_active > 0) {
-=09=09=09mpp->retry_tick =3D 0;
-=09=09=09if (!is_queueing)
-=09=09=09=09dm_queue_if_no_path(mpp->alias, 1);
-=09=09} else if (is_queueing && mpp->retry_tick =3D=3D 0)
-=09=09=09enter_recovery_mode(mpp);
-=09=09break;
-=09}
-}
-
 int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
 =09=09      int reset)
 {
--=20
2.24.0
