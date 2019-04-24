From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External]  Re: [PATCH] dm-writecache: avoid unnecessary lookups
 in writecache_find_entry
Date: Wed, 24 Apr 2019 04:08:24 +0000
Message-ID: <HK2PR03MB4418482EB0C2C73559FACD7F923C0@HK2PR03MB4418.apcprd03.prod.outlook.com>
References: <20190420162102.6460-1-yehs2007@zoho.com>
 <alpine.LRH.2.02.1904231140240.17390@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1904231140240.17390@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "prarit@redhat.com" <prarit@redhat.com>, NingTing Cheng <chengnt@lenovo.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Huaisheng Ye <yehs2007@zoho.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>
Sent: Tuesday, April 23, 2019 11:44 PM
>=20
> On Sun, 21 Apr 2019, Huaisheng Ye wrote:
>=20
> > From: Huaisheng Ye <yehs1@lenovo.com>
> >
> > Only when entry has been found, that would only be necessary to check t=
he
> > lowest or highest seq-count.
> >
> > Add local variable "found" in writecache_find_entry, if no entry has be=
en
> > found, it is meaningless that having a useless rb_prev or rb_next.
>=20
>=20
> Hi
>=20
> I don't quite see what is this patch trying to fix.
> Don't fix something that isn't broken

Hi Mikulas,

Thanks for your reply.
This patch is not designed for fixing logical error. That is used for optim=
izing the behavior of writecache_find_entry.

Let me give an example to illustrate the point below.
Suppose that is the case, here is a normal READ bio comes to writecache_map=
. And because of bio's direction is READ, writecache_find_entry would be ca=
lled with flags WFE_RETURN_FOLLOWING.

Now there are two scenarios,=20
1. writecache_find_entry successfully get an existing entry by searching rb=
_tree, we could call it HIT. Then the first 'while' will be finished by 'br=
eak'. Next it will move to second 'while' loop, because of the flags hasn't=
 been marked as WFE_LOWEST_SEQ. writecache_find_entry will try to return an=
 entry with HIGHEST_SEQ, if there are other entries which has same original=
_sector in rb_tree.
For this situation, the current code is okay to deal with it.

2. writecache_find_entry couldn't get an existing entry from rb_tree, we co=
uld call it MISS. Because of same flags WFE_RETURN_FOLLOWING, writecache_fi=
nd_entry will get other entry, which's original_sector will slightly larger=
 than input parameter block, with big probability.
For this scenario, function writecache_find_entry doesn't need to enter sec=
ond 'while' loop. But current code would still try to check there were othe=
r entry with same original_sector.
So the additional rb_next or rb_prev is unnecessary by this case, also the =
code doesn't need to compare the original_sector of 'e2' with parameter 'bl=
ock'.

My patch is designed to optimize the second case. so we could skip the seco=
nd 'while' loop when the block is missed from rb_tree.

Cheers,
Huaisheng Ye

>=20
> > Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> > ---
> >  drivers/md/dm-writecache.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> > index ddf1732..047ae09 100644
> > --- a/drivers/md/dm-writecache.c
> > +++ b/drivers/md/dm-writecache.c
> > @@ -537,14 +537,18 @@ static struct wc_entry *writecache_find_entry(str=
uct dm_writecache *wc,
> >  {
> >  	struct wc_entry *e;
> >  	struct rb_node *node =3D wc->tree.rb_node;
> > +	bool found =3D false;
> >
> >  	if (unlikely(!node))
> >  		return NULL;
> >
> >  	while (1) {
> >  		e =3D container_of(node, struct wc_entry, rb_node);
> > -		if (read_original_sector(wc, e) =3D=3D block)
> > +		if (read_original_sector(wc, e) =3D=3D block) {
> > +			found =3D true;
> >  			break;
> > +		}
> > +
> >  		node =3D (read_original_sector(wc, e) >=3D block ?
> >  			e->rb_node.rb_left : e->rb_node.rb_right);
> >  		if (unlikely(!node)) {
> > @@ -564,7 +568,8 @@ static struct wc_entry *writecache_find_entry(struc=
t dm_writecache *wc,
> >  		}
> >  	}
> >
> > -	while (1) {
> > +	/* only need to check lowest or highest seq-count when entry has been=
 found */
> > +	while (found) {
> >  		struct wc_entry *e2;
> >  		if (flags & WFE_LOWEST_SEQ)
> >  			node =3D rb_prev(&e->rb_node);
> > @@ -577,6 +582,9 @@ static struct wc_entry *writecache_find_entry(struc=
t dm_writecache *wc,
> >  			return e;
> >  		e =3D e2;
> >  	}
> > +
> > +	/* no entry has been found, return the following entry */
> > +	return e;
> >  }
> >
> >  static void writecache_insert_entry(struct dm_writecache *wc, struct w=
c_entry *ins)
> > --
> > 1.8.3.1
> >
> >
