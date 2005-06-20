From: "goggin, edward" <egoggin@emc.com>
Subject: syslog overlog?
Date: Mon, 20 Jun 2005 11:52:59 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AAD5@SRMANNING.eng.emc.com>
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Lots of page writeback io errors can tie up a system with syslog writing
mostly
dm-mpath messages to its log files if KERN_WARNING is directed to do so.

In my use case, I had a bunch of Symmetrix LUs with read-only access being
written to via dd to the block device file system.  The resulting write
behind
errors were using up lots of cpu time writing on average 50 dm-mpath syslog
warning messages for each scsi disk io error message logged.  This
multiplier
reflected the average bio coalescence rate during this period for the 4k
bios.

Not clear if this is a concern or not ... just thought I would mention it
since 
syslog burned us before.
