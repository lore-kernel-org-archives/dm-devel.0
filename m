From: "Child, David" <David.Child@ps.net>
Subject: RE: Multipathing with RHEL4 U2 on EMC DMX
Date: Thu, 16 Feb 2006 15:09:18 -0600
Message-ID: <2CF4E90F20CF3C4DBD3A71BD9FA2758D122FAF@PSCDALPEXCH03.perotsystems.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
List-Id: dm-devel.ids

Hello Brian,

Thanks for the tips. We aleady had the lvm.conf settings complete, but
your multipath.conf stanza for the Symmetrix was part of the solution.=20

Here is what I did to get it all working;

1. I found that the Symmetrix ID (serial number) for each LUN was
displaying FA port information instead of the common '000' digits (e.g.
790367051091 for LUN 051 on FA9, port 1). For multipath to work
correctly I would imagine that the C-bit setting (common serial number)
needed to be set on the Symmetrix FA port for that host. I checked with
the storage team and EMC PowerLink. We couldn't find any mention of
device-mapper, but PowerLink indicated that for Veritas DMP to work you
had to have the C-bit set so that was a fairly good confirmation. Once
the C-bit was set the serial numbers for both paths to a device came
back identical.

2. Added the SYMMETRIX device stanza listed in Brian's post to
/etc/multipath.conf;
	devices {
		device {
			vendor                  "EMC     "
			product                 "SYMMETRIX     "
			getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"
		}
	}=20

3. At this point auto-discovery of the paths worked, but my device files
were called things like: SEMC_____SYMMETRIX______790367051000. That
didn't look useful so I added the following to /etc/multipath.conf;
	multipaths {
		multipath {
			wwid
SEMC_____SYMMETRIX______790367051000
			alias                   sym051mp
		}
		<repeat for each LUN>
	}

4. So far so good. I now had multipath devices in /dev/mpath called
"sym???mp". This will take care of the persistence issues, but it wasn't
picking up any partitions on those devices. I'm sure there is a better
way to fix it, but a quick hack I did took care of that.=20

	a. I edited /etc/udev/rules.d/40-multipath.rules as follows;
		KERNEL=3D"dm-[0-9]*", PROGRAM=3D"/sbin/dmsetup ls --target
linear --exec /usr/local/sbin/dmsetup_parser.sh -j %M -m %m",
RESULT=3D"?*", NAME=3D"%k", SYMLINK=3D"mpath/%c"
		(the original line used "--target multipath", but that
didn't pick up partitions. --target linear works, but picks up all kinds
of DM stuff (logical volumes, etc.). I therefore had to create a custom
parsing script.)
=09
	b. Created the dmsetup_parser.sh PROGRAM (as I said, its just a
quick hack and not optimized or anything);
		#!/bin/bash
		dev=3D`basename $*`
		key=3D`echo $dev | cut -c 1-3`
		if [ "${key}" =3D "sym" ]; then
  			echo "$dev"
		fi
=09
Now I have auto-detected multipaths for each EMC Symm LUN and each
partition on those LUNs (if any). The last item of importance (the most
important actually) is to figure out why both paths to a device get
knocked offline (failed) at the same time when hit with high I/O (see
original post).

Thanks,
David

David Child
Email  David.Child@ps.net

-----Original Message-----
From: Brian Long <brilong cisco com>
To: device-mapper development <dm-devel redhat com>
Subject: Re: [dm-devel] Multipathing with RHEL4 U2 on EMC DMX
Date: Wed, 15 Feb 2006 14:52:12 -0500

On Fri, 2006-02-10 at 08:48 -0600, Child, David wrote:
> Hello,
>=20
> I've just recently connected some HP BL20p G3 blades running RHEL4 U2
> up to a DMX2000 (via McData switches). We didn't get PowerPath and
> intended to use device-mapper multipathing. I was able to get things
> up for the most part and get devices defined, but have to do that
> manually.

Hello David,

We have a /etc/lvm/lvm.conf and /etc/multipath.conf tweak you may be
interested in.  I've attached them to this email.

/Brian/
