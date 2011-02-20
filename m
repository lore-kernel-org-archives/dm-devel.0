From: Phillip Susi <psusi-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Sun, 20 Feb 2011 00:04:21 -0500
Message-ID: <4D60A0D5.40904@cfl.rr.com>
References: <4D5B42BE.3050301@cfl.rr.com>
	<4D5B7ED9.20304@suse.de>	<4D5C2793.1020601@cfl.rr.com>
	<4D5CCE75.5090202@suse.de>	<4D5D375F.9070106@cfl.rr.com>
	<4D5D3B34.4000005@suse.de>	<4D5D3B0F.3050708@cfl.rr.com>
	<20110217165332.GE28729@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
In-Reply-To: <20110217165332.GE28729-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
List-Unsubscribe: <http://lists.alioth.debian.org/mailman/options/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.alioth.debian.org/pipermail/parted-devel>
List-Post: <mailto:parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Help: <mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=help>
List-Subscribe: <http://lists.alioth.debian.org/mailman/listinfo/parted-devel>,
	<mailto:parted-devel-request-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org?subject=subscribe>
Sender: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
Errors-To: parted-devel-bounces+gcgpd-parted-devel=m.gmane.org-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org
To: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Curtis Gedak <gedakc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org, De
List-Id: dm-devel.ids

Oops, didn't see this until today because this darn mailing list mangles 
the reply-to header. *shakes fist*

Currently all of the tools check by trying to open the expected device 
name.  If they have different ideas of what that is, the check fails to 
find the existing instance.  It is looking to me like the way to fix 
this is to patch dmraid and libparted so that they conform with the 
kpartx and "linux since the dawn of time" method of only adding the 'p' 
if the previous character is a digit.

On 02/17/2011 11:53 AM, Alasdair G Kergon wrote:
> Partitions should be created only once, in one place.
>
> If a second instance of anything tries to create them too, it should,
> by default, detect that they are already there and not proceed.
>
> You should not be able to run kpartx twice on the same underlying
> disk with different delimiters without some sort of 'force' option.
>
> (Check by querying /sys/.../holders ?)
