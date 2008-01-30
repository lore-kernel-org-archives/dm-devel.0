From: "Greene, Rick" <rick.greene@ncogroup.com>
Subject: RE: Multipath and getuid_callout issues with HPXP1024disk
	array
Date: Wed, 30 Jan 2008 13:56:09 -0500
Message-ID: <2F1F44D192D1284BAA298E48C1B2A4F90234F14D@exchmail03.ncogroup.com>
References: <20080130185024.GA6165@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080130185024.GA6165@us.ibm.com>
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

I've been trying to play with using a different command in the
getuid_callout, but everything I try comes up with "error calling out".
For example, I wrote my own little shell script that pushes out the same
scsi_id string, plus some output from a vendor-supplied disk querying
command, and this is what "multipath -v3" shows for one of the devices
(they all display similar results):

=3D=3D=3D=3D=3D path info sda (mask 0x1f) =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 8:0
size =3D 28452960
vendor =3D HP
product =3D OPEN-E
rev =3D 2114
h:b:t:l =3D 1:0:0:0
tgt_node_name =3D 0x50060e80039c5a04
serial =3D 40026
path checker =3D readsector0 (internal default)
state =3D 2
getprio =3D /bin/true (internal default)
prio =3D 0
getuid =3D /sbin/xpdisk %n (internal default)
error calling out /sbin/xpdisk sda
uid =3D  (callout)

Run manually, it looks like this:
# /sbin/xpdisk sda
0HP_OPEN-E_50060e80039c5a0400000000000000000000e100_05:83

I've tried various things with the script I wrote, including just
spitting out the 05:83 (which is the CU:LDev values from the disk array,
pretty much the most unique disk identifying info I can find)

Not sure what else to do.

Thanks,
Rick

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Wednesday, January 30, 2008 1:50 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Multipath and getuid_callout issues with
HPXP1024disk array

You have two default sections in your multipath.conf file, but that is
not
the problem though. The scsi_id output from each path looks different,
that is why multipath treats them as different LUNs.

Make sure you configure your storage properly or change the default
getuid string that works for your storage.

Thanks, Malahal.

Greene, Rick [rick.greene@ncogroup.com] wrote:
> Ok, some more background first:
>=20
> System is an HP Proliant DL380 (or maybe DL580?), using Emulex fibre
> channel cards (don't know exact model off-hand).
>=20
> Running Red Hat Enterprise Linux 4, update 5.
>=20
> Device-mapper-multipath was version 0.4.5-21, just updated it to
> 0.4.5-27
>=20
> There are 4 LUNs from an HP XP1024 disk array, each pathed to be
visible
> on each fibre channel.  LUN type is OPEN-E.
> =20
> Multipath now seems to accept the longer string returned by scsi_id,
but
> it doesn't seem able to tell that certain disks are the same.
>=20
> Attached is the multipath.conf file I'm using and the output from
> "multipath -v3". If the attachments don't come through, I'll send
> separate emails with just the contents for each file.
>=20
> Any aide gladly received, I'm in over my head on this one.
>=20
> Thanks,
> Rick
>=20
>=20
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of malahal@us.ibm.com
> Sent: Tuesday, January 29, 2008 5:19 PM
> To: dm-devel@redhat.com
> Subject: Re: [dm-devel] Multipath and getuid_callout issues with HP
> XP1024disk array
>=20
> Greene, Rick [rick.greene@ncogroup.com] wrote:
> >    I've done what I can to try to understand how all this works, but
I
> keep
> >    getting "error calling out /sbin/scsi_id -g -u -s /block/sda"
when
> I run
> >    the command "multipath -v2"
> >=20
> >=20
> >=20
> >    I've tried a number of different things in the
/etc/multipath.conf
> file,
> >    but keep coming back to this same error.  If I run the command
> manually I
> >    get the following:
> >=20
> >=20
> >=20
> >    # /sbin/scsi_id -g -u -s /block/sda
> >=20
> >    0HP______OPEN-E__________50060e80039c5a0400000000000000000000e100
> >=20
> >=20
> >=20
> >    What's missing?  Any help greatly appreciated.
>=20
> You are not missing anything. The device id is too big to fit in
> multipath tools allocated memory. The program incorrectly prints that
> there is a problem while executing /sbin/scsi_id but in fact the
problem
> lies in the program itself. You may have some old version of multipath
> tools. WWID_SIZE was set to 64 bytes and that is small for your
device.
> Get the latest version where that macro is set to 128 or so.
>=20
> Hope that helps!
>=20
> --Malahal.
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel



> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
