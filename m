From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [RFC PATCH 2/2] mm, mempool: do not throttle
 PF_LESS_THROTTLE tasks
Date: Wed, 27 Jul 2016 10:28:40 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607270948040.1779@file01.intranet.prod.int.rdu2.redhat.com>
References: <1468831164-26621-1-git-send-email-mhocko@kernel.org> <1468831285-27242-1-git-send-email-mhocko@kernel.org> <1468831285-27242-2-git-send-email-mhocko@kernel.org> <87oa5q5abi.fsf@notabene.neil.brown.name> <20160722091558.GF794@dhcp22.suse.cz>
 <878twt5i1j.fsf@notabene.neil.brown.name> <alpine.LRH.2.02.1607251730280.11852@file01.intranet.prod.int.rdu2.redhat.com> <87invr4tjm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87invr4tjm.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Ondrej Kozina <okozina@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids



On Wed, 27 Jul 2016, NeilBrown wrote:

> On Tue, Jul 26 2016, Mikulas Patocka wrote:
> 
> > On Sat, 23 Jul 2016, NeilBrown wrote:
> >
> >> "dirtying ... from the reclaim context" ??? What does that mean?
> >> According to
> >>   Commit: 26eecbf3543b ("[PATCH] vm: pageout throttling")
> >> From the history tree, the purpose of throttle_vm_writeout() is to
> >> limit the amount of memory that is concurrently under I/O.
> >> That seems strange to me because I thought it was the responsibility of
> >> each backing device to impose a limit - a maximum queue size of some
> >> sort.
> >
> > Device mapper doesn't impose any limit for in-flight bios.
> 
> I would suggest that it probably should. At least it should
> "set_wb_congested()" when the number of in-flight bios reaches some
> arbitrary threshold.

If we set the device mapper device as congested, it can again trigger that 
mempool alloc throttling bug.

I.e. suppose that we swap to a dm-crypt device. The dm-crypt device 
becomes clogged and sets its state as congested. The underlying block 
device is not congested.

The mempool_alloc function in the dm-crypt workqueue sets the 
PF_LESS_THROTTLE flag, and tries to allocate memory, but according to 
Michal's patches, processes with PF_LESS_THROTTLE may still get throttled.

So if we set the dm-crypt device as congested, it can incorrectly throttle 
the dm-crypt workqueue that does allocations of temporary pages and 
encryption.

I think that approach with PF_LESS_THROTTLE in mempool_alloc is incorrect 
and that mempool allocations should never be throttled.

> > I've made some patches that limit in-flight bios for device mapper in
> > the past, but there were not integrated into upstream.
> 
> I second the motion to resurrect these.

I uploaded those patches here:

http://people.redhat.com/~mpatocka/patches/kernel/dm-limit-outstanding-bios/

Mikulas

> Thanks,
> NeilBrown
> 
