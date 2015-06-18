From: Andi Kleen <andi@firstfloor.org>
Subject: Re: WARNING: at fs/block_dev.c:5 when removing LV on removed device
Date: Thu, 18 Jun 2015 20:08:04 +0200
Message-ID: <20150618180804.GC19417@two.firstfloor.org>
References: <20150618165713.GB19417@two.firstfloor.org>
 <20150618180408.GD2321@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618180408.GD2321@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

> Hmm, so you have a filesystem active on it too?

I unmounted it before.

>  
> > Also the VG removal did not work of course.
> 
> Once you resolve the filesystem piece, from vgremove man page:
> 
> "vgremove allows you to remove one or more volume groups.  If one or
> more physical volumes in the volume group are lost, consider vgreduce
> --removemissing to make the volume group metadata consistent again."

Well in any case there should not be WARN()s.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
