From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9] dax, dm: introduce ->fs_{claim, release}() dax_device
 infrastructure
Date: Tue, 3 Apr 2018 17:13:20 -0400
Message-ID: <20180403211320.GA7835@redhat.com>
References: <CAPcyv4gSh29g7ZSuWnZVTdgXXS_027qvQNLgAUA+JrFwefXW+w@mail.gmail.com>
 <152278769715.7139.9560094354006725491.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <152278769715.7139.9560094354006725491.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Apr 03 2018 at  4:36pm -0400,
Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> In preparation for allowing filesystems to augment the dev_pagemap
> associated with a dax_device, add an ->fs_claim() callback. The
> ->fs_claim() callback is leveraged by the device-mapper dax
> implementation to iterate all member devices in the map and repeat the
> claim operation across the array.
> =

> In order to resolve collisions between filesystem operations and DMA to
> DAX mapped pages we need a callback when DMA completes. With a callback
> we can hold off filesystem operations while DMA is in-flight and then
> resume those operations when the last put_page() occurs on a DMA page.
> The ->fs_claim() operation arranges for this callback to be registered,
> although that implementation is saved for a later patch.
> =

> Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: "J=E9r=F4me Glisse" <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> Changes since v8:
> * make __fs_dax_claim and __fs_dax_release private to
>   drivers/dax/super.c
> =

> * rename dm_dax_iterate to dm_dax_interate_devices (Mike)
> =

> * drop the return value from dm_dax_interate_devices since nothing uses
>   it (Mike)

Acked-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
