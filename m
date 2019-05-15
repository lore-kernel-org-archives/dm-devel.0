From: Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [PATCH] dax: Arrange for dax_supported check to span multiple
 devices
Date: Wed, 15 May 2019 04:38:06 -0400 (EDT)
Message-ID: <34965939.28870107.1557909486195.JavaMail.zimbra@redhat.com>
References: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: snitzer@redhat.com, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, Keith Busch <keith.busch@intel.com>, Matthew Wilcox <willy@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



> 
> Pankaj reports that starting with commit ad428cdb525a "dax: Check the
> end of the block-device capacity with dax_direct_access()" device-mapper
> no longer allows dax operation. This results from the stricter checks in
> __bdev_dax_supported() that validate that the start and end of a
> block-device map to the same 'pagemap' instance.
> 
> Teach the dax-core and device-mapper to validate the 'pagemap' on a
> per-target basis. This is accomplished by refactoring the
> bdev_dax_supported() internals into generic_fsdax_supported() which
> takes a sector range to validate. Consequently generic_fsdax_supported()
> is suitable to be used in a device-mapper ->iterate_devices() callback.
> A new ->dax_supported() operation is added to allow composite devices to
> split and route upper-level bdev_dax_supported() requests.
> 
> Fixes: ad428cdb525a ("dax: Check the end of the block-device...")
> Cc: <stable@vger.kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Reported-by: Pankaj Gupta <pagupta@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thank you for the patch. Looks good to me. 
I also tested the patch and it works well.

Reviewed-and-Tested-by: Pankaj Gupta <pagupta@redhat.com> 

Best regards,
Pankaj
