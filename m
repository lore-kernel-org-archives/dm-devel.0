From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: multipath prio_callout broke from 5.2 to 5.3
Date: Mon, 13 Apr 2009 05:00:05 -0400
Message-ID: <1239613205.6376.16.camel@jaspav.missionsit.net.missionsit.net>
References: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1779195765.1578721239520436084.JavaMail.root@zimbra16-e3.priv.proxad.net>
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

Thank you.  I'll detail our script and the logic behind it in a separate
email in case it is helpful to others.

In the meantime, we have a critical problem where the script which was
working perfectly in 5.2 is now broken in 5.3.  Is there any way to
deconfuse the 5.3 multipathd or any other immediate solution? - John

On Sun, 2009-04-12 at 09:13 +0200, christophe.varoqui@free.fr wrote:
> John,
>=20
> Redhat-shiped multipathd populates upon start-up a private mem-backed f=
ilesystem with binaries it needs.
> Prio callouts in the form "$SHELL /path/to/myscript" seem to confuse th=
e logic.
> If you prio callout is of general interest, may be we can port it upstr=
eam (as a shared object).
> If you are interested, please describe and post the source.
>=20
> Regards,
> cvaroqui
>=20
> ----- Mail Original -----
> De: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
> =C3=80: "device-mapper development" <dm-devel@redhat.com>
> Envoy=C3=A9: Dimanche 12 Avril 2009 06h07:55 GMT +01:00 Amsterdam / Ber=
lin / Berne / Rome / Stockholm / Vienne
> Objet: Re: [dm-devel] multipath prio_callout broke from 5.2 to 5.3
>=20
> On Sat, 2009-04-11 at 23:54 -0400, John A. Sullivan III wrote:
> > Hello, all.  We are facing a serious problem with dm-multipath after =
our
> > upgrade.  We use a bash script to set priorities for failover.  We
> > understand multipathd cannot use a bash script directly so it has bee=
n
> > carefully crafted to use only internal commands and is loaded as:
> >=20
> > prio_callout            "/bin/bash /usr/local/sbin/mpath_prio_ssi %n"
> >=20
> > This has been working perfectly fine.  We upgraded our test lab to
> > CentOS 5.3, device-mapper-multipath.x86_64 0.4.7-23.el5_3.2, kernel
> > 2.6.29.1 (the 2.6.18 default causes a kernel panic with iSCSI).
> > Suddenly, it is breaking.  /var/log/messages is filled with:
> >=20
> > Apr 11 23:17:15 kvm01 multipathd: cannot open /sbin/dasd_id : No such=
 file or directory
> > Apr 11 23:17:15 kvm01 multipathd: cannot open /sbin/gnbd_import : No =
such file or directory
> > Apr 11 23:17:15 kvm01 multipathd: [copy.c] cannot open /sbin/dasd_id
> > Apr 11 23:17:15 kvm01 multipathd: cannot copy /sbin/dasd_id in ramfs =
: No such file or directory
> > Apr 11 23:17:15 kvm01 multipathd: [copy.c] cannot open /sbin/gnbd_imp=
ort
> > Apr 11 23:17:15 kvm01 multipathd: cannot copy /sbin/gnbd_import in ra=
mfs : No such file or directory
> > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> > Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/lo=
cal/sbin/mpath_prio_ssi sdc
> > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> > Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/lo=
cal/sbin/mpath_prio_ssi sdd
> > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> > Apr 11 23:17:15 kvm01 multipathd: error calling out /bin/bash /usr/lo=
cal/sbin/mpath_prio_ssi sde
> > Apr 11 23:17:15 kvm01 multipathd: /bin/bash exitted with 127
> >=20
> > The first several messages are expected but not the latter ones.  If =
we
> > run the call from the command line, e.g.,
> > "/bin/bash /usr/local/sbin/mpath_prio_ssi sdc" it works perfectly fin=
e.
> >=20
> > What has changed and how do we fix it? I'll include a sample script
> > below.  The script is dynamically created just before launching
> > multipathd:
> >=20
> > #!/bin/bash
> > # if not passed any device name, return a priority of 0
> > if [ -z "${1}" ];then
> >         echo 0
> >         exit
> > fi
> >=20
> > DEVS=3D"lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-isc=
si-iqn.1986-03.com.sun:02:17f534f0-74af-e61b-a716-b8ac8e219dac-lun-0 -> .=
./../sdj
> > lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1=
986-03.com.sun:02:47c5e722-10d3-66c7-a952-d3d79732da9c-lun-0 -> ../../sdr
> > lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1=
986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7-lun-0 -> ../../sdn=
"
> >=20
> > LIST=3D"172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6f=
c9-922a-eb4540bee1c9->99
> > 172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-=
eb4540bee1c9->49
> > 172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-=
eb4540bee1c9->24"
> >=20
> > FOUND=3D0
> > IFSORIG=3D${IFS}
> > IFS=3D$'\n'
> > for LINE in ${DEVS}
> > do
> >         ENTRY=3D${LINE%/${1}}
> >         if [ ${#ENTRY} -ne ${#LINE} ];then # We found the line
> >                 FOUND=3D1
> >                 break
> >         fi
> > done
> > if [ "$FOUND" =3D "0" ];then  # This is not an iSCSI device
> >         echo 0
> >         exit
> > fi
> > DEV=3D"${ENTRY##* ip-}"
> > #DEV=3D"${DEV%% ->*}" # the pattern changed in CentOS 5.3
> > #DEV=3D"$(echo ${DEV} | sed 's/-lun-[0-9][0-9]* ->.*//')"
> > DEV=3D"${DEV%%-lun-[0-9]* ->*}"
> > PRIORITY=3D0
> > for LINE in ${LIST}
> > do
> >         DISK=3D${LINE%->*}
> >         if [ "${DEV}" =3D "${DISK}" ];then
> >                 PRIORITY=3D"${LINE##*->}"
> >                 break
> >         fi
> > done
> > echo ${PRIORITY}
> >=20
> > I did notice the semantics of /dev/disk/by-path changed and we adapte=
d
> > to that.  We were planning to move this to production on Thursday so
> > this has thrown a huge spanner in the works.  Any help would be great=
ly
> > appreciated.  Thanks - John
>=20
> I've just notice that my console is filled with:
>=20
> /bin/bash: /usr/local/sbin/mpath_prio_ssi: No such file or directory
>=20
> but it is indeed there and owned by root and executable.  I've quintupl=
e
> checked! Has multipathd been changed so it cannot read anything from
> disk even if invoked from within bash? Thanks - John
--=20
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
