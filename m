From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/39] kpartx: Memory leak in get_hotplug_device()
Date: Thu, 16 Jun 2016 11:47:31 +0200
Message-ID: <1466070465-1021-26-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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

We allocate a string for 'device', but never free it on error.
And the string 'mapname' is never freed at all.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/kpartx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index e8c35d4..e1ebc96 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -178,16 +178,21 @@ get_hotplug_device(void)
 	len = strlen(mapname);
 
 	/* Dirname + mapname + \0 */
-	if (!(device = (char *)malloc(sizeof(char) * (off + len + 1))))
+	if (!(device = (char *)malloc(sizeof(char) * (off + len + 1)))) {
+		free(mapname);
 		return NULL;
+	}
 
 	/* Create new device name. */
 	snprintf(device, off + 1, "%s", devname);
 	snprintf(device + off, len + 1, "%s", mapname);
 
-	if (strlen(device) != (off + len))
+	if (strlen(device) != (off + len)) {
+		free(device);
+		free(mapname);
 		return NULL;
-
+	}
+	free(mapname);
 	return device;
 }
 
-- 
2.6.6
