From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: rlookup WWIDs with spaces by alias
Date: Fri, 11 Nov 2011 22:54:26 -0600
Message-ID: <20111112045426.GD24133@ether.msp.redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

If a WWID contained spaces, the rlookup code wasn't able to look it up
by its user_friendly_name, since the code was only reading the wwid till
the first space.  It now reads to the end of the line.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-110412/libmultipath/alias.c
===================================================================
--- multipath-tools-110412.orig/libmultipath/alias.c
+++ multipath-tools-110412/libmultipath/alias.c
@@ -288,7 +288,7 @@ rlookup_binding(FILE *f, char **map_wwid
 		curr_id = scan_devname(alias, NULL); /* TBD: Why this call? */
 		if (curr_id >= id)
 			id = curr_id + 1;
-		wwid = strtok(NULL, " \t");
+		wwid = strtok(NULL, "");
 		if (!wwid){
 			condlog(3,
 				"Ignoring malformed line %u in bindings file",
