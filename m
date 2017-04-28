From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Create: tell udev md device is not ready when first created.
Date: Fri, 28 Apr 2017 15:05:50 +1000
Message-ID: <87h919ruj5.fsf@notabene.neil.brown.name>
References: <149265560315.31004.3851231165281498425.stgit@noble> <149265600601.31004.323865505557190368.stgit@noble> <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com> <87mvbasqx6.fsf@notabene.neil.brown.name> <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Peter Rajnoha <prajnoha@redhat.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


When an array is created the content is not initialized,
so it could have remnants of an old filesystem or md array
etc on it.
udev will see this and might try to activate it, which is almost
certainly not what is wanted.

So create a mechanism for mdadm to communicate with udev to tell
it that the device isn't ready.  This mechanism is the existance
of a file /run/mdadm/created-mdXXX where mdXXX is the md device name.

When creating an array, mdadm will create the file.
A new udev rule file, 01-md-raid-creating.rules, will detect the
precense of thst file and set ENV{SYSTEMD_READY}=3D"0".
This is fairly uniformly used to suppress actions based on the
contents of the device.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 Assemble.c                  |  2 +-
 Build.c                     |  2 +-
 Create.c                    |  9 +++++++-
 Incremental.c               |  4 ++--
 Makefile                    |  4 ++--
 lib.c                       | 29 +++++++++++++++++++++++++
 mdadm.h                     |  4 +++-
 mdopen.c                    | 52 ++++++++++++++++++++++++++++-------------=
----
 udev-md-raid-creating.rules |  7 ++++++
 9 files changed, 86 insertions(+), 27 deletions(-)
 create mode 100644 udev-md-raid-creating.rules

diff --git a/Assemble.c b/Assemble.c
index d6beb23da9c5..a9442c8ce73b 100644
=2D-- a/Assemble.c
+++ b/Assemble.c
@@ -1478,7 +1478,7 @@ try_again:
 			name =3D strchr(name, ':')+1;
=20
 		mdfd =3D create_mddev(mddev, name, ident->autof, trustworthy,
=2D				    chosen_name);
+				    chosen_name, 0);
 	}
 	if (mdfd < 0) {
 		st->ss->free_super(st);
diff --git a/Build.c b/Build.c
index 11ba12f4ae7d..665d9067b8d6 100644
=2D-- a/Build.c
+++ b/Build.c
@@ -109,7 +109,7 @@ int Build(char *mddev, struct mddev_dev *devlist,
 	/* We need to create the device.  It can have no name. */
 	map_lock(&map);
 	mdfd =3D create_mddev(mddev, NULL, c->autof, LOCAL,
=2D			    chosen_name);
+			    chosen_name, 0);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
diff --git a/Create.c b/Create.c
index 6ca092449880..df1bc20c635b 100644
=2D-- a/Create.c
+++ b/Create.c
@@ -605,7 +605,7 @@ int Create(struct supertype *st, char *mddev,
=20
 	/* We need to create the device */
 	map_lock(&map);
=2D	mdfd =3D create_mddev(mddev, name, c->autof, LOCAL, chosen_name);
+	mdfd =3D create_mddev(mddev, name, c->autof, LOCAL, chosen_name, 1);
 	if (mdfd < 0) {
 		map_unlock(&map);
 		return 1;
@@ -620,6 +620,7 @@ int Create(struct supertype *st, char *mddev,
 			chosen_name);
 		close(mdfd);
 		map_unlock(&map);
+		udev_unblock();
 		return 1;
 	}
 	mddev =3D chosen_name;
@@ -1053,9 +1054,15 @@ int Create(struct supertype *st, char *mddev,
 		pr_err("not starting array - not enough devices.\n");
 	}
 	close(mdfd);
+	/* Give udev a moment to process the Change event caused
+	 * by the close.
+	 */
+	usleep(100*1000);
+	udev_unblock();
 	return 0;
=20
  abort:
+	udev_unblock();
 	map_lock(&map);
  abort_locked:
 	map_remove(&map, fd2devnm(mdfd));
diff --git a/Incremental.c b/Incremental.c
index 28f1f7734956..63ed4fa1a88d 100644
=2D-- a/Incremental.c
+++ b/Incremental.c
@@ -321,7 +321,7 @@ int Incremental(struct mddev_dev *devlist, struct conte=
xt *c,
=20
 		/* Couldn't find an existing array, maybe make a new one */
 		mdfd =3D create_mddev(match ? match->devname : NULL,
=2D				    name_to_use, c->autof, trustworthy, chosen_name);
+				    name_to_use, c->autof, trustworthy, chosen_name, 0);
=20
 		if (mdfd < 0)
 			goto out_unlock;
@@ -1605,7 +1605,7 @@ static int Incremental_container(struct supertype *st=
, char *devname,
 					    ra->name,
 					    c->autof,
 					    trustworthy,
=2D					    chosen_name);
+					    chosen_name, 0);
 		}
 		if (only && (!mp || strcmp(mp->devnm, only) !=3D 0))
 			continue;
diff --git a/Makefile b/Makefile
index 685069612617..021d3adf3ed1 100644
=2D-- a/Makefile
+++ b/Makefile
@@ -256,8 +256,8 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
 	$(INSTALL) -D -m 644 md.4 $(DESTDIR)$(MAN4DIR)/md.4
 	$(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
=20
=2Dinstall-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules
=2D	@for file in 63-md-raid-arrays.rules 64-md-raid-assembly.rules ; \
+install-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules udev-m=
d-raid-creating.rules
+	@for file in 01-md-raid-creating.rules 63-md-raid-arrays.rules 64-md-raid=
-assembly.rules ; \
 	do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file#??-} > .install.tmp.1 && \
 	   $(ECHO) $(INSTALL) -D -m 644 udev-$${file#??-} $(DESTDIR)$(UDEVDIR)/ru=
les.d/$$file ; \
 	   $(INSTALL) -D -m 644 .install.tmp.1 $(DESTDIR)$(UDEVDIR)/rules.d/$$fil=
e ; \
diff --git a/lib.c b/lib.c
index b640634ef6f2..7e44b1f27fcc 100644
=2D-- a/lib.c
+++ b/lib.c
@@ -163,6 +163,35 @@ char *fd2devnm(int fd)
 	return NULL;
 }
=20
+/* When we create a new array, we don't want the content to
+ * be immediately examined by udev - it is probably meaningless.
+ * So create /run/mdadm/creating-FOO and expect that a udev
+ * rule will noticed this and act accordingly.
+ */
+static char block_path[] =3D "/run/mdadm/creating-%s";
+static char *unblock_path =3D NULL;
+void udev_block(char *devnm)
+{
+	int fd;
+	char *path =3D NULL;
+
+	xasprintf(&path, block_path, devnm);
+	fd =3D open(path, O_CREAT|O_RDWR, 0600);
+	if (fd >=3D 0) {
+		close(fd);
+		unblock_path =3D path;
+	} else
+		free(path);
+}
+
+void udev_unblock(void)
+{
+	if (unblock_path)
+		unlink(unblock_path);
+	free(unblock_path);
+	unblock_path =3D NULL;
+}
+
 /*
  * convert a major/minor pair for a block device into a name in /dev, if p=
ossible.
  * On the first call, walk /dev collecting name.
diff --git a/mdadm.h b/mdadm.h
index 1bbacfe9e916..6a382a7c1b90 100644
=2D-- a/mdadm.h
+++ b/mdadm.h
@@ -1533,7 +1533,7 @@ extern char *get_md_name(char *devnm);
 extern char DefaultConfFile[];
=20
 extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
=2D			char *chosen);
+			char *chosen, int block_udev);
 /* values for 'trustworthy' */
 #define	LOCAL	1
 #define	LOCAL_ANY 10
@@ -1567,6 +1567,8 @@ extern char *stat2kname(struct stat *st);
 extern char *fd2kname(int fd);
 extern char *stat2devnm(struct stat *st);
 extern char *fd2devnm(int fd);
+extern void udev_block(char *devnm);
+extern void udev_unblock(void);
=20
 extern int in_initrd(void);
=20
diff --git a/mdopen.c b/mdopen.c
index 82b97fc90339..099efa0aa2e5 100644
=2D-- a/mdopen.c
+++ b/mdopen.c
@@ -135,7 +135,7 @@ void make_parts(char *dev, int cnt)
  */
=20
 int create_mddev(char *dev, char *name, int autof, int trustworthy,
=2D		 char *chosen)
+		 char *chosen, int block_udev)
 {
 	int mdfd;
 	struct stat stb;
@@ -147,6 +147,10 @@ int create_mddev(char *dev, char *name, int autof, int=
 trustworthy,
 	char devname[37];
 	char devnm[32];
 	char cbuf[400];
+
+	if (!use_udev())
+		block_udev =3D 0;
+
 	if (chosen =3D=3D NULL)
 		chosen =3D cbuf;
=20
@@ -305,43 +309,53 @@ int create_mddev(char *dev, char *name, int autof, in=
t trustworthy,
 		int fd;
 		int n =3D -1;
 		sprintf(devnm, "md_%s", cname);
+		if (block_udev)
+			udev_block(devnm);
 		fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
 		if (fd >=3D 0) {
 			n =3D write(fd, devnm, strlen(devnm));
 			close(fd);
 		}
=2D		if (n < 0)
+		if (n < 0) {
 			devnm[0] =3D 0;
+			udev_unblock();
+		}
 	}
 	if (num >=3D 0) {
 		int fd;
 		int n =3D -1;
 		sprintf(devnm, "md%d", num);
+		if (block_udev)
+			udev_block(devnm);
 		fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
 		if (fd >=3D 0) {
 			n =3D write(fd, devnm, strlen(devnm));
 			close(fd);
 		}
=2D		if (n < 0)
+		if (n < 0) {
 			devnm[0] =3D 0;
=2D	}
=2D	if (devnm[0])
=2D		;
=2D	else if (num < 0) {
=2D		/* need to choose a free number. */
=2D		char *_devnm =3D find_free_devnm(use_mdp);
=2D		if (_devnm =3D=3D NULL) {
=2D			pr_err("No avail md devices - aborting\n");
=2D			return -1;
+			udev_unblock();
 		}
=2D		strcpy(devnm, _devnm);
=2D	} else {
=2D		sprintf(devnm, "%s%d", use_mdp?"md_d":"md", num);
=2D		if (mddev_busy(devnm)) {
=2D			pr_err("%s is already in use.\n",
=2D				dev);
=2D			return -1;
+	}
+	if (devnm[0] =3D=3D 0) {
+		if (num < 0) {
+			/* need to choose a free number. */
+			char *_devnm =3D find_free_devnm(use_mdp);
+			if (_devnm =3D=3D NULL) {
+				pr_err("No avail md devices - aborting\n");
+				return -1;
+			}
+			strcpy(devnm, _devnm);
+		} else {
+			sprintf(devnm, "%s%d", use_mdp?"md_d":"md", num);
+			if (mddev_busy(devnm)) {
+				pr_err("%s is already in use.\n",
+				       dev);
+				return -1;
+			}
 		}
+		if (block_udev)
+			udev_block(devnm);
 	}
=20
 	sprintf(devname, "/dev/%s", devnm);
diff --git a/udev-md-raid-creating.rules b/udev-md-raid-creating.rules
new file mode 100644
index 000000000000..2be466bcefd2
=2D-- /dev/null
+++ b/udev-md-raid-creating.rules
@@ -0,0 +1,7 @@
+# do not edit this file, it will be overwritten on update
+# While mdadm is creating an array, it creates a file
+# /run/mdadm/creating-mdXXX.  If that file exists, then
+# the array is not "ready" and we should make sure the
+# content is ignored.
+
+KERNEL=3D=3D"md*", TEST=3D"/run/mdadm/creating-$kernel", ENV{SYSTEMD_READY=
}=3D"0"
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkCza4ACgkQOeye3VZi
gbk6AhAAknQVgAspjboTumfi9gnb7FrAFUXrbCnmayiA9k6U3ZsDyD5/G/QEZrZz
8cnKsgyKJv8oC6ayBOLdkiB6cr4NDGnDa/Ib7ocxLgqb+KsPz8qlqF1tL3nGljEu
Ou3CKh6DFLQah9Ioq2/h+pb4D+4XcZSvZOmfAuyfFfHjDYtS66gAOwaEu9DZ4Xfk
fvCyBiybnjECa3rcPDehlTDv0ddDjzmyeATuirvN73/wrPb3kOcBQ+9h5mDjTgth
2B/lJT7vgTZPlM8xAVfkmRqGFO38yC5QQwyBc6fDlXLAv264EilmmVYQpWdBZFY4
h5S5IIdwFwDMrzcDLxD5w4GqBsGZUgb36W9KHBPIGa3DnaC8IhHr8P7O4JARTqXt
Bk6WU7lwt3d2qrnifx+zAgChiXCuDl9qrGGquw/ob1pgkOZ/SevAkaphUhiK6qOs
BLl4tMnk24xSgbY5lEi8WNo6eTqxLh2bo7NLowVLzpwtAxY3+UO81nIFeOfM49mG
BcrZGq9SEGXtEsfAMuiNo6cYlKfX9STByoQOsay89oc5+uFCPZvcpuuKFfAI//VJ
rXTLPk+2eG8OsJ7YqSBDAgy4gAUKKzJLnB3tbQhkk42kjDWIudy68oFL4ikmd1JJ
mRSWFJkjTYRGt1p0irJotHMCEtPIr7YaPU/GgCQj5vyx9BEyyhg=
=lxVo
-----END PGP SIGNATURE-----
--=-=-=--
