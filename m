From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH] dm-multipath: fix get_word return value when the
	last word is found
Date: Fri, 20 Mar 2015 17:01:54 +0800
Message-ID: <1426842114-3335-1-git-send-email-vaughan.cao@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: vaughan.cao@oracle.com
List-Id: dm-devel.ids

get_word() returns how many bytes it has parsed when it gets a new word.
But the deleted code will cause 0 returned for the last word, which
breaks this semantic. It hasn't cause any trouble yet because we have
been calling it as we are certain there is an word left.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 libmultipath/util.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index ac0d1b2..0bb9c15 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -93,9 +93,6 @@ get_word (char * sentence, char ** word)
 	strchop(*word);
 	condlog(4, "*word = %s, len = %i", *word, len);
 
-	if (*p == '\0')
-		return 0;
-
 	return skip + len;
 }
 
-- 
1.9.0
