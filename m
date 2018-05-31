From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Date: Thu, 31 May 2018 13:35:54 -0700
Message-ID: <CAPcyv4i6t1zahuL73m+oL5qiRJ_oikOszBvTMxoby62Z_0e7Hw@mail.gmail.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com> <20180531191332.GB7825@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180531191332.GB7825@magnolia>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, May 31, 2018 at 12:13 PM, Darrick J. Wong
<darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
>> On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
>> > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
>> > > From: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > >
>> > > The function return values are confusing with the way the function is
>> > > named. We expect a true or false return value but it actually returns
>> > > 0/-errno.  This makes the code very confusing. Changing the return values
>> > > to return a bool where if DAX is supported then return true and no DAX
>> > > support returns false.
>> > >
>> > > Signed-off-by: Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> >
>> > Looks ok, do you want me to pull the first two patches through the xfs
>> > tree?
>> >
>> > Reviewed-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> Thanks for the review.
>>
>> I'm not sure what's best.  If you do that then Mike will need to have a DM
>> branch for the rest of the series based on your stable commits, yea?
>>
>> Mike what would you prefer?
>
> I /was/ about to say that I would pull in the first two patches, but now
> I can't get xfs to mount with pmem at all, and have no way of testing
> this...?
>
> # echo 'file drivers/dax/* +p' > /sys/kernel/debug/dynamic_debug/control
> # mount /dev/pmem3 -o rtdev=/dev/pmem4,dax /mnt
> # dmesg
> <snip>
> SGI XFS with ACLs, security attributes, realtime, scrub, debug enabled
> XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> pmem3: error: dax support not enabled
> pmem4: error: dax support not enabled
> XFS (pmem3): DAX unsupported by block device. Turning off DAX.
> XFS (pmem3): Mounting V5 Filesystem
> XFS (pmem3): Ending clean mount
>
> Evidently the pfn it picks up is missing PFN_MAP in flags because
> ND_REGION_PAGEMAP isn't set, and looking at the kernel source, pmem that
> comes in via NFIT never gets that set...?
>
> relevant qemu pmem options:
>
> -object memory-backend-file,id=memnvdimm0,prealloc=no,mem-path=/dev/shm/a.img,share=yes,size=13488881664
> -device nvdimm,node=0,memdev=memnvdimm0,id=nvdimm0,slot=0
> (repeat for five more devices)
>
> <confused>
>

What does "ndctl list" say? The namespaces need to be in fsdax mode.
