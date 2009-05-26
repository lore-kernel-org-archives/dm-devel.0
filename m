From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid failure and LVM volume group availability
Date: Tue, 26 May 2009 13:05:59 +0200
Message-ID: <87ws84nmy0.fsf@frosties.localdomain>
References: <alpine.DEB.2.00.0905211232250.26077@dirac.rather.puzzling.org>
	<389deec70905250909h79c599b2gfd2229520f5a8ce0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec70905250909h79c599b2gfd2229520f5a8ce0@mail.gmail.com>
	(hank peng's message of "Tue, 26 May 2009 00:09:25 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: Tim Connors <tconnors@rather.puzzling.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

hank peng <pengxihan@gmail.com> writes:

> Only one of disks in this RAID1failed, it should continue to work with
> degraded state.
> Why LVM complained with I/O errors??

That is because the last drive in a raid1 can not fail:

md9 : active raid1 ram1[1] ram0[2](F)
      65472 blocks [2/1] [_U]

# mdadm --fail /dev/md9 /dev/ram1
mdadm: set /dev/ram1 faulty in /dev/md9

md9 : active raid1 ram1[1] ram0[2](F)
      65472 blocks [2/1] [_U]

See, still marked working.

MfG
        Goswin

PS: Why doesn't mdadm or kernel give a message about not failing?
