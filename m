From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath: change default configuration
	parameters
Date: Tue, 15 Jan 2013 23:14:09 +0100
Message-ID: <50F5D4B1.5070508@gmail.com>
References: <20130108053459.GU19059@ether.msp.redhat.com>
	<50EEFB87.1060707@gmail.com>
	<1358283765.3854.1.camel@lapoo.opensvc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358283765.3854.1.camel@lapoo.opensvc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 01/15/2013 10:02 PM, Christophe Varoqui wrote:

> I pushed a patch to resync the multipath.conf.defaults using the
> "multipathd show config" output.

> --- a/multipath.conf.defaults
> +++ b/multipath.conf.defaults
> @@ -2,775 +2,863 @@
>  # overwrite these values in your config file.
>  
>  #defaults {
> -#      udev_dir                /dev
> -#      polling_interval        5
> -#      path_selector           "round-robin 0"
> -#      path_grouping_policy    failover
> -#      getuid_callout          "/lib/udev/scsi_id --whitelisted --device=/dev/%n"

scsi_id is going to be replaced in systemd(recently udev was
included in systemd).

See sg_inq(--export option) from sg3_utils.
