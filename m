From: Hannes Reinecke <hare@suse.de>
Subject: Re: What is the deal with the partition separator?
Date: Wed, 16 Feb 2011 08:38:01 +0100
Message-ID: <4D5B7ED9.20304@suse.de>
References: <4D5B42BE.3050301@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D5B42BE.3050301@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Curtis Gedak <gedakc@gmail.com>, parted-devel@lists.alioth.debian.org, serge.hallyn@ubuntu.com, Phillip Susi <psusi@cfl.rr.com>, Debian LVM Team <pkg-lvm-maintainers@lists.alioth.debian.org>
List-Id: dm-devel.ids

On 02/16/2011 04:21 AM, Phillip Susi wrote:
> It used to be that partitions device names just had a digit added on to
> the base disk device name.  It seems that this became problematic at
> some point with device mapper and oddly named disks, and there have been
> several responses to it:
> =

> 1)  dmraid and (lib)parted now always add a 'p' between the base name
> and the partition number
> =

> 2)  kpartx from multipath-tools adds the 'p' only if the base name ends
> in a digit
> =

> 3)  Debian and Ubuntu's udev and init scripts tell kpartx to use 'part'
> instead of just 'p'.
> =

> 4)  gparted now explicitly tells dmraid to not use any character so that
> it behaves like older versions and is therefore compatible with the
> kpartx method that gparted has adopted, at least when the base name does
> not end with a digit.
> =

> Each of these components needs to agree on what the correct name is or
> chaos ensues.  I would like to discuss the merits of each and try to
> decide on a standard.
> =

> Having thought about it for a moment, it seems to me that deciding on
> always adding the 'p' is the way to go, since the 'art' just makes
> things longer for no good reason, and if you only sometimes add the 'p'
> then you can't tell if a device name that ends in a digit that does not
> follow a 'p' is a whole disk, or a partition.
> =

No.

The linux scheme since the dawn of time is to
a) Add the partition number to the device node name
b) If last letter of the device node name is a number, insert a 'p'
between device node name and partition number

with the advent of persistent device names (via udev) the partition
separator (for persistent links only!) is '-part'.

So you have

/dev/sda
/dev/sda1
/dev/disk/by-id/scsi-0WhatAStupidName
/dev/disk/by-id/scsi-0WhatAStupidName-part1

persistent device names are longish anyway, so we can as well use
something readable for partitions.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
