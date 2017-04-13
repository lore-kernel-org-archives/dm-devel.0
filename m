From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] Revert "multipathd: set timeout for CLI commands
	correctly"
Date: Thu, 13 Apr 2017 15:11:21 +0200
Message-ID: <20170413131121.20635-1-mwilck@suse.com>
References: <20170405220705.GH19236@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405220705.GH19236@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

This reverts commit a002d124723cef3f2bb4fc33899d2613bdfe3924.

uxsock_timeout is in ms (argument to poll()), whereas
parse_cmd() uses the value to add to tv_sec in a struct timespec.
So the previous code was correct.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0c61caad..b167cb4c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1087,7 +1087,7 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
 		return 1;
 	}
 
-	r = parse_cmd(str, reply, len, vecs, uxsock_timeout);
+	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
 
 	if (r > 0) {
 		if (r == ETIMEDOUT)
-- 
2.12.2
