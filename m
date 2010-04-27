From: akpm@linux-foundation.org
Subject: [patch 1/1] dm_ioctl: use nonseekable_open
Date: Tue, 27 Apr 2010 14:10:15 -0700
Message-ID: <201004272110.o3RLAGlh019922@imap1.linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: fweisbec@gmail.com, dm-devel@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, arnd@relay.de.ibm.com
List-Id: dm-devel.ids

From: Arnd Bergmann <arnd@relay.de.ibm.com>

The dm control device does not implement read/write, so it has no use for
seeking.  Using no_llseek prevents falling back to default_llseek, which
requires the BKL.

[fweisbec@gmail.com: drop useless llseek = no_llseek]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/md/dm-ioctl.c~dm_ioctl-use-nonseekable_open drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm_ioctl-use-nonseekable_open
+++ a/drivers/md/dm-ioctl.c
@@ -1593,6 +1593,7 @@ static long dm_compat_ctl_ioctl(struct f
 #endif
 
 static const struct file_operations _ctl_fops = {
+	.open = nonseekable_open,
 	.unlocked_ioctl	 = dm_ctl_ioctl,
 	.compat_ioctl = dm_compat_ctl_ioctl,
 	.owner	 = THIS_MODULE,
_
