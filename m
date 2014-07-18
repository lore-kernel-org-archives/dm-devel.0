From: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: LUKS on a jffs2 partition
Date: Fri, 18 Jul 2014 13:35:18 +0200
Message-ID: <53C90676.2060501@gmail.com>
References: <1405636940.30842.YahooMailNeo@web140602.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <1405636940.30842.YahooMailNeo-mhNdJOJujDYR8UyDmTZ/NZEhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
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

On 07/18/2014 12:42 AM, Joe Dougherty wrote:
> I have a small embedded device with a raw nand flash using jffs2
> filesystem. I want to create a luks container on one of the jffs2
> partitions. Everything seems to work fine until I try to mount the
> file system and I receive the error shown below. Here are the
> commands I used to set this up:
>     cryptsetup luksFormat /dev/mtdblock4 --cipher=aes-cbc-essiv:sha256
>     cryptsetup luksOpen /dev/mtdblock4 efs
> At this point I can perform luksDump and all looks OK and the /dev/mapper/efs exists. So I continue to create filesystem:
>     mkfs.jffs2  -p -l --eraseblock=0x20000 --no-cleanmarkers --pagesize=0x800 -r ./userdata -o /dev/mapper/efs
> Now the mount fails:
>     mount -o loud -t jffs2 /dev/mapper/efs /mnt
>     MTD: Attempt to mount non-MTD device "/dev/mapper/efs"
>     mount: mounting /dev/mapper/efs on /mnt failed: Invalid argument
> 
> I have used similar commands successfully for non-jffs2 filesystems. Is this possible with jffs2? Any help appreciated.
> Here's some additional version info:
> cryptsetup --version
> cryptsetup 1.6.2
> dmsetup --version
> Library version:   1.02.76 (2012-08-07)
> Driver version:    4.20.0
> uname -a
> Linux m-1138 3.0.15+m-1138+gecbbdf0 #1 Tue Jul 8 08:57:12 MST 2014 armv7l GNU/Linux

As you already found, there is a similar bug report
https://code.google.com/p/cryptsetup/issues/detail?id=203

In this case it is almost for sure kernel bug, so maybe reporting it
to appropriate kernel list (perhaps jffs related) would be better.
(Adding dm-devel, maybe someone could help as well.)

Milan
_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
