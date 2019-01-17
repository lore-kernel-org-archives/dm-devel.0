From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 08/12] libmultipath(coverity): fix "enum
 misuse" for find_multipaths
Date: Thu, 17 Jan 2019 15:32:53 -0600
Message-ID: <20190117213253.GC11315@octiron.msp.redhat.com>
References: <20190108225409.15977-1-mwilck@suse.com>
	<20190108225409.15977-9-mwilck@suse.com>
	<20190117195528.GZ11315@octiron.msp.redhat.com>
	<08440b7b40257000f1ea07ee17b19d812fec9a55.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <08440b7b40257000f1ea07ee17b19d812fec9a55.camel@suse.com>
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

On Thu, Jan 17, 2019 at 10:25:03PM +0100, Martin Wilck wrote:
> On Thu, 2019-01-17 at 13:55 -0600, Benjamin Marzinski wrote:
> > On Tue, Jan 08, 2019 at 11:54:05PM +0100, Martin Wilck wrote:
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/dict.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > =

> > > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > > index fd29abc..eaad4f1 100644
> > > --- a/libmultipath/dict.c
> > > +++ b/libmultipath/dict.c
> > > @@ -327,7 +327,7 @@ def_find_multipaths_handler(struct config
> > > *conf, vector strvec)
> > >  	int i;
> > >  =

> > >  	if (set_yes_no_undef(strvec, &conf->find_multipaths) =3D=3D 0 &&
> > > -	    conf->find_multipaths !=3D YNU_UNDEF)
> > > +	    conf->find_multipaths !=3D FIND_MULTIPATHS_UNDEF)
> > >  		return 0;
> > =

> > Is there some reason that I don't understand why YNU_UNDEF is
> > problematic here, but not later in the function at the:
> > =

> >         if (conf->find_multipaths =3D=3D YNU_UNDEF) {
> >                 condlog(0, "illegal value for find_multipaths: %s",
> > buff);
> >                 conf->find_multipaths =3D DEFAULT_FIND_MULTIPATHS;
> >         }
> > =

> > check?
> =

> Good catch. Maybe coverity would have found that in a second pass? Or I
> was just too blind... As I said, this round of work on coverity was
> disrupted by coverity's server downtime, which is still not fixed.
> =

> Anyway, this isn't wrong, only incomplete. I'd rather not resend the
> whole series because of this. When coverity is up again, I'll do
> another round of fixes.
> =


Sure. ACK.

-Ben

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
