From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: [PATCH 2/2] [multipath-tools] Additional fixes for
 inconsistent quoting in snprint functions
Date: Tue, 23 Apr 2013 21:23:19 +0000
Message-ID: <8255ED565A0EAA4A960625E27D49DBF21FFB6B9F@SACEXCMBX04-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch finishes the job from this commit: http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commitdiff;h=cef43b6f910f740c0e2d38761f58c5ebedfb7585;hp=41b85341ca514a50d18c592996a2ecb43a81fa90
All attributes printing strings from their snprint functions should now be quotes.

Signed-off-by: Sean Stewart <Sean.Stewart@netapp.com>

---
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index a54dda9..5154cdd 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1883,11 +1883,11 @@ snprint_mp_failback (char * buff, int len, void * data)
        case  FAILBACK_UNDEF:
                break;
        case -FAILBACK_MANUAL:
-               return snprintf(buff, len, "manual");
+               return snprintf(buff, len, "\"manual\"");
        case -FAILBACK_IMMEDIATE:
-               return snprintf(buff, len, "immediate");
+               return snprintf(buff, len, "\"immediate\"");
        case -FAILBACK_FOLLOWOVER:
-               return snprintf(buff, len, "followover");
+               return snprintf(buff, len, "\"followover\"");
        default:
                return snprintf(buff, len, "%i", mpe->pgfailback);
        }
@@ -2078,9 +2078,9 @@ snprint_mp_user_friendly_names (char * buff, int len, void * data)
        if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
                return 0;
        else if (mpe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
-               return snprintf(buff, len, "no");
+               return snprintf(buff, len, "\"no\"");
        else
-               return snprintf(buff, len, "yes");
+               return snprintf(buff, len, "\"yes\"");
 }

 static int
@@ -2260,11 +2260,11 @@ snprint_hw_failback (char * buff, int len, void * data)
        case  FAILBACK_UNDEF:
                break;
        case -FAILBACK_MANUAL:
-               return snprintf(buff, len, "manual");
+               return snprintf(buff, len, "\"manual\"");
        case -FAILBACK_IMMEDIATE:
-               return snprintf(buff, len, "immediate");
+               return snprintf(buff, len, "\"immediate\"");
        case -FAILBACK_FOLLOWOVER:
-               return snprintf(buff, len, "followover");
+               return snprintf(buff, len, "\"followover\"");
        default:
                return snprintf(buff, len, "%i", hwe->pgfailback);
        }
@@ -2382,9 +2382,9 @@ snprint_hw_user_friendly_names (char * buff, int len, void * data)
        if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_UNDEF)
                return 0;
        else if (hwe->user_friendly_names == USER_FRIENDLY_NAMES_OFF)
-               return snprintf(buff, len, "no");
+               return snprintf(buff, len, "\"no\"");
        else
-               return snprintf(buff, len, "yes");
+               return snprintf(buff, len, "\"yes\"");
 }

 static int
@@ -2393,9 +2393,9 @@ snprint_hw_retain_hwhandler_handler(char * buff, int len, void * data)
        struct hwentry * hwe = (struct hwentry *)data;

        if (hwe->retain_hwhandler == RETAIN_HWHANDLER_ON)
-               return snprintf(buff, len, "yes");
+               return snprintf(buff, len, "\"yes\"");
        else if (hwe->retain_hwhandler == RETAIN_HWHANDLER_OFF)
-               return snprintf(buff, len, "no");
+               return snprintf(buff, len, "\"no\"");
        else
                return 0;
 }
@@ -2406,9 +2406,9 @@ snprint_detect_prio(char * buff, int len, void * data)
        struct hwentry * hwe = (struct hwentry *)data;

        if (hwe->detect_prio == DETECT_PRIO_ON)
-               return snprintf(buff, len, "yes");
+               return snprintf(buff, len, "\"yes\"");
        else if (hwe->detect_prio == DETECT_PRIO_OFF)
-               return snprintf(buff, len, "no");
+               return snprintf(buff, len, "\"no\"");
        else
                return 0;
 }
--
