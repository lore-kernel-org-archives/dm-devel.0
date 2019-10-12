From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 08/72] libmultipath: rlookup_binding(): removed
 unused parameter
Date: Sat, 12 Oct 2019 21:27:46 +0000
Message-ID: <20191012212703.12989-9-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

The parameter "prefix" is unused in this function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index ac342a54..767800d0 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -183,7 +183,7 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 }
 
 static int
-rlookup_binding(FILE *f, char *buff, const char *map_alias, const char *prefix)
+rlookup_binding(FILE *f, char *buff, const char *map_alias)
 {
 	char line[LINE_MAX];
 	unsigned int line_nr = 0;
@@ -297,7 +297,7 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 	/* lookup the binding. if it exists, the wwid will be in buff
 	 * either way, id contains the id for the alias
 	 */
-	rlookup_binding(f, buff, alias_old, prefix);
+	rlookup_binding(f, buff, alias_old);
 
 	if (strlen(buff) > 0) {
 		/* if buff is our wwid, it's already
@@ -412,7 +412,7 @@ get_user_friendly_wwid(const char *alias, char *buff, const char *file)
 		return -1;
 	}
 
-	rlookup_binding(f, buff, alias, NULL);
+	rlookup_binding(f, buff, alias);
 	if (!strlen(buff)) {
 		fclose(f);
 		return -1;
-- 
2.23.0
