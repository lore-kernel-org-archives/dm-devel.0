From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/19] libmultipath: decrease log level of word
	splitting
Date: Wed, 21 Nov 2018 11:18:28 +0100
Message-ID: <20181121101839.30784-9-mwilck@suse.com>
References: <20181121101839.30784-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181121101839.30784-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This will make log level 4 actually usable.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 66c47611..b5d2e706 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -104,7 +104,7 @@ get_word (char * sentence, char ** word)
 	}
 	strncpy(*word, sentence, len);
 	strchop(*word);
-	condlog(4, "*word = %s, len = %i", *word, len);
+	condlog(5, "*word = %s, len = %i", *word, len);
 
 	if (*p == '\0')
 		return 0;
-- 
2.19.1
