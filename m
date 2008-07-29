From: Sajesh Singh <ssingh@amnh.org>
Subject: Re: Strange DM issue on boot
Date: Tue, 29 Jul 2008 10:47:24 -0400
Message-ID: <488F2D7C.9090905@amnh.org>
References: <156D04C1A9F47A40BBAE9554FDC7CD7802568F08@3parm3.hq.3pardata.com>
Reply-To: ssingh@amnh.org, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <156D04C1A9F47A40BBAE9554FDC7CD7802568F08@3parm3.hq.3pardata.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids



Charles Polk wrote:
> The controllers are not happy with the panging on the controllers.
>
>   
Should I not be using the default settings in the /etc/multipath.conf? 
Are there any specific settings that need to be configured to use 
multipathd with an HDS AMS1000 array?

> ----- Original Message -----
> From: dm-devel-bounces@redhat.com <dm-devel-bounces@redhat.com>
> To: dm-devel@redhat.com <dm-devel@redhat.com>
> Sent: Mon Jul 28 13:54:52 2008
> Subject: [dm-devel] Strange DM issue on boot
>
> EL 5.2
> Hitachi AMS1000 array
> Qlogic HBA (qla2xxx driver)
>
> I am seeing a strange issue when rebooting a server connected to the 
> AMS1000 disk array. If I have a mount point defined in /etc/fstab that 
> points to a mulitpathe device I receive the following error:
>
> error calling out /sbin/mpath_prio_hds_modular 8:32
>
> That error would seem to indicate a path failure, but if I remove the 
> entry from /etc/fstab and reboot I am able to mount the device from the 
> command line. I have tried to include the qlogic driver in the initrd, 
> but that did help in any way. Are the dm-multipath drivers loading at 
> the incorrect time? Has anyone ever encountered this before?
>
> Regards,
>
> Sajesh
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>   
