From: "goggin, edward" <egoggin@emc.com>
Subject: reducing path test delays
Date: Mon, 4 Apr 2005 15:48:36 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A8AB@SRMANNING.eng.emc.com>
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
Cc: 'Alasdair G Kergon' <agk@redhat.com>, 'Christophe Varoqui' <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

In the interest of reducing delay time when testing either good or
failed paths, could we (1) prevent SCSI mid-layer initiated i/o
retry of these requests and (2) insert the test path i/os at the
head of the path's block i/o queue?  Doing either of these will
require some kernel enhancement since there is no way to
either request fail fast capability or insertion at queue head for
a SCSI CDB issued from user space.

Currently the scsi_cmd_ioctl->sg_io->blk_execute_rq code
path for a multipath test i/o does not set the REQ_FAILFAST
bit in the flags field of the request structure and unconditionally
inserts the request at the tail of the request queue for the scsi
device representing the scsi path being tested.

Possibly the desire for each of these two attributes could be
passed as a flag bit setting in the flag field of the sg_io_hdr
structure passed into the kernel as part of the test path ioctl(2).
