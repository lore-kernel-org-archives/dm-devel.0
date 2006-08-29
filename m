From: "Adam Huffman" <adam.huffman@gmail.com>
Subject: Multipathd not starting up properly
Date: Tue, 29 Aug 2006 19:12:53 +0100
Message-ID: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

I'm seeing the following messages when I start multipathd:

Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s /block/sda
Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s /block/sdb

Here is the output of multipath -v 3:


load path identifiers cache
#
# all paths in cache :
#
  0:0:0:0 sda 8:0  [ready] Raidtec /JEFF            /0281
  0:0:1:0 sdb 8:16  [ready] Raidtec /JEFF            /0281
cciss!c0d0 blacklisted
dm-0 blacklisted
dm-1 blacklisted
dm-2 blacklisted
fd0 blacklisted
hda blacklisted
md0 blacklisted
ram0 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
===== path info sda (mask 0x1f) =====
bus = 1
dev_t = 8:0
size = 2929684480
vendor = Raidtec
product = JEFF
rev = 0281
h:b:t:l = 0:0:0:0
tgt_node_name = 0x20000010e9004510
serial = 11900002000010

path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
error calling out /sbin/scsi_id -g -u -s /block/sda
uid =  (callout)
===== path info sdb (mask 0x1f) =====
bus = 1
dev_t = 8:16
size = 2929684480
vendor = Raidtec
product = JEFF
rev = 0281
h:b:t:l = 0:0:1:0
tgt_node_name = 0x20000010e9004510
serial = 11900002000010

path checker = readsector0 (internal default)
state = 2
getprio = (null) (internal default)
prio = 1
getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
error calling out /sbin/scsi_id -g -u -s /block/sdb
uid =  (callout)
#
# all paths :
#
  0:0:0:0 sda 8:0 1 [ready] Raidtec /JEFF            /0281
  0:0:1:0 sdb 8:16 1 [ready] Raidtec /JEFF            /0281

I don't seem to be getting anything useful without this call out working.

Any suggestions appreciated.

Adam
