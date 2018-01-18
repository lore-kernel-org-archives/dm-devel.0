From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 17:18:40 -0500
Message-ID: <1516313920.24506.4.camel@redhat.com>
References: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
         <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
         <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
         <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
         <20180118204856.GA31679@redhat.com> <1516309128.2676.38.camel@wdc.com>
         <20180118212327.GB31679@redhat.com> <1516311554.2676.50.camel@wdc.com>
         <20180118220132.GA20860@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180118220132.GA20860@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, 2018-01-18 at 17:01 -0500, Mike Snitzer wrote:
> On Thu, Jan 18 2018 at  4:39pm -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Thu, 2018-01-18 at 16:23 -0500, Mike Snitzer wrote:
> > > On Thu, Jan 18 2018 at  3:58P -0500,
> > > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > > 
> > > > On Thu, 2018-01-18 at 15:48 -0500, Mike Snitzer wrote:
> > > > > For Bart's test the underlying scsi-mq driver is what is
> > > > > regularly
> > > > > hitting this case in __blk_mq_try_issue_directly():
> > > > > 
> > > > >         if (blk_mq_hctx_stopped(hctx) ||
> > > > > blk_queue_quiesced(q))
> > > > 
> > > > These lockups were all triggered by incorrect handling of
> > > > .queue_rq() returning BLK_STS_RESOURCE.
> > > 
> > > Please be precise, dm_mq_queue_rq()'s return of BLK_STS_RESOURCE?
> > > "Incorrect" because it no longer runs
> > > blk_mq_delay_run_hw_queue()?
> > 
> > In what I wrote I was referring to both dm_mq_queue_rq() and
> > scsi_queue_rq().
> > With "incorrect" I meant that queue lockups are introduced that
> > make user
> > space processes unkillable. That's a severe bug.
> 
> And yet Laurence cannot reproduce any such lockups with your test...
> 
> Are you absolutely certain this patch doesn't help you?
> https://patchwork.kernel.org/patch/10174037/
> 
> If it doesn't then that is actually very useful to know.
> 
> > > We have time to get this right, please stop hyperventilating
> > > about
> > > "regressions".
> > 
> > Sorry Mike but that's something I consider as an unfair comment. If
> > Ming and
> > you work on patches together, it's your job to make sure that no
> > regressions
> > are introduced. Instead of blaming me because I report these
> > regressions you
> > should be grateful that I take the time and effort to report these
> > regressions
> > early. And since you are employed by a large organization that
> > sells Linux
> > support services, your employer should invest in developing test
> > cases that
> > reach a higher coverage of the dm, SCSI and block layer code. I
> > don't think
> > that it's normal that my tests discovered several issues that were
> > not
> > discovered by Red Hat's internal test suite. That's something Red
> > Hat has to
> > address.
> 
> You have no self-awareness of just how mypoic you're being about
> this.
> 
> I'm not ignoring or blaming you for your test no longer passing.  Far
> from it.  I very much want to fix this.  But I want it fixed in a way
> that doesn't paper over the real bug(s) while also introducing blind
> queue runs that compromise the blk-mq RESTART code's ability to work
> as
> intended.
> 
> I'd have thought you could appreciate this.  We need a root cause on
> this, not hand-waving justifications on why problematic delayed queue
> runs are correct.
> 
> Please just focus on helping Laurence get his very capable testbed to
> reproduce this issue.  Once we can reproduce these "unkillable"
> "stalls"
> in-house it'll be _much_ easier to analyze and fix.
> 
> Thanks,
> Mike

Hello Bart

OK, I ran 5 at once of 5 separate mount points.
I am using 4k block sizes
Its solid consistent for me. No stalls no gaps.

[global]
name=02-mq
filename=fio-output-02-mq.txt
rw=randwrite
verify=md5
;rwmixread=60
;rwmixwrite=40
bs=4K
;direct=1
;numjobs=4
;time_based=1
runtime=120

[file1]
size=3G
ioengine=libaio
iodepth=16

I watch I/O and I see it ramp up but fio still runs and it kind of
shuts down.

#!/bin/bash
for i in 1 2 3 4 5
do
	cd /data-$i 
	fio /root/srp-test.lobe/fio_tests/02-mq 1>/data-$i.out 2>&1 &
done


#Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes 

17:16:09   34  12 34431  10393      0      0 249872  36094 
17:16:10   31  10 13001   2679      0      0  57652   7980 
17:16:11   32  11 19473   4416      0      0 143248  17362 
17:16:12   31   9  8068   1606      0      0  20088   2026 
17:16:13   31   9  7718   1518      0      0  15908   1354 
17:16:14   36  14 41132   9710      0      0 686216  46661 
17:16:15   39  18 63622  21033      0      0  1246K  75108 
17:16:16   38  16 76114   9013      0      0  1146K  82338 
17:16:17   33  11 31941   2735      0      0 237340  25034 
17:16:18   36  14 23900   4982      0      1  1567K  43244 
17:16:19   37  15 55884   4974      0      4  1003K  67253 
17:16:20   28  12  7542   4975      0      0  1630K   3266 
17:16:21    8   6 14650  34721      0      0  2535K  21206 
17:16:22    2   2  6655  15839      0      0  2319K   9897 
17:16:23   11  11 37305 134030      0      0  1275K  87010 
17:16:24   23  22 59266 119350   6560   1640  1102K  78034 
17:16:25   21  17 65699 144462 148052  37013 159900  22120 
17:16:26   14   9 80700 164034 216588  54147      4      1 
#         <----CPU[HYPER]-----><----------Disks----------->
#Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes 
17:16:27   14   9 78699 162095 214412  53603      0      0 
17:16:28   14   9 75895 155352 204932  51233      0      0 
17:16:29   14   9 75377 161871 214136  53534      0      0 
17:16:30   16  11 79298 155967 206164  51541      0      0 
17:16:31   14   8 82281 165266 218652  54662      0      0 
17:16:32   14   9 88635 163302 215876  53970      0      0 
17:16:33   14   8 88755 168958 223568  55892      0      0 
17:16:34   15   9 82073 154321 203936  50984      0      0 
17:16:35   17  10 87004 161467 213308  53327      0      0 
17:16:36   15   9 86198 161247 212940  53235      4      1 
17:16:37   15   9 83429 162890 215276  53819      0      0 
17:16:38   16  10 83272 160611 212264  53066     20      2 
17:16:39   16  10 93850 168179 222376  55594      0      0 
17:16:40   15   9 86801 167507 221372  55343      0      0 
17:16:41   14   8 82688 171249 226560  56640      0      0 
17:16:42   14   8 86202 159171 210344  52586      0      0 
17:16:43   16  10 86063 156009 206328  51582      0      0 
17:16:44   16  10 90927 153961 203584  50896      0      0 
17:16:45   15   9 95084 156370 206844  51710    132     13 
17:16:46   14   8 85572 158469 209300  52326      4      1 
17:16:47   14   8 92075 158469 209600  52400      0      0 
17:16:48   16  10 95469 154772 204176  51044      0      0 
#         <----CPU[HYPER]-----><----------Disks----------->
#Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes 
17:16:49   15  10 93856 154182 203568  50897      5      5 
17:16:50   15  10 92308 151964 200680  50170      0      0 
17:16:51   16  10 94035 155076 204868  51217      0      0 
17:16:52   15   9 93949 164969 217980  54495      0      0 
17:16:53   14   9 85744 149553 197428  49357      0      0 
17:16:54   14   9 83064 155788 205684  51421      0      0 
17:16:55   16  10 83579 166084 218480  54620      0      0 
17:16:56   15   9 74766 158728 208556  52139      4      1 
17:16:57   14   9 82944 162720 215116  53779      0      0 
17:16:58   12   7 88529 163814 216440  54110      0      0 
17:16:59   14   7 85936 166723 220372  55093      4      1 
17:17:00   13   8 86701 153728 203052  50763      0      0 
17:17:01   14   9 92859 155963 205972  51493      0      0 
17:17:02   13   8 85624 143746 189756  47439      0      0 
17:17:03   13   8 85029 142540 188044  47010      0      0 
17:17:04   14   8 87291 144790 191148  47788      0      0 
17:17:05   14   8 81922 144342 190544  47636      0      0 
17:17:06   14   8 81587 161043 212576  53144      8      2 
17:17:07   15   8 85080 142285 187688  46922      0      0 
17:17:08   13   8 86980 150246 197852  49463      0      0 
17:17:09   12   8 81388 144335 190312  47578      4      1 
17:17:10   13   8 88436 146957 194040  48510      0      0 
#         <----CPU[HYPER]-----><----------Disks----------->
#Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes 
17:17:11   11   7 78997 137847 181828  45457      0      0 
17:17:12   12   8 85709 148847 196708  49177      0      0 
17:17:13   17  10 97228 170646 225528  56382      0      0 
17:17:14   14   9 96032 173474 229400  57350      0      0 
17:17:15   15   9 95340 167951 221848  55462      0      0 
17:17:16   16  10 87392 157489 207748  51937     38      5 
17:17:17   16  10 84756 152753 201716  50429      0      0 
17:17:18   17  10 85109 153000 202080  50520      0      0 
17:17:19   16  10 92109 164514 217396  54349     80      5 
17:17:20   15   9 91342 155674 205804  51451      0      0 
17:17:21   12   7 73921 126577 167060  41765      0      0 
17:17:22   13   8 76916 126701 167176  41794      0      0 
17:17:23   13   8 85187 151074 199768  49942      0      0 
17:17:24   15   9 85737 153664 203168  50792      0      0 
17:17:25   15   9 87113 147636 195084  48771      0      0 
17:17:26   14   8 89440 157433 208116  52029      4      1 
17:17:27   14   9 95290 172224 227036  56759      0      0 
17:17:28   15  10 93918 167611 220164  55041      0      0 
17:17:29   13   8 82404 149274 197312  49328      0      0 
17:17:30   10   7 75961 138276 182668  45667      0      0 
17:17:31   12   8 84899 151829 200764  50191      0      0 
17:17:32   13   8 81386 141091 186444  46611      0      0 
17:17:33   15   9  100K 167489 221640  55410      0      0 
17:17:34   14   9 89601 158765 210032  52508      0      0 
17:17:35   14   9 92440 155287 205216  51304      0      0 
17:17:36   15  10 90042 155934 206168  51542      4      1 
17:17:37   14   9 91670 164456 217684  54421      0      0 
17:17:38   14   9 78612 167368 221348  55337      0      0 
17:17:39   15   9 91325 162599 214616  53654      0      0 
17:17:40   14   9 79112 151595 199984  50000     21      8 
17:17:41    9   3 32565  60936  79832  19964     32     12 
