From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-integrity: fix inefficient allocation of stack
	space
Date: Fri, 21 Jul 2017 08:15:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707210808560.17010@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
	<22895.42876.199753.299282@quad.stoffel.home>
	<20170719190230.GC20480@redhat.com>
	<22895.51753.260996.643914@quad.stoffel.home>
	<alpine.LRH.2.02.1707200652080.32226@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1707200703460.32226@file01.intranet.prod.int.rdu2.redhat.com>
	<22896.56378.568488.989656@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22896.56378.568488.989656@quad.stoffel.home>
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



On Thu, 20 Jul 2017, John Stoffel wrote:

> Mikulas> In the early days when I was programming, I was adding checks for NULL 
> Mikulas> pointers "just in case - so that it doesn't crash". But these checks 
> Mikulas> didn't make the code any more understandable - they made the code less 
> Mikulas> understandable - because if a function return value is checked for NULL, 
> Mikulas> the programmer believes that the function could return NULL. And the 
> Mikulas> programmer no longer knows what is the contract of the function - could 
> Mikulas> the function really return NULL or not?
> 
> In this case, maybe it would make more sense to clamp the values to
> the maximums in case they do exceed their limits?  The check is
> simply:
> 
>     if (unlikely(section >= ic->journal_sections) ||
> 	 unlikely(offset >= limit)) {
> 
> So I'm arguing that when you set the section or offset, shouldn't they
> be clamped to their limits there?
> 
> Thanks for your time,
> John

Returning invalid data is directly against the purpose of the dm-integrity 
target.

If you think that clamping array indices that are out of range improves 
software reliability - so write some program that uses this technique and 
we will see how reliable or unreliable it is. You can persuade people by 
writing software, you can't persuade them by preaching what should they 
do.

Mikulas
