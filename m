From: Bryan Gurney <bgurney@redhat.com>
Subject: [RFC PATCH 0/1] dm: add dm-dust, a bad sector emulator
Date: Mon,  7 Jan 2019 14:31:22 -0500
Message-ID: <1546889483-6341-1-git-send-email-bgurney@redhat.com>
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
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: jdorminy@redhat.com, jshimkus@redhat.com, tjaskiew@redhat.com, jpittman@redhat.com, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

This patch adds the device-mapper target dm-dust, which allows the
arbitrary designation of "bad" sectors, at an arbitrary time.

This target behaves similarly to a linear target, with the exception
of the minimum and optimal IO sizes being configurable to 512 or
4096 bytes.  At a given time, the user can send a message to the
target to start failing read requests on specific blocks.  When the
failure behavior is enabled, reads of blocks configured "bad" will
fail with EIO.

Writes of blocks configured "bad" will result in the following:

1. Remove the block from the "bad block list".
   sector).
2. Successfully complete the write.

After this point, the block will successfully contain the written
data, and will service reads and writes normally.  This emulates the
behavior of a "remapped sector" on a hard disk drive.

dm-dust provides logging of which blocks have been added or removed
to the "bad block list", as well as logging when a block has been
removed from the bad block list.  These messages can be used
alongside the messages from the driver using a dm-dust device to
analyze the driver's behavior when a read fails at a given time.

(This logging can be reduced via a "quiet" mode, if desired.)

Bryan Gurney (1):
  dm: add dust target

 Documentation/device-mapper/dm-dust.txt | 256 ++++++++++++
 drivers/md/Kconfig                      |   9 +
 drivers/md/Makefile                     |   1 +
 drivers/md/dm-dust.c                    | 499 ++++++++++++++++++++++++
 4 files changed, 765 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-dust.txt
 create mode 100644 drivers/md/dm-dust.c

-- 
2.17.2
