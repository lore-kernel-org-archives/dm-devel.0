From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH v3] dcssblk: add dax_operations support
Date: Thu, 20 Apr 2017 19:05:50 +0200
Message-ID: <20170420190550.6a31fa6c@thinkpad>
References: <149264113824.36586.1220609927071019352.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <149264113824.36586.1220609927071019352.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de
List-Id: dm-devel.ids

On Wed, 19 Apr 2017 15:32:38 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Setup a dax_dev to have the same lifetime as the dcssblk block device
> and add a ->direct_access() method that is equivalent to
> dcssblk_direct_access(). Once fs/dax.c has been converted to use
> dax_operations the old dcssblk_direct_access() will be removed.
> 
> Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since v2:
> * fix return code in the alloc_dax() failure case (Gerald)
> * assign dax_dev to dev_info and kill local variable (Gerald)
> 
>  drivers/s390/block/Kconfig   |    1 +
>  drivers/s390/block/dcssblk.c |   55 +++++++++++++++++++++++++++++++++++-------
>  2 files changed, 47 insertions(+), 9 deletions(-)

Acked-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
