From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] dm: add new loop and ram targets
Date: Wed, 17 Jan 2018 19:36:49 -0500
Message-ID: <20180118003649.GA7649@redhat.com>
References: <cover.1516124587.git.heinzm@redhat.com>
	<20180117212936.GA6756@redhat.com>
	<fcba7e3a-2d90-3507-b810-b5186442f051@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fcba7e3a-2d90-3507-b810-b5186442f051@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 17 2018 at  6:21pm -0500,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> On 01/17/2018 10:29 PM, Mike Snitzer wrote:
>
> >My initial thought for dm-ram was: why?  (considering we have brd and
> >pmem and null_blk).  But for 100 lines of code if nothing else it could
> >serve as yet another example DM target for those interested in learning
> >more about how to implement a DM target.  Would be good to compare its
> >performance with brd, null_blk and pmem though.
> =

> With it we get the dm flexibility to set up ramdisks as opposed to
> brd module parameters.=A0 It's performance is pretty similar
> to brd but it's faster for larger block sizes.
> Yes, the value of its simplicity for beginners is an additonal goody.
> =

> null_blk doesn't quite fit the list lagging backing store support?

Sure, but I was saying null_blk vs dm-ram.  dm-ram doesn't use a backing
store.

> Some numbers in brd, dm-ram, null_blk order:
> # fio --bs=3D32k --rw=3Drandrw --numjobs=3D99 --group_reporting
> --iodepth=3D12 --runtime=3D3=A0 --ioengine=3Dlibaio --loops=3D1 --direct=
=3D1
> --exitall --name pipi --filename=3D/dev/ram0|egrep "read|write"
> =A0=A0 read: IOPS=3D334k, BW=3D10.2GiB/s (10.0GB/s)(30.7GiB/3009msec)
> =A0 write: IOPS=3D334k, BW=3D10.2GiB/s (10.0GB/s)(30.7GiB/3009msec)
> =

> # fio --bs=3D32k --rw=3Drandrw --numjobs=3D99 --group_reporting
> --iodepth=3D12 --runtime=3D3=A0 --ioengine=3Dlibaio --loops=3D1 --direct=
=3D1
> --exitall --name pipi --filename=3D/dev/mapper/ram|egrep "read|write"
> =A0=A0 read: IOPS=3D354k, BW=3D10.8GiB/s (11.6GB/s)(32.4GiB/3005msec)
> =A0 write: IOPS=3D354k, BW=3D10.8GiB/s (11.6GB/s)(32.5GiB/3005msec)
> =

> # fio --bs=3D32k --rw=3Drandrw --numjobs=3D99 --group_reporting
> --iodepth=3D12 --runtime=3D3=A0 --ioengine=3Dlibaio --loops=3D1 --direct=
=3D1
> --exitall --name pipi --filename=3D/dev/nullb0|egrep "read|write"
> =A0=A0 read: IOPS=3D337k, BW=3D10.3GiB/s (11.0GB/s)(30.9GiB/3007msec)
> =A0 write: IOPS=3D337k, BW=3D10.3GiB/s (11.0GB/s)(30.9GiB/3007msec)

Nice, dm-ram is doing best for that test.

> >As for dm-loop, doubling the performance of the loopback driver is quite
> >nice (especially with only 1/7 the number of lines of code as
> >drives/block/loop.c).
> =

> Yes, found this challenging in particular too.
> Didn't bother to cover direct io or async io (yet).
> Much rather wanted to keep it simple.

Ah, OK.  But still, doubling the buffered case isn't insignificant.

Mike
