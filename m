From: Satyam Sharma <satyam@infradead.org>
Subject: [PATCH -mm] drivers/md/: Shut up uninitialized variable
	warnings
Date: Mon, 3 Sep 2007 01:52:21 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0709030151320.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-440205242-1188764544=:29617"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-440205242-1188764544=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/md/dm-exception-store.c: In function ‘persistent_read_metadata’:
drivers/md/dm-exception-store.c:452: warning: ‘new_snapshot’ may be used uninitialized in this function

drivers/md/dm-ioctl.c: In function ‘ctl_ioctl’:
drivers/md/dm-ioctl.c:1407: warning: ‘param’ may be used uninitialized in this function

[ For these, I'd like to especially add -- shame on you, gcc! ]

drivers/md/dm-table.c: In function ‘dm_get_device’:
drivers/md/dm-table.c:472: warning: ‘dev’ may be used uninitialized in this function

are all verified to be bogus warnings. Let's shut them up.

---

 drivers/md/dm-exception-store.c |    3 ++-
 drivers/md/dm-ioctl.c |    2 +-
 drivers/md/dm-table.c |    2 +-
 3 file changed, 4 insertions(+), 3 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/md/dm-exception-store.c~fix	2007-09-03 01:05:12.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/md/dm-exception-store.c	2007-09-03 01:11:37.000000000 +0530
@@ -449,7 +449,8 @@ static void persistent_destroy(struct ex
 
 static int persistent_read_metadata(struct exception_store *store)
 {
-	int r, new_snapshot;
+	int r;
+	int uninitialized_var(new_snapshot);
 	struct pstore *ps = get_info(store);
 
 	/*
--- linux-2.6.23-rc4-mm1/drivers/md/dm-ioctl.c~fix	2007-09-03 01:04:58.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/md/dm-ioctl.c	2007-09-03 01:07:04.000000000 +0530
@@ -1404,7 +1404,7 @@ static int ctl_ioctl(struct inode *inode
 {
 	int r = 0;
 	unsigned int cmd;
-	struct dm_ioctl *param;
+	struct dm_ioctl * uninitialized_var(param);
 	struct dm_ioctl __user *user = (struct dm_ioctl __user *) u;
 	ioctl_fn fn = NULL;
 	size_t param_size;
--- linux-2.6.23-rc4-mm1/drivers/md/dm-table.c~fix	2007-09-03 00:56:05.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/md/dm-table.c	2007-09-03 00:57:15.000000000 +0530
@@ -469,7 +469,7 @@ static int __table_get_device(struct dm_
 			      int mode, struct dm_dev **result)
 {
 	int r;
-	dev_t dev;
+	dev_t uninitialized_var(dev);
 	struct dm_dev *dd;
 	unsigned int major, minor;
 
--464262402-440205242-1188764544=:29617
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--464262402-440205242-1188764544=:29617--
