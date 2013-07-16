From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 18/30] Update multipath.conf.defaults
Date: Wed, 17 Jul 2013 00:01:03 +0200
Message-ID: <51E5C29F.1060902@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>, device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: dm-devel.ids

Hi,

> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipath.conf.defaults | 110 +++++++++++++++++++++++++++---------------------
>  1 file changed, 62 insertions(+), 48 deletions(-)
> 
> diff --git a/multipath.conf.defaults b/multipath.conf.defaults
> index cd13369..f278f1f 100644
> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -4,6 +4,7 @@
>  #defaults {
>  #	verbosity 2
>  #	polling_interval 5
> +#	multipath_dir "/lib64/multipath"

multipath_dir should be removed, it's generated at compile time.

/lib64/multipath -> for 64bit
/lib/multipath -> for 32bit
