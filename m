From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 02/12] Return the correct size buffer in
	set_value()
Date: Mon, 30 Jun 2014 00:13:53 -0500
Message-ID: <1404105243-5071-3-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When multipath was mallocing the buffer in set_value, it was using
sizeof(char *), instead of sizeof(char), so it was allocating a buffer
big enough for an array of pointers instead of characters.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 526c45b..0d4c870 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -408,11 +408,11 @@ set_value(vector strvec)
 			len += strlen(str);
 			if (!alloc)
 				alloc =
-				    (char *) MALLOC(sizeof (char *) *
+				    (char *) MALLOC(sizeof (char) *
 						    (len + 1));
 			else {
 				alloc =
-				    REALLOC(alloc, sizeof (char *) * (len + 1));
+				    REALLOC(alloc, sizeof (char) * (len + 1));
 				tmp = VECTOR_SLOT(strvec, i-1);
 				if (alloc && *str != '"' && *tmp != '"')
 					strncat(alloc, " ", 1);
@@ -422,7 +422,7 @@ set_value(vector strvec)
 				strncat(alloc, str, strlen(str));
 		}
 	} else {
-		alloc = MALLOC(sizeof (char *) * (size + 1));
+		alloc = MALLOC(sizeof (char) * (size + 1));
 		if (alloc)
 			memcpy(alloc, str, size);
 	}
-- 
1.8.3.1
