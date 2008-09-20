From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [dm-devel] Re: dm-ioband + bio-cgroup benchmarks
Date: Sat, 20 Sep 2008 18:25:41 +0900
Message-ID: <20080920182541.0edb5ab5.kamezawa.hiroyu@jp.fujitsu.com>
References: <48D267B5.20402@gmail.com>
	<20080918150634.GH20640@redhat.com>
	<48D2715A.6060002@gmail.com>
	<20080919.123405.91829935.taka@valinux.co.jp>
	<20080920132703.e74c8f89.kamezawa.hiroyu@jp.fujitsu.com>
	<48D48789.8000606@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752932AbYITJTf@vger.kernel.org>
In-Reply-To: <48D48789.8000606@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Cc: Hirokazu Takahashi <taka@valinux.co.jp>, righi.andrea@gmail.com, dm-devel@redhat.com, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, agk@sourceware.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, jens.axboe@oracle.com, fernando@oss.ntt.co.jp, xemul@openvz.org
List-Id: dm-devel.ids

On Fri, 19 Sep 2008 22:18:01 -0700
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Kamezawa-San, I am not dead against it, but I would provide a knob/control point
> for system administrator to decide if movement is important for applications,
> then let them do so (like force_empty).
> 
make sense.


> > Anyway what's next for me is
> >  1. fix current discussion to remove page->page_cgroup pointer.
> >  2. reduce locks.
> 
> Are you planning on reposting these. I've been trying other approaches at my end
> 
I'll post in next Monday. It's obvious that I should do more tests/fixes...
About performance, I'll give it up at some reasonable point.

> 1. Use radix tree per-node per-zone
> 2. Use radix trees only for 32 bit systems
> 3. Depend on CONFIG_HAVE_MEMORY_PRESENT and build a sparse data structure and
> use pre-allocation
> 
> I've posted (1) and I'll take a look at your patches as well
> 
My patch has (many) bugs. Severals are fixed but there will be still ;)
SwapCache beats me again because it easily reuse uncharged pages...

BTW why do you like radix-tree ? It's not very good for our purpose.
FLATMEM support for small system will be easy work.

> >  3. support swap and swap-cache.
> > 
> > I think algorithm for (1), (2) is now getting smart.
> > 
> 
> Yes, it is getting better
> 

Thanks,
-Kame
