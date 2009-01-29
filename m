From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Implementation of dm-ioband as a dm-driver (Re: [dm-devel] [PATCH
 1/2] dm-ioband: I/O bandwidth controller v1.10.0: Source code and patch)
Date: Thu, 29 Jan 2009 12:41:33 +0900 (JST)
Message-ID: <20090129.124133.179945157.ryov@valinux.co.jp>
References: <20090122161218.GA28795@redhat.com>
	<20090123.191404.39168431.ryov@valinux.co.jp>
	<20090126162951.GI31802@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758594AbZA2Dlr@vger.kernel.org>
In-Reply-To: <20090126162951.GI31802@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com, jmoyer@redhat.com, riel@redhat.com, peterz@infradead.org, menage@google.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, chrisw@redhat.com
List-Id: dm-devel.ids

Hi Vivek,

This mail is about implement IO controller as a dm-driver.

> In this case first you are forcing some functionalilty to go in a kernel
> module and then coming up with tools for configuration. I never understood
> that why don't you let the controller be inside the kernel, let it
> directly interact with cgroup subsystem and work instead of first taking
> the functionality out of kernel in a module and then justifying the case
> that now we need new ways of configuring that module because cgroup
> infrastructure is not sufficient.  

It is possible the algorithm of dm-ioband can be directly implemented
in the kernel. I've been investigating how to do it.

> > > - Need of a dm device for every device we want to control
> > > 
> > > 	- This requirement looks odd. It forces everybody to use dm-tools
> > > 	  and if there are lots of disks in the system, configuation is
> > > 	  pain.
> > 
> > I don't think it's so pain. I think you are already using LVM devices on
> > your boxes. Setting up dm-ioband is the same as that for LVM. And some
> > scripts or something similar will help you set up them.
> 
> Not everybody uses LVM. Balbir had asked once, if there are thousands of 
> disks in the system, does that mean I need to create this dm-ioband device
> for all the disks?

I think it could be easily done by a small script of several lines.

Thanks,
Ryo Tsuruta
