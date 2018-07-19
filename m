From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Thu, 19 Jul 2018 09:46:04 +0800
Message-ID: <cda1d3de-3f21-2dfc-0423-c1cf456838b4@huawei.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
 <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
 <b6eaf471-7279-ca4f-bb7c-d25df8db2419@gmail.com>
 <20180718164625.GA20360@sirena.org.uk>
 <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <82248c13-42fe-b598-0cd7-68e5db0b51be@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: agk@redhat.com, snitzer@redhat.com, herbert@gondor.apana.org.au, dm-devel@redhat.com, linux-kernel@vger.kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com
List-Id: dm-devel.ids

Hi,

On 2018/7/19 1:17, Milan Broz wrote:
> On 18/07/18 18:46, Mark Brown wrote:
>> On Wed, Jul 18, 2018 at 10:16:05AM +0200, Milan Broz wrote:
>>
>>> So we are here again and moving INTERNAL dm-crypt functionality into
>>> cryptoapi.

> (namely TCW and LMK) do much more that IV - they modify encryption mode.
> This was a hack to support some FDE encryption modes (old Truecrypt and loopAES)
> and that should not spread outside dm-crypt (and blame me for this code hacks :).
> 
> 2) If the reason is performance, please provide numbers with the patch.
> What I see now is that the performance is almost the same. So why you are doing it?
> Any real hw that benefits from it?

I add IV templates, such as 'plain()',  'benbi()'
When applying it to the existing algorithm, such as 'aes-cbc', and so on,
it generates new algorithm 'aes-cbc-plain', 'aes-cbc-benbi.
This patch modify the dm-crypt to rely on the new algorithm 'aes-cbc-benbi'.
Dm-crypt passes the whole 'bio' to 'aes-cbc-benbi', rather than divide
the bio into sectors, and alternatively pass each sector to 'aes-cbc'.

Because the internal implementation of the IV template 'benbi()' is still
dividing the whole bio into sectors, so the performance is almost the same.
The purpose of this patch is to let dm-crypt rely on the new algorithm 'aes-cbc-benbi'
and pass the whole bio to the new algorithm.
And then if the hardware driver implements this new algorithm, it can get the data of
the bio at one time, and return the processed data at one time.
I think it will decrease the overhead of passing each sector alternatively.
But the hardware need to implement the new algorithm if it want to benefit from this.

Thanks,
Xiongfeng
> 
> I added 4k sector support in dmcrypt and IMO this helps much more
> than some hw IV accelerations (AFAIK is is already used in some mainframe
> accelerators this way because of performance).
> 
> Milan
> 
> 
