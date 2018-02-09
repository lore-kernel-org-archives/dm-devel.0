From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Fri, 9 Feb 2018 17:42:14 +0000
Message-ID: <1518198133.2871.26.camel@wdc.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518192932.2871.11.camel@wdc.com>
	<20180209172607.GV14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180209172607.GV14513@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <408AF581158E3A468F12F58D88E9383D@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

On Fri, 2018-02-09 at 11:26 -0600, Benjamin Marzinski wrote:
> On Fri, Feb 09, 2018 at 04:15:34PM +0000, Bart Van Assche wrote:
> > On Thu, 2018-02-08 at 17:56 -0600, Benjamin Marzinski wrote:
> > >  static void cleanup_func(void *data)
> > >  {
> > > -	int holders;
> > > +	int running, holders;
> > >  	struct tur_checker_context *ct = data;
> > > -	pthread_spin_lock(&ct->hldr_lock);
> > > -	ct->holders--;
> > > -	holders = ct->holders;
> > > -	ct->thread = 0;
> > > -	pthread_spin_unlock(&ct->hldr_lock);
> > > +
> > > +	running = uatomic_xchg(&ct->running, 0);
> > > +	holders = uatomic_sub_return(&ct->holders, 1);
> > >  	if (!holders)
> > >  		cleanup_context(ct);
> > > +	if (!running)
> > > +		pause();
> > >  }
> > 
> > Hello Ben,
> > 
> > Why has the pause() call been added? I think it is safe to call pthread_cancel()
> > for a non-detached thread that has finished so I don't think that pause() call
> > is necessary.
> 
> Martin objected to having the threads getting detached as part of
> cancelling them (I think. I'm a little fuzzy on what he didn't like).
> But he definitely said he preferred the thread to start detached, so in
> this version, it does.  That's why we need the pause().  If he's fine with
> the threads getting detached later, I will happily replace the pause()
> with
> 
> if (running)
> 	pthread_detach(pthread_self());
> 
> and add pthread_detach(ct->thread) after the calls to
> pthread_cancel(ct->thread). Otherwise we need the pause() to solve your
> original bug.

Ah, thanks, I had overlooked that the tur checker detaches the checker thread. Have
you considered to add a comment above the pause() call that explains the purpose of
that call?

Thanks,

Bart.
