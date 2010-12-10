From: Tarcisio Fedrizzi <tarcisio.fedrizzi@gmail.com>
Subject: Possible kpartx bug investigation/report
Date: Fri, 10 Dec 2010 10:01:38 +0100
Message-ID: <4D01EC72.5060205@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
I'm while I was trying to get a device working on multipath I had
a problem with kpartx. The problem is the following: I mounted an
iSCSI deviec that is exported with block size of 4K. The multipath side 
works
correctly, the problem arises when kpartx maps the partition contained
in the device. When mounting the partition I get an error saying that the
partition doesn't contain a filesystem. After some digging I found that 
kpartx
calculates a wrong offset and size because it treats the offset and the 
size as
they was of 512b. I mean that they not get multiplied by 4096 / 512 = 8. By
using dmsetup and multiplying by 8 the offset and size I get a device that
mounts correctly, the same by patching kpartx/gpt.c and adding a
multiplication of offset/size by get_sector_size(fd) / 512.
Since I'm not an expert in this field I cannot state for sure that the 
problem
is this and doesn't depend on something else like some fault I've done or
a buggy implementation of iSCSI by the NAS I'm using. I then kindly ask 
if you can
help me to determine if this is a kpartx bug or something else so I can 
get it
working in the correct way or file a bug.

Thanks in advance,
Best regards,
Tarcisio Fedrizzi.
