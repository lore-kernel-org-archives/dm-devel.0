From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: Re: [dm- devel][PATCH V2]
Date: Wed, 29 Jul 2020 09:54:27 +0800
Message-ID: <beea69eb-ecc9-1bc7-2fdc-5925c86fde9d@huawei.com>
References: <b444af45-dbc3-2525-066f-4475efdc1a57@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b444af45-dbc3-2525-066f-4475efdc1a57@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmarzins@redhat.com, mwilck@suse.com, hare@suse.de, christophe.varoqui@opensvc.com, kabelac@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, yanxiaodan@huawei.com, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

Sorry for forgetting to add a subject.
I will resend the v2 patch.

On 2020/7/29 9:52, Zhiqiang Liu wrote:
> 
> In disassemble_status func, for dealing with selector args,
> word is allocated by get_word func. However, word is not freed.
> Then a memory leak occurs.
> 
> Here, we call FREE(word) to free word.
> 
> Fixes: 35ad40b4 ('leastpending IO loadbalancing is not displayed properly')
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/dmparser.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 3dc77242..33f47405 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -580,10 +580,15 @@ int disassemble_status(char *params, struct multipath *mpp)
>  				if (!strncmp(mpp->selector,
>  					     "least-pending", 13)) {
>  					p += get_word(p, &word);
> +
> +					if (!word)
> +						return 1;
> +
>  					if (sscanf(word,"%d:*d",
>  						   &def_minio) == 1 &&
>  					    def_minio != mpp->minio)
>  							mpp->minio = def_minio;
> +					FREE(word);
>  				} else
>  					p += get_word(p, NULL);
>  			}
> 
