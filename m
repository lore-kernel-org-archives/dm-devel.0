From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 14/14] multipathpersist: delete unused
 variable in handle_args
Date: Thu, 10 Sep 2020 20:50:10 +0200
Message-ID: <9d263718209e39bee19a21e26075bcccadf91888.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<3b8dc5f8-2fbc-e051-7151-d39308c4aa44@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3b8dc5f8-2fbc-e051-7151-d39308c4aa44@huawei.com>
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

On Thu, 2020-09-10 at 18:54 +0800, lixiaokeng wrote:
> In handle_args, the tmp isn't used. We delete it.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


> ---
>  mpathpersist/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index da67c15c..85453ac2 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -211,7 +211,6 @@ static int handle_args(int argc, char * argv[],
> int nline)
>  	int prout_sa = -1;
>  	char *batch_fn = NULL;
>  	void *resp = NULL;
> -	struct transportid * tmp;
> 
>  	memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct
> transportid));
> 
