From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid failure and LVM volume group availability
Date: Mon, 25 May 2009 14:15:28 +0200
Message-ID: <87vdnpqsyn.fsf@frosties.localdomain>
References: <alpine.DEB.2.00.0905211232250.26077@dirac.rather.puzzling.org>
	<7df2bc4ce840fbfa8d2bec357069bc5a.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7df2bc4ce840fbfa8d2bec357069bc5a.squirrel@neil.brown.name>
	(NeilBrown's message of "Thu, 21 May 2009 13:55:03 +1000 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tim Connors <tconnors@rather.puzzling.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

"NeilBrown" <neilb@suse.de> writes:

> On Thu, May 21, 2009 1:07 pm, Tim Connors wrote:
>> Is it possible to force both lvm and md to give up on the device so I can
>> readd them without rebooting (since they're not going to be anymore
>> corrupt yet than you'd expect from an unclean shutdown, because there's
>> been no IO to them yet, so I should just be able to readd them, mount and
>> resync)?
>
> For the md side, you can just assemble the drives into an array with
> a different name.
> e.g.
>   mdadm -A /dev/md1 /dev/sda1 /dev/sd....
>
> using whatever new names were given to the devices when you plugged them
> back in.
> Maybe you can do a similar thing with the LVM side, but I know nothing
> about that.
>
> NeilBrown

On the device mapper side (the thing below lvm) you can use dmsetup to
suspend, alter and resume the device mapper table of your
devices. That should make the actual filesysems happy again.

Not sure what LVM tools will make of that though.

MfG
        Goswin
