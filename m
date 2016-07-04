From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/26] libmultipath: fallback to checking
	environment variable in get_udev_uid()
Date: Mon,  4 Jul 2016 09:08:30 +0200
Message-ID: <1467616126-10036-11-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

If we cannot get the udev attribute via udev we should always fallback
to checking the environment variable; there is no need to restrict
it to a specific command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6fc2e8f..019faef 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1479,7 +1479,7 @@ get_udev_uid(struct path * pp, char *uid_attribute)
 
 	value = udev_device_get_property_value(pp->udev,
 					       uid_attribute);
-	if ((!value || strlen(value) == 0) && conf->cmd == CMD_VALID_PATH)
+	if (!value || strlen(value) == 0)
 		value = getenv(uid_attribute);
 	if (value && strlen(value)) {
 		if (strlen(value) + 1 > WWID_SIZE) {
-- 
2.6.6
