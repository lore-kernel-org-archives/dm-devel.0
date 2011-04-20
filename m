From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] multipathd: use 0 for initial pg if there are no
 priority groups
Date: Wed, 20 Apr 2011 17:24:00 -0400
Message-ID: <20110420212400.GA6114@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-multipath now accommodates a DM table that doesn't have any priority
groups, see: http://git.kernel.org/linus/a490a07a67b7a37

That kernel change imposes that multipathd must pass 0 for the initial
priority group if there aren't any priority groups (currently passes 1).

There is no need to check the multipath target version to decide whether
to pass an initial_pg of 0 or 1 because until recently dm-multipath
never accommodated a DM table with no priority groups.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 libmultipath/dmparser.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 1ef3aad..0803bec 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -52,6 +52,7 @@ assemble_map (struct multipath * mp)
 	int i, j;
 	int shift, freechar;
 	int minio;
+	int nr_priority_groups, initial_pg_nr;
 	char * p;
 	struct pathgroup * pgp;
 	struct path * pp;
@@ -60,9 +61,12 @@ assemble_map (struct multipath * mp)
 	p = mp->params;
 	freechar = sizeof(mp->params);
 
+	nr_priority_groups = VECTOR_SIZE(mp->pg);
+	initial_pg_nr = (nr_priority_groups ? mp->bestpg : 0);
+
 	shift = snprintf(p, freechar, "%s %s %i %i",
 			 mp->features, mp->hwhandler,
-			 VECTOR_SIZE(mp->pg), mp->bestpg);
+			 nr_priority_groups, initial_pg_nr);
 
 	if (shift >= freechar) {
 		fprintf(stderr, "mp->params too small\n");
-- 
1.7.3.4
