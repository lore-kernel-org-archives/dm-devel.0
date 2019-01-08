From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/12] libmultipath(coverity): make sure readlink
	result is 0-terminated
Date: Tue,  8 Jan 2019 23:54:01 +0100
Message-ID: <20190108225409.15977-5-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Coverity warned that readlink() results aren't necessarily 0-terminated.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 944c632..5b838d5 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -176,6 +176,7 @@ int devt2devname(char *devname, int devname_len, char *devt)
 	if (stat("/sys/dev/block", &statbuf) == 0) {
 		/* Newer kernels have /sys/dev/block */
 		sprintf(block_path,"/sys/dev/block/%u:%u", major, minor);
+		dev[FILE_NAME_SIZE - 1] = '\0';
 		if (lstat(block_path, &statbuf) == 0) {
 			if (S_ISLNK(statbuf.st_mode) &&
 			    readlink(block_path, dev, FILE_NAME_SIZE-1) > 0) {
-- 
2.19.2
