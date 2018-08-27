From: "Kani, Toshi" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: Snapshot target and DAX-capable devices
Date: Mon, 27 Aug 2018 16:43:28 +0000
Message-ID: <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
References: <20180827160744.GE4002@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180827160744.GE4002-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Content-ID: <090B267D40F391409D5CDE9EF74773E1-mmYPd6ayCNGroOM5E8FhRbjFIynDaujOfM0AETQt39g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "jack-AlSwsSmVLrQ@public.gmane.org" <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, 2018-08-27 at 18:07 +0200, Jan Kara wrote:
> Hi,
> 
> I've been analyzing why fstest generic/081 fails when the backing device is
> capable of DAX. The problem boils down to the failure of:
> 
> lvm vgcreate -f vg0 /dev/pmem0
> lvm lvcreate -L 128M -n lv0 vg0
> lvm lvcreate -s -L 4M -n snap0 vg0/lv0
> 
> The last command fails like:
> 
>   device-mapper: reload ioctl on (253:0) failed: Invalid argument
>   Failed to lock logical volume vg0/lv0.
>   Aborting. Manual intervention required.
> 
> And the core of the problem is that volume vg0/lv0 is originally of
> DM_TYPE_DAX_BIO_BASED type but when the snapshot gets created, we try to
> switch it to DM_TYPE_BIO_BASED because now the device stops supporting DAX.
> The problem seems to be introduced by Ross' commit dbc626597 "dm: prevent
> DAX mounts if not supported".
> 
> The question is whether / how this should be fixed. The current inability
> to create snapshots of DAX-capable devices looks weird and the cryptic
> failure makes it even worse (it took me quite a while to understand what is
> failing and why). OTOH I see the rationale behind Ross' change as well.

Here are the dm-snap changes that went along with the original DAX
support.

commit b5ab4a9ba55
commit f6e629bd237

Basically, snapshots can be added/removed to DAX-capable devices, but
snapshots need to be mounted without dax option.

Thanks,
-Toshi
