From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 14/14] multipathpersist: delete unused
 variable in handle_args
Date: Fri, 4 Sep 2020 19:14:25 -0500
Message-ID: <20200905001425.GJ11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<829f930f-f426-bcd6-602d-26959accaef7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <829f930f-f426-bcd6-602d-26959accaef7@huawei.com>
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

On Wed, Sep 02, 2020 at 03:26:29PM +0800, lixiaokeng wrote:
> In handle_args, the tmp isn't used. We delete it.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  mpathpersist/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> index f20c902c..ccf0024e 100644
> --- a/mpathpersist/main.c
> +++ b/mpathpersist/main.c
> @@ -213,7 +213,6 @@ static int handle_args(int argc, char * argv[], int nline)
>  	int num_transport =0;
>  	char *batch_fn = NULL;
>  	void *resp = NULL;
> -	struct transportid * tmp;
> 
>  	memset(transportids, 0, MPATH_MX_TIDS * sizeof(struct transportid));
> 
> -- 
