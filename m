From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] dm: writecache: add DAX dependency
Date: Tue, 29 May 2018 09:17:12 -0600
Message-ID: <20180529151712.GA2537@linux.intel.com>
References: <20180528153834.2268557-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180528153834.2268557-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 28, 2018 at 05:38:10PM +0200, Arnd Bergmann wrote:
> The new dm-writecache driver inconditionally uses the dax
			       unconditionally

> subsystem, leading to link errors in some configurations:
> 
> drivers/md/dm-writecache.o: In function `writecache_ctr':
> dm-writecache.c:(.text+0x1fdc): undefined reference to `dax_read_lock'
> dm-writecache.c:(.text+0x2004): undefined reference to `dax_direct_access'
> dm-writecache.c:(.text+0x21cc): undefined reference to `dax_read_unlock'
> 
> It seems wrong to require DAX in order to build the writecache
> driver, but that at least avoids randconfig build errors.
> 
> Fixes: bb15b431d650 ("dm: add writecache target")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/md/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 852c7ebe2902..f8ecf2da1edf 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -338,6 +338,7 @@ config DM_CACHE_SMQ
>  config DM_WRITECACHE
>  	tristate "Writecache target"
>  	depends on BLK_DEV_DM
> +	depends on DAX
>  	---help---
>  	   The writecache target caches writes on persistent memory or SSD.
>  	   It is intended for databases or other programs that need extremely

I think the right way to handle this is to instead wrap all the DAX code in
dm-writecache in "#if IS_ENABLED(CONFIG_DAX_DRIVER)" blocks and provide stubs
for the non-DAX case.  This prevents you from having to pull in all the
generic DAX code unnecessarily.

In looking at the file I think this is just the persistent_memory_claim()
function.

I'll send out a patch once I've tested a bit.

- Ross
