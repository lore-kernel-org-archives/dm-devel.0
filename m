From: "goggin, edward" <egoggin@emc.com>
Subject: bugs in handling of errors for SG_IO and
	SCSI_IOCTL_SEND_COMMAND ioctls to block device
Date: Thu, 7 Jul 2005 23:39:19 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB4B@SRMANNING.eng.emc.com>
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
Cc: christophe varoqui <christophe.varoqui@free.fr>, 'Lars Marowsky-Bree' <lmb@suse.de>, 'Alasdair G Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

Found several problems in both the upstream kernel (at least up to
2.6.12-rc2)
and the SuSE SLES 9 SP2-RC(2/3/4) kernels regarding the handling of errors
occurring during the servicing of both an SG_IO and a
SCSI_IOCTL_SEND_COMMAND
SCSI ioctl command sent to a block device.  Haven't verified this problem
with a Red Hat
SP2 kernel yet.

Looks like three bugs, starting from the bottom up.

(1)	For the SuSE SP2 kernels, scsi_io_completion in
drivers/scsi/scsi_lib.c is ignoring
	a whole class of errors involving the higher order 24 bits of the
32-bit result when
	setting the errors field of a REQ_BLOCK_PC io request.  Since most
FC cable
	failures are generating a DID_NO_CONNECT (as the result of a scsi
command
	timeout) status in the third byte of this field without any sense
data, the current
	code which only pays attention only to the availability of sense
data or the low
	order 8 bits of the scsi command's result field, simply sets the
errors field of the
	pass through io request to zero for most if not all cable failures.

	This problem is corrected in at least the version 2.6.12-rc2
upstream kernel.

(2)	sg_scsi_ioctl is only referencing the low order 8 bits of the errors
field of the
	REQ_BLOCK_PC io request just serviced.  This is the case in both the
SuSE
	SP2 kernels and the upstream 2.6.12-rc2 kernel.  While this is not a
problem
	for multipath, and the SCSI_IOCTL_SEND_COMMAND interface is
deprecated,
	this is still a problem.

(3)	Why do both the bio_uncopy_user and bio_unmap_user functions of
fs/bio.c
	always copy_to_user the entire bio's worth of data for a read?
Seems like they
	should only do the copy_to_user up to a byte length which should be
specified as a
	parameter to each function passed through by blk_rq_unmap_user.  For

	REQ_BLOCK_PC io requests, this would be the byte size of the io
transfer
	minus the residual after an error during the transfer.  In the event
of a completely
	failed io due to a cable disconnect, no data should be transferred
to user space.
	The bio handling for these REQ_BLOCK_PC requests shouldn't be
treated any
	differently than the more typical REQ_CMD type block io request.


All of this combines to cause scsi pass through commands sent to a scsi
block device
to appear to succeed when they actually have failed when sent along a failed
path.  This
is what is causing both tur and readsector0 path check functions to yield
false positive
path test results.

These bugs even combine to cause the emc_clariion path checker to
occasionally yield false negative results by tripping onto another problem
in that path
checker which causes multipathd to think a path is down when it really is
not, which
prevents the path from being restored to a useful state unless multipath(8)
is run or
multipathd is restarted.
