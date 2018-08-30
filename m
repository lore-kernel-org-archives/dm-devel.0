From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] Snapshot target and DAX-capable devices
Date: Thu, 30 Aug 2018 15:17:16 -0400
Message-ID: <x498t4naclf.fsf@segfault.boston.devel.redhat.com>
References: <20180827160744.GE4002@quack2.suse.cz>
 <e38303902267d2d8bae8b0c88da84a4ed668e9fb.camel@hpe.com>
 <20180828075025.GA17756@quack2.suse.cz>
 <20180828175630.GA1197@redhat.com>
 <20180830093028.GC1767@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180830093028.GC1767-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org> (Jan Kara's message of
 "Thu, 30 Aug 2018 11:30:28 +0200")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> writes:

> On Tue 28-08-18 13:56:30, Mike Snitzer wrote:
>> On Tue, Aug 28 2018 at  3:50am -0400,
>> Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
>> 
>> > On Mon 27-08-18 16:43:28, Kani, Toshi wrote:
>> > > On Mon, 2018-08-27 at 18:07 +0200, Jan Kara wrote:
>> > > > Hi,
>> > > > 
>> > > > I've been analyzing why fstest generic/081 fails when the backing device is
>> > > > capable of DAX. The problem boils down to the failure of:
>> > > > 
>> > > > lvm vgcreate -f vg0 /dev/pmem0
>> > > > lvm lvcreate -L 128M -n lv0 vg0
>> > > > lvm lvcreate -s -L 4M -n snap0 vg0/lv0
>> > > > 
>> > > > The last command fails like:
>> > > > 
>> > > >   device-mapper: reload ioctl on (253:0) failed: Invalid argument
>> > > >   Failed to lock logical volume vg0/lv0.
>> > > >   Aborting. Manual intervention required.
>> > > > 
>> > > > And the core of the problem is that volume vg0/lv0 is originally of
>> > > > DM_TYPE_DAX_BIO_BASED type but when the snapshot gets created, we try to
>> > > > switch it to DM_TYPE_BIO_BASED because now the device stops supporting DAX.
>> > > > The problem seems to be introduced by Ross' commit dbc626597 "dm: prevent
>> > > > DAX mounts if not supported".
>> > > > 
>> > > > The question is whether / how this should be fixed. The current inability
>> > > > to create snapshots of DAX-capable devices looks weird and the cryptic
>> > > > failure makes it even worse (it took me quite a while to understand what is
>> > > > failing and why). OTOH I see the rationale behind Ross' change as well.
>> > > 
>> > > Here are the dm-snap changes that went along with the original DAX
>> > > support.
>> > > 
>> > > commit b5ab4a9ba55
>> > > commit f6e629bd237
>> > > 
>> > > Basically, snapshots can be added/removed to DAX-capable devices, but
>> > > snapshots need to be mounted without dax option.
>> > 
>> > Yes, and after these two commits things were working. But then commit
>> > dbc626597 broke things again so currently snapshotting DAX-capable devices
>> > does not work. Just try with 4.18...
>> 
>> Commit f6e629bd237 was a nasty hack, and commit dbc626597 exposed it as
>> such.  But commit dbc626597 has caused us to regress.. so we need to fix
>> it.
>> 
>> We could remove DM_TYPE_DAX_BIO_BASED completely.  But in the past I was
>> reluctant to do so because it really is unclear how/if we can even
>> support a device switching from DAX to non-DAX while IO is in-flight. DM
>> supports suspending without flushing (via dmsetup suspend --noflush) and
>> that could really be problematic if we leave DAX IO inflight and then
>> switch the DM table such that the DM device no longer supports DAX.
>
> Well, changing device from DAX-capable to DAX-incapable is problematic for
> filesystem on top of it as well. Filesystems simply don't expect this
> feature of a device can change so they would fail in unexpected ways. Also
> PFNs from the pmem (DAX-capable) device that are already mapped to user page
> tables won't magically become unmapped so those processes will still have
> DAX access to those areas of the device.
>
> But, if both original bdev and COW device are DAX-capable, we *should* be
> able to support snapshotting (and refusing mixing of DAX-capable and
> DAX-incapable devices in a snapshot is IMHO not very surprising to users).
> When creating a snapshot of a device, we need to freeze the filesystem
> using it. That will writeprotect all page tables so we are sure we'll get
> page faults (and thus ->direct_access requests from DM POV) for each write
> attempt to any mapping. Then ->direct_access method of snapshot-origin can
> make sure to copy original contents to the COW-device before returning PFN
> from ->direct_access. Similarly ->direct_access of COW-device can provide
> remapped PFN so everything should work seamlessly from user POV.

In your example above, if two processes have a file mapped with
MAP_SHARED, and P1 does a store, the new contents will not be reflected
in P2, right?.  This is different from what is expected, and different
from what happens when the page cache is involved.

I think you'd need to unmap all mappings on a CoW, whether triggered by
a store to an existing mapping or a write(2).

-Jeff
