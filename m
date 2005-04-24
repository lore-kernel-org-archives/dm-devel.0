From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4507] New: device-mapper crypt
 can't encrypt cdrom device
Date: Sat, 23 Apr 2005 17:55:23 -0700
Message-ID: <20050423175523.7aa0dd63.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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


I'm not sure if this is a bug or a user error.  Could someone please
update the bugzilla record?

Thanks.

Begin forwarded message:

Date: Sun, 17 Apr 2005 07:39:02 -0700
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4507] New: device-mapper crypt can't encrypt cdrom device


http://bugme.osdl.org/show_bug.cgi?id=4507

           Summary: device-mapper crypt can't encrypt cdrom device
    Kernel Version: 2.6.11
            Status: NEW
          Severity: normal
             Owner: thornber@sistina.com
         Submitter: hadmut@danisch.de


Distribution: Debian 
Hardware Environment: Plain PC
Software Environment: dmsetup 1.01

Problem Description:

I tried to generate an encrypted CDROM (generated a 
plain ISO image, encrypted it with the device mapper, 
and burned it onto a CDROM).

But mounting the device with the device mapper fails:

# dmsetup create cdromx
0 73246 crypt aes-plain 61a60170273e74a5be90355ffe8e86ad 0 /dev/cdroms/cdrom0 0
device-mapper ioctl cmd 9 failed: Invalid argument
Command failed


dmesg says:
device-mapper: crypt: Device lookup failed

It seems as if dm_get_device in dm-table.c does not find the 
cdrom drive. Even giving the full device path 
/dev/ide/host0/bus1/target0/lun0/cd or the major:minor as 
22:0 does not help.


regards
Hadmut



Steps to reproduce:

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
