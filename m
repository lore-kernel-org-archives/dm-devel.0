From: egoggin@emc.com
Subject: RE: Multipathing with RHEL4 U2 on EMC DMX
Date: Thu, 16 Feb 2006 17:05:19 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321B02C@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

on Thursday, February 16, 2006 4:09 PM Child, David wrote:

> 3. At this point auto-discovery of the paths worked, but my 
> device files
> were called things like: SEMC_____SYMMETRIX______790367051000. That
> didn't look useful so I added the following to /etc/multipath.conf;
> 	multipaths {
> 		multipath {
> 			wwid
> SEMC_____SYMMETRIX______790367051000
> 			alias                   sym051mp
> 		}
> 		<repeat for each LUN>
> 	}

The upstream version of scsi_id kept within udev is changed to support
retrieving a device UID from older model (4, 5, and 6) Symmetrix storage
arrays via the new scsi_id option "pre-spc3-83".  Red Hat may have a version
of the udev RPM for update 2 with this change.

Setting up the Symmetrix device entry in /etc/multipath.conf to also use
this option "-ppre-spc3-83" will cause dm multipath to generate mapped
device names for Symmetrix logical units which do not have the vendor/model
prefix.

Both of these changes are in SuSE SLES 9 SP3 and it works as stated above.
