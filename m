From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt: remove per-cpu structure
Date: Thu, 20 Feb 2014 19:10:11 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1402201907120.29698@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1402201758190.28312@file01.intranet.prod.int.rdu2.redhat.com>
	<20140220235935.GA32743@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140220235935.GA32743@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com, Lisa Du <chunlingdu1@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 20 Feb 2014, Mike Snitzer wrote:

> On Thu, Feb 20 2014 at  6:01pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Dm-crypt used per-cpu structures to hold pointers to ablkcipher_request.
> > The code assumed that the work item keeps executing on a single CPU, so it
> > used no synchronization when accessing this structure.
> > 
> > When we disable a CPU by writing zero to
> > /sys/devices/system/cpu/cpu*/online, the work item could be moved to
> > another CPU. This causes crashes in dm-crypt because the code starts using
> > a wrong ablkcipher_request.
> > 
> > This patch fixes this bug by removing the percpu definition. The structure
> > ablkcipher_request is accessed via a pointer from convert_context.
> > Consequently, if the work item is rescheduled to a different CPU, the
> > thread still uses the same ablkcipher_request.
> 
> Hi Mikulas,
> 
> Obviously avoiding crashes is more important than performance.
> 
> But are we losing performance by switching away from using percpu?  Do
> we care?  I'd like to see the header to speak to the potential for
> slowdown (if there is any).

There is one more allocation per request than before. I don't know how 
much does it cost.

We could also modify the code to use per_bio_data to save one allocation.

Mikulas
