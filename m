From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband + bio-cgroup benchmarks
Date: Wed, 24 Sep 2008 10:53:31 -0400
Message-ID: <20080924145331.GD547@redhat.com>
References: <20080919131019.GA3606@redhat.com>
	<20080922.183651.62951479.taka@valinux.co.jp>
	<20080922143042.GA19222@redhat.com>
	<20080924.193414.22923673.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080924.193414.22923673.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, righi.andrea@gmail.com, agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Wed, Sep 24, 2008 at 07:34:14PM +0900, Hirokazu Takahashi wrote:
> Hi,
> 
> > > It's possible the algorithm of dm-ioband can be placed in the block layer
> > > if it is really a big problem.
> > > But I doubt it can control every control block I/O as we wish since
> > > the interface the cgroup supports is quite poor.
> > 
> > Had a question regarding cgroup interface. I am assuming that in a system,
> > one will be using other controllers as well apart from IO-controller.
> > Other controllers will be using cgroup as a grouping mechanism.
> > Now coming up with additional grouping mechanism for only io-controller seems
> > little odd to me. It will make the job of higher level management software
> > harder.
> > 
> > Looking at the dm-ioband grouping examples given in patches, I think cases
> > of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
> > cgroup and making sure applications are launched/moved into right cgroup by
> > user space tools. 
> 
> Grouping in pid, pgrp and uid is not the point, which I've been thinking
> can be replaced with cgroup once the implementation of bio-cgroup is done.
> 
> I think problems of cgroup are that they can't support lots of storages
> and hotplug devices, it just handle them as if they were just one resource.
> I don't insist the interface of dm-ioband is the best. I just hope the
> cgroup infrastructure support this kind of resources.
> 

Sorry, I did not understand fully. Can you please explain in detail what
kind of situation will not be covered by cgroup interface.

Thanks
Vivek
