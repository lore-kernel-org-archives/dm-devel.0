From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 11/14] mpathpersist: check whether malloc
 paramp->trnptid_list fails in handle_args func
Date: Thu, 10 Sep 2020 20:40:57 +0200
Message-ID: <4c55ba6dcf80faed5859f9e8b6ed71ca49beaed1.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<3f34cd14-17a0-f7a4-6cdb-7a37aa5c31b4@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3f34cd14-17a0-f7a4-6cdb-7a37aa5c31b4@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Thu, 2020-09-10 at 18:52 +0800, lixiaokeng wrote:
> In handle_args func, we donot check whether malloc paramp and
> each paramp->trnptid_list[j] fails before using them, it may
> cause access NULL pointer.
> 
> Here, we add alloc_prout_param_descriptor to allocate and init
> paramp, and we add free_prout_param_descriptor to free paramp
> and each paramp->trnptid_list[j].
> 
> We change num_transport to num_transportids to combine them.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  mpathpersist/main.c | 65 ++++++++++++++++++++++++++++++++++---------
> --
>  1 file changed, 50 insertions(+), 15 deletions(-)
> 
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index 28bfe410..da67c15c 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -153,6 +153,38 @@ static int do_batch_file(const char *batch_fn)
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
> +				(sizeof(struct transportid *) *
> num_transportid));
> +
> +	if (!paramp)
> +		return NULL;
> +
> +	paramp->num_transportid = num_transportid;
> +	memset(paramp, 0, sizeof(struct prout_param_descriptor) +
> +			(sizeof(struct transportid *) *
> num_transportid));

Here you overwrite paramp->num_transportid, which you just set.
Otherwise, the patch looks ok.

Regards,
Martin
