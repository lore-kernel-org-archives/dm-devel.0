From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: LUKS on a jffs2 partition
Date: Fri, 01 Aug 2014 11:26:03 +0200
Message-ID: <53DB5D2B.5020507@gmail.com>
References: <1405636940.30842.YahooMailNeo@web140602.mail.bf1.yahoo.com>
 <53C90676.2060501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <53C90676.2060501-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: Joe Dougherty <jopado1-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>, "dm-crypt-4q3lyFh4P1g@public.gmane.org" <dm-crypt-4q3lyFh4P1g@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On 07/18/2014 01:35 PM, Milan Broz wrote:
> On 07/18/2014 12:42 AM, Joe Dougherty wrote:
>> I have a small embedded device with a raw nand flash using jffs2
>> filesystem. I want to create a luks container on one of the jffs2
>> partitions. Everything seems to work fine until I try to mount the
>> file system and I receive the error shown below. Here are the
>> commands I used to set this up:
>>     cryptsetup luksFormat /dev/mtdblock4 --cipher=aes-cbc-essiv:sha256
>>     cryptsetup luksOpen /dev/mtdblock4 efs
>> At this point I can perform luksDump and all looks OK and the /dev/mapper/efs exists. So I continue to create filesystem:
>>     mkfs.jffs2  -p -l --eraseblock=0x20000 --no-cleanmarkers --pagesize=0x800 -r ./userdata -o /dev/mapper/efs
>> Now the mount fails:
>>     mount -o loud -t jffs2 /dev/mapper/efs /mnt
>>     MTD: Attempt to mount non-MTD device "/dev/mapper/efs"
>>     mount: mounting /dev/mapper/efs on /mnt failed: Invalid argument

Interesting nobody from embedded world replied here to the obvious problem
which lies in confusion between MTD (memory technology device) and block devices :)

So how (I understand) it works and what is the workaround for these cases:

The jffs2 (and probably other MTD based filesystems) *requires* MTD device parameter to mount.
 
The /dev/mtdblock* device is created as simulated block device access to underlying MTD device.

Note there is a *hack* in kernel, which allows to mount mtdblock device directly as MTD device,
(it uses underlying device directly - see drivers/mtd/mtdsuper.c for this wonderful magic).

Obviously, if we add another translation layer (dmcrypt or whatever), underlying device
is not an MTD device and this hack fails.

Workaround is to add yet another layer, which simulates new MTD device again on top
of device-mapper stack.

For your example you can do it this way (you need to probably set erase block size
as parameter too):

# modprobe block2mtd block2mtd=/dev/mapper/efs

and the mount newly appeared mtdblock device instead:

# mount -o loud -t jffs2 /dev/mtdblockX /mnt

(I see a lot of kernel warnings here but that's another story.)

Hope this helps.

Milan
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
