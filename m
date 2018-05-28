From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dm: writecache: add DAX dependency
Date: Mon, 28 May 2018 11:18:58 -0700
Message-ID: <CAPcyv4gpMhBaUdy=UY9M0-2QomycGZCo+K6o+Dzjdc4jmPjrkg@mail.gmail.com>
References: <20180528153834.2268557-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180528153834.2268557-1-arnd@arndb.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Heinz Mauelshagen <heinzm@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, May 28, 2018 at 8:38 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The new dm-writecache driver inconditionally uses the dax
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
>         tristate "Writecache target"
>         depends on BLK_DEV_DM
> +       depends on DAX

This should probably be depends on DAX && DAX_DRIVER as we at least
need pmem or dcssblk enabled to provide a dax capable block device for
DM to claim.
