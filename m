From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/12] kpartx: don't treat multi-linear
	mappings as partitions
Date: Mon, 15 May 2017 17:37:17 +0200
Message-ID: <20170515153722.11508-8-mwilck@suse.com>
References: <20170515153722.11508-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170515153722.11508-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

kpartx -d treats any map that has a "linear" mapping into a
device as first target as a partition of this device.
This is wrong, because linear mappings may consist of
several pieces, combining multiple devices into one
(LVM logical volumes are an example of such a
mapping). Partitions have to be single-target mappings.

Fix this by returning an error in dm_type() if a map with
multiple targets is encountered. The "type" of a map with
two or more targets is a difficult concept, anyway.

test case:
truncate -s 1G test0 test1
losetup /dev/loop0 test0
losetup /dev/loop1 test1
dmsetup create <<EOF
0 1000000 linear 7:0 4096
1000000 1000000 linear 7:1 4096
EOF
kpartx -d /dev/loop0 -v

The map "join" should NOT be deleted.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/devmapper.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 6cee120d..b714ba4e 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -392,10 +392,11 @@ dm_type(const char * name, char * type)
 		goto out;
 
 	/* Fetch 1st target */
-	dm_get_next_target(dmt, NULL, &start, &length,
-			   &target_type, &params);
-
-	if (!target_type)
+	if (dm_get_next_target(dmt, NULL, &start, &length,
+			       &target_type, &params) != NULL)
+		/* more than one target */
+		r = -1;
+	else if (!target_type)
 		r = -1;
 	else if (!strcmp(target_type, type))
 		r = 1;
@@ -500,7 +501,7 @@ do_foreach_partmaps (const char * mapname, const char *uuid,
 		/*
 		 * skip if devmap target is not "linear"
 		 */
-		if (!dm_type(names->name, "linear")) {
+		if (dm_type(names->name, "linear") != 1) {
 			if (rd->verbose)
 				printf("%s: is not a linear target. Not removing\n",
 				       names->name);
-- 
2.12.2
