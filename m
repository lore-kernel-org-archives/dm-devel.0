From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 0/3] Fix DM DAX handling
Date: Tue, 26 Jun 2018 14:48:25 -0400
Message-ID: <20180626184824.GA7114@redhat.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180626175932.8899-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Tue, Jun 26 2018 at  1:59pm -0400,
Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:

> This series fixes a few issues that I found with DM's handling of DAX
> devices.  Here are some of the issues I found:
> 
>  * We can create a dm-stripe or dm-linear device which is made up of an
>    fsdax PMEM namespace and a raw PMEM namespace but which can hold a
>    filesystem mounted with the -o dax mount option.  DAX operations to
>    the raw PMEM namespace part lack struct page and can fail in
>    interesting/unexpected ways when doing things like fork(), examining
>    memory with gdb, etc.
> 
>  * We can create a dm-stripe or dm-linear device which is made up of an
>    fsdax PMEM namespace and a BRD ramdisk which can hold a filesystem
>    mounted with the -o dax mount option.  All I/O to this filesystem
>    will fail.
> 
> ---
> 
> Changes since v2:
>   * Only set QUEUE_FLAG_DAX for fsdax mode PMEM namespaces. (Mike)
>   * Check for QUEUE_FLAG_DAX in __bdev_dax_supported(). (Mike)
>   * Get rid of DM_TYPE_DAX_BIO_BASED reworks. (Mike)
>   * Dropped the first 2 prep patches of v2 since they were merged for
>     v4.18-rc1.  (Thanks, Darrick!)
> 
> ---
> 
> Mike, can you take this series through your tree?
> 
> Personally I think this should be treated as a bug fix and merged in the
> v4.18-rc* series.

I'd be fine with staging it for 4.18.  Only question is whether others
are fine with the dax patch (and me being the one to get it to Linus)?

I already replied to the 3rd patch with some feedback for v4 (but I can
also take care of those changes if I'm the one to stage these changes).

Maybe if Dan and/or others could provide their review for both the dax
and pmem patches?  If I can get review on those I'll get the series
staged for Linus to pull this week.

Thanks,
Mike
