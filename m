From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Tue, 08 Sep 2009 14:05:16 +0900 (JST)
Message-ID: <20090908.140516.104049366.ryov@valinux.co.jp>
References: <4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908032254.GJ8315@balbir.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090908032254.GJ8315@balbir.in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: balbir@linux.vnet.ibm.com
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com
List-Id: dm-devel.ids

Hi Balbir,

Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Ryo Tsuruta <ryov@valinux.co.jp> [2009-09-08 12:01:19]:
> 
> > I think there are some advantages to dm-ioband. That's why I post
> > dm-ioband to the mailing list.
> > 
> > - dm-ioband supports not only proportional weight policy but also rate
> >   limiting policy. Besides, new policies can be added to dm-ioband if
> >   a user wants to control bandwidth by his or her own policy.
> > - The dm-ioband driver can be replaced without stopping the system by
> >   using device-mapper's facility. It's easy to maintain.
> > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> >   advantage.)
> 
> But don't you need page_cgroup for IO tracking?

It is not necessary when controlling bandwidth on a per partition
basis or on a IO thread basis like Xen blkback kernel thread.

Here are configration examples.
http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband/man/examples

Thanks,
Ryo Tsuruta
