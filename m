From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Thu, 10 Sep 2009 16:58:49 +0900 (JST)
Message-ID: <20090910.165849.104059407.ryov@valinux.co.jp>
References: <20090908170649.GC8828@linux.vnet.ibm.com>
	<20090909.150511.112608142.ryov@valinux.co.jp>
	<20090909105122.GF8828@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090909105122.GF8828@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dhaval@linux.vnet.ibm.com
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi,

Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > I know that cgroup is a very well defined functionality, that is why
> > dm-ioband also supports throttling per cgroup. But how are we supposed
> > to do throttling on the system which doesn't support cgroup?
> > As I wrote in another mail to Vivek, I would like to make use of
> > dm-ioband on RHEL 5.x. 
> 
> Hi Ryo,
> 
> I am not sure that upstream should really be worrying about RHEL 5.x.
> cgroups is a relatively mature solution and is available in most (if not
> all) community distros today. We really should not be looking at another
> grouping solution if the sole reason is that then dm-ioband can be used
> on RHEL 5.x. The correct solution would be to maintain a separate patch
> for RHEL 5.x then and not to burden the upstream kernel.

RHEL 5.x is not the sole reason for that.

> > And I don't think that the grouping methods are not complicated, just
> > stack a new device on the existing device and assign bandwidth to it,
> > that is the same method as other device-mapper targets, if you would
> > like to assign bandwidth per thread, then register the thread's ID to
> > the device and assign bandwidth to it as well. I don't think it makes
> > users confused.
> > 
> > > I would tend to agree with this. With other resource management
> > > controllers using cgroups, having dm-ioband use something different will
> > > require a different set of userspace tools/libraries to be used.
> > > Something that will severly limit its usefulness froma programmer's
> > > perspective.
> > 
> > Once we create a dm-ioband device, the device can be configured
> > through the cgroup interface. I think it will not severly limit its
> > usefulness.
> > 
> 
> My objection is slightly different. My objection is that there are too
> many interfaces to do the same thing.

Not too many, There are only two interfaces device-mapper and cgroup.

> Which one of these is the recommended one? 

I think whichever users like, it's up to users.

> WHich one is going to be supported?

Both device-mapper and cgroup interfaces are supported continuously.

> If we say that cgroups is not the preferred interface, do the
> application developers need to use yet another library for io
> control along with cpu/memory control?

I don't think that cgroup is not the preferred interface, especially
not if dm-ioband uses with cpu/memory controller together. Once a
dm-ioband device is created, all configurations for the device can be
done through the cgroup interface like other cgroup subsystems. It
does not require a different set of userspace tools/libraries to be
used.

I think it is natural to make dm-ioband can be configured by
device-mapper's interface since dm-ioband is a device-mapper driver,
and it extends use case, rather it limits usefulness.

Thanks,
Ryo Tsuruta
