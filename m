From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 09/72] libmultipath: allocate_binding(): error
	out for id=0
Date: Sat, 12 Oct 2019 21:27:48 +0000
Message-ID: <20191012212703.12989-10-martin.wilck@suse.com>
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

Only for positive id can we allocate a binding. All current
callers make sure the id is positive. Yet, fix the implementation
in allocate_binding(), too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 767800d0..2df34f32 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -233,8 +233,9 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 	char *alias, *c;
 	int i;
 
-	if (id < 0) {
-		condlog(0, "Bindings file full. Cannot allocate new binding");
+	if (id <= 0) {
+		condlog(0, "%s: cannot allocate new binding for id %d",
+			__func__, id);
 		return NULL;
 	}
 
-- 
2.23.0
