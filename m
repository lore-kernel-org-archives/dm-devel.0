From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 11:40:20 -0400
Message-ID: <20091002154020.GC4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
	<20091002124921.GA4494@redhat.com>
	<4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	<1254497520.10392.11.camel@marge.simson.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1254497520.10392.11.camel@marge.simson.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Galbraith <efault@gmx.de>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, Corrado Zoccolo <czoccolo@gmail.com>, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Oct 02, 2009 at 05:32:00PM +0200, Mike Galbraith wrote:
> On Fri, 2009-10-02 at 17:27 +0200, Corrado Zoccolo wrote:
> > On Fri, Oct 2, 2009 at 2:49 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Fri, Oct 02, 2009 at 12:55:25PM +0200, Corrado Zoccolo wrote:
> > >
> > > Actually I am not touching this code. Looking at the V10, I have not
> > > changed anything here in idling code.
> > 
> > I based my analisys on the original patch:
> > http://lkml.indiana.edu/hypermail/linux/kernel/0907.1/01793.html
> > 
> > Mike, can you confirm which version of the fairness patch did you use
> > in your tests?
> 
> That would be this one-liner.
> 

Ok. Thanks. Sorry, I got confused and thought that you are using "io
controller patches" with fairness=1.

In that case, Corrado's suggestion of refining it further and disabling idling
for seeky process only on non-rotational media (SSD and hardware RAID), makes
sense to me.

Thanks
Vivek
  
> o CFQ provides fair access to disk in terms of disk time used to processes.
>   Fairness is provided for the applications which have their think time with
>   in slice_idle (8ms default) limit.
> 
> o CFQ currently disables idling for seeky processes. So even if a process
>   has think time with-in slice_idle limits, it will still not get fair share
>   of disk. Disabling idling for a seeky process seems good from throughput
>   perspective but not necessarily from fairness perspecitve.
> 
> 0 Do not disable idling based on seek pattern of process if a user has set
>   /sys/block/<disk>/queue/iosched/fairness = 1.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c
> +++ linux-2.6/block/cfq-iosched.c
> @@ -1953,7 +1953,7 @@ cfq_update_idle_window(struct cfq_data *
>  	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
>  
>  	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
> -	    (cfqd->hw_tag && CIC_SEEKY(cic)))
> +	    (!cfqd->cfq_fairness && cfqd->hw_tag && CIC_SEEKY(cic)))
>  		enable_idle = 0;
>  	else if (sample_valid(cic->ttime_samples)) {
>  		if (cic->ttime_mean > cfqd->cfq_slice_idle)
> 
