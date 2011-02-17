From: Phillip Susi <psusi-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Thu, 17 Feb 2011 10:13:19 -0500
Message-ID: <4D5D3B0F.3050708@cfl.rr.com>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C2793.1020601@cfl.rr.com> <4D5CCE75.5090202@suse.de>
	<4D5D375F.9070106@cfl.rr.com> <4D5D3B34.4000005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
In-Reply-To: <4D5D3B34.4000005-l3A5Bk7waGM@public.gmane.org>
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

On 2/17/2011 10:13 AM, Hannes Reinecke wrote:
> Which is why you should call 'dmraid' with '-p' to avoid having it
> creating partitions.
> We'll be getting another event via udev, which then trigger kpartx
> to create the partitons there.

Except that won't work if you don't have kpartx installed, and also
users tend to run dmraid directly and don't use -p to change its
behavior.  The same goes with kpartx.  Everyone needs to get on the same
page here and do away with -p switches to deviate from the standard
behavior, or you run into possibly data corrupting problems.

> Which was the reason why I chose the '-part' naming scheme; this way
> it's pretty obvious that a new naming scheme is used. So any
> objections for it not being compliant to the linux naming scheme are
> immediately voided.

Being VERY non compliant does not void objections that you aren't compliant.
