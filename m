From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/39] kpartx: do not use 'const' for mapname in
	get_hotplug_device()
Date: Thu, 16 Jun 2016 11:47:33 +0200
Message-ID: <1466070465-1021-28-git-send-email-hare@suse.de>
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

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/kpartx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index e1ebc96..4de13fa 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -150,7 +150,7 @@ static char *
 get_hotplug_device(void)
 {
 	unsigned int major, minor, off, len;
-	const char *mapname;
+	char *mapname;
 	char *devname = NULL;
 	char *device = NULL;
 	char *var = NULL;
-- 
2.6.6
