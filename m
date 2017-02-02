From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: Re: deterministic io throughput in multipath
Date: Thu, 2 Feb 2017 11:48:39 +0000
Message-ID: <3ab5d07903b44e0a913b5637862c4c96@BRMWP-EXMB12.corp.brocade.com>
References: <af56a18e992f4a8cb474de87a208e02a@BRMWP-EXMB12.corp.brocade.com>
	<1486000201-3960-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_3ab5d07903b44e0a913b5637862c4c96BRMWPEXMB12corpbrocadec_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1486000201-3960-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--_002_3ab5d07903b44e0a913b5637862c4c96BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi Ben,
The below changes suggested by you are good. Thanks for it.
I have taken your changes and made few changes to make the functionality working.
I have tested the same on the setup which works fine.

We need to increment the path_failures every time checker fails.
if a device is down for a while, when it comes back up, it will get delayed only if the path failures exceeds the error threshold.
Whether checker fails or kernel identifies the failures we need  to capture those as it tells the state of the path and target.
The below code has already taken care of this.

Could you please review the attached patch and provide us your valuable comments .

Below are the files that has been changed .

libmultipath/config.c      |  6 ++++++
 libmultipath/config.h      |  9 +++++++++
 libmultipath/configure.c   |  3 +++
 libmultipath/defaults.h    |  3 ++-
 libmultipath/dict.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 libmultipath/dict.h        |  3 +--
 libmultipath/propsel.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 libmultipath/propsel.h     |  3 +++
 libmultipath/structs.h     | 14 ++++++++++----
 multipath/multipath.conf.5 | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 multipathd/main.c          | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 281 insertions(+), 34 deletions(-)

Regards,
Muneendra.




-----Original Message-----
From: Benjamin Marzinski [mailto:bmarzins@redhat.com] 
Sent: Thursday, February 02, 2017 7:20 AM
To: Muneendra Kumar M <mmandala@Brocade.com>
Cc: device-mapper development <dm-devel@redhat.com>
Subject: RE: [dm-devel] deterministic io throughput in multipath

This is certainly moving in the right direction.  There are a couple of things I would change. check_path_reinstate_state() will automatically disable the path if there are configuration problems. If things aren't configured correctly, or the code can't get the current time, it seems like it should allow the path to get reinstated, to avoid keeping a perfectly good path down indefinitely.  Also, if you look at the delay_*_checks code, it automatically reinstates a problematic path if there are no other paths to use. This seems like a good idea as well.

Also, your code increments path_failures every time the checker fails.
This means that if a device is down for a while, when it comes back up, it will get delayed.  I'm not sure if this is intentional, or if you were trying to track the number of times the path was restored and then failed again, instead of the total time a path was failed for.

Perhaps it would be easier to show the kind of changes I would make with a patch.  What do you think about this? I haven't done much testing on it at all, but these are the changes I would make.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c |   3 +
 libmultipath/dict.c   |   2 +-
 multipathd/main.c     | 149 +++++++++++++++++++++++---------------------------
 3 files changed, 72 insertions(+), 82 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c index be384af..5837dc6 100644
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
diff --git a/libmultipath/dict.c b/libmultipath/dict.c index 4754572..ae94c88 100644
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
diff --git a/multipathd/main.c b/multipathd/main.c index d6d68a4..305e236 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1488,69 +1488,70 @@ void repair_path(struct path * pp)  }
 
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
 	     pp->initialized == INIT_REQUESTED_UDEV) && !pp->mpp) @@ -1664,16 +1665,15 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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
 	
 	if ((newstate == PATH_UP || newstate == PATH_GHOST) && @@ -1685,31 +1685,18 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
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


--_002_3ab5d07903b44e0a913b5637862c4c96BRMWPEXMB12corpbrocadec_
Content-Type: application/octet-stream; name="san_path_error.patch"
Content-Description: san_path_error.patch
Content-Disposition: attachment; filename="san_path_error.patch"; size=22168;
	creation-date="Wed, 01 Feb 2017 05:58:31 GMT";
	modification-date="Thu, 02 Feb 2017 10:14:56 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWcuYyBiL2xpYm11bHRpcGF0aC9jb25maWcu
YwppbmRleCAxNWRkYmQ4Li41ODM3ZGM2IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvY29uZmln
LmMKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZy5jCkBAIC0zNDgsNiArMzQ4LDkgQEAgbWVyZ2Vf
aHdlIChzdHJ1Y3QgaHdlbnRyeSAqIGRzdCwgc3RydWN0IGh3ZW50cnkgKiBzcmMpCiAJbWVyZ2Vf
bnVtKGRlbGF5X3dhaXRfY2hlY2tzKTsKIAltZXJnZV9udW0oc2tpcF9rcGFydHgpOwogCW1lcmdl
X251bShtYXhfc2VjdG9yc19rYik7CisJbWVyZ2VfbnVtKHNhbl9wYXRoX2Vycl90aHJlc2hvbGQp
OworCW1lcmdlX251bShzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUpOworCW1lcmdlX251bShzYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CiAKIAkvKgogCSAqIE1ha2Ugc3VyZSBmZWF0dXJlcyBp
cyBjb25zaXN0ZW50IHdpdGgKQEAgLTYyMSw2ICs2MjQsOSBAQCBsb2FkX2NvbmZpZyAoY2hhciAq
IGZpbGUpCiAJY29uZi0+ZGlzYWJsZV9jaGFuZ2VkX3d3aWRzID0gREVGQVVMVF9ESVNBQkxFX0NI
QU5HRURfV1dJRFM7CiAJY29uZi0+cmVtb3ZlX3JldHJpZXMgPSAwOwogCWNvbmYtPm1heF9zZWN0
b3JzX2tiID0gREVGQVVMVF9NQVhfU0VDVE9SU19LQjsKKwljb25mLT5zYW5fcGF0aF9lcnJfdGhy
ZXNob2xkID0gREVGQVVMVF9FUlJfQ0hFQ0tTOworCWNvbmYtPnNhbl9wYXRoX2Vycl9mb3JnZXRf
cmF0ZSA9IERFRkFVTFRfRVJSX0NIRUNLUzsKKwljb25mLT5zYW5fcGF0aF9lcnJfcmVjb3Zlcnlf
dGltZSA9IERFRkFVTFRfRVJSX0NIRUNLUzsKIAogCS8qCiAJICogcHJlbG9hZCBkZWZhdWx0IGh3
dGFibGUKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jb25maWcuaCBiL2xpYm11bHRpcGF0aC9j
b25maWcuaAppbmRleCA5NjcwMDIwLi45ZTQ3ODk0IDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
Y29uZmlnLmgKKysrIGIvbGlibXVsdGlwYXRoL2NvbmZpZy5oCkBAIC02NSw2ICs2NSw5IEBAIHN0
cnVjdCBod2VudHJ5IHsKIAlpbnQgZGVmZXJyZWRfcmVtb3ZlOwogCWludCBkZWxheV93YXRjaF9j
aGVja3M7CiAJaW50IGRlbGF5X3dhaXRfY2hlY2tzOworCWludCBzYW5fcGF0aF9lcnJfdGhyZXNo
b2xkOworCWludCBzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGU7CisJaW50IHNhbl9wYXRoX2Vycl9y
ZWNvdmVyeV90aW1lOwogCWludCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3RvcnNfa2I7CiAJ
Y2hhciAqIGJsX3Byb2R1Y3Q7CkBAIC05Myw2ICs5Niw5IEBAIHN0cnVjdCBtcGVudHJ5IHsKIAlp
bnQgZGVmZXJyZWRfcmVtb3ZlOwogCWludCBkZWxheV93YXRjaF9jaGVja3M7CiAJaW50IGRlbGF5
X3dhaXRfY2hlY2tzOworCWludCBzYW5fcGF0aF9lcnJfdGhyZXNob2xkOworCWludCBzYW5fcGF0
aF9lcnJfZm9yZ2V0X3JhdGU7CisJaW50IHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lOwogCWlu
dCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3RvcnNfa2I7CiAJdWlkX3QgdWlkOwpAQCAtMTM4
LDYgKzE0NCw5IEBAIHN0cnVjdCBjb25maWcgewogCWludCBwcm9jZXNzZWRfbWFpbl9jb25maWc7
CiAJaW50IGRlbGF5X3dhdGNoX2NoZWNrczsKIAlpbnQgZGVsYXlfd2FpdF9jaGVja3M7CisJaW50
IHNhbl9wYXRoX2Vycl90aHJlc2hvbGQ7CisJaW50IHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZTsK
KwlpbnQgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWU7CiAJaW50IHV4c29ja190aW1lb3V0Owog
CWludCBzdHJpY3RfdGltaW5nOwogCWludCByZXRyaWdnZXJfdHJpZXM7CmRpZmYgLS1naXQgYS9s
aWJtdWx0aXBhdGgvY29uZmlndXJlLmMgYi9saWJtdWx0aXBhdGgvY29uZmlndXJlLmMKaW5kZXgg
YTBmY2FkOS4uNWFkMzAwNyAxMDA2NDQKLS0tIGEvbGlibXVsdGlwYXRoL2NvbmZpZ3VyZS5jCisr
KyBiL2xpYm11bHRpcGF0aC9jb25maWd1cmUuYwpAQCAtMjk0LDYgKzI5NCw5IEBAIGludCBzZXR1
cF9tYXAoc3RydWN0IG11bHRpcGF0aCAqbXBwLCBjaGFyICpwYXJhbXMsIGludCBwYXJhbXNfc2l6
ZSkKIAlzZWxlY3RfZGVmZXJyZWRfcmVtb3ZlKGNvbmYsIG1wcCk7CiAJc2VsZWN0X2RlbGF5X3dh
dGNoX2NoZWNrcyhjb25mLCBtcHApOwogCXNlbGVjdF9kZWxheV93YWl0X2NoZWNrcyhjb25mLCBt
cHApOworCXNlbGVjdF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkKGNvbmYsIG1wcCk7CisJc2VsZWN0
X3Nhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZShjb25mLCBtcHApOworCXNlbGVjdF9zYW5fcGF0aF9l
cnJfcmVjb3ZlcnlfdGltZShjb25mLCBtcHApOwogCXNlbGVjdF9za2lwX2twYXJ0eChjb25mLCBt
cHApOwogCXNlbGVjdF9tYXhfc2VjdG9yc19rYihjb25mLCBtcHApOwogCmRpZmYgLS1naXQgYS9s
aWJtdWx0aXBhdGgvZGVmYXVsdHMuaCBiL2xpYm11bHRpcGF0aC9kZWZhdWx0cy5oCmluZGV4IGI5
YjBhMzcuLjNlZjE1NzkgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9kZWZhdWx0cy5oCisrKyBi
L2xpYm11bHRpcGF0aC9kZWZhdWx0cy5oCkBAIC0yMyw3ICsyMyw4IEBACiAjZGVmaW5lIERFRkFV
TFRfUkVUQUlOX0hXSEFORExFUiBSRVRBSU5fSFdIQU5ETEVSX09OCiAjZGVmaW5lIERFRkFVTFRf
REVURUNUX1BSSU8JREVURUNUX1BSSU9fT04KICNkZWZpbmUgREVGQVVMVF9ERUZFUlJFRF9SRU1P
VkUJREVGRVJSRURfUkVNT1ZFX09GRgotI2RlZmluZSBERUZBVUxUX0RFTEFZX0NIRUNLUwlERUxB
WV9DSEVDS1NfT0ZGCisjZGVmaW5lIERFRkFVTFRfREVMQVlfQ0hFQ0tTCU5VX05PCisjZGVmaW5l
IERFRkFVTFRfRVJSX0NIRUNLUwlOVV9OTwogI2RlZmluZSBERUZBVUxUX1VFVkVOVF9TVEFDS1NJ
WkUgMjU2CiAjZGVmaW5lIERFRkFVTFRfUkVUUklHR0VSX0RFTEFZCTEwCiAjZGVmaW5lIERFRkFV
TFRfUkVUUklHR0VSX1RSSUVTCTMKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kaWN0LmMgYi9s
aWJtdWx0aXBhdGgvZGljdC5jCmluZGV4IGRjMjE4NDYuLmFlOTRjODggMTAwNjQ0Ci0tLSBhL2xp
Ym11bHRpcGF0aC9kaWN0LmMKKysrIGIvbGlibXVsdGlwYXRoL2RpY3QuYwpAQCAtMTAyMyw3ICsx
MDIzLDcgQEAgZGVjbGFyZV9tcF9oYW5kbGVyKHJlc2VydmF0aW9uX2tleSwgc2V0X3Jlc2VydmF0
aW9uX2tleSkKIGRlY2xhcmVfbXBfc25wcmludChyZXNlcnZhdGlvbl9rZXksIHByaW50X3Jlc2Vy
dmF0aW9uX2tleSkKIAogc3RhdGljIGludAotc2V0X2RlbGF5X2NoZWNrcyh2ZWN0b3Igc3RydmVj
LCB2b2lkICpwdHIpCitzZXRfb2ZmX2ludF91bmRlZih2ZWN0b3Igc3RydmVjLCB2b2lkICpwdHIp
CiB7CiAJaW50ICppbnRfcHRyID0gKGludCAqKXB0cjsKIAljaGFyICogYnVmZjsKQEAgLTEwMzMs
NDcgKzEwMzMsNjkgQEAgc2V0X2RlbGF5X2NoZWNrcyh2ZWN0b3Igc3RydmVjLCB2b2lkICpwdHIp
CiAJCXJldHVybiAxOwogCiAJaWYgKCFzdHJjbXAoYnVmZiwgIm5vIikgfHwgIXN0cmNtcChidWZm
LCAiMCIpKQotCQkqaW50X3B0ciA9IERFTEFZX0NIRUNLU19PRkY7CisJCSppbnRfcHRyID0gTlVf
Tk87CiAJZWxzZSBpZiAoKCppbnRfcHRyID0gYXRvaShidWZmKSkgPCAxKQotCQkqaW50X3B0ciA9
IERFTEFZX0NIRUNLU19VTkRFRjsKKwkJKmludF9wdHIgPSBOVV9VTkRFRjsKIAogCUZSRUUoYnVm
Zik7CiAJcmV0dXJuIDA7CiB9CiAKIGludAotcHJpbnRfZGVsYXlfY2hlY2tzKGNoYXIgKiBidWZm
LCBpbnQgbGVuLCB2b2lkICpwdHIpCitwcmludF9vZmZfaW50X3VuZGVmKGNoYXIgKiBidWZmLCBp
bnQgbGVuLCB2b2lkICpwdHIpCiB7CiAJaW50ICppbnRfcHRyID0gKGludCAqKXB0cjsKIAogCXN3
aXRjaCgqaW50X3B0cikgewotCWNhc2UgREVMQVlfQ0hFQ0tTX1VOREVGOgorCWNhc2UgTlVfVU5E
RUY6CiAJCXJldHVybiAwOwotCWNhc2UgREVMQVlfQ0hFQ0tTX09GRjoKLQkJcmV0dXJuIHNucHJp
bnRmKGJ1ZmYsIGxlbiwgIlwib2ZmXCIiKTsKKwljYXNlIE5VX05POgorCQlyZXR1cm4gc25wcmlu
dGYoYnVmZiwgbGVuLCAiXCJub1wiIik7CiAJZGVmYXVsdDoKIAkJcmV0dXJuIHNucHJpbnRmKGJ1
ZmYsIGxlbiwgIiVpIiwgKmludF9wdHIpOwogCX0KIH0KIAotZGVjbGFyZV9kZWZfaGFuZGxlcihk
ZWxheV93YXRjaF9jaGVja3MsIHNldF9kZWxheV9jaGVja3MpCi1kZWNsYXJlX2RlZl9zbnByaW50
KGRlbGF5X3dhdGNoX2NoZWNrcywgcHJpbnRfZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9vdnJfaGFu
ZGxlcihkZWxheV93YXRjaF9jaGVja3MsIHNldF9kZWxheV9jaGVja3MpCi1kZWNsYXJlX292cl9z
bnByaW50KGRlbGF5X3dhdGNoX2NoZWNrcywgcHJpbnRfZGVsYXlfY2hlY2tzKQotZGVjbGFyZV9o
d19oYW5kbGVyKGRlbGF5X3dhdGNoX2NoZWNrcywgc2V0X2RlbGF5X2NoZWNrcykKLWRlY2xhcmVf
aHdfc25wcmludChkZWxheV93YXRjaF9jaGVja3MsIHByaW50X2RlbGF5X2NoZWNrcykKLWRlY2xh
cmVfbXBfaGFuZGxlcihkZWxheV93YXRjaF9jaGVja3MsIHNldF9kZWxheV9jaGVja3MpCi1kZWNs
YXJlX21wX3NucHJpbnQoZGVsYXlfd2F0Y2hfY2hlY2tzLCBwcmludF9kZWxheV9jaGVja3MpCi0K
LWRlY2xhcmVfZGVmX2hhbmRsZXIoZGVsYXlfd2FpdF9jaGVja3MsIHNldF9kZWxheV9jaGVja3Mp
Ci1kZWNsYXJlX2RlZl9zbnByaW50KGRlbGF5X3dhaXRfY2hlY2tzLCBwcmludF9kZWxheV9jaGVj
a3MpCi1kZWNsYXJlX292cl9oYW5kbGVyKGRlbGF5X3dhaXRfY2hlY2tzLCBzZXRfZGVsYXlfY2hl
Y2tzKQotZGVjbGFyZV9vdnJfc25wcmludChkZWxheV93YWl0X2NoZWNrcywgcHJpbnRfZGVsYXlf
Y2hlY2tzKQotZGVjbGFyZV9od19oYW5kbGVyKGRlbGF5X3dhaXRfY2hlY2tzLCBzZXRfZGVsYXlf
Y2hlY2tzKQotZGVjbGFyZV9od19zbnByaW50KGRlbGF5X3dhaXRfY2hlY2tzLCBwcmludF9kZWxh
eV9jaGVja3MpCi1kZWNsYXJlX21wX2hhbmRsZXIoZGVsYXlfd2FpdF9jaGVja3MsIHNldF9kZWxh
eV9jaGVja3MpCi1kZWNsYXJlX21wX3NucHJpbnQoZGVsYXlfd2FpdF9jaGVja3MsIHByaW50X2Rl
bGF5X2NoZWNrcykKLQorZGVjbGFyZV9kZWZfaGFuZGxlcihkZWxheV93YXRjaF9jaGVja3MsIHNl
dF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9kZWZfc25wcmludChkZWxheV93YXRjaF9jaGVja3Ms
IHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX292cl9oYW5kbGVyKGRlbGF5X3dhdGNoX2No
ZWNrcywgc2V0X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX292cl9zbnByaW50KGRlbGF5X3dhdGNo
X2NoZWNrcywgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfaHdfaGFuZGxlcihkZWxheV93
YXRjaF9jaGVja3MsIHNldF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9od19zbnByaW50KGRlbGF5
X3dhdGNoX2NoZWNrcywgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfbXBfaGFuZGxlcihk
ZWxheV93YXRjaF9jaGVja3MsIHNldF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9tcF9zbnByaW50
KGRlbGF5X3dhdGNoX2NoZWNrcywgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfZGVmX2hh
bmRsZXIoZGVsYXlfd2FpdF9jaGVja3MsIHNldF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9kZWZf
c25wcmludChkZWxheV93YWl0X2NoZWNrcywgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVf
b3ZyX2hhbmRsZXIoZGVsYXlfd2FpdF9jaGVja3MsIHNldF9vZmZfaW50X3VuZGVmKQorZGVjbGFy
ZV9vdnJfc25wcmludChkZWxheV93YWl0X2NoZWNrcywgcHJpbnRfb2ZmX2ludF91bmRlZikKK2Rl
Y2xhcmVfaHdfaGFuZGxlcihkZWxheV93YWl0X2NoZWNrcywgc2V0X29mZl9pbnRfdW5kZWYpCitk
ZWNsYXJlX2h3X3NucHJpbnQoZGVsYXlfd2FpdF9jaGVja3MsIHByaW50X29mZl9pbnRfdW5kZWYp
CitkZWNsYXJlX21wX2hhbmRsZXIoZGVsYXlfd2FpdF9jaGVja3MsIHNldF9vZmZfaW50X3VuZGVm
KQorZGVjbGFyZV9tcF9zbnByaW50KGRlbGF5X3dhaXRfY2hlY2tzLCBwcmludF9vZmZfaW50X3Vu
ZGVmKQorZGVjbGFyZV9kZWZfaGFuZGxlcihzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBzZXRfb2Zm
X2ludF91bmRlZikKK2RlY2xhcmVfZGVmX3NucHJpbnQoc2FuX3BhdGhfZXJyX3RocmVzaG9sZCwg
cHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfb3ZyX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZCwgc2V0X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX292cl9zbnByaW50KHNhbl9wYXRo
X2Vycl90aHJlc2hvbGQsIHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX2h3X2hhbmRsZXIo
c2FuX3BhdGhfZXJyX3RocmVzaG9sZCwgc2V0X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX2h3X3Nu
cHJpbnQoc2FuX3BhdGhfZXJyX3RocmVzaG9sZCwgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xh
cmVfbXBfaGFuZGxlcihzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBzZXRfb2ZmX2ludF91bmRlZikK
K2RlY2xhcmVfbXBfc25wcmludChzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBwcmludF9vZmZfaW50
X3VuZGVmKQorZGVjbGFyZV9kZWZfaGFuZGxlcihzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUsIHNl
dF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9kZWZfc25wcmludChzYW5fcGF0aF9lcnJfZm9yZ2V0
X3JhdGUsIHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX292cl9oYW5kbGVyKHNhbl9wYXRo
X2Vycl9mb3JnZXRfcmF0ZSwgc2V0X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX292cl9zbnByaW50
KHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSwgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVf
aHdfaGFuZGxlcihzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUsIHNldF9vZmZfaW50X3VuZGVmKQor
ZGVjbGFyZV9od19zbnByaW50KHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSwgcHJpbnRfb2ZmX2lu
dF91bmRlZikKK2RlY2xhcmVfbXBfaGFuZGxlcihzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUsIHNl
dF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9tcF9zbnByaW50KHNhbl9wYXRoX2Vycl9mb3JnZXRf
cmF0ZSwgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfZGVmX2hhbmRsZXIoc2FuX3BhdGhf
ZXJyX3JlY292ZXJ5X3RpbWUsIHNldF9vZmZfaW50X3VuZGVmKQorZGVjbGFyZV9kZWZfc25wcmlu
dChzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSwgcHJpbnRfb2ZmX2ludF91bmRlZikKK2RlY2xh
cmVfb3ZyX2hhbmRsZXIoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHNldF9vZmZfaW50X3Vu
ZGVmKQorZGVjbGFyZV9vdnJfc25wcmludChzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSwgcHJp
bnRfb2ZmX2ludF91bmRlZikKK2RlY2xhcmVfaHdfaGFuZGxlcihzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZSwgc2V0X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX2h3X3NucHJpbnQoc2FuX3BhdGhf
ZXJyX3JlY292ZXJ5X3RpbWUsIHByaW50X29mZl9pbnRfdW5kZWYpCitkZWNsYXJlX21wX2hhbmRs
ZXIoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUsIHNldF9vZmZfaW50X3VuZGVmKQorZGVjbGFy
ZV9tcF9zbnByaW50KHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lLCBwcmludF9vZmZfaW50X3Vu
ZGVmKQogc3RhdGljIGludAogZGVmX3V4c29ja190aW1lb3V0X2hhbmRsZXIoc3RydWN0IGNvbmZp
ZyAqY29uZiwgdmVjdG9yIHN0cnZlYykKIHsKQEAgLTE0MDQsNiArMTQyNiwxMCBAQCBpbml0X2tl
eXdvcmRzKHZlY3RvciBrZXl3b3JkcykKIAlpbnN0YWxsX2tleXdvcmQoImNvbmZpZ19kaXIiLCAm
ZGVmX2NvbmZpZ19kaXJfaGFuZGxlciwgJnNucHJpbnRfZGVmX2NvbmZpZ19kaXIpOwogCWluc3Rh
bGxfa2V5d29yZCgiZGVsYXlfd2F0Y2hfY2hlY2tzIiwgJmRlZl9kZWxheV93YXRjaF9jaGVja3Nf
aGFuZGxlciwgJnNucHJpbnRfZGVmX2RlbGF5X3dhdGNoX2NoZWNrcyk7CiAJaW5zdGFsbF9rZXl3
b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZkZWZfZGVsYXlfd2FpdF9jaGVja3NfaGFuZGxlciwg
JnNucHJpbnRfZGVmX2RlbGF5X3dhaXRfY2hlY2tzKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3Jk
KCJzYW5fcGF0aF9lcnJfdGhyZXNob2xkIiwgJmRlZl9zYW5fcGF0aF9lcnJfdGhyZXNob2xkX2hh
bmRsZXIsICZzbnByaW50X2RlZl9zYW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAgICAgaW5z
dGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUiLCAmZGVmX3Nhbl9wYXRoX2Vy
cl9mb3JnZXRfcmF0ZV9oYW5kbGVyLCAmc25wcmludF9kZWZfc2FuX3BhdGhfZXJyX2ZvcmdldF9y
YXRlKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGlt
ZSIsICZkZWZfc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJpbnRfZGVm
X3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKKwogCWluc3RhbGxfa2V5d29yZCgiZmluZF9t
dWx0aXBhdGhzIiwgJmRlZl9maW5kX211bHRpcGF0aHNfaGFuZGxlciwgJnNucHJpbnRfZGVmX2Zp
bmRfbXVsdGlwYXRocyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJ1eHNvY2tfdGltZW91dCIsICZkZWZf
dXhzb2NrX3RpbWVvdXRfaGFuZGxlciwgJnNucHJpbnRfZGVmX3V4c29ja190aW1lb3V0KTsKIAlp
bnN0YWxsX2tleXdvcmQoInJldHJpZ2dlcl90cmllcyIsICZkZWZfcmV0cmlnZ2VyX3RyaWVzX2hh
bmRsZXIsICZzbnByaW50X2RlZl9yZXRyaWdnZXJfdHJpZXMpOwpAQCAtMTQ4Niw2ICsxNTEyLDkg
QEAgaW5pdF9rZXl3b3Jkcyh2ZWN0b3Iga2V5d29yZHMpCiAJaW5zdGFsbF9rZXl3b3JkKCJkZWZl
cnJlZF9yZW1vdmUiLCAmaHdfZGVmZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X2h3X2Rl
ZmVycmVkX3JlbW92ZSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YXRjaF9jaGVja3MiLCAm
aHdfZGVsYXlfd2F0Y2hfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X2h3X2RlbGF5X3dhdGNoX2No
ZWNrcyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZod19kZWxheV93
YWl0X2NoZWNrc19oYW5kbGVyLCAmc25wcmludF9od19kZWxheV93YWl0X2NoZWNrcyk7CisgICAg
ICAgIGluc3RhbGxfa2V5d29yZCgic2FuX3BhdGhfZXJyX3RocmVzaG9sZCIsICZod19zYW5fcGF0
aF9lcnJfdGhyZXNob2xkX2hhbmRsZXIsICZzbnByaW50X2h3X3Nhbl9wYXRoX2Vycl90aHJlc2hv
bGQpOworICAgICAgICBpbnN0YWxsX2tleXdvcmQoInNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSIs
ICZod19zYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGVfaGFuZGxlciwgJnNucHJpbnRfaHdfc2FuX3Bh
dGhfZXJyX2ZvcmdldF9yYXRlKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9l
cnJfcmVjb3ZlcnlfdGltZSIsICZod19zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZV9oYW5kbGVy
LCAmc25wcmludF9od19zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CiAJaW5zdGFsbF9rZXl3
b3JkKCJza2lwX2twYXJ0eCIsICZod19za2lwX2twYXJ0eF9oYW5kbGVyLCAmc25wcmludF9od19z
a2lwX2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJtYXhfc2VjdG9yc19rYiIsICZod19tYXhf
c2VjdG9yc19rYl9oYW5kbGVyLCAmc25wcmludF9od19tYXhfc2VjdG9yc19rYik7CiAJaW5zdGFs
bF9zdWJsZXZlbF9lbmQoKTsKQEAgLTE1MTUsNiArMTU0NCwxMCBAQCBpbml0X2tleXdvcmRzKHZl
Y3RvciBrZXl3b3JkcykKIAlpbnN0YWxsX2tleXdvcmQoImRlZmVycmVkX3JlbW92ZSIsICZvdnJf
ZGVmZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZzbnByaW50X292cl9kZWZlcnJlZF9yZW1vdmUpOwog
CWluc3RhbGxfa2V5d29yZCgiZGVsYXlfd2F0Y2hfY2hlY2tzIiwgJm92cl9kZWxheV93YXRjaF9j
aGVja3NfaGFuZGxlciwgJnNucHJpbnRfb3ZyX2RlbGF5X3dhdGNoX2NoZWNrcyk7CiAJaW5zdGFs
bF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNrcyIsICZvdnJfZGVsYXlfd2FpdF9jaGVja3NfaGFu
ZGxlciwgJnNucHJpbnRfb3ZyX2RlbGF5X3dhaXRfY2hlY2tzKTsKKyAgICAgICAgaW5zdGFsbF9r
ZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNob2xkIiwgJm92cl9zYW5fcGF0aF9lcnJfdGhyZXNo
b2xkX2hhbmRsZXIsICZzbnByaW50X292cl9zYW5fcGF0aF9lcnJfdGhyZXNob2xkKTsKKyAgICAg
ICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUiLCAmb3ZyX3Nhbl9w
YXRoX2Vycl9mb3JnZXRfcmF0ZV9oYW5kbGVyLCAmc25wcmludF9vdnJfc2FuX3BhdGhfZXJyX2Zv
cmdldF9yYXRlKTsKKyAgICAgICAgaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZSIsICZvdnJfc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWVfaGFuZGxlciwgJnNucHJp
bnRfb3ZyX3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKTsKKwogCWluc3RhbGxfa2V5d29yZCgi
c2tpcF9rcGFydHgiLCAmb3ZyX3NraXBfa3BhcnR4X2hhbmRsZXIsICZzbnByaW50X292cl9za2lw
X2twYXJ0eCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJtYXhfc2VjdG9yc19rYiIsICZvdnJfbWF4X3Nl
Y3RvcnNfa2JfaGFuZGxlciwgJnNucHJpbnRfb3ZyX21heF9zZWN0b3JzX2tiKTsKIApAQCAtMTU0
Myw2ICsxNTc2LDkgQEAgaW5pdF9rZXl3b3Jkcyh2ZWN0b3Iga2V5d29yZHMpCiAJaW5zdGFsbF9r
ZXl3b3JkKCJkZWZlcnJlZF9yZW1vdmUiLCAmbXBfZGVmZXJyZWRfcmVtb3ZlX2hhbmRsZXIsICZz
bnByaW50X21wX2RlZmVycmVkX3JlbW92ZSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YXRj
aF9jaGVja3MiLCAmbXBfZGVsYXlfd2F0Y2hfY2hlY2tzX2hhbmRsZXIsICZzbnByaW50X21wX2Rl
bGF5X3dhdGNoX2NoZWNrcyk7CiAJaW5zdGFsbF9rZXl3b3JkKCJkZWxheV93YWl0X2NoZWNrcyIs
ICZtcF9kZWxheV93YWl0X2NoZWNrc19oYW5kbGVyLCAmc25wcmludF9tcF9kZWxheV93YWl0X2No
ZWNrcyk7CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfdGhyZXNob2xkIiwgJm1wX3Nh
bl9wYXRoX2Vycl90aHJlc2hvbGRfaGFuZGxlciwgJnNucHJpbnRfbXBfc2FuX3BhdGhfZXJyX3Ro
cmVzaG9sZCk7CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUiLCAm
bXBfc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlX2hhbmRsZXIsICZzbnByaW50X21wX3Nhbl9wYXRo
X2Vycl9mb3JnZXRfcmF0ZSk7CisJaW5zdGFsbF9rZXl3b3JkKCJzYW5fcGF0aF9lcnJfcmVjb3Zl
cnlfdGltZSIsICZtcF9zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZV9oYW5kbGVyLCAmc25wcmlu
dF9tcF9zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CiAJaW5zdGFsbF9rZXl3b3JkKCJza2lw
X2twYXJ0eCIsICZtcF9za2lwX2twYXJ0eF9oYW5kbGVyLCAmc25wcmludF9tcF9za2lwX2twYXJ0
eCk7CiAJaW5zdGFsbF9rZXl3b3JkKCJtYXhfc2VjdG9yc19rYiIsICZtcF9tYXhfc2VjdG9yc19r
Yl9oYW5kbGVyLCAmc25wcmludF9tcF9tYXhfc2VjdG9yc19rYik7CiAJaW5zdGFsbF9zdWJsZXZl
bF9lbmQoKTsKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kaWN0LmggYi9saWJtdWx0aXBhdGgv
ZGljdC5oCmluZGV4IDRjZDAzYzUuLjJkNjA5N2QgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9k
aWN0LmgKKysrIGIvbGlibXVsdGlwYXRoL2RpY3QuaApAQCAtMTQsNiArMTQsNSBAQCBpbnQgcHJp
bnRfbm9fcGF0aF9yZXRyeShjaGFyICogYnVmZiwgaW50IGxlbiwgdm9pZCAqcHRyKTsKIGludCBw
cmludF9mYXN0X2lvX2ZhaWwoY2hhciAqIGJ1ZmYsIGludCBsZW4sIHZvaWQgKnB0cik7CiBpbnQg
cHJpbnRfZGV2X2xvc3MoY2hhciAqIGJ1ZmYsIGludCBsZW4sIHZvaWQgKnB0cik7CiBpbnQgcHJp
bnRfcmVzZXJ2YXRpb25fa2V5KGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICogcHRyKTsKLWlu
dCBwcmludF9kZWxheV9jaGVja3MoY2hhciAqIGJ1ZmYsIGludCBsZW4sIHZvaWQgKnB0cik7Ci0K
K2ludCBwcmludF9vZmZfaW50X3VuZGVmKGNoYXIgKiBidWZmLCBpbnQgbGVuLCB2b2lkICpwdHIp
OwogI2VuZGlmIC8qIF9ESUNUX0ggKi8KZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9wcm9wc2Vs
LmMgYi9saWJtdWx0aXBhdGgvcHJvcHNlbC5jCmluZGV4IGMwYmM2MTYuLmU0YWZlZjcgMTAwNjQ0
Ci0tLSBhL2xpYm11bHRpcGF0aC9wcm9wc2VsLmMKKysrIGIvbGlibXVsdGlwYXRoL3Byb3BzZWwu
YwpAQCAtNjIzLDcgKzYyMyw3IEBAIGludCBzZWxlY3RfZGVsYXlfd2F0Y2hfY2hlY2tzKHN0cnVj
dCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKm1wKQogCW1wX3NldF9jb25mKGRlbGF5
X3dhdGNoX2NoZWNrcyk7CiAJbXBfc2V0X2RlZmF1bHQoZGVsYXlfd2F0Y2hfY2hlY2tzLCBERUZB
VUxUX0RFTEFZX0NIRUNLUyk7CiBvdXQ6Ci0JcHJpbnRfZGVsYXlfY2hlY2tzKGJ1ZmYsIDEyLCAm
bXAtPmRlbGF5X3dhdGNoX2NoZWNrcyk7CisJcHJpbnRfb2ZmX2ludF91bmRlZihidWZmLCAxMiwg
Jm1wLT5kZWxheV93YXRjaF9jaGVja3MpOwogCWNvbmRsb2coMywgIiVzOiBkZWxheV93YXRjaF9j
aGVja3MgPSAlcyAlcyIsIG1wLT5hbGlhcywgYnVmZiwgb3JpZ2luKTsKIAlyZXR1cm4gMDsKIH0K
QEAgLTYzOCwxMiArNjM4LDU2IEBAIGludCBzZWxlY3RfZGVsYXlfd2FpdF9jaGVja3Moc3RydWN0
IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApCiAJbXBfc2V0X2NvbmYoZGVsYXlf
d2FpdF9jaGVja3MpOwogCW1wX3NldF9kZWZhdWx0KGRlbGF5X3dhaXRfY2hlY2tzLCBERUZBVUxU
X0RFTEFZX0NIRUNLUyk7CiBvdXQ6Ci0JcHJpbnRfZGVsYXlfY2hlY2tzKGJ1ZmYsIDEyLCAmbXAt
PmRlbGF5X3dhaXRfY2hlY2tzKTsKKwlwcmludF9vZmZfaW50X3VuZGVmKGJ1ZmYsIDEyLCAmbXAt
PmRlbGF5X3dhaXRfY2hlY2tzKTsKIAljb25kbG9nKDMsICIlczogZGVsYXlfd2FpdF9jaGVja3Mg
PSAlcyAlcyIsIG1wLT5hbGlhcywgYnVmZiwgb3JpZ2luKTsKIAlyZXR1cm4gMDsKIAogfQoraW50
IHNlbGVjdF9zYW5fcGF0aF9lcnJfdGhyZXNob2xkKHN0cnVjdCBjb25maWcgKmNvbmYsIHN0cnVj
dCBtdWx0aXBhdGggKm1wKQoreworICAgICAgICBjaGFyICpvcmlnaW4sIGJ1ZmZbMTJdOworCisg
ICAgICAgIG1wX3NldF9tcGUoc2FuX3BhdGhfZXJyX3RocmVzaG9sZCk7CisgICAgICAgIG1wX3Nl
dF9vdnIoc2FuX3BhdGhfZXJyX3RocmVzaG9sZCk7CisgICAgICAgIG1wX3NldF9od2Uoc2FuX3Bh
dGhfZXJyX3RocmVzaG9sZCk7CisgICAgICAgIG1wX3NldF9jb25mKHNhbl9wYXRoX2Vycl90aHJl
c2hvbGQpOworICAgICAgICBtcF9zZXRfZGVmYXVsdChzYW5fcGF0aF9lcnJfdGhyZXNob2xkLCBE
RUZBVUxUX0VSUl9DSEVDS1MpOworb3V0OgorICAgICAgICBwcmludF9vZmZfaW50X3VuZGVmKGJ1
ZmYsIDEyLCAmbXAtPnNhbl9wYXRoX2Vycl90aHJlc2hvbGQpOworICAgICAgICBjb25kbG9nKDMs
ICIlczogc2FuX3BhdGhfZXJyX3RocmVzaG9sZCA9ICVzICVzIiwgbXAtPmFsaWFzLCBidWZmLCBv
cmlnaW4pOworICAgICAgICByZXR1cm4gMDsKK30KKworaW50IHNlbGVjdF9zYW5fcGF0aF9lcnJf
Zm9yZ2V0X3JhdGUoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApCit7
CisgICAgICAgIGNoYXIgKm9yaWdpbiwgYnVmZlsxMl07CisKKyAgICAgICAgbXBfc2V0X21wZShz
YW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUpOworICAgICAgICBtcF9zZXRfb3ZyKHNhbl9wYXRoX2Vy
cl9mb3JnZXRfcmF0ZSk7CisgICAgICAgIG1wX3NldF9od2Uoc2FuX3BhdGhfZXJyX2ZvcmdldF9y
YXRlKTsKKyAgICAgICAgbXBfc2V0X2NvbmYoc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlKTsKKyAg
ICAgICAgbXBfc2V0X2RlZmF1bHQoc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlLCBERUZBVUxUX0VS
Ul9DSEVDS1MpOworb3V0OgorICAgICAgICBwcmludF9vZmZfaW50X3VuZGVmKGJ1ZmYsIDEyLCAm
bXAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZSk7CisgICAgICAgIGNvbmRsb2coMywgIiVzOiBz
YW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUgPSAlcyAlcyIsIG1wLT5hbGlhcywgYnVmZiwgb3JpZ2lu
KTsKKyAgICAgICAgcmV0dXJuIDA7CisKK30KK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX3JlY292
ZXJ5X3RpbWUoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqbXApCit7Cisg
ICAgICAgIGNoYXIgKm9yaWdpbiwgYnVmZlsxMl07CiAKKyAgICAgICAgbXBfc2V0X21wZShzYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CisgICAgICAgIG1wX3NldF9vdnIoc2FuX3BhdGhfZXJy
X3JlY292ZXJ5X3RpbWUpOworICAgICAgICBtcF9zZXRfaHdlKHNhbl9wYXRoX2Vycl9yZWNvdmVy
eV90aW1lKTsKKyAgICAgICAgbXBfc2V0X2NvbmYoc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUp
OworICAgICAgICBtcF9zZXRfZGVmYXVsdChzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSwgREVG
QVVMVF9FUlJfQ0hFQ0tTKTsKK291dDoKKyAgICAgICAgcHJpbnRfb2ZmX2ludF91bmRlZihidWZm
LCAxMiwgJm1wLT5zYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSk7CisgICAgICAgIGNvbmRsb2co
MywgIiVzOiBzYW5fcGF0aF9lcnJfcmVjb3ZlcnlfdGltZSA9ICVzICVzIiwgbXAtPmFsaWFzLCBi
dWZmLCBvcmlnaW4pOworICAgICAgICByZXR1cm4gMDsKKworfQogaW50IHNlbGVjdF9za2lwX2tw
YXJ0eCAoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0IG11bHRpcGF0aCAqIG1wKQogewogCWNo
YXIgKm9yaWdpbjsKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9wcm9wc2VsLmggYi9saWJtdWx0
aXBhdGgvcHJvcHNlbC5oCmluZGV4IGFkOThmYTUuLmU1YjZmOTMgMTAwNjQ0Ci0tLSBhL2xpYm11
bHRpcGF0aC9wcm9wc2VsLmgKKysrIGIvbGlibXVsdGlwYXRoL3Byb3BzZWwuaApAQCAtMjQsMyAr
MjQsNiBAQCBpbnQgc2VsZWN0X2RlbGF5X3dhdGNoX2NoZWNrcyAoc3RydWN0IGNvbmZpZyAqY29u
Ziwgc3RydWN0IG11bHRpcGF0aCAqIG1wKTsKIGludCBzZWxlY3RfZGVsYXlfd2FpdF9jaGVja3Mg
KHN0cnVjdCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKiBtcCk7CiBpbnQgc2VsZWN0
X3NraXBfa3BhcnR4IChzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVsdGlwYXRoICogbXAp
OwogaW50IHNlbGVjdF9tYXhfc2VjdG9yc19rYiAoc3RydWN0IGNvbmZpZyAqY29uZiwgc3RydWN0
IG11bHRpcGF0aCAqIG1wKTsKK2ludCBzZWxlY3Rfc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlKHN0
cnVjdCBjb25maWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKm1wKTsKK2ludCBzZWxlY3Rfc2Fu
X3BhdGhfZXJyX3RocmVzaG9sZChzdHJ1Y3QgY29uZmlnICpjb25mLCBzdHJ1Y3QgbXVsdGlwYXRo
ICptcCk7CitpbnQgc2VsZWN0X3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lKHN0cnVjdCBjb25m
aWcgKmNvbmYsIHN0cnVjdCBtdWx0aXBhdGggKm1wKTsKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0
aC9zdHJ1Y3RzLmggYi9saWJtdWx0aXBhdGgvc3RydWN0cy5oCmluZGV4IDM5NmY2OWQuLjZlZGQ5
MjcgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9zdHJ1Y3RzLmgKKysrIGIvbGlibXVsdGlwYXRo
L3N0cnVjdHMuaApAQCAtMTUyLDkgKzE1Miw5IEBAIGVudW0gc2NzaV9wcm90b2NvbCB7CiAJU0NT
SV9QUk9UT0NPTF9VTlNQRUMgPSAweGYsIC8qIE5vIHNwZWNpZmljIHByb3RvY29sICovCiB9Owog
Ci1lbnVtIGRlbGF5X2NoZWNrc19zdGF0ZXMgewotCURFTEFZX0NIRUNLU19PRkYgPSAtMSwKLQlE
RUxBWV9DSEVDS1NfVU5ERUYgPSAwLAorZW51bSBub191bmRlZl9zdGF0ZXMgeworCU5VX05PID0g
LTEsCisJTlVfVU5ERUYgPSAwLAogfTsKIAogZW51bSBpbml0aWFsaXplZF9zdGF0ZXMgewpAQCAt
MjIzLDcgKzIyMywxMCBAQCBzdHJ1Y3QgcGF0aCB7CiAJaW50IGluaXRpYWxpemVkOwogCWludCBy
ZXRyaWdnZXJzOwogCWludCB3d2lkX2NoYW5nZWQ7Ci0KKwl1bnNpZ25lZCBpbnQgcGF0aF9mYWls
dXJlczsKKwl0aW1lX3QgZGlzX3JlaW5zdGF0ZV90aW1lOworCWludCBkaXNhYmxlX3JlaW5zdGF0
ZTsKKwlpbnQgc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlOwogCS8qIGNvbmZpZ2xldCBwb2ludGVy
cyAqLwogCXN0cnVjdCBod2VudHJ5ICogaHdlOwogfTsKQEAgLTI1NSw2ICsyNTgsOSBAQCBzdHJ1
Y3QgbXVsdGlwYXRoIHsKIAlpbnQgZGVmZXJyZWRfcmVtb3ZlOwogCWludCBkZWxheV93YXRjaF9j
aGVja3M7CiAJaW50IGRlbGF5X3dhaXRfY2hlY2tzOworCWludCBzYW5fcGF0aF9lcnJfdGhyZXNo
b2xkOworCWludCBzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGU7CisJaW50IHNhbl9wYXRoX2Vycl9y
ZWNvdmVyeV90aW1lOwogCWludCBza2lwX2twYXJ0eDsKIAlpbnQgbWF4X3NlY3RvcnNfa2I7CiAJ
dW5zaWduZWQgaW50IGRldl9sb3NzOwpkaWZmIC0tZ2l0IGEvbXVsdGlwYXRoL211bHRpcGF0aC5j
b25mLjUgYi9tdWx0aXBhdGgvbXVsdGlwYXRoLmNvbmYuNQppbmRleCAzNjU4OWY1Li4zYzU2NGFk
IDEwMDY0NAotLS0gYS9tdWx0aXBhdGgvbXVsdGlwYXRoLmNvbmYuNQorKysgYi9tdWx0aXBhdGgv
bXVsdGlwYXRoLmNvbmYuNQpAQCAtNzUxLDYgKzc1MSw0NSBAQCBUaGUgZGVmYXVsdCBpczogXGZC
L2V0Yy9tdWx0aXBhdGgvY29uZi5kL1xmUgogLgogLgogLlRQCisuQiBzYW5fcGF0aF9lcnJfdGhy
ZXNob2xkCitJZiBzZXQgdG8gYSB2YWx1ZSBncmVhdGVyIHRoYW4gMCwgbXVsdGlwYXRoZCB3aWxs
IHdhdGNoIHBhdGhzIGFuZCBjaGVjayBob3cgbWFueQordGltZXMgYSBwYXRoIGhhcyBiZWVuIGZh
aWxlZCBkdWUgdG8gZXJyb3JzLklmIHRoZSBudW1iZXIgb2YgZmFpbHVyZXMgb24gYSBwYXJ0aWN1
bGFyCitwYXRoIGlzIGdyZWF0ZXIgdGhlbiB0aGUgc2FuX3BhdGhfZXJyX3RocmVzaG9sZCB0aGVu
IHRoZSBwYXRoIHdpbGwgbm90ICByZWluc3RhbnRlCit0aWxsIHNhbl9wYXRoX2Vycl9yZWNvdmVy
eV90aW1lLlRoZXNlIHBhdGggZmFpbHVyZXMgc2hvdWxkIG9jY3VyIHdpdGhpbiBhIAorc2FuX3Bh
dGhfZXJyX2ZvcmdldF9yYXRlIGNoZWNrcywgaWYgbm90IHdlIHdpbGwgY29uc2lkZXIgdGhlIHBh
dGggaXMgZ29vZCBlbm91Z2gKK3RvIHJlaW5zdGFudGF0ZS4KKy5SUworLlRQCitUaGUgZGVmYXVs
dCBpczogXGZCbm9cZlIKKy5SRQorLgorLgorLlRQCisuQiBzYW5fcGF0aF9lcnJfZm9yZ2V0X3Jh
dGUKK0lmIHNldCB0byBhIHZhbHVlIGdyZWF0ZXIgdGhhbiAwLCBtdWx0aXBhdGhkIHdpbGwgY2hl
Y2sgd2hldGhlciB0aGUgcGF0aCBmYWlsdXJlcworaGFzIGV4Y2VlZGVkICB0aGUgc2FuX3BhdGhf
ZXJyX3RocmVzaG9sZCB3aXRoaW4gdGhpcyBtYW55IGNoZWNrcyBpLmUgCitzYW5fcGF0aF9lcnJf
Zm9yZ2V0X3JhdGUgLiBJZiBzbyB3ZSB3aWxsIG5vdCByZWluc3RhbnRlIHRoZSBwYXRoIHRpbGwK
K3Nhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lLgorLlJTCisuVFAKK1RoZSBkZWZhdWx0IGlzOiBc
ZkJub1xmUgorLlJFCisuCisuCisuVFAKKy5CIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCitJ
ZiBzZXQgdG8gYSB2YWx1ZSBncmVhdGVyIHRoYW4gMCwgbXVsdGlwYXRoZCB3aWxsIG1ha2Ugc3Vy
ZSB0aGF0IHdoZW4gcGF0aCBmYWlsdXJlcworaGFzIGV4Y2VlZGVkIHRoZSBzYW5fcGF0aF9lcnJf
dGhyZXNob2xkIHdpdGhpbiBzYW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUgdGhlbiB0aGUgcGF0aAor
d2lsbCBiZSBwbGFjZWQgaW4gZmFpbGVkIHN0YXRlIGZvciBzYW5fcGF0aF9lcnJfcmVjb3Zlcnlf
dGltZSBkdXJhdGlvbi5PbmNlIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCitoYXMgdGltZW91
dCAgd2Ugd2lsbCByZWluc3RhbnRlIHRoZSBmYWlsZWQgcGF0aCAuCitzYW5fcGF0aF9lcnJfcmVj
b3ZlcnlfdGltZSB2YWx1ZSBzaG91bGQgYmUgaW4gc2Vjcy4KKy5SUworLlRQCitUaGUgZGVmYXVs
dCBpczogXGZCbm9cZlIKKy5SRQorLgorLgorLlRQCiAuQiBkZWxheV93YXRjaF9jaGVja3MKIElm
IHNldCB0byBhIHZhbHVlIGdyZWF0ZXIgdGhhbiAwLCBtdWx0aXBhdGhkIHdpbGwgd2F0Y2ggcGF0
aHMgdGhhdCBoYXZlCiByZWNlbnRseSBiZWNvbWUgdmFsaWQgZm9yIHRoaXMgbWFueSBjaGVja3Mu
IElmIHRoZXkgZmFpbCBhZ2FpbiB3aGlsZSB0aGV5IGFyZQpAQCAtMTAxNSw2ICsxMDU0LDEyIEBA
IGFyZSB0YWtlbiBmcm9tIHRoZSBcZklkZWZhdWx0c1xmUiBvciBcZklkZXZpY2VzXGZSIHNlY3Rp
b246CiAuVFAKIC5CIGRlZmVycmVkX3JlbW92ZQogLlRQCisuQiBzYW5fcGF0aF9lcnJfdGhyZXNo
b2xkCisuVFAKKy5CIHNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZQorLlRQCisuQiBzYW5fcGF0aF9l
cnJfcmVjb3ZlcnlfdGltZQorLlRQCiAuQiBkZWxheV93YXRjaF9jaGVja3MKIC5UUAogLkIgZGVs
YXlfd2FpdF9jaGVja3MKQEAgLTExMjgsNiArMTE3MywxMiBAQCBzZWN0aW9uOgogLlRQCiAuQiBk
ZWZlcnJlZF9yZW1vdmUKIC5UUAorLkIgc2FuX3BhdGhfZXJyX3RocmVzaG9sZAorLlRQCisuQiBz
YW5fcGF0aF9lcnJfZm9yZ2V0X3JhdGUKKy5UUAorLkIgc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3Rp
bWUKKy5UUAogLkIgZGVsYXlfd2F0Y2hfY2hlY2tzCiAuVFAKIC5CIGRlbGF5X3dhaXRfY2hlY2tz
CkBAIC0xMTkyLDYgKzEyNDMsMTIgQEAgdGhlIHZhbHVlcyBhcmUgdGFrZW4gZnJvbSB0aGUgXGZJ
ZGV2aWNlc1xmUiBvciBcZklkZWZhdWx0c1xmUiBzZWN0aW9uczoKIC5UUAogLkIgZGVmZXJyZWRf
cmVtb3ZlCiAuVFAKKy5CIHNhbl9wYXRoX2Vycl90aHJlc2hvbGQKKy5UUAorLkIgc2FuX3BhdGhf
ZXJyX2ZvcmdldF9yYXRlCisuVFAKKy5CIHNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1lCisuVFAK
IC5CIGRlbGF5X3dhdGNoX2NoZWNrcwogLlRQCiAuQiBkZWxheV93YWl0X2NoZWNrcwpkaWZmIC0t
Z2l0IGEvbXVsdGlwYXRoZC9tYWluLmMgYi9tdWx0aXBhdGhkL21haW4uYwppbmRleCBhZGMzMjU4
Li40YTFhN2VmIDEwMDY0NAotLS0gYS9tdWx0aXBhdGhkL21haW4uYworKysgYi9tdWx0aXBhdGhk
L21haW4uYwpAQCAtMTQ4Nyw2ICsxNDg3LDgzIEBAIHZvaWQgcmVwYWlyX3BhdGgoc3RydWN0IHBh
dGggKiBwcCkKIAlMT0dfTVNHKDEsIGNoZWNrZXJfbWVzc2FnZSgmcHAtPmNoZWNrZXIpKTsKIH0K
IAorc3RhdGljIGludCBjaGVja19wYXRoX3JlaW5zdGF0ZV9zdGF0ZShzdHJ1Y3QgcGF0aCAqIHBw
KSB7CisJc3RydWN0IHRpbWVzcGVjIGN1cnJfdGltZTsKKwlpZiAoISgocHAtPm1wcC0+c2FuX3Bh
dGhfZXJyX3RocmVzaG9sZCA+IDApICYmCisJCQkJKHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9mb3Jn
ZXRfcmF0ZSA+IDApICYmCisJCQkJKHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9yZWNvdmVyeV90aW1l
ID4wKSkpIHsKKwkJcmV0dXJuIDA7CisJfQorCQorCWlmIChwcC0+ZGlzYWJsZV9yZWluc3RhdGUp
IHsKKwkJLyogSWYgd2UgZG9uJ3Qga25vdyBob3cgbXVjaCB0aW1lIGhhcyBwYXNzZWQsIGF1dG9t
YXRpY2FsbHkKKwkJICogcmVpbnN0YXRlIHRoZSBwYXRoLCBqdXN0IHRvIGJlIHNhZmUuIEFsc28s
IGlmIHRoZXJlIGFyZQorCQkgKiBubyBvdGhlciB1c2FibGUgcGF0aHMsIHJlaW5zdGF0ZSB0aGUg
cGF0aCAKKwkJICovCisJCWlmIChjbG9ja19nZXR0aW1lKENMT0NLX01PTk9UT05JQywgJmN1cnJf
dGltZSkgIT0gMCB8fAorCQkJCXBwLT5tcHAtPm5yX2FjdGl2ZSA9PSAwKSB7CisJCQljb25kbG9n
KDIsICIlcyA6IHJlaW5zdGF0aW5nIHBhdGggZWFybHkiLCBwcC0+ZGV2KTsKKwkJCWdvdG8gcmVp
bnN0YXRlX3BhdGg7CisJCX0KKwkJaWYgKChjdXJyX3RpbWUudHZfc2VjIC0gcHAtPmRpc19yZWlu
c3RhdGVfdGltZSApID4gcHAtPm1wcC0+c2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUpIHsKKwkJ
CWNvbmRsb2coMiwiJXMgOiByZWluc3RhdGUgdGhlIHBhdGggYWZ0ZXIgZXJyIHJlY292ZXJ5IHRp
bWUiLCBwcC0+ZGV2KTsKKwkJCWdvdG8gcmVpbnN0YXRlX3BhdGg7CisJCX0KKwkJcmV0dXJuIDE7
CisJfQorCS8qIGZvcmdldCBlcnJvcnMgb24gYSB3b3JraW5nIHBhdGggKi8KKwlpZiAoKHBwLT5z
dGF0ZSA9PSBQQVRIX1VQIHx8IHBwLT5zdGF0ZSA9PSBQQVRIX0dIT1NUKSAmJgorCQkJcHAtPnBh
dGhfZmFpbHVyZXMgPiAwKSB7CisJCWlmIChwcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlID4g
MCl7CisJCQlwcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlLS07CisJCX0gZWxzZSB7CisJCQkv
KiBmb3IgZXZlcnkgc2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlIG51bWJlciBvZiAKKwkJCSAqIHN1
Y2Nlc3NmdWwgcGF0aCBjaGVja3MgZGVjcmVtZW50IHBhdGhfZmFpbHVyZXMgYnkgMQorCQkJICov
CisJCQlwcC0+cGF0aF9mYWlsdXJlcy0tOworCQkJcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0
ZSA9IHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZTsKKwkJfQorCQlyZXR1cm4gMDsK
Kwl9CisKKwkvKiBJZiB0aGUgcGF0aCBpc24ndCByZWNvdmVyaW5nIGZyb20gYSBmYWlsZWQgc3Rh
dGUsIGRvIG5vdGhpbmcgKi8KKwlpZiAocHAtPnN0YXRlICE9IFBBVEhfRE9XTiAmJiBwcC0+c3Rh
dGUgIT0gUEFUSF9TSEFLWSAmJgorCQkJcHAtPnN0YXRlICE9IFBBVEhfVElNRU9VVCkKKwkJcmV0
dXJuIDA7CisKKwlpZiAocHAtPnBhdGhfZmFpbHVyZXMgPT0gMCkKKwkJcHAtPnNhbl9wYXRoX2Vy
cl9mb3JnZXRfcmF0ZSA9IHBwLT5tcHAtPnNhbl9wYXRoX2Vycl9mb3JnZXRfcmF0ZTsKKworCXBw
LT5wYXRoX2ZhaWx1cmVzKys7CisKKwkvKiBpZiB3ZSBkb24ndCBrbm93IHRoZSBjdXJyZW50bHkg
dGltZSwgd2UgZG9uJ3Qga25vdyBob3cgbG9uZyB0bworCSAqIGRlbGF5IHRoZSBwYXRoLCBzbyB0
aGVyZSdzIG5vIHBvaW50IGluIGNoZWNraW5nIGlmIHdlIHNob3VsZCAKKwkgKi8KKworCWlmIChj
bG9ja19nZXR0aW1lKENMT0NLX01PTk9UT05JQywgJmN1cnJfdGltZSkgIT0gMCkKKwkJcmV0dXJu
IDA7CisJLyogd2hlbiBwYXRoIGZhaWx1cmVzIGhhcyBleGNlZWRlZCB0aGUgc2FuX3BhdGhfZXJy
X3RocmVzaG9sZAorCSAqIHBsYWNlIHRoZSBwYXRoIGluIGRlbGF5ZWQgc3RhdGUgdGlsbCBzYW5f
cGF0aF9lcnJfcmVjb3ZlcnlfdGltZQorCSAqIHNvIHRoYXQgdGhlIGN1dG9tZXIgY2FuIHJlY3Rp
ZnkgdGhlIGlzc3VlIHdpdGhpbiB0aGlzIHRpbWUuIEFmdGVyCisJICogdGhlIGNvbXBsZXRpb24g
b2Ygc2FuX3BhdGhfZXJyX3JlY292ZXJ5X3RpbWUgaXQgc2hvdWxkCisJICogYXV0b21hdGljYWxs
eSByZWluc3RhdGUgdGhlIHBhdGggCisJICovCisJaWYgKHBwLT5wYXRoX2ZhaWx1cmVzID4gcHAt
Pm1wcC0+c2FuX3BhdGhfZXJyX3RocmVzaG9sZCkgeworCQljb25kbG9nKDIsICIlcyA6IGhpdCBl
cnJvciB0aHJlc2hvbGQuIERlbGF5aW5nIHBhdGggcmVpbnN0YXRlbWVudCIsIHBwLT5kZXYpOwor
CQlwcC0+ZGlzX3JlaW5zdGF0ZV90aW1lID0gY3Vycl90aW1lLnR2X3NlYzsKKwkJcHAtPmRpc2Fi
bGVfcmVpbnN0YXRlID0gMTsKKwkJcmV0dXJuIDE7CisJfSBlbHNlIHsKKwkJcmV0dXJuIDA7CisJ
fQorCityZWluc3RhdGVfcGF0aDoKKwlwcC0+cGF0aF9mYWlsdXJlcyA9IDA7CisJcHAtPmRpc2Fi
bGVfcmVpbnN0YXRlID0gMDsKKwlwcC0+c2FuX3BhdGhfZXJyX2ZvcmdldF9yYXRlID0gMDsKKwly
ZXR1cm4gMDsKK30KKwogLyoKICAqIFJldHVybnMgJzEnIGlmIHRoZSBwYXRoIGhhcyBiZWVuIGNo
ZWNrZWQsICctMScgaWYgaXQgd2FzIGJsYWNrbGlzdGVkCiAgKiBhbmQgJzAnIG90aGVyd2lzZQpA
QCAtMTYwMSw2ICsxNjc4LDEyIEBAIGNoZWNrX3BhdGggKHN0cnVjdCB2ZWN0b3JzICogdmVjcywg
c3RydWN0IHBhdGggKiBwcCwgaW50IHRpY2tzKQogCQlyZXR1cm4gMDsKIAogCWlmICgobmV3c3Rh
dGUgPT0gUEFUSF9VUCB8fCBuZXdzdGF0ZSA9PSBQQVRIX0dIT1NUKSAmJgorCQkJY2hlY2tfcGF0
aF9yZWluc3RhdGVfc3RhdGUocHApKSB7CisJCXBwLT5zdGF0ZSA9IFBBVEhfREVMQVlFRDsKKwkJ
cmV0dXJuIDE7CisJfQorCisJaWYgKChuZXdzdGF0ZSA9PSBQQVRIX1VQIHx8IG5ld3N0YXRlID09
IFBBVEhfR0hPU1QpICYmCiAJICAgICBwcC0+d2FpdF9jaGVja3MgPiAwKSB7CiAJCWlmIChwcC0+
bXBwLT5ucl9hY3RpdmUgPiAwKSB7CiAJCQlwcC0+c3RhdGUgPSBQQVRIX0RFTEFZRUQ7Cg==

--_002_3ab5d07903b44e0a913b5637862c4c96BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_3ab5d07903b44e0a913b5637862c4c96BRMWPEXMB12corpbrocadec_--
