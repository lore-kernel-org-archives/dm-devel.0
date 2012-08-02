From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: SCSI disk IO problem with JBOD/multipath
Date: Wed, 1 Aug 2012 20:51:34 -0400
Message-ID: <20120802005134.GA26766@redhat.com>
References: <5019B510.4000707@soe.ucsc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5019B510.4000707@soe.ucsc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Erich Weiler <weiler@soe.ucsc.edu>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 01 2012 at  7:00pm -0400,
Erich Weiler <weiler@soe.ucsc.edu> wrote:
 
> So then I had the idea to compile the RDAC multipathing driver and
> create a new initrd that preloads the RDAC driver:
> 
> mkinitrd /boot/initrd-$(uname -r)-scsi_dh.img $(uname -r)
> --preload=scsi_dh_rdac
> 
> Then I booted with that.  It actually did not crash this time, but
> did spew a *ton* of SCSI errors on boot, like these (from dmesg):

snip...

The log you provided does not indicate that the scsi_dh_rdac driver
was actually loaded at boot.

Please add "rdloaddriver=scsi_dh_rdac" to your kernel command line and
see if that helps with all the IO errors you're seeing at boot.
 
> etc, etc, thousands of times.  Just for fun I then tried to tie it
> together with multipathd, using this config:
> 
> defaults {
>       udev_dir                /dev
>       polling_interval        5
>       path_grouping_policy    failover
>       getuid_callout          "/lib/udev/scsi_id --whitelisted
> --device=/dev/%n"
>       path_checker            directio
>       prio                    const
>       rr_min_io               1000
>       rr_weight               uniform
>       failback                manual
>       no_path_retry           fail
>       user_friendly_names     yes
> }
> 
> blacklist {
>       devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>       devnode "^hd[a-z]
>       # Blacklist the root disk (/dev/sda) by wwid - Find the wwid
> via "/lib/udev/scsi_id --page=0x83 --whitelisted --device=/dev/sda"
>       wwid "3600508e000000000c3c8e073ff8f3b0c"
>       devnode "^dcssblk[0-9]*"
> }
> 
> devices {
>       device {
>               vendor                  "*"
>               product                 "*"
>               getuid_callout          "/lib/udev/scsi_id
> --whitelisted --device=/dev/%n"
>               path_selector           "round-robin 0"
>               path_grouping_policy    failover
>               failback                immediate
>               rr_weight               priorities
>               no_path_retry           5
>               rr_min_io               1000
>               path_checker            tur
>               prio                    const
>       }
> }

You're not specifying rdac in the multipath conf; therefore multipath
isn't going attach the rdac scsi_dh when each path is activated via
dm-mpath.

> And it *appears* to work:
> 
> # multipath -ll
> mpathak (35000c500418ae7db) dm-18 SEAGATE,ST33000651SS
> size=2.7T features='1 queue_if_no_path' hwhandler='0' wp=rw
> |-+- policy='round-robin 0' prio=1 status=active
> | `- 0:0:24:0  sdx  65:112 active ready running
> `-+- policy='round-robin 0' prio=1 status=enabled
>   `- 0:0:84:0  sdce 69:32  active ready running

Again, no hwhandler is being specified given: hwhandler='0'

> But I cannot write to the disks, I get I/O errors.  When I reboot I
> still get the thousands of SCSI errors on boot from mpt2sas, etc.
> I'm completely stuck.  Does anyone have any ideas?  Or, is there a
> better place to ask this question?

If you continue to have problems please escalate to Red Hat support and
point them to this mail.  They will triage and open a bug accordingly.
