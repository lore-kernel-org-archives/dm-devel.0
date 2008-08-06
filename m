From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: RFC: I/O bandwidth controller (was Re: Too many I/O controller
	patches)
Date: Wed, 06 Aug 2008 11:00:44 -0700
Message-ID: <1218045644.10907.93.camel@nimitz>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz>
	 <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <4899D464.1070506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754692AbYHFSCs@vger.kernel.org>
In-Reply-To: <4899D464.1070506@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Cc: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>, xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, ngupta@google.com, Andrea Righi <righi.andrea@gmail.com>
List-Id: dm-devel.ids

On Wed, 2008-08-06 at 22:12 +0530, Balbir Singh wrote:
> Would you like to split up IO into read and write IO. We know that read can be
> very latency sensitive when compared to writes. Should we consider them
> separately in the RFC?

I'd just suggest doing what is simplest and can be done in the smallest
amount of code.  As long as it is functional in some way and can be
extended to cover the end goal, I say keep it tiny.

> > Even in the non-hotplug case it would be nice if we could treat each
> > block I/O device as an independent resource, which means we could do
> > things like allocating I/O bandwidth on a per-device basis. As long as
> > performance is not compromised too much, adding some kind of basic
> > hotplug support to cgroups is probably worth it.
> 
> Won't that get too complex. What if the user has thousands of disks with several
> partitions on each?

I think what Fernando is suggesting is that we *allow* each disk to be
treated separately, not that we actually separate them out.  I agree
that with large disk count systems, it would get a bit nutty to deal
with I/O limits on each of them.  It would also probably be nutty for
some dude with two disks in his system to have to set (or care about)
individual limits.

I guess I'm just arguing that we should allow pretty arbitrary grouping
of block devices into these resource pools.

-- Dave
