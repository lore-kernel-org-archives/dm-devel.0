From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
Date: Sat, 21 Jan 2012 14:35:18 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F1AB392.20604@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, 21 Jan 2012 at 13:46, Jens Axboe wrote:
> Can you try and pull:
> 
> git://git.kernel.dk/linux-block.git for-linus
> 
> and see if it helps?

Pulled, compiled, bootet - but the BUG: stays. Please see .config and full 
dmesg: http://nerdbynature.de/bits/3.2.0/   (the 3.3.0-rc1 files)

Note that I don't have an actual problem here: the machine (PowerBook G4) 
is booting & running fine, I'm currently not using any LVM devices, so 
it's merely the BUG: being printed during bootup I'm whining about.

Thanks,
Christian.
-- 
BOFH excuse #292:

We ran out of dial tone and we're and waiting for the phone company to deliver another bottle.
