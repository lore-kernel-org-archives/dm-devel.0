From: neilb@suse.de
Subject: [dmraid 1/4] Parse "-cc" as required by man page.
Date: Thu, 17 Dec 2009 16:44:11 +1100
Message-ID: <20091217054515.427662058@suse.de>
References: <20091217054410.410634166@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dmraid_duplicate_args.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a bit of a hack but....

The man page says that "-cc" will provide 'CSV' style output.
The code only provides this if "-c -c" is given.
This hack effectively maps "-cc" to "-c -c".

patch extracted from openSUSE package

From: hare@suse.de
Signed-off-by: NeilBrown <neilb@suse.de>

---
 tools/commands.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- dmraid.orig/tools/commands.c
+++ dmraid/tools/commands.c
@@ -142,10 +142,18 @@ check_identifiers(struct lib_context *lc
 		const char delim = *OPT_STR_SEPARATOR(lc);
 		char *p = optarg;
 
-		p = remove_white_space(lc, p, strlen(p));
-		p = collapse_delimiter(lc, p, strlen(p), delim);
-		if (!lc_strcat_opt(lc, o, p, delim))
-			return 0;
+		if (o == LC_COLUMN) {
+			while (p && *p == 'c') {
+				lc_inc_opt(lc, o);
+				p++;
+			}
+		}
+		if (p && *p) {
+			p = remove_white_space(lc, p, strlen(p));
+			p = collapse_delimiter(lc, p, strlen(p), delim);
+			if (!lc_strcat_opt(lc, o, p, delim))
+				return 0;
+		}
 	}
 
 	lc_inc_opt(lc, o);
