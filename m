From: "goggin, edward" <egoggin@emc.com>
Subject: another multipath deadlock involving fs-writeback
Date: Thu, 24 Mar 2005 17:18:23 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A866@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Christophe Varoqui' <christophe.varoqui@free.fr>, 'Alasdair G Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

This one involves a process waiting for i/o to complete on its multipath
mapped device's block device inode after having set the inode's
__I_LOCK state bit and multipath(8) or multipathd(8) (both in my case)
needing to obtain multipath specific device-mapper status information
via ctl_ioctl() call to table_status() from the same mapped device in
order to obtain the kernel's state for the path.  Looks like another
call to bdget_disk() is the problem, this one called from __dev_status()
called from table_status().

Of course the i/o for the device doesn't complete because the path
state in the kernel for the mapped device indicates failure for all paths
as part of an EMC CLARiion NDU test.

In this case, the first process has invoked sync(1) while the one on
March 8th involved balance_dirty_pages() called as part of servicing
write(2).
