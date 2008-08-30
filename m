From: Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for August 27
Date: Sat, 30 Aug 2008 11:10:25 +0200
Message-ID: <48B90E81.5060905@kernel.org>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <48B7C361.9070008@kernel.org> <20080829094249.GQ20055@kernel.dk> <200808292123.07246.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <200808292123.07246.bzolnier@gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

Bartlomiej Zolnierkiewicz wrote:
>>> Hmmm... it broke booting?  Bart, can you please elaborate a bit what got
>>> broken?  Did it fail to locate the root partition or were you using
>>> static device nodes?
>> It works fine for me, fwiw.
> 
> It fails to locate the root partition if you are using the default root
> device on x86 (the one hard-wired into bzImage, it uses hard-coded 8-bit
> major/minor numbers).

Right.  That would break it too.

> Now I see that the issue is easily fixed by passing the root device name
> with "root=" (since it will figure out the actual major/minor numbers
> later) and that the default root device is said to be deprecated according
> to Documentation/x86/boot.txt (OTOH there is no warning at all that it is
> deprecated and that you should be using "root=" so I'm not convinced that
> I'm the only one who would hit the unfortunate combination).

Yeap, in retrospect, enabling BLOCK_EXT_DEVT by default seems too
disruptive.  There also are people running off static /dev.  I hope
distros enable it during their alphas and betas tho so that they can
spot problems in configuration utilities and stuff early.

> Actually it seems that CONFIG_DEBUG_BLOCK_EXT_DEVT introduction (which I
> think is a nice step forward) is a good oportunity to put the deprecation
> of the default root device further, i.e. it may be worth to hook the
> default root device check and/or CONFIG_DEBUG_BLOCK_EXT_DEVT one into
> mount_block_root().

Maybe we can add a warning there if BLOCK_EXT_DEVT is enabled or do
you have something else on mind?

Thanks.

-- 
tejun
