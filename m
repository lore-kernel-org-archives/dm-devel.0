From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: regarding DM device for a single path.
Date: Fri, 05 Aug 2005 19:58:18 +0200
Message-ID: <1123264699.21778.57.camel@zezette>
References: <E8C532D801BE5B479B28B626184E8CDD07C7F2FB@tayexc14.americas.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E8C532D801BE5B479B28B626184E8CDD07C7F2FB@tayexc14.americas.cpqcorp.net>
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


=20
>=20
>      1. I tested your latest user space tools with 2.6.9-11.41 kernel.
>         Used the default created devices for multipathing. The path
>         status is getting updated appropriately for HSV200 arrays.
>          However the failback functionality is not working for me. I
>         have configure value for =E2=80=9Cfailback=E2=80=9D variable
>         in /etc/multipath.conf as zero for immediate failback, but
>         when the failed path in the original path group comes back
>         online, the IO is not failed back the old pathgroup.
>=20
I'll look into that when I return from vacation in 2 weeks.
I think I'll have the appropriate HW at hand.
=20
>=20
>      1. In yesterday=E2=80=99s discussion, you mentioned that DM device=
 nodes
>         will not be created for the physical devices which are having
>         single path.  Assuming one particular device had 2 paths and
>         DM device was created and used by the applications. While the
>         system is rebooted for some reasons, and if one of the paths
>         for this device is lost, then the subsequent reboot will not
>         create the DM device as it sees only one path for this device.
>         And the DM device might be created only if the other path
>         comes back online and the HBA driver is rescanned for new
>         devices.  This may not be desired multipathing behaviour, as
>         the DM device does not exist if we one path for the device.
>=20
To my knowledge, mono-path multipath map are created.
At least they used to be last time I check with a parallel SCSI server.
Can you back with testing ?

Regards,

--=20
christophe varoqui <christophe.varoqui@free.fr>
