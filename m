From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 07/10] libmultipath: handle TUR threads
 that can't be cancelled
Date: Tue, 23 Oct 2018 16:21:27 -0500
Message-ID: <20181023212127.GF7100@octiron.msp.redhat.com>
References: <20181023134348.17915-1-mwilck@suse.com>
	<20181023134348.17915-2-mwilck@suse.com>
	<20181023192849.GA7100@octiron.msp.redhat.com>
	<8a3659b919b21305cf7ef6bae321cc3b2b93ffd6.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <8a3659b919b21305cf7ef6bae321cc3b2b93ffd6.camel@suse.com>
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

On Tue, Oct 23, 2018 at 10:49:49PM +0200, Martin Wilck wrote:
> On Tue, 2018-10-23 at 14:28 -0500,  Benjamin Marzinski  wrote:
> =

> > On Tue, Oct 23, 2018 at 03:43:45PM +0200, Martin Wilck wrote:
> > > When the tur checker code determines that a hanging TUR thread
> > > couldn't be cancelled, rather than simply returning, reallocate
> > > the checker context and start a new thread. This will leak some
> > > memory if the hanging thread never wakes up again, but well, in
> > > that highly unlikely case we're leaking threads anyway.
> > =

> > The thing about PATH_UNCHECKED is that we do mark the path as failed.
> > We just don't tell device-mapper. If we get PATH_UNCHECKED in
> > pathinfo(), we set the state to PATH_DOWN. If we get a PATH_UNCHECKED
> > in
> > check_path(), we immediately call pathinfo(), =

> =

> But we call pathinfo(pp, conf, 0) there, i.e. all DI flags unset. This
> comes down to a (partial) blacklist check (which is ignored) and a call
> to path_offline(). pp->state isn't touched in this code path. It's more
> or less a NOOP. (BTW, the purpose of this pathinfo() call remains
> obscure to me. It goes back to the ancient commit 95987395).

Oops. I overlooked the flags. Well, that takes care of any issue with
check_path(). As for the pathinfo call itself, I assume that, at some
tine, it was possible to get to check_path() without a fully initialized
path device.  But that doesn't explain why it doesn't set any flags.
I'm not sure if this code currently serves any purpose.
 =

> > making it likely that we
> > will get PATH_UNCHECKED there as well. The consequence of this is
> > that
> > if the path later changes to PATH_DOWN, which seems likely, we still
> > won't tell device-mapper, since as far as multipathd is concerned,
> > the
> > path hasn't changed state. =

> =

> I don't follow you. check_path() quits early when PATH_UNCHECKED is
> encountered, and doesn't alter pp->state. It will check again in the
> next round, and if the path switches to DOWN then (or any other state,
> for that matter) it will treat it right, AFAICS.

If PATH_UNCHECKED triggers the "blank" code in pathinfo, it will set the
path's state to PATH_DOWN.

> >  Looking at most of the code, the way we
> > treat PATH_UNCHECKED really only makes sense when we use it to mean
> > we
> > haven't ever gotten a result from get_state() before.
> > =

> > If you want a return code that does just does nothing with the path,
> > except wait, that's PATH_PENDING. It leaves the paths state exactly
> > the
> > same as before. The only issue there is that we schedule another path
> > checker for a second later, which might not be the right answer to an
> > out-of-memory issue.
> > =

> > If you've reviewed the code paths that we follow on PATH_UNCHECKED,
> > and
> > still feel that it is the right answer, I won't block it, because
> > this
> > is a pretty remote corner case.
> =

> PATH_UNCHECKED is tested in the following places (ignoring calls from
> multipath and mpathpersist):
> =

>  1) pathinfo(): in the "blank" case (we discussed that before, I think
> it's wrong and I removed that test in 17/21 of my previous 21-part
> series).

removing the blank case here fixes the issue with getting a
PATH_UNCHECKED in pathinfo(), which is the root of my objection to it,
so

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

>  2) sync_map_state(): no attempt to sync the path with dm is made,
> which is what we want here, IMHO.
>  3) check_path(): see above.
> =

> So yes, IMO the code review shows that PATH_UNCHECKED is better then
> PATH_TIMEOUT for the corner case at hand.
> =

> Regards
> Martin
> =

> =

> >  But I don't like how PATH_UNCHECKED
> > works like PATH_DOWN, but without actually keeping the state synced
> > with
> > the kernel, since the rest of the multipathd code is expecting the
> > state
> > to be synced.
> >  =

> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/checkers/tur.c | 24 +++++++++++++++++++++---
> > >  1 file changed, 21 insertions(+), 3 deletions(-)
> > > =

> > > diff --git a/libmultipath/checkers/tur.c
> > > b/libmultipath/checkers/tur.c
> > > index 41210892..a6c88eb2 100644
> > > --- a/libmultipath/checkers/tur.c
> > > +++ b/libmultipath/checkers/tur.c
> > > @@ -349,11 +349,29 @@ int libcheck_check(struct checker * c)
> > >  		}
> > >  	} else {
> > >  		if (uatomic_read(&ct->holders) > 1) {
> > > -			/* The thread has been cancelled but hasn't
> > > -			 * quit. exit with timeout. */
> > > +			/*
> > > +			 * The thread has been cancelled but hasn't
> > > quit.
> > > +			 * We have to prevent it from interfering with
> > > the new
> > > +			 * thread. We create a new context and leave
> > > the old
> > > +			 * one with the stale thread, hoping it will
> > > clean up
> > > +			 * eventually.
> > > +			 */
> > >  			condlog(3, "%d:%d : tur thread not responding",
> > >  				major(ct->devt), minor(ct->devt));
> > > -			return PATH_TIMEOUT;
> > > +
> > > +			/*
> > > +			 * libcheck_init will replace c->context.
> > > +			 * It fails only in OOM situations. In this
> > > case, return
> > > +			 * PATH_UNCHECKED to avoid prematurely failing
> > > the path.
> > > +			 */
> > > +			if (libcheck_init(c) !=3D 0)
> > > +				return PATH_UNCHECKED;
> > > +
> > > +			if (!uatomic_sub_return(&ct->holders, 1))
> > > +				/* It did terminate, eventually */
> > > +				cleanup_context(ct);
> > > +
> > > +			ct =3D c->context;
> > >  		}
> > >  		/* Start new TUR checker */
> > >  		pthread_mutex_lock(&ct->lock);
> > > -- =

> > > 2.19.1
> > =

> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
