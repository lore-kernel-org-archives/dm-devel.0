From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 20/20] libmultipath: path latency: remove
	warnings
Date: Sat, 13 Jan 2018 22:19:38 +0100
Message-ID: <20180113211938.31552-21-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The warnings at here are pointless. We are looking at a single
path only. Firstly, the standdard deviation for this measurement
can't be "too low" - the lower, the more precise the measurement,
the better. Secondly, a high standard deviation indicates an
unstable path with highly variable latency. Not good, but nothing
to warn about here.

What matters for the selection of "base_num" is not how a single
path behaves, but how different paths of the same path group relate
to each other, which we don't know at this point at the code.

What we want to avoid is too fine a differentiation, in particular
in combination with group_by_prio, because we'd loose the ability for
load balancing. But this is rather a topic for the man page or a
"best practices" document.
---
 libmultipath/prioritizers/path_latency.c | 34 --------------------------------
 1 file changed, 34 deletions(-)

diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index e764f1dd8a21..765265c02333 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -289,40 +289,6 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 		return DEFAULT_PRIORITY;
 	}
 
-	standard_deviation = calc_standard_deviation(lg_path_latency,
-			index, lg_avglatency);
-	/*
-	 * In calPrio(), we let prio y = f(x) = log(max, base) - log (x, base);
-	 * So if we want to let the priority of the latency outside 2 standard
-	 * deviations can be distinguished from the latency inside 2 standard
-	 * deviation, in others words at most 95% are the same and at least 5%
-	 * are different according interval estimation of normal distribution,
-	 * we should warn the user to set the base_num to be smaller if the
-	 * log(x_threshold, base) is small than 2 standard deviation.
-	 * x_threshold is derived from:
-	 * y + 1 = f(x) + 1 = f(x) + log(base, base), so x_threadshold =
-	 * base_num; Note that we only can compare the logarithm of x_threshold
-	 * with the standard deviation because the standard deviation is derived
-	 * from logarithm of latency.
-	 *
-	 * therefore , we recommend the base_num to meet the condition :
-	 * 1 <= 2 * standard_deviation
-	 */
-	pp_pl_log(5, "%s: standard deviation for logarithm of latency = %.6f",
-			pp->dev, standard_deviation);
-	if (standard_deviation <= 0.5)
-		pp_pl_log(3, "%s: the base_num(%.3lf) is too big to distinguish different priority "
-			  "of two far-away latency. It is recommend to be set smaller",
-			  pp->dev, base_num);
-	/*
-	 * If the standard deviation is too large , we should also warn the user
-	 */
-
-	if (standard_deviation > 4)
-		pp_pl_log(3, "%s: the base_num(%.3lf) is too small to avoid noise disturbance "
-			  ".It is recommend to be set larger",
-			  pp->dev, base_num);
-
 	standard_deviation = sqrt((sum_squares - lg_toldelay * lg_avglatency)
 				  / (io_num - 1));
 
-- 
2.15.1
