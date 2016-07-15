From: David Rientjes <rientjes@google.com>
Subject: Re: System freezes after OOM
Date: Fri, 15 Jul 2016 14:58:20 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1607151447490.121215@chino.kir.corp.google.com>
References: <57837CEE.1010609@redhat.com> <alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com> <20160712064905.GA14586@dhcp22.suse.cz> <alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
 <2d5e1f84-e886-7b98-cb11-170d7104fd13@I-love.SAKURA.ne.jp> <20160713133955.GK28723@dhcp22.suse.cz> <alpine.LRH.2.02.1607131004340.31769@file01.intranet.prod.int.rdu2.redhat.com> <20160713145638.GM28723@dhcp22.suse.cz>
 <alpine.LRH.2.02.1607131105080.31769@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.10.1607131644590.92037@chino.kir.corp.google.com> <alpine.LRH.2.02.1607140818250.15554@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.10.1607141316240.68666@chino.kir.corp.google.com>
 <alpine.LRH.2.02.1607150711270.5034@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.10.1607151422140.121215@chino.kir.corp.google.com> <alpine.LRH.2.02.1607151730430.21114@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1607151730430.21114@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Ondrej Kozina <okozina@redhat.com>, Jerome Marchand <jmarchan@redhat.com>, Stanislav Kozina <skozina@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 15 Jul 2016, Mikulas Patocka wrote:

> And what about the oom reaper? It should have freed all victim's pages 
> even if the victim is looping in mempool_alloc. Why the oom reaper didn't 
> free up memory?
> 

Is that possible with mlock or shared memory?  Nope.  The oom killer does 
not have the benefit of selecting a process to kill that will likely free 
the most memory or reap the most memory, the choice is configurable by the 
user.

> > guarantee that elements would be returned in a completely livelocked 
> > kernel in 4.7 or earlier kernels, that would not have been the case.  I 
> 
> And what kind of targets do you use in device mapper in the configuration 
> that livelocked? Do you use some custom google-developed drivers?
> 
> Please describe the whole stack of block I/O devices when this livelock 
> happened.
> 
> Most device mapper drivers can really make forward progress when they are 
> out of memory, so I'm interested what kind of configuration do you have.
> 

Kworkers are processing writeback, ext4_writepages() relies on kmem that 
is reclaiming memory itself through kmem_getpages() and they are waiting 
on the oom victim to exit so they endlessly loop in the page allocator 
themselves.  Same situation with __alloc_skb() so we can intermittently 
lose access to hundreds of the machines over the network.  There are no 
custom drivers required for this to happen, the stack trace has already 
been posted of the livelock victim and this can happen for anything in 
filemap_fault() that has TIF_MEMDIE set.

> > frankly don't care about your patch reviewing of dm mempool usage when 
> > dm_request() livelocked our kernel.
> 
> If it livelocked, it is a bug in some underlying block driver, not a bug 
> in mempool_alloc.
> 

Lol, the interface is quite clear and can be modified to allow mempool 
users to set __GFP_NOMEMALLOC on their mempool_alloc() request if they can 
guarantee elements will be returned to the freelist in all situations, 
including system oom situations.  We may revert that ourselves if our 
machines time out once we use a post-4.7 kernel and report that as 
necessary.
