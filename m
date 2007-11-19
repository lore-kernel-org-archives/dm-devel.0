From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [RFC] How to fix system stall on root volume multipath
Date: Mon, 19 Nov 2007 01:17:41 +0100
Message-ID: <1195431462.27535.43.camel@localhost.localdomain>
References: <20071109.181719.115904569.k-ueda@ct.jp.nec.com>
	<20071110033113.GA22843@agk.fab.redhat.com>
	<20071112.112454.71086888.k-ueda@ct.jp.nec.com>
	<1194915684.6724.66.camel@localhost.localdomain>
	<1195202472.27535.27.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1195202472.27535.27.camel@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


Le vendredi 16 novembre 2007 =C3=A0 09:41 +0100, Christophe Varoqui a =C3=
=A9crit :
> > > Ben, Christophe,
> > > Is that code still problem for current multipathd?
> > > And what do you think about my proposal?
> > >=20
> > I'm not found of yet-another user-visible ramfs for multipathd use,
> > that's why I started with the private namespace tricks. The problems =
are
> > still there, and will stay till we stop using pthreads.
> >=20
> > That may happen someday, as one of the main reason for pthread was th=
e
> > (blocking ioctl) libdevmapper event collection. And this is being
> > superseded by path status uevents.
> >=20
> > But not soon enough, and the private namespace stuff suffers from lac=
k
> > of friendliness anyway : we can't expect users to grasp easily that
> > changing their prioritizer in /sbin won't be seen by the multipath
> > daemon till restart, for example.
> >=20
> > So I propose to start playing with your prioritizers-as-lib idea to s=
ee
> > if it's practical.
> >=20
> > I prepared the following patch to that effect. It is not complete
> > (actually segfaults, no useful prioritizer ported) but can start fixi=
ng
> > bugs and go where ever your personnal interest leads.
> >=20
> I'm sorry I forgot to post the git-cached part of the changeset, i.e.
> libprio/ files.
>=20
> There it goes.

Upstream git hosts the initial libprio/ commit.

I ported all useful prioritizers, leaving balance_units in the dark.
(If someone is actually using it, please say so)

This time, I cared for a bit of testing and the stuff seems to actually
work.

Now I'm interested in feedback from the Netapp fault injection team.
And any other feedback.

Regards,
cvaroqui
>=20
