From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 16/21] libmultipath: tur checker: leave
 unsupported paths alone
Date: Thu, 25 Oct 2018 16:42:42 -0500
Message-ID: <20181025214242.GY7100@octiron.msp.redhat.com>
References: <20181011222707.3631-1-mwilck@suse.com>
	<20181011222707.3631-17-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181011222707.3631-17-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 12, 2018 at 12:27:02AM +0200, Martin Wilck wrote:
> A checker shouldn't set the path state to PATH_DOWN if it fails
> to obtain information about the path in the first place. Add logic
> to the checker to distinguish a failed path from an unsupported path.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/tur.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 448c396e..8f4bdc8b 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -125,6 +125,10 @@ retry:
>  	io_hdr.timeout = timeout * 1000;
>  	io_hdr.pack_id = 0;
>  	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
> +		if (errno == ENOTTY) {
> +			*msgid = CHECKER_MSGID_UNSUPPORTED;
> +			return PATH_WILD;
> +		}
>  		*msgid = CHECKER_MSGID_DOWN;
>  		return PATH_DOWN;
>  	}
> -- 
> 2.19.0
