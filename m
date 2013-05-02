From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 04/16] Don't print checker messages for ghost
	paths
Date: Thu,  2 May 2013 16:46:25 -0500
Message-ID: <1367531197-8987-5-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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

Since PATH_GHOST is not an unexpected state, we don't need to
keep printing out checker messages for these paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0b5fd1d..826ea75 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -898,7 +898,8 @@ get_state (struct path * pp, int daemon)
 		c->timeout = DEF_TIMEOUT;
 	state = checker_check(c);
 	condlog(3, "%s: state = %s", pp->dev, checker_state_name(state));
-	if (state != PATH_UP && strlen(checker_message(c)))
+	if (state != PATH_UP && state != PATH_GHOST &&
+	    strlen(checker_message(c)))
 		condlog(3, "%s: checker msg is \"%s\"",
 			pp->dev, checker_message(c));
 	return state;
-- 
1.8.2
