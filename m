From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/8] Various cleanups
Date: Wed, 15 Jul 2020 09:42:58 -0400
Message-ID: <20200715134258.GB9501@redhat.com>
References: <20200715095217.441885-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200715095217.441885-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 15 2020 at  5:52am -0400,
Damien Le Moal <damien.lemoal@wdc.com> wrote:

> Mike,
> 
> These patches fix various compilation warnings showing up when compiling
> with W=1. The last patch addresses a static checker warning (C=1
> compilation). There are a lot more of these code checker warnings
> remaining that probably could be addressed, some seem to be false
> positive though.
> 
> Damien Le Moal (8):
>   dm raid5: Remove set but unused variable
>   dm raid5: Fix compilation warning
>   md: Fix compilation warning
>   dm raid10: Fix compilation warning
>   dm verity: Fix compilation warning
>   dm raid: Remove empty if statement
>   dm ioctl: Fix compilation warning
>   dm init: Set file local variable static
> 
>  drivers/md/dm-init.c              |  2 +-
>  drivers/md/dm-ioctl.c             |  2 +-
>  drivers/md/dm-raid.c              |  2 --
>  drivers/md/dm-verity-verify-sig.h | 14 +++++++-------

OK, thanks.

>  drivers/md/md.c                   | 12 ++++++------
>  drivers/md/raid10.c               |  4 ++--
>  drivers/md/raid5-cache.c          |  4 +---
>  drivers/md/raid5.c                | 12 ++++++------

But these need to be routed through the MD.

Mike
