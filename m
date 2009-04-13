From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipath prio_callout broke from 5.2 to 5.3
Date: Mon, 13 Apr 2009 13:57:45 -0500
Message-ID: <20090413185745.GF15911@ether.msp.redhat.com>
References: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
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

On Mon, Apr 13, 2009 at 05:00:05AM -0400, John A. Sullivan III wrote:
> Thank you.  I'll detail our script and the logic behind it in a separat=
e
> email in case it is helpful to others.
>=20
> In the meantime, we have a critical problem where the script which was
> working perfectly in 5.2 is now broken in 5.3.  Is there any way to
> deconfuse the 5.3 multipathd or any other immediate solution? - John

What christophe said is correct. In RHEL 5.3, multipath started copying
all of the necessary callouts into it own private namespace. It scans
through your config file, and pulls out all the binaries.  However,
there are two problems that are affecting you.  First, it only pulls the
command, "/bin/bash" in you case, not the arguments, which for
you include a script to run.  Second, it's private namespace only
consists of /sbin, /bin, /tmp, a couple of virtual filesystems, like
/proc and /sys (well, actually there are a couple of others, like /etc,
that multipath needs to start up, but you shouldn't rely on them being
there all the time, since you can lose access to them if the device
they're on goes down)

There are two ways to deal with this.  First is to rewrite the
prioritizer in C.  I realize that this is a pain, but it will be
necessary to run on RHEL6 and new fedora machines, which use upstream's
prio functions instead of callout binaries.

The second, quicker way is to move your callout to /sbin and add a dummy
device section to make sure it gets picked up.

devices {
...
	device {
		vendor       "dummy"
		product      "dummy"
		prio_callout "/sbin/mpath_prio_ssi"
	}
}

This will cause multipathd to copy your script into the private
namespace, and everything should work, with one exception.

bash is not a statically linked executable.  It links to libraries,
and multipathd doesn't make its own copies of them.  Under normal
operation this will work (/lib is also in multipathd's
private namespace). However, if you lose access to /lib, bash won't
work, and multipathd won't be able to restore access to your devices.
If you aren't planning on multipathing / or /lib you might choose to
ignore this (The exact same problem exists in 5.2).

I don't believe that there is a statically linked shell in RHEL 5.
This is another reason to convert your callout to a C program. Or
you can recompile bash with static linking.

-Ben

> On Sun, 2009-04-12 at 09:13 +0200, christophe.varoqui@free.fr wrote:
> > John,
> >=20
> > Redhat-shiped multipathd populates upon start-up a private mem-backed=
 filesystem with binaries it needs.
> > Prio callouts in the form "$SHELL /path/to/myscript" seem to confuse =
the logic.
> > If you prio callout is of general interest, may be we can port it ups=
tream (as a shared object).
> > If you are interested, please describe and post the source.
> >=20
> > Regards,
> > cvaroqui
> >=20
> > ----- Mail Original -----
> > De: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
> > =C0: "device-mapper development" <dm-devel@redhat.com>
> > Envoy=E9: Dimanche 12 Avril 2009 06h07:55 GMT +01:00 Amsterdam / Berl=
in / Berne / Rome / Stockholm / Vienne
> > Objet: Re: [dm-devel] multipath prio_callout broke from 5.2 to 5.3
> >=20
> > On Sat, 2009-04-11 at 23:54 -0400, John A. Sullivan III wrote:
> > > Hello, all.  We are facing a serious problem with dm-multipath afte=
r our
> > > upgrade.  We use a bash script to set priorities for failover.  We
> > > understand multipathd cannot use a bash script directly so it has b=
een
> > > carefully crafted to use only internal commands and is loaded as:
> > >=20
> > > prio_callout            "/bin/bash /usr/local/sbin/mpath_prio_ssi %=
n"
> > >=20
> > > This has been working perfectly fine.  We upgraded our test lab to
> > > CentOS 5.3, device-mapper-multipath.x86_64 0.4.7-23.el5_3.2, kernel
> > > 2.6.29.1 (the 2.6.18 default causes a kernel panic with iSCSI).
> > > Suddenly, it is breaking.  /var/log/messages is filled with:
> > >=20
> > > Apr 11 23:17:15 kvm01 multipathd: cannot open /sbin/dasd_id : No su=
ch file or directory
> > > Apr 11 23:17:15 kvm01 multipathd: cannot open /sbin/gnbd_import : N=
o such file or directory
> > > Apr 11 23:17:15 kvm01 multipathd: [copy.c] cannot open /sbin/dasd_i=
d
> > > Apr 11 23:17:15 kvm01 multipathd: cannot copy /sbin/dasd_id in ramf=
s : No such file or directory
> > > Apr 11 23:17:15 kvm01 multipathd: [copy.c] cannot open /sbin/gnbd_i=
mport
> > > Apr 11 23:17:15 kvm01 multipathd: cannot copy /sbin/gnbd_import in =
ramfs : No such file or directory
> > > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> > > Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/=
local/sbin/mpath_prio_ssi sdc
> > > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> > > Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/=
local/sbin/mpath_prio_ssi sdd
> > > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> > > Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/=
local/sbin/mpath_prio_ssi sde
> > > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> > >=20
> > > The first several messages are expected but not the latter ones.  I=
f we
> > > run the call from the command line, e.g.,
> > > "/bin/bash /usr/local/sbin/mpath_prio_ssi sdc" it works perfectly f=
ine.
> > >=20
> > > What has changed and how do we fix it? I'll include a sample script
> > > below.  The script is dynamically created just before launching
> > > multipathd:
> > >=20
> > > #!/bin/bash
> > > # if not passed any device name, return a priority of 0
> > > if [ -z "${1}" ];then
> > >         echo 0
> > >         exit
> > > fi
> > >=20
> > > DEVS=3D"lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-i=
scsi-iqn.1986-03.com.sun:02:17f534f0-74af-e61b-a716-b8ac8e219dac-lun-0 ->=
 ../../sdj
> > > lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn=
.1986-03.com.sun:02:47c5e722-10d3-66c7-a952-d3d79732da9c-lun-0 -> ../../s=
dr
> > > lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn=
.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7-lun-0 -> ../../s=
dn"
> > >=20
> > > LIST=3D"172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-=
6fc9-922a-eb4540bee1c9->99
> > > 172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922=
a-eb4540bee1c9->49
> > > 172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922=
a-eb4540bee1c9->24"
> > >=20
> > > FOUND=3D0
> > > IFSORIG=3D${IFS}
> > > IFS=3D$'\n'
> > > for LINE in ${DEVS}
> > > do
> > >         ENTRY=3D${LINE%/${1}}
> > >         if [ ${#ENTRY} -ne ${#LINE} ];then # We found the line
> > >                 FOUND=3D1
> > >                 break
> > >         fi
> > > done
> > > if [ "$FOUND" =3D "0" ];then  # This is not an iSCSI device
> > >         echo 0
> > >         exit
> > > fi
> > > DEV=3D"${ENTRY##* ip-}"
> > > #DEV=3D"${DEV%% ->*}" # the pattern changed in CentOS 5.3
> > > #DEV=3D"$(echo ${DEV} | sed 's/-lun-[0-9][0-9]* ->.*//')"
> > > DEV=3D"${DEV%%-lun-[0-9]* ->*}"
> > > PRIORITY=3D0
> > > for LINE in ${LIST}
> > > do
> > >         DISK=3D${LINE%->*}
> > >         if [ "${DEV}" =3D "${DISK}" ];then
> > >                 PRIORITY=3D"${LINE##*->}"
> > >                 break
> > >         fi
> > > done
> > > echo ${PRIORITY}
> > >=20
> > > I did notice the semantics of /dev/disk/by-path changed and we adap=
ted
> > > to that.  We were planning to move this to production on Thursday s=
o
> > > this has thrown a huge spanner in the works.  Any help would be gre=
atly
> > > appreciated.  Thanks - John
> >=20
> > I've just notice that my console is filled with:
> >=20
> > /bin/bash: /usr/local/sbin/mpath_prio_ssi: No such file or directory
> >=20
> > but it is indeed there and owned by root and executable.  I've quintu=
ple
> > checked! Has multipathd been changed so it cannot read anything from
> > disk even if invoked from within bash? Thanks - John
> --=20
> John A. Sullivan III
> Open Source Development Corporation
> +1 207-985-7880
> jsullivan@opensourcedevel.com
>=20
> http://www.spiritualoutreach.com
> Making Christianity intelligible to secular society
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
