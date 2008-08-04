From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: Too many I/O controller patches
Date: Mon, 04 Aug 2008 22:44:26 +0200
Message-ID: <48976A2A.9060600@gmail.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp>	 <1217870433.20260.101.camel@nimitz>  <489748E6.5080106@gmail.com> <1217876521.20260.123.camel@nimitz>
Reply-To: righi.andrea@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763915AbYHDUox@vger.kernel.org>
In-Reply-To: <1217876521.20260.123.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org
List-Id: dm-devel.ids

Dave Hansen wrote:
> On Mon, 2008-08-04 at 20:22 +0200, Andrea Righi wrote:
>> But I'm not yet convinced that limiting the IO writes at the device
>> mapper layer is the best solution. IMHO it would be better to throttle
>> applications' writes when they're dirtying pages in the page cache (the
>> io-throttle way), because when the IO requests arrive to the device
>> mapper it's too late (we would only have a lot of dirty pages that are
>> waiting to be flushed to the limited block devices, and maybe this could
>> lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
>> (at least for my requirements). Ryo, correct me if I'm wrong or if I've
>> not understood the dm-ioband approach.
> 
> The avoid-lots-of-page-dirtying problem sounds like a hard one.  But, if
> you look at this in combination with the memory controller, they would
> make a great team.
> 
> The memory controller keeps you from dirtying more than your limit of
> pages (and pinning too much memory) even if the dm layer is doing the
> throttling and itself can't throttle the memory usage.

mmh... but in this way we would just move the OOM inside the cgroup,
that is a nice improvement, but the main problem is not resolved...

A safer approach IMHO is to force the tasks to wait synchronously on
each operation that directly or indirectly generates i/o.

In particular the solution used by the io-throttle controller to limit
the dirty-ratio in memory is to impose a sleep via
schedule_timeout_killable() in balance_dirty_pages() when a generic
process exceeds the limits defined for the belonging cgroup.

Limiting read operations is a lot more easy, because they're always
synchronized with i/o requests.

-Andrea
