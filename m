From: "Mears, Morgan" <Morgan.Mears@netapp.com>
Subject: Re: dm-cache mq policy warmup issue
Date: Wed, 13 Nov 2013 16:13:43 +0000
Message-ID: <33A0129EBFD46748804DE81B354CA1B21C031CD6@SACEXCMBX06-PRD.hq.netapp.com>
References: <9BDA3ECEC2A5454BB4294114677019E131B6C2F9@SACEXCMBX02-PRD.hq.netapp.com>
	<33A0129EBFD46748804DE81B354CA1B21C031288@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B21C031288@SACEXCMBX06-PRD.hq.netapp.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 04, 2013 at 12:22:26PM -0500, Krishnasamy, Somasundaram wrote:
> Mike,
> =

> I was doing some testing with latest dm-cache code (from 'for-next' branc=
h). I
> am having difficulty in making the cache to warm-up. I used the below scr=
ipt
> to read range of blocks repeatedly to get them promoted. I assume after
> reading a block for mq->promote_threshold + 4 times, a block will be
> promoted. But it is not happening. I also tested the same with the
> sequential_threshold set to very high value.
> =

> Cache warming-up was relatively easier in the previous dm-cache code. Is =
this
> something you have seen in your testing?. Is there anything different sho=
uld I
> do?

I'm also testing with the for-next branch of linux-dm.git and seeing the
same thing as Somu.  It's easy to reproduce; reading the same block on the
cached device over and over with dd does not result in that block being
promoted.

I did notice that the "read miss" counter for the cached device increments
each time I execute dd, which I believe means this isn't a buffer cache
issue (I also used dd iflag=3Ddirect).  The migration_threshold value
shouldn't be an issue for this test, but I set it to a very high value
anyway; didn't make any difference.

Are there any tests in device-mapper-test-suite that you would recommend
for testing whether promotions are occurring as expected?

--Morgan

> Note: /dev/mapper/mydev is the dm-cache target device. I ran the below
> script with "64k 100 100 0" as argument.
> -----------
> #!/bin/bash
> =

> if [[ $# -lt 4 ]]
> then
> =A0=A0=A0=A0=A0=A0=A0 echo "Usage: $0 <cache_block_size> <nblocks to prom=
ote> <nread of a
> block> <start_block>"
> =A0=A0=A0=A0=A0=A0=A0 exit 1
> fi
> =

> BSSIZE=3D$1
> ((TOTAL=3D$2+$4))
> HITCNT=3D$3
> =

> # Read even numbered blocks
> blkcnt=3D$4
> while [[ blkcnt -lt $TOTAL ]]
> do
> =A0=A0=A0=A0=A0=A0=A0 i=3D0
> =A0=A0=A0=A0=A0=A0=A0 echo "Reading block $blkcnt $HITCNT times"
> =A0=A0=A0=A0=A0=A0=A0 while [[ $i -lt $HITCNT ]]
> =A0=A0=A0=A0=A0=A0=A0 do
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dd if=3D/dev/mapper/mydev o=
f=3D/dev/null bs=3D$BSSIZE skip=3D$blkcnt
> count=3D1 conv=3Dnotrunc iflag=3Ddirect 2> /dev/null
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if [[ $? -ne 0 ]]
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0then
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ech=
o "I/O failure. exiting."
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exi=
t 1
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fi
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ((i=3Di+1))
> =A0=A0=A0=A0=A0=A0=A0 done
> =

> =A0=A0=A0=A0=A0=A0=A0 ((blkcnt=3Dblkcnt+2))
> =

> =A0=A0=A0=A0=A0=A0=A0 PROMOTED=3D$(dmsetup status mydev | awk '{print $11=
}')
> =A0=A0 =A0=A0=A0=A0=A0echo "Promoted blocks so far: $PROMOTED"
> done
> =

> # Read odd numbered blocks
> ((blkcnt=3D$4+1))
> while [[ blkcnt -lt $TOTAL ]]
> do
> =A0=A0=A0=A0=A0=A0=A0 i=3D0
> =A0=A0=A0=A0=A0=A0=A0 echo "Reading block $blkcnt $HITCNT times"
> =A0=A0=A0=A0=A0=A0=A0 while [[ $i -lt $HITCNT ]]
> =A0=A0=A0=A0=A0=A0=A0 do
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dd if=3D/dev/mapper/mydev o=
f=3D/dev/null bs=3D$BSSIZE skip=3D$blkcnt
> count=3D1 conv=3Dnotrunc iflag=3Ddirect 2> /dev/null
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if [[ $? -ne 0 ]]
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 then
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ech=
o "I/O failure. exiting."
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 exi=
t 1
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fi
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ((i=3Di+1))
> =A0=A0=A0=A0=A0=A0=A0 done
> =

> =A0=A0=A0=A0=A0=A0=A0 ((blkcnt=3Dblkcnt+2))
> =

> =A0=A0=A0=A0=A0=A0=A0 PROMOTED=3D$(dmsetup status mydev | awk '{print $11=
}')
> =A0=A0=A0=A0=A0=A0=A0 echo "Promoted blocks so far: $PROMOTED"
> done
> ------------
> =

> Regards,
> Somu.
