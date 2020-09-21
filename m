From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH v2] dm: Call proper helper to determine dax support
Date: Mon, 21 Sep 2020 11:23:07 +0530
Message-ID: <CA+G9fYud7x0TfTDNWHa_0hzYHNQyet-a2==gQzDaZKXywY1meg@mail.gmail.com>
References: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
To: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux- stable <stable@vger.kernel.org>, Adrian Huang <ahuang12@lenovo.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, open list <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, mpatocka@redhat.com, lkft-triage@lists.linaro.org
List-Id: dm-devel.ids

On Fri, 18 Sep 2020 at 11:18, Dan Williams <dan.j.williams@intel.com> wrote=
:
>
> From: Jan Kara <jack@suse.cz>
>
> DM was calling generic_fsdax_supported() to determine whether a device
> referenced in the DM table supports DAX. However this is a helper for "le=
af" device drivers so that
> they don't have to duplicate common generic checks. High level code
> should call dax_supported() helper which that calls into appropriate
> helper for the particular device. This problem manifested itself as
> kernel messages:
>
> dm-3: error: dax access failed (-95)
>
> when lvm2-testsuite run in cases where a DM device was stacked on top of
> another DM device.
>
> Fixes: 7bf7eac8d648 ("dax: Arrange for dax_supported check to span multip=
le devices")
> Cc: <stable@vger.kernel.org>
> Tested-by: Adrian Huang <ahuang12@lenovo.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since v1 [1]:
> - Add missing dax_read_lock() around dax_supported()
>
> [1]: http://lore.kernel.org/r/20200916151445.450-1-jack@suse.cz
>
>  drivers/dax/super.c   |    4 ++++
>  drivers/md/dm-table.c |   10 +++++++---
>  include/linux/dax.h   |   11 +++++++++--
>  3 files changed, 20 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e5767c83ea23..b6284c5cae0a 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -325,11 +325,15 @@ EXPORT_SYMBOL_GPL(dax_direct_access);
>  bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev=
,
>                 int blocksize, sector_t start, sector_t len)
>  {
> +       if (!dax_dev)
> +               return false;
> +
>         if (!dax_alive(dax_dev))
>                 return false;
>
>         return dax_dev->ops->dax_supported(dax_dev, bdev, blocksize, star=
t, len);
>  }
> +EXPORT_SYMBOL_GPL(dax_supported);

arm build error while building with allmodconfig.

../drivers/dax/super.c:325:6: error: redefinition of =E2=80=98dax_supported=
=E2=80=99
  325 | bool dax_supported(struct dax_device *dax_dev, struct
block_device *bdev,
      |      ^~~~~~~~~~~~~
In file included from ../drivers/dax/super.c:16:
../include/linux/dax.h:162:20: note: previous definition of
=E2=80=98dax_supported=E2=80=99 was here
  162 | static inline bool dax_supported(struct dax_device *dax_dev,
      |                    ^~~~~~~~~~~~~
make[3]: *** [../scripts/Makefile.build:283: drivers/dax/super.o] Error 1

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Ref:
https://builds.tuxbuild.com/IO690jFQDp0qP9zFuWBqpA/build.log
