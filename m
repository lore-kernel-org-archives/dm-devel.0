From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [dm-devel] [PATCH 0/2] dm-band: The I/O bandwidth controller:
 Overview
Date: Thu, 24 Jan 2008 01:21:03 +0900 (JST)
Message-ID: <20080124.012103.105433865.taka@valinux.co.jp>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<20080123144717.GS8075@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754832AbYAWQVU@vger.kernel.org>
In-Reply-To: <20080123144717.GS8075@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: ryov@valinux.co.jp, containers@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: dm-devel.ids

Hi,

> On Wed, Jan 23, 2008 at 09:53:50PM +0900, Ryo Tsuruta wrote:
> > Dm-band gives bandwidth to each job according to its weight, 
> > which each job can set its own value to.
> > At this time, a job is a group of processes with the same pid or pgrp or uid.
> 
> It seems to rely on 'current' to classify bios and doesn't do it until the map
> function is called, possibly in a different process context, so it won't
> always identify the original source of the I/O correctly:

Yes, this should be mentioned in the document with the current implementation
as you pointed out.

By the way, I think once a memory controller of cgroup is introduced, it will
help to track down which cgroup is the original source.

> people need to take
> this into account when designing their group configuration and so this should
> be mentioned in the documentation.
>
> I've uploaded it here while we consider ways we might refine the architecture and
> interfaces etc.:
> 
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-add-band-target.patch
> 
> Alasdair
> -- 
> agk@redhat.com

Thank you,
Hirokazu Takahashi.
