From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the select
 or poll function
Date: Thu, 11 May 2017 14:46:21 -0700
Message-ID: <b14635cd-095f-a466-18cd-ced079b949f6@redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com> <1494495801.6093.12.camel@suse.com>
	<20170511132134.GA10709@redhat.com> <1494531043.6093.27.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494531043.6093.27.camel@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On 05/11/2017 12:30 PM, Martin Wilck wrote:
> 
> I see - but I don't see yet how the ioctl approach (or the
> close()/open() based one, for that matter) would avoid this race.
> 
>   1) application processes event N
>   2) event N+1 arrives in the kernel
>   3) user space issues ioctl or close()/open() sequence, N+1 is recorded
>      in priv->global_event_nr
>   4) user space runs poll()
>   5) event N+2 arrives 4 weeks later and poll returns
> 
> ... meaning that event N+1 has been left unprocessed for 4 weeks.
> Or what I am missing?
> 
> AFAICS, the only way for user space to make sure it misses no events
> would be passing the number of the last processed event down the kernel
> in the ioctl call (and the kernel would use that value, rather than its
> internal counter, for initializing priv->global_event_nr).

a) Application notes initial event_nrs for all relevant devices
while (1)
     b) Application calls ARM_POLL
     c) Application gets updated event_nrs from LIST_DEVICES and handles
     d) Application calls poll()

If events arrive between b and c, app sees them.
If events arrive between c and d, dm_global_event_nr is greater than 
priv->global_event_nr and poll() will indicate fd is ready immediately 
w/o sleeping.
If events arrive after d, app sleeps in poll() until fd is ready.

The difference is that you have to ARM_POLL and *then* process events 
before calling poll(). The only small negative consequence is that if an 
event arrives between b and c, it will be handled by c but poll() will 
still see readiness and pop out of the poll() and loop again when it 
strictly didn't have to. But events won't be lost.

Regards -- Andy
