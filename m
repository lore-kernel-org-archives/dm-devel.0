From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 7/7] multipath: print sysfs state in fast
	list mode
Date: Thu, 8 Feb 2018 13:06:33 -0600
Message-ID: <20180208190633.GT14513@octiron.msp.redhat.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
	<1518043787-7066-8-git-send-email-bmarzins@redhat.com>
	<1518082326.15245.54.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518082326.15245.54.camel@suse.com>
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

On Thu, Feb 08, 2018 at 10:32:06AM +0100, Martin Wilck wrote:
> Hi Ben,
> =

> On Wed, 2018-02-07 at 16:49 -0600, Benjamin Marzinski wrote:
> > commit b123e711ea2a4b471a98ff5e26815df3773636b5 "libmultipath:
> > cleanup
> > orphan device states" stopped multipathd from showing old state for
> > orphan paths by checking if pp->mpp was set, and only printing the
> > state
> > if it was.   Unfortunately, when "multipath -l" is run, pp->mpp isn't
> > set. While the checker state isn't checked and shouldn't be printed
> > with
> > "-l", the sysfs state can be, and was before b123e711. This patch
> > sets
> > pp->mpp in fast list mode, so that the sysfs state gets printed.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipath/main.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > =

> > diff --git a/multipath/main.c b/multipath/main.c
> > index bffe065..1799fd5 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -149,7 +149,7 @@ usage (char * progname)
> >  }
> >  =

> >  static int
> > -update_paths (struct multipath * mpp)
> > +update_paths (struct multipath * mpp, int quick)
> >  {
> >  	int i, j;
> >  	struct pathgroup * pgp;
> > @@ -164,6 +164,10 @@ update_paths (struct multipath * mpp)
> >  			continue;
> >  =

> >  		vector_foreach_slot (pgp->paths, pp, j) {
> > +			if (quick) {
> > +				pp->mpp =3D mpp;
> > +				continue;
> > +			}
> >  			if (!strlen(pp->dev)) {
> >  				if (devt2devname(pp->dev, =

> =

> Shouldn't you check whether the paths are still present in sysfs, like
> the code for the general case (quick =3D=3D false) does?

Sure. It will make multipath paths that don't exist in sysfs show up
with a checker state of "faulty", instead of "undef" like was previously
the case for all paths in the quick list, but that seems like an
improvement.

> =

> Regards
> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
