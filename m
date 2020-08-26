From: mwilck@suse.com
Subject: [PATCH v2 08/10] libmultipath: fix invalid memory access
	in is_token()
Date: Wed, 26 Aug 2020 11:59:05 +0200
Message-ID: <20200826095907.5576-9-mwilck@suse.com>
References: <20200826095907.5576-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200826095907.5576-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

memcmp() must always be passed memory areas that are valid for the
full length given by the size argument.

See e.g. https://trust-in-soft.com/blog/2015/12/21/memcmp-requires-pointers-to-fully-valid-buffers/

Fixes: 7d95fb6 ("libmultipath: config parser: fix corner case for double quotes")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/parser.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 4f65ba1..3875174 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -194,7 +194,9 @@ snprint_keyword(char *buff, int len, char *fmt, struct keyword *kw,
 static const char quote_marker[] = { '\0', '"', '\0' };
 bool is_quote(const char* token)
 {
-	return !memcmp(token, quote_marker, sizeof(quote_marker));
+	return token[0] == quote_marker[0] &&
+		token[1] == quote_marker[1] &&
+		token[2] == quote_marker[2];
 }
 
 vector
-- 
2.28.0
