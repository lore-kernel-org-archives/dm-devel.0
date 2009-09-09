From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 9 Sep 2009 16:21:22 +0530
Message-ID: <20090909105122.GF8828@linux.vnet.ibm.com>
References: <20090908.120119.71095369.ryov@valinux.co.jp> <20090908134244.GA15974@redhat.com> <20090908170649.GC8828@linux.vnet.ibm.com> <20090909.150511.112608142.ryov@valinux.co.jp>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753311AbZIIOwv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090909.150511.112608142.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: vgoyal@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Wed, Sep 09, 2009 at 03:05:11PM +0900, Ryo Tsuruta wrote:
> Hi,
> 
> Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> > > >   advantage.)
> > > 
> > > I think this is more of a disadvantage than advantage. We have a very well
> > > defined functionality of cgroup in kernel to group the tasks. Now you are
> > > coming up with your own method of grouping the tasks which will make life
> > > even more confusing for users and application writers.
> 
> I know that cgroup is a very well defined functionality, that is why
> dm-ioband also supports throttling per cgroup. But how are we supposed
> to do throttling on the system which doesn't support cgroup?
> As I wrote in another mail to Vivek, I would like to make use of
> dm-ioband on RHEL 5.x. 

Hi Ryo,

I am not sure that upstream should really be worrying about RHEL 5.x.
cgroups is a relatively mature solution and is available in most (if not
all) community distros today. We really should not be looking at another
grouping solution if the sole reason is that then dm-ioband can be used
on RHEL 5.x. The correct solution would be to maintain a separate patch
for RHEL 5.x then and not to burden the upstream kernel.

> And I don't think that the grouping methods are not complicated, just
> stack a new device on the existing device and assign bandwidth to it,
> that is the same method as other device-mapper targets, if you would
> like to assign bandwidth per thread, then register the thread's ID to
> the device and assign bandwidth to it as well. I don't think it makes
> users confused.
> 
> > I would tend to agree with this. With other resource management
> > controllers using cgroups, having dm-ioband use something different will
> > require a different set of userspace tools/libraries to be used.
> > Something that will severly limit its usefulness froma programmer's
> > perspective.
> 
> Once we create a dm-ioband device, the device can be configured
> through the cgroup interface. I think it will not severly limit its
> usefulness.
> 

My objection is slightly different. My objection is that there are too
many interfaces to do the same thing. Which one of these is the
recommended one? WHich one is going to be supported? If we say that
cgroups is not the preferred interface, do the application developers
need to use yet another library for io control along with cpu/memory
control?

thanks,
-- 
regards,
Dhaval
