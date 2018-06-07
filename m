From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/2] mpathpersist: add all_tg_pt option
Date: Thu, 7 Jun 2018 11:20:55 -0500
Message-ID: <20180607162055.GG3103@octiron.msp.redhat.com>
References: <1527891722-11132-1-git-send-email-bmarzins@redhat.com>
	<97cd3d03418bb923941096309db1d3b53e2f89ca.camel@suse.com>
	<20180606215629.GD3103@octiron.msp.redhat.com>
	<86960c65d505dffe2f0d1b7b6db918c6944e9057.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <86960c65d505dffe2f0d1b7b6db918c6944e9057.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 07, 2018 at 09:24:00AM +0200, Martin Wilck wrote:
> On Wed, 2018-06-06 at 16:56 -0500, Benjamin Marzinski wrote:
> > On Wed, Jun 06, 2018 at 10:25:36PM +0200, Martin Wilck wrote:
> > > =

> > > The patch looks good to me, but doesn't this mean that mpathpersist
> > > would now also support persistent reservations with the ALL_TG_PT
> > > bit
> > > set (IIUC, the VNX basically acts as if that bit was always set)? =

> > > =

> > > If yes, I think the warning in mpath_prout_reg() about this flag
> > > could
> > > be dropped, and mpathpersist could be extended to support the -Y/
> > > --param-alltgpt option, no?
> > =

> > I'm a little fuzzy on the --param-alltgpt option. The initial
> > mpathpersist sumbission didn't include support for it, on the grounds
> > that supporting it would cause mpathpersist to do a lot of extra
> > work.
> > What I did cuts down on the amout of work that mpathpersist has to
> > do.
> > If I could clear that up, I'd happily add the option to mpathpersist.
> > =

> =

> Are you saying you intend to do so? Again, from a user point of view,
> without much knowledge about what's going on behind the scenes, seeing
> an all_tg_pt option in multipath.conf would make me think that I could =

> simply set that option and thus have multipath-tools issue PROUT
> commands with the ALL_TG_PT bit set, which isn't true at this point in
> time.
> =

> Best
> Martin

I get your concern, and I do plan on either allowing the mpathpersist
option or renaming the multipath.conf option so as to not confuse
people. I was hoping to get some reassurance that what I did does
actually make the ALL_TG_TP flag for persistent reservations work.  I
don't have any arrays that seem to actually honor it. They either are
like the VNX, and always treat the reservation as being for all target
ports, or they never do, even when I use the option with sg_persist.  If
I can find an array to test on with multiple target ports that actually
does something in response to the ALL_TG_PT flag, I can check whether my
all_tg_pt code makes this work correctly.

-Ben =


> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
