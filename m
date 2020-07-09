From: mwilck@suse.com
Subject: [PATCH 05/35] libmultipath: improve strchop()
Date: Thu,  9 Jul 2020 12:15:50 +0200
Message-ID: <20200709101620.6786-6-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

strchop() returns size_t, so have it work with size_t, too. Also,
avoid the unnecessary second call to strlen().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 51c38c8..28d0168 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -26,11 +26,11 @@
 size_t
 strchop(char *str)
 {
-	int i;
+	size_t i;
 
-	for (i=strlen(str)-1; i >=0 && isspace(str[i]); --i) ;
+	for (i = strlen(str) - 1; i != (size_t) -1 && isspace(str[i]); i--) ;
 	str[++i] = '\0';
-	return strlen(str);
+	return i;
 }
 
 int
-- 
2.26.2
