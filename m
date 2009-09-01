From: malahal@us.ibm.com
Subject: Re: Removing a failed device from LVM2/DM
Date: Tue, 1 Sep 2009 15:47:04 -0700
Message-ID: <20090901224704.GA23179@us.ibm.com>
References: <1251731770.6817.31.camel@cail> <1251821775.5459.21.camel@cail>
	<20090901162537.GA15197@us.ibm.com>
	<1251830539.5459.135.camel@cail>
	<20090901190843.GA18641@us.ibm.com>
	<1251838679.5459.148.camel@cail>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1251838679.5459.148.camel@cail>
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

Alan D. Brunelle [Alan.Brunelle@hp.com] wrote:
> Unfortunately:
> 
> # rm -rf /etc/lvm/cache
> 
> # vgscan
>   Reading all physical volumes.  This may take a while...
>   /dev/disk/by-id/scsi-360060b0000837a508c01035ef0d00033: read failed
> after 0 of 512 at 0: Input/output error
>   /dev/disk/by-id/scsi-360060b0000837a508c01035ef0d00033: read failed
> after 0 of 512 at 291347562496: Input/output error
>   /dev/disk/by-id/scsi-360060b0000837a508c01035ef0d00033: read failed
> after 0 of 512 at 291347632128: Input/output error
>   /dev/disk/by-id/scsi-360060b0000837a508c01035ef0d00033: read failed
> after 0 of 512 at 0: Input/output error
>   /dev/disk/by-id/scsi-360060b0000837a508c01035ef0d00033: read failed
> after 0 of 512 at 4096: Input/output error
>   /dev/disk/by-id/scsi-360060b0000837a508c01035ef0d00033: read failed
> after 0 of 2048 at 0: Input/output error
>   Found volume group "vg" using metadata type lvm2

Looks like you have some symbolic links that point to a dead device.
Change your filter to accept devices appropriately, maybe like below
(untested!).

filter = [ "r|sdab|", a|/dev/sd|", "r|.*|" ]

The above filter would avoid looking at /dev/disk/by-id and other
unneeded directories.

Thanks, Malahal.
