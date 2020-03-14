From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 1/4] libmpathpersist: limit PRIN allocation
 length to 8192 bytes
Date: Sat, 14 Mar 2020 18:14:15 -0500
Message-ID: <20200314231415.GR30153@octiron.msp.redhat.com>
References: <20200306230605.3473-1-mwilck@suse.com>
	<20200306230605.3473-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200306230605.3473-2-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com, David Bond <dbond@suse.com>
List-Id: dm-devel.ids

On Sat, Mar 07, 2020 at 12:06:02AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Some targets (notably the qemu-pr-helper) don't support PERSISTENT
> RESERVE IN  commands with more than 8192 bytes allocation length.
> While I have found no explicit requirement in the SCSI specs that
> the allocation lengh may not exceed 8k, an 8k limit is also enforced
> by sg_persist(8), and actually by mpathpersist itself for the
> --allocation-length option, but not for the auto-determined length.
> 
> Fix that.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_pr_ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
> index 74b26b0c..1a28cba7 100644
> --- a/libmpathpersist/mpath_pr_ioctl.c
> +++ b/libmpathpersist/mpath_pr_ioctl.c
> @@ -543,5 +543,7 @@ int get_prin_length(int rq_servact)
>  			mx_resp_len = 0;
>  			break;
>  	}
> +	if (mx_resp_len > MPATH_MAX_PARAM_LEN)
> +		mx_resp_len = MPATH_MAX_PARAM_LEN;
>  	return mx_resp_len;
>  }
> -- 
> 2.25.1
