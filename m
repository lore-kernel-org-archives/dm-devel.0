From: "BK, GirishKumar" <GirishKumar.BK@netapp.com>
Subject: Re: DM-Delay
Date: Wed, 28 Jan 2015 07:11:09 +0000
Message-ID: <D0EE88C7.10C34%GirishKumar.BK@netapp.com>
References: <CAE6Xt1tC7ifisESxLiQaRnJtY9puB8TwJaNv_05=EyVLnx1idQ@mail.gmail.com>
	<CAFTzLMOthP-P=XYQ9kpmCCAg2c61iaX1Qi69=wW2YNisM7yVyg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFTzLMOthP-P=XYQ9kpmCCAg2c61iaX1Qi69=wW2YNisM7yVyg@mail.gmail.com>
Content-Language: en-US
Content-ID: <478E4314F4C7484F8DF78F0B5D9613B9@hq.netapp.com>
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
List-Id: dm-devel.ids

Hi Vasily,

It would great if you could point us to your sample code which uses
high-res timers.
We hope to add delays in the range of 20 - 500 u sec in dm-cache path.

Thanks,
/Girish BK


On 1/22/15, 8:42 PM, "Vasily Tarasov" <tarasov@vasily.name> wrote:

>Hi Sourav,
>
>Delay target provides uniform latency with 1ms granularity. You can
>specify different latency for reads or writes. No matter what is the
>size of the request or the number of requests submitted - the delay
>will remain the same.
>
>To change granularity to microseconds the code need to be modified to
>use high-res timers (instead of regular Linux timers). It is
>relatively straight forward modification,  I did it once and have a
>patch somewhere. Let me see if I can find it.
>
>HTH,
>Vasily
>
>On Wed, Jan 21, 2015 at 12:15 PM, Sourav Basu <sourav.juit@gmail.com>
>wrote:
>> Hello,
>>    I have few questions regarding dm-delay component.
>> 1. Why type of emulations is targeted while implementation of dm-delay?
>>  2. Is the delay uniform across different i/o going to the device?
>>  3. Can the granularity of be reduced from mili-sec to tens of
>>micro-sec? If
>> so how?
>>
>> My aim is to emulate ssd devices latency varying from 10us to 100ms on
>> ramdisk using dm-delay.
>>
>> Regards,
>> Sourav
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
