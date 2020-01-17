From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 07/15] libmultipath: fix sgio_get_vpd looping
Date: Fri, 17 Jan 2020 17:27:00 +0100
Message-ID: <42675e7de2ed4c56762438e2cae803da8de9118e.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-8-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-8-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> If do_inq returns a page with a length that is less than maxlen, but
> larger than DEFAULT_SGIO_LEN, this function will loop forever. Also
> if do_inq returns with a length equal to or greater than maxlen,
> sgio_get_vpd will exit immediately, even if it hasn't read the entire
> page.  Fix these issues, modify the tests to verify the new behavior.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 12 +++---
>  tests/vpd.c              | 84 ++++++++++++++++++++++++------------
> ----
>  2 files changed, 57 insertions(+), 39 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 72f455e8..3c72a80a 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -870,6 +870,7 @@ static int
>  sgio_get_vpd (unsigned char * buff, int maxlen, int fd, int pg)
>  {
>  	int len = DEFAULT_SGIO_LEN;
> +	int rlen;
>  
>  	if (fd < 0) {
>  		errno = EBADF;
> @@ -877,12 +878,11 @@ sgio_get_vpd (unsigned char * buff, int maxlen,
> int fd, int pg)
>  	}
>  retry:
>  	if (0 == do_inq(fd, 0, 1, pg, buff, len)) {
> -		len = get_unaligned_be16(&buff[2]) + 4;
> -		if (len >= maxlen)
> -			return len;
> -		if (len > DEFAULT_SGIO_LEN)
> -			goto retry;
> -		return len;
> +		rlen = get_unaligned_be16(&buff[2]) + 4;
> +		if (rlen <= len || len >= maxlen)
> +			return rlen;
> +		len = (rlen < maxlen)? rlen : maxlen;
> +		goto retry;
>  	}
>  	return -1;
>  }

This looks good.

> diff --git a/tests/vpd.c b/tests/vpd.c
> index d9f80eaa..4dbce010 100644
> --- a/tests/vpd.c
> +++ b/tests/vpd.c
> @@ -306,7 +306,7 @@ static int create_vpd83(unsigned char *buf,
> size_t bufsiz, const char *id,
>  	default:
>  		break;
>  	}
> -	put_unaligned_be16(n, buf + 2);
> +	put_unaligned_be16(bufsiz, buf + 2);
>  	return n + 4;
>  }

I can see that you are trying to create a VPD with a certain given
length. But this way you intentionally create a VPD that doesn't
conform to the spec (offset 2 should contain the real length of the
designator list, not some arbitrary value). This is dangerous, in the
future someone may copy this code thinking that it creates a valid
VPD. At least you should add a big fat comment. Better even, you
should leave out this hunk and override the length value in the
actual test (make_test_vpd_eui) if (sml == 1) (and also add a comment).

Regards
Martin
