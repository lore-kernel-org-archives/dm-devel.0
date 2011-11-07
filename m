From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 21:27:57 +0100
Message-ID: <20111107202757.GG18221__9558.1213049174$1320772827$gmane$org@smp.if.uj.edu.pl>
References: <20111107082231.GB18221@smp.if.uj.edu.pl>
	<20111107134601.GH12886@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com>
	<CA+55aFwejLwfY6A9o2yx1YPJMD4a5grD6ttmoG1AsFdEcGZWcw@mail.gmail.com>
	<20111107163215.GF18221@smp.if.uj.edu.pl>
	<20111107190002.GB4396@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20111107190002.GB4396@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@
List-Id: dm-devel.ids

On 11-07 19:00, Alasdair G Kergon wrote:
> On Mon, Nov 07, 2011 at 05:32:15PM +0100, Witold Baryluk wrote:
> > Update patch atached.
>  
> More module.h files can now be export.h I think, so try this version:
> http://git.kernel.org/?p=linux/kernel/git/agk/linux-dm.git;a=patch;h=bef30d3d2059b80b8994ad6a9db8612518ea7a10
> 
> commit bef30d3d2059b80b8994ad6a9db8612518ea7a10
> Author: Alasdair G Kergon <agk@redhat.com>
> Date:   Mon Nov 7 18:45:18 2011 +0000
> 
>     dm: fix module export includes
>     
>     Fix the use of export.h and module.h in new thin provisioning code.
>     
>     Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index cb24666..6919d50 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -10,6 +10,7 @@
>  
>  #include <linux/device-mapper.h>
>  #include <linux/dm-io.h>
> +#include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
>  #include <linux/version.h>
> diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
> index 65fd85e..023fbc2 100644
> --- a/drivers/md/persistent-data/dm-btree-remove.c
> +++ b/drivers/md/persistent-data/dm-btree-remove.c
> @@ -8,7 +8,7 @@
>  #include "dm-btree-internal.h"
>  #include "dm-transaction-manager.h"
>  
> -#include <linux/module.h>
> +#include <linux/export.h>
>  
>  /*
>   * Removing an entry from a btree
> diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
> index e0638be..bd1e7ff 100644
> --- a/drivers/md/persistent-data/dm-btree.c
> +++ b/drivers/md/persistent-data/dm-btree.c
> @@ -8,7 +8,7 @@
>  #include "dm-space-map.h"
>  #include "dm-transaction-manager.h"
>  
> -#include <linux/module.h>
> +#include <linux/export.h>
>  #include <linux/device-mapper.h>
>  
>  #define DM_MSG_PREFIX "btree"
> diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md/persistent-data/dm-space-map-checker.c
> index bb44a93..4bbc7d5 100644
> --- a/drivers/md/persistent-data/dm-space-map-checker.c
> +++ b/drivers/md/persistent-data/dm-space-map-checker.c
> @@ -6,6 +6,7 @@
>  
>  #include "dm-space-map-checker.h"
>  
> +#include <linux/export.h>
>  #include <linux/device-mapper.h>
>  
>  #ifdef CONFIG_DM_DEBUG_SPACE_MAPS
> diff --git a/drivers/md/persistent-data/dm-space-map-disk.c b/drivers/md/persistent-data/dm-space-map-disk.c
> index aeff785..fc469ba 100644
> --- a/drivers/md/persistent-data/dm-space-map-disk.c
> +++ b/drivers/md/persistent-data/dm-space-map-disk.c
> @@ -12,7 +12,7 @@
>  
>  #include <linux/list.h>
>  #include <linux/slab.h>
> -#include <linux/module.h>
> +#include <linux/export.h>
>  #include <linux/device-mapper.h>
>  
>  #define DM_MSG_PREFIX "space map disk"
> diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
> index 728e89a..6f8d387 100644
> --- a/drivers/md/persistent-data/dm-transaction-manager.c
> +++ b/drivers/md/persistent-data/dm-transaction-manager.c
> @@ -10,7 +10,7 @@
>  #include "dm-space-map-metadata.h"
>  #include "dm-persistent-data-internal.h"
>  
> -#include <linux/module.h>
> +#include <linux/export.h>
>  #include <linux/slab.h>
>  #include <linux/device-mapper.h>
>  

All files affected by patch compiles cleanly.

    Tested-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>

Thanks.

-- 
Witold Baryluk
