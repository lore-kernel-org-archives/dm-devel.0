From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/19] san_path_err & multipath ANA support
Date: Tue, 8 Jan 2019 10:23:47 -0600
Message-ID: <20190108162347.GN11315@octiron.msp.redhat.com>
References: <20181218231931.10762-1-mwilck@suse.com>
	<20181221160640.GI11315@octiron.msp.redhat.com>
	<b717c0ca88c546da7fdeb5285bd65a7a26fefa6e.camel@suse.com>
	<20190107191504.GL11315@octiron.msp.redhat.com>
	<2f26519d60baf230bfed8fd73d402c1a90769bd6.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2f26519d60baf230bfed8fd73d402c1a90769bd6.camel@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 08, 2019 at 09:50:33AM +0100, Martin Wilck wrote:
> On Mon, 2019-01-07 at 13:15 -0600, Benjamin Marzinski wrote:
> > On Mon, Jan 07, 2019 at 12:21:55PM +0100, Martin Wilck wrote:
> > > On Fri, 2018-12-21 at 10:06 -0600, Benjamin Marzinski wrote:
> > > > I've been thinking about how we handle marginal paths, and it
> > > > seems
> > > > to
> > > > me that instead of telling the kernel that they have failed, it
> > > > might
> > > > be
> > > > better to create pathgroups of last resort, which contains
> > > > marginal
> > > > paths that should only be used if all the other paths are down.
> > > =

> > > Maybe we should simply assign marginal paths a very low priority? =

> > =

> > Yeah, that's the idea. The question is whether all the table
> > reloading
> > and messy configurations that could come with this outweighs the
> > benefit
> > of having the kernel automatically use these paths when nothing else
> > is
> > available.
> =

> I had a similar discussion with Hannes lately about "ghost" states
> (ALUA: STANDBY, ANA: INACCESSIBLE), which we currently represent as
> "OK" paths with priority =3D 1. Our current model with "OK" vs. "FAILED"
> paths, plus a numeric priority, isn't perfect for representing  either
> the cost of trespassing, or the temporary, "fuzzy" state of a path
> being "marginal".
> =

> That aside, we should probably just try the priority-based approach.
> Patches welcome :-)
> =

> Another question is whether "marginal" state should be a matter of path
> _group_ switching at all. We could also model it in the path selector
> using rr_weight.

I don't think that would work.  Imagine the flakey component being the
storage controller or the connection between the switch and the
controller. Most likely all of the effected paths would be in the same
pathgroup. If we didn't change the priority of those paths and they
happened to be the highest priority paths, then all the paths in the
highest priority pathgroup would be flakey.

> > > At least with "group_by_prio" and immediate failback, that would
> > > cause
> > > multipathd to switch to these paths if nothing else is available,
> > > and
> > > switch back ASAP - so it would give you the desired behavior almost
> > > at
> > > no cost. An open question for me is whether this priority should be
> > > higher or lower than what we assign to "ghost" paths ins standby
> > > state
> > > (1, currently).
> > > =

> > > Side note: the global "failback" policy setting may not fit the
> > > needs
> > > of all modern setups. I think that immediate failback is always
> > > correct
> > > for "marginal" vs. flawless paths, but we know that it's not always
> > > wanted for non-optimal vs. optimal paths, or other failback
> > > scenarios.
> > =

> > Agreed, but I don't think that there is another failback policy that
> > makes more sense as the global default.
> =

> I wasn't talking about defaults. We are currently not able to provide a
> policy that makes different decisions based on which priority the
> current and the best PG have. Our failback model simply doesn't have
> this feature. =

> =

> Btw it could be added quite simply, like this:
> =

>  - we agree on a priority value P_0 in all prioritizers (P_0 =3D 5, say)
>  - whever the prio of the current PG is below P_0, and another PG is
> above P_0, we fail back immediately, no matter what the current
> failback setting is.

Ah. Good point.

-Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
