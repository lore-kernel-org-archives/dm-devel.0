From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] multipathd: wait for udev in cli_resume()
Date: Mon,  9 May 2016 12:53:03 +0200
Message-ID: <1462791185-2903-6-git-send-email-hare@suse.de>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462791185-2903-1-git-send-email-hare@suse.de>
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

When calling 'cli_resume()' we should be waiting for udev to
ensure the device really has been resumed.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/cli_handlers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 0397353..5112786 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -967,7 +967,7 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 		return 1;
 	}
 
-	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0, 0);
+	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 1, 0);
 
 	condlog(2, "%s: resume (operator)", param);
 
-- 
2.6.6
