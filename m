From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: small dm mpath cleanups
Date: Fri, 28 Apr 2017 20:42:36 +0000
Message-ID: <1493412156.2767.21.camel@sandisk.com>
References: <20170426074039.14602-1-hch@lst.de>
         <1493232084.2632.5.camel@sandisk.com> <20170427063318.GA20345@lst.de>
         <20170428202358.GA28562@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170428202358.GA28562@redhat.com>
Content-Language: en-US
Content-ID: <8EC6DA55B3791F419EAB5177D06A4497@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

On Fri, 2017-04-28 at 16:23 -0400, Mike Snitzer wrote:
> On Thu, Apr 27 2017 at  2:33am -0400, hch@lst.de <hch@lst.de> wrote:
> > On Wed, Apr 26, 2017 at 06:41:27PM +0000, Bart Van Assche wrote:
> > > On Wed, 2017-04-26 at 09:40 +0200, Christoph Hellwig wrote:
> > > > this series has some prep patches for my work to have proper, type
> > > > checked block errors codes.  One fallout of that is that we need to
> > > > get rid of how dm overloads a few return values with either interna=
l
> > > > positive error codes or negative errno values.  This patches does
> > > > that, which happens to clean things up a bit, and also allows us
> > > > dm to propagate the actual error code in one case where it currentl=
y
> > > > is dropped on the floor.
> > >=20
> > > Hello Christoph,
> > >=20
> > > Some patches in this series conflict with patches I would like to end=
 up in
> > > the stable kernel series. If I would rebase my patch series on top of=
 your
> > > series then that would make it harder to apply my patches on the stab=
le
> > > kernel trees. Mike and Christoph, please advise how to proceed.
> >=20
> > Bugfixes always go before cleanups.  I'd be happy to delay and/or rebas=
e
> > any of my patches as needed.
>=20
> I rebased your patchset ontop of Bart's patchset that I've already
> staged in linux-dm.git's 'dm-4.12' branch.
>=20
> When I try to apply this rebased patchset, it turns out 'dm-4.12' is
> missing linux-block.git commit 8fc779805 ("dm mpath: don't check for
> req->errors").  Because of this your first patch ("dm mpath: merge
> do_end_io into multipath_end_io") won't apply due to conflict.
>=20
> Not sure how we skin this cat.  Unfortunately Jens cannot easily pick
> this rebased patchset up because he'll be missing all of Bart's changes
> that I've staged in linux-dm.git's 'dm-4.12'.
>=20
> In hindsight, linux-block.git commit 8fc779805 likely should've been
> routed through linux-dm.git.  But not a big deal.
>=20
> How should we skin this cat of getting your changes into 4.12?  I could
> send a 2nd pull request to Linus after both linux-block.git and
> linux-dm.git are merged... sound OK?
>=20
> Until then, and/or for now, I've staged the fully merged result in
> linux-next via linux-dm.git's 'for-next', see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.gi=
t/log/?h=3Dfor-next

Hello Mike,

A few days ago Linus wrote that he is OK with occasional cherry-picking of
patches to resolve scenarios like the one described above (see also
https://lkml.org/lkml/2017/4/14/484). How about cherry-picking the necessar=
y
commit(s) from Jens' tree into the dm for-next branch?

Bart.=
