From: Jens Axboe <axboe@kernel.dk>
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
Date: Sat, 21 Jan 2012 13:46:10 +0100
Message-ID: <4F1AB392.20604@kernel.dk>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org> <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, peterz@infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 2012-01-21 12:42, Christian Kujau wrote:
> On Wed, 18 Jan 2012 at 00:18, Christian Kujau wrote:
>> today's git checkout boots fine on powerpc32, but has this message during 
>> bootup:
>>
>> BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
>>  lock: ef32a9f8, .magic: dead4ead, .owner: vgchange/936, .owner_cpu: 0
>> Call Trace:
> 
> Still happening with 3.3.0-rc1.

Can you try and pull:

git://git.kernel.dk/linux-block.git for-linus

and see if it helps?

-- 
Jens Axboe
