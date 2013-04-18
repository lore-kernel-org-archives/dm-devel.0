From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Thu, 18 Apr 2013 07:30:14 -0700
Message-ID: <20130418143014.GZ4816@kernel.dk>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk>
 <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk>
 <516FFFAC.8040103@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <516FFFAC.8040103@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Thu, Apr 18 2013, Wanlong Gao wrote:
> On 04/18/2013 09:35 PM, Jens Axboe wrote:
> > On Thu, Apr 18 2013, Wanlong Gao wrote:
> >>> A bio is always fully initialized, regardless of which internal
> >>> allocator it came from. If people are doing private kmallocs, then they
> >>> better be using bio_init() as well.
> >>>
> >>> Wanlong, would it be possible to get a full dmesg on boot see I can see
> >>> what drivers and file systems are in use? Anything special about your
> >>> setup.
> >>
> >> Sure, attached.
> > 
> > Does the below help?
> 
> Still got panic with this patch. :-(

Could you capture the full dump? I'd like to see what rcx was, and that
seems to have scrolled off.

-- 
Jens Axboe
