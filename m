From: San Mehat <san@google.com>
Subject: Re: [PATCH] md: dm-crypt: Add option to re-use a new
	global work-queue.
Date: Tue, 27 Apr 2010 13:58:38 -0700
Message-ID: <x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
References: <1271958538-11193-1-git-send-email-san@google.com>
	<4BD08F78.4000701@redhat.com>
	<q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
	<4BD099DB.2020108@redhat.com>
	<s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Brian Swetland <swetland@google.com>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

*ping* Any word on my previous counter-proposal? Shall I prepare
another patch for consideration?

-san


On Thu, Apr 22, 2010 at 12:42 PM, San Mehat <san@google.com> wrote:
> On Thu, Apr 22, 2010 at 11:47 AM, Milan Broz <mbroz@redhat.com> wrote:
>> On 04/22/2010 08:08 PM, San Mehat wrote:
>>> On Thu, Apr 22, 2010 at 11:03 AM, Milan Broz <mbroz@redhat.com> wrote:
>>>> On 04/22/2010 07:48 PM, San Mehat wrote:
>>>>> Typically, dm-crypt instances each have their own set of kcrypt/kcryp=
t_io
>>>>> work-queues. This patch adds an option which will create one set of
>>>>> work-queues on init, and re-uses them for all dm-crypt target instanc=
es.
>>
>>>> Can you explain the real reason for this patch?
>>>>
>>>
>>> Sure, I'd be happy to explain.
>>
>> (Please add this always to patch header.)
>>
>
> Will do - thanks.
>
>>>
>>> =A0 Upcoming versions of android are about to start using dm/dm-crypt
>>> heavily, having
>>> a large number of small dm-crypt instances running on the device (hard
>>> to tell just
>>> how many, but i've seen cases where up to 50 or 60 instances may be
>>> running). This ends up creating 100 - 120 kernel threads, and I was
>>> simply trying to cut that down.
>>
>> Sorry, but I don't take this argument. "Too many notes!" :-)
>>
>> So the problem is with memory allocation? Scheduler? Or where?
>> Kernel threads should be cheap.
>>
>
> Well the initial consideration was towards memory overhead with so
> many threads that don't do much (in our use-case) on an embedded
> device.
>
>> If you need 60 crypt devices, you almost surely hit at least starvation
>> problem with one global queue!
>> (Just curious - what are these crypt devices doing?)
>
> The crypt devices are providing small read-only encrypted file-systems
> - whose backing files exist on an external FAT file-system, and are
> created on-demand as needed. In this usage scenario, we'll only see
> typically a few of these devices being simultaneously accessed, (and
> the sd-card throughput is definitely the long-pole in the performance
> profile, so even when I beat on 80 or 90 concurrent instances, we're
> mainly waiting for mmcqd to complete transactions).
>
>>
>>> I'd be more than happy to discuss alternatives; but do we *really*
>>> need 2 work-queue threads per instance?
>>
>> yes.
>
> What if we made a note in the Kconfig advising against using the option in
> stacked configurations? (Or even make it depend on CONFIG_EMBEDDED)
>
> Thanks for your time,
>
> -san
>
>>
>> For separate io queue - see commit cabf08e4d3d1181d7c408edae97fb4d1c3151=
8af
>>
>> | Add post-processing queue (per crypt device) for read operations.
>>
>> | Current implementation uses only one queue for all operations
>> | and this can lead to starvation caused by many requests waiting
>> | for memory allocation. But the needed memory-releasing operation
>> | is queued after these requests (in the same queue).
>>
>>
>> (and there were another problem with async crypt - callback is called
>> in interrupt context, bio must be submitted from separate workqueue IIRC)
>>
>>>> (cc: Alasdair - I think he will not accept the patch anyway.)
>>>
>>> Probably not, but at least we can get the discussion going :)
>>
>> I am not saying that I do not want to discuss this - but we must know
>> the real problems many queues are causing first.
>> And then think about possible solutions.
>>
>> Milan
>>
>
>
>
> --
> San Mehat =A0| =A0Staff Software Engineer =A0| =A0Android =A0| =A0Google =
Inc.
> 415.366.6172 (san@google.com)
>



-- =

San Mehat =A0| =A0Staff Software Engineer =A0| =A0Android =A0| =A0Google In=
c.
415.366.6172 (san@google.com)
