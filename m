From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: StorageWorks multipath support
Date: Wed, 15 Jun 2005 16:13:02 +0200
Message-ID: <20050615141302.GH11423@marowsky-bree.de>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
	<20050615134536.GC16446@averon.dyndns.org>
	<20050615135337.GG11423@marowsky-bree.de>
	<20050615140740.GD16446@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050615140740.GD16446@averon.dyndns.org>
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

On 2005-06-15T16:07:40, Christophe Varoqui <christophe.varoqui@free.fr> w=
rote:

> > Well, before, those paths were simply kept as "active" / "healthy" (a=
nd
> > from the point of view of the kernel code they are, just that the PG
> > they are in might not be enabled).
> >=20
> Mmm, not anymore.
>=20
> It was true till 0.4.4, but in HEAD there are patches to implement to p=
roactive DM-failing of checker-failed paths. This was a request from Tran=
 if I remember.

The emc_clariion checker considers the "ghost" paths to be healthy
because of that. (Which is true: they haven't failed, they are just
passive.)

That failed paths are not proactively failed is an orthogonal issue, and
a change I like ;-)

> > BTW, backporting uevent is a bit more annoying then I thought. How ab=
out
> > a way to manually prod the daemon? That might be useful in general, f=
or
> > example if a hotplug event was lost due to whatever reason...
> >=20
> Too bad.
>=20
> Can you elaborate on what you have in mind ?

Well, basically I'd like it if a SIGHUP would still cause the daemon to
reload the configuration and rescan the mappings. (Which is a common use
of SIGHUP.) Then we'd get the best of both worlds, we could re-trigger
it on the old dists and use the more efficient uevent on newer kernels.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
