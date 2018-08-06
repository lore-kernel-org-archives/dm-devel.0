From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 18/32] libmultipath: fix tur memory misuse
Date: Mon, 6 Aug 2018 18:12:03 -0500
Message-ID: <20180806231203.GX31378@octiron.msp.redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
	<1533157038-3924-19-git-send-email-bmarzins@redhat.com>
	<c2e5237d7ee818ce90f4ed749493c970f17178c8.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <c2e5237d7ee818ce90f4ed749493c970f17178c8.camel@wdc.com>
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

On Sun, Aug 05, 2018 at 03:43:18PM +0000, Bart Van Assche wrote:
> On Wed, 2018-08-01 at 15:57 -0500, Benjamin Marzinski wrote:
> > when tur_thread() was calling tur_check(), it was passing ct->message as
> > the copy argument, but copy_msg_to_tcc() was assuming that it was
> > getting a tur_checker_context pointer. This means it was treating
> > ct->message as ct. This is why the tur checker never printed checker
> > messages. Intead of simply changing the copy argument passed in, I just
> > removed all the copying code, since it is completely unnecessary. The
> > callers of tur_check() can just pass in a buffer that it is safe to
> > write to, and copy it later, if necessary.
> > [ ... ]
> > -#define TUR_MSG(fmt, args...)					\
> > -	do {							\
> > -		char msg[CHECKER_MSG_LEN];			\
> > -								\
> > -		snprintf(msg, sizeof(msg), fmt, ##args);	\
> > -		copy_message(cb_arg, msg);			\
> > -	} while (0)
> > -
> > [ ... ]
> > -static void copy_msg_to_tcc(void *ct_p, const char *msg)
> > -{
> > -	struct tur_checker_context *ct = ct_p;
> > -
> > -	pthread_mutex_lock(&ct->lock);
> > -	strlcpy(ct->message, msg, sizeof(ct->message));
> > -	pthread_mutex_unlock(&ct->lock);
> > -}
> 
> The above code was introduced because multiple threads can access ct->message
> concurrently. Does your patch reintroduce the race conditions on the ct->message
> buffer that were fixed by commit f63f4d115813 ("libmultipath/checkers/tur: Protect
> tur_checker_context.message changes")?

It shouldn't. Since the tur checker thread only has access to the
tur_checker_context, the only race we have to worry about here is on
access to ct->message. The main checker code is free to pass c->message
to tur_check(), since the tur checker thread doesn't have access to
that.  With this patch, tur_thread() passes tur_check() a local variable
and copies that variable to ct->message while holding the mutex.  the
main checker code copies ct->message to c->message while holding the
same mutex. The main checker code even clears ct->message before
starting the thread while holding the mutex.

If you see something I've missed, please let me know.

-Ben

> 
> Bart.
> 
