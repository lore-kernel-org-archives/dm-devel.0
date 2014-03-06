From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: A target to just process bios background?
Date: Thu, 6 Mar 2014 17:57:21 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1403061745500.928@file01.intranet.prod.int.rdu2.redhat.com>
References: <20140304103037.a42991f149d749448846caab@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140304103037.a42991f149d749448846caab@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akira Hayakawa <hayakawa@valinux.co.jp>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Tue, 4 Mar 2014, Akira Hayakawa wrote:

> Hi,
> 
> Is it meaningless to submit the split and cloned bios in background
> using workqueue?
> 
> device-mapper doesn't go to next split before the .map hook returns
> (and generic_make_request() returns only in case of DM_MAPIO_REMAPPED).
> So, quitting from .map hook and going into next split fast sounds to me
> effective at least in terms of CPU usage (in multicore system).
> 
> is this discussed before?
> 
> A target as tiny as linear or flakey can be thought:
> - it has work_struct in per_bio_data
> - .map hook queue_work the work into private wq.
> - and then return DM_MAPIO_SUBMITTED
> 
> is this implemented before?
> 
> I think this target will make people happy if they
> want to see what if the bio submission is done background
> without changing their code but only stacking a dm target.
> 
> I am sorry if I am confused.

Hi

Such target doesn't exist and I wouldn't recommend to make it. If you 
add the bio to a queue and return immediatelly from the map routine, the 
caller sends another bio. So, in the end, you end up with extreme amount 
of bios on the queue and very bad responsiveness.

Suppose, for example, that you have a system with 16GB memory. 20% can be 
marked dirty (that's the default value for /proc/sys/vm/dirty_ratio), and 
if you use 4k bios, you may have 838860 bios on the queue. Any process 
that tries to write anything to disk freezes until all of them are 
written.

In fact, dm-crypt behaves this way - and we have a bug report that it 
causes out-of-memory crashes when massive amounts of bios are added to the 
queue.

dm-mirror also behaves this way, but only for write bios - you can load a 
mirror target with both legs pointing to the same device if you want to 
see how does it behave.

Mikulas
