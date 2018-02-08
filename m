From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH v2 17/20] libmultipath: path latency: fix
 default base num
Date: Thu, 8 Feb 2018 20:03:48 +0800
Message-ID: <85e136a2-fbb8-e9fd-543b-74d6b87d8424@huawei.com>
References: <20180113211938.31552-1-mwilck@suse.com>
	<20180113211938.31552-18-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-18-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, niuhaoxin <niuhaoxin@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>
List-Id: dm-devel.ids

Looks Good.

Reviewed-by Guan Junxiong <guanjunxiong@huawei.com>

On 2018/1/14 5:19, Martin Wilck wrote:
> I don't think anyone can measure latency to 1% accuracy. It's
> better to not even pretend to be able to. 10% should be fine
> even for the most latency-critical environments.
> ---
>  libmultipath/prioritizers/path_latency.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
> index 9d5397ec1b3a..b8c5bc7c50a4 100644
> --- a/libmultipath/prioritizers/path_latency.c
> +++ b/libmultipath/prioritizers/path_latency.c
> @@ -42,8 +42,9 @@
>  #define DEF_IO_NUM		100
>  
>  #define MAX_BASE_NUM		10
> -#define MIN_BASE_NUM		1.01
> -#define DEF_BASE_NUM		1.5
> +#define MIN_BASE_NUM		1.1
> +// This is 10**(1/4). 4 prio steps correspond to a factor of 10.
> +#define DEF_BASE_NUM		1.77827941004
>  
>  #define MAX_AVG_LATENCY		100000000.	/* Unit: us */
>  #define MIN_AVG_LATENCY		1.		/* Unit: us */
> 
