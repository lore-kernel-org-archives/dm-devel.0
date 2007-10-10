From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: Multipath on boot and root partition with Redhat5.0
Date: Wed, 10 Oct 2007 15:07:49 -0400
Message-ID: <1D80D4F6D179BD4D869FE807A5BF8336018C68D8@EXCNYSM0A1AN.nysemail.nyenet>
References: <470CB061.5000902@univ-tln.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-reply-to: <470CB061.5000902@univ-tln.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I use multipath boot (/boot) and root (/) on SLES9 kernel 2.6.5 on IBM
mainframe Linux with scsi LUNs. I'm not familiar with redhat5 or HP, but
from your post I guess it's newer kernel and newer multipath-tools than
my SLES9.
I did a howto for SLES9
http://www.linuxvm.org/Info/HOWTOs/root-on-multipath.html
but probably won't help you other than hinting at a way; many
differences in our two linux systems.

SLES 10 (kernel 2.6.16?) says it supports root-on-multipath (not boot
though), may be a common feature with redhat 5 too?

As you said, "on boot the multipath.conf file is not read", so that
maybe explains your mpath0 has defaulted alias name when you really
wanted the persistent name to be os_lun as per your multipath.conf. And
the fstab LABEL=3D's get you around that unexpected mpath0 device name.

General idea is to modify the initial ramfs /init script to run
multipath early; put your current multipath.conf in the initramfs cpio
archive so your aliases are used.  Note that though I have a
multipath-ed /boot after multipath runs, I boot from any single one of
its available paths; mainframe boot loader's not aware of the multiple
paths.
=20
good luck


--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.


-----Original Message-----

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Sandrine Twardy
Sent: Wednesday, October 10, 2007 6:59 AM
To: dm-devel@redhat.com
Subject: [dm-devel] Multipath on boot and root partition with Redhat5.0

Hello,

I have a SAN Eva 5000 HP And I have installed a redhat 5.0 on my server=20
with "linux mpath", so far all is fine.
I have an os device multipathed as follow :

 > multipath -ll
mpath0 () dm-0 COMPAQ,HSV110 (C)COMPAQ
[size=3D7.0G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
\_ 3:0:0:1 sdb 8:16  [active][ready]
\_ 4:0:0:1 sdc 8:32  [active][ready]

But when I presents a new lun to my host and scans again the scsi lun, I

am losing the multipath on the disk (/ and /boot)
(possibly because the name of device is changed from sdb/sdc to sdc/sde
? )

Here's an extract of my multipath.conf:

multipath {
              wwid                    3600508b40000c1c50001c000000b0000
              path_grouping_policy    group_by_serial
              rr_weight               uniform
              prio_callout            /bin/true
              alias                   os_lun
      }
     But it's seems that on boot the mutlipath.conf file is not read. =20
Am I right?
When the system is booted, multipathd cannot use the boot device ...
What can I do to fix the boot device name persistence? Where is supposed

to be configuration file that defines the multipath options of the boot=20
device ?

Right now, the server can boot because my fstab is like this:
LABEL=3D/1                /                      LABEL=3D/boot           =
 =20
/boot

Thanks you for your help
