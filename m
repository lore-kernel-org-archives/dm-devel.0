From: "Aditya Vasudevan" <aditya.vasudevan@patni.com>
Subject: device mapper : supported features
Date: Tue, 26 Dec 2006 09:05:22 +0530
Message-ID: <200612260332.kBQ3WhT2022644@spzha1.patni.com>
Reply-To: aditya.vasudevan@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1167103966-5526-236"
Return-path: <dm-devel-bounces@redhat.com>
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

This is a multi-part message in MIME format...

------------=_1167103966-5526-236
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, 

I am moving from a propriety multipathing solution to device mapper.

I wanted to know which of the following features would not work on device
mapper (if any).

Any information is highly appreciated.

1. host interface types - support for SCSI/iSCSI/FC/SA
2. Maximum Path per LUN - 32 paths per LUN (logical drive)
3. Load Balancing - Round Robin with Subset
			- Dynamic Least Queue Depth
			- Weighted Paths
			- Least Blocks
			- round robin the IO between the paths of the two
controllers 
4. Support for SCSI PASS THROUGH IOCTL
5. SCSI Command Support - support for all the SCSI commands passed from the
other layers to the Subsystems, including standard SCSI commands and Vendor
Specific Commands, regardless of the Command Operation Code or CDB Length
etc.
6. Protocol and HBA Agnostic - It must be protocol and HBA agnostic. It must
work with subsystems supporting the following host IO protocols of SCSI
(Ultra 160 and Ultra 320), iSCSI, FC (Fibre Channel) and SAS (Serial
Attached SCSI).
It must work with different kinds of HBAs
7. Single Controller Multipathing - support for multipathing through the
multiple host IO ports  which are only installed with single controller
8. Dual Controller Multipathing - support for multipathing through the
multiple host IO ports offered by dual controllers
9. Active-Standby - support for multipathing for the dual controllers
operate in Active-Standby mode.
10. Symmetric Active-Active - support for multipathing for the dual
controllers operate in Symmetric Active-Active mode.
11. Asymmetric Active-Active- support for multipathing for the dual
controllers operate in Asymmetric Active-Active mode.
12. Pseudo LUN - It shall treat the Pseudo LUN equally as it does for the
regular logical drives.
13. Tape Device Support - the user may insert tape
drives into the slots where we normally insert hard disk drives.
14. support for a redhat cluster
15. Support for :
Number of controller per subsystem (1-2),
Number of ports per controller (2-4)
16. Can I write my own prio_callout, load balancing algo, path_checker.

For the ones not supported, is it possible for users like us to implement it
by writing a specific module like the hardware handler, etc

I plan to use this on 2.6 kernel. I hope many of the above will work. 

I think device mapper is back ported on to 2.4 as well. Is it fully
functional because 2.4 didn't have udev, hotplug, sysfs etc..

Thanks !




http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail. 
_____________________________________________________________________

------------=_1167103966-5526-236
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------------=_1167103966-5526-236--
