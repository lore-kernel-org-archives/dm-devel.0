From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Qemu-devel] [PATCH v12 4/7] dm: enable synchronous dax
Date: Tue, 11 Jun 2019 22:23:09 -0400 (EDT)
Message-ID: <332155967.34508010.1560306189624.JavaMail.zimbra@redhat.com>
References: <20190611163802.25352-1-pagupta@redhat.com>
 <20190611163802.25352-5-pagupta@redhat.com>
 <20190611171416.GA1248@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190611171416.GA1248-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adilger kernel <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jstaron-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kilobyte-b9QjgO8OEXPVItvQsEIGlw@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, yuval shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, xiaoguangrong eric <xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cohuck-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, darrick wong <darrick.wong>
List-Id: dm-devel.ids


> On Tue, Jun 11 2019 at 12:37pm -0400,
> Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > This patch sets dax device 'DAXDEV_SYNC' flag if all the target
> > devices of device mapper support synchrononous DAX. If device
> > mapper consists of both synchronous and asynchronous dax devices,
> > we don't set 'DAXDEV_SYNC' flag.
> > 
> > 'dm_table_supports_dax' is refactored to pass 'iterate_devices_fn'
> > as argument so that the callers can pass the appropriate functions.
> > 
> > Suggested-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Thanks, and for the benefit of others, passing function pointers like
> this is perfectly fine IMHO because this code is _not_ in the fast
> path.  These methods are only for device creation.
> 
> Reviewed-by: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thank you, Mike

Best regards,
Pankaj

> 
> 
