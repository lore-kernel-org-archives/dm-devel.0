From: "Levy, Jerome" <jerome.levy@emc.com>
Subject: [PATCH v3] libmultipath: minimize noise with snapshots
 in emc_clariion checker
Date: Tue, 23 Apr 2013 13:34:03 +0000
Message-ID: <454E18A46D7B064CA63B41E99AD179504EF35161@MX103CL02.corp.emc.com>
References: <454E18A46D7B064CA63B41E99AD179504EF34D8E@MX103CL02.corp.emc.com>
	<20130423132648.GA9083@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130423132648.GA9083@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, "christophe.varoqui@gmail.com" <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Corrections noted. Sorry for the inconvenience... changing include and inverting diff.
Thanks, Mike!!!!
--- 

Patch to stop emc_clariion_checker from logging messages when probes to snapshot LUNs occur. Notification is still available if logging is turned up (see condlog()) but normal probing of snapshots will no longer produce status messages. Path functionality on snapshot probes is unchanged.

Signed-off-by: Jerry Levy <jerome.levy@emc.com>


--- ./libmultipath/checkers/emc_clariion.c.orig 2013-04-22 14:07:36.966548097 -0400
+++ ./libmultipath/checkers/emc_clariion.c      2013-04-22 15:50:19.081555624 -0400
@@ -15,6 +15,7 @@
 #include "../libmultipath/sg_include.h"
 #include "libsg.h"
 #include "checkers.h"
+#include "../libmultipath/debug.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
@@ -198,9 +199,8 @@ int libcheck_check (struct checker * c)
                                 * 02/04/03 not 05/25/01 on read.
                                 */
                                SET_INACTIVE_SNAP(c);
-                               MSG(c, "emc_clariion_checker: Active "
-                                       "path to inactive snapshot WWN %s.",
-                                       wwnstr);
+                               condlog(3, "emc_clariion_checker: Active path to "
+                                       "inactive snapshot WWN %s.", wwnstr);
                        } else
                                MSG(c, "emc_clariion_checker: Read "
                                        "error for WWN %s.  Sense data are "
@@ -219,9 +219,8 @@ int libcheck_check (struct checker * c)
        } else {
                if (IS_INACTIVE_SNAP(c)) {
                        hexadecimal_to_ascii(ct->wwn, wwnstr);
-                       MSG(c, "emc_clariion_checker: Passive "
-                               "path to inactive snapshot WWN %s.",
-                               wwnstr);
+                       condlog(3, "emc_clariion_checker: Passive path to "
+                               "inactive snapshot WWN %s.", wwnstr);
                        ret = PATH_DOWN;
                } else {
                        MSG(c,
