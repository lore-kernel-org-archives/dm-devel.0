From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/2] multipath: don't check timestamps
	without a path
Date: Wed, 6 Jun 2018 16:57:42 -0500
Message-ID: <20180606215742.GE3103@octiron.msp.redhat.com>
References: <1528238421-26087-1-git-send-email-bmarzins@redhat.com>
	<1528238421-26087-3-git-send-email-bmarzins@redhat.com>
	<f881e41b92559528558af7f848a060a0ec5d8fa1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <f881e41b92559528558af7f848a060a0ec5d8fa1.camel@suse.com>
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

On Wed, Jun 06, 2018 at 11:26:55AM +0200, Martin Wilck wrote:
> On Tue, 2018-06-05 at 17:40 -0500, Benjamin Marzinski wrote:
> > If a path was blacklisted, pathvec could exist but have no path in
> > it.
> > print_cmd_valid wasn't checking this before calling
> > find_multipaths_check_timeout(). This was causing it to dereference a
> > NULL pointer in these cases.
> > =

> > Cc: Martin Wilck <mwilck@suse.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  multipath/main.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > =

> > diff --git a/multipath/main.c b/multipath/main.c
> > index c69e996..3f0a6aa 100644
> > --- a/multipath/main.c
> > +++ b/multipath/main.c
> > @@ -482,10 +482,8 @@ static int print_cmd_valid(int k, const vector
> > pathvec,
> >  			pp, pp->find_multipaths_timeout, &until);
> >  		if (wait !=3D FIND_MULTIPATHS_WAITING)
> >  			k =3D 1;
> > -	} else if (pathvec !=3D NULL) {
> > -		pp =3D VECTOR_SLOT(pathvec, 0);
> > +	} else if (pathvec !=3D NULL && (pp =3D VECTOR_SLOT(pathvec,
> > 0)))
> >  		wait =3D find_multipaths_check_timeout(pp, 0, &until);
> > -	}
> >  	if (wait =3D=3D FIND_MULTIPATHS_WAITING)
> >  		printf("FIND_MULTIPATHS_WAIT_UNTIL=3D\"%ld.%06ld\"\n",
> >  			       until.tv_sec, until.tv_nsec/1000);
> =

> Thanks for pointing this out. This must be the case where get_refwwid()
> fails on the path early in configure(), correct?

Yep.

-Ben

> =

> Anyway:
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
