From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 10/72] libmultipath: allocate_binding(): detect
	line overflow
Date: Sat, 12 Oct 2019 21:27:49 +0000
Message-ID: <20191012212703.12989-11-martin.wilck@suse.com>
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

Be sure not to truncate the WWID. This shouldn't happen under
normal circumstances, but play it safe.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 2df34f32..15bbc8ed 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -244,7 +244,10 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 		return NULL;
 
 	c = buf + i;
-	snprintf(c, LINE_MAX - i, " %s\n", wwid);
+	if (snprintf(c, LINE_MAX - i, " %s\n", wwid) >= LINE_MAX - i) {
+		condlog(1, "%s: line too long for %s\n", __func__, wwid);
+		return NULL;
+	}
 	buf[LINE_MAX - 1] = '\0';
 
 	offset = lseek(fd, 0, SEEK_END);
-- 
2.23.0
