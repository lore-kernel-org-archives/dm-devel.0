From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 9 Sep 2009 09:34:27 -0400
Message-ID: <20090909133427.GA8256@redhat.com>
References: <20090908032254.GJ8315@balbir.in.ibm.com>
	<20090908.140516.104049366.ryov@valinux.co.jp>
	<20090908134915.GB15974@redhat.com>
	<20090909.141748.189706141.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090909.141748.189706141.ryov@valinux.co.jp>
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
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Wed, Sep 09, 2009 at 02:17:48PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > > It is not necessary when controlling bandwidth on a per partition
> > > basis or on a IO thread basis like Xen blkback kernel thread.
> > > 
> > > Here are configration examples.
> > > http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband/man/examples
> > > 
> > 
> > For partition based control, where a thread or group of threads is doing
> > IO to a specific parition, why can't you simply create different cgroups
> > for each partition and move threads in those partitions.
> > 
> > 
> > 			root
> > 		 	/ | \
> > 		    sda1 sda2 sda3
> >
> > Above are three groups and move threads doing IO into those groups and
> > problem is solved. In fact that's what one will do for KVM virtual
> > machines. Move all the qemu helper threds doing IO for a virtual machine
> > instance into a specific group and control the IO.
> > 
> > Why do you have to come up with additional complicated grouping mechanism?
> 
> I don't get why you think it's complicated, your io-controller also
> provides the same grouping machanism which assigns bandwidth per
> device by io.policy file. What's the difference?

I am using purely cgroup based interface. This makes life easier for user
space tools and libraries like libcgroup and should also help libvirt. Now
they can treat all the resource controllers in kernel in a uniform way
(through cgroup interface).

With-in cgroups, there are controller specific files and libcgroup is
aware of that. So libcgroup can be modified to take care of special
syntax of io.policy file. But this is not too big a deviation in overall
picture.

dm-ioband is coming up with a whole new way of configuring and managing
groups and now these user space tools shall have to be modified to take
care of this new way only for io controller.

The point is there is no need. You seem to be introducing this new
interface because you want to use this module with RHEL5 which does not
have cgroup support. 

I think this is hard to sell argument that upstream should also introduce
a new interface just because one wants to use the module with older
releases of kernel which did not have cgroup support.

Taking this new interface solves your case but will make life harder for user
space tools, libraries and applications making use of cgroups and various
resource controllers.

> The thread grouping
> machianism is also not special, it is the same concept as cgroup.
> These mechanisms are necessary to make use of dm-ioband on the systems
> which doesn't support cgroup such as RHEL 5.x. As you know, dm-ioband
> also supports cgroup, the configurations you mentioned above can apply
> to the system by dm-ioband.

dm-ioband also supports cgroup but there is additional step required and
that is passing all the cgroup ids to various ioband devices. This
requires knowledge of all the ioband devices and how these have been
created and usage of dm tools. 

The only place where it helps a bit is that once the configuration is
done, one can move the tasks in groups to arbitrarily group them instead
of grouping these on pid, gid etc....

So it still does not solve the issue of dm-ioband being so different from
rest of the controllers and introducing a new interface for creation and
management of groups.

> I think it's not bad to have several ways
> to setup.

It is not bad if there is a proper justification for new interface and why
existing standard mechanism does not meet that requirement.

In this case you are saying that in general cgroup mechanism is sufficient
to take care of grouping of tasks but it is not available in older kernels
hence let us introduce a new interface in upstream kernels. I think this does
not work. This brings in unnecessary overhead of maintaining anohter interface
for upstream and upstream does not benefit from this interface.

Thanks
Vivek
