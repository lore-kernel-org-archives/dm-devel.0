From: Bryan Gurney <bgurney@redhat.com>
Subject: Re: [PATCH][next] dm: remove redundant unsigned comparison to less
 than zero
Date: Thu, 2 May 2019 09:27:05 -0400
Message-ID: <CAHhmqcTRVWBNnynaAJ7mbtke-MCiBma-6z_=bYrFzh0ubky-Fw@mail.gmail.com>
References: <20190501125717.5695-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501125717.5695-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, May 1, 2019 at 8:58 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Variable block is an unsigned long long hence the less than zero
> comparison is always false, hence it is redundant and can be removed.
>
> Addresses-Coverity: ("Unsigned compared against 0")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/md/dm-dust.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
> index 178587bdc626..e739092bfc65 100644
> --- a/drivers/md/dm-dust.c
> +++ b/drivers/md/dm-dust.c
> @@ -411,7 +411,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
>
>                 block = tmp;
>                 sector_div(size, dd->sect_per_block);
> -               if (block > size || block < 0) {
> +               if (block > size) {
>                         DMERR("selected block value out of range");
>                         return result;
>                 }
> --
> 2.20.1
>

Thanks.

There was already a check before that to ensure that the argument
feeding this variable is an unsigned long long; if it isn't, it will
fail with EINVAL:

# dmsetup message -- dust1 0 queryblock -1
device-mapper: message ioctl on dust1  failed: Invalid argument
Command failed

Reviewed-by: Bryan Gurney <bgurney@redhat.com>
