From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: deterministic io throughput in multipath
Date: Wed,  1 Feb 2017 19:50:01 -0600
Message-ID: <1486000201-3960-1-git-send-email-bmarzins@redhat.com>
References: <af56a18e992f4a8cb474de87a208e02a@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <af56a18e992f4a8cb474de87a208e02a@BRMWP-EXMB12.corp.brocade.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is certainly moving in the right direction.  There are a couple of
things I would change. check_path_reinstate_state() will automatically
disable the path if there are configuration problems. If things aren't
configured correctly, or the code can't get the current time, it seems
like it should allow the path to get reinstated, to avoid keeping
a perfectly good path down indefinitely.  Also, if you look at the
delay_*_checks code, it automatically reinstates a problematic
path if there are no other paths to use. This seems like a good idea as
well.

Also, your code increments path_failures every time the checker fails.
This means that if a device is down for a while, when it comes back up,
it will get delayed.  I'm not sure if this is intentional, or if you
were trying to track the number of times the path was restored and then
failed again, instead of the total time a path was failed for.

Perhaps it would be easier to show the kind of changes I would make with
a patch.  What do you think about this? I haven't done much testing on
it at all, but these are the changes I would make.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c |   3 +
 libmultipath/dict.c   |   2 +-
 multipathd/main.c     | 149 +++++++++++++++++++++++---------------------------
 3 files changed, 72 insertions(+), 82 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index be384af..5837dc6 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -624,6 +624,9 @@ load_config (char * file)
 	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
 	conf->remove_retries = 0;
 	conf->max_sectors_kb = DEFAULT_MAX_SECTORS_KB;
+	conf->san_path_err_threshold = DEFAULT_ERR_CHECKS;
+	conf->san_path_err_forget_rate = DEFAULT_ERR_CHECKS;
+	conf->san_path_err_recovery_time = DEFAULT_ERR_CHECKS;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 4754572..ae94c88 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1050,7 +1050,7 @@ print_off_int_undef(char * buff, int len, void *ptr)
 	case NU_UNDEF:
 		return 0;
 	case NU_NO:
-		return snprintf(buff, len, "\"off\"");
+		return snprintf(buff, len, "\"no\"");
 	default:
 		return snprintf(buff, len, "%i", *int_ptr);
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index d6d68a4..305e236 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1488,69 +1488,70 @@ void repair_path(struct path * pp)
 }
 
 static int check_path_reinstate_state(struct path * pp) {
-	struct timespec start_time;
-	int disable_reinstate = 1;
-
-	if (!((pp->mpp->san_path_err_threshold > 0) && 
-				(pp->mpp->san_path_err_forget_rate > 0) &&
-				(pp->mpp->san_path_err_recovery_time >0))) {
-		return disable_reinstate;
-	}
-
-	if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0) {
-		return disable_reinstate;	
+	struct timespec curr_time;
+
+	if (pp->disable_reinstate) {
+		/* If we don't know how much time has passed, automatically
+		 * reinstate the path, just to be safe. Also, if there are
+		 * no other usable paths, reinstate the path */
+		if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0 ||
+		    pp->mpp->nr_active == 0) {
+			condlog(2, "%s : reinstating path early", pp->dev);
+			goto reinstate_path;
+		}
+		if ((curr_time.tv_sec - pp->dis_reinstate_time ) > pp->mpp->san_path_err_recovery_time) {
+			condlog(2,"%s : reinstate the path after err recovery time", pp->dev);
+			goto reinstate_path;
+		}
+		return 1;
 	}
 
-	if ((start_time.tv_sec - pp->dis_reinstate_time ) > pp->mpp->san_path_err_recovery_time) {
-		disable_reinstate =0;
-		pp->path_failures = 0;
-		pp->disable_reinstate = 0;
-		pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
-		condlog(3,"\npath %s :reinstate the path after err recovery time\n",pp->dev);
+	/* forget errors on a working path */
+	if ((pp->state == PATH_UP || pp->state == PATH_GHOST) &&
+	    pp->path_failures > 0) {
+		if (pp->san_path_err_forget_rate > 0)
+			pp->san_path_err_forget_rate--;
+		else {
+			/* for every san_path_err_forget_rate number of 
+			 * successful path checks decrement path_failures by 1
+			 */
+			pp->path_failures--;
+			pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
+		}
+		return 0;
 	}
-	return  disable_reinstate;
-}
 
-static int check_path_validity_err (struct path * pp) {
-	struct timespec start_time;
-	int disable_reinstate = 0;
+	/* If the path isn't recovering from a failed state, do nothing */
+	if (pp->state != PATH_DOWN && pp->state != PATH_SHAKY &&
+	    pp->state != PATH_TIMEOUT)
+		return 0;
 
-	if (!((pp->mpp->san_path_err_threshold > 0) && 
-				(pp->mpp->san_path_err_forget_rate > 0) &&
-				(pp->mpp->san_path_err_recovery_time >0))) {
-		return disable_reinstate;
-	}
+	if (pp->path_failures == 0)
+		 pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
+	pp->path_failures++;
 
-	if (clock_gettime(CLOCK_MONOTONIC, &start_time) != 0) {
-		return disable_reinstate;	
-	}
-	if (!pp->disable_reinstate) {
-		if (pp->path_failures) {
-			/*if the error threshold has hit hit within the san_path_err_forget_rate
-			 *cycles donot reinstante the path till the san_path_err_recovery_time
-			 *place the path in failed state till san_path_err_recovery_time so that the
-			 *cutomer can rectify the issue within this time .Once the completion of
-			 *san_path_err_recovery_time it should automatically reinstantate the path
-			 */
-			if ((pp->path_failures > pp->mpp->san_path_err_threshold) &&
-					(pp->san_path_err_forget_rate > 0)) {
-				printf("\n%s:%d: %s hit error threshold \n",__func__,__LINE__,pp->dev);
-				pp->dis_reinstate_time = start_time.tv_sec ;
-				pp->disable_reinstate = 1;
-				disable_reinstate = 1;
-			} else if ((pp->san_path_err_forget_rate > 0)) {
-				pp->san_path_err_forget_rate--;
-			} else {
-				/*for every san_path_err_forget_rate number
-				 *of successful path checks decrement path_failures by 1
-				 */
-				pp->path_failures --;
-				pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
-			}
-		}
+	/* if we don't know the currently time, we don't know how long to
+	 * delay the path, so there's no point in checking if we should */
+	if (clock_gettime(CLOCK_MONOTONIC, &curr_time) != 0)
+		return 0;
+	/* when path failures has exceeded the san_path_err_threshold
+	 * place the path in delayed state till san_path_err_recovery_time
+	 * so that the cutomer can rectify the issue within this time. After
+	 * the completion of san_path_err_recovery_time it should
+	 * automatically reinstate the path */
+	if (pp->path_failures > pp->mpp->san_path_err_threshold) {
+		condlog(2, "%s : hit error threshold. Delaying path reinstatement", pp->dev);
+		pp->dis_reinstate_time = curr_time.tv_sec;
+		pp->disable_reinstate = 1;
+		return 1;
 	}
-	return  disable_reinstate;
+	return 0;
+reinstate_path:
+	pp->path_failures = 0;
+	pp->disable_reinstate = 0;
+	return 0;
 }
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1566,7 +1567,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	int oldchkrstate = pp->chkrstate;
 	int retrigger_tries, checkint;
 	struct config *conf;
-	int ret;	
+	int ret;
 
 	if ((pp->initialized == INIT_OK ||
 	     pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp)
@@ -1664,16 +1665,15 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	if (!pp->mpp)
 		return 0;
 
+	/* We only need to check if the path should be delayed when the
+	 * the path is actually usable and san_path_err is configured */
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
-	     pp->disable_reinstate) {
-		/*
-		 * check if the path is in failed state for more than san_path_err_recovery_time
-		 * if not place the path in delayed state
-		 */
-		if (check_path_reinstate_state(pp)) {
-			pp->state = PATH_DELAYED;
-			return 1;
-		}
+	    pp->mpp->san_path_err_threshold > 0 &&
+	    pp->mpp->san_path_err_forget_rate > 0 &&
+	    pp->mpp->san_path_err_recovery_time > 0 &&
+	    check_path_reinstate_state(pp)) {
+		pp->state = PATH_DELAYED;
+		return 1;
 	}
 	
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) &&
@@ -1685,31 +1685,18 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		} else
 			pp->wait_checks = 0;
 	}
-	if ((newstate == PATH_DOWN || newstate == PATH_GHOST ||
-		pp->state == PATH_DOWN)) {
-		/*assigned  the path_err_forget_rate when we see the first failure on the path*/
-		if(pp->path_failures == 0){
-			pp->san_path_err_forget_rate = pp->mpp->san_path_err_forget_rate;
-		}
-		pp->path_failures++;
-	}
+
 	/*
 	 * don't reinstate failed path, if its in stand-by
 	 * and if target supports only implicit tpgs mode.
 	 * this will prevent unnecessary i/o by dm on stand-by
 	 * paths if there are no other active paths in map.
-	 *
-	 * when path failures has exceeded the san_path_err_threshold 
-	 * within san_path_err_forget_rate then we don't reinstate
-	 * failed path for san_path_err_recovery_time
 	 */
-	disable_reinstate = ((newstate == PATH_GHOST &&
+	disable_reinstate = (newstate == PATH_GHOST &&
 			    pp->mpp->nr_active == 0 &&
-			    pp->tpgs == TPGS_IMPLICIT) ? 1 :
-			    check_path_validity_err(pp));
+			    pp->tpgs == TPGS_IMPLICIT) ? 1 : 0;
 
 	pp->chkrstate = newstate;
-
 	if (newstate != pp->state) {
 		int oldstate = pp->state;
 		pp->state = newstate;
-- 
1.8.3.1
