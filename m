From: "John Stoffel" <john@stoffel.org>
Subject: Re: dm-integrity: fix inefficient allocation of stack
	space
Date: Thu, 20 Jul 2017 11:46:34 -0400
Message-ID: <22896.53338.384584.365071@quad.stoffel.home>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, John Stoffel <john@stoffel.org>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> On Wed, 19 Jul 2017, John Stoffel wrote:

>> I'd like to argue that you should never use BUG_ON at all, esp since
>> if you have integrity running on just one critical device, but have
>> other devices that work just fine, bringing down the entire system
>> because you don't think things are ok is terrible.
>> 
>> We should rip out ALL the BUG_ONs in the dm-integrity and just do
>> proper error handling instead.  For testing, sure, use them on your
>> code.  But please, not for general use!
>> 
>> John

Mikulas> Linus sometimes argued against BUG_ON and people are
Mikulas> repeating it after him like sheep.

I understand Linus' rants on BUG_ON and I agree with them.  He doesn't
argue that they're not appropriate at times, but just using them
because a random driver or module freaks out is NOT appropriate.  

Mikulas> If a programmer made a bug in his code, he should fix that
Mikulas> bug, not write additional recovery code for the bug.

If a programmer has a bug which kills the system for no damn good
reason, then I object.  Don't think that dm-integrity is oh so
important that you need to kill the system because of a mistake.

Try to be robust.  90% of all code is error handling.

John
