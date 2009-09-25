From: John Hughes <john@Calva.COM>
Subject: Dell MD3000/multipath - huge numbers of I/O errors on
	boot
Date: Fri, 25 Sep 2009 15:45:20 +0200
Message-ID: <4ABCC970.70603@Calva.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've got a Dell MD3000 SAS cabinet, connected with two SAS cables using 
multipathd/dm-multipath.

Most things work fine, but one problem I have is that the MD3000 wants 
to do failover, it gets very shirty if I access the "ghost" path to a 
LUN without doing some RDAC fancyness.

The problem is that when the kernel discovers each LUN it tries to read 
the partition table, which produces insane numbers of read failures on 
boot.  How can I silence them?

[  236.136435] scsi 4:0:0:14: Direct-Access     DELL     MD3000           0735 PQ: 0 ANSI: 5
[  236.158631] sd 4:0:0:14: [sdav] 142323712 512-byte hardware sectors: (72.8 GB/67.8 GiB)
[  236.158950] sd 4:0:0:14: [sdav] Write Protect is off
[  236.159035] sd 4:0:0:14: [sdav] Mode Sense: 77 00 10 08
[  236.159456] sd 4:0:0:14: [sdav] Write cache: enabled, read cache: enabled, supports DPO and FUA
[  236.159888] sd 4:0:0:14: [sdav] 142323712 512-byte hardware sectors: (72.8 GB/67.8 GiB)
[  236.160199] sd 4:0:0:14: [sdav] Write Protect is off
[  236.160285] sd 4:0:0:14: [sdav] Mode Sense: 77 00 10 08
[  236.160679] sd 4:0:0:14: [sdav] Write cache: enabled, read cache: enabled, supports DPO and FUA
[  236.161450] sd 4:0:0:14: [sdav] Attached SCSI disk
[  236.161546] sd 4:0:0:14: Embedded Enclosure Device
[  236.368374] sd 4:0:0:14: Attached scsi generic sg49 type 0
...
[  240.579148] sd 3:0:1:14: [sdaf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[  240.579323] sd 3:0:1:14: [sdaf] Sense Key : Illegal Request [current] 
[  243.792964] sd 3:0:1:14: [sdaf] <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
[  245.265769] sd 3:0:1:14: [sdaf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[  245.265940] sd 3:0:1:14: [sdaf] Sense Key : Illegal Request [current] 
[  245.266215] sd 3:0:1:14: [sdaf] <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
[  245.825586] sd 3:0:1:14: [sdaf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[  245.825752] sd 3:0:1:14: [sdaf] Sense Key : Illegal Request [current] 
[  245.826017] sd 3:0:1:14: [sdaf] <<vendor>> ASC=0x94 ASCQ=0x1ASC=0x94 ASCQ=0x1
... [ MANY MANY ERRORS REMOVED ]
[  303.486849] sd 3:0:1:14: rdac: LUN 14 (unowned)
[  303.494695] sd 4:0:0:14: rdac: LUN 14 (owned)

# multipath -ll 
...
mpath43 (360024e80005b3b23000001b94ab0587f) dm-30 DELL    ,MD3000        
[size=68G][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][active]
 \_ 4:0:0:14 sdav 66:240 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 3:0:1:14 sdaf 65:240 [active][ghost]
...
