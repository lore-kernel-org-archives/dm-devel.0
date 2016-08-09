From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] libmultipath/discovery.c: use 'unsigned
	long' instead of 'unsigned int'
Date: Tue,  9 Aug 2016 09:31:11 +0200
Message-ID: <1470727873-10502-2-git-send-email-hare@suse.de>
References: <1470727873-10502-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470727873-10502-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

We should be using 'unsigned long' for the variable preferred.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1fb4db4..38ab038 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -491,7 +491,7 @@ sysfs_get_asymmetric_access_state(struct path *pp, char *buff, int buflen)
 {
 	struct udev_device *parent = pp->udev;
 	char value[16], *eptr;
-	unsigned int preferred;
+	unsigned long preferred;
 
 	while (parent) {
 		const char *subsys = udev_device_get_subsystem(parent);
-- 
2.6.6
