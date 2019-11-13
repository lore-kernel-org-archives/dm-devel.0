From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: fix mpp->nr_active more than
 actually active
Date: Wed, 13 Nov 2019 15:12:06 -0600
Message-ID: <20191113211206.GF30153@octiron.msp.redhat.com>
References: <cd8528f6f2224121ab586f9cd05bf87c@h3c.com>
	<996e9408b64fabe3337d55937acd2c22b9b89792.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <996e9408b64fabe3337d55937acd2c22b9b89792.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.de>
Cc: Wangyong <wang.yongD@h3c.com>, Chengchiwen <chengchiwen@h3c.com>, Guozhonghua <guozhonghua@h3c.com>, Zhangguanghui <zhang.guanghui@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changlimin <changlimin@h3c.com>, Wangxibo <wang.xibo@h3c.com>, Chongyun Wu <wu.chongyun@h3c.com>, "Martin Wilck (mwilck@suse.com)" <mwilck@suse.com>
List-Id: dm-devel.ids

On Wed, Nov 13, 2019 at 09:32:33AM +0100, Martin Wilck wrote:
> On Wed, 2019-11-13 at 07:16 +0000, Chongyun Wu wrote:
> > Hi Martin, Ben and other viewers
> >=20
> > Cloud you help to view below patch, we have reproduce this issue and
> > found a way to fix it, thanks.
> >=20
> > From b3e5d5919668b03185a039fb54962c47d339bb54 Mon Sep 17 00:00:00
> > 2001
> > From: Chongyun Wu <wu.chongyun@h3c.com>
> > Date: Wed, 13 Nov 2019 14:52:07 +0800
> > Subject: [PATCH] multipathd: fix mpp->nr_active more than actually
> > active
> >  paths count
> >=20
> > In check_path if path check thread not return in next round check but
> > return before timeout happen, the path state will be PAHT_PENDING,
> > when return up check_path will try to call reinstate_path, in this
> > situation should not pass add_active=3D1 into reinstate_path func as
> > parameter, other wise the mpp->nr_active will bigger than actually
> > active paths count.
> >=20
> > We have a environment can reproduce this issue, with this patch issue
> > not found again.
>=20
> I wonder how this can happen. In my opinion pp->state can never be set
> to PATH_PENDING, and thus oldstate can never have that value, either.
>=20
> Are you running the latest upstream code? In particular, do you have=20
> e224d57a13cb ("libmutipath: continue to use old state on
> PATH_PENDING")?

Not that it matters to the correctness of this patch, bub that commit
does allow pp->state to be set to PATH_PENDING. It's just pretty
convoluted.  You need two calls to pathinfo, the first needs to set the
path state to PATH_WILD or PATH_UNCHECKED, and a later one needs to set
the path state to PATH_PENDING. Then the path will be in a PATH_PENDING
state during the call to check path. Perhaps pathinfo should never set a
path's state to PATH_WILD, PATH_UNCHECKED, or PATH_PENDING, unless it is
already one of those values.

But I still don't see how the patch helps. check_path() calls
set_no_path_retry(), which will recalculate nr_active, counting any path
not in PATH_UP or PATH_GHOST as down.  Because of this, it should always
be correct to set add_active when a path changes from a state that isn't
PATH_UP or PATH_GHOST to one of those states. Do you know why this
wouldn't be happening in your scenario?=20

> Anyway, the ongoing struggle to get nr_active right bothers me.
>=20
> @Ben, I'm inclined to remove nr_active altogether and calculate it on
> the fly. What do you think?

I would happily ACK a patch that always calculated the current number of
active paths on the fly.

> Regards
> Martin
>=20
