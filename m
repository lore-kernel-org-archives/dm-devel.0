From: Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v3 0/6] kaddr and pfn can be NULL to ->direct_access()
Date: Tue, 31 Jul 2018 08:35:58 -0700
Message-ID: <d39a623d-5071-731b-87ae-9f9bd11024c6@intel.com>
References: <20180730071548.9172-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180730071548.9172-1-yehs2007@zoho.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Huaisheng Ye <yehs2007@zoho.com>, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, willy@infradead.org, vishal.l.verma@intel.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, viro@zeniv.linux.org.uk, martin.petersen@oracle.com, axboe@kernel.dk, gregkh@linuxfoundation.org, bart.vanassche@wdc.com, jack@suse.cz, agk@redhat.com, snitzer@redhat.com, keescook@chromium.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, colyli@suse.de, chengnt@lenovo.com, Huaisheng Ye <yehs1@lenovo.com>
List-Id: dm-devel.ids

On 7/30/2018 12:15 AM, Huaisheng Ye wrote:

Applied
> From: Huaisheng Ye <yehs1@lenovo.com>
>
> Changes since v2 [2]:
> * Collect Martin and Mike's acks for dcssblk and dm-writecache;
> * Rebase the series of patch to v4.18-rc7.
>
> Changes since v1 [1]:
> * Involve the previous patches for pfn can be NULL.
> * Reword the patch descriptions according to Christian's comment.
> * According to Ross's suggestion, replace local pointer dummy_addr
>    with NULL within md/dm-writecache for direct_access.
>
> [1]: https://lkml.org/lkml/2018/7/24/199
> [2]: https://lkml.org/lkml/2018/7/25/581
>
> Some functions within fs/dax, dax/super and md/dm-writecache don't
> need to get local pointer kaddr or variable pfn from direct_access.
> Assigning NULL to kaddr or pfn with ->direct_access() is more
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
>    libnvdimm, pmem: kaddr and pfn can be NULL to ->direct_access()
>    s390, dcssblk: kaddr and pfn can be NULL to ->direct_access()
>    tools/testing/nvdimm: kaddr and pfn can be NULL to ->direct_access()
>    dax/super: Do not request a pointer kaddr when not required
>    md/dm-writecache: Don't request pointer dummy_addr when not required
>    filesystem-dax: Do not request kaddr and pfn when not required
>
>   drivers/dax/super.c             |  3 +--
>   drivers/md/dm-writecache.c      |  3 +--
>   drivers/nvdimm/pmem.c           |  7 +++++--
>   drivers/s390/block/dcssblk.c    |  8 +++++---
>   fs/dax.c                        | 13 ++++---------
>   tools/testing/nvdimm/pmem-dax.c | 12 ++++++++----
>   6 files changed, 24 insertions(+), 22 deletions(-)
>
