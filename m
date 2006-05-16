From: egoggin@emc.com
Subject: patch to allow multipath(8) and multipathd(8) to pick up
	existing alias (if any) from dm device-name
Date: Tue, 16 May 2006 15:32:28 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4149049@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Christophe,

This small patch should allow multipath(8) and multipathd(8) to acquire its
internal alias name from the device-mapper's device-name for the device if a
multipath specific alias (user friendly one or not) has __not__ been set.
Otherwise, assuming that a multipath device has been renamed beforehand by
someone invoking "dm_setup rename", simply invoking "multipath" changes the
device-mapper's device-name for the device back to the multipath assigned
UID name.

Ed

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 79cee8b..003433e 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -15,6 +15,7 @@
 #include "pgpolicies.h"
 #include "alias.h"
 #include "defaults.h"
+#include "devmapper.h"
 
 pgpolicyfn *pgpolicies[] = {
 	NULL,
@@ -165,6 +166,9 @@ select_alias (struct multipath * mp)
 			mp->alias = get_user_friendly_alias(mp->wwid,
 					conf->bindings_file);
 		if (mp->alias == NULL)
+			if ((mp->alias = MALLOC(WWID_SIZE)) != NULL)
+				dm_get_name(mp->wwid, DEFAULT_TARGET,
mp->alias);
+		if (mp->alias == NULL)
 			mp->alias = mp->wwid;
 	}
