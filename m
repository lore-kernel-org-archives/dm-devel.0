From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] loop: clear read-only flag in loop_clr_fd.
Date: Mon, 14 Feb 2011 15:07:55 +0100
Message-ID: <20110214140755.GL18742@htj.dyndns.org>
References: <4D573BBB.6090200@redhat.com>
 <1297594735-5593-1-git-send-email-tm@tao.ma>
 <4D57E67E.1030707@redhat.com>
 <4D57F357.6060708@tao.ma>
 <4D580A8B.5050508@redhat.com>
 <20110214103026.GA18742@htj.dyndns.org>
 <4D591664.6090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D591664.6090203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello, Milan.

On Mon, Feb 14, 2011 at 12:47:48PM +0100, Milan Broz wrote:
> With patch below (loop cannot be built as module) it fixes the loop problem.

Okay.

> But it doesn't fix the read-only snapshot issue and I guess there will be
> the same problem with read-only MD code too.
> (so the 2) issue here https://lkml.org/lkml/2011/2/12/209).
> 
> If the call is changed intentionally, we have to fix unconditional blkdev open
> calls with read-write flag in this code.
> Before doing that I would like to know if it was intentional change or not...

Yeap, the change was intentional.  It was part of effort to make bdev
usages more consistent as before there was no mechanism enforcing ro.
It's still problematic as bdev users can clear ro without consulting
the actual device driver.  Device driver's ->open() is called w/ ro
flag but the resulting bdev can be used rw.  I wanted to remove that
too but filesystems depend on it so maybe later.

Thanks.

-- 
tejun
