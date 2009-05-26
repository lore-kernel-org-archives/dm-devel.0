From: Neil Brown <neilb@suse.de>
Subject: Re: raid failure and LVM volume group availability
Date: Tue, 26 May 2009 21:56:50 +1000
Message-ID: <18971.55554.63887.457689@notabene.brown>
References: <alpine.DEB.2.00.0905211232250.26077@dirac.rather.puzzling.org>
	<389deec70905250909h79c599b2gfd2229520f5a8ce0@mail.gmail.com>
	<87ws84nmy0.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Tuesday May 26
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: hank peng <pengxihan@gmail.com>, Tim Connors <tconnors@rather.puzzling.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tuesday May 26, goswin-v-b@web.de wrote:
> hank peng <pengxihan@gmail.com> writes:
> 
> > Only one of disks in this RAID1failed, it should continue to work with
> > degraded state.
> > Why LVM complained with I/O errors??
> 
> That is because the last drive in a raid1 can not fail:
> 
> md9 : active raid1 ram1[1] ram0[2](F)
>       65472 blocks [2/1] [_U]
> 
> # mdadm --fail /dev/md9 /dev/ram1
> mdadm: set /dev/ram1 faulty in /dev/md9
> 
> md9 : active raid1 ram1[1] ram0[2](F)
>       65472 blocks [2/1] [_U]
> 
> See, still marked working.
> 
> MfG
>         Goswin
> 
> PS: Why doesn't mdadm or kernel give a message about not failing?

-ENOPATCH :-)

You would want to rate limit any such message from the kernel, but it
might make sense to have it.

NeilBrown
