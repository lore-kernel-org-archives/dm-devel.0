From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 09/10] multipathd: fix buffer size in
	cli_getprkey()
Date: Sun, 24 Jun 2018 21:09:43 +0200
Message-ID: <20180624190944.27158-10-mwilck@suse.com>
References: <20180624190944.27158-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180624190944.27158-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

gcc 8.1 warned about this.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli_handlers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 47830e1c..5682b5c2 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1449,7 +1449,7 @@ cli_getprkey(void * v, char ** reply, int * len, void * data)
 	if (!mpp)
 		return 1;
 
-	*reply = malloc(20);
+	*reply = malloc(26);
 
 	if (!get_be64(mpp->reservation_key)) {
 		sprintf(*reply, "none\n");
@@ -1458,7 +1458,7 @@ cli_getprkey(void * v, char ** reply, int * len, void * data)
 	}
 	if (mpp->sa_flags & MPATH_F_APTPL_MASK)
 		flagstr = ":aptpl";
-	snprintf(*reply, 20, "0x%" PRIx64 "%s\n",
+	snprintf(*reply, 26, "0x%" PRIx64 "%s\n",
 		 get_be64(mpp->reservation_key), flagstr);
 	(*reply)[19] = '\0';
 	*len = strlen(*reply) + 1;
-- 
2.17.1
