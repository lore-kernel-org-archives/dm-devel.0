From: Wilfried Weissmann <Wilfried.Weissmann@gmx.at>
Subject: Re: Re: grub 0.96 bug
Date: Mon, 21 Mar 2005 19:16:20 +0100
Message-ID: <423F0F74.3030007@gmx.at>
References: <62b0912f05031606396a3a47db@mail.gmail.com>	<20050318125120.GQ3301@redhat.com>	<62b0912f0503181112ea853a6@mail.gmail.com>	<62b0912f050318142923419b20@mail.gmail.com>	<62b0912f05031914513909bcfb@mail.gmail.com>	<62b0912f050319145547c4a7db@mail.gmail.com>	<20050320163001.GB643@percy.comedia.it>	<62b0912f05032019262c009465@mail.gmail.com>	<62b0912f0503202121607bd38a@mail.gmail.com>	<62b0912f05032104052e78fd60@mail.gmail.com>
	<62b0912f050321065558fc956@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <62b0912f050321065558fc956@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Molle Bestefich <molle.bestefich@gmail.com>, device-mapper development <dm-devel@redhat.com>
Cc: bug-grub@gnu.org
List-Id: dm-devel.ids

> Chris Nicola wrote:
>> Yes I am having the exact same problem.  I am actually just going to try
>> and lower version of grub for now but I will try this patch if that
>> still happens.
> 
> Just did this:
> ==========
> grub> device (hd0) /dev/mapper/hpt37x_ehgjaggaf
> grub> root (hd0,5)/boot
> Filesystem type is reiserfs, partition type 0x83
> grub> setup (hd0)
> ==========
> 
> and it destroyed my RAID0.
> GRUB is such a piece of crap :-).
> 
> It must be severely broken; since if it just sticked to writing to the
> device I pointed it at (hpt37x_ehgjaggaf) which is a RAID0 "virtual
> disk" / whatever, it should never be able to overwrite metadata out on
> the physical disk.

HPT desided to make the metadata accessable from the virtual disk. Just 
look at sector 9 of a working array and enjoy the show...
Grub is fine. At least the version that I am using. You have to do some 
tricks to get grub running on the old hpt controllers (I think the new 
ones are better, but I cannot tell for sure).

Just copy the stage 1.5 reiserfs module to sector 16 instead of sector 8 
which is the grub default that destroys the metadata in case of a hpt.

# dd if=/boot/grub/reiserfs_stage1_5 of=/dev/mapper/hpt37x_cjafdedchg 
seek=16 conv=sync

Then do the following in grub:

grub> root (hd0,1)
grub> geometry (hd0) 9964 255 63
grub> install --stage2=/boot/grub/stage2 /boot/grub/stage1 (hd0) 
(hd0)16+18 (hd0,1)/boot/grub/stage2 (hd0,1)/boot/grub/menu.lst

You have to use the correct geometry for your harddisk and your (hd...) 
values. The "(hd0)16+18" parameter of the "install" command tells grub 
where to find the stage 1.5 loader. "(hd0)" is the disk. "16" is the 
offset of the sector where the module is located and "+18" is the size 
in sectors of the module. Your size may vary. And do not forget that you 
have to round up to the next full sector.

> 
> Anyway, just wanted to tell you to beware.
> Gerte has a GRUB example on his page where he does setup (hd0,5)
> instead of setup (hd0), perhaps that's how it's meant to work.
> 

But you still need a MBR that invokes the loader in (hd0,5) then!

Greetings,
Wilfried
