From: Bryan Gurney <bgurney@redhat.com>
Subject: [PATCH v2] dm dust: convert documentation to ReST
Date: Mon,  7 Oct 2019 13:24:49 -0400
Message-ID: <1570469089-31554-1-git-send-email-bgurney@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-doc@vger.kernel.org, corbet@lwn.net
Cc: Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Convert the dm-dust documentation to ReST formatting, using literal
blocks for all of the shell command, shell output, and log output
examples.

Add dm-dust to index.rst.

Additionally, fix an annotation in the "querying for specific bad
blocks" section, on the "queryblock ... not found in badblocklist"
example, to properly state that the message appears when a given
block is not found.

Signed-off-by: Bryan Gurney <bgurney@redhat.com>

---

Changes since v1:

- Clean up the table parameters section of the dm-dust
  documentation to a description-list format.
- Condense literal block trailing colons where possible.
- Remove trailing colons from titles.
---
 .../{dm-dust.txt => dm-dust.rst}              | 243 ++++++++++--------
 .../admin-guide/device-mapper/index.rst       |   1 +
 2 files changed, 130 insertions(+), 114 deletions(-)
 rename Documentation/admin-guide/device-mapper/{dm-dust.txt => dm-dust.rst} (51%)

diff --git a/Documentation/admin-guide/device-mapper/dm-dust.txt b/Documentation/admin-guide/device-mapper/dm-dust.rst
similarity index 51%
rename from Documentation/admin-guide/device-mapper/dm-dust.txt
rename to Documentation/admin-guide/device-mapper/dm-dust.rst
index 954d402a1f6a..b6e7e7ead831 100644
--- a/Documentation/admin-guide/device-mapper/dm-dust.txt
+++ b/Documentation/admin-guide/device-mapper/dm-dust.rst
@@ -31,218 +31,233 @@ configured "bad blocks" will be treated as bad, or bypassed.
 This allows the pre-writing of test data and metadata prior to
 simulating a "failure" event where bad sectors start to appear.
 
-Table parameters:
------------------
+Table parameters
+----------------
 <device_path> <offset> <blksz>
 
 Mandatory parameters:
-    <device_path>: path to the block device.
-    <offset>: offset to data area from start of device_path
-    <blksz>: block size in bytes
+    <device_path>:
+        Path to the block device.
+
+    <offset>:
+        Offset to data area from start of device_path
+
+    <blksz>:
+        Block size in bytes
+
 	     (minimum 512, maximum 1073741824, must be a power of 2)
 
-Usage instructions:
--------------------
+Usage instructions
+------------------
 
-First, find the size (in 512-byte sectors) of the device to be used:
+First, find the size (in 512-byte sectors) of the device to be used::
 
-$ sudo blockdev --getsz /dev/vdb1
-33552384
+        $ sudo blockdev --getsz /dev/vdb1
+        33552384
 
 Create the dm-dust device:
 (For a device with a block size of 512 bytes)
-$ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 0 512'
+
+::
+
+        $ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 0 512'
 
 (For a device with a block size of 4096 bytes)
-$ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 0 4096'
+
+::
+
+        $ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 0 4096'
 
 Check the status of the read behavior ("bypass" indicates that all I/O
-will be passed through to the underlying device):
-$ sudo dmsetup status dust1
-0 33552384 dust 252:17 bypass
+will be passed through to the underlying device)::
+
+        $ sudo dmsetup status dust1
+        0 33552384 dust 252:17 bypass
 
-$ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=128 iflag=direct
-128+0 records in
-128+0 records out
+        $ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=128 iflag=direct
+        128+0 records in
+        128+0 records out
 
-$ sudo dd if=/dev/zero of=/dev/mapper/dust1 bs=512 count=128 oflag=direct
-128+0 records in
-128+0 records out
+        $ sudo dd if=/dev/zero of=/dev/mapper/dust1 bs=512 count=128 oflag=direct
+        128+0 records in
+        128+0 records out
 
-Adding and removing bad blocks:
--------------------------------
+Adding and removing bad blocks
+------------------------------
 
 At any time (i.e.: whether the device has the "bad block" emulation
 enabled or disabled), bad blocks may be added or removed from the
-device via the "addbadblock" and "removebadblock" messages:
+device via the "addbadblock" and "removebadblock" messages::
 
-$ sudo dmsetup message dust1 0 addbadblock 60
-kernel: device-mapper: dust: badblock added at block 60
+        $ sudo dmsetup message dust1 0 addbadblock 60
+        kernel: device-mapper: dust: badblock added at block 60
 
-$ sudo dmsetup message dust1 0 addbadblock 67
-kernel: device-mapper: dust: badblock added at block 67
+        $ sudo dmsetup message dust1 0 addbadblock 67
+        kernel: device-mapper: dust: badblock added at block 67
 
-$ sudo dmsetup message dust1 0 addbadblock 72
-kernel: device-mapper: dust: badblock added at block 72
+        $ sudo dmsetup message dust1 0 addbadblock 72
+        kernel: device-mapper: dust: badblock added at block 72
 
 These bad blocks will be stored in the "bad block list".
-While the device is in "bypass" mode, reads and writes will succeed:
+While the device is in "bypass" mode, reads and writes will succeed::
 
-$ sudo dmsetup status dust1
-0 33552384 dust 252:17 bypass
+        $ sudo dmsetup status dust1
+        0 33552384 dust 252:17 bypass
 
-Enabling block read failures:
------------------------------
+Enabling block read failures
+----------------------------
 
-To enable the "fail read on bad block" behavior, send the "enable" message:
+To enable the "fail read on bad block" behavior, send the "enable" message::
 
-$ sudo dmsetup message dust1 0 enable
-kernel: device-mapper: dust: enabling read failures on bad sectors
+        $ sudo dmsetup message dust1 0 enable
+        kernel: device-mapper: dust: enabling read failures on bad sectors
 
-$ sudo dmsetup status dust1
-0 33552384 dust 252:17 fail_read_on_bad_block
+        $ sudo dmsetup status dust1
+        0 33552384 dust 252:17 fail_read_on_bad_block
 
 With the device in "fail read on bad block" mode, attempting to read a
-block will encounter an "Input/output error":
+block will encounter an "Input/output error"::
 
-$ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=1 skip=67 iflag=direct
-dd: error reading '/dev/mapper/dust1': Input/output error
-0+0 records in
-0+0 records out
-0 bytes copied, 0.00040651 s, 0.0 kB/s
+        $ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=1 skip=67 iflag=direct
+        dd: error reading '/dev/mapper/dust1': Input/output error
+        0+0 records in
+        0+0 records out
+        0 bytes copied, 0.00040651 s, 0.0 kB/s
 
 ...and writing to the bad blocks will remove the blocks from the list,
-therefore emulating the "remap" behavior of hard disk drives:
+therefore emulating the "remap" behavior of hard disk drives::
 
-$ sudo dd if=/dev/zero of=/dev/mapper/dust1 bs=512 count=128 oflag=direct
-128+0 records in
-128+0 records out
+        $ sudo dd if=/dev/zero of=/dev/mapper/dust1 bs=512 count=128 oflag=direct
+        128+0 records in
+        128+0 records out
 
-kernel: device-mapper: dust: block 60 removed from badblocklist by write
-kernel: device-mapper: dust: block 67 removed from badblocklist by write
-kernel: device-mapper: dust: block 72 removed from badblocklist by write
-kernel: device-mapper: dust: block 87 removed from badblocklist by write
+        kernel: device-mapper: dust: block 60 removed from badblocklist by write
+        kernel: device-mapper: dust: block 67 removed from badblocklist by write
+        kernel: device-mapper: dust: block 72 removed from badblocklist by write
+        kernel: device-mapper: dust: block 87 removed from badblocklist by write
 
-Bad block add/remove error handling:
-------------------------------------
+Bad block add/remove error handling
+-----------------------------------
 
 Attempting to add a bad block that already exists in the list will
-result in an "Invalid argument" error, as well as a helpful message:
+result in an "Invalid argument" error, as well as a helpful message::
 
-$ sudo dmsetup message dust1 0 addbadblock 88
-device-mapper: message ioctl on dust1  failed: Invalid argument
-kernel: device-mapper: dust: block 88 already in badblocklist
+        $ sudo dmsetup message dust1 0 addbadblock 88
+        device-mapper: message ioctl on dust1  failed: Invalid argument
+        kernel: device-mapper: dust: block 88 already in badblocklist
 
 Attempting to remove a bad block that doesn't exist in the list will
-result in an "Invalid argument" error, as well as a helpful message:
+result in an "Invalid argument" error, as well as a helpful message::
 
-$ sudo dmsetup message dust1 0 removebadblock 87
-device-mapper: message ioctl on dust1  failed: Invalid argument
-kernel: device-mapper: dust: block 87 not found in badblocklist
+        $ sudo dmsetup message dust1 0 removebadblock 87
+        device-mapper: message ioctl on dust1  failed: Invalid argument
+        kernel: device-mapper: dust: block 87 not found in badblocklist
 
-Counting the number of bad blocks in the bad block list:
---------------------------------------------------------
+Counting the number of bad blocks in the bad block list
+-------------------------------------------------------
 
 To count the number of bad blocks configured in the device, run the
-following message command:
+following message command::
 
-$ sudo dmsetup message dust1 0 countbadblocks
+        $ sudo dmsetup message dust1 0 countbadblocks
 
 A message will print with the number of bad blocks currently
-configured on the device:
+configured on the device::
 
-kernel: device-mapper: dust: countbadblocks: 895 badblock(s) found
+        kernel: device-mapper: dust: countbadblocks: 895 badblock(s) found
 
-Querying for specific bad blocks:
----------------------------------
+Querying for specific bad blocks
+--------------------------------
 
 To find out if a specific block is in the bad block list, run the
-following message command:
+following message command::
 
-$ sudo dmsetup message dust1 0 queryblock 72
+        $ sudo dmsetup message dust1 0 queryblock 72
 
-The following message will print if the block is in the list:
-device-mapper: dust: queryblock: block 72 found in badblocklist
+The following message will print if the block is in the list::
 
-The following message will print if the block is in the list:
-device-mapper: dust: queryblock: block 72 not found in badblocklist
+        device-mapper: dust: queryblock: block 72 found in badblocklist
+
+The following message will print if the block is not in the list::
+
+        device-mapper: dust: queryblock: block 72 not found in badblocklist
 
 The "queryblock" message command will work in both the "enabled"
 and "disabled" modes, allowing the verification of whether a block
 will be treated as "bad" without having to issue I/O to the device,
 or having to "enable" the bad block emulation.
 
-Clearing the bad block list:
-----------------------------
+Clearing the bad block list
+---------------------------
 
 To clear the bad block list (without needing to individually run
 a "removebadblock" message command for every block), run the
-following message command:
+following message command::
 
-$ sudo dmsetup message dust1 0 clearbadblocks
+        $ sudo dmsetup message dust1 0 clearbadblocks
 
-After clearing the bad block list, the following message will appear:
+After clearing the bad block list, the following message will appear::
 
-kernel: device-mapper: dust: clearbadblocks: badblocks cleared
+        kernel: device-mapper: dust: clearbadblocks: badblocks cleared
 
 If there were no bad blocks to clear, the following message will
-appear:
+appear::
 
-kernel: device-mapper: dust: clearbadblocks: no badblocks found
+        kernel: device-mapper: dust: clearbadblocks: no badblocks found
 
-Message commands list:
-----------------------
+Message commands list
+---------------------
 
 Below is a list of the messages that can be sent to a dust device:
 
-Operations on blocks (requires a <blknum> argument):
+Operations on blocks (requires a <blknum> argument)::
 
-addbadblock <blknum>
-queryblock <blknum>
-removebadblock <blknum>
+        addbadblock <blknum>
+        queryblock <blknum>
+        removebadblock <blknum>
 
 ...where <blknum> is a block number within range of the device
-  (corresponding to the block size of the device.)
+(corresponding to the block size of the device.)
 
-Single argument message commands:
+Single argument message commands::
 
-countbadblocks
-clearbadblocks
-disable
-enable
-quiet
+        countbadblocks
+        clearbadblocks
+        disable
+        enable
+        quiet
 
-Device removal:
----------------
+Device removal
+--------------
 
-When finished, remove the device via the "dmsetup remove" command:
+When finished, remove the device via the "dmsetup remove" command::
 
-$ sudo dmsetup remove dust1
+        $ sudo dmsetup remove dust1
 
-Quiet mode:
------------
+Quiet mode
+----------
 
 On test runs with many bad blocks, it may be desirable to avoid
 excessive logging (from bad blocks added, removed, or "remapped").
-This can be done by enabling "quiet mode" via the following message:
+This can be done by enabling "quiet mode" via the following message::
 
-$ sudo dmsetup message dust1 0 quiet
+        $ sudo dmsetup message dust1 0 quiet
 
 This will suppress log messages from add / remove / removed by write
 operations.  Log messages from "countbadblocks" or "queryblock"
 message commands will still print in quiet mode.
 
-The status of quiet mode can be seen by running "dmsetup status":
+The status of quiet mode can be seen by running "dmsetup status"::
 
-$ sudo dmsetup status dust1
-0 33552384 dust 252:17 fail_read_on_bad_block quiet
+        $ sudo dmsetup status dust1
+        0 33552384 dust 252:17 fail_read_on_bad_block quiet
 
-To disable quiet mode, send the "quiet" message again:
+To disable quiet mode, send the "quiet" message again::
 
-$ sudo dmsetup message dust1 0 quiet
+        $ sudo dmsetup message dust1 0 quiet
 
-$ sudo dmsetup status dust1
-0 33552384 dust 252:17 fail_read_on_bad_block verbose
+        $ sudo dmsetup status dust1
+        0 33552384 dust 252:17 fail_read_on_bad_block verbose
 
 (The presence of "verbose" indicates normal logging.)
 
diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index c77c58b8f67b..4872fb6d2952 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -9,6 +9,7 @@ Device Mapper
     cache
     delay
     dm-crypt
+    dm-dust
     dm-flakey
     dm-init
     dm-integrity
-- 
2.21.0
