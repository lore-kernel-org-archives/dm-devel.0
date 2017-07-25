From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] dm,dax: Make sure dm_dax_flush() is called if device
 supports it
Date: Tue, 25 Jul 2017 13:43:27 -0700
Message-ID: <CAPcyv4gqyOjBTFDbXbSYqxPQzY2cAjA6=zi6+51cN=Hae7eDJQ@mail.gmail.com>
References: <20170725194337.GA20979@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170725194337.GA20979-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Jul 25, 2017 at 12:43 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Right now, dm_dax_flush() is not being called and I think it is not being
> called becuase DAXDEV_WRITE_CACHE is not set on dm dax device.
>
> If underlying dax device supports write cache, set DAXDEV_WRITE_CACHE on
> dm dax device. This will get dm_dax_flush() being called.
>
> Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/dax/super.c   |  5 +++++
>  drivers/md/dm-table.c | 33 +++++++++++++++++++++++++++++++++
>  include/linux/dax.h   |  1 +
>  3 files changed, 39 insertions(+)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index ce9e563e6e1d..5c5e7b9f6831 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -278,6 +278,11 @@ void dax_write_cache(struct dax_device *dax_dev, bool wc)
>  }
>  EXPORT_SYMBOL_GPL(dax_write_cache);
>
> +bool dax_write_cache_enabled(struct dax_device *dax_dev)
> +{
> +       return test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
> +}

We need :

    EXPORT_SYMBOL_GPL(dax_write_cache_enabled)

...but other than that, looks good to me.

Acked-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
