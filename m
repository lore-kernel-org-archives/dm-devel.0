From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-integrity: fix inefficient allocation of stack
	space
Date: Thu, 20 Jul 2017 07:25:33 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707200703460.32226@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
	<22895.42876.199753.299282@quad.stoffel.home>
	<20170719190230.GC20480@redhat.com>
	<22895.51753.260996.643914@quad.stoffel.home>
	<alpine.LRH.2.02.1707200652080.32226@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1707200652080.32226@file01.intranet.prod.int.rdu2.redhat.com>
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



On Thu, 20 Jul 2017, Mikulas Patocka wrote:

> 
> 
> On Wed, 19 Jul 2017, John Stoffel wrote:
> 
> > I'd like to argue that you should never use BUG_ON at all, esp since
> > if you have integrity running on just one critical device, but have
> > other devices that work just fine, bringing down the entire system
> > because you don't think things are ok is terrible.
> > 
> > We should rip out ALL the BUG_ONs in the dm-integrity and just do
> > proper error handling instead.  For testing, sure, use them on your
> > code.  But please, not for general use!
> > 
> > John
> 
> Linus sometimes argued against BUG_ON and people are repeating it after 
> him like sheep.
> 
> If a programmer made a bug in his code, he should fix that bug, not write 
> additional recovery code for the bug.
> 
> Mikulas

For example, there a function access_journal_check that checks if journal 
section and offset are valid and calls BUG if they're not.

Now, suppose that we change BUG() to WARN() - now we need to return error 
code from the function. So we change the return value from void to int.

But this function is called by three other functions - page_list_location, 
access_journal_entry, access_journal_data - and now we need to test the 
error code in all of them.

page_list_location returns void, so it needs to be changed to return an 
error code too. access_journal_entry and access_journal_data return a 
pointer, so we change them to return NULL on error - but that NULL needs 
to be checked in the callers.

There are 11 callers of access_journal_entry and 5 calleds of 
access_journal_data and 5 callers of page_list_location.

And now you can see that changing a single BUG to WARN adds excessive 
amount of junk code that checks for "impossible" conditions. These extra 
tests do not make the code any more readable or understandable - they make 
it less readable because the programmer no longer knows what checks are 
really needed and what are not.


In the early days when I was programming, I was adding checks for NULL 
pointers "just in case - so that it doesn't crash". But these checks 
didn't make the code any more understandable - they made the code less 
understandable - because if a function return value is checked for NULL, 
the programmer believes that the function could return NULL. And the 
programmer no longer knows what is the contract of the function - could 
the function really return NULL or not?

Mikulas
