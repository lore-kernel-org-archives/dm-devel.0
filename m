From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Fri, 08 Aug 2008 23:31:50 +0900 (JST)
Message-ID: <20080808.233150.02266833.taka@valinux.co.jp>
References: <1217870433.20260.101.camel@nimitz>
	<1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	<20080808.152119.43521725.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080808.152119.43521725.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: fernando@oss.ntt.co.jp
Cc: xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, yoshikawa.takuya@oss.ntt.co.jp, dm-devel@redhat.com, agk@sourceware.org, virtualization@lists.linux-foundation.org, ngupta@google.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi, Fernando,

> >   - Implement a block layer resource controller. dm-ioband is a working
> > solution and feature rich but its dependency on the dm infrastructure is
> > likely to find opposition (the dm layer does not handle barriers
> > properly and the maximum size of I/O requests can be limited in some
> > cases). In such a case, we could either try to build a standalone
> > resource controller based on dm-ioband (which would probably hook into
> > generic_make_request) or try to come up with something new.
> 
> I doubt about the maximum size of I/O requests problem. You can't avoid
> this problem as far as you use device mapper modules with such a bad
> manner, even if the controller is implemented as a stand-alone controller.
> There is no limitation if you only use dm-ioband without any other device
> mapper modules.

Ryo told me this isn't true anymore. The dm infrastructure introduced
a new feature to support multiple page-sized I/O requests, that was
just merged to the current linux tree. So you and me don't need to
worry about this stuff anymore.

Ryo said he was going to make dm-ioband support this new feature and
post the patches soon.

> And I think the device mapper team just started designing barriers support.
> I guess it won't take long. Right, Alasdair?
> We should know it is logically impossible to support barriers on some
> types of device mapper modules such as LVM. You can't avoid the barrier
> problem when you use this kind of multiple devices even if you implement
> the controller in the block layer.
> 
> But I think a stand-alone implementation will have a merit that it
> makes it easier to setup the configuration rather than dm-ioband.
> From this point of view, it would be good that you move the algorithm
> of dm-ioband into the block layer.
> On the other hand, we should know it will make it impossible to use
> the dm infrastructure from the controller, though it isn't so rich.
> 
> >   - If the I/O tracking patches make it into the kernel we could move on
> > and try to get the Cgroup extensions to CFQ and AS mentioned before (see
> > (1), (2), and (3) above for details) merged.
> >   - Delegate the task of controlling the rate at which a task can
> > generate dirty pages to the memory controller.
> > 
> > This RFC is somewhat vague but my feeling is that we build some
> > consensus on the goals and basic design aspects before delving into
> > implementation details.
> > 
> > I would appreciate your comments and feedback.
> > 
> > - Fernando

Thanks,
Hirokazu Takahashi.
