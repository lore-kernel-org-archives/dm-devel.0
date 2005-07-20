From: h4x3r <h4x3r@triad.rr.com>
Subject: Fedora cdrom issues ...
Date: Tue, 19 Jul 2005 21:18:47 -0400
Message-ID: <1121822327.4334.5.camel@908kc2RHrV.qIFnWDaIuu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

Hello,

Bug issue w/ your name on it.

$ uname -a
Linux xxx.xxx 2.6.12-1.1435_FC5smp #1 SMP Sun Jul 17 18:33:39 EDT 2005
i686 i686 i386 GNU/Linux

hdb is a CDROM CD486-H Cyberdrive w/ firmware updated by Hewlett-Packard

device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 8
Buffer I/O error on device hdb, logical block 1
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 16
Buffer I/O error on device hdb, logical block 2
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 24
Buffer I/O error on device hdb, logical block 3
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 32
Buffer I/O error on device hdb, logical block 4
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 40
Buffer I/O error on device hdb, logical block 5
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 48
Buffer I/O error on device hdb, logical block 6
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 56
Buffer I/O error on device hdb, logical block 7
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 1024768
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 8
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 16
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 24
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 32
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 40
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 48
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 56
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 1024768
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0

Sorry, I just copied everything that appeared in my log
doesnt really tell me a whole lot but, I have reported this bug before
on bugzilla https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=138119

Regards,
