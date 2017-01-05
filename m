From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: fix lost ioprio when queuing crypto bios
 from task with ioprio
Date: Thu, 5 Jan 2017 11:55:19 -0500
Message-ID: <20170105165518.GA7376@redhat.com>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net>
	<alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net>
	<20161217155800.GA6580@redhat.com>
	<alpine.LRH.2.11.1612291856160.20227@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1612291856160.20227@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, kent.overstreet@gmail.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Thu, Dec 29 2016 at 11:08pm -0500,
Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:

> On Sat, 17 Dec 2016, Mike Snitzer wrote:
> > On Fri, Dec 16 2016 at  5:29pm -0500,
> > Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
> > > On Wed, 14 Dec 2016, Eric Wheeler wrote:
> > > > Since dm-crypt queues writes (and sometimes reads) to a different kernel
> > > > thread (workqueue), the bios will dispatch from tasks with different
> > > > io_context->ioprio settings than the submitting task, thus giving
> > > > incorrect ioprio hints to the io scheduler.
> > > 
> > > The motivation of this patch is for ioprio-driven writebackup/bypass 
> > > hinting inside bcache when bcache is under dm-crypt which Jens is picking 
> > > up for 4.10:
> > >   https://lkml.org/lkml/2016/12/6/607
> > 
> > I now see your commits:
> > b71de4659fba4e42c7 bcache: introduce per-process ioprio-based bypass/writeback hints
> > 82e7192711c3855038 bcache: documentation for ioprio cache hinting
> > 
> > You'd think this is the type of thing that you'd have proposed to a
> > wider audience.  
> 
> ( Its not really relevant to this bugfix, but please see this thread since 
>   you were curious about a wider audience discussion: 
>   https://www.redhat.com/archives/dm-devel/2016-July/msg00556.html )
> 
> The note above in the previous email was intended to explain how we 
> discovered the dm-crypt problem, purely as an example use case.  The 
> stable commit note discusses the real issue: lost elevator hints.
> 
> This commit fixes elevator ioprio hints passing through dm-crypt and is 
> not intended to address dm-cache, nor enable a bcache feature.
> 
> All impementations using ioprio hints beneath dm-crypt would 
> benefit---most importantly, _CFQ_ !
>   
> As it is, all ioprio hints passing through dm-crypt are lost to the 
> elevator; the elevator looses those useful bits because of queuing to 
> another thread for crypto operations.

How did you test the change?

Or put differently: what is the easiest test to run against a dm-crypt
device to verify that ioprio is being passed through?
