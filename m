From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid failure and LVM volume group availability
Date: Thu, 28 May 2009 20:48:10 +0200
Message-ID: <87skipysgl.fsf@frosties.localdomain>
References: <alpine.DEB.2.00.0905211232250.26077@dirac.rather.puzzling.org>
	<389deec70905250909h79c599b2gfd2229520f5a8ce0@mail.gmail.com>
	<87ws84nmy0.fsf@frosties.localdomain>
	<18971.55554.63887.457689@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18971.55554.63887.457689@notabene.brown> (Neil Brown's message
	of "Tue, 26 May 2009 21:56:50 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, hank peng <pengxihan@gmail.com>, Tim Connors <tconnors@rather.puzzling.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Neil Brown <neilb@suse.de> writes:

> On Tuesday May 26, goswin-v-b@web.de wrote:
>> hank peng <pengxihan@gmail.com> writes:
>> 
>> > Only one of disks in this RAID1failed, it should continue to work with
>> > degraded state.
>> > Why LVM complained with I/O errors??
>> 
>> That is because the last drive in a raid1 can not fail:
>> 
>> md9 : active raid1 ram1[1] ram0[2](F)
>>       65472 blocks [2/1] [_U]
>> 
>> # mdadm --fail /dev/md9 /dev/ram1
>> mdadm: set /dev/ram1 faulty in /dev/md9
>> 
>> md9 : active raid1 ram1[1] ram0[2](F)
>>       65472 blocks [2/1] [_U]
>> 
>> See, still marked working.
>> 
>> MfG
>>         Goswin
>> 
>> PS: Why doesn't mdadm or kernel give a message about not failing?
>
> -ENOPATCH :-)
>
> You would want to rate limit any such message from the kernel, but it
> might make sense to have it.
>
> NeilBrown

No rate risk in mdadm --fail reporting a failure to fail the device.

MfG
        Goswin
