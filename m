From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] [device-mapper] Document the fact that
 iterate_device method shouldn't block.
Date: Fri, 21 Oct 2011 13:07:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110211306560.5163@hs20-bc2-1.build.redhat.com>
References: <20111021092800.GB4393@ubuntu>
	<1319192375-5048-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1319192375-5048-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Ack.

Mikulas

On Fri, 21 Oct 2011, Joe Thornber wrote:

> ---
>  include/linux/device-mapper.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index aa09503..8ceb13a 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -148,6 +148,10 @@ struct target_type {
>  	dm_ioctl_fn ioctl;
>  	dm_merge_fn merge;
>  	dm_busy_fn busy;
> +
> +	/*
> +	 * iterate_devices must not block.
> +	 */
>  	dm_iterate_devices_fn iterate_devices;
>  	dm_io_hints_fn io_hints;
>  
> -- 
> 1.7.5.4
> 
