From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 07/23] multipathd: move conf destruction into
 separate function
Date: Tue, 29 Sep 2020 11:12:44 +0200
Message-ID: <28ff7b2c246907821bf20ce764552f7b140d6b8b.camel@suse.com>
References: <20200924134054.14632-1-mwilck@suse.com>
	<20200924134054.14632-8-mwilck@suse.com>
	<20200928180312.GM3384@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200928180312.GM3384@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2020-09-28 at 13:03 -0500, Benjamin Marzinski wrote:
>  
> > -	if (logsink == 1)
> > +	if (logsink == 1) {
> > +		logsink = 0;
> >  		log_thread_stop();
> 
> It seems like log_thread_stop() could just do something like
> 
> pthread_t log_thr_save = log_thr;
> log_thr = (pthread_t)0;
> 
> at the start, and then you would continue to get syslog logging, even
> when the log thread stopped. It's racy, but all the other threads
> (except the log_thread, obviously) should be stopped. Or am I not
> understanding the purpose of doing this?

I guess we could do this, yes (although I think (pthread_t)0 should be
avoided, but that's a different issue. Let me have another look.

Regards,
Martin
