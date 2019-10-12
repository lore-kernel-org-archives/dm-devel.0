From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 05/72] libmultipath: format_devname: avoid buffer
	overflow
Date: Sat, 12 Oct 2019 21:27:43 +0000
Message-ID: <20191012212703.12989-6-martin.wilck@suse.com>
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

If the buffer was too short, the current code could write
the terminating 0 byte after the actual buffer.

Also, assert sufficient buffer length, and positive id.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 412ab5b4..0fb206d1 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -52,18 +52,24 @@ format_devname(char *name, int id, int len, const char *prefix)
 	int pos;
 	int prefix_len = strlen(prefix);
 
-	memset(name,0, len);
+	if (len <= prefix_len + 1 || id <= 0)
+		return -1;
+
+	memset(name, 0, len);
 	strcpy(name, prefix);
-	for (pos = len - 1; pos >= prefix_len; pos--) {
+	name[len - 1] = '\0';
+	for (pos = len - 2; pos >= prefix_len; pos--) {
 		id--;
 		name[pos] = 'a' + id % 26;
 		if (id < 26)
 			break;
 		id /= 26;
 	}
+	if (pos < prefix_len)
+		return -1;
+
 	memmove(name + prefix_len, name + pos, len - pos);
-	name[prefix_len + len - pos] = '\0';
-	return (prefix_len + len - pos);
+	return (prefix_len + len - pos - 1);
 }
 
 static int
@@ -213,6 +219,9 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 	}
 
 	i = format_devname(buf, id, LINE_MAX, prefix);
+	if (i == -1)
+		return NULL;
+
 	c = buf + i;
 	snprintf(c, LINE_MAX - i, " %s\n", wwid);
 	buf[LINE_MAX - 1] = '\0';
-- 
2.23.0
