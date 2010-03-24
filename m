From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Status of dm integrity checksumming features
Date: Wed, 24 Mar 2010 18:39:20 +0200
Message-ID: <20100324163920.GM1878@reaktio.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hello,

What's the current status of Linux device mapper integrity (checksumming) features? 

iirc bio integrity extensions were integrated into Linux 2.6.27, but those are only
usable for SCSI disks that provide 520-bytes per sector support and also have the 
hardware support for verifying the checksums, correct? Or then you need to have a HBA
or RAID-adapter with integrity support..

(bio integrity patches: http://kerneltrap.org/mailarchive/linux-kernel/2008/6/7/2056354)

Is it possible to use 'normal' 512-bytes per sectors disks, and store the checksums
on them, and calculate/verify the checkcums in software in device mapper.. 
this obviously gives you a bit less usable space, but would be suitable for sw-raid scenarios. 

I guess that sounds pretty much like dm-csum:
https://patchwork.kernel.org/patch/25245/

What's the status of all this nowadays? 

Thanks!

-- Pasi
