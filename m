From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Wed, 05 Nov 2014 15:50:15 +0100
Message-ID: <545A3927.7010904@redhat.com>
References: <20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Dne 5.11.2014 v 15:37 Mikulas Patocka napsal(a):
>
>
> On Wed, 5 Nov 2014, Mike Snitzer wrote:
>
>> On Wed, Nov 05 2014 at  8:05am -0500,
>> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>>> On Wed, 5 Nov 2014, Mikulas Patocka wrote:
>>>
>>>> You can for example set the flag in the prison meaning that the prison is
>>>> suspended and then call dm_internal_suspend immediatelly followed by
>>>> dm_internal_resume - that will clear in-progress bios and prevent new bios
>>>> from coming in (and we don't need to change dm_internal_suspend and
>>>> dm_internal_resume to become so big).
>>
>> It may _seem_ like they have gotten big given the code was refactored to
>> share code with dm_suspend and dm_resume.  BUT I know you see that the
>> actual code complexity isn't big.  I especially wanted you (and/or Bryn)
>> to evaluate the performance implications that my changes had on
>> dm-stats.  I'm pretty confident there won't be much if any performance
>> difference (given the code is identical to what you had, except some
>> extra checks are made but ultimately not used, e.g. lockfs/unlockfs).
>
> This is not about performance, it is about unclear behavior.
>
> If someone does internal_suspend followed by remove, what should be the
> correct behavior? The current code deadlocks in this case.
>

yep - that would my concern as well.

If this 'internal' suspend is purely 'enforced' by incorrectly behaving user 
space part (aka lvm2 is not doing it's best) I assume it's better to fix
user space - instead of moving it into kernel with some side-effects.

Zdenek
