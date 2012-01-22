From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
Date: Sun, 22 Jan 2012 02:36:38 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk> <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org> <4F1BE548.3000800@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F1BE548.3000800@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 22 Jan 2012 at 11:30, Jens Axboe wrote:
> What about with this on top?

Will try. A compile on this box takes almost two hours (PowerBook G4, 
throttled to 70MHz), would it be enough to remove the block/*.o files and 
continue from there?

Thanks,
Christian.
-- 
BOFH excuse #17:

fat electrons in the lines
