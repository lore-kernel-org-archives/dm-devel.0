From: Chip Coldwell <coldwell@redhat.com>
Subject: RE: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 09:57:32 -0400 (EDT)
Message-ID: <alpine.LRH.1.00.0803140951210.23740@bogart.boston.redhat.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
	<20080313214352.GA18433@us.ibm.com>
	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
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
Cc: Doug Gilbert <dougg@torque.net>
List-Id: dm-devel.ids

On Thu, 13 Mar 2008, lemons_terry@emc.com wrote:
> 
> Sorry, but doesn't scsi_id only return what it finds in SCSI VPD pages
> 80 or 83?  Not all devices provide a WWN in VPD page 83.

It's quite a bit more complicated than that.  If a WWN exists on VPD
pages 80 or 83, scsi_id will return that; otherwise it will synthesize
a serial number.

Doug Gilbert and I have exchange some correspondence on the subject of
unifying his lsscsi (and possibly sg3_utils), my scsitool and the udev
scsi_id utility.  At the moment, all of these are drawn from different
code bases.  Doug chose to design lsscsi to use only sysfs information
because he wanted it to be runnable as a non-privileged process.
That's both good and bad: sysfs is shifting sand to build a foundation
on, and so far there is no standard place in sysfs to retrieve a WWN.
Both scsi_id and sg3_utils use SG_IO to do a VPD 0x80/0x83 INQUIRY.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
