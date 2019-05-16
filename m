From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: dax: Arrange for dax_supported check to span multiple devices
Date: Thu, 16 May 2019 14:10:51 -0700
Message-ID: <CAPcyv4j5M7ZgJqFtRxw1t2p4tb579azdb6=FedV-rcqJ3GJPNw@mail.gmail.com>
References: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190516185732.GA27796@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190516185732.GA27796@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: stable <stable@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Keith Busch <keith.busch@intel.com>, Matthew Wilcox <willy@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Pankaj Gupta <pagupta@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, May 16, 2019 at 11:58 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Tue, May 14 2019 at 11:48pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > Pankaj reports that starting with commit ad428cdb525a "dax: Check the
> > end of the block-device capacity with dax_direct_access()" device-mapper
> > no longer allows dax operation. This results from the stricter checks in
> > __bdev_dax_supported() that validate that the start and end of a
> > block-device map to the same 'pagemap' instance.
> >
> > Teach the dax-core and device-mapper to validate the 'pagemap' on a
> > per-target basis. This is accomplished by refactoring the
> > bdev_dax_supported() internals into generic_fsdax_supported() which
> > takes a sector range to validate. Consequently generic_fsdax_supported()
> > is suitable to be used in a device-mapper ->iterate_devices() callback.
> > A new ->dax_supported() operation is added to allow composite devices to
> > split and route upper-level bdev_dax_supported() requests.
> >
> > Fixes: ad428cdb525a ("dax: Check the end of the block-device...")
> > Cc: <stable@vger.kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Dave Jiang <dave.jiang@intel.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > Cc: Keith Busch <keith.busch@intel.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Reported-by: Pankaj Gupta <pagupta@redhat.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> > Hi Mike,
> >
> > Another day another new dax operation to allow device-mapper to better
> > scope dax operations.
> >
> > Let me know if the device-mapper changes look sane. This passes a new
> > unit test that indeed fails on current mainline.
> >
> > https://github.com/pmem/ndctl/blob/device-mapper-pending/test/dm.sh
> >
> >  drivers/dax/super.c          |   88 +++++++++++++++++++++++++++---------------
> >  drivers/md/dm-table.c        |   17 +++++---
> >  drivers/md/dm.c              |   20 ++++++++++
> >  drivers/md/dm.h              |    1
> >  drivers/nvdimm/pmem.c        |    1
> >  drivers/s390/block/dcssblk.c |    1
> >  include/linux/dax.h          |   19 +++++++++
> >  7 files changed, 110 insertions(+), 37 deletions(-)
> >
>
> ...
>
> > diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> > index 2d539b82ec08..e5e240bfa2d0 100644
> > --- a/drivers/md/dm.h
> > +++ b/drivers/md/dm.h
> > @@ -78,6 +78,7 @@ void dm_unlock_md_type(struct mapped_device *md);
> >  void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
> >  enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
> >  struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
> > +bool dm_table_supports_dax(struct dm_table *t, int blocksize);
> >
> >  int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
> >
>
> I'd prefer to have dm_table_supports_dax come just after
> dm_table_get_md_mempools in the preceding dm_table section of dm.h (just
> above this mapped_device section you extended).
>
> But other than that nit, patch looks great on a DM level:
>
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Thanks Mike, I folded in this change:

@@ -72,13 +72,13 @@ bool dm_table_bio_based(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
+bool dm_table_supports_dax(struct dm_table *t, int blocksize);

 void dm_lock_md_type(struct mapped_device *md);
 void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
 enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
-bool dm_table_supports_dax(struct dm_table *t, int blocksize);

 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
