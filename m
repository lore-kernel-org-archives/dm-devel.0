From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: [PATCH] multipath-tools: document why dev_loss_tmo
 is set to infinity for HPE 3PAR
Date: Wed, 12 Dec 2018 13:44:03 -0600
Message-ID: <CAAMCDednRXQqf9hgW5kKNSEoFgVjW21BQv3FmVUSVQTiXoQk8Q@mail.gmail.com>
References: <20181212165833.12407-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181212165833.12407-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: xose.vazquez@gmail.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On thing that seems to be a mess with the tmo value that is being
inherited from the underlying driver, is that the setting for the scsi
layer is significantly different from what multipath calls TMO.

In the case I have seen with the lpfc driver this is often set fairly
low (HPE's doc references 14 seconds, and this is similar to what my
employer is using).
parm:           lpfc_devloss_tmo:Seconds driver will hold I/O waiting
for a device to come back (int)

But setting this on the scsi layer causes it to quickly return an
error to the multipath layer.  It does not mean that the scsi layer
removes the device from the system, just that it returns an error so
that the layer above it can deal with it.   The multipath layer
interprets its value of TMO as when to clean up/remove the underlying
path that when dev_loss_tmo is hit.    TMO is used in both names, but
they are not the same usage and meaning and the scsi layer's TMO
should not be inherited by the multipath layer, as they don't appear
to actually be the same thing.   In multipath it should probably be
called remove_fault_paths or something similar.

This incorrect inheritance has caused issues, as prior to multipath
inheriting TMO from the scsi layer, multipath did not remove the paths
when IO failed for TMO time.   The paths prior to the inheritance
stayed around and errored until the underlying issue was fixed, or a
reboot happened, or until someone manually removed the failing paths.
When I first saw this I had processes to deal with this, and we did
noticed when it stated automatically cleaning up paths and it was good
since it eliminated manual work, that is until it caused issues during
firmware update.  HPE's update to infinity will be a response to the
inherited TMO change causing issues.

On Wed, Dec 12, 2018 at 10:58 AM Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
>
> It's needed by Peer Persistence, documented in SLES and RHEL guides:
> https://support.hpe.com/hpsc/doc/public/display?docId=a00053835
> https://support.hpe.com/hpsc/doc/public/display?docId=c04448818
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index d3a8d9b..543bacd 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -116,6 +116,7 @@ static struct hwentry default_hw[] = {
>                 .prio_name     = PRIO_ALUA,
>                 .no_path_retry = 18,
>                 .fast_io_fail  = 10,
> +               /* infinity is needed by Peer Persistence */
>                 .dev_loss      = MAX_DEV_LOSS_TMO,
>         },
>         {
> --
> 2.19.2
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
