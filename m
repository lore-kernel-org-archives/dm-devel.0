From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 2/4] multipath-tools: add checker callout to
 repair path
Date: Sun, 14 Aug 2016 03:41:33 -0500
Message-ID: <57B02EBD.9090206@redhat.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<1470657710-28081-3-git-send-email-mchristi@redhat.com>
	<9d5dcfcd-2550-c9e9-94dc-47c34ebdb039@sandisk.com>
	<57ACE12F.20700@redhat.com>
	<e4286ca9-01cb-5cc0-2d67-38f68c0a19cb@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010708090702070506070405"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e4286ca9-01cb-5cc0-2d67-38f68c0a19cb@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010708090702070506070405
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 08/11/2016 04:41 PM, Bart Van Assche wrote:
> On 08/11/2016 01:33 PM, Mike Christie wrote:
>> Could you try the attached patch. I found two segfaults. If check_path
>> returns less than 0 then we free the path and so we cannot call repair
>> on it. If libcheck_init fails it memsets the checker, so we cannot call
>> repair on it too.
>>
>> I moved the repair call to the specific paths that the path is down.
> 
> Hello Mike,
> 
> Thanks for the patch. Unfortunately even with this patch applied I can
> still trigger a segfault sporadically:
> 

Ok. This should fix all of them. Attached patch fixes:

1. If check_path returns less than 0 then we free the path and so we
cannot call repair on it of course.
2. If libcheck_init fails it memsets the checker, so we cannot call
repair on it too.
3. We can hit a race where when pathinfo is setting up a path, the path
could have gone down. In the DI_CHECKER chunk we then do not run
get_state and attach a checker. Later when check_path is run
path_offline we could still return PATH_DOWN or PATH_REMOVED and
get_state is again not run so we do not get to attach a checker again. I
was then running repair_path since the state was PATH_DOWN, and kaboom.

Attached patch should fix these issues.

--------------010708090702070506070405
Content-Type: text/x-patch;
 name="multipathd-fix-segfault.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="multipathd-fix-segfault.patch"

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 8976c89..fd999b0 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -213,7 +213,7 @@ void checker_put (struct checker * dst)
 
 void checker_repair (struct checker * c)
 {
-	if (!c)
+	if (!c || !checker_selected(c))
 		return;
 
 	c->message[0] = '\0';
diff --git a/multipathd/main.c b/multipathd/main.c
index f5e9a01..c4ffe6f 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1442,6 +1442,16 @@ int update_path_groups(struct multipath *mpp, struct vectors *vecs, int refresh)
 	return 0;
 }
 
+void repair_path(struct path * pp)
+{
+	if (pp->state != PATH_DOWN)
+		return;
+
+	checker_repair(&pp->checker);
+	if (strlen(checker_message(&pp->checker)))
+		LOG_MSG(1, checker_message(&pp->checker));
+}
+
 /*
  * Returns '1' if the path has been checked, '-1' if it was blacklisted
  * and '0' otherwise
@@ -1606,6 +1616,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 			pp->mpp->failback_tick = 0;
 
 			pp->mpp->stat_path_failures++;
+			repair_path(pp);
 			return 1;
 		}
 
@@ -1700,7 +1711,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	}
 
 	pp->state = newstate;
-
+	repair_path(pp);
 
 	if (pp->mpp->wait_for_udev)
 		return 1;
@@ -1725,14 +1736,6 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 	return 1;
 }
 
-void repair_path(struct vectors * vecs, struct path * pp)
-{
-	if (pp->state != PATH_DOWN)
-		return;
-
-	checker_repair(&pp->checker);
-}
-
 static void *
 checkerloop (void *ap)
 {
@@ -1804,7 +1807,6 @@ checkerloop (void *ap)
 					i--;
 				} else
 					num_paths += rc;
-				repair_path(vecs, pp);
 			}
 			lock_cleanup_pop(vecs->lock);
 		}

--------------010708090702070506070405
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010708090702070506070405--
