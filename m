From: Adam Courville <rttst@verizon.net>
Subject: Update to kernel 514.2 Breaks RAID0
Date: Fri, 16 Dec 2016 12:01:42 -0600
Message-ID: <d9928b3f-16a0-d67d-e113-5c0c829209a9@verizon.net>
Reply-To: RTTST@verizon.net
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

This is using CentOS 7.  A previously used striped RAID stalls the boot, 
because it is not found in /dev/mapper location.

When I tried  a forced creation of a device using dmsetup using this 
command:

# 'echo "0 $NumSectors striped 2 256 /dev/sdb 0 /dev/sdc 0" | dmsetup 
create ddf1_4TB'

I get the following:

"Failure to communicate with kernel device-mapper driver.
Incompatible libdevmapper 1.02.135-RHEL7 (2016-09-28) and kernel driver 
(unknown version).
Command failed"

Hence, I suspect something amiss with the new kernel 514.2 and/or 
device-mapper.

If I regress via grub bootloader to 3.10.0-327.36.3.el7.x86_64, the 
RAID0 works fine.

Any workaround assistance would be appreciated.

Thank you,

Adam Courville
