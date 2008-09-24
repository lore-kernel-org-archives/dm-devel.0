From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: dm-ioband + bio-cgroup benchmarks
Date: Wed, 24 Sep 2008 19:34:14 +0900 (JST)
Message-ID: <20080924.193414.22923673.taka@valinux.co.jp>
References: <20080919131019.GA3606@redhat.com>
	<20080922.183651.62951479.taka@valinux.co.jp>
	<20080922143042.GA19222@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20080922143042.GA19222@redhat.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: vgoyal@redhat.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, righi.andrea@gmail.com, agk@sourceware.org, ryov@valinux.co.jp, xemul@openvz.org, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi,

> > It's possible the algorithm of dm-ioband can be placed in the block layer
> > if it is really a big problem.
> > But I doubt it can control every control block I/O as we wish since
> > the interface the cgroup supports is quite poor.
> 
> Had a question regarding cgroup interface. I am assuming that in a system,
> one will be using other controllers as well apart from IO-controller.
> Other controllers will be using cgroup as a grouping mechanism.
> Now coming up with additional grouping mechanism for only io-controller seems
> little odd to me. It will make the job of higher level management software
> harder.
> 
> Looking at the dm-ioband grouping examples given in patches, I think cases
> of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
> cgroup and making sure applications are launched/moved into right cgroup by
> user space tools. 

Grouping in pid, pgrp and uid is not the point, which I've been thinking
can be replaced with cgroup once the implementation of bio-cgroup is done.

I think problems of cgroup are that they can't support lots of storages
and hotplug devices, it just handle them as if they were just one resource.
I don't insist the interface of dm-ioband is the best. I just hope the
cgroup infrastructure support this kind of resources.

> I think keeping grouping mechanism in line with rest of the controllers
> should help because a uniform grouping mechanism should make life simpler.
> 
> I am not very sure about moving dm-ioband algorithm in block layer. Looks
> like it will make life simpler at least in terms of configuration. 


Thanks,
Hirokazu Takahashi.
