From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] [RFC] multipath: multipath command pathgroup
	compare problem
Date: Tue, 09 Nov 2010 00:30:36 -0800
Message-ID: <53a3cae5dc7a1d1c3e37.1289291436@malahal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

I have 2 pathgroups to a LUN and each pathgroup has 2 paths. Say P1,P2
belong to PG1 and P3,P4 belong to PG2.

I deleted P2 from the system and added it back. I also stopped
multipathd on purpose. Now, running multipath command is not adding the
new path P3 back to the table.

After some debugging, I found that both the pathgroups in mpp->pg
compute their ids to be same and is 20020. The actual loaded table's
pathgroup ids are computed as 61E860 and 20020. The pgcmp() returns 0
here as the same pathgroup PG2 from the loaded table (cmpp) is compared
against PG1 and PG2 of intended table (mpp)

Added a found field to avoid using the same pathgroup multiple times.

The fact that the exclusive ORing computation of path address can
evaluate to the same value for two different pathgroups indicates that
we may a hit different problem in the future. The best way to do this is
sorting pathgroups and paths within the pathgroup and just compare path
by path. Any suggestions or am I missing something here?

Signed-off-by: Malahal Naineni (malahal@us.ibm.com)

diff -r 1dc078c2002f -r 53a3cae5dc7a libmultipath/configure.c
--- a/libmultipath/configure.c	Tue Nov 09 00:07:04 2010 -0800
+++ b/libmultipath/configure.c	Tue Nov 09 00:30:17 2010 -0800
@@ -125,11 +125,14 @@ pgcmp (struct multipath * mpp, struct mu
 	if (!mpp)
 		return 0;
 
+	vector_foreach_slot (cmpp->pg, cpgp, j) {
+		cpgp->found = 0;
+	}
 	vector_foreach_slot (mpp->pg, pgp, i) {
 		compute_pgid(pgp);
-
 		vector_foreach_slot (cmpp->pg, cpgp, j) {
-			if (pgp->id == cpgp->id) {
+			if (!cpgp->found && pgp->id == cpgp->id) {
+				cpgp->found = 1;
 				r = 0;
 				break;
 			}
diff -r 1dc078c2002f -r 53a3cae5dc7a libmultipath/structs.h
--- a/libmultipath/structs.h	Tue Nov 09 00:07:04 2010 -0800
+++ b/libmultipath/structs.h	Tue Nov 09 00:30:17 2010 -0800
@@ -210,6 +210,7 @@ struct multipath {
 
 struct pathgroup {
 	long id;
+	int found;
 	int status;
 	int priority;
 	int enabled_paths;
