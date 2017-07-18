From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/4] libmultipath: get_udev_uid: make sure
	pp->wwid is 0-terminated
Date: Tue, 18 Jul 2017 09:29:13 +0200
Message-ID: <20170718072916.24275-2-mwilck@suse.com>
References: <20170718072916.24275-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170718072916.24275-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, linux-nvme@lists.infradead.org, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

If the first WWID_LEN bytes of the uuid_attribute do not contain
a 0 byte, pp->wwid may end up not properly terminated. Fix it by
using strlcpy() rather than strncpy().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Benjamin Marzinski <bmarzins@redhat.com>

---
 libmultipath/discovery.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 663c8eaa..419a148b 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1608,13 +1608,11 @@ get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
 	if (!value || strlen(value) == 0)
 		value = getenv(uid_attribute);
 	if (value && strlen(value)) {
-		if (strlen(value) + 1 > WWID_SIZE) {
+		len = strlcpy(pp->wwid, value, WWID_SIZE);
+		if (len >= WWID_SIZE) {
 			condlog(0, "%s: wwid overflow", pp->dev);
 			len = WWID_SIZE;
-		} else {
-			len = strlen(value);
 		}
-		strncpy(pp->wwid, value, len);
 	} else {
 		condlog(3, "%s: no %s attribute", pp->dev,
 			uid_attribute);
-- 
2.13.2
