From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 2/4] libmultipath/discovery: modify NVMe path
 states
Date: Fri, 15 Sep 2017 18:00:16 +0800
Message-ID: <6fc42f4a-6fff-72c0-e724-714f33da4a53@huawei.com>
References: <1505457030-119611-1-git-send-email-hare@suse.de>
	<1505457030-119611-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505457030-119611-3-git-send-email-hare@suse.de>
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
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, "Shenhong (C)" <shenhong09@huawei.com>, niuhaoxin <niuhaoxin@huawei.com>
List-Id: dm-devel.ids



On 2017/9/15 14:30, Hannes Reinecke wrote:
> The NVMe path states 'resetting' and 'reconnecting' indicate that
> the controller could not talk to the namespace, which translates
> into a path down state, not a path pending state.
> Path pending should only be used for short lived intermediate states
> like 'new' or 'deleting'.
> I agree with the statements --Path pending should only be used for short
lived intermediate states. But it's better to schedule path state checking
so soon as possible in the next second for  "resetting" and "reconnecting"
states  because those two states is transient in a short time.
How about introducing a new state for multipath: PATH_TRANSITING to distinguish
PATH_PENDING?

PATH_TRANSITING should also  schedule path state checking
so soon as possible in the next second.

Thanks
Guan

> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmultipath/discovery.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 95c138b..a880f4b 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1449,8 +1449,7 @@ path_offline (struct path * pp)
>  		}
>  		pp->offline = 0;
>  		if (!strncmp(buff, "new", 3) ||
> -		    !strncmp(buff, "reconnecting", 12) ||
> -		    !strncmp(buff, "resetting", 9))
> +		    !strncmp(buff, "deleting", 8))
>  			return PATH_PENDING;
>  		else if (!strncmp(buff, "live", 4))
>  			return PATH_UP;
> 
