From: Scotty <sbauer@eng.utah.edu>
Subject: [PATCH] dm ioctl: Access user-land memory through safe functions.
Date: Tue, 1 Dec 2015 11:11:04 -0700
Message-ID: <565DE2B8.7040709@eng.utah.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080605030004010507040202"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080605030004010507040202
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


--------------080605030004010507040202
Content-Type: text/x-patch;
 name="0001-dm-ioctl-Access-user-land-memory-through-safe-functi.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-dm-ioctl-Access-user-land-memory-through-safe-functi.pa";
 filename*1="tch"

=46rom b26adf880eba03ac6f2b1dd87426bb96fd2a0282 Mon Sep 17 00:00:00 2001
From: Scotty Bauer <sbauer@eng.utah.edu>
Date: Tue, 1 Dec 2015 10:52:46 -0700
Subject: [PATCH] dm ioctl: Access user-land memory through safe functions=
=2E

This patch fixes a user-land dereference. Now we use
the safe copy_from_user to access the memory.

Signed-off-by: Scotty Bauer <sbauer@eng.utah.edu>
---
 drivers/md/dm-ioctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 80a4395..39a9d1a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1642,9 +1642,13 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int=
 *ioctl_flags)
 static int check_version(unsigned int cmd, struct dm_ioctl __user *user)=

 {
 	uint32_t version[3];
+	uint32_t __user *version_ptr;
 	int r =3D 0;
=20
-	if (copy_from_user(version, user->version, sizeof(version)))
+	if (copy_from_user(&version_ptr, &user->version, sizeof(version_ptr)))
+		return -EFAULT;
+
+	if (copy_from_user(version, version_ptr, sizeof(version)))
 		return -EFAULT;
=20
 	if ((DM_VERSION_MAJOR !=3D version[0]) ||
@@ -1663,7 +1667,7 @@ static int check_version(unsigned int cmd, struct d=
m_ioctl __user *user)
 	version[0] =3D DM_VERSION_MAJOR;
 	version[1] =3D DM_VERSION_MINOR;
 	version[2] =3D DM_VERSION_PATCHLEVEL;
-	if (copy_to_user(user->version, version, sizeof(version)))
+	if (copy_to_user(version_ptr, version, sizeof(version)))
 		return -EFAULT;
=20
 	return r;
--=20
1.9.1


--------------080605030004010507040202--
