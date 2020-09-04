From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 11/14] mpathpersist: check whether malloc
 paramp->trnptid_list, fails in handle_args func
Date: Fri, 4 Sep 2020 18:52:52 -0500
Message-ID: <20200904235252.GG11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<eeea4f08-bcb1-65b6-2fe8-b078961a07d3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <eeea4f08-bcb1-65b6-2fe8-b078961a07d3@huawei.com>
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
To: lixiaokeng <lixiaokeng@huawei.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, Sep 02, 2020 at 03:23:42PM +0800, lixiaokeng wrote:
> In handle_args func, we donot check whether malloc paramp and
> each paramp->trnptid_list[j] fails before using them, it may
> cause access NULL pointer.
> 
> Here, we add alloc_prout_param_descriptor to allocate and init
> paramp, and we add free_prout_param_descriptor to free paramp
> and each paramp->trnptid_list[j].

This looks mostly fine to me. I have some minor nitpicks. But they
don't actually effect the correctness of the patch.

-Ben

> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  mpathpersist/main.c | 55 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 46 insertions(+), 9 deletions(-)
> 
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 28bfe410..f20c902c 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -153,6 +153,39 @@ static int do_batch_file(const char *batch_fn)
>  	return ret;
>  }
> 
> +static struct prout_param_descriptor *
> +alloc_prout_param_descriptor(int num_transportid)
> +{
> +	struct prout_param_descriptor *paramp;
> +
> +	if (num_transportid < 0 || num_transportid > MPATH_MX_TIDS)
> +		return NULL;
> +
> +	paramp= malloc(sizeof(struct prout_param_descriptor) +
> +				(sizeof(struct transportid *) * num_transportid));
> +
> +	if (!paramp)
> +		return NULL;
> +
> +	paramp->num_transportid = num_transportid;
> +	memset(paramp, 0, sizeof(struct prout_param_descriptor) +
> +			(sizeof(struct transportid *) * num_transportid));
> +	return paramp;
> +}
> +
> +static void free_prout_param_descriptor(struct prout_param_descriptor *paramp)
> +{
> +	int i;
> +	if (!paramp)
> +		return;
> +
> +	for (i = 0; i < paramp->num_transportid; i++)
> +		free(paramp->trnptid_list[i]);
> +
> +	free(paramp);

Setting paramp to NULL here doesn't actually do anything.

> +	paramp = NULL;
> +}
> +
>  static int handle_args(int argc, char * argv[], int nline)
>  {
>  	int c;
> @@ -525,9 +558,12 @@ static int handle_args(int argc, char * argv[], int nline)
>  		int j;
>  		struct prout_param_descriptor *paramp;
> 
> -		paramp= malloc(sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS )));
> -
> -		memset(paramp, 0, sizeof(struct prout_param_descriptor) + (sizeof(struct transportid *)*(MPATH_MX_TIDS)));

When looking at your patch, I noticed that this function has both
num_transport and num_transportids, but only num_transport is used,
while num_transportids is reported back to the user.  I realize that
this is only tangentially related to your patch, but if you could
combine these two varaiables, that would be helpful.

> +		paramp = alloc_prout_param_descriptor(num_transport);
> +		if (!paramp) {
> +			fprintf(stderr, "malloc paramp failed\n");
> +			ret = MPATH_PR_OTHER;
> +			goto out_fd;
> +		}
> 
>  		for (j = 7; j >= 0; --j) {
>  			paramp->key[j] = (param_rk & 0xff);
> @@ -551,6 +587,12 @@ static int handle_args(int argc, char * argv[], int nline)
>  			for (j = 0 ; j < num_transport; j++)
>  			{
>  				paramp->trnptid_list[j] = (struct transportid *)malloc(sizeof(struct transportid));
> +				if (!paramp->trnptid_list[j]) {
> +					fprintf(stderr, "malloc paramp->trnptid_list[%d] failed.\n", j);
> +					ret = MPATH_PR_OTHER;
> +					free_prout_param_descriptor(paramp);
> +					goto out_fd;
> +				}
>  				memcpy(paramp->trnptid_list[j], &transportids[j],sizeof(struct transportid));
>  			}
>  		}
> @@ -558,12 +600,7 @@ static int handle_args(int argc, char * argv[], int nline)
>  		/* PROUT commands other than 'register and move' */
>  		ret = __mpath_persistent_reserve_out (fd, prout_sa, 0, prout_type,
>  				paramp, noisy);
> -		for (j = 0 ; j < num_transport; j++)
> -		{
> -			tmp = paramp->trnptid_list[j];
> -			free(tmp);
> -		}
> -		free(paramp);
> +		free_prout_param_descriptor(paramp);
>  	}
> 
>  	if (ret != MPATH_PR_SUCCESS)
> -- 
