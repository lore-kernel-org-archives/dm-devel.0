From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fixup kpartx rules for dmraid
Date: Mon, 06 Aug 2007 13:22:27 +0200
Message-ID: <46B70473.2030406@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060800000301050000090400"
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
--------------060800000301050000090400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

the kpartx rules do not detect dmraid properly. This patch
fixes this.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------060800000301050000090400
Content-Type: text/plain;
 name="kpartx-fix-rules-for-dmraid"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kpartx-fix-rules-for-dmraid"

[kpartx] Fix udev rules for dmraid

The kpartx_id program is located under /lib/udev, so we don't need to
call it with the full pathname.
And we should also create persistent links for dmraid tables.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index f32c718..9ab9a49 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -9,7 +9,7 @@ ACTION=="remove", GOTO="kpartx_end"
 
 ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
 
-ENV{DM_UUID}=="?*", IMPORT{program}=="/lib/udev/kpartx_id %M %m $env{DM_UUID}"
+ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
 OPTIONS="link_priority=50"
 
@@ -18,7 +18,7 @@ ENV{DM_UUID}=="mpath-*", \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
 
 # Create persistent links for dmraid tables
-ENV{DM_UUID}=="mpath-*", \
+ENV{DM_UUID}=="dmraid-*", \
         SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
 
 # Create persistent links for partitions

--------------060800000301050000090400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060800000301050000090400--
