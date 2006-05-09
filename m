From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipath load balancing?
Date: Wed, 10 May 2006 00:44:56 +0200
Message-ID: <1147214696.27764.80.camel@localhost.localdomain>
References: <1147130744.29855.1.camel@serpent.office.seatab.com>
	<1147212464.13567.2.camel@serpent.office.seatab.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147212464.13567.2.camel@serpent.office.seatab.com>
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

Le mardi 09 mai 2006 =C3=A0 15:07 -0700, Brad Dameron a =C3=A9crit :
> I am rewriting this since I received no answer.
>=20
> Does DM and Multipath tools now offer load balancing between 2 HBA port=
s
> to a single SAN? So if I have a 2 port HBA that can both see the same
> LUN I can setup a multipath device and it will then utilize both paths
> as one larger single path?
>=20
To my understanding, it does since day-1 : paths round-robining is the
one and only load-balancing algo implemented in DM.

Regards,
cvaroqui
