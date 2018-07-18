From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Wed, 18 Jul 2018 19:17:45 +0200
Message-ID: <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
 <20180718164625.GA20360@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718164625.GA20360@sirena.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>, agk@redhat.com, snitzer@redhat.com, herbert@gondor.apana.org.au, dm-devel@redhat.com, linux-kernel@vger.kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com
List-Id: dm-devel.ids

On 18/07/18 18:46, Mark Brown wrote:
> On Wed, Jul 18, 2018 at 10:16:05AM +0200, Milan Broz wrote:
> 
>> So we are here again and moving INTERNAL dm-crypt functionality into
>> cryptoapi.
> 
>> The TCW,LMK  IVs generator make sense only for dm-crypt 
>> for compatible old disk encryption mappings.
> 
>> I strongly disagree to move this outside of dm-crypt.
> 
>> Sorry, the last discussion was that it remains inside dm-crypt
>> and it will be only registered through crypto API.
> 
> Sorry, I'm partly to blame for this in that I asked Xiongfeng to pick up
> Binoy Jayan's old patch set.  I seem to have missed that particular part
> of the discussion and so haven't forwarded it on to him - do you have a
> link, I can't seem to see it in my local archives of the prior
> discussions but they might not be complete?

I think the last iteration was this patch
https://lore.kernel.org/lkml/1498106510-19793-2-git-send-email-binoy.jayan@linaro.org/

But I have still some questions, because I really do not understand
the real reason for this patchset.
For now, it adds a lot of complexity for ... what?

1) If the reason is to make cryptoapi to include IV algorithms, I think we should
focus on universal algorithms (sequential aka plain64 in dmcrypt) as used
in XTS mode. ESSIV is intended for CBC mode only and I think general
consensus today is that XTS mode is preferred to CBC (despite it known problems).
But I see ESSIV used elsewhere, so maybe it makes sense to export this one as well.

But definitely not other internal IVs - some IV generators inside dm-crypt
(namely TCW and LMK) do much more that IV - they modify encryption mode.
This was a hack to support some FDE encryption modes (old Truecrypt and loopAES)
and that should not spread outside dm-crypt (and blame me for this code hacks :).

2) If the reason is performance, please provide numbers with the patch.
What I see now is that the performance is almost the same. So why you are doing it?
Any real hw that benefits from it?

I added 4k sector support in dmcrypt and IMO this helps much more
than some hw IV accelerations (AFAIK is is already used in some mainframe
accelerators this way because of performance).

Milan
