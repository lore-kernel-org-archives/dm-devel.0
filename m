From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Fri, 9 Feb 2018 11:26:07 -0600
Message-ID: <20180209172607.GV14513@octiron.msp.redhat.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518192932.2871.11.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518192932.2871.11.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

On Fri, Feb 09, 2018 at 04:15:34PM +0000, Bart Van Assche wrote:
> On Thu, 2018-02-08 at 17:56 -0600, Benjamin Marzinski wrote:
> >  static void cleanup_func(void *data)
> >  {
> > -	int holders;
> > +	int running, holders;
> >  	struct tur_checker_context *ct = data;
> > -	pthread_spin_lock(&ct->hldr_lock);
> > -	ct->holders--;
> > -	holders = ct->holders;
> > -	ct->thread = 0;
> > -	pthread_spin_unlock(&ct->hldr_lock);
> > +
> > +	running = uatomic_xchg(&ct->running, 0);
> > +	holders = uatomic_sub_return(&ct->holders, 1);
> >  	if (!holders)
> >  		cleanup_context(ct);
> > +	if (!running)
> > +		pause();
> >  }
> 
> Hello Ben,
> 
> Why has the pause() call been added? I think it is safe to call pthread_cancel()
> for a non-detached thread that has finished so I don't think that pause() call
> is necessary.

Martin objected to having the threads getting detached as part of
cancelling them (I think. I'm a little fuzzy on what he didn't like).
But he definitely said he preferred the thread to start detached, so in
this version, it does.  That's why we need the pause().  If he's fine with
the threads getting detached later, I will happily replace the pause()
with

if (running)
	pthread_detach(pthread_self());

and add pthread_detach(ct->thread) after the calls to
pthread_cancel(ct->thread). Otherwise we need the pause() to solve your
original bug.

As an aside, Martin, if your problem is the thread detaching itself, we
can skip that if we are fine with a zombie thread hanging around until
the next time we call libcheck_check() or libcheck_free(). Then the
checker can always be in charge of detaching the thread.
 
> >  static int tur_running(struct tur_checker_context *ct)
> >  {
> > -	pthread_t thread;
> > -
> > -	pthread_spin_lock(&ct->hldr_lock);
> > -	thread = ct->thread;
> > -	pthread_spin_unlock(&ct->hldr_lock);
> > -
> > -	return thread != 0;
> > +	return (uatomic_read(&ct->running) != 0);
> >  }
> 
> Is such a one line function really useful?

Nope. I just left it there to keep the number of changes that the patch
makes lower, to make it more straightforward to review. I'm fine will
inlining it.

> I think the code will be easier to read if this function is inlined
> into its callers.

> > @@ -418,8 +396,12 @@ int libcheck_check(struct checker * c)
> >  		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
> >  			condlog(3, "%s: tur checker still running",
> >  				tur_devt(devt, sizeof(devt), ct));
> > -			ct->running = 1;
> >  			tur_status = PATH_PENDING;
> > +		} else {
> > +			int running = uatomic_xchg(&ct->running, 0);
> > +			if (running)
> > +				pthread_cancel(ct->thread);
> > +			ct->thread = 0;
> >  		}
> >  	}
> 
> Why has this pthread_cancel() call been added? I think that else clause can only be
> reached if ct->running == 0 so I don't think that the pthread_cancel() call will ever
> be reached.

It can be reached if ct->running is 1, as long as tur_status has been
updated.  In practice this means that the thread should have done
everything it needs to do, and all that's left is for it to shutdown.
However, if the thread doesn't shut itself down before the next time you
call libcheck_check(), the checker will give up and return PATH_TIMEOUT.

It seems pretty unlikely that this will happen, since there should be a
significant delay before calling libcheck_check() again. This
theoretical race has been in the code for a while, and AFAIK, it's never
occured. But there definitely is the possiblity that the thread will
still be running at the end of libcheck_check(), and it doesn't hurt
things to forceably shut the thread down, if it is. 

-Ben

> Thanks,
> 
> Bart.
> 
> 
> 
