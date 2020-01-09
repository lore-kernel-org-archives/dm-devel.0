From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
Date: Wed, 8 Jan 2020 19:18:54 -0800
Message-ID: <fda88fd3-2d75-085e-ca15-a29f89c1e781@acm.org>
References: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BYAPR04MB5749820C322B40C7DBBBCA02863F0@BYAPR04MB5749.namprd04.prod.outlook.com>
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
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "msnitzer@redhat.com" <msnitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matias Bjorling <Matias.Bjorling@wdc.com>, Stephen Bates <sbates@raithlin.com>, "roland@purestorage.com" <roland@purestorage.com>, "mpatocka@redhat.com" <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, "frederick.knight@netapp.com" <frederick.knight@netapp.com>, "zach.brown@ni.com" <zach.brown@ni.com>
List-Id: dm-devel.ids

On 2020-01-07 10:14, Chaitanya Kulkarni wrote:
> * Current state of the work :-
> -----------------------------------------------------------------------
> 
> With [3] being hard to handle arbitrary DM/MD stacking without
> splitting the command in two, one for copying IN and one for copying
> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
> candidate. Also, with [4] there is an unresolved problem with the
> two-command approach about how to handle changes to the DM layout
> between an IN and OUT operations.

Was this last discussed during the 2018 edition of LSF/MM (see also
https://www.spinics.net/lists/linux-block/msg24986.html)? Has anyone
taken notes during that session? I haven't found a report of that
session in the official proceedings (https://lwn.net/Articles/752509/).

Thanks,

Bart.


This is my own collection with two year old notes about copy offloading
for the Linux Kernel:

Potential Users
* All dm-kcopyd users, e.g. dm-cache-target, dm-raid1, dm-snap, dm-thin,
  dm-writecache and dm-zoned.
* Local filesystems like BTRFS, f2fs and bcachefs: garbage collection
  and RAID, at least if RAID is supported by the filesystem. Note: the
  BTRFS_IOC_CLONE_RANGE ioctl is no longer supported. Applications
  should use FICLONERANGE instead.
* Network filesystems, e.g. NFS. Copying at the server side can reduce
  network traffic significantly.
* Linux SCSI initiator systems connected to SAN systems such that
  copying can happen locally on the storage array. XCOPY is widely used
  for provisioning virtual machine images.
* Copy offloading in NVMe fabrics using PCIe peer-to-peer communication.

Requirements
* The block layer must gain support for XCOPY. The new XCOPY API must
  support asynchronous operation such that users of this API are not
  blocked while the XCOPY operation is in progress.
* Copying must be supported not only within a single storage device but
  also between storage devices.
* The SCSI sd driver must gain support for XCOPY.
* A user space API must be added and that API must support asynchronous
  (non-blocking) operation.
* The block layer XCOPY primitive must be support by the device mapper.

SCSI Extended Copy (ANSI T10 SPC)
The SCSI commands that support extended copy operations are:
* POPULATE TOKEN + WRITE USING TOKEN.
* EXTENDED COPY(LID1/4) + RECEIVE COPY STATUS(LID1/4). LID1 stands for a
  List Identifier length of 1 byte and LID4 stands for a List Identifier
  length of 4 bytes.
* SPC-3 and before define EXTENDED COPY(LID1) (83h/00h). SPC-4 added
  EXTENDED COPY(LID4) (83h/01h).

Existing Users and Implementations of SCSI XCOPY
* VMware, which uses XCOPY (with a one-byte length ID, aka LID1).
* Microsoft, which uses ODX (aka LID4 because it has a four-byte length
  ID).
* Storage vendors all support XCOPY, but ODX support is growing.

Block Layer Notes
The block layer supports the following types of block drivers:
* blk-mq request-based drivers.
* make_request drivers.

Notes:
With each request a list of bio's is associated.
Since submit_bio() only accepts a single bio and not a bio list this
means that all make_request block drivers process one bio at a time.

Device Mapper
The device mapper core supports bio processing and blk-mq requests. The
function in the device mapper that creates a request queue is called
alloc_dev(). That function not only allocates a request queue but also
associates a struct gendisk with the request queue. The
DM_DEV_CREATE_CMD ioctl triggers a call of alloc_dev(). The
DM_TABLE_LOAD ioctl loads a table definition. Loading a table definition
causes the type of a dm device to be set to one of the following:
DM_TYPE_NONE;
DM_TYPE_BIO_BASED;
DM_TYPE_REQUEST_BASED;
DM_TYPE_MQ_REQUEST_BASED;
DM_TYPE_DAX_BIO_BASED;
DM_TYPE_NVME_BIO_BASED.

Device mapper drivers must implement target_type.map(),
target_type.clone_and_map_rq() or both. .map() maps a bio list.
.clone_and_map_rq() maps a single request. The multipath and error
device mapper drivers implement both methods. All other dm drivers only
implement the .map() method.

Device mapper bio processing
submit_bio()
-> generic_make_request()
  -> dm_make_request()
    -> __dm_make_request()
      -> __split_and_process_bio()
        -> __split_and_process_non_flush()
          -> __clone_and_map_data_bio()
          -> alloc_tio()
          -> clone_bio()
            -> bio_advance()
          -> __map_bio()

Existing Linux Copy Offload APIs
* The FICLONERANGE ioctl. From <include/linux/fs.h>:
  #define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)

struct file_clone_range {
	__s64 src_fd;
	__u64 src_offset;
	__u64 src_length;
	__u64 dest_offset;
};

* The sendfile() system call. sendfile() copies a given number of bytes
  from one file to another. The output offset is the offset of the
  output file descriptor. The input offset is either the input file
  descriptor offset or can be specified explicitly. The sendfile()
  prototype is as follows:
  ssize_t sendfile(int out_fd, int in_fd, off_t *ppos, size_t count);
  ssize_t sendfile64(int out_fd, int in_fd, loff_t *ppos, size_t count);
* The copy_file_range() system call. See also vfs_copy_file_range(). Its
  prototype is as follows:
  ssize_t copy_file_range(int fd_in, loff_t *off_in, int fd_out,
     loff_t *off_out, size_t len, unsigned int flags);
* The splice() system call is not appropriate for adding extended copy
  functionality since it copies data from or to a pipe. Its prototype is
  as follows:
  long splice(struct file *in, loff_t *off_in, struct file *out,
    loff_t *off_out, size_t len, unsigned int flags);

Existing Linux Block Layer Copy Offload Implementations
* Martin Petersen's REQ_COPY bio, where source and destination block
  device are both specified in the same bio. Only works for block
  devices. Does not work for files. Adds a new blocking ioctl() for
  XCOPY from user space.
* Mikulas Patocka's approach: separate REQ_OP_COPY_WRITE and
  REQ_OP_COPY_READ operations. These are sent individually down stacked
  drivers and are paired by the driver at the bottom of the stack.
