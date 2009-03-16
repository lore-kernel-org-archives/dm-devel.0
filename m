From: "dushyanth.h@directi.com" <dushyanth.h@directi.com>
Subject: Multipath failover issues
Date: Mon, 16 Mar 2009 21:51:48 +0530
Message-ID: <49BE7C9C.8020100@directi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi guys,

Iam using dm-multipath for a Infortrend dual controller F16F-R4031-6 FC
system.

Version details are :

device-mapper-multipath-0.4.7-17.el5
device-mapper-1.02.24-1.el5
device-mapper-event-1.02.24-1.el5

OS : Red Hat Enterprise Linux Server release 5.2 (Tikanga)
Kernel : 2.6.18-92.1.10.el5 #1 SMP x86_64 x86_64 x86_64

Recently, one of the RAID controllers failed and caused multipath to
fail both active paths

device-mapper: multipath: Failing path 8:32.
sd 2:0:0:0: SCSI error: return code = 0x00020000
end_request: I/O error, dev sdd, sector 1976776672
device-mapper: multipath: Failing path 8:48.
sd 2:0:0:0: SCSI error: return code = 0x00020000
end_request: I/O error, dev sdd, sector 1967432880
sd 2:0:0:0: SCSI error: return code = 0x00020000
end_request: I/O error, dev sdd, sector 161647296

This caused the ext3 filesystem to go into a read only mode. Full IO
errors is at http://pastebin.com/m103325d9

The dual controller storage unit and the host server (Only 1 Server
using 2 Qlogic FC HBAs) are hooked upto two different Qlogic SanBox FC
switch for redundancy.

multipath.conf : http://pastebin.com/m4c7da817
multipath -v4 -ll : http://pastebin.com/m7d863925

I have checked the logs on the FC switch and the HBAs
and i dont see any event which suggest both paths failed at once. Even
the errors i captured out of dmesg show that one of the physical disks
that makes up dm-0 had 'end_request: I/O errors' while the other did not
have any such error.

sd 2:0:0:0: SCSI error: return code = 0x00020000
end_request: I/O error, dev sdd, sector 1967432880
sd 2:0:0:0: SCSI error: return code = 0x00020000
end_request: I/O error, dev sdd, sector 161647296

At this point iam wondering how paths 8:32 and 8:48 failed together -
considering both paths are through two different FC switches. Any
suggestions on this ?

Additionaly, I have looked at the mailing list archives & annotated conf
files and found two options a) failback and b) no_path_retry. What would
be the best recommended values for these on a dual controller setup like
mine ?

It would also be helpful if someone could share infotrend specific
settings multipath settings.

TIA
Dushyanth
