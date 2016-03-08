From: Bernd Broermann <bernd@broermann.com>
Subject: =?utf-8?q?path=5Fgrouping=5Fpolicy__group=5Fby=5Fseria?=
	=?utf-8?q?l__prio_question?=
Date: Tue, 08 Mar 2016 13:03:03 +0100
Message-ID: <de2a545fcd595b05011ba8cd715d484a@broermann.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,


Does "group_by_serial" activate the "low latency"  path ?

There are two servers which have a separate path to a EMC VPLEX box in 
different Data centers ( DC1 , DC2 ) .

Because of latency the paths are grouped by the serial number of the 
VPLEX box.




        DC1                DC2

    +------------+    +------------+
    | Server 1   |    | Server 2   |
    +------------+    +------------+
       |   \              /  |
       |     \          /    |
       |       \      /      |
       |         \  /        |
       |          X          |
       |        /   \        |
       |      /       \      |
       |    /           \    |
       |  /              \   |
    +------------+    +------------+
    |disk VPLEX A|    |disk VPLEX B|
    +------------+    +------------+


As I expected the paths are grouped and the path to the "nearest" disk( 
VPLEX) is active.

Is this an coincidence or does it work as designed ?

I didn't find something enlightening in the dm documentation.

Thank you for your help.

Bernd



partitial output of  "multipathd show config"
....
device {
     vendor "EMC"
     product "Invista"
     product_blacklist "LUNZ"
     path_grouping_policy group_by_serial
     getuid_callout "/lib/udev/scsi_id --whitelisted --device=/dev/%n"
     path_selector "round-robin 0"
     path_checker tur
     features "0"
     hardware_handler "1 emc"
     prio emc
     rr_weight uniform
     no_path_retry fail
     rr_min_io 1000
     rr_min_io_rq 1
     detect_prio yes
}
