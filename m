From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 22/72] libmultipath: mark unused arguments in
 partmap functions
Date: Sat, 12 Oct 2019 21:28:04 +0000
Message-ID: <20191012212703.12989-23-martin.wilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0f0c3a34..f478ac2d 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -812,7 +812,8 @@ dm_get_major_minor(const char *name, int *major, int *minor)
 }
 
 static int
-has_partmap(const char *name, void *data)
+has_partmap(const char *name __attribute__((unused)),
+	    void *data __attribute__((unused)))
 {
 	return 1;
 }
@@ -1308,7 +1309,7 @@ dm_remove_partmaps (const char * mapname, int need_sync, int deferred_remove)
 #ifdef LIBDM_API_DEFERRED
 
 static int
-cancel_remove_partmap (const char *name, void *unused)
+cancel_remove_partmap (const char *name, void *unused __attribute__((unused)))
 {
 	if (dm_get_opencount(name))
 		dm_cancel_remove_partmaps(name);
-- 
2.23.0
