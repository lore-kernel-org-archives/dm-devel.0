From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [RFC PATCH] dm-zoned: Zoned block device target
Date: Tue, 10 Jan 2017 10:15:04 +0900
Message-ID: <20e0caef-6ad9-b394-f3b4-94ee9f918dfe@wdc.com>
References: <1481784687-6993-1-git-send-email-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1481784687-6993-1-git-send-email-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Shaun Tancheff <shaun@tancheff.com>
List-Id: dm-devel.ids


All,

Comments on this patch would be very much appreciated.

Thank you.

Best regards.

On 12/15/16 15:51, Damien Le Moal wrote:
> The dm-zoned device mapper provides transparent write access to zoned
> block devices (ZBC and ZAC compliant devices). dm-zoned hides to the
> device user (a file system or an application doing raw block device
> accesses) any constraint imposed on write requests by the zoned block
> device.  dm-zoned primary target is host-managed zoned block devices
> but it can also be used with host-aware models to mitigate potential
> device-side performance degradation due to excessive random write.
> 
> dm-zoned implementation focus on simplicity and on minimizing overhead
> (CPU, memory and storage overhead). For a 10TB host-manmaged disk with
> 256 MB zones, dm-zoned memory usage per disk instance is at most 4.5 MB
> and as little as 5 zones will be used internally for storing metadata
> and performaing reclaim operations.
> 
> This is a different solution from the zdm target proposed by Shaun.
> Whereas zdm implements a full block translation layer to enable a
> sequential write pattern to the zoned block device, dm-zoned only
> implements zone indirection. This requires on-disk buffering of random
> write accesses using conventional zones, leading to lower write
> performance. However, read performance can be maintained (no added
> fragmentation) and internal metadata management is simplified.
> 
> dm-zoned backend devices can be formatted and checked using the dmzadm
> utility available at:
> 
> https://github.com/hgst/dm-zoned-tools
> 
> This patch applies on top of Jens Axboe linux-block tree, branch
> for-4.10/block (this branch includes the block layer support for zoned
> block devices, on which dm-zoned depends).
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  Documentation/device-mapper/dm-zoned.txt |  157 +++
>  MAINTAINERS                              |    7 +
>  drivers/md/Kconfig                       |   16 +
>  drivers/md/Makefile                      |    2 +
>  drivers/md/dm-zoned-io.c                 | 1103 +++++++++++++++
>  drivers/md/dm-zoned-metadata.c           | 2211 ++++++++++++++++++++++++++++++
>  drivers/md/dm-zoned-reclaim.c            |  699 ++++++++++
>  drivers/md/dm-zoned.h                    |  570 ++++++++
>  8 files changed, 4765 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-zoned.txt
>  create mode 100644 drivers/md/dm-zoned-io.c
>  create mode 100644 drivers/md/dm-zoned-metadata.c
>  create mode 100644 drivers/md/dm-zoned-reclaim.c
>  create mode 100644 drivers/md/dm-zoned.h

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
