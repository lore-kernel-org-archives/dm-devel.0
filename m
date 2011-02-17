From: Curtis Gedak <gedakc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [dm-devel] What is the deal with the partition
	separator?
Date: Thu, 17 Feb 2011 09:54:32 -0700
Message-ID: <4D5D52C8.3080706@gmail.com>
References: <4D5B42BE.3050301@cfl.rr.com> <4D5B7ED9.20304@suse.de>
	<4D5C2793.1020601@cfl.rr.com> <4D5CCE75.5090202@suse.de>
	<4D5D375F.9070106@cfl.rr.com> <4D5D3B34.4000005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
Cc: parted-devel-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, Phillip Susi <psusi-3tLf1voIkJTQT0dZR+AlfA@public.gmane.org>, Debian LVM Team <pkg-lvm-maintainers-XbBxUvOt3X2LieD7tvxI8l/i77bcL1HB@public.gmane.org>
List-Id: dm-devel.ids

On 11-02-17 08:13 AM, Hannes Reinecke wrote:
> So whichever way you proceed, you should avoid using a naming scheme
> which resembles the linux one.

 From my perspective as a maintainer of partitioning software it would 
be nice if given the device name and partition number I could easily 
determine the partition name.

Unfortunately this is not easily done when there are deviations from the 
linux model ("insert a 'p' between the device name and the partition 
number when the device name ends in a number").

Each deviation from the linux partition naming model results in more 
code to handle the deviation, and a corresponding increased number of 
test cases to avoid errors.

Regards,
Curtis Gedak
(Maintainer of GParted)
