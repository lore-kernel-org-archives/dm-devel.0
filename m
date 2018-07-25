From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/6] kaddr and pfn can be NULL to ->direct_access()
Date: Wed, 25 Jul 2018 14:35:32 -0700
Message-ID: <3689520a-4a49-4e1f-6ee9-2ff4a9796b9f@intel.com>
References: <20180725162849.8320-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180725162849.8320-1-yehs2007-ytc+IHgoah0@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Huaisheng Ye <yehs2007-ytc+IHgoah0@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, chengnt-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, colyli-l3A5Bk7waGM@public.gmane.org, bart.vanassche-Sjgp3cTcYWE@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Pretty straight forward series. Huaisheng, I can apply the whole series
to libnvdimm if we can get ack's from maintainer of dcssblk and
dm-writecache for the respective bits.

On 07/25/2018 09:28 AM, Huaisheng Ye wrote:
> From: Huaisheng Ye <yehs1-6jq1YtArVR3QT0dZR+AlfA@public.gmane.org>
> 
> Changes since v1 [1]:
> * Involve the previous patches for pfn can be NULL.
> * Reword the patch descriptions according to Christian's comment.
> * According to Ross's suggestion, replace local pointer dummy_addr
>   with NULL within md/dm-writecache for direct_access.
> 
> [1]: https://lkml.org/lkml/2018/7/24/199
> 
> Some functions within fs/dax, dax/super and md/dm-writecache don't
> need to get local pointer kaddr or variable pfn from direct_access.
> Assigning NULL to kaddr or pfn to ->direct_access() is more
> straightforward and simple than offering a useless local pointer or
> variable.
> 
> So all ->direct_access() need to check the validity of pointer kaddr
> and pfn for NULL assignment. If either of them is equal to NULL, that
> is to say callers may have no need for kaddr or pfn, so this series of
> patch are prepared for allowing them to pass in NULL instead of having
> to pass in a local pointer or variable that they then just throw away.
> 
> Huaisheng Ye (6):
>   libnvdimm, pmem: kaddr and pfn can be NULL to ->direct_access()
>   s390, dcssblk: kaddr and pfn can be NULL to ->direct_access()
>   tools/testing/nvdimm: kaddr and pfn can be NULL to ->direct_access()
>   dax/super: Do not request a pointer kaddr when not required
>   md/dm-writecache: Don't request pointer dummy_addr when not required
>   filesystem-dax: Do not request kaddr and pfn when not required
> 
>  drivers/dax/super.c             |  3 +--
>  drivers/md/dm-writecache.c      |  3 +--
>  drivers/nvdimm/pmem.c           |  7 +++++--
>  drivers/s390/block/dcssblk.c    |  8 +++++---
>  fs/dax.c                        | 13 ++++---------
>  tools/testing/nvdimm/pmem-dax.c | 12 ++++++++----
>  6 files changed, 24 insertions(+), 22 deletions(-)
> 
