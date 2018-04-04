From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix DAX dependency
Date: Wed, 4 Apr 2018 09:43:15 -0400
Message-ID: <20180404134315.GA14708@redhat.com>
References: <20180404095427.2537184-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180404095427.2537184-1-arnd@arndb.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Dan Williams <dan.j.williams@intel.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 04 2018 at  5:54am -0400,
Arnd Bergmann <arnd@arndb.de> wrote:

> Building device mapper with CONFIG_DAX=m now results in a link error:
> 
> drivers/md/dm.o: In function `dm_put_table_device':
> dm.c:(.text+0x33c): undefined reference to `put_dax'
> drivers/md/dm.o: In function `cleanup_mapped_device':
> dm.c:(.text+0x1054): undefined reference to `kill_dax'
> dm.c:(.text+0x105c): undefined reference to `put_dax'
> drivers/md/dm.o: In function `dm_get_table_device':
> dm.c:(.text+0x2744): undefined reference to `dax_get_by_host'
> drivers/md/dm-table.o: In function `device_dax_write_cache_enabled':
> dm-table.c:(.text+0x1030): undefined reference to `dax_write_cache_enabled'
> drivers/md/dm-table.o: In function `dm_table_set_restrictions':
> dm-table.c:(.text+0x29b8): undefined reference to `dax_write_cache'
> 
> This adds a dependency that prevents the invalid configuration, allowing
> a built-in device mapper only if DAX is either built-in as well, or
> completely disabled.
> 
> Fixes: 4de1c562f7e9 ("dax, dm: allow device-mapper to operate without dax support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> The regression only showed up in linux-next at the start of the merge
> window. Any idea what happened?
> ---
>  drivers/md/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 49287135b86c..5e5a47c5ff82 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -200,6 +200,7 @@ config BLK_DEV_DM_BUILTIN
>  
>  config BLK_DEV_DM
>  	tristate "Device mapper support"
> +	depends on DAX || DAX=n
>  	select BLK_DEV_DM_BUILTIN
>  	---help---
>  	  Device-mapper is a low level volume manager.  It works by allowing
> -- 
> 2.9.0
> 

Seems fine, CONFIG_DAX=m was an oversight in commit 4de1c562f7e9

Dan, do you want to just fold this into that original commit?  Either
way, please feel free to pick this up.

Thanks Arnd.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>
