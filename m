From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 01/19] libmultipath: fix tur checker
	timeout
Date: Thu, 4 Oct 2018 11:31:18 -0500
Message-ID: <20181004163118.GA3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-2-git-send-email-bmarzins@redhat.com>
	<deb772629c403acaf8c39a0e74f947a7f8b9d2bf.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <deb772629c403acaf8c39a0e74f947a7f8b9d2bf.camel@suse.com>
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

On Mon, Oct 01, 2018 at 09:51:22PM +0200, Martin Wilck wrote:
> On Fri, 2018-09-21 at 18:05 -0500, Benjamin Marzinski wrote:
> > The code previously was timing out mode if ct->thread was 0 but
> > ct->running wasn't. This combination never happens.  The idea was to
> > timeout if for some reason the path checker tried to kill the thread,
> > but it didn't die.  The correct thing to check for this is ct-
> > >holders.
> > ct->holders will always be at least one when libcheck_check() is
> > called,
> > since libcheck_free() won't get called until the device is no longer
> > being checked. So, if ct->holders is 2, that means that the tur
> > thread
> > is has not shut down yet.
> > =

> > Also, instead of returning PATH_TIMEOUT whenever the thread hasn't
> > died,
> > it should only time out if the thread didn't successfully get a
> > value,
> > which means the previous state was already PATH_TIMEOUT.
> =

> What about PATH_UNCHECKED?
> =


I don't see how that could happen. In this state we've definitely set
ct->state to PATH_PENDING when we started the thread. The thread will
only change  ct->state to the return of tur_check(), which doesn't
ever return PATH_UNCHECKED. Am I missing something here?

> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers/tur.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> > =

> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index bf8486d..275541f 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -355,12 +355,15 @@ int libcheck_check(struct checker * c)
> >  		}
> >  		pthread_mutex_unlock(&ct->lock);
> >  	} else {
> > -		if (uatomic_read(&ct->running) !=3D 0) {
> > -			/* pthread cancel failed. continue in sync mode
> > */
> > -			pthread_mutex_unlock(&ct->lock);
> > -			condlog(3, "%s: tur thread not responding",
> > -				tur_devt(devt, sizeof(devt), ct));
> > -			return PATH_TIMEOUT;
> > +		if (uatomic_read(&ct->holders) > 1) {
> > +			/* pthread cancel failed. If it didn't get the
> > path
> > +			   state already, timeout */
> > +			if (ct->state =3D=3D PATH_PENDING) {
> > +				pthread_mutex_unlock(&ct->lock);
> > +				condlog(3, "%s: tur thread not
> > responding",
> > +					tur_devt(devt, sizeof(devt),
> > ct));
> > +				return PATH_TIMEOUT;
> > +			}
> >  		}
> =

> I'm not quite getting it yet. We're entering this code path if =

> ct->thread is 0. As you point out, if there are >1 holders, a
> previously cancelled TUR thread must be still "alive". But now we want
> to check *again*. The previous code refused to do that - a single
> hanging TUR thread could block further checks from happening, forever.
> The PATH_TIMEOUT return code was actually questionable - in this
> libcheck_check() invocation, we didn't even try to check, so nothing
> could actually time out (but that's obviously independent of your
> patch).
> =

> With your patch, if ct->state !=3D PATH_PENDING, we'd try to start
> another TUR thread although there's still a hanging one. That's not
> necessarily wrong, but I fail to see why it depends on ct->state.
> Anyway, if we do this, we take the risk of starting more and more TUR
> threads which might all end up hanging; I wonder if we should stop
> creating more threads if ct->holders grows further (e.g. > 5).

It's been a while, and I'm not exactly sure what I was thinking here.
But IIRC the idea was that if the state isn't set yet, then the old
thread could mess with the results of a future thread. Also, it was to
avoid a corner case where the tur checker was called, started the
thread, got the result before the checker exitted, cancelled the thread
and returned the result and then was called very shortly afterwards,
before the thread could clean itself up.  In that case, the right thing
to do (I thought) would be to start a new thread, because the other one
would be ending soon.  In truth, starting a new thread at all is
probably a bad idea, since the old thread will still mess with the
checker context on exit. =


A better idea might be to simply fail back to a syncronous call to
tur_check() when you notice a cancelled thread that hasn't exitted.
That can cause all the other checkers to get delayed, but at least in
that case you are still checking paths. The other option is to do as
before and just not check this path, which won't effect the other
checkers. It seems very unlikely that the thread could remain
uncancelled forever, especially if the path was usable.

thoughts?

-Ben

> Regards,
> Martin
> =

> =

> >  		/* Start new TUR checker */
> >  		ct->state =3D PATH_UNCHECKED;
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
