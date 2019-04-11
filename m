From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/4] libmultipath: ana prioritizer: decrease log
	level
Date: Thu, 11 Apr 2019 12:49:22 +0200
Message-ID: <20190411104923.13470-4-mwilck@suse.com>
References: <20190411104923.13470-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190411104923.13470-1-mwilck@suse.com>
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

The "ana state = ..." printed in the get_prio() call path
is irritating, because by it's similarity to the checker
messages it suggests to the reader that an "ana checker",
which doesn't exist, was in place. Moreover, the "ana prio ="
message is also only printed at level 4.

Decrease the verbosity of this message.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/ana.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index 990d935f..2673d9d9 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -164,7 +164,7 @@ int get_ana_info(struct path * pp, unsigned int timeout)
 				   ana_log, ana_log_len);
 	pthread_cleanup_pop(1);
 	if (rc >= 0)
-		condlog(3, "%s: ana state = %02x [%s]", pp->dev, rc,
+		condlog(4, "%s: ana state = %02x [%s]", pp->dev, rc,
 			aas_print_string(rc));
 	return rc;
 }
-- 
2.21.0
