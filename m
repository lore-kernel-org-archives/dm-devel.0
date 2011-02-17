From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Thu, 17 Feb 2011 08:29:57 +0100
Message-ID: <4D5CCE75.5090202@suse.de>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C2793.1020601@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
In-Reply-To: <4D5C2793.1020601-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
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
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org, Debian LVM Team <pkg-lvm-maintainers-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Id: dm-devel.ids

On 02/16/2011 08:37 PM, Phillip Susi wrote:
> On 2/16/2011 2:38 AM, Hannes Reinecke wrote:
>> The linux scheme since the dawn of time is to
>> a) Add the partition number to the device node name
>> b) If last letter of the device node name is a number, insert a 'p'
>> between device node name and partition number
> =

> Since the dawn of time?  Before device mapper it wasn't possible to have
> a disk device name ending in a digit.
> =

Unless you happen to have a raid HBA, which has names like

cciss/c0d0

or

rd/c0d0

and, of course, you can have partitions on md devices, too, which
will also give you names like
md0p1

>> with the advent of persistent device names (via udev) the partition
>> separator (for persistent links only!) is '-part'.
>>
>> So you have
>>
>> /dev/sda
>> /dev/sda1
>> /dev/disk/by-id/scsi-0WhatAStupidName
>> /dev/disk/by-id/scsi-0WhatAStupidName-part1
>>
>> persistent device names are longish anyway, so we can as well use
>> something readable for partitions.
> =

> That's fine for the symlinks in by-id, but what about the names in
> /dev/mapper and /dev/VG?
> =

/dev/mapper contains the names of the device-mapper devices
themselves; for those I don't have any preference.
kpartx as called from udev is using the '-part' suffix here, too.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
