From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH] dm ioctl: Remove double parentheses
Date: Fri, 31 Mar 2017 18:50:19 -0700
Message-ID: <20170401015019.GA13986@google.com>
References: <20170316164830.127026-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170316164830.127026-1-mka@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Grant Grundler <grundler@chromium.org>, Michael Davidson <md@google.com>, Greg Hackmann <ghackmann@google.com>
List-Id: dm-devel.ids

El Thu, Mar 16, 2017 at 09:48:30AM -0700 Matthias Kaehlcke ha dit:

> The extra pair of parantheses is not needed and causes clang to generate
> the following warning:
> 
> drivers/md/dm-ioctl.c:1776:11: error: equality comparison with extraneous parentheses [-Werror,-Wparentheses-equality]
>         if ((cmd == DM_DEV_CREATE_CMD)) {
>              ~~~~^~~~~~~~~~~~~~~~~~~~
> drivers/md/dm-ioctl.c:1776:11: note: remove extraneous parentheses around the comparison to silence this warning
>         if ((cmd == DM_DEV_CREATE_CMD)) {
>             ~    ^                   ~
> drivers/md/dm-ioctl.c:1776:11: note: use '=' to turn this equality comparison into an assignment
>         if ((cmd == DM_DEV_CREATE_CMD)) {
>                  ^~
>                  =
> 
> Also remove another double parentheses that don't cause a warning.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>  drivers/md/dm-ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index a5a9b17f0f7f..9360036bf6d3 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1777,12 +1777,12 @@ static int validate_params(uint cmd, struct dm_ioctl *param)
>  	    cmd == DM_LIST_VERSIONS_CMD)
>  		return 0;
>  
> -	if ((cmd == DM_DEV_CREATE_CMD)) {
> +	if (cmd == DM_DEV_CREATE_CMD) {
>  		if (!*param->name) {
>  			DMWARN("name not supplied when creating device");
>  			return -EINVAL;
>  		}
> -	} else if ((*param->uuid && *param->name)) {
> +	} else if (*param->uuid && *param->name) {
>  		DMWARN("only supply one of name or uuid, cmd(%u)", cmd);
>  		return -EINVAL;
>  	}

Ping? Any feedback on this patch?

Cheers

Matthias
