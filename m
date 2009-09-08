From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 8 Sep 2009 09:49:15 -0400
Message-ID: <20090908134915.GB15974@redhat.com>
References: <4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908032254.GJ8315@balbir.in.ibm.com>
	<20090908.140516.104049366.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090908.140516.104049366.ryov@valinux.co.jp>
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

On Tue, Sep 08, 2009 at 02:05:16PM +0900, Ryo Tsuruta wrote:
> Hi Balbir,
> 
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > * Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-08 12:01:19]:
> > 
> > > I think there are some advantages to dm-ioband. That's why I post
> > > dm-ioband to the mailing list.
> > > 
> > > - dm-ioband supports not only proportional weight policy but also rate
> > >   limiting policy. Besides, new policies can be added to dm-ioband if
> > >   a user wants to control bandwidth by his or her own policy.
> > > - The dm-ioband driver can be replaced without stopping the system by
> > >   using device-mapper's facility. It's easy to maintain.
> > > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> > >   advantage.)
> > 
> > But don't you need page_cgroup for IO tracking?
> 
> It is not necessary when controlling bandwidth on a per partition
> basis or on a IO thread basis like Xen blkback kernel thread.
> 
> Here are configration examples.
> http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband/man/examples
> 

For partition based control, where a thread or group of threads is doing
IO to a specific parition, why can't you simply create different cgroups
for each partition and move threads in those partitions.


			root
		 	/ | \
		    sda1 sda2 sda3

Above are three groups and move threads doing IO into those groups and
problem is solved. In fact that's what one will do for KVM virtual
machines. Move all the qemu helper threds doing IO for a virtual machine
instance into a specific group and control the IO.

Why do you have to come up with additional complicated grouping mechanism?

Thanks
Vivek
