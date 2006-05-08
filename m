From: Shyam Sundar <g.shyamsundar@yahoo.co.in>
Subject: Re: multipath table for MSA-1000
Date: Tue, 9 May 2006 00:16:07 +0100 (BST)
Message-ID: <20060508231607.76537.qmail@web8503.mail.in.yahoo.com>
References: <1147125596.27764.57.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147125596.27764.57.camel@localhost.localdomain>
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


Is there any configuration parameter in dm to issue a
failover command (in this case probably a START_STOP
command) on the MSA so the failover happens
automatically when the primary path is not available ?


--- Christophe Varoqui <christophe.varoqui@free.fr>
wrote:

> Le lundi 08 mai 2006 =E0 22:43 +0100, Shyam Sundar a
> =E9crit :
> > I have a single port qla2342 initiator connected
> to a
> > MSA-1000 through a Switch.
> > The two ports of the MSA 1000 are connected to the
> > switch exposing 2 paths to the target LUNs.=20
> > When I display the topology using
> >=20
> > multipath -ll
> >=20
> > i get the output as follows:
> > 3600805................
> > [size=3D9GB][features=3D1
> queue_if_no_path][hwhandler=3D0]
> > \_round-robin 0 [prio=3D1][active]
> >  \_ 17:0:0:3 sda 8:0 [failed][faulty]
> >  \_ 17:0:1:3 sdi  8:128[active][ready]
> > 3600805................
> > ..............................
> > ..............................
> >=20
> >=20
> > Is it normal for a MSA1000 target to have a
> "faulty"
> > and a "ready" path.=20
>=20
> It is, as this hardware is active/passive.
> Which is not, is the multibus topology, where you
> should use group by
> serial or failover.
>=20
> > If yes, what does "faulty" signify
> > ?
>=20
> It means the path is not useable as-is. It is
> activated only when
> necesary or when asked to.
>=20
> > =20
> > Under what condition does the faulty path become
> > ready?
>=20
> "sg_start" the path or play with the LU ownership on
> the MSA management
> console.
>=20
> Regards,
> cvaroqui
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20



	=09
__________________________________________________________=20
Yahoo! India Answers: Share what you know. Learn something new.=20
http://in.answers.yahoo.com
