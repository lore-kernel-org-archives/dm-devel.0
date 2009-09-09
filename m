From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 9 Sep 2009 09:57:26 -0400
Message-ID: <20090909135726.GB8256@redhat.com>
References: <20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908134244.GA15974@redhat.com>
	<20090908170649.GC8828@linux.vnet.ibm.com>
	<20090909.150511.112608142.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090909.150511.112608142.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: riel@redhat.com, dhaval@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
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

I think you need to maintain and support this module out of the kernel tree for
older kernels. Does not make much sense to introduce new interfaces to support
a functionality in older kernels.

> And I don't think that the grouping methods are not complicated, just
> stack a new device on the existing device and assign bandwidth to it,
> that is the same method as other device-mapper targets, if you would
> like to assign bandwidth per thread, then register the thread's ID to
> the device and assign bandwidth to it as well. I don't think it makes
> users confused.

- First of all it is more about doing things a new way and not the standard
  way. Moreover upstream does not benefit from this new interface. It just
  stands to loose because of maintenance overhead and need of chaning user
  space tools to make use of this new interface.

- Secondly, personally I think it more twisted also. Following is the
  small code to setup two ioband devices ioband1 and ioband2 and two
  additional groups on ioband1 device using cgroup interface.

***********************************************************************
echo "0 $(blockdev --getsize /dev/sdd1) ioband /dev/sdd1 1 0 0 none"
"weight 0 :200" | dmsetup create ioband1
echo "0 $(blockdev --getsize /dev/sdd2) ioband /dev/sdd2 1 0 0 none"
"weight 0 :100" | dmsetup create ioband2

mount -t cgroup -o blkio hier1 /cgroup/ioband
mkdir /cgroup/ioband/test1 /cgroup/ioband/test2

test1_id=`cat /cgroup/ioband/test1/blkio.id`
test2_id=`cat /cgroup/ioband/test2/blkio.id`

test1_weight=200
test2_weight=100

dmsetup message ioband1 0 type cgroup
dmsetup message ioband1 0 attach $test1_id
dmsetup message ioband1 0 attach $test2_id
dmsetup message ioband1 0 weight $test1_id:$test1_weight
dmsetup message ioband1 0 weight $test2_id:$test2_weight

mount /dev/mapper/ioband1 /mnt/sdd1
mount /dev/mapper/ioband2 /mnt/sdd2
************************************************************************* 

For status of various settings one needs to use "dmsetup status" and
"dmsetup table" commands. Look at the output of these commands with just
two groups. Output for all the groups is on a single line. Think of the
situation when there are 7-8 groups and how bad it will look.

#dmsetup status
ioband2: 0 40355280 ioband 1 -1 105 0 834 1 0 8
ioband1: 0 37768752 ioband 1 -1 105 0 834 1 0 8 2 0 0 0 0 0 0 3 0 0 0 0 0 0

#dmsetup table
ioband2: 0 40355280 ioband 8:50 1 4 192 none weight 768 :100
ioband1: 0 37768752 ioband 8:49 1 4 192 cgroup weight 768 :200 2:200 3:100

I find it so hard to interpre those numbers. Everything about a device is
exported in a single line.

In cgroup based interface, things are deviced nicely among different
files. Also one group shows statistics about that group only and not about
all the groups present in the system. It is easier to parse and
comprehend.

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

To create the device once you need dm-tools and libcgroup needs to learn 
how to make various use of various dm commands. It also needs to learn how
to parse outputs of "dmsetup table" and "dmsetup status" commands and
consolidate that information.

This is despite the fact that it is using cgroup interface finally to
group the task. But libcgroup still need to propagate cgroup id to
individual ioband devices.

Thanks
Vivek
