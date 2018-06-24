From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 07/10] (lib)mpathpersist: use O_RDONLY file
	descriptors
Date: Sun, 24 Jun 2018 21:09:41 +0200
Message-ID: <20180624190944.27158-8-mwilck@suse.com>
References: <20180624190944.27158-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180624190944.27158-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

udevd catches close-after-write inotify events and generates "change"
uvents for such devices, which may cause extra unnecessary and unwanted
udev activity.

Therefore use O_RDONLY file descriptors for PRIN and PROUT commands. This
works just as well as O_WRONLY. sg_persist has supported the --readonly option
for years.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 4 ++--
 mpathpersist/main.c              | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 8416a3bf..a222b1e1 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -52,7 +52,7 @@ int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
 	int fd = -1;
 
 	snprintf(devname, FILE_NAME_SIZE, "/dev/%s",dev);
-	fd = open(devname, O_WRONLY);
+	fd = open(devname, O_RDONLY);
 	if(fd < 0){
 		condlog (1, "%s: unable to open device.", dev);
 		return MPATH_PR_FILE_ERROR;
@@ -308,7 +308,7 @@ int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int
 	{MPATH_PRIN_CMD, 0, 0, 0, 0, 0, 0, 0, 0, 0};
 
 	snprintf(devname, FILE_NAME_SIZE, "/dev/%s",dev);
-	fd = open(devname, O_WRONLY);
+	fd = open(devname, O_RDONLY);
 	if(fd < 0){
 		condlog(0, "%s: Unable to open device ", dev);
 		return MPATH_PR_FILE_ERROR;
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 5b37f3ae..34caa16c 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -380,7 +380,7 @@ int main (int argc, char * argv[])
 	}
 
 	/* open device */
-	if ((fd = open (device_name, O_WRONLY)) < 0)
+	if ((fd = open (device_name, O_RDONLY)) < 0)
 	{
 		fprintf (stderr, "%s: error opening file (rw) fd=%d\n",
 				device_name, fd);
-- 
2.17.1
