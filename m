From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 05/20] libmultipath: don't update path groups
	when printing
Date: Tue, 20 Feb 2018 14:26:43 +0100
Message-ID: <20180220132658.22295-6-mwilck@suse.com>
References: <20180220132658.22295-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180220132658.22295-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Updating the prio values for printing makes no sense. The user wants to see
the prio values multipath is actually using for path group selection, and
updating the values here means actually lying to the user if the prio values
have changed, but multipathd hasn't updated them internally.

If we really don't update the pathgroup prios when we need to, this should be
fixed elsewhere. The current wrong output would just hide that if it occured.

Moreover, correctness forbids changing properties so deeply in a code path
that's supposed to print them only. Finally, this piece of code prevents the
print.c code to be converted to proper "const" usage.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 8fb5c5058965..b5c00bfe69a5 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -484,13 +484,6 @@ snprint_pg_selector (char * buff, size_t len, struct pathgroup * pgp)
 static int
 snprint_pg_pri (char * buff, size_t len, struct pathgroup * pgp)
 {
-	/*
-	 * path group priority is not updated for every path prio change,
-	 * but only on switch group code path.
-	 *
-	 * Printing is another reason to update.
-	 */
-	path_group_prio_update(pgp);
 	return snprint_int(buff, len, pgp->priority);
 }
 
-- 
2.16.1
