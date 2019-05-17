From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/4] multipathd: handle NULL return from
	genhelp_handler
Date: Fri, 17 May 2019 11:14:10 -0500
Message-ID: <1558109650-21179-5-git-send-email-bmarzins@redhat.com>
References: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

parse_cmd() wasn't checking if genhelp_handler() returned NULL. It was simply
assuming that it got a string. On NULL, it now returns an error. Found by
Coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index ca176a99..17795b61 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -467,6 +467,8 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 
 	if (r) {
 		*reply = genhelp_handler(cmd, r);
+		if (*reply == NULL)
+			return EINVAL;
 		*len = strlen(*reply) + 1;
 		return 0;
 	}
@@ -474,9 +476,11 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 	h = find_handler(fingerprint(cmdvec));
 
 	if (!h || !h->fn) {
+		free_keys(cmdvec);
 		*reply = genhelp_handler(cmd, EINVAL);
+		if (*reply == NULL)
+			return EINVAL;
 		*len = strlen(*reply) + 1;
-		free_keys(cmdvec);
 		return 0;
 	}
 
-- 
2.17.2
