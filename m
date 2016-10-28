From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Remove duplicated code in
 mpath_alloc_prin_response()
Date: Fri, 28 Oct 2016 08:16:18 -0700
Message-ID: <4109416b-9d3c-9b31-90bc-1f8695d9aca9@sandisk.com>
References: <1477383563-10684-1-git-send-email-ding.yemin@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477383563-10684-1-git-send-email-ding.yemin@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ding.yemin@zte.com.cn, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On 10/25/2016 01:19 AM, ding.yemin@zte.com.cn wrote:
>  	}
> +	if (size > 0)
> +	{
> +		ptr = malloc(size);
> +		if (ptr)
> +		{
> +			memset(ptr, 0, size);
> +		}
> +	}
>  	return ptr;
>  }

Hello Ding Yemin,

Please use calloc() instead of open coding it.

Thanks,

Bart.
