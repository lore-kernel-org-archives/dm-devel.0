From: Tejun Heo <tj@kernel.org>
Subject: Re: RAID/block regression starting from 2.6.32, bisected
Date: Fri, 30 Jul 2010 12:29:30 +0200
Message-ID: <4C52A98A.7060507@kernel.org>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net> <20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu> <4C5073F3.1060406@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C5073F3.1060406@vlnb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

On 07/28/2010 08:16 PM, Vladislav Bolkhovitin wrote:
> In recent kernels we are experiencing a problem that in our setup
> using SCST BLOCKIO backend some BIOs are finished, i.e. the finish
> callback called for them, with error -EIO. It happens quite often,
> much more often than one would expect to have an actual IO
> error. (BLOCKIO backend just converts all incoming SCSI commands to
> the corresponding block requests.)
> 
> After some investigation, we figured out, that, most likely,
> raid5.c::make_request() for some reason sometimes calls bio_endio()
> with not BIO_UPTODATE bios.
> 
> We bisected it to commit: 
> 
> commit a82afdfcb8c0df09776b6458af6b68fc58b2e87b
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Jul 3 17:48:16 2009 +0900
> 
>     block: use the same failfast bits for bio and request

That commit doesn't (or at least isn't supposed to) make any behavior
difference.  It's just repositioning flag bits.  If the commit is
actually causing the problem, I think one possibility is that whatever
code could be using hard coded constants which now are mapped to
different flags.  The mixed merge changes have been in mainline for
quite some time and shipping in all major distros too and this is the
first time this is reported, so I don't think it could be a widespread
problem.

Thanks.

-- 
tejun
