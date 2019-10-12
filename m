From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 13/72] libmultipath: alias.c: prepare for
 cancel-safe allocation
Date: Sat, 12 Oct 2019 21:27:53 +0000
Message-ID: <20191012212703.12989-14-martin.wilck@suse.com>
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

In functions that return newly allocated memory, avoid cancellation
points before returning, and if that's not possible, guard the code
that contains cancellation points with a cleanup function calling
free(), and immediately before returning, call pthread_cleanup_pop(0).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 15bbc8ed..0fc9e542 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -268,13 +268,12 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 	c = strchr(buf, ' ');
 	if (c)
 		*c = '\0';
+
+	condlog(3, "Created new binding [%s] for WWID [%s]", buf, wwid);
 	alias = strdup(buf);
 	if (alias == NULL)
-		condlog(0, "cannot copy new alias from bindings file : %s",
-			strerror(errno));
-	else
-		condlog(3, "Created new binding [%s] for WWID [%s]", alias,
-			wwid);
+		condlog(0, "cannot copy new alias from bindings file: out of memory");
+
 	return alias;
 }
 
@@ -342,7 +341,9 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 	}
 
 out:
+	pthread_cleanup_push(free, alias);
 	fclose(f);
+	pthread_cleanup_pop(0);
 	return alias;
 }
 
@@ -378,18 +379,19 @@ get_user_friendly_alias(const char *wwid, const char *file, const char *prefix,
 		return NULL;
 	}
 
+	pthread_cleanup_push(free, alias);
+
 	if (fflush(f) != 0) {
 		condlog(0, "cannot fflush bindings file stream : %s",
 			strerror(errno));
 		free(alias);
-		fclose(f);
-		return NULL;
-	}
-
-	if (can_write && !bindings_read_only && !alias)
+		alias = NULL;
+	} else if (can_write && !bindings_read_only && !alias)
 		alias = allocate_binding(fd, wwid, id, prefix);
 
 	fclose(f);
+
+	pthread_cleanup_pop(0);
 	return alias;
 }
 
-- 
2.23.0
