From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] Use strmatch to load config file
Date: Thu, 09 Nov 2006 11:29:52 +0100
Message-ID: <45530320.8020003@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070305090401030702090902"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070305090401030702090902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

We should really be using string match to load the config file.
This avoids false positives when comparing two regexps.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------070305090401030702090902
Content-Type: text/plain;
	name="0001-libmultipath-Use-strmatch-to-load-config-file.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="0001-libmultipath-Use-strmatch-to-load-config-file.txt"

[libmultipath] Use strmatch to load config file

Currently we're using regexec to load the initial hardware table.
Unfortunately the hardware table has regex as defaults, so it's quite
possible for two different regular expressions do match.
But that's quite undesired as we just want a clean 1:1 copy here.
So we're better using a string match for comparison.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 libmultipath/config.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a87e97e..2f07792 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -20,6 +20,25 @@ #include "config.h"
 #include "blacklist.h"
 #include "defaults.h"
 
+static struct hwentry *
+find_hwe_strmatch (vector hwtable, char * vendor, char * product)
+{
+	int i;
+	struct hwentry *hwe, *ret = NULL;
+
+	vector_foreach_slot (hwtable, hwe, i) {
+		if (hwe->vendor && vendor && strcmp(hwe->vendor, vendor))
+			continue;
+
+		if (hwe->product && product && strcmp(hwe->product, product))
+			continue;
+
+		ret = hwe;
+		break;
+	}
+	return ret;
+}
+
 struct hwentry *
 find_hwe (vector hwtable, char * vendor, char * product)
 {
@@ -222,7 +241,7 @@ store_hwe (vector hwtable, struct hwentr
 {
 	struct hwentry * hwe;
 
-	if (dup_hwe(hwtable, dhwe->vendor, dhwe->product))
+	if (find_hwe_strmatch(hwtable, dhwe->vendor, dhwe->product))
 		return 0;
 	
 	if (!(hwe = alloc_hwe()))
-- 
1.3.1


--------------070305090401030702090902
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070305090401030702090902--
