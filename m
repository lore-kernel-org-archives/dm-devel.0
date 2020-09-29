From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 18/23] libmultipath: fix log_thread startup
	and teardown
Date: Tue, 29 Sep 2020 11:18:13 +0200
Message-ID: <f7e7f62ed6b79c08b2f494bcd45ba09e265de55b.camel@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
	<20200924134054.14632-19-mwilck@suse.com>
	<20200928201523.GO3384@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200928201523.GO3384@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2020-09-28 at 15:15 -0500, Benjamin Marzinski wrote:
> On Thu, Sep 24, 2020 at 03:40:49PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > This fixes several issues with the log_thread. First, the running
> > flag logq_running should be set by the thread itself, not by
> > log_thread_start()/_stop(). Second, the thread was both cancelled
> > and
> > terminated via a flag (again, logq_running). It's sufficient,
> > and better, to just cancel it and use logq_running as indication
> > for
> > successful termination. Third, the locking wasn't cancel-safe in
> > some
> > places. Forth, log_thread_start() and log_thread_stop() didn't wait
> > for
> > startup/teardown properly. Fifth, using (pthread_t)0 is wrong
> > (pthread_t is
> > opaque; there's no guarantee that 0 is not a valid pthread_t
> > value). Finally,
> > pthread_cancel() was called under logq_lock, which doesn't make
> > sense to
> > me at all.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  
> >  	pthread_mutex_lock(&logev_lock);
> > -	logq_running = 0;
> > -	pthread_cond_signal(&logev_cond);
> > -	pthread_mutex_unlock(&logev_lock);
> > +	pthread_cleanup_push(cleanup_mutex, &logev_lock);
> > +	running = logq_running;
> > +	if (running) {
> > +		pthread_cancel(log_thr);
> > +		pthread_cond_signal(&logev_cond);
> > +	}
> > +	while (logq_running)
> > +		pthread_cond_wait(&logev_cond, &logev_lock);
> 
> If we're already going to join the thread, why do we have to wait for
> the cleanup handler first? Won't the join do the waiting we need?

Yes, I guess it would. I implemented it in a way analogous the startup
sequence, but it's really not necessary for shutdown. Thanks for
pointing it out.

Martin
