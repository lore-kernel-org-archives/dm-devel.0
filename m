From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath on boot and root partition with Redhat5.0
Date: Tue, 16 Oct 2007 16:27:33 -0500
Message-ID: <20071016212733.GD32092@ether.msp.redhat.com>
References: <470CB061.5000902@univ-tln.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <470CB061.5000902@univ-tln.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 10, 2007 at 12:58:41PM +0200, Sandrine Twardy wrote:
> Hello,
> 
> I have a SAN Eva 5000 HP And I have installed a redhat 5.0 on my server 
> with "linux mpath", so far all is fine.
> I have an os device multipathed as follow :
> 
> > multipath -ll
> mpath0 () dm-0 COMPAQ,HSV110 (C)COMPAQ
> [size=7.0G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][active]
> \_ 3:0:0:1 sdb 8:16  [active][ready]
> \_ 4:0:0:1 sdc 8:32  [active][ready]
> 
> But when I presents a new lun to my host and scans again the scsi lun, I 
> am losing the multipath on the disk (/ and /boot)
> (possibly because the name of device is changed from sdb/sdc to sdc/sde ? )
> 
> Here's an extract of my multipath.conf:
> 
> multipath {
>              wwid                    3600508b40000c1c50001c000000b0000
>              path_grouping_policy    group_by_serial
>              rr_weight               uniform
>              prio_callout            /bin/true
>              alias                   os_lun
>      }
>     But it's seems that on boot the mutlipath.conf file is not read.  
> Am I right?
> When the system is booted, multipathd cannot use the boot device ...
> What can I do to fix the boot device name persistence? Where is supposed 
> to be configuration file that defines the multipath options of the boot 
> device ?
> 
> Right now, the server can boot because my fstab is like this:
> LABEL=/1                /                      LABEL=/boot             
> /boot
> 
> Thanks you for your help

Multipathed root support in kind of rough in RHEL5.0.  It is much nicer in
5.1.  When you say "But when I presents a new lun to my host and scans again
the scsi lun, I am losing the multipath on the disk" do you mean that if
you add the lun, and rescan without rebooting, that you lose your root
filesystem?  If so, that's strange.  Multipath shouldn't remove the device if
it is currently being used.

Assuming that the problem happens on reboot, the best way to deal with it is to
get your multipaths set up the way you want, and remake the initrd with
mkinitrd.  You should save a backup of your old initrd, so that if there is a
problem with the new initrd, you can still boot your system with the old one.
You might even want to have a seperate grub.conf entry for each initrd.

-Ben

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
