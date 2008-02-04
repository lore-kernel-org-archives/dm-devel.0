From: Igor M Podlesny <for.poige+linux@gmail.com>
Subject: > Please do (at a minimum)
Date: Mon, 04 Feb 2008 23:07:50 +0700
Message-ID: <47A73856.3070806@gmail.com>
References: <43d009740802020227u187576a0s3931a24107e847ae@mail.gmail.com>
	<43d009740802031020j6b9fdcdfj1573d7758d75284e@mail.gmail.com>
	<alpine.LFD.1.00.0802040746380.7554@hp.linux-foundation.org>
Reply-To: for.poige+linux@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LFD.1.00.0802040746380.7554@hp.linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 2008-02-04 22:49, Linus Torvalds wrote:
> 
> On Mon, 4 Feb 2008, Igor wrote:
>> 
>> ... and found out that it doesn't "see" my LVM-2's devices. Which way to bug
>> report it would be the best one -- http://bugzilla.kernel.org/ or what?
>> 
>>    Are more details required or this would be enough?
> 
> Please do (at a minimum)
>  - describe when it worked and when it broke (ie does -git10 work for you, 
>    and -git11 breaks?)
>  - describe differences in dmesg in working/non-working setup.
>  - and shortly describe your setup
> 
> because the "it doesn't work" thing doesn't tell anybody much of 
> anything ;)

	I didn't say plain (or blank) "it didn't work", nope. "Doesn't see" is
something better, but anyway since the same problem happens with
2.6.24-mm1 as well, I have reported it to its mail list. I was given
just a bit better advice/hint there, so I think I'm closer to the
solution. Speaking shorter, probably I should had updated my own
home-made initrd before writing to anybody at all! Sorry! :-)

	P. S. Honestly I was such in a hurry just because it seemed to me that
it's quite reasonable that something was recently broken on kernel's way
from 2.6.24 to -git11, and rather unlikely it was caused by anything
else. :-) Assumption is the mother of all f*ckups, I know. ;-)

-- 
End of message. Next message?
