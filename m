From: "Greene, Rick" <rick.greene@ncogroup.com>
Subject: RE: Multipath and getuid_callout issues withHPXP1024disk
	array
Date: Wed, 30 Jan 2008 15:21:01 -0500
Message-ID: <2F1F44D192D1284BAA298E48C1B2A4F90234F150@exchmail03.ncogroup.com>
References: <20080130201115.GA6833@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080130201115.GA6833@us.ibm.com>
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

Thanks Malahal, you just put me in a "Ok, that's my 'dumb guy' moment
for the day."

I added "#!/bin/bash" as the first line of my /sbin/xpdisk script, and
then modified the script to just spit out the CU:LDev info from the
HP-supplied-but-not-supported xpinfo command, and now it looks like it's
working:
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
uid =3D 05:83 (cache)

and:
No matching wwid [05:83] in bindings file.
Created new binding [mpath0] for WWID [05:83]
pgpolicy =3D failover (config file default)
selector =3D round-robin 0 (internal default)
features =3D 0 (internal default)
hwhandler =3D 0 (internal default)
rr_weight =3D 2 (config file default)
rr_min_io =3D 100 (config file default)
no_path_retry =3D -1 (config file default)
pg_timeout =3D NONE (internal default)
0 28452960 multipath 0 0 2 1 round-robin 0 1 1 8:0 100 round-robin 0 1 1
8:64 100
set ACT_CREATE: map does not exists
message mpath0 0 switch_group 1

create: mpath0 (05:83)
[size=3D13 GB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0
 \_ 1:0:0:0 sda 8:0   [ready]
\_ round-robin 0
 \_ 2:0:0:0 sde 8:64  [ready]

Some (hopefully) final questions for you (or whoever knows)...

1) does the actual WWID need to be in the "uid" value that multipath
gets from the callout, or is any value that is unique to the disk good
enough?

2) what is the character limit to the return value from the
getuid_callout?

3) is there a specific format that multipath is looking at for parsing
the info in the uid value (such as vendor, model, type, serial number,
etc), or is the unique disk identifier all that is needed?

With those answers, I think I'll have a lock on this.

Thanks,
Rick

-----Original Message-----
From: malahal@us.ibm.com [mailto:malahal@us.ibm.com]=20
Sent: Wednesday, January 30, 2008 3:11 PM
To: Greene, Rick
Cc: device-mapper development
Subject: Re: [dm-devel] Multipath and getuid_callout issues
withHPXP1024disk array

Greene, Rick [rick.greene@ncogroup.com] wrote:
> getuid =3D /sbin/xpdisk %n (internal default)
> error calling out /sbin/xpdisk sda
> uid =3D  (callout)

It prints your getuid call as "internal default", that is odd.  That
looks like a bug if you are just changing multipath.conf. I just tested
my SLES10 SP1 system (multipath-tools-0.4.7-34.18) with /sbin/uid shell
script that contains the following two lines. The first line is needed,
do you have that in your shell script?

#!/bin/sh
echo $1

It woks and few lines of multipath -v3 output:

sda: serial =3D 3EL0585G00007115JK65
sda: getprio =3D NULL (internal default)
sda: prio =3D 1
sda: getuid =3D /sbin/uid %n (config file default)
sda: uid =3D sda (callout)


>=20
> Run manually, it looks like this:
> # /sbin/xpdisk sda
> 0HP_OPEN-E_50060e80039c5a0400000000000000000000e100_05:83
>=20
> I've tried various things with the script I wrote, including just
> spitting out the 05:83 (which is the CU:LDev values from the disk
array,
> pretty much the most unique disk identifying info I can find)
>=20
> Not sure what else to do.
>=20
> Thanks,
> Rick
>=20
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of malahal@us.ibm.com
> Sent: Wednesday, January 30, 2008 1:50 PM
> To: dm-devel@redhat.com
> Subject: Re: [dm-devel] Multipath and getuid_callout issues with
> HPXP1024disk array
>=20
> You have two default sections in your multipath.conf file, but that is
> not
> the problem though. The scsi_id output from each path looks different,
> that is why multipath treats them as different LUNs.
>=20
> Make sure you configure your storage properly or change the default
> getuid string that works for your storage.
>=20
> Thanks, Malahal.
>=20
> Greene, Rick [rick.greene@ncogroup.com] wrote:
> > Ok, some more background first:
> >=20
> > System is an HP Proliant DL380 (or maybe DL580?), using Emulex fibre
> > channel cards (don't know exact model off-hand).
> >=20
> > Running Red Hat Enterprise Linux 4, update 5.
> >=20
> > Device-mapper-multipath was version 0.4.5-21, just updated it to
> > 0.4.5-27
> >=20
> > There are 4 LUNs from an HP XP1024 disk array, each pathed to be
> visible
> > on each fibre channel.  LUN type is OPEN-E.
> > =20
> > Multipath now seems to accept the longer string returned by scsi_id,
> but
> > it doesn't seem able to tell that certain disks are the same.
> >=20
> > Attached is the multipath.conf file I'm using and the output from
> > "multipath -v3". If the attachments don't come through, I'll send
> > separate emails with just the contents for each file.
> >=20
> > Any aide gladly received, I'm in over my head on this one.
> >=20
> > Thanks,
> > Rick
> >=20
> >=20
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com
[mailto:dm-devel-bounces@redhat.com]
> > On Behalf Of malahal@us.ibm.com
> > Sent: Tuesday, January 29, 2008 5:19 PM
> > To: dm-devel@redhat.com
> > Subject: Re: [dm-devel] Multipath and getuid_callout issues with HP
> > XP1024disk array
> >=20
> > Greene, Rick [rick.greene@ncogroup.com] wrote:
> > >    I've done what I can to try to understand how all this works,
but
> I
> > keep
> > >    getting "error calling out /sbin/scsi_id -g -u -s /block/sda"
> when
> > I run
> > >    the command "multipath -v2"
> > >=20
> > >=20
> > >=20
> > >    I've tried a number of different things in the
> /etc/multipath.conf
> > file,
> > >    but keep coming back to this same error.  If I run the command
> > manually I
> > >    get the following:
> > >=20
> > >=20
> > >=20
> > >    # /sbin/scsi_id -g -u -s /block/sda
> > >=20
> > >
0HP______OPEN-E__________50060e80039c5a0400000000000000000000e100
> > >=20
> > >=20
> > >=20
> > >    What's missing?  Any help greatly appreciated.
> >=20
> > You are not missing anything. The device id is too big to fit in
> > multipath tools allocated memory. The program incorrectly prints
that
> > there is a problem while executing /sbin/scsi_id but in fact the
> problem
> > lies in the program itself. You may have some old version of
multipath
> > tools. WWID_SIZE was set to 64 bytes and that is small for your
> device.
> > Get the latest version where that macro is set to 128 or so.
> >=20
> > Hope that helps!
> >=20
> > --Malahal.
