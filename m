From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Multipath load balancing?
Date: Wed, 10 May 2006 13:29:56 +0200
Message-ID: <OFF145ED5E.1C3D90E3-ONC125716A.003B41FD-C125716A.003EFC5E@de.ibm.com>
References: <1147214696.27764.80.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147214696.27764.80.camel@localhost.localdomain>
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

Some would make a diference between load-balancing and round-robin. The=20
currently
available round-robin selector switches paths based on a fix number of=20
requests that
have been sent to one path. Quite some time ago I posted a load-level pat=
h=20
selector
that tries to select a path also based on the number of requests that are=
=20
still being
processed. Unfortunately this also required some changes to the main code=
=20
and
Alasdair hasn't much time to integrate new features.

Regards,
Stefan

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 10.05.2006 00:44:56:

> Le mardi 09 mai 2006 =E0 15:07 -0700, Brad Dameron a =E9crit :
> > I am rewriting this since I received no answer.
> >=20
> > Does DM and Multipath tools now offer load balancing between 2 HBA=20
ports
> > to a single SAN? So if I have a 2 port HBA that can both see the same
> > LUN I can setup a multipath device and it will then utilize both path=
s
> > as one larger single path?
> >=20
> To my understanding, it does since day-1 : paths round-robining is the
> one and only load-balancing algo implemented in DM.
>=20
> Regards,
> cvaroqui
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
