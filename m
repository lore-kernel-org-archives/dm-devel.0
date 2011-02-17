From: Phillip Susi <psusi-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Thu, 17 Feb 2011 09:57:35 -0500
Message-ID: <4D5D375F.9070106@cfl.rr.com>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C2793.1020601@cfl.rr.com> <4D5CCE75.5090202@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
In-Reply-To: <4D5CCE75.5090202-l3A5Bk7waGM@public.gmane.org>
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
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org, Debian LVM Team <pkg-lvm-maintainers-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Id: dm-devel.ids

On 2/17/2011 2:29 AM, Hannes Reinecke wrote:
> /dev/mapper contains the names of the device-mapper devices
> themselves; for those I don't have any preference.
> kpartx as called from udev is using the '-part' suffix here, too.

Right; it needs to not do that.  Everyone needs to use the same naming
scheme.  When you change naming schemes, you get duplicate devices.  If
dmraid creates them with 'p' and then udev runs kpartx and tells it to
use '-part', then you get two partition devices, which will cause all
kinds of hell.

Is there any harm done by adding the 'p' even when the base name does
not end in a digit?  Is there any good reason to?
