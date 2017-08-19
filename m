From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Fri, 18 Aug 2017 20:18:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708181523190.30782@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
	<22930.1510.64868.411152@quad.stoffel.home>
	<alpine.LRH.2.02.1708142001390.24994@file01.intranet.prod.int.rdu2.redhat.com>
	<22933.58742.629722.398176@quad.stoffel.home>
	<alpine.LRH.2.02.1708181253450.30782@file01.intranet.prod.int.rdu2.redhat.com>
	<22935.14792.87054.266777@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22935.14792.87054.266777@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Stoffel <john@stoffel.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, Tom Yan <tom.ty89@gmail.com>, dm-devel@redhat.com, Ondrej Kozina <okozina@redhat.com>, hch@lst.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Fri, 18 Aug 2017, John Stoffel wrote:

> Mikulas> The limit can't be changed. I expect that no one will run a system with 
> Mikulas> such a tight requirements that the memory is used up to the last 2%.
> 
> Mikulas> If the user is near hitting the memory limit, he can just add swap space 
> Mikulas> to solve the problem instead of tuning dm-crypt.
> 
> My real concern is that we build up too many outstanding BIOs so that
> they take along time to process.  I'm already seeing some reports
> about timeouts after 120 seconds due to stacking of dm-crypt with
> other stuff.
> 
> What I'm trying to say is that as memory grows, you need to slow down
> the growth of the amount of memory that dm-crypt can allocate.  It's
> more important to scale by the speed of the IO sub-system than the
> size of memory.
> 
> But hey, you really addresed my concern with smaller memory systems
> already.
> 
> John

This patch doesn't restrict the number of in-flight bios. Lowering the 
memory limit has no effect on the number of bios being allocated by some 
other part of the kernel and submitted for dm-crypt.

Some times ago I made a patch that limits the number of in-flight bios in 
device mapper - see this:
http://people.redhat.com/~mpatocka/patches/kernel/dm-limit-outstanding-bios/

Mikulas
