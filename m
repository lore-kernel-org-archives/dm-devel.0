From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 13/33] libmultipath: use existing alias from
	bindings file
Date: Tue, 28 Feb 2017 17:23:09 +0100
Message-ID: <20170228162329.14517-14-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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

From: Hannes Reinecke <hare@suse.de>

If the bindings file has been edited by hand not all entries conform
to the user_friendly_prefix setting. So if we don't find a matching
alias we need to check if the wwid is set to a different alias; if
so we need to use that.
Otherwise we'll end up with duplicate entries in the bindings file.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/alias.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 12afef8f..fd6b7f91 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -107,6 +107,7 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 
 	*map_alias = NULL;
 
+	rewind(f);
 	while (fgets(buf, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
@@ -280,6 +281,13 @@ use_existing_alias (char *wwid, char *file, char *alias_old,
 		goto out;
 	}
 
+	id = lookup_binding(f, wwid, &alias, NULL);
+	if (alias) {
+		condlog(3, "Use existing binding [%s] for WWID [%s]",
+			alias, wwid);
+		goto out;
+	}
+
 	/* allocate the existing alias in the bindings file */
 	id = scan_devname(alias_old, prefix);
 	if (id <= 0)
-- 
2.11.0
