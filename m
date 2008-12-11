From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6/6] Fix user_friendly_names for WWIDs with spaces
Date: Thu, 11 Dec 2008 16:12:40 -0600
Message-ID: <20081211221240.GN1585@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The user_friendly_names code didn't handle WWIDs with spaces correctly.  This
fixes it by taking everything from the start of the WWID to the end of the line
as the WWID.  The only downside is that if someone hand edits their bindings
file, they may leave stray whitespace at the end of the line, and cause it to
not match.  This could ne solved by quoting the WWIDs and escaping any quotes
that they might have, but I don't think that people hand edit their bindings
files enough to make it a problem.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: multipath-tools-081203/libmultipath/alias.c
===================================================================
--- multipath-tools-081203.orig/libmultipath/alias.c
+++ multipath-tools-081203/libmultipath/alias.c
@@ -243,7 +243,7 @@ lookup_binding(FILE *f, char *map_wwid, 
 		curr_id = scan_devname(alias);
 		if (curr_id >= id)
 			id = curr_id + 1;
-		wwid = strtok(NULL, " \t");
+		wwid = strtok(NULL, "");
 		if (!wwid){
 			condlog(3,
 				"Ignoring malformed line %u in bindings file",
