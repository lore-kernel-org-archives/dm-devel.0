From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 11/16] Fix max path checker timing
Date: Fri, 3 May 2013 12:59:49 -0500
Message-ID: <20130503175948.GO6253@ether.msp.redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
	<1367531197-8987-12-git-send-email-bmarzins@redhat.com>
	<5183603F.5000003@suse.de>
	<20130503154457.GN6253@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130503154457.GN6253@ether.msp.redhat.com>
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

Due to some code being placed inside the wrong block, the number of
seconds to wait between path checks (pp->tick), was only getting set to
the path's individual check interval if that wasn't equal to the max
check interval.  Otherwise it was using the default for a failed path.
This patch makes sure that pp->ticks always always gets set correctly
for active paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 440d254..9d52465 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1220,10 +1220,10 @@ check_path (struct vectors * vecs, struct path * pp)
 				else
 					pp->checkint = conf->max_checkint;
 
-				pp->tick = pp->checkint;
 				condlog(4, "%s: delay next check %is",
-					pp->dev_t, pp->tick);
+					pp->dev_t, pp->checkint);
 			}
+			pp->tick = pp->checkint;
 		}
 	}
 	else if (newstate == PATH_DOWN) {
-- 
1.8.2
