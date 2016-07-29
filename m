From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: To add, or not to add, a bio REQ_ROTATIONAL flag
Date: Thu, 28 Jul 2016 17:50:14 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1607281603530.10662@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: dm-devel.ids

Hello all,

With the many SSD caching layers being developed (bcache, dm-cache, 
dm-writeboost, etc), how could we flag a bio from userspace to indicate 
whether the bio is preferred to hit spinning disks instead of an SSD?

Unnecessary promotions, evections, and writeback increase the write burden 
on the caching layer and burns out SSDs too fast (TBW), thus requring 
equipment replacement.

Is there already a mechanism for this that could be added to the various 
caching mechanisms' promote/demote/bypass logic?

For example, I would like to prevent backups from influencing the cache 
eviction logic. Neither do I wish to evict cache due to a bio from a 
backup process, nor do I wish a bio from the backup process to be cached 
on the SSD.  


We would want to bypass the cache for IO that is somehow flagged to bypass 
block-layer caches and use the rotational disk unless the referenced block 
already exists on the SSD.

There might be two cases here that would be ideal to unify without 
touching filesystem code:

  1) open() of a block device

  2) open() on a file such that a filesystem must flag the bio

I had considered writing something to detect FADV_SEQUENTIAL/FADV_NOREUSE 
or `ionice -c3` on a process hitting bcache and modifying 
check_should_bypass()/should_writeback() to behave as such.

However, just because FADV_SEQUENTIAL is flagged doesn't mean the cache 
should bypass.  Filesystems can fragment, and while the file being read 
may be read sequentially, the blocks on which it resides may not be.  
Same thing for higher-level block devices such as dm-thinp where one might 
sequentially read a thin volume but its _tdata might not be in linear 
order.  This may imply that we need a new way to flag cache bypass from 
userspace that is neither io-priority nor fadvise driven.

So what are our options?  What might be the best way to do this?

If fadvise is the better option, how can a block device driver lookup the 
fadvise advice from a given bio struct?  Can we add an FADV_NOSSD flag 
since FADV_SEQUENTIAL may be insufficent?  Are FADV_NOREUSE/FADV_DONTNEED 
reasonable candidates?

Perhaps ionice could be used used, but the concept of "priority" 
doesn't exactly encompass the concept of cache-bypass---so is something 
else needed?

Other ideas?  


--
Eric Wheeler
