From: Dennis Yang <shinrairis@gmail.com>
Subject: Re: kernel BUG at
	drivers/md/persistent-data/dm-btree-remove.c:182!
Date: Tue, 20 Oct 2015 10:39:31 +0800
Message-ID: <CAKTMprPVpRH6jktgPQ=f9Ak3XO8wg50oNqr8o-1UXTd=_9u0SA@mail.gmail.com>
References: <5624B4B8.1030404@siteground.com> <5624B505.6000406@siteground.com>
	<20151019103057.GA14688@rh-vpn> <5624C9CB.7000702@siteground.com>
	<20151019160230.GA23826@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151019160230.GA23826@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: SiteGround Operations <operations@siteground.com>, Nikolay Borisov <n.borisov@siteground.com>, thornber@redhat.com
List-Id: dm-devel.ids

Hi,

After I analyzed the metadata of this case couple months ago, I find
out that there is another possible bug which might trigger this
assertion fail in shift(). I had posted a patch two months ago on the
list to explain and fix this issue. Could you help reviewing this?

https://www.redhat.com/archives/dm-devel/2015-August/msg00155.html

Thanks,
Dennis

2015-10-20 0:02 GMT+08:00 Mike Snitzer <snitzer@redhat.com>:
> On Mon, Oct 19 2015 at  6:45am -0400,
> Nikolay Borisov <n.borisov@siteground.com> wrote:
>
>>
>>
>> On 10/19/2015 01:30 PM, Joe Thornber wrote:
>> > On Mon, Oct 19, 2015 at 12:16:53PM +0300, Nikolay Borisov wrote:
>> >> [Resending as I had typo in the dm-devel's mailing list the first time]
>> >>
>> >> Hello,
>> >>
>> >> Using kernel 3.12.47 I've hit the aforementioned issue. I'd also like
>> >> to say that this kernel does include Dennis Yang's patch which
>> >> supposedly fixes a similar issue
>> >> (https://www.redhat.com/archives/dm-devel/2015-May/msg00113.html).
>> >
>> >
>> > Did you apply this patch or my corrected patch?
>> >
>> > https://www.redhat.com/archives/dm-devel/2015-May/msg00123.html
>>
>> I haven't applied anything per-se, rather this stable kernel does
>> include your corrected patch. So yes, the correct fix for the issue
>> reported by Dennis is included, yet apparently the same issue is
>> manifesting again.
>
> Are you using metadata snapshots at all?
> Do you have this commit applied?
>
> b0dc3c8bc15 ("dm btree: add ref counting ops for the leaves of top level btrees")
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
