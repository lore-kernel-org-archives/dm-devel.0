From: "goggin, edward" <egoggin@emc.com>
Subject: Re: another multipath deadlock involving fs-writeback
Date: Mon, 28 Mar 2005 11:15:40 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A86A@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
Cc: 'Alasdair G Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, 24 Mar 2005 22:26:46 +0000, Alasdair G Kergon wrote:
> It should probably be setting the recent DM_SKIP_BDGET_FLAG 
> on every? dm ioctl.
> 
> i.e. call dm_task_no_open_count() in libdevmapper prior to 
> dm_task_run().

I see.  A recent change which I did not have in my
2.6.11-rc3 kernel but which I see is in the 2.6.12-rc1
kernel.  This code will certainly fix the deadlock problem
for any dm ioctl which is calling bdget_disk indirectly
from __dev_status, but ...

this will not address the case where bdget_disk is called
from __lock_fs and __unlock_fs.  This occurs in the code
path of multipath(8) suspending a dm mapped device which
currently has no valid paths while swapping the device's
map/table while some process which owns the __I_LOCK bit
of the same mapped device's block device inode is waiting
for dirty pages associated with the inode to be flushed.
