From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: add HSV3[46]0 to
	multipath.conf.defaults
Date: Tue, 22 Jan 2013 13:09:24 +0100
Message-ID: <1358856564.1739.0.camel@lapoo.opensvc.com>
References: <1358855343-3160-1-git-send-email-xose.vazquez@gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358855343-3160-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On mar., 2013-01-22 at 12:49 +0100, Xose Vazquez Perez wrote:
> Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: dm-devel@redhat.com
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipath.conf.defaults | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
Applied.

> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> index c9f58d5..ad32343 100644
> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -151,7 +151,7 @@
>  #	}
>  #	device {
>  #		vendor "(COMPAQ|HP)"
> -#		product "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0"
> +#		product "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0"
>  #		path_grouping_policy "group_by_prio"
>  #		path_checker "tur"
>  #		features "0"
