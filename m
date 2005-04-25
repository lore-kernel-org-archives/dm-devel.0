From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4541] New: device mapper corruption
 after upgrading from 2.6.9 or 2.6.5 to 2.6.11
Date: Mon, 25 Apr 2005 14:38:15 -0700
Message-ID: <20050425143815.5bf8365e.akpm@osdl.org>
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
Cc: m@iw.hu
List-Id: dm-devel.ids



Begin forwarded message:

Date: Mon, 25 Apr 2005 11:47:56 -0700
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4541] New: device mapper corruption after upgrading from 2.6.9 or 2.6.5 to 2.6.11


http://bugme.osdl.org/show_bug.cgi?id=4541

           Summary: device mapper corruption after upgrading from 2.6.9 or
                    2.6.5 to 2.6.11
    Kernel Version: 2.6.11
            Status: NEW
          Severity: high
             Owner: thornber@sistina.com
         Submitter: m@iw.hu


Distribution: Debian 
Hardware Environment: Intel Xeon (with and w/o SMP), aic7902 scsi
Problem Description:

After upgrading from 2.6.5-rc2 or 2.6.9-rc1 to 2.6.11, all striped LVM volumes
that have been working flawlessly for months show a totally corrupted
filesystem. If I boot the original kernel again w/o touching the filesystems,
everything is fine. 

I guess this has to do something with the lvm striping fix that went in recently.

Steps to reproduce:
Create a striped LVM volume on 2.6.9-rc1 and upgrade the kernel to 2.6.11

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
