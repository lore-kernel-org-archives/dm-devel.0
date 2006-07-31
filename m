From: "Jeff Gibson" <jgibson@spscommerce.com>
Subject: RE: Bug in multipath detecting devices
Date: Mon, 31 Jul 2006 18:14:08 -0500
Message-ID: <E59516884AA0B041BCB80771B771498336519B@lumbergh.spscommerce.com>
References: <1154387006.29739.24.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1154387006.29739.24.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The need is Oracle.  We're running an Oracle RAC configuration which
needs the device numbers for it's raw partitions and especially for
ASMlib.  If the device numbers change very bad things could happen.
Since multipath is probably used more for enterprise applications I
would think this would be a concern.=20

I don't understand what you mean about the names being static if they
start pointing to different devices. =20

-----Original Message-----
From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
Sent: Monday, July 31, 2006 6:03 PM
To: Jeff Gibson
Cc: dm-devel@redhat.com
Subject: Re: Bug in multipath detecting devices


> It seems that if you have more than 26 disks/luns it will detect sdaa=20
> before it detects sdb (sda is the onboard raid & is blacklisted).  The

> result is that the major/minor numbers in /dev/mapper get out of order

> with the disks presented to the system.  For example:
>=20
Yes.

Nobody claimed mapper devices numbers are static nor even predictible.
But their names really are.

Actually, you shouldn't trust Linux device number at all : the dynamic
device numbering idea still has fans amongst kernel developpers, I guess
;)


> The major problem with this is that if I add another disk/lun in the=20
> future sdaa will change to another disk.  This is because sdaa is on=20
> the second port of the qlogic card and gets detected as a later device

> than before.  When multipath comes along it creates the device in=20
> /dev/mapper that sdaa is a member of before sdb's device is created. =20
> As a result the multipath devices aren't in the same sequnce as the=20
> devices that the OS detects (sdb, sdc, etc).  It would be better if=20
> sdb was always detected before sdaa.  However, I don't see a way to do

> that in /etc/multipath.conf without blacklisting all of the sda*
drives.
> Another option would be to have a user-configurable scan order, which=20
> I don't think exists (correct me if I'm wrong).
>=20
The multipath assembly walks the device list as show by "ls
/sys/block/", ie alphabetically.

I still don't see the need to do it differently.

Regards,
cvaroqui
