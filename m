From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Write protected devices, unexpected dm-multipath queueing
Date: Fri, 06 Jan 2012 20:30:51 +0100
Message-ID: <1325878251.19595.13.camel@lapoo.opensvc.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
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
To: Hannes Reinecke <hare@suse.de>, dm-devel <dm-devel@redhat.com>
Cc: "cyril.galibern" <cyril.galibern@opensvc.com>
List-Id: dm-devel.ids

Hannes, list,

reading your kernel path there
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=63583cca745f440167bf27877182dc13e19d4bcf
I wonder if this is expected that a write io on a write protected device
is returned to the queue ? I would have guessed it qualified as
TARGET_ERROR, hence not retryable (and not causing path invalidation).

In the following log the sense code is clearly seen as 
Sense Key : Data Protect [current]
Add. Sense: Write protected

The log is grabbed from a el6 kernel rev. 131 which include the
mentioned patch (since rev. 110 iirc).

Care to confirm something is fishy there ?

Regards,
cvaroqui

====

Jan  6 02:54:20 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 0

Jan  6 02:54:20 wheeler multipathd: 360000970000292602571533030384444:
Entering recovery mode: max_retries=5

Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
sdbq - tur checker reports path is up

Jan  6 02:54:23 wheeler multipathd: 68:64: reinstated

Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
queue_if_no_path enabled

Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
Recovered to normal mode

Jan  6 02:54:23 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 1

Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Unhandled sense code

Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Result:
hostbyte=invalid driverbyte=DRIVER_SENSE

Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Sense Key : Data
Protect [current] 

Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] Add. Sense: Write
protected

Jan  6 02:54:23 wheeler kernel: sd 2:0:0:15: [sdbq] CDB: Write(10): 2a
00 00 00 00 d0 00 00 10 00

Jan  6 02:54:23 wheeler kernel: end_request: I/O error, dev sdbq, sector
208

Jan  6 02:54:23 wheeler kernel: device-mapper: multipath: Failing path
68:64.

Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
sdq - tur checker reports path is up

Jan  6 02:54:24 wheeler multipathd: 65:0: reinstated

Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 2

Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
sdaq - tur checker reports path is up

Jan  6 02:54:24 wheeler multipathd: 66:160: reinstated

Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 3

Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
sdcq - tur checker reports path is up

Jan  6 02:54:24 wheeler multipathd: 69:224: reinstated

Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 4

Jan  6 02:54:24 wheeler multipathd: 68:64: mark as failed

Jan  6 02:54:24 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 3

Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Unhandled sense code

Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Result:
hostbyte=invalid driverbyte=DRIVER_SENSE

Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Sense Key : Data
Protect [current] 

Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] Add. Sense: Write
protected

Jan  6 02:54:24 wheeler kernel: sd 1:0:0:15: [sdq] CDB: Write(10): 2a 00
00 00 00 d0 00 00 10 00

Jan  6 02:54:24 wheeler kernel: end_request: I/O error, dev sdq, sector
208

Jan  6 02:54:24 wheeler kernel: device-mapper: multipath: Failing path
65:0.

Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Unhandled sense code

Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Result:
hostbyte=invalid driverbyte=DRIVER_SENSE

Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Sense Key : Data
Protect [current] 

Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] Add. Sense: Write
protected

Jan  6 02:54:24 wheeler kernel: sd 2:0:1:15: [sdcq] CDB: Write(10): 2a
00 00 00 00 d0 00 00 10 00

Jan  6 02:54:24 wheeler kernel: end_request: I/O error, dev sdcq, sector
208

Jan  6 02:54:24 wheeler kernel: device-mapper: multipath: Failing path
69:224.

Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Unhandled sense code

Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Result:
hostbyte=invalid driverbyte=DRIVER_SENSE

Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Sense Key : Data
Protect [current] 

Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] Add. Sense: Write
protected

Jan  6 02:54:24 wheeler kernel: sd 1:0:1:15: [sdaq] CDB: Write(10): 2a
00 00 00 00 d0 00 00 10 00

Jan  6 02:54:24 wheeler kernel: end_request: I/O error, dev sdaq, sector
208

Jan  6 02:54:24 wheeler kernel: device-mapper: multipath: Failing path
66:160.

Jan  6 02:54:25 wheeler multipathd: 65:0: mark as failed

Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 2

Jan  6 02:54:25 wheeler multipathd: 66:160: mark as failed

Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 1

Jan  6 02:54:25 wheeler multipathd: 69:224: mark as failed

Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
Entering recovery mode: max_retries=5

Jan  6 02:54:25 wheeler multipathd: 360000970000292602571533030384444:
remaining active paths: 0
