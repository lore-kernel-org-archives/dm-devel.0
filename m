From: "Mark De Lange" <mark.deLange@crosswalkinc.com>
Subject: How do I determine the status of a dm device?
Date: Wed, 8 Nov 2006 15:54:25 -0700
Message-ID: <2E02749DAF5338479606A056219BE109014839D1@smail.crosswalkinc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

An example may illustrate the question better:

1)  I have 2 FC SCSI devices each with 2 paths.  dm_multipath will thus
create 2 dm devices.
2)  I create another dm device using the "striped" target and the
members are the 2 multipath devices.


The failure scenario:
1) the paths to my FC SCSI devices fail (e.g. the FC switch may be
powered down etc - it doesn't really matter as to the cause).
2) The SCSI disks will (eventually) be marked as failed/offline.
3) dm_multipath detects the failed paths and marks them as such.

The problem:
Other than the states in 2) and 3) above, there is no status information
maintained for dm devices (at least none that I can find - hence this
email).


System information:
RedHat X86_64 RHEL4 release (update 3)
QLogic FC HBA

Some configuration setup:
Output from "multipath -l"

mylun1 (3600a0b80001f4e5d00001c764517be04)
[size=3D18 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 1:0:1:2 sdg 8:96  [active][ready]
 \_ 2:0:1:2 sdo 8:224 [active][ready]

mylun2 (3600a0b80001f4e5d00001c744517bdba)
[size=3D18 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
\_ round-robin 0 [active]
 \_ 1:0:0:1 sdb 8:16  [active][ready]
 \_ 2:0:0:1 sdj 8:144 [active][ready]


Output from "dmsetup table"

mylun1: 0 533651456 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1
8:128 1280 65:0 1280 round-robin 0 2 1 8:64 1280 8:192 1280
mylun2: 0 819350994 multipath 1 queue_if_no_path 0 2 1 round-robin 0 2 1
8:48 1280 8:176 1280 round-robin 0 2 1 8:112 1280 8:240 1280
myvol1: 0 41943040 striped 2 256 253:0 10486144 253:1 10486144

Pointers/help on this will be greatly appreciated.
Thanks
Mark
