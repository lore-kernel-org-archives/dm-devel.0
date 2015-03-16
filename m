From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 57/78] multipath: enable sync support
Date: Mon, 16 Mar 2015 13:36:44 +0100
Message-ID: <1426509425-15978-58-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

multipath didn't enable 'sync support' for device-mapper,
causing device-mapper to create the device nodes internally
rather than relying on udev here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipath/main.c b/multipath/main.c
index ebca4dc..bee9a65 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -582,6 +582,7 @@ main (int argc, char *argv[])
 	if (dm_prereq())
 		exit(1);
 	dm_drv_version(conf->version, TGT_MPATH);
+	udev_set_sync_support(1);
 
 	if (optind < argc) {
 		conf->dev = MALLOC(FILE_NAME_SIZE);
-- 
1.8.4.5
