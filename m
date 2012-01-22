From: Jens Axboe <axboe@kernel.dk>
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
Date: Sun, 22 Jan 2012 13:09:56 +0100
Message-ID: <4F1BFC94.9000306@kernel.dk>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org> <4F1AB392.20604@kernel.dk> <alpine.DEB.2.01.1201211430340.2895@trent.utfs.org> <4F1BE548.3000800@kernel.dk> <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1201220233260.2895@trent.utfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 2012-01-22 11:36, Christian Kujau wrote:
> On Sun, 22 Jan 2012 at 11:30, Jens Axboe wrote:
>> What about with this on top?
> 
> Will try. A compile on this box takes almost two hours (PowerBook G4, 
> throttled to 70MHz), would it be enough to remove the block/*.o files and 
> continue from there?

Yes, just recompiling block/*.o is enough.

-- 
Jens Axboe
