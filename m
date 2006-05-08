From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Setting up a multipath device
Date: Mon, 08 May 2006 23:33:15 +0200
Message-ID: <1147123995.27764.46.camel@localhost.localdomain>
References: <445A0AE9.20907@voltaire.com> <20060504144915.GA2319@pundit>
	<445A1D88.7030500@voltaire.com>
	<1146768927.27764.12.camel@localhost.localdomain>
	<445DFD9D.4040402@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <445DFD9D.4040402@voltaire.com>
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

Le dimanche 07 mai 2006 =C3=A0 17:01 +0300, Erez Zilber a =C3=A9crit :
> Some more questions:
>=20
>    1. I couldn't find the config file. Where is it located? Is there an=
y
>       documentation about it?

The config file normal location is /etc/multipath.conf

>    2. How can I configure fancy naming for devices (instaed of using
>       something like /dev/mapper/3600c0ff00000000007c1d121c397f503) in
>       the config file?

Have a look at the templates provided with the upstream package.

>    3. How can I config the delay from the time that a device has failed
>       until the dm moves to the next active device? Again, I understand
>       that I should use the config file somehow.
>=20
Ditto.

> I tried to run the following test: I created a multipath device with 2=20
> physical devices (/dev/sda & /dev/sdb). I started running traffic on th=
e=20
> multipath device. All traffic ran through /dev/sda. Then, I disconnecte=
d=20
> the iSCSI target that was represented by /dev/sda. After some time, the=
=20
> traffic was directed to /dev/sdb. I stopped the traffic, disconnected=20
> the iSCSI target that was represented by /dev/sdb and reconnected=20
> /dev/sda. Now, if I run `multipath -l`, I see the following output:
>=20
> 3600c0ff00000000007c1d121c397f503
> [size=3D10 GB][features=3D0][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 0:0:0:0 sda 8:0   [failed][undef]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 1:0:0:0 sdb 8:16  [failed][faulty]
>=20
> /dev/sdb is dead and I'm ok with it. However, /dev/sda is alive. I was=20
> able to run the following command:
>=20
> dd if=3D/dev/sda of=3D/dev/null count=3D100000
>=20
> However, if I run the following command:
>=20
> dd if=3D/dev/mapper/3600c0ff00000000007c1d121c397f503 of=3D/dev/null=20
> count=3D100000
>=20
> This is what I get:
>=20
> dd: reading `/dev/mapper/3600c0ff00000000007c1d121c397f503':=20
> Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.00067 seconds, 0.0 kB/s
>=20
> Can't it recongnize that a device that has failed (/dev/sda) is back to=
=20
> life?
>=20
Is the daemon (multipathd) running ? The daemon takes care of path
revalidation.

Regards,
cvaroqui
