From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/33] multipathd: set timeout for CLI commands
	correctly
Date: Tue, 28 Feb 2017 17:23:02 +0100
Message-ID: <20170228162329.14517-7-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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

From: Hannes Reinecke <hare@suse.de>

The CLI command timeout wasn't set correctly for CLI commands,
causing it to timeout prematurely before the CLI response
could be received.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index e317a4c9..86d73f7b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1070,7 +1070,7 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
 		return 1;
 	}
 
-	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
+	r = parse_cmd(str, reply, len, vecs, uxsock_timeout);
 
 	if (r > 0) {
 		if (r == ETIMEDOUT)
-- 
2.11.0
