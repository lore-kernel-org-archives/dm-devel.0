From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: writecache: add DAX dependency
Date: Tue, 29 May 2018 09:06:01 -0400
Message-ID: <20180529130601.GA31628@redhat.com>
References: <20180528153834.2268557-1-arnd@arndb.de>
 <CAPcyv4gpMhBaUdy=UY9M0-2QomycGZCo+K6o+Dzjdc4jmPjrkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gpMhBaUdy=UY9M0-2QomycGZCo+K6o+Dzjdc4jmPjrkg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mikulas Patocka <mpatocka@redhat.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, May 28 2018 at  2:18pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Mon, May 28, 2018 at 8:38 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The new dm-writecache driver inconditionally uses the dax
> > subsystem, leading to link errors in some configurations:
> >
> > drivers/md/dm-writecache.o: In function `writecache_ctr':
> > dm-writecache.c:(.text+0x1fdc): undefined reference to `dax_read_lock'
> > dm-writecache.c:(.text+0x2004): undefined reference to `dax_direct_access'
> > dm-writecache.c:(.text+0x21cc): undefined reference to `dax_read_unlock'
> >
> > It seems wrong to require DAX in order to build the writecache
> > driver, but that at least avoids randconfig build errors.
> >
> > Fixes: bb15b431d650 ("dm: add writecache target")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/md/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index 852c7ebe2902..f8ecf2da1edf 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -338,6 +338,7 @@ config DM_CACHE_SMQ
> >  config DM_WRITECACHE
> >         tristate "Writecache target"
> >         depends on BLK_DEV_DM
> > +       depends on DAX
> 
> This should probably be depends on DAX && DAX_DRIVER as we at least
> need pmem or dcssblk enabled to provide a dax capable block device for
> DM to claim.

But dm-writecache is meant to be used for normal SSD even if PMEM isn't
available in the kernel.
