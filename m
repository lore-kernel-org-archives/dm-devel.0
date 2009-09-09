From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 09 Sep 2009 15:05:11 +0900 (JST)
Message-ID: <20090909.150511.112608142.ryov@valinux.co.jp>
References: <20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908134244.GA15974@redhat.com>
	<20090908170649.GC8828@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090908170649.GC8828@linux.vnet.ibm.com>
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
> > > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> > >   advantage.)
> > 
> > I think this is more of a disadvantage than advantage. We have a very well
> > defined functionality of cgroup in kernel to group the tasks. Now you are
> > coming up with your own method of grouping the tasks which will make life
> > even more confusing for users and application writers.

I know that cgroup is a very well defined functionality, that is why
dm-ioband also supports throttling per cgroup. But how are we supposed
to do throttling on the system which doesn't support cgroup?
As I wrote in another mail to Vivek, I would like to make use of
dm-ioband on RHEL 5.x. 
And I don't think that the grouping methods are not complicated, just
stack a new device on the existing device and assign bandwidth to it,
that is the same method as other device-mapper targets, if you would
like to assign bandwidth per thread, then register the thread's ID to
the device and assign bandwidth to it as well. I don't think it makes
users confused.

> I would tend to agree with this. With other resource management
> controllers using cgroups, having dm-ioband use something different will
> require a different set of userspace tools/libraries to be used.
> Something that will severly limit its usefulness froma programmer's
> perspective.

Once we create a dm-ioband device, the device can be configured
through the cgroup interface. I think it will not severly limit its
usefulness.

Thanks,
Ryo Tsuruta
