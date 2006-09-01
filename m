From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] remove obsolete '-D' option
Date: Fri, 01 Sep 2006 09:32:18 +0200
Message-ID: <44F7E202.6090206@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010101080702080600020406"
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
--------------010101080702080600020406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

our documentation folks complained that the manpage documents an=20
obsolete / unused '-D' option for multipath.

This patch removes this description from the manpage.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------010101080702080600020406
Content-Type: text/plain;
 name="multipath-tools-remove-obsolete-option"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="multipath-tools-remove-obsolete-option"

tree eaa0a96390363af7ae983ce8f3c5b552094ef081
parent 8d239c5fa1169f9ed906ac057dac7b94df5b368e
author Hannes Reinecke <hare@suse.de> 1146558273 +0200
committer Hannes Reinecke <hare@suse.de> 1146558273 +0200

multipath.8: Remove obsolete '-D' option

The manpage describes an obsolete '-D' option. As this option
is not supported anymore we can delete this reference.

Signed-off-by: Hannes Reinecke <hare@suse.de>
01f9107a26b6c8f4e0288a2639b1fcbfc5af872e
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 7133598..e4b28fc 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -38,12 +38,6 @@ show the current multipath topology from
 .B \-ll
 show the current multipath topology from all available information (sysfs, the device mapper, path checkers ...)
 .TP
-.TP
-.BI \-D " major:minor"
-update only the devmap the path pointed by
-.I major:minor
-is in
-.TP
 .B \-f
 flush a multipath device map specified as parameter, if unused
 .TP

--------------010101080702080600020406
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010101080702080600020406--
