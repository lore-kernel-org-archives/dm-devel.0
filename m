From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/2] mpathpersist: add all_tg_pt option
Date: Wed, 6 Jun 2018 16:56:29 -0500
Message-ID: <20180606215629.GD3103@octiron.msp.redhat.com>
References: <1527891722-11132-1-git-send-email-bmarzins@redhat.com>
	<97cd3d03418bb923941096309db1d3b53e2f89ca.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <97cd3d03418bb923941096309db1d3b53e2f89ca.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Vijay Chauhan <vijay.chauhan@netapp.com>
List-Id: dm-devel.ids

On Wed, Jun 06, 2018 at 10:25:36PM +0200, Martin Wilck wrote:
> On Fri, 2018-06-01 at 17:22 -0500, Benjamin Marzinski wrote:
> > Some arrays, such as the EMC VNX, don't follow the scsi persistent
> > reservations spec in making key registrations per I_T NEXUS. Instead,
> > the registration is shared by all target ports connected to a given
> > host.  This causes mpathpersist to fail whenever it tries to register
> > a
> > key, since it will receive a registration conflict on some of the
> > paths.
> > =

> > To deal with this, mpathpersist needs to track the hosts that it has
> > done a registration on, and only register once per host. The new
> > "all_tg_pt" multipath.conf option is used to set which arrays need
> > this
> > feature.  I currently don't know if all EMC VNX arrays handle
> > persistent
> > reservations like this, or if it is configurable. A future patch will
> > update the VNX built-in config, if this is indeed their default (or
> > only) setting.
> > =

> > Multipathd doesn't need to worry about this. It is often the case
> > that
> > when a path device comes back, it will still have the keys registered
> > to
> > it. Because of this, multipathd uses register-and-ignore, which means
> > that it won't cause an error if the registration has already happened
> > down a different target port.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist.c | 28 ++++++++++++++++++++++------
> >  libmultipath/config.c           |  2 ++
> >  libmultipath/config.h           |  2 ++
> >  libmultipath/defaults.h         |  1 +
> >  libmultipath/dict.c             | 10 ++++++++++
> >  libmultipath/propsel.c          | 15 +++++++++++++++
> >  libmultipath/propsel.h          |  1 +
> >  libmultipath/structs.h          |  7 +++++++
> >  multipath/multipath.conf.5      | 11 +++++++++++
> >  9 files changed, 71 insertions(+), 6 deletions(-)
> =

> The patch looks good to me, but doesn't this mean that mpathpersist
> would now also support persistent reservations with the ALL_TG_PT bit
> set (IIUC, the VNX basically acts as if that bit was always set)? =

> =

> If yes, I think the warning in mpath_prout_reg() about this flag could
> be dropped, and mpathpersist could be extended to support the -Y/
> --param-alltgpt option, no?

I'm a little fuzzy on the --param-alltgpt option. The initial
mpathpersist sumbission didn't include support for it, on the grounds
that supporting it would cause mpathpersist to do a lot of extra work.
What I did cuts down on the amout of work that mpathpersist has to do.
If I could clear that up, I'd happily add the option to mpathpersist.

-Ben

> =

> Otherwise, I'd suggest to give this option a different name, because
> it'd just too easily be confused with ALL_TG_PT from the spec.
> =

> Regards,
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
