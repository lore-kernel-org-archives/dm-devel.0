From: <Sreenivas.Honnur@dell.com>
Subject: device blacklisting and suspend issue
Date: Sat, 25 Jan 2020 07:51:54 +0000
Message-ID: <a06c41ee9a6a40288b05d016455469ab@BLRX13MDC419.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

I have below queries, help is appreciated.

1.	We have an issue with device blacklisting. To blacklist a device we add an entry in /etc/multipath.conf" and do "service multipathd reload". After this to check if device is blacklisted we issue "multipathd show blacklist" command in a loop(with a delay of 10 second). Sometimes I see that this command takes too much time to come out or sometimes it just hangs. 
	a. Is this the correct way to check if device is blacklisted? Or is there any other way to do it?
	b. Is "multipathd reload" a async call? Is there a way to know that "multipathd reload" is completed?

2.	After suspending (dmsetup suspend wwid) a device,  is there a way to inform multipathd not to make it active if some events happen on this device(like new path added..etc...I see that the table is reloaded and device becomes active)
How to avoid this i.e. the device should be in "suspended" state until I do a "resume" on it, "multipathd" should not enable it until I do "dmsetup resume"

3.  " blk_cloned_rq_check_limits: over max size limit." Error
I have a requirement to change(decrease) the max_sector_kb value of a device, when I do that (using "echo value /sys/block/dm-x/queue/max_sector_kb) I hit above error.
How I can I avoid this error when I change the max_sector_kb value?
