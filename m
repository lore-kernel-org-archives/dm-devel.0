From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 01/33] multipathd.service: fixup Wants= and
 Before= statements
Date: Mon, 13 Mar 2017 18:06:05 -0500
Message-ID: <20170313230605.GG3421@octiron.msp.redhat.com>
References: <20170228162329.14517-1-mwilck@suse.com>
	<20170228162329.14517-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170228162329.14517-2-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 28, 2017 at 05:22:57PM +0100, Martin Wilck wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> With the latest LVM2 update we now have the 'lvm2-lvmetad.service'.
> Also we need to specify 'blk-availability.service' in the 'Before='
> statement, as just adding it to 'Wants=' assumes the multipathd
> service should be running after the blk-availability service.

As far as I can tell, The Before= command only says that if the other
unit is started, this one will be started first. It doesn't take the
place of Wants= or Requires=. So I think we should keep that Wants=
line.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  multipathd/multipathd.service | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
> index d26577f3..be13138c 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service
> @@ -1,10 +1,9 @@
>  [Unit]
>  Description=Device-Mapper Multipath Device Controller
> -Before=iscsi.service iscsid.service lvm2-activation-early.service
> -Before=local-fs-pre.target systemd-udev-trigger.service
> +Before=iscsi.service iscsid.service lvm2-lvmetad.service lvm2-activation-early.service
> +Before=local-fs-pre.target systemd-udev-trigger.service blk-availability.service
>  After=multipathd.socket systemd-udevd.service
>  DefaultDependencies=no
> -Wants=local-fs-pre.target multipathd.socket blk-availability.service
>  Conflicts=shutdown.target
>  
>  [Service]
> -- 
> 2.11.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
