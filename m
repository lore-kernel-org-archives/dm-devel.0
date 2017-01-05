From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] Tolerate modprobe failures in
 multipathd.service
Date: Thu, 5 Jan 2017 09:30:10 -0600
Message-ID: <20170105153010.GN2732@octiron.msp.redhat.com>
References: <CACqULmOaE9MwhLmczZWCcFBPAHim5kYnBMCbgXNnYBUCQvjneQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACqULmOaE9MwhLmczZWCcFBPAHim5kYnBMCbgXNnYBUCQvjneQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Anthony Ryan <anthonyryan1@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 05, 2017 at 08:33:10AM -0500, Anthony Ryan wrote:
> When these modules are built statically into the kernel, modprobe
> will fail and prevent the service from being started. By making this
> line non-fatal, on such systems the service is still able to be
> started.

ACK

-Ben

> ---
>  multipathd/multipathd.service | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
> index e3d6f91..d26577f 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service
> @@ -11,7 +11,7 @@ Conflicts=shutdown.target
>  Type=notify
>  NotifyAccess=main
>  LimitCORE=infinity
> -ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac
> dm-multipath
> +ExecStartPre=-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac
> dm-multipath
>  ExecStart=/sbin/multipathd -d -s
>  ExecReload=/sbin/multipathd reconfigure
> 
> -- 
> 2.11.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
