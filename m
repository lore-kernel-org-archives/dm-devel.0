From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/8] dm: Fix workqueue leak for raid5
Date: Tue, 24 Jul 2007 15:27:05 -0700
Message-ID: <e9c3a7c20707241527o55f3b2dbh4d218c96c6bb612b@mail.gmail.com>
References: <20070724085106.GD20538@dnb.sw.ru>
	<20070724085642.GB16507@dnb.sw.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070724085642.GB16507@dnb.sw.ru>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 7/24/07, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  drivers/md/raid5.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0f30826..79dd2c7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4985,6 +4985,8 @@ static int run(mddev_t *mddev)
>  abort:
>         if (conf) {
>                 print_raid5_conf(conf);
> +               if (conf->workqueue)
> +                       destroy_workqueue(conf->workqueue);
>                 safe_put_page(conf->spare_page);
>                 kfree(conf->disks);
>                 kfree(conf->stripe_hashtbl);
> --
I assume this patch is against -mm.  I will fold it into:

git://lost.foo-projects.org/~dwillia2/git/iop md-for-linus

Thanks,
Dan
