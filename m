From: James Hogarth <james.hogarth@gmail.com>
Subject: Fwd: [Vdo-devel] Trying to test thin provisioned LVM on
	VDO
Date: Wed, 11 Jul 2018 11:51:19 +0100
Message-ID: <CAGkb5vd5Q1qRZFi8dz-gyRzj87cPFih+D06ojCXBkHZBkFh3+g@mail.gmail.com>
References: <CAGkb5veuGH=ry3dzmeKWKxva42J3353y4K8JDOOy3dukeWee7w@mail.gmail.com>
	<CAJtpHn9k4HXHOsvO4gsuWfimLfMFXAZALArpp2Ryq2NL2YZV2g@mail.gmail.com>
	<CAGkb5vfrd5SJeY3Aa5FwMEsna2p66Pg0YrXHaLX2NEAWm=eZ_g@mail.gmail.com>
	<CAGkb5vec2pF1XiSgRP7zKaW8ew1titUhdjSjCtO-Wric_BjwEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAGkb5vec2pF1XiSgRP7zKaW8ew1titUhdjSjCtO-Wric_BjwEQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Forwarding to dm-devel as it appears the issue to be resolved for VDO
to receive discards correctly needs a code change in dm-thin ...

See start of thread here for full details:

https://www.redhat.com/archives/vdo-devel/2018-July/msg00000.html


---------- Forwarded message ----------
From: James Hogarth <james.hogarth@gmail.com>
Date: 11 July 2018 at 11:48
Subject: Re: [Vdo-devel] Trying to test thin provisioned LVM on VDO
To: vdo-devel@redhat.com
Cc: Michael Sclafani <sclafani@redhat.com>, snitzer@redhat.com


On 11 July 2018 at 11:26, James Hogarth <james.hogarth@gmail.com> wrote:
> On 11 July 2018 at 10:40, Michael Sclafani <sclafani@redhat.com> wrote:
>> Based on the error message and a quick scan of the code, it appears dm-thin
>> disables discards because VDO's max_discard_sectors = 4KB is smaller than
>> dm-thin's 64KB+ block size. I have no idea why it does that, but if it
>> neither discards nor zeros out blocks it has written to VDO, that space will
>> not be reclaimed.
>>
>
> Thanks for confirming the line of thought I was following ...
>
> Annoyingly this makes the RHEL documentation pretty useless to follow
> for carrying out thin provisioned volumes...
>
> Unfortunately I don't have a support account to hand to raise this as
> a RHEL7.5 issue to resolve ...
>
> Looking at the lvcreate man page it's not possible to set a block size
> for a thin pool below 64K
>
> -c|--chunksize Size[k|UNIT]
>               The size of chunks in a snapshot, cache pool or thin
> pool.  For snapshots, the value
>               must be a power of 2 between 4KiB and 512KiB and the
> default value is 4.  For a cache
>               pool the value must be between 32KiB and 1GiB and the
> default value is 64.  For a thin
>               pool the value must be between 64KiB and 1GiB and the
> default value starts with 64 and
>               scales up to fit the pool metadata size within 128MiB,
> if the pool metadata size is not
>               specified.  The value must be a multiple of 64KiB.  See
> lvmthin(7) and lvmcache(7) for
>               more information.
>
> What's going to be the best approach to resolve this so that thin
> provisioning works as expected? It's obviously not advisable to use in
> this configuration due to the inevitable disk exhaustion issue that
> will arise.


Mike you wrote the relevant patch that appears to be causing the
conflict and prevents dm-thin passing the discard to VDO here:

https://www.redhat.com/archives/dm-devel/2012-August/msg00381.html

I know it was a while back but do you recall what the reason for the
max_discard_sector and sectors_per_block comparison was for?

From the VDO code it appears untenable to increase maxDiscardSector
without major performance impact - to the extent of I/O stalls.

So it looks like the only way to make this work is a change to dm-thin
to ensure the discards are still passed to the VDO layer below it.
