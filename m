From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] libmultipath: get_udev_uid: make sure
	pp->wwid is 0-terminated
Date: Fri, 14 Jul 2017 13:32:06 +0200
Message-ID: <20170714113209.17177-2-mwilck@suse.com>
References: <20170714113209.17177-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170714113209.17177-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, tang.junhui@zte.com.cn, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

If the first WWID_LEN bytes of the uuid_attribute do not contain
a 0 byte, pp->wwid may end up not properly terminated. Fix it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 663c8eaa..9951af84 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1615,6 +1615,7 @@ get_udev_uid(struct path * pp, char *uid_attribute, struct udev_device *udev)
 			len = strlen(value);
 		}
 		strncpy(pp->wwid, value, len);
+		pp->wwid[WWID_SIZE - 1] = '\0';
 	} else {
 		condlog(3, "%s: no %s attribute", pp->dev,
 			uid_attribute);
-- 
2.13.2
