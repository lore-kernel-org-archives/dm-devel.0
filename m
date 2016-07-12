From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Page Allocation Failures/OOM with dm-crypt on software RAID10
 (Intel Rapid Storage)
Date: Tue, 12 Jul 2016 13:49:20 +0200
Message-ID: <20160712114920.GF14586@dhcp22.suse.cz>
References: <02580b0a303da26b669b4a9892624b13@mail.ud19.udmedia.de>
 <20160712095013.GA14591@dhcp22.suse.cz>
 <d9dbe0328e938eb7544fdb2aa8b5a9c7@mail.ud19.udmedia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d9dbe0328e938eb7544fdb2aa8b5a9c7@mail.ud19.udmedia.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthias Dahl <ml_linux-kernel@binary-island.eu>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue 12-07-16 13:28:12, Matthias Dahl wrote:
> Hello Michal...
> 
> On 2016-07-12 11:50, Michal Hocko wrote:
> 
> > This smells like file pages are stuck in the writeback somewhere and the
> > anon memory is not reclaimable because you do not have any swap device.
> 
> Not having a swap device shouldn't be a problem -- and in this case, it
> would cause even more trouble as in disk i/o.
> 
> What could cause the file pages to get stuck or stopped from being written
> to the disk? And more importantly, what is so unique/special about the
> Intel Rapid Storage that it happens (seemingly) exclusively with that
> and not the the normal Linux s/w raid support?

I am not a storage expert (not even mention dm-crypt). But what those
counters say is that the IO completion doesn't trigger so the
PageWriteback flag is still set. Such a page is not reclaimable
obviously. So I would check the IO delivery path and focus on the
potential dm-crypt involvement if you suspect this is a contributing
factor.
 
> Also, if the pages are not written to disk, shouldn't something error
> out or slow dd down?

Writers are normally throttled when we the dirty limit. You seem to have
dirty_ratio set to 20% which is quite a lot considering how much memory
you have. If you get back to the memory info from the OOM killer report:
[18907.592209] active_anon:110314 inactive_anon:295 isolated_anon:0
                active_file:27534 inactive_file:819673 isolated_file:160
                unevictable:13001 dirty:167859 writeback:651864 unstable:0
                slab_reclaimable:177477 slab_unreclaimable:1817501
                mapped:934 shmem:588 pagetables:7109 bounce:0
                free:49928 free_pcp:45 free_cma:0

The dirty+writeback is ~9%. What is more interesting, though, LRU
pages are negligible to the memory size (~11%). Note the numer of
unreclaimable slab pages (~20%). Who is consuming those objects?
Where is the rest 70% of memory hiding?
-- 
Michal Hocko
SUSE Labs
