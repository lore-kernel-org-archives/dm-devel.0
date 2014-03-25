From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [dm-devel] [PATCH RFC v1 00/01] dm-lightnvm introduction
Date: Tue, 25 Mar 2014 18:23:34 +0100
Message-ID: <CAFLxGvynL7s5ZuLYCyLaa0HZhsVugGfiSpaUJHg4rkdm=6gFFw@mail.gmail.com>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
	<20140321090630.GA30044@debian>
	<532C5930.7040107@bjorling.me>
	<alpine.DEB.2.02.1403242004580.527@nftneq.ynat.uz>
	<5330FE66.4080908@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5330FE66.4080908@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Matias Bjorling <m@bjorling.me>
Cc: David Lang <david@lang.hm>, device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com, agk@redhat.com, NeilBrown <neilb@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Mar 25, 2014 at 4:56 AM, Matias Bjorling <m@bjorling.me> wrote:
> On 03/24/2014 08:08 PM, David Lang wrote:
>> On Fri, 21 Mar 2014, Matias Bjorling wrote:
>>
>>> On 03/21/2014 02:06 AM, Joe Thornber wrote:
>>>> Hi Matias,
>>>>
>>>> This looks really interesting and I'd love to get involved.  Do you
>>>> have any recommendations for what hardware I should pick up?
>>>
>>> Hi Joe,
>>>
>>> The most easily available platform is OpenSSD
>>> (http://www.openssd-project.org). It's a little old, but still very
>>> functional. When there's a good firmware implementation, I think it will
>>> be easier for the custom SSD vendor's to jump on board with their own
>>> firmware.
>>
>> Is this something that would make sense to use for accessing the NAND
>> flash that's being used on routers nowdays? Talking with the OpenWRT
>> folks, they are having trouble supporting those devices because the
>> flash may contain defects and squashfs doesn't work in such an
>> environment. This appears to be the one remaining problem preventing a
>> lot of new routers from working.
>>
>> If this can work as a shim layer between the hardware and the filesystem
>> for OpenWRT, you would gain a very large userbase rather quickly.
>
> It's possible and would make sense. However, I'm not sure that its the
> best choice.
>
> From what I can see, OpenWRT routers expose their flash through mtd.
> Couldn't UBIFS be a better choice for this, instead of squashfs?

Using ubiblock you can also run squashfs ontop of UBI.
Hopefully it will be merged in 3.15.

-- 
Thanks,
//richard
