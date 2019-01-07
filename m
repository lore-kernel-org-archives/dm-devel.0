From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/19] san_path_err & multipath ANA support
Date: Mon, 7 Jan 2019 13:15:04 -0600
Message-ID: <20190107191504.GL11315@octiron.msp.redhat.com>
References: <20181218231931.10762-1-mwilck@suse.com>
	<20181221160640.GI11315@octiron.msp.redhat.com>
	<b717c0ca88c546da7fdeb5285bd65a7a26fefa6e.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b717c0ca88c546da7fdeb5285bd65a7a26fefa6e.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: mwilck+gmail@suse.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 07, 2019 at 12:21:55PM +0100, Martin Wilck wrote:
> On Fri, 2018-12-21 at 10:06 -0600, Benjamin Marzinski wrote:
> > =

> > I've been thinking about how we handle marginal paths, and it seems
> > to
> > me that instead of telling the kernel that they have failed, it might
> > be
> > better to create pathgroups of last resort, which contains marginal
> > paths that should only be used if all the other paths are down.
> =

> Maybe we should simply assign marginal paths a very low priority? =


Yeah, that's the idea. The question is whether all the table reloading
and messy configurations that could come with this outweighs the benefit
of having the kernel automatically use these paths when nothing else is
available.
 =

> At least with "group_by_prio" and immediate failback, that would cause
> multipathd to switch to these paths if nothing else is available, and
> switch back ASAP - so it would give you the desired behavior almost at
> no cost. An open question for me is whether this priority should be
> higher or lower than what we assign to "ghost" paths ins standby state
> (1, currently).
> =

> Side note: the global "failback" policy setting may not fit the needs
> of all modern setups. I think that immediate failback is always correct
> for "marginal" vs. flawless paths, but we know that it's not always
> wanted for non-optimal vs. optimal paths, or other failback scenarios.

Agreed, but I don't think that there is another failback policy that
makes more sense as the global default.

> > =

> > The downsides to this method are that it is quite possible that it
> > could
> > double the number of pathgroups whenever you have connection issues,
> > since a connection issue near the host HBA could cause a marginal
> > path
> > in each pathgroup. This means more reloading tables, and more
> > confusing
> > layouts.
> > =

> > The upside to this method is that multipath won't run out of paths
> > while
> > their are still marginal paths that it could use. When queuing isn't
> > enabled, there's nothing to stop the kernel from failing IO while
> > potentially usable marginal paths exist.
> > =

> > On the other hand, this problem could be mitigated by having
> > multipath
> > work such that, when marginal path detection is configured, it always
> > makes sure that no_path_retry is at least some minimum value that we
> > believe is long enough for multipathd to be notified of the path
> > failure
> > by the kernel and to reinstate the marginal paths.
> =

> I'd rather simply document that we discourage "no_path_retry =3D fail"
> while marginall path detection is enabled. "long enough" sounds like a
> can of worms to me.

Sure.

-Ben

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
