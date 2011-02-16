From: Phillip Susi <psusi-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
Subject: What is the deal with the partition separator?
Date: Tue, 15 Feb 2011 22:21:34 -0500
Message-ID: <4D5B42BE.3050301@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Unsubscribe: <http://lists.alioth.debian.org/mailman/options/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.alioth.debian.org/pipermail/parted-devel>
List-Post: <mailto:parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Help: <mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=help>
List-Subscribe: <http://lists.alioth.debian.org/mailman/listinfo/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=subscribe>
Sender: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
Errors-To: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Curtis Gedak <gedakc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, Debian LVM Team <pkg-lvm-maintainers-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>, parted-deve
List-Id: dm-devel.ids

It used to be that partitions device names just had a digit added on to 
the base disk device name.  It seems that this became problematic at 
some point with device mapper and oddly named disks, and there have been 
several responses to it:

1)  dmraid and (lib)parted now always add a 'p' between the base name 
and the partition number

2)  kpartx from multipath-tools adds the 'p' only if the base name ends 
in a digit

3)  Debian and Ubuntu's udev and init scripts tell kpartx to use 'part' 
instead of just 'p'.

4)  gparted now explicitly tells dmraid to not use any character so that 
it behaves like older versions and is therefore compatible with the 
kpartx method that gparted has adopted, at least when the base name does 
not end with a digit.

Each of these components needs to agree on what the correct name is or 
chaos ensues.  I would like to discuss the merits of each and try to 
decide on a standard.

Having thought about it for a moment, it seems to me that deciding on 
always adding the 'p' is the way to go, since the 'art' just makes 
things longer for no good reason, and if you only sometimes add the 'p' 
then you can't tell if a device name that ends in a digit that does not 
follow a 'p' is a whole disk, or a partition.
