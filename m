From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 09 Sep 2009 19:01:46 +0900 (JST)
Message-ID: <20090909.190146.59669568.ryov@valinux.co.jp>
References: <4AA51065.6050000@redhat.com>
	<20090908.120119.71095369.ryov@valinux.co.jp>
	<20090908134244.GA15974@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752122AbZIIKBp@vger.kernel.org>
In-Reply-To: <20090908134244.GA15974@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > I think there are some advantages to dm-ioband. That's why I post
> > dm-ioband to the mailing list.
> > 
> > - dm-ioband supports not only proportional weight policy but also rate
> >   limiting policy. Besides, new policies can be added to dm-ioband if
> >   a user wants to control bandwidth by his or her own policy.
> 
> I think we can easily extent io scheduler based controller to also support
> max rate per group policy also. That should not be too hard. It is a
> matter of only keeping track of io rate per group and if a group is
> exceeding the rate, then schedule it out and move on to next group.
> 
> I can do that once proportional weight solution is stablized and gets
> merged. 
> 
> So its not an advantage of dm-ioband.

O.K.

> > - The dm-ioband driver can be replaced without stopping the system by
> >   using device-mapper's facility. It's easy to maintain.
> 
> We talked about this point in the past also. In io scheduler based
> controller, just move all the tasks to root group and you got a system
> not doing any io control.
> 
> By the way why would one like to do that? 
> 
> So this is also not an advantage.

My point is that dm-ioband can be updated for improvements and
bug-fixing without stopping the system.

> > - dm-ioband can use without cgroup. (I remember Vivek said it's not an
> >   advantage.)
> 
> I think this is more of a disadvantage than advantage. We have a very well
> defined functionality of cgroup in kernel to group the tasks. Now you are
> coming up with your own method of grouping the tasks which will make life
> even more confusing for users and application writers.
> 
> I don't understand what is that core requirement of yours which is not met
> by io scheduler based io controller. range policy control you have
> implemented recently. I don't think that removing dm-ioband module
> dynamically is core requirement. Also whatever you can do with additional 
> grouping mechanism, you can do with cgroup also.
> 
> So if there is any of your core functionality which is not fulfilled by
> io scheduler based controller, please let me know. I will be happy to look
> into it and try to provide that feature. But looking at above list, I am
> not convinced that any of the above is a compelling argument for dm-ioband
> inclusion.

As I wrote in another email, I would like to make use of dm-ioband on
the system which doesn't support cgroup such as RHEL. In addition,
there are devices which doesn't use standard IO schedulers, and
dm-ioband can work on even such devices.

Thanks,
Ryo Tsuruta
