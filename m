From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath: change default configuration
	parameters
Date: Thu, 17 Jan 2013 08:30:30 +0100
Message-ID: <50F7A896.9040100@suse.de>
References: <20130108053459.GU19059@ether.msp.redhat.com>
	<50EEFB87.1060707@gmail.com>
	<1358283765.3854.1.camel@lapoo.opensvc.com>
	<50F5D4B1.5070508@gmail.com>
	<1358371462.8351.18.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050006060806070003010904"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358371462.8351.18.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050006060806070003010904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id r0H7UjnH013048

On 01/16/2013 10:24 PM, Christophe Varoqui wrote:
> On mar., 2013-01-15 at 23:14 +0100, Xose Vazquez Perez wrote:
> ...
>> scsi_id is going to be replaced in systemd(recently udev was
>> included in systemd).
>>
>> See sg_inq(--export option) from sg3_utils.
>
> We will need to patch sg_inq to report a denser id than the documented
> SCSI_IDENT_<assoc>_<type>=3D<ident>
>
Why? It took me ages to implement that one properly.
And it's only strings, which can be expanded at will.
Plus I have a set of udev rules mangling those into the usual ID_XXX=20
variables.

I don't see why we need to change that ...

> Time to launch a debate over the pertinence to maintain the '3' prefix
> scsi_id insisted on prepending to the wwids ... Lennart will take the
> blame without flinching I'm sure ;)
>
It's not '3'.

The '3' is the VPD designator ID as defined in the spec. And it's=20
attached there so that you can differentiate between several IDs,=20
which might be identical otherwise.

The original idea behind the prefix was that each ID has a different=20
level of 'uniqueness'.
Basically, there are 5 possible designator IDs for the LUN:

0: Vendor specific
1: T10 Vendor ID based
2: EUI-64 based
3: NAA
8: SCSI Name string

of which 0, 1, and 8 are basically arbitrary. We only have a=20
guaranteed unique ID when the designator is of type 2 or 3.
So prefixing the designator number allows you to figure out whether=20
it's a good idea for using that ID.

Mind you, that was when all was encoded in scsi_id.
Now that's all open-coded with udev rules you have different=20
variables for each ID, so it's easy to figure out.

But sorry, we can't change that.
Upgrade will be _HELL_ if you do that.

Btw, a patch to the udev rules is attached. It's not yet included in=20
the upstream sources as Kay and I are still discussing whether we=20
should split the original rule set.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--------------050006060806070003010904
Content-Type: text/x-patch;
 name="use-sg_inq-in-persistent-rules.patch"
Content-Disposition: attachment;
	filename="use-sg_inq-in-persistent-rules.patch"
Content-Transfer-Encoding: 7bit

diff --git a/rules/rules.d/60-persistent-storage.rules b/rules/rules.d/60-persistent-storage.rules
index 1c4c2b2..a8377c6 100644
--- a/rules/rules.d/60-persistent-storage.rules
+++ b/rules/rules.d/60-persistent-storage.rules
@@ -38,17 +38,35 @@ KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", SUBSYSTEMS=="ata", IMPORT{program
 # ATA devices using the "scsi" subsystem
 KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", SUBSYSTEMS=="scsi", ATTRS{vendor}=="ATA", IMPORT{program}="ata_id --export $tempnode"
 # scsi devices
-KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", IMPORT{program}="scsi_id --export --whitelisted -d $tempnode", ENV{ID_BUS}="scsi"
-KERNEL=="cciss*", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}!="?*", IMPORT{program}="scsi_id --export --whitelisted -d $tempnode", ENV{ID_BUS}="cciss"
+KERNEL=="sd*[!0-9]|sr*", IMPORT{program}="/usr/bin/sg_inq --export  $tempnode", ENV{ID_BUS}="scsi"
+KERNEL=="cciss*", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}!="?*", IMPORT{program}="/usr/bin/sg_inq --export $tempnode", ENV{ID_BUS}="cciss"
+# Select which identifier to use per default
+# 1: NAA IEEE Registered Extended identifier
+ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA}=="6*", ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA}"
+# 2: NAA IEEE Registered identifier
+ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA}=="5*", ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA}"
+# 3: Unspecified NAA identfier
+ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAA}=="?*", ENV{ID_SERIAL}="3$env{SCSI_IDENT_LUN_NAA}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAA}"
+# 4: EUI-64 identifer
+ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_EUI64}=="?*", ENV{ID_SERIAL}="2$env{SCSI_IDENT_LUN_EUI64}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_EUI64}"
+# 5: SCSI name identifier
+ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_NAME}=="?*", ENV{ID_SERIAL}="8$env{SCSI_IDENT_LUN_NAME}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_NAME}"
+# 6: T10 Vendor identifer
+ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_T10}=="?*", ENV{ID_SERIAL}="1$env{SCSI_IDENT_LUN_T10}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_T10}"
+# 7: Vendor-specific identifier
+ENV{ID_SERIAL}!="?*", ENV{SCSI_IDENT_LUN_VENDOR}=="?*", ENV{ID_SERIAL}="0$env{SCSI_IDENT_LUN_VENDOR}", ENV{ID_SERIAL_SHORT}="$env{SCSI_IDENT_LUN_VENDOR}"
 KERNEL=="sd*|sr*|cciss*", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="?*", SYMLINK+="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}"
 KERNEL=="sd*|cciss*", ENV{DEVTYPE}=="partition", ENV{ID_SERIAL}=="?*", SYMLINK+="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}-part%n"
 
+KERNEL=="sd*[!0-9]|sr*", ENV{ID_SCSI_SERIAL}!="?*", IMPORT{program}="/usr/bin/sg_inq --export -p 0x80 $tempnode", ENV{ID_SCSI_SERIAL}="$env{SCSI_IDENT_SERIAL}"
+KERNEL=="cciss*", ENV{DEVTYPE}=="disk", ENV{ID_SCSI_SERIAL}!="?*", IMPORT{program}="/usr/bin/sg_inq --export -p 0x80 $tempnode", ENV{ID_SCSI_SERIAL}="$env{SCSI_IDENT_SERIAL}"
+
 # firewire
 KERNEL=="sd*[!0-9]|sr*", ATTRS{ieee1394_id}=="?*", SYMLINK+="disk/by-id/ieee1394-$attr{ieee1394_id}"
 KERNEL=="sd*[0-9]", ATTRS{ieee1394_id}=="?*", SYMLINK+="disk/by-id/ieee1394-$attr{ieee1394_id}-part%n"
 
 # scsi compat links for ATA devices
-KERNEL=="sd*[!0-9]", ENV{ID_BUS}=="ata", PROGRAM="scsi_id --whitelisted --replace-whitespace -p0x80 -d$tempnode", RESULT=="?*", ENV{ID_SCSI_COMPAT}="$result", SYMLINK+="disk/by-id/scsi-$env{ID_SCSI_COMPAT}"
+KERNEL=="sd*[!0-9]", ENV{ID_BUS}=="ata", ENV{SCSI_IDENT_SERIAL}=="?*", ENV{ID_SCSI_COMPAT}="$env{SCSI_IDENT_SERIAL}", SYMLINK+="disk/by-id/scsi-$env{ID_SCSI_COMPAT}"
 KERNEL=="sd*[0-9]", ENV{ID_SCSI_COMPAT}=="?*", SYMLINK+="disk/by-id/scsi-$env{ID_SCSI_COMPAT}-part%n"
 
 KERNEL=="mmcblk[0-9]", SUBSYSTEMS=="mmc", ATTRS{name}=="?*", ATTRS{serial}=="?*", ENV{ID_NAME}="$attr{name}", ENV{ID_SERIAL}="$attr{serial}", SYMLINK+="disk/by-id/mmc-$env{ID_NAME}_$env{ID_SERIAL}"

--------------050006060806070003010904
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------050006060806070003010904--
