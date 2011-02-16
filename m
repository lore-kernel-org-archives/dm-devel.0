From: Curtis Gedak <gedakc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Wed, 16 Feb 2011 13:18:47 -0700
Message-ID: <4D5C3127.7050304@gmail.com>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C073F.3020502@gmail.com> <4D5C268B.6070507@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
In-Reply-To: <4D5C268B.6070507-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.alioth.debian.org/mailman/options/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.alioth.debian.org/pipermail/parted-devel>
List-Post: <mailto:parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Help: <mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=help>
List-Subscribe: <http://lists.alioth.debian.org/mailman/listinfo/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=subscribe>
Sender: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
Errors-To: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
To: Phillip Susi <psusi-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Debian LVM Team <pkg-lvm-maintainers-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Id: dm-devel.ids

On 11-02-16 12:33 PM, Phillip Susi wrote:
> On 2/16/2011 12:19 PM, Curtis Gedak wrote:
>> Only newer versions of (lib)parted which link with the dmraid library
>> work this way with dmraid devices.  In this situation it is the dmraid
>> library that is coming up with the device names.  For all other devices,
>> (lib)parted uses the "linux scheme since the dawn of time" mentioned
>> below.  Older versions of (lib)parted follow the "linux scheme since the
>> dawn of time".
> (lib)parted does not link to dmraid; it contains its own code to
> generate the name by always adding the 'p' in libparted/arch/linux.c.

My bad.  (lib)parted does not link with dmraid.  It has been a while 
since I looked deeply into the libparted code.

I do know that the current version of parted in git has a 
"--enable-device-mapper" option for configure that is enabled by default.
http://git.debian.org/?p=parted/parted.git;a=blob;f=configure.ac;h=25960a74abe909f7b11580aa053c0689a966820d;hb=HEAD#l81

The function _device_get_part_path in libparted/arc/linux.c, does appear 
to always insert a 'p'  for devices such as PED_DEVICE_DM and 
PED_DEVICE_ATARAID.
http://git.debian.org/?p=parted/parted.git;a=blob;f=libparted/arch/linux.c;h=0288a150769298b92f06d96f8515f96bc27066ea;hb=HEAD#l2198


Regarding the GParted code, it has been written to will work with dmraid 
devices regardless of whether the "--enable-device-mapper" configure 
option is enabled or disabled.

>> GParted uses (lib)parted to come up with device names, except in the
>> case of dmraid devices.  Because dmraid does not follow the "linux
>> scheme since the dawn of time", gparted calls dmraid directly to create
>> names following the old dmraid standard (only append partition number to
>> device name).  If kpartx is available, then GParted will call kpartx to
>> ensure that dmraid device names follow the "linux scheme since the dawn
>> of time".  This behaviour enables GParted to work with all versions of
>> dmraid, and maintain compatibility with (lib)parted versions 1.7.1 and
>> higher.
> It shouldn't be using both dmraid and kpartx to create the partition
> devices.  If dmraid does it, then calling kpartx at best does nothing,
> and at worst creates duplicate devices.

It would be easy in GParted to not call kpartx at all.  This is in the 
code to try to follow the normal partition naming standards for GNU/Linux.
