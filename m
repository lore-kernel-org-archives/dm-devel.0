From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/11] multipathd: Correctly initialize udev
	context
Date: Fri, 13 Dec 2013 13:14:12 +0100
Message-ID: <1386936854-8399-10-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

The udev context is passed as argument to ueventloop(), so
we should be using that instead of the global variable.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 1a1aa2d..7058147 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -836,6 +836,8 @@ out:
 static void *
 ueventloop (void * ap)
 {
+	struct udev *udev = ap;
+
 	if (uevent_listen(udev))
 		condlog(0, "error starting uevent listener");
 
-- 
1.8.1.4
