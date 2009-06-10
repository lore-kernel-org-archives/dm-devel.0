From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 08/18] io-controller: idle for sometime on
	sync queue before expiring it
Date: Wed, 10 Jun 2009 09:26:38 -0400
Message-ID: <20090610132638.GB19680@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	<1241553525-28095-9-git-send-email-vgoyal@redhat.com>
	<4A2E15B6.8030001@cn.fujitsu.com>
	<20090609175131.GB13476@redhat.com>
	<4A2F0CBE.8030208@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A2F0CBE.8030208@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Wed, Jun 10, 2009 at 09:30:38AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Tue, Jun 09, 2009 at 03:56:38PM +0800, Gui Jianfeng wrote:
> >> Vivek Goyal wrote:
> >> ...
> >>> +ssize_t elv_fairness_store(struct request_queue *q, const char *name,
> >>> +			  size_t count)
> >>> +{
> >>> +	struct elv_fq_data *efqd;
> >>> +	unsigned int data;
> >>> +	unsigned long flags;
> >>> +
> >>> +	char *p = (char *)name;
> >>> +
> >>> +	data = simple_strtoul(p, &p, 10);
> >>> +
> >>> +	if (data < 0)
> >>> +		data = 0;
> >>> +	else if (data > INT_MAX)
> >>> +		data = INT_MAX;
> >>   Hi Vivek,
> >>
> >>   data might overflow on 64 bit systems. In addition, since "fairness" is nothing 
> >>   more than a switch, just let it be.
> >>
> >> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> >> ---
> > 
> > Hi Gui,
> > 
> > How about following patch? Currently this should apply at the end of the
> > patch series. If it looks good, I will merge the changes in higher level
> > patches.
> 
>   This patch seems good to me. Some trivial issues comment below.
> 
> > 
> > Thanks
> > Vivek
> > 
> > o Previously common layer elevator parameters were appearing as request
> >   queue parameters in sysfs. But actually these are io scheduler parameters
> >   in hiearchical mode. Fix it.
> > 
> > o Use macros to define multiple sysfs C functions doing the same thing. Code
> >   borrowed from CFQ. Helps reduce the number of lines of by 140.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ...	\
> > +}
> > +SHOW_FUNCTION(elv_fairness_show, efqd->fairness, 0);
> > +EXPORT_SYMBOL(elv_fairness_show);
> > +SHOW_FUNCTION(elv_slice_idle_show, efqd->elv_slice_idle, 1);
> > +EXPORT_SYMBOL(elv_slice_idle_show);
> > +SHOW_FUNCTION(elv_async_slice_idle_show, efqd->elv_async_slice_idle, 1);
> > +EXPORT_SYMBOL(elv_async_slice_idle_show);
> > +SHOW_FUNCTION(elv_slice_sync_show, efqd->elv_slice[1], 1);
> > +EXPORT_SYMBOL(elv_slice_sync_show);
> > +SHOW_FUNCTION(elv_slice_async_show, efqd->elv_slice[0], 1);
> > +EXPORT_SYMBOL(elv_slice_async_show);
> > +#undef SHOW_FUNCTION
> > +
> > +#define STORE_FUNCTION(__FUNC, __PTR, MIN, MAX, __CONV)			\
> > +ssize_t __FUNC(struct elevator_queue *e, const char *page, size_t count)	\
> > +{									\
> > +	struct elv_fq_data *efqd = &e->efqd;				\
> > +	unsigned int __data;						\
> > +	int ret = elv_var_store(&__data, (page), count);		\
> 
>   Since simple_strtoul returns unsigned long, it's better to make __data 
>   be that type.
> 

I just took it from CFQ. BTW, what's the harm here in truncating unsigned
long to int? Anyway for our variables we are not expecting any value 
bigger than unsigned int and if it is, we expect to truncate it?

> > +	if (__data < (MIN))						\
> > +		__data = (MIN);						\
> > +	else if (__data > (MAX))					\
> > +		__data = (MAX);						\
> > +	if (__CONV)							\
> > +		*(__PTR) = msecs_to_jiffies(__data);			\
> > +	else								\
> > +		*(__PTR) = __data;					\
> > +	return ret;							\
> > +}
> > +STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 1, 0);
> > +EXPORT_SYMBOL(elv_fairness_store);
> > +STORE_FUNCTION(elv_slice_idle_store, &efqd->elv_slice_idle, 0, UINT_MAX, 1);
> 
>   Do we need to set an actual max limitation rather than UINT_MAX for these entries?

Again these are the same values CFQ was using.  Do you have a better upper
limit in mind? Until and unless there is strong objection to UINT_MAX, we
can stick to what CFQ has been doing so far.

Thanks
Vivek
