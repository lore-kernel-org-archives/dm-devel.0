From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 02/14] dm: add ->copy_from_iter() dax operation support
Date: Sun, 18 Jun 2017 19:04:56 -0700
Message-ID: <CAPcyv4hMThgvV6mejT57d_PHbHzVZ3BWyGwFWOx5J40X=2NwDg@mail.gmail.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703983692.20620.3787021839815275819.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170618083702.GB26456@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170618083702.GB26456-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Sun, Jun 18, 2017 at 1:37 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>> +size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>> +             size_t bytes, struct iov_iter *i)
>> +{
>> +     if (!dax_alive(dax_dev))
>> +             return 0;
>> +
>> +     if (!dax_dev->ops->copy_from_iter)
>> +             return copy_from_iter(addr, bytes, i);
>> +     return dax_dev->ops->copy_from_iter(dax_dev, pgoff, addr, bytes, i);
>> +}
>> +EXPORT_SYMBOL_GPL(dax_copy_from_iter);
>
> Can you remove the fallbacks after this series so that we have
> a clean abstraction?

You mean update all implementations to register copy_from_iter() as
their default op rather than workaround a NULL op in the core? Yeah, I
can do that.
