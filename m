From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: rename some drivers/md/ files to have an "md-" prefix
Date: Tue, 10 Oct 2017 14:29:18 -0700
Message-ID: <20171010212918.fykwmts6y2kfll2i@kernel.org>
References: <20171010210241.2332-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171010210241.2332-1-snitzer@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 10, 2017 at 05:02:41PM -0400, Mike Snitzer wrote:
> Motivated by the desire to illiminate the imprecise nature of
> DM-specific patches being unnecessarily sent to both the MD maintainer
> and mailing-list.  Which is born out of the fact that DM files also
> reside in drivers/md/
> 
> Now all MD-specific files in drivers/md/ start with either "raid" or
> "md-" and the MAINTAINERS file has been updated accordingly.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Good idea! Assume I take this?

> ---
>  MAINTAINERS                                | 7 ++++++-
>  drivers/md/Makefile                        | 8 ++++----
>  drivers/md/dm-raid.c                       | 2 +-
>  drivers/md/{bitmap.c => md-bitmap.c}       | 2 +-
>  drivers/md/{bitmap.h => md-bitmap.h}       | 0
>  drivers/md/md-cluster.c                    | 2 +-
>  drivers/md/{faulty.c => md-faulty.c}       | 0
>  drivers/md/{linear.c => md-linear.c}       | 2 +-
>  drivers/md/{linear.h => md-linear.h}       | 0
>  drivers/md/{multipath.c => md-multipath.c} | 2 +-
>  drivers/md/{multipath.h => md-multipath.h} | 0
>  drivers/md/md.c                            | 2 +-
>  drivers/md/raid1.c                         | 2 +-
>  drivers/md/raid10.c                        | 2 +-
>  drivers/md/raid5-cache.c                   | 2 +-
>  drivers/md/raid5.c                         | 2 +-
>  16 files changed, 20 insertions(+), 15 deletions(-)
>  rename drivers/md/{bitmap.c => md-bitmap.c} (99%)
>  rename drivers/md/{bitmap.h => md-bitmap.h} (100%)
>  rename drivers/md/{faulty.c => md-faulty.c} (100%)
>  rename drivers/md/{linear.c => md-linear.c} (99%)
>  rename drivers/md/{linear.h => md-linear.h} (100%)
>  rename drivers/md/{multipath.c => md-multipath.c} (99%)
>  rename drivers/md/{multipath.h => md-multipath.h} (100%)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2d3d750..6e96848 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4091,6 +4091,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
>  T:	quilt http://people.redhat.com/agk/patches/linux/editing/
>  S:	Maintained
>  F:	Documentation/device-mapper/
> +F:	drivers/md/Makefile
> +F:	drivers/md/Kconfig
>  F:	drivers/md/dm*
>  F:	drivers/md/persistent-data/
>  F:	include/linux/device-mapper.h
> @@ -12453,7 +12455,10 @@ M:	Shaohua Li <shli@kernel.org>
>  L:	linux-raid@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git
>  S:	Supported
> -F:	drivers/md/
> +F:	drivers/md/Makefile
> +F:	drivers/md/Kconfig
> +F:	drivers/md/md*
> +F:	drivers/md/raid*
>  F:	include/linux/raid/
>  F:	include/uapi/linux/raid/
>  
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 786ec9e..d8e5f9c 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -18,7 +18,7 @@ dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o \
>  dm-cache-smq-y   += dm-cache-policy-smq.o
>  dm-era-y	+= dm-era-target.o
>  dm-verity-y	+= dm-verity-target.o
> -md-mod-y	+= md.o bitmap.o
> +md-mod-y	+= md.o md-bitmap.o
>  raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
>  dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
>  
> @@ -27,13 +27,13 @@ dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
>  # themselves, and md.o may use the personalities when it 
>  # auto-initialised.
>  
> -obj-$(CONFIG_MD_LINEAR)		+= linear.o
> +obj-$(CONFIG_MD_LINEAR)		+= md-linear.o
>  obj-$(CONFIG_MD_RAID0)		+= raid0.o
>  obj-$(CONFIG_MD_RAID1)		+= raid1.o
>  obj-$(CONFIG_MD_RAID10)		+= raid10.o
>  obj-$(CONFIG_MD_RAID456)	+= raid456.o
> -obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
> -obj-$(CONFIG_MD_FAULTY)		+= faulty.o
> +obj-$(CONFIG_MD_MULTIPATH)	+= md-multipath.o
> +obj-$(CONFIG_MD_FAULTY)		+= md-faulty.o
>  obj-$(CONFIG_MD_CLUSTER)	+= md-cluster.o
>  obj-$(CONFIG_BCACHE)		+= bcache/
>  obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 2245d06..9856667 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -12,7 +12,7 @@
>  #include "raid1.h"
>  #include "raid5.h"
>  #include "raid10.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  
>  #include <linux/device-mapper.h>
>  
> diff --git a/drivers/md/bitmap.c b/drivers/md/md-bitmap.c
> similarity index 99%
> rename from drivers/md/bitmap.c
> rename to drivers/md/md-bitmap.c
> index d212163..298f72a 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -29,7 +29,7 @@
>  #include <linux/seq_file.h>
>  #include <trace/events/block.h>
>  #include "md.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  
>  static inline char *bmname(struct bitmap *bitmap)
>  {
> diff --git a/drivers/md/bitmap.h b/drivers/md/md-bitmap.h
> similarity index 100%
> rename from drivers/md/bitmap.h
> rename to drivers/md/md-bitmap.h
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 03082e1..0754573 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -15,7 +15,7 @@
>  #include <linux/sched.h>
>  #include <linux/raid/md_p.h>
>  #include "md.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  #include "md-cluster.h"
>  
>  #define LVB_SIZE	64
> diff --git a/drivers/md/faulty.c b/drivers/md/md-faulty.c
> similarity index 100%
> rename from drivers/md/faulty.c
> rename to drivers/md/md-faulty.c
> diff --git a/drivers/md/linear.c b/drivers/md/md-linear.c
> similarity index 99%
> rename from drivers/md/linear.c
> rename to drivers/md/md-linear.c
> index c464fb4..773fc70 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/md-linear.c
> @@ -23,7 +23,7 @@
>  #include <linux/slab.h>
>  #include <trace/events/block.h>
>  #include "md.h"
> -#include "linear.h"
> +#include "md-linear.h"
>  
>  /*
>   * find which device holds a particular offset
> diff --git a/drivers/md/linear.h b/drivers/md/md-linear.h
> similarity index 100%
> rename from drivers/md/linear.h
> rename to drivers/md/md-linear.h
> diff --git a/drivers/md/multipath.c b/drivers/md/md-multipath.c
> similarity index 99%
> rename from drivers/md/multipath.c
> rename to drivers/md/md-multipath.c
> index b68e066..5c70176 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/md-multipath.c
> @@ -25,7 +25,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include "md.h"
> -#include "multipath.h"
> +#include "md-multipath.h"
>  
>  #define MAX_WORK_PER_DISK 128
>  
> diff --git a/drivers/md/multipath.h b/drivers/md/md-multipath.h
> similarity index 100%
> rename from drivers/md/multipath.h
> rename to drivers/md/md-multipath.h
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0ff1bbf..b64fe10 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -69,7 +69,7 @@
>  
>  #include <trace/events/block.h>
>  #include "md.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  #include "md-cluster.h"
>  
>  #ifndef MODULE
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f3f3e40..d2c2368 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -43,7 +43,7 @@
>  
>  #include "md.h"
>  #include "raid1.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  
>  #define UNSUPPORTED_MDDEV_FLAGS		\
>  	((1L << MD_HAS_JOURNAL) |	\
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 374df57..4dac10e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -29,7 +29,7 @@
>  #include "md.h"
>  #include "raid10.h"
>  #include "raid0.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  
>  /*
>   * RAID10 provides a combination of RAID0 and RAID1 functionality.
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 0b7406a..2b450ee 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -23,7 +23,7 @@
>  #include <linux/types.h>
>  #include "md.h"
>  #include "raid5.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  #include "raid5-log.h"
>  
>  /*
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 928e24a..10c0d87 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -63,7 +63,7 @@
>  #include "md.h"
>  #include "raid5.h"
>  #include "raid0.h"
> -#include "bitmap.h"
> +#include "md-bitmap.h"
>  #include "raid5-log.h"
>  
>  #define UNSUPPORTED_MDDEV_FLAGS	(1L << MD_FAILFAST_SUPPORTED)
> -- 
> 2.10.1
> 
