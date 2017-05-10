From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 4/5] kpartx: default to running in sync mode
Date: Thu, 11 May 2017 00:42:27 +0200
Message-ID: <a6409045-02e1-643f-7c9c-b3bf13ebcfbc@gmail.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
	<1493073570-17167-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493073570-17167-5-git-send-email-bmarzins@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 04/25/2017 12:39 AM, Benjamin Marzinski wrote:

> When users run kpartx, they would naturally assume that when it
> completes, the devices have been created. However, kpartx runs in async
> mode by default.  This seems like it is likely to trip up users.  So,
> switch the default to sync mode, add a -n option to enable async mode,
> and set async mode when kpartx is called by the udev rules.
>[...]
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 58e60ff..d1edd5e 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
>[...]
> -static char short_opts[] = "rladfgvp:t:su";
> +static char short_opts[] = "rladfgvp:t:snu";
>[...]
> -	printf("\t-s sync mode. Don't return until the partitions are created\n");
> +	printf("\t-n nosync mode. Return before the partitions are created\n");
> +	printf("\t-s sync mode. Don't return until the partitions are created. Default.\n");
>  	return 1;
>[...]> +		case 'n':
> +			udev_sync = 0;
> +			break;

New flags should be documented in its man page.
