From: Jose Nuno Neto <j.neto@eib.org>
Subject: Re: Too many paths from multipath?
Date: Wed, 02 Dec 2009 18:57:08 +0100
Message-ID: <4B16AA74.7050307@eib.org>
References: <4B168B7F.6060307@eib.org> <1259774764.2177.9.camel@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <1259774764.2177.9.camel@localhost>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jsosic@srce.hr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Ok that seems right, but on my case I have 4connections per HBA total of=20
8per Lun

The info I got regarding zoning is that each HBA is connected/zoned to=20
only one Storage controller
So that would make 2connections per Lun

What I suspect is that the Fabric here is made of 4switchs and that=20
makes 4x plus. The SAN people just configured it with a generic "big"=20
fabric zoning just one connection. but Linux shoes 4. could this be the=20
reason?

Jakov Sosic wrote:
> On Wed, 2009-12-02 at 16:45 +0100, Jose Nuno Neto wrote:
>
>  =20
>> I have 2 HBAs connected to one LUN on a Hitachi Storage. Only two=20
>> connections have been zoned
>>    =20
>
> If one connection goes to one switch, and that switch is connected to
> two controllers on the storage, then you'll see two paths on that HBA i=
n
> your host. If you have two HBA's and second is connected to second
> switch, which is also connected to two controllers of the stroage, then
> you'll see 4 of them.
>
> That is the situation in my company. It goes like this:
>
>
>              ________Hitachi controller0
>             /
> HOST----switch0
>             \
>              \_______Hitachi controller1
>
>
>
>
>
>  =20

--------------------------------------------------------------------

Les informations contenues dans ce message et/ou ses annexes sont=20
reservees a l'attention et a l'utilisation de leur destinataire et peuven=
t etre=20
confidentielles. Si vous n'etes pas destinataire de ce message, vous etes=
=20
informes que vous l'avez recu par erreur et que toute utilisation en est=20
interdite. Dans ce cas, vous etes pries de le detruire et d'en informer l=
a=20
Banque Europeenne d'Investissement.

The information in this message and/or attachments is intended solely for=
=20
the attention and use of the named addressee and may be confidential. If=20
you are not the intended recipient, you are hereby notified that you have=
=20
received this transmittal in error and that any use of it is prohibited. =
In=20
such a case please delete this message and kindly notify the European=20
Investment Bank accordingly.
--------------------------------------------------------------------
=20
