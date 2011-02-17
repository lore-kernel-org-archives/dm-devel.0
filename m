From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Thu, 17 Feb 2011 16:13:56 +0100
Message-ID: <4D5D3B34.4000005@suse.de>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C2793.1020601@cfl.rr.com> <4D5CCE75.5090202@suse.de>
	<4D5D375F.9070106@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
In-Reply-To: <4D5D375F.9070106-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
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

On 02/17/2011 03:57 PM, Phillip Susi wrote:
> On 2/17/2011 2:29 AM, Hannes Reinecke wrote:
>> /dev/mapper contains the names of the device-mapper devices
>> themselves; for those I don't have any preference.
>> kpartx as called from udev is using the '-part' suffix here, too.
> =

> Right; it needs to not do that.  Everyone needs to use the same naming
> scheme.  When you change naming schemes, you get duplicate devices.  If
> dmraid creates them with 'p' and then udev runs kpartx and tells it to
> use '-part', then you get two partition devices, which will cause all
> kinds of hell.
> =

Which is why you should call 'dmraid' with '-p' to avoid having it
creating partitions.
We'll be getting another event via udev, which then trigger kpartx
to create the partitons there.

> Is there any harm done by adding the 'p' even when the base name does
> not end in a digit?  Is there any good reason to?

The main problem here is that each and everyone has their own
preferred way of naming.
Most tend to stick to the linux model (occasionally inserting a
'p'), some tend to use persistent device names, some tend to use
device-mapper / LVM and do away with all partitions etc.

So whichever way you proceed, you should avoid using a naming scheme
which resembles the linux one.
Otherwise inevitably someone doesn't get it and starts complaining,
one way of the other.

Which was the reason why I chose the '-part' naming scheme; this way
it's pretty obvious that a new naming scheme is used. So any
objections for it not being compliant to the linux naming scheme are
immediately voided.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
