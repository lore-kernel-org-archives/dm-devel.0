From: Bastian Blank <bastian@waldi.eu.org>
Subject: [PATCH] libdevmapper - make device permissions
	overwritable
Date: Fri, 23 Dec 2005 23:00:57 +0100
Message-ID: <20051223220057.GA29576@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1007482516=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids


--===============1007482516==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Content-Disposition: inline


--rQ2U398070+RC21q
Content-Type: multipart/mixed; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair

The attached patch makes it possible to set the permissions for devices.

The deptree part only supports it for dm_tree_add_new_dev yet, as this
is the entrypoint which is used by lvm2.

Bastian

--=20
You canna change the laws of physics, Captain; I've got to have thirty minu=
tes!

--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=diff-lib
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D lib/.exported_symbols
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/.exported_symbols	(revision 206)
+++ lib/.exported_symbols	(local)
@@ -20,6 +20,9 @@
 dm_task_set_event_nr
 dm_task_set_major
 dm_task_set_minor
+_dm_task_set_uid
+_dm_task_set_gid
+_dm_task_set_mode
 dm_task_set_sector
 dm_task_set_message
 dm_task_suppress_identical_reload
@@ -36,6 +39,7 @@
 dm_tree_free
 dm_tree_add_dev
 dm_tree_add_new_dev
+_dm_tree_add_new_dev_mode
 dm_tree_node_get_name
 dm_tree_node_get_uuid
 dm_tree_node_get_info
=3D=3D=3D lib/ioctl/libdm-iface.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/ioctl/libdm-iface.c	(revision 206)
+++ lib/ioctl/libdm-iface.c	(local)
@@ -1310,6 +1310,9 @@
=20
 	task->major =3D dmt->major;
 	task->minor =3D dmt->minor;
+	task->uid =3D dmt->uid;
+	task->gid =3D dmt->gid;
+	task->mode =3D dmt->mode;
=20
 	r =3D dm_task_run(task);
 	dm_task_destroy(task);
=3D=3D=3D lib/libdevmapper.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/libdevmapper.h	(revision 206)
+++ lib/libdevmapper.h	(local)
@@ -143,6 +143,9 @@
 int dm_task_set_event_nr(struct dm_task *dmt, uint32_t event_nr);
 int dm_task_set_message(struct dm_task *dmt, const char *message);
 int dm_task_set_sector(struct dm_task *dmt, uint64_t sector);
+int _dm_task_set_uid(struct dm_task *dmt, uid_t uid);
+int _dm_task_set_gid(struct dm_task *dmt, gid_t gid);
+int _dm_task_set_mode(struct dm_task *dmt, mode_t mode);
 int dm_task_no_open_count(struct dm_task *dmt);
 int dm_task_skip_lockfs(struct dm_task *dmt);
 int dm_task_suppress_identical_reload(struct dm_task *dmt);
@@ -234,6 +237,15 @@
                                             int clear_inactive,
                                             void *context);
=20
+struct dm_tree_node *_dm_tree_add_new_dev_mode(struct dm_tree *tree,
+                                            const char *name,
+                                            const char *uuid,
+                                            uint32_t major, uint32_t minor,
+                                            uid_t uid, uid_t gid, mode_t m=
ode,
+                                            int read_only,
+                                            int clear_inactive,
+                                            void *context);
+
 /*
  * Search for a node in the tree.
  * Set major and minor to 0 or uuid to NULL to get the root node.
=3D=3D=3D lib/libdm-common.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/libdm-common.c	(revision 206)
+++ lib/libdm-common.c	(local)
@@ -180,6 +180,27 @@
 	return 1;
 }
=20
+int _dm_task_set_uid(struct dm_task *dmt, uid_t uid)
+{
+	dmt->uid =3D uid;
+
+	return 1;
+}
+
+int _dm_task_set_gid(struct dm_task *dmt, gid_t gid)
+{
+	dmt->gid =3D gid;
+
+	return 1;
+}
+
+int _dm_task_set_mode(struct dm_task *dmt, mode_t mode)
+{
+	dmt->mode =3D mode;
+
+	return 1;
+}
+
 int dm_task_add_target(struct dm_task *dmt, uint64_t start, uint64_t size,
 		       const char *ttype, const char *params)
 {
=3D=3D=3D lib/libdm-deptree.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- lib/libdm-deptree.c	(revision 206)
+++ lib/libdm-deptree.c	(local)
@@ -92,6 +92,9 @@
 	int read_only;
 	uint32_t major;
 	uint32_t minor;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
=20
 	unsigned segment_count;
 	struct list segs;
@@ -366,6 +369,7 @@
 }
=20
 static int _deps(struct dm_task **dmt, struct dm_pool *mem, uint32_t major=
, uint32_t minor,
+		 uid_t uid, gid_t gid, mode_t mode,
 		 const char **name, const char **uuid,
 		 struct dm_info *info, struct dm_deps **deps)
 {
@@ -401,6 +405,24 @@
 		goto failed;
 	}
=20
+	if (!_dm_task_set_uid(*dmt, uid)) {
+		log_error("_deps: failed to set uid for (%" PRIu32 ":%" PRIu32 ")",
+			  major, minor);
+		goto failed;
+	}
+
+	if (!_dm_task_set_gid(*dmt, gid)) {
+		log_error("_deps: failed to set gid for (%" PRIu32 ":%" PRIu32 ")",
+			  major, minor);
+		goto failed;
+	}
+
+	if (!_dm_task_set_mode(*dmt, mode)) {
+		log_error("_deps: failed to set mode for (%" PRIu32 ":%" PRIu32 ")",
+			  major, minor);
+		goto failed;
+	}
+
 	if (!dm_task_run(*dmt)) {
 		log_error("_deps: task run failed for (%" PRIu32 ":%" PRIu32 ")",
 			  major, minor);
@@ -448,7 +470,8 @@
=20
 static struct dm_tree_node *_add_dev(struct dm_tree *dtree,
 				     struct dm_tree_node *parent,
-				     uint32_t major, uint32_t minor)
+				     uint32_t major, uint32_t minor,
+				     uid_t uid, gid_t gid, mode_t mode)
 {
 	struct dm_task *dmt =3D NULL;
 	struct dm_info info;
@@ -461,7 +484,7 @@
=20
 	/* Already in tree? */
 	if (!(node =3D _find_dm_tree_node(dtree, major, minor))) {
-		if (!_deps(&dmt, dtree->mem, major, minor, &name, &uuid, &info, &deps))
+		if (!_deps(&dmt, dtree->mem, major, minor, uid, gid, mode, &name, &uuid,=
 &info, &deps))
 			return_NULL;
=20
 		if (!(node =3D _create_dm_tree_node(dtree, name, uuid,
@@ -491,7 +514,7 @@
 	/* Add dependencies to tree */
 	for (i =3D 0; i < deps->count; i++)
 		if (!_add_dev(dtree, node, MAJOR(deps->device[i]),
-			      MINOR(deps->device[i]))) {
+			      MINOR(deps->device[i]), uid, gid, mode)) {
 			node =3D NULL;
 			goto_out;
 		}
@@ -560,6 +583,18 @@
 					    int clear_inactive,
 					    void *context)
 {
+	return _dm_tree_add_new_dev_mode(dtree, name, uuid, major, minor, DEVICE_=
UID, DEVICE_GID, DEVICE_MODE, read_only, clear_inactive, context);
+}
+
+struct dm_tree_node *_dm_tree_add_new_dev_mode(struct dm_tree *dtree,
+					    const char *name,
+					    const char *uuid,
+					    uint32_t major, uint32_t minor,
+					    uid_t uid, gid_t gid, mode_t mode,
+					    int read_only,
+					    int clear_inactive,
+					    void *context)
+{
 	struct dm_tree_node *dnode;
 	struct dm_info info;
 	const char *name2;
@@ -593,6 +628,9 @@
=20
 		dnode->props.major =3D major;
 		dnode->props.minor =3D minor;
+                dnode->props.uid =3D uid;
+                dnode->props.gid =3D gid;
+                dnode->props.mode =3D mode;
 		dnode->props.new_name =3D NULL;
 	} else if (strcmp(name, dnode->name)) {
 		/* Do we need to rename node? */
@@ -614,7 +652,7 @@
=20
 int dm_tree_add_dev(struct dm_tree *dtree, uint32_t major, uint32_t minor)
 {
-	return _add_dev(dtree, &dtree->root, major, minor) ? 1 : 0;
+	return _add_dev(dtree, &dtree->root, major, minor, DEVICE_UID, DEVICE_GID=
, DEVICE_MODE) ? 1 : 0;
 }
=20
 const char *dm_tree_node_get_name(struct dm_tree_node *node)
@@ -1155,6 +1193,12 @@
 		goto out;
 	}
=20
+	if (!_dm_task_set_uid(dmt, dnode->props.uid) ||
+	    !_dm_task_set_gid(dmt, dnode->props.gid) ||
+	    !_dm_task_set_mode(dmt, dnode->props.mode)) {
+		log_error("Failed to set device permissions for %s creation.", dnode->na=
me);
+		goto out;
+	}
 	if (dnode->props.read_only && !dm_task_set_ro(dmt)) {
 		log_error("Failed to set read only flag for %s", dnode->name);
 		goto out;
@@ -1711,7 +1755,7 @@
 		}
=20
 		/* FIXME Check correct macro use */
-		if (!(dev_node =3D _add_dev(node->dtree, node, MAJOR(info.st_rdev), MINO=
R(info.st_rdev))))
+		if (!(dev_node =3D _add_dev(node->dtree, node, MAJOR(info.st_rdev), MINO=
R(info.st_rdev), DEVICE_UID, DEVICE_GID, DEVICE_MODE)))
 			return_0;
 	}
=20

--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename=diff-dmsetup
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D dmsetup/dmsetup.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- dmsetup/dmsetup.c	(revision 206)
+++ dmsetup/dmsetup.c	(local)
@@ -88,6 +88,9 @@
 	EXEC_ARG,
 	MAJOR_ARG,
 	MINOR_ARG,
+	UID_ARG,
+	GID_ARG,
+	MODE_ARG,
 	NOHEADINGS_ARG,
 	NOLOCKFS_ARG,
 	NOOPENCOUNT_ARG,
@@ -390,6 +393,15 @@
 	if (_switches[MINOR_ARG] && !dm_task_set_minor(dmt, _values[MINOR_ARG]))
 		goto out;
=20
+	if (_switches[UID_ARG] && !_dm_task_set_uid(dmt, _values[UID_ARG]))
+		goto out;
+
+	if (_switches[GID_ARG] && !_dm_task_set_gid(dmt, _values[GID_ARG]))
+		goto out;
+
+	if (_switches[MODE_ARG] && !_dm_task_set_mode(dmt, _values[MODE_ARG]))
+		goto out;
+
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
=20
@@ -1292,7 +1304,8 @@
=20
 static struct command _commands[] =3D {
 	{"create", "<dev_name> [-j|--major <major> -m|--minor <minor>]\n"
-	  "\t                  [-u|uuid <uuid>] [--notable] [<table_file>]",
+	  "\t                  [-u|uuid <uuid>] [-U|--uid <uid>] [-G|--gid <gid>]=
\n"
+	  "\t                  [-M|--mode <mode>] [--notable] [<table_file>]",
 	 1, 2, _create},
 	{"remove", "<device>", 0, 1, _remove},
 	{"remove_all", "", 0, 0, _remove_all},
@@ -1420,6 +1433,9 @@
 		{"exec", 1, &ind, EXEC_ARG},
 		{"major", 1, &ind, MAJOR_ARG},
 		{"minor", 1, &ind, MINOR_ARG},
+		{"uid", 1, &ind, UID_ARG},
+		{"gid", 1, &ind, GID_ARG},
+		{"mode", 1, &ind, MODE_ARG},
 		{"noheadings", 0, &ind, NOHEADINGS_ARG},
 		{"nolockfs", 0, &ind, NOLOCKFS_ARG},
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
@@ -1478,10 +1494,14 @@
=20
 	optarg =3D 0;
 	optind =3D OPTIND_INIT;
-	while ((ind =3D -1, c =3D GETOPTLONG_FN(*argc, *argv, "cCj:m:no:ru:v",
+	while ((ind =3D -1, c =3D GETOPTLONG_FN(*argc, *argv, "cCj:G:m:M:no:ru:U:=
v",
 					    long_options, NULL)) !=3D -1) {
 		if (c =3D=3D 'c' || c =3D=3D 'C' || ind =3D=3D COLS_ARG)
 			_switches[COLS_ARG]++;
+		if (c =3D=3D 'G' || ind =3D=3D GID_ARG) {
+			_switches[GID_ARG]++;
+			_values[GID_ARG] =3D strtol(optarg, NULL, 10);
+		}
 		if (c =3D=3D 'r' || ind =3D=3D READ_ONLY)
 			_switches[READ_ONLY]++;
 		if (c =3D=3D 'j' || ind =3D=3D MAJOR_ARG) {
@@ -1492,6 +1512,10 @@
 			_switches[MINOR_ARG]++;
 			_values[MINOR_ARG] =3D atoi(optarg);
 		}
+		if (c =3D=3D 'M' || ind =3D=3D MODE_ARG) {
+			_switches[MODE_ARG]++;
+			_values[MODE_ARG] =3D strtol(optarg, NULL, 8);
+		}
 		if (c =3D=3D 'n' || ind =3D=3D NOTABLE_ARG)
 			_switches[NOTABLE_ARG]++;
 		if (c =3D=3D 'o' || ind =3D=3D OPTIONS_ARG) {
@@ -1504,6 +1528,10 @@
 			_switches[UUID_ARG]++;
 			_uuid =3D optarg;
 		}
+		if (c =3D=3D 'U' || ind =3D=3D UID_ARG) {
+			_switches[UID_ARG]++;
+			_values[UID_ARG] =3D strtol(optarg, NULL, 10);
+		}
 		if ((ind =3D=3D EXEC_ARG)) {
 			_switches[EXEC_ARG]++;
 			_command =3D optarg;

--zx4FCpZtqtKETZ7O--

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iEYEARECAAYFAkOsc5kACgkQnw66O/MvCNEdBQCfTiKdEkRWcW3lgCux3c9/MEeK
PNgAoJ5iGOc8+bnypM9zDjarf7f8jzxW
=9cqG
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--


--===============1007482516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1007482516==--
