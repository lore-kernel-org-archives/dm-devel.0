From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Too many I/O controller patches
Date: Mon, 04 Aug 2008 12:02:01 -0700
Message-ID: <1217876521.20260.123.camel@nimitz>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz>  <489748E6.5080106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761220AbYHDTCh@vger.kernel.org>
In-Reply-To: <489748E6.5080106@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: righi.andrea@gmail.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org
List-Id: dm-devel.ids

On Mon, 2008-08-04 at 20:22 +0200, Andrea Righi wrote:
> But I'm not yet convinced that limiting the IO writes at the device
> mapper layer is the best solution. IMHO it would be better to throttle
> applications' writes when they're dirtying pages in the page cache (the
> io-throttle way), because when the IO requests arrive to the device
> mapper it's too late (we would only have a lot of dirty pages that are
> waiting to be flushed to the limited block devices, and maybe this could
> lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
> (at least for my requirements). Ryo, correct me if I'm wrong or if I've
> not understood the dm-ioband approach.

The avoid-lots-of-page-dirtying problem sounds like a hard one.  But, if
you look at this in combination with the memory controller, they would
make a great team.

The memory controller keeps you from dirtying more than your limit of
pages (and pinning too much memory) even if the dm layer is doing the
throttling and itself can't throttle the memory usage.

I also don't think this is any different from the problems we have in
the regular VM these days.  Right now, people can dirty lots of pages on
devices that are slow.  The only thing dm-ioband would be added would be
changing how those devices *got* slow. :)

-- Dave
