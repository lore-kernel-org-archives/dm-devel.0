From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 06/72] libmultipath: scan_devname: fix int
	overflow detection
Date: Sat, 12 Oct 2019 21:27:44 +0000
Message-ID: <20191012212703.12989-7-martin.wilck@suse.com>
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

For an int n, it's possible that n > 0 and (26 * n) > 0, but
and still 26 * n overflows the int.
E.g. n = 0x0ec4ec4e; 26 * n = 0x17fffffec, truncated to 32 bit
yields 0x7fffffec, which is > 0.

And anyway, relying on a signed int overflow to detect a problem
is wrong, as the result of such operations is undefined in C.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 0fb206d1..a96ba5cc 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -77,6 +77,7 @@ scan_devname(const char *alias, const char *prefix)
 {
 	const char *c;
 	int i, n = 0;
+	static const int last_26 = INT_MAX / 26;
 
 	if (!prefix || strncmp(alias, prefix, strlen(prefix)))
 		return -1;
@@ -93,9 +94,9 @@ scan_devname(const char *alias, const char *prefix)
 		if (*c < 'a' || *c > 'z')
 			return -1;
 		i = *c - 'a';
-		n = ( n * 26 ) + i;
-		if (n < 0)
+		if (n > last_26 || (n == last_26 && i >= INT_MAX % 26))
 			return -1;
+		n = n * 26 + i;
 		c++;
 		n++;
 	}
-- 
2.23.0
