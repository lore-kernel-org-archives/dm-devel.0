From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-integrity: fix inefficient allocation of stack
	space
Date: Thu, 20 Jul 2017 06:59:18 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707200652080.32226@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
	<22895.42876.199753.299282@quad.stoffel.home>
	<20170719190230.GC20480@redhat.com>
	<22895.51753.260996.643914@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22895.51753.260996.643914@quad.stoffel.home>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Wed, 19 Jul 2017, John Stoffel wrote:

> I'd like to argue that you should never use BUG_ON at all, esp since
> if you have integrity running on just one critical device, but have
> other devices that work just fine, bringing down the entire system
> because you don't think things are ok is terrible.
> 
> We should rip out ALL the BUG_ONs in the dm-integrity and just do
> proper error handling instead.  For testing, sure, use them on your
> code.  But please, not for general use!
> 
> John

Linus sometimes argued against BUG_ON and people are repeating it after 
him like sheep.

If a programmer made a bug in his code, he should fix that bug, not write 
additional recovery code for the bug.

Mikulas
