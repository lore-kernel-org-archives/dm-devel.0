From: Curtis Gedak <gedakc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Wed, 16 Feb 2011 10:19:59 -0700
Message-ID: <4D5C073F.3020502@gmail.com>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
In-Reply-To: <4D5B7ED9.20304-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.alioth.debian.org/mailman/options/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.alioth.debian.org/pipermail/parted-devel>
List-Post: <mailto:parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Help: <mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=help>
List-Subscribe: <http://lists.alioth.debian.org/mailman/listinfo/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=subscribe>
Sender: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
Errors-To: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, Phillip Susi <psusi-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>, Debian LVM Team <pkg-lvm-maintainers-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Id: dm-devel.ids

On 11-02-16 12:38 AM, Hannes Reinecke wrote:
> On 02/16/2011 04:21 AM, Phillip Susi wrote:
>> It used to be that partitions device names just had a digit added on to
>> the base disk device name.  It seems that this became problematic at
>> some point with device mapper and oddly named disks, and there have been
>> several responses to it:
>>
>> 1)  dmraid and (lib)parted now always add a 'p' between the base name
>> and the partition number

Only newer versions of (lib)parted which link with the dmraid library 
work this way with dmraid devices.  In this situation it is the dmraid 
library that is coming up with the device names.  For all other devices, 
(lib)parted uses the "linux scheme since the dawn of time" mentioned 
below.  Older versions of (lib)parted follow the "linux scheme since the 
dawn of time".

>> 2)  kpartx from multipath-tools adds the 'p' only if the base name ends
>> in a digit

kpartx follows the "linux scheme since the dawn of time" mentioned below.

>> 4)  gparted now explicitly tells dmraid to not use any character so that
>> it behaves like older versions and is therefore compatible with the
>> kpartx method that gparted has adopted, at least when the base name does
>> not end with a digit.
>>

GParted uses (lib)parted to come up with device names, except in the 
case of dmraid devices.  Because dmraid does not follow the "linux 
scheme since the dawn of time", gparted calls dmraid directly to create 
names following the old dmraid standard (only append partition number to 
device name).  If kpartx is available, then GParted will call kpartx to 
ensure that dmraid device names follow the "linux scheme since the dawn 
of time".  This behaviour enables GParted to work with all versions of 
dmraid, and maintain compatibility with (lib)parted versions 1.7.1 and 
higher.

>> Each of these components needs to agree on what the correct name is or
>> chaos ensues.  I would like to discuss the merits of each and try to
>> decide on a standard.
>>
>> Having thought about it for a moment, it seems to me that deciding on
>> always adding the 'p' is the way to go, since the 'art' just makes
>> things longer for no good reason, and if you only sometimes add the 'p'
>> then you can't tell if a device name that ends in a digit that does not
>> follow a 'p' is a whole disk, or a partition.
>>
> No.
>
> The linux scheme since the dawn of time is to
> a) Add the partition number to the device node name
> b) If last letter of the device node name is a number, insert a 'p'
> between device node name and partition number
>
> with the advent of persistent device names (via udev) the partition
> separator (for persistent links only!) is '-part'.
>
> So you have
>
> /dev/sda
> /dev/sda1
> /dev/disk/by-id/scsi-0WhatAStupidName
> /dev/disk/by-id/scsi-0WhatAStupidName-part1
>
> persistent device names are longish anyway, so we can as well use
> something readable for partitions.
>
>

My thoughts are that if possible, tools should try to create partition 
names using the "linux scheme since the dawn of time", unless there are 
good reasons to not do this.

Regards,
Curtis Gedak
(Maintainer of GParted)
