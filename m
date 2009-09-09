From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 09 Sep 2009 14:17:48 +0900 (JST)
Message-ID: <20090909.141748.189706141.ryov@valinux.co.jp>
References: <20090908032254.GJ8315@balbir.in.ibm.com>
	<20090908.140516.104049366.ryov@valinux.co.jp>
	<20090908134915.GB15974@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090908134915.GB15974@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vgoyal@redhat.com
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > It is not necessary when controlling bandwidth on a per partition
> > basis or on a IO thread basis like Xen blkback kernel thread.
> > 
> > Here are configration examples.
> > http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband/man/examples
> > 
> 
> For partition based control, where a thread or group of threads is doing
> IO to a specific parition, why can't you simply create different cgroups
> for each partition and move threads in those partitions.
> 
> 
> 			root
> 		 	/ | \
> 		    sda1 sda2 sda3
>
> Above are three groups and move threads doing IO into those groups and
> problem is solved. In fact that's what one will do for KVM virtual
> machines. Move all the qemu helper threds doing IO for a virtual machine
> instance into a specific group and control the IO.
> 
> Why do you have to come up with additional complicated grouping mechanism?

I don't get why you think it's complicated, your io-controller also
provides the same grouping machanism which assigns bandwidth per
device by io.policy file. What's the difference? The thread grouping
machianism is also not special, it is the same concept as cgroup.
These mechanisms are necessary to make use of dm-ioband on the systems
which doesn't support cgroup such as RHEL 5.x. As you know, dm-ioband
also supports cgroup, the configurations you mentioned above can apply
to the system by dm-ioband. I think it's not bad to have several ways
to setup.

Thanks,
Ryo Tsuruta
