From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath table for MSA-1000
Date: Mon, 08 May 2006 23:59:56 +0200
Message-ID: <1147125596.27764.57.camel@localhost.localdomain>
References: <20060508214319.6871.qmail@web8510.mail.in.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060508214319.6871.qmail@web8510.mail.in.yahoo.com>
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

Le lundi 08 mai 2006 =C3=A0 22:43 +0100, Shyam Sundar a =C3=A9crit :
> I have a single port qla2342 initiator connected to a
> MSA-1000 through a Switch.
> The two ports of the MSA 1000 are connected to the
> switch exposing 2 paths to the target LUNs.=20
> When I display the topology using
>=20
> multipath -ll
>=20
> i get the output as follows:
> 3600805................
> [size=3D9GB][features=3D1 queue_if_no_path][hwhandler=3D0]
> \_round-robin 0 [prio=3D1][active]
>  \_ 17:0:0:3 sda 8:0 [failed][faulty]
>  \_ 17:0:1:3 sdi  8:128[active][ready]
> 3600805................
> ..............................
> ..............................
>=20
>=20
> Is it normal for a MSA1000 target to have a "faulty"
> and a "ready" path.=20

It is, as this hardware is active/passive.
Which is not, is the multibus topology, where you should use group by
serial or failover.

> If yes, what does "faulty" signify
> ?

It means the path is not useable as-is. It is activated only when
necesary or when asked to.

> =20
> Under what condition does the faulty path become
> ready?

"sg_start" the path or play with the LU ownership on the MSA management
console.

Regards,
cvaroqui
