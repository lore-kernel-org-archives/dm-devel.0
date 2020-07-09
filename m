From: mwilck@suse.com
Subject: [PATCH 24/35] libmultipath: pathinfo(): improve a log
	message
Date: Thu,  9 Jul 2020 12:16:09 +0200
Message-ID: <20200709101620.6786-25-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

"node" is too generic to be understood without checking the code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c692026..2e559d8 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2124,7 +2124,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		pp->fd = open(udev_device_get_devnode(pp->udev), O_RDONLY);
 
 	if (pp->fd < 0) {
-		condlog(4, "Couldn't open node for %s: %s",
+		condlog(4, "Couldn't open device node for %s: %s",
 			pp->dev, strerror(errno));
 		goto blank;
 	}
-- 
2.26.2
