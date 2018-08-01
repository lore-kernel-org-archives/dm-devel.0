From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 23/32] libmultipath: _install_keyword cleanup
Date: Wed,  1 Aug 2018 15:57:09 -0500
Message-ID: <1533157038-3924-24-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

_install_keyword should use VECTOR_LAST_SLOT(), which has better error
checking. It should also fail if it gets a NULL pointer, instead of
dereferencing it. Found by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index b8b7e0d..92ef7cf 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -79,12 +79,16 @@ _install_keyword(vector keywords, char *string,
 	struct keyword *keyword;
 
 	/* fetch last keyword */
-	keyword = VECTOR_SLOT(keywords, VECTOR_SIZE(keywords) - 1);
+	keyword = VECTOR_LAST_SLOT(keywords);
+	if (!keyword)
+		return 1;
 
 	/* position to last sub level */
-	for (i = 0; i < sublevel; i++)
-		keyword =
-		    VECTOR_SLOT(keyword->sub, VECTOR_SIZE(keyword->sub) - 1);
+	for (i = 0; i < sublevel; i++) {
+		keyword = VECTOR_LAST_SLOT(keyword->sub);
+		if (!keyword)
+			return 1;
+	}
 
 	/* First sub level allocation */
 	if (!keyword->sub)
-- 
2.7.4
