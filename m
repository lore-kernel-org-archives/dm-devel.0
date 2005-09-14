From: "goggin, edward" <egoggin@emc.com>
Subject: Proposed change to scsi_id parameter string in
	libmultipath/hwtab le.c for EMC Symmetrix
Date: Wed, 14 Sep 2005 16:45:03 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AC98@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Christophe,

May want to patch the EMC SYMMETRIX hw entry in
libmultipath/hwtable.c to use the "-ppre-spc3-83"
scsi_id option.  Doing so will allow scsi_id to
return a UID derived from a version of a SCSI
Inquiry EVPD page 83 which is not compliant with
either SPC-2 or SPC-3 for an older model Symmetrix,
that is, models 4, 5 and some model sixes.

I should have suggested this earlier, but I assumed
that it would be good enough for administrators to simply
modify their /etc/scsi_id.config file to add this
option as a default for all Symmetrix models.  Since
this assumption is likely a bad idea :((, I think we
should include the new option in the multipath default
configuration.

Udev will need similar changes since we likely cannot
rely on the scsi_id.config file being setup properly
by a site administrator.

Here is the patch.

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -17,7 +17,7 @@ setup_default_hwtable (vector hw)
 	r += store_hwe(hw, "COMPAQ", "MSA1000 VOLUME", GROUP_BY_SERIAL,
DEFAULT_GETUID);
 	r += store_hwe(hw, "DDN", "SAN DataDirector", MULTIBUS,
DEFAULT_GETUID);
 	r += store_hwe(hw, "DEC", "HSG80", GROUP_BY_SERIAL, DEFAULT_GETUID);
-	r += store_hwe(hw, "EMC", "SYMMETRIX", MULTIBUS, DEFAULT_GETUID);
+	r += store_hwe(hw, "EMC", "SYMMETRIX", MULTIBUS, "/sbin/scsi_id -g
-u -ppre-spc3-83 -s /block/%n");
 	r += store_hwe(hw, "FSC", "CentricStor", GROUP_BY_SERIAL,
DEFAULT_GETUID);
 	r += store_hwe(hw, "HITACHI", "DF400", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "HITACHI", "DF500", MULTIBUS, DEFAULT_GETUID);
