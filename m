From: Dharmesh Kamdar <kamdard71@yahoo.com>
Subject: Re: mapper device perms on reboot
Date: Wed, 27 Feb 2008 10:17:34 -0800 (PST)
Message-ID: <788110.21147.qm@web90606.mail.mud.yahoo.com>
References: <342d47870802261304s54c3650dv83216abd8ffaee8f@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870802261304s54c3650dv83216abd8ffaee8f@mail.gmail.com>
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

Hi Scott,

This weblink may help -->
http://www.ardentperf.com/2008/02/13/oracle-clusterware-on-rhel5oel5-with=
-udev-and-multipath/
I've not tried this, but the author of the article
claims that it works..

We are also facing similar issue(s) with Oracle and
RHEL 5.1 using UDEV/Device-mapper..I've also posted a
query on the same
(https://www.redhat.com/archives/dm-devel/2008-February/msg00201.html)
...But it just discusses the changing of permissions,
however creation of raw devices using UDEV is not
specified, hence we are still looking for that answer.

Hope it helps somewhat.

Let us know.

Regards,
Dharmesh.


--- Scott Moseman <scmoseman@gmail.com> wrote:

> How can I get the mapper device permissions set on
> reboot?
>=20
> When I attempted to try this...
>=20
> # cat /etc/udev/permissions.d/50-udev.permissions |
> grep mapper
> mapper/mpath*:oracle:dba:0660
>=20
> But it did not seem to work...
>=20
> # ls -l /dev/mapper/mpath*
> brw-rw----  1 root disk 253, 2 Feb 26 20:56
> /dev/mapper/mpath0
> brw-rw----  1 root disk 253, 5 Feb 26 20:56
> /dev/mapper/mpath0p1
> brw-rw----  1 root disk 253, 3 Feb 26 20:56
> /dev/mapper/mpath1
> brw-rw----  1 root disk 253, 4 Feb 26 20:56
> /dev/mapper/mpath1p1
>=20
> Am I doing something wrong?  Is there another way to
> do this?
>=20
> Thanks,
> Scott
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20



      ___________________________________________________________________=
_________________
Be a better friend, newshound, and=20
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_y=
lt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ=20
