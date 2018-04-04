From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dm: fix DAX dependency
Date: Wed, 4 Apr 2018 07:00:13 -0700
Message-ID: <CAPcyv4hc67fhOvZ21JOy+pvoTepCjvuqk3TS=U8tN=6+vEkdFQ@mail.gmail.com>
References: <20180404095427.2537184-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180404095427.2537184-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Apr 4, 2018 at 2:54 AM, Arnd Bergmann <arnd@arndb.de> wrote:
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

I had some larger reworks of dax pending in -next until I got a late
report of a UML build error. Investigating that made me realize that I
missed the device-mapper dax support in those dax reworks, I started
pulling in late changes. However, this wider rework is to feel too
late for 4.17...

Thanks for the fix, I'll get it folded in and reevaluate what bits are
still viable / tested enough to push at this stage.
