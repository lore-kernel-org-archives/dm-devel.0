From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair
	queuing code in elevaotor layer
Date: Tue, 30 Jun 2009 21:28:27 -0400
Message-ID: <20090701012827.GA13958@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-3-git-send-email-vgoyal@redhat.com>
	<4A49B364.5000508@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A49B364.5000508@cn.fujitsu.com>
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
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Tue, Jun 30, 2009 at 02:40:36PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +/*
> > + * Do the accounting. Determine how much service (in terms of time slices)
> > + * current queue used and adjust the start, finish time of queue and vtime
> > + * of the tree accordingly.
> > + *
> > + * Determining the service used in terms of time is tricky in certain
> > + * situations. Especially when underlying device supports command queuing
> > + * and requests from multiple queues can be there at same time, then it
> > + * is not clear which queue consumed how much of disk time.
> > + *
> > + * To mitigate this problem, cfq starts the time slice of the queue only
> > + * after first request from the queue has completed. This does not work
> > + * very well if we expire the queue before we wait for first and more
> > + * request to finish from the queue. For seeky queues, we will expire the
> > + * queue after dispatching few requests without waiting and start dispatching
> > + * from next queue.
> > + *
> > + * Not sure how to determine the time consumed by queue in such scenarios.
> > + * Currently as a crude approximation, we are charging 25% of time slice
> > + * for such cases. A better mechanism is needed for accurate accounting.
> > + */
> 
>   Hi Vivek,
> 
>   The comment is out of date, would you update it accordingly?
> 

Thanks Gui. Yes, I will update it in next posting.

Vivek
