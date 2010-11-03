From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Memory leak if failed to do RTPG.
Date: Wed, 3 Nov 2010 16:53:46 -0400
Message-ID: <20101103205346.GA26473@redhat.com>
References: <1239228685-5658-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1239228685-5658-1-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch is still queued in dm-devel's patchwork and is still relevant
to upstream's multipath-tools:
https://patchwork.kernel.org/patch/17280/

On Wed, Apr 08 2009 at  6:11pm -0400,
Konrad Rzeszutek <konrad@virtualiron.com> wrote:

> We don't de-alloc the buf variable if we fail on the first
> do_rtpg call.
> ---
>  libmultipath/prioritizers/alua_rtpg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
> index 7151cdd..5a8a59f 100644
> --- a/libmultipath/prioritizers/alua_rtpg.c
> +++ b/libmultipath/prioritizers/alua_rtpg.c
> @@ -263,7 +263,7 @@ get_asymmetric_access_state(int fd, unsigned int tpg)
>  	}
>  	rc = do_rtpg(fd, buf, buflen);
>  	if (rc < 0)
> -		return rc;
> +		goto out;
>  	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
>  	if (buflen < (scsi_buflen + 4)) {
>  		free(buf);
> -- 
> 1.5.4.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
