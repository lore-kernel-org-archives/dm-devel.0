From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/2] multipath: don't check timestamps without a
	path
Date: Tue,  5 Jun 2018 17:40:21 -0500
Message-ID: <1528238421-26087-3-git-send-email-bmarzins@redhat.com>
References: <1528238421-26087-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1528238421-26087-1-git-send-email-bmarzins@redhat.com>
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

If a path was blacklisted, pathvec could exist but have no path in it.
print_cmd_valid wasn't checking this before calling
find_multipaths_check_timeout(). This was causing it to dereference a
NULL pointer in these cases.

Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index c69e996..3f0a6aa 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -482,10 +482,8 @@ static int print_cmd_valid(int k, const vector pathvec,
 			pp, pp->find_multipaths_timeout, &until);
 		if (wait != FIND_MULTIPATHS_WAITING)
 			k = 1;
-	} else if (pathvec != NULL) {
-		pp = VECTOR_SLOT(pathvec, 0);
+	} else if (pathvec != NULL && (pp = VECTOR_SLOT(pathvec, 0)))
 		wait = find_multipaths_check_timeout(pp, 0, &until);
-	}
 	if (wait == FIND_MULTIPATHS_WAITING)
 		printf("FIND_MULTIPATHS_WAIT_UNTIL=\"%ld.%06ld\"\n",
 			       until.tv_sec, until.tv_nsec/1000);
-- 
2.7.4
