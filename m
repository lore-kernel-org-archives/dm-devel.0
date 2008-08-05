From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Too many I/O controller patches
Date: Tue, 05 Aug 2008 09:25:37 -0700
Message-ID: <1217953537.10907.30.camel@nimitz>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
	 <1217876521.20260.123.camel@nimitz> <48976A2A.9060600@gmail.com>
	 <6599ad830808042255y59215481l5463d4dca9fb2001@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760582AbYHEQ0X@vger.kernel.org>
In-Reply-To: <6599ad830808042255y59215481l5463d4dca9fb2001@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menage <menage@google.com>
Cc: righi.andrea@gmail.com, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org
List-Id: dm-devel.ids

On Mon, 2008-08-04 at 22:55 -0700, Paul Menage wrote:
> 
> As Dave suggested, I think it would make more sense to have your
> page-dirtying throttle points hook into the memory controller instead,
> and allow the memory controller to track/limit dirty pages for a
> cgroup, and potentially do throttling as part of that.

Yeah, I'm sure we're going to have to get to setting the dirty ratio
        
        $ cat /proc/sys/vm/dirty_ratio
        40

on a per-container basis at *some* point.  We might as well do it
earlier rather than later.

-- Dave
