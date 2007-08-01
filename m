From: Andrew Miklas <public@mikl.as>
Subject: Size affects performance?
Date: Tue, 31 Jul 2007 23:03:52 -0400
Message-ID: <0F900654-4DF1-40F7-8227-C277E11C4F33@mikl.as>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
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

Hi,

I've noticed that the size of a device seems to affect its performance.
Is this expected behaviour?

For example, on a device that is exactly 1GB, I can transfer at 16.4  
MB/s:

flanders1:~# dmsetup create test
0 2097152 linear /dev/sda6 0

flanders1:~# dd if=/dev/zero of=/dev/mapper/test bs=1K count=1048576
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 65.4846 seconds, 16.4 MB/s


Yet, if I resize the device to be one sector larger, the same  
transfer happens at 59.0 MB/s:

flanders1:~# dmsetup create test
0 2097153 linear /dev/sda6 0

flanders1:~# dd if=/dev/zero of=/dev/mapper/test bs=1K count=1048576
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 18.1887 seconds, 59.0 MB/s


For reference, the underlying device seems capable of ~ 60 MB/s:

flanders1:~# dd if=/dev/zero of=/dev/sda6 bs=1K count=1048576
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 18.1325 seconds, 59.2 MB/s


I've noticed that the problem either doesn't occur or isn't as  
pronounced if different block sizes are used (ie. bs=4K).
I'm running a fairly recent kernel: git tag v2.6.23-rc1-g6a30235


Thanks for any help,


Andrew Miklas
