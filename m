From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 11/16] Fix max path checker timing
Date: Fri, 3 May 2013 10:44:57 -0500
Message-ID: <20130503154457.GN6253@ether.msp.redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
	<1367531197-8987-12-git-send-email-bmarzins@redhat.com>
	<5183603F.5000003@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5183603F.5000003@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Fri, May 03, 2013 at 08:59:11AM +0200, Hannes Reinecke wrote:
> On 05/02/2013 11:46 PM, Benjamin Marzinski wrote:
> > Due to some code being placed inside the wrong block, the number of
> > seconds to wait between path checks (pp->tick), was only getting set to
> > the path's individual check interval if that wasn't equal to the max
> > check interval.  Otherwise it was using the default for a failed path.
> > This patch makes sure that pp->ticks always always gets set correctly
> > for active paths.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipathd/main.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > =

> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index 440d254..df1c5b9 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -1219,11 +1219,10 @@ check_path (struct vectors * vecs, struct path =
* pp)
> >  					pp->checkint =3D 2 * pp->checkint;
> >  				else
> >  					pp->checkint =3D conf->max_checkint;
> > -
> > -				pp->tick =3D pp->checkint;
> > -				condlog(4, "%s: delay next check %is",
> > -					pp->dev_t, pp->tick);
> >  			}
> > +			pp->tick =3D pp->checkint;
> > +			condlog(4, "%s: delay next check %is",
> > +				pp->dev_t, pp->tick);
> >  		}
> >  	}
> >  	else if (newstate =3D=3D PATH_DOWN) {
> > =

> But then the message is wrong, isn't it?
> We should be printing the 'delay next check' message only
> if the check was actually delayed, ie inside the block.
> =

> So I think something like this should be more appropriate
> (minus line-breaks, of course):
> =

> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6471d24..9901b02 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1235,10 +1235,10 @@ check_path (struct vectors * vecs, struct
> path * pp)
>                                 else
>                                         pp->checkint =3D
> conf->max_checkint;
> =

> -                               pp->tick =3D pp->checkint;
>                                 condlog(4, "%s: delay next check %is",
>                                         pp->dev_t, pp->tick);

I think you mean pp->checkint here.  Otherwise the code will print
pp->tick before we set it. But otherwise, I'm fine with this.  I'll
respin the patch.

-Ben

>                         }
> +                       pp->tick =3D pp->checkint;
>                 }
>         }
>         else if (newstate =3D=3D PATH_DOWN) {
> =

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
