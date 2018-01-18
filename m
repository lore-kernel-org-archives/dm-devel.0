From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes
	idle
Date: Thu, 18 Jan 2018 17:20:14 -0500
Message-ID: <CAFfF4qssnQjaAPnAimEN9fpf4E62zw3UMfVrjRbX3dQmmuNDFA@mail.gmail.com>
References: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
	<20180118170353.GB19734@redhat.com>
	<1516296056.2676.23.camel@wdc.com> <20180118183039.GA20121@redhat.com>
	<1516301278.2676.35.camel@wdc.com>
	<deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
	<20180118204856.GA31679@redhat.com> <1516309128.2676.38.camel@wdc.com>
	<20180118212327.GB31679@redhat.com> <1516311554.2676.50.camel@wdc.com>
	<20180118220132.GA20860@redhat.com>
	<1516313920.24506.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0138700462631281455=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1516313920.24506.4.camel@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

--===============0138700462631281455==
Content-Type: multipart/alternative; boundary="001a1147a26c37834c0563145e89"

--001a1147a26c37834c0563145e89
Content-Type: text/plain; charset="UTF-8"

That should have said fio still runs and it only shuts down when done
I simply dont see the stalls

On Thu, Jan 18, 2018 at 5:18 PM, Laurence Oberman <loberman@redhat.com>
wrote:

> On Thu, 2018-01-18 at 17:01 -0500, Mike Snitzer wrote:
> > On Thu, Jan 18 2018 at  4:39pm -0500,
> > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> >
> > > On Thu, 2018-01-18 at 16:23 -0500, Mike Snitzer wrote:
> > > > On Thu, Jan 18 2018 at  3:58P -0500,
> > > > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > > >
> > > > > On Thu, 2018-01-18 at 15:48 -0500, Mike Snitzer wrote:
> > > > > > For Bart's test the underlying scsi-mq driver is what is
> > > > > > regularly
> > > > > > hitting this case in __blk_mq_try_issue_directly():
> > > > > >
> > > > > >         if (blk_mq_hctx_stopped(hctx) ||
> > > > > > blk_queue_quiesced(q))
> > > > >
> > > > > These lockups were all triggered by incorrect handling of
> > > > > .queue_rq() returning BLK_STS_RESOURCE.
> > > >
> > > > Please be precise, dm_mq_queue_rq()'s return of BLK_STS_RESOURCE?
> > > > "Incorrect" because it no longer runs
> > > > blk_mq_delay_run_hw_queue()?
> > >
> > > In what I wrote I was referring to both dm_mq_queue_rq() and
> > > scsi_queue_rq().
> > > With "incorrect" I meant that queue lockups are introduced that
> > > make user
> > > space processes unkillable. That's a severe bug.
> >
> > And yet Laurence cannot reproduce any such lockups with your test...
> >
> > Are you absolutely certain this patch doesn't help you?
> > https://patchwork.kernel.org/patch/10174037/
> >
> > If it doesn't then that is actually very useful to know.
> >
> > > > We have time to get this right, please stop hyperventilating
> > > > about
> > > > "regressions".
> > >
> > > Sorry Mike but that's something I consider as an unfair comment. If
> > > Ming and
> > > you work on patches together, it's your job to make sure that no
> > > regressions
> > > are introduced. Instead of blaming me because I report these
> > > regressions you
> > > should be grateful that I take the time and effort to report these
> > > regressions
> > > early. And since you are employed by a large organization that
> > > sells Linux
> > > support services, your employer should invest in developing test
> > > cases that
> > > reach a higher coverage of the dm, SCSI and block layer code. I
> > > don't think
> > > that it's normal that my tests discovered several issues that were
> > > not
> > > discovered by Red Hat's internal test suite. That's something Red
> > > Hat has to
> > > address.
> >
> > You have no self-awareness of just how mypoic you're being about
> > this.
> >
> > I'm not ignoring or blaming you for your test no longer passing.  Far
> > from it.  I very much want to fix this.  But I want it fixed in a way
> > that doesn't paper over the real bug(s) while also introducing blind
> > queue runs that compromise the blk-mq RESTART code's ability to work
> > as
> > intended.
> >
> > I'd have thought you could appreciate this.  We need a root cause on
> > this, not hand-waving justifications on why problematic delayed queue
> > runs are correct.
> >
> > Please just focus on helping Laurence get his very capable testbed to
> > reproduce this issue.  Once we can reproduce these "unkillable"
> > "stalls"
> > in-house it'll be _much_ easier to analyze and fix.
> >
> > Thanks,
> > Mike
>
> Hello Bart
>
> OK, I ran 5 at once of 5 separate mount points.
> I am using 4k block sizes
> Its solid consistent for me. No stalls no gaps.
>
> [global]
> name=02-mq
> filename=fio-output-02-mq.txt
> rw=randwrite
> verify=md5
> ;rwmixread=60
> ;rwmixwrite=40
> bs=4K
> ;direct=1
> ;numjobs=4
> ;time_based=1
> runtime=120
>
> [file1]
> size=3G
> ioengine=libaio
> iodepth=16
>
> I watch I/O and I see it ramp up but fio still runs and it kind of
> shuts down.
>
> #!/bin/bash
> for i in 1 2 3 4 5
> do
>         cd /data-$i
>         fio /root/srp-test.lobe/fio_tests/02-mq 1>/data-$i.out 2>&1 &
> done
>
>
> #Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes
>
> 17:16:09   34  12 34431  10393      0      0 249872  36094
> 17:16:10   31  10 13001   2679      0      0  57652   7980
> 17:16:11   32  11 19473   4416      0      0 143248  17362
> 17:16:12   31   9  8068   1606      0      0  20088   2026
> 17:16:13   31   9  7718   1518      0      0  15908   1354
> 17:16:14   36  14 41132   9710      0      0 686216  46661
> 17:16:15   39  18 63622  21033      0      0  1246K  75108
> 17:16:16   38  16 76114   9013      0      0  1146K  82338
> 17:16:17   33  11 31941   2735      0      0 237340  25034
> 17:16:18   36  14 23900   4982      0      1  1567K  43244
> 17:16:19   37  15 55884   4974      0      4  1003K  67253
> 17:16:20   28  12  7542   4975      0      0  1630K   3266
> 17:16:21    8   6 14650  34721      0      0  2535K  21206
> 17:16:22    2   2  6655  15839      0      0  2319K   9897
> 17:16:23   11  11 37305 134030      0      0  1275K  87010
> 17:16:24   23  22 59266 119350   6560   1640  1102K  78034
> 17:16:25   21  17 65699 144462 148052  37013 159900  22120
> 17:16:26   14   9 80700 164034 216588  54147      4      1
> #         <----CPU[HYPER]-----><----------Disks----------->
> #Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes
> 17:16:27   14   9 78699 162095 214412  53603      0      0
> 17:16:28   14   9 75895 155352 204932  51233      0      0
> 17:16:29   14   9 75377 161871 214136  53534      0      0
> 17:16:30   16  11 79298 155967 206164  51541      0      0
> 17:16:31   14   8 82281 165266 218652  54662      0      0
> 17:16:32   14   9 88635 163302 215876  53970      0      0
> 17:16:33   14   8 88755 168958 223568  55892      0      0
> 17:16:34   15   9 82073 154321 203936  50984      0      0
> 17:16:35   17  10 87004 161467 213308  53327      0      0
> 17:16:36   15   9 86198 161247 212940  53235      4      1
> 17:16:37   15   9 83429 162890 215276  53819      0      0
> 17:16:38   16  10 83272 160611 212264  53066     20      2
> 17:16:39   16  10 93850 168179 222376  55594      0      0
> 17:16:40   15   9 86801 167507 221372  55343      0      0
> 17:16:41   14   8 82688 171249 226560  56640      0      0
> 17:16:42   14   8 86202 159171 210344  52586      0      0
> 17:16:43   16  10 86063 156009 206328  51582      0      0
> 17:16:44   16  10 90927 153961 203584  50896      0      0
> 17:16:45   15   9 95084 156370 206844  51710    132     13
> 17:16:46   14   8 85572 158469 209300  52326      4      1
> 17:16:47   14   8 92075 158469 209600  52400      0      0
> 17:16:48   16  10 95469 154772 204176  51044      0      0
> #         <----CPU[HYPER]-----><----------Disks----------->
> #Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes
> 17:16:49   15  10 93856 154182 203568  50897      5      5
> 17:16:50   15  10 92308 151964 200680  50170      0      0
> 17:16:51   16  10 94035 155076 204868  51217      0      0
> 17:16:52   15   9 93949 164969 217980  54495      0      0
> 17:16:53   14   9 85744 149553 197428  49357      0      0
> 17:16:54   14   9 83064 155788 205684  51421      0      0
> 17:16:55   16  10 83579 166084 218480  54620      0      0
> 17:16:56   15   9 74766 158728 208556  52139      4      1
> 17:16:57   14   9 82944 162720 215116  53779      0      0
> 17:16:58   12   7 88529 163814 216440  54110      0      0
> 17:16:59   14   7 85936 166723 220372  55093      4      1
> 17:17:00   13   8 86701 153728 203052  50763      0      0
> 17:17:01   14   9 92859 155963 205972  51493      0      0
> 17:17:02   13   8 85624 143746 189756  47439      0      0
> 17:17:03   13   8 85029 142540 188044  47010      0      0
> 17:17:04   14   8 87291 144790 191148  47788      0      0
> 17:17:05   14   8 81922 144342 190544  47636      0      0
> 17:17:06   14   8 81587 161043 212576  53144      8      2
> 17:17:07   15   8 85080 142285 187688  46922      0      0
> 17:17:08   13   8 86980 150246 197852  49463      0      0
> 17:17:09   12   8 81388 144335 190312  47578      4      1
> 17:17:10   13   8 88436 146957 194040  48510      0      0
> #         <----CPU[HYPER]-----><----------Disks----------->
> #Time     cpu sys inter  ctxsw KBRead  Reads KBWrit Writes
> 17:17:11   11   7 78997 137847 181828  45457      0      0
> 17:17:12   12   8 85709 148847 196708  49177      0      0
> 17:17:13   17  10 97228 170646 225528  56382      0      0
> 17:17:14   14   9 96032 173474 229400  57350      0      0
> 17:17:15   15   9 95340 167951 221848  55462      0      0
> 17:17:16   16  10 87392 157489 207748  51937     38      5
> 17:17:17   16  10 84756 152753 201716  50429      0      0
> 17:17:18   17  10 85109 153000 202080  50520      0      0
> 17:17:19   16  10 92109 164514 217396  54349     80      5
> 17:17:20   15   9 91342 155674 205804  51451      0      0
> 17:17:21   12   7 73921 126577 167060  41765      0      0
> 17:17:22   13   8 76916 126701 167176  41794      0      0
> 17:17:23   13   8 85187 151074 199768  49942      0      0
> 17:17:24   15   9 85737 153664 203168  50792      0      0
> 17:17:25   15   9 87113 147636 195084  48771      0      0
> 17:17:26   14   8 89440 157433 208116  52029      4      1
> 17:17:27   14   9 95290 172224 227036  56759      0      0
> 17:17:28   15  10 93918 167611 220164  55041      0      0
> 17:17:29   13   8 82404 149274 197312  49328      0      0
> 17:17:30   10   7 75961 138276 182668  45667      0      0
> 17:17:31   12   8 84899 151829 200764  50191      0      0
> 17:17:32   13   8 81386 141091 186444  46611      0      0
> 17:17:33   15   9  100K 167489 221640  55410      0      0
> 17:17:34   14   9 89601 158765 210032  52508      0      0
> 17:17:35   14   9 92440 155287 205216  51304      0      0
> 17:17:36   15  10 90042 155934 206168  51542      4      1
> 17:17:37   14   9 91670 164456 217684  54421      0      0
> 17:17:38   14   9 78612 167368 221348  55337      0      0
> 17:17:39   15   9 91325 162599 214616  53654      0      0
> 17:17:40   14   9 79112 151595 199984  50000     21      8
> 17:17:41    9   3 32565  60936  79832  19964     32     12
>
>
>

--001a1147a26c37834c0563145e89
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+VGhhdCBzaG91bGQgaGF2ZSBzYWlkIGZpbyBzdGlsbCBydW5zIGFuZCBp
dCBvbmx5IHNodXRzIGRvd24gd2hlbiBkb25lPGRpdj5JIHNpbXBseSBkb250IHNlZSB0aGUgc3Rh
bGxzPC9kaXY+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZXh0cmEiPjxicj48ZGl2IGNsYXNzPSJn
bWFpbF9xdW90ZSI+T24gVGh1LCBKYW4gMTgsIDIwMTggYXQgNToxOCBQTSwgTGF1cmVuY2UgT2Jl
cm1hbiA8c3BhbiBkaXI9Imx0ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzpsb2Jlcm1hbkByZWRoYXQu
Y29tIiB0YXJnZXQ9Il9ibGFuayI+bG9iZXJtYW5AcmVkaGF0LmNvbTwvYT4mZ3Q7PC9zcGFuPiB3
cm90ZTo8YnI+PGJsb2NrcXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjAg
MCAwIC44ZXg7Ym9yZGVyLWxlZnQ6MXB4ICNjY2Mgc29saWQ7cGFkZGluZy1sZWZ0OjFleCI+T24g
VGh1LCAyMDE4LTAxLTE4IGF0IDE3OjAxIC0wNTAwLCBNaWtlIFNuaXR6ZXIgd3JvdGU6PGJyPg0K
Jmd0OyBPbiBUaHUsIEphbiAxOCAyMDE4IGF0wqDCoDQ6MzlwbSAtMDUwMCw8YnI+DQo8ZGl2Pjxk
aXYgY2xhc3M9Img1Ij4mZ3Q7IEJhcnQgVmFuIEFzc2NoZSAmbHQ7PGEgaHJlZj0ibWFpbHRvOkJh
cnQuVmFuQXNzY2hlQHdkYy5jb20iPkJhcnQuVmFuQXNzY2hlQHdkYy5jb208L2E+Jmd0OyB3cm90
ZTo8YnI+DQomZ3Q7PGJyPg0KJmd0OyAmZ3Q7IE9uIFRodSwgMjAxOC0wMS0xOCBhdCAxNjoyMyAt
MDUwMCwgTWlrZSBTbml0emVyIHdyb3RlOjxicj4NCiZndDsgJmd0OyAmZ3Q7IE9uIFRodSwgSmFu
IDE4IDIwMTggYXTCoMKgMzo1OFAgLTA1MDAsPGJyPg0KJmd0OyAmZ3Q7ICZndDsgQmFydCBWYW4g
QXNzY2hlICZsdDs8YSBocmVmPSJtYWlsdG86QmFydC5WYW5Bc3NjaGVAd2RjLmNvbSI+QmFydC5W
YW5Bc3NjaGVAd2RjLmNvbTwvYT4mZ3Q7IHdyb3RlOjxicj4NCiZndDsgJmd0OyAmZ3Q7PGJyPg0K
Jmd0OyAmZ3Q7ICZndDsgJmd0OyBPbiBUaHUsIDIwMTgtMDEtMTggYXQgMTU6NDggLTA1MDAsIE1p
a2UgU25pdHplciB3cm90ZTo8YnI+DQomZ3Q7ICZndDsgJmd0OyAmZ3Q7ICZndDsgRm9yIEJhcnQm
IzM5O3MgdGVzdCB0aGUgdW5kZXJseWluZyBzY3NpLW1xIGRyaXZlciBpcyB3aGF0IGlzPGJyPg0K
Jmd0OyAmZ3Q7ICZndDsgJmd0OyAmZ3Q7IHJlZ3VsYXJseTxicj4NCiZndDsgJmd0OyAmZ3Q7ICZn
dDsgJmd0OyBoaXR0aW5nIHRoaXMgY2FzZSBpbiBfX2Jsa19tcV90cnlfaXNzdWVfZGlyZWN0bHko
KTo8YnI+DQomZ3Q7ICZndDsgJmd0OyAmZ3Q7ICZndDs8YnI+DQomZ3Q7ICZndDsgJmd0OyAmZ3Q7
ICZndDsgwqDCoMKgwqDCoMKgwqDCoGlmIChibGtfbXFfaGN0eF9zdG9wcGVkKGhjdHgpIHx8PGJy
Pg0KJmd0OyAmZ3Q7ICZndDsgJmd0OyAmZ3Q7IGJsa19xdWV1ZV9xdWllc2NlZChxKSk8YnI+DQom
Z3Q7ICZndDsgJmd0OyAmZ3Q7PGJyPg0KJmd0OyAmZ3Q7ICZndDsgJmd0OyBUaGVzZSBsb2NrdXBz
IHdlcmUgYWxsIHRyaWdnZXJlZCBieSBpbmNvcnJlY3QgaGFuZGxpbmcgb2Y8YnI+DQomZ3Q7ICZn
dDsgJmd0OyAmZ3Q7IC5xdWV1ZV9ycSgpIHJldHVybmluZyBCTEtfU1RTX1JFU09VUkNFLjxicj4N
CiZndDsgJmd0OyAmZ3Q7PGJyPg0KJmd0OyAmZ3Q7ICZndDsgUGxlYXNlIGJlIHByZWNpc2UsIGRt
X21xX3F1ZXVlX3JxKCkmIzM5O3MgcmV0dXJuIG9mIEJMS19TVFNfUkVTT1VSQ0U/PGJyPg0KJmd0
OyAmZ3Q7ICZndDsgJnF1b3Q7SW5jb3JyZWN0JnF1b3Q7IGJlY2F1c2UgaXQgbm8gbG9uZ2VyIHJ1
bnM8YnI+DQomZ3Q7ICZndDsgJmd0OyBibGtfbXFfZGVsYXlfcnVuX2h3X3F1ZXVlKCk/PGJyPg0K
Jmd0OyAmZ3Q7PGJyPg0KJmd0OyAmZ3Q7IEluIHdoYXQgSSB3cm90ZSBJIHdhcyByZWZlcnJpbmcg
dG8gYm90aCBkbV9tcV9xdWV1ZV9ycSgpIGFuZDxicj4NCiZndDsgJmd0OyBzY3NpX3F1ZXVlX3Jx
KCkuPGJyPg0KJmd0OyAmZ3Q7IFdpdGggJnF1b3Q7aW5jb3JyZWN0JnF1b3Q7IEkgbWVhbnQgdGhh
dCBxdWV1ZSBsb2NrdXBzIGFyZSBpbnRyb2R1Y2VkIHRoYXQ8YnI+DQomZ3Q7ICZndDsgbWFrZSB1
c2VyPGJyPg0KJmd0OyAmZ3Q7IHNwYWNlIHByb2Nlc3NlcyB1bmtpbGxhYmxlLiBUaGF0JiMzOTtz
IGEgc2V2ZXJlIGJ1Zy48YnI+DQomZ3Q7PGJyPg0KJmd0OyBBbmQgeWV0IExhdXJlbmNlIGNhbm5v
dCByZXByb2R1Y2UgYW55IHN1Y2ggbG9ja3VwcyB3aXRoIHlvdXIgdGVzdC4uLjxicj4NCiZndDs8
YnI+DQomZ3Q7IEFyZSB5b3UgYWJzb2x1dGVseSBjZXJ0YWluIHRoaXMgcGF0Y2ggZG9lc24mIzM5
O3QgaGVscCB5b3U/PGJyPg0KJmd0OyA8YSBocmVmPSJodHRwczovL3BhdGNod29yay5rZXJuZWwu
b3JnL3BhdGNoLzEwMTc0MDM3LyIgcmVsPSJub3JlZmVycmVyIiB0YXJnZXQ9Il9ibGFuayI+aHR0
cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy88d2JyPnBhdGNoLzEwMTc0MDM3LzwvYT48YnI+DQom
Z3Q7PGJyPg0KJmd0OyBJZiBpdCBkb2VzbiYjMzk7dCB0aGVuIHRoYXQgaXMgYWN0dWFsbHkgdmVy
eSB1c2VmdWwgdG8ga25vdy48YnI+DQomZ3Q7PGJyPg0KJmd0OyAmZ3Q7ICZndDsgV2UgaGF2ZSB0
aW1lIHRvIGdldCB0aGlzIHJpZ2h0LCBwbGVhc2Ugc3RvcCBoeXBlcnZlbnRpbGF0aW5nPGJyPg0K
Jmd0OyAmZ3Q7ICZndDsgYWJvdXQ8YnI+DQomZ3Q7ICZndDsgJmd0OyAmcXVvdDtyZWdyZXNzaW9u
cyZxdW90Oy48YnI+DQomZ3Q7ICZndDs8YnI+DQomZ3Q7ICZndDsgU29ycnkgTWlrZSBidXQgdGhh
dCYjMzk7cyBzb21ldGhpbmcgSSBjb25zaWRlciBhcyBhbiB1bmZhaXIgY29tbWVudC4gSWY8YnI+
DQomZ3Q7ICZndDsgTWluZyBhbmQ8YnI+DQomZ3Q7ICZndDsgeW91IHdvcmsgb24gcGF0Y2hlcyB0
b2dldGhlciwgaXQmIzM5O3MgeW91ciBqb2IgdG8gbWFrZSBzdXJlIHRoYXQgbm88YnI+DQomZ3Q7
ICZndDsgcmVncmVzc2lvbnM8YnI+DQomZ3Q7ICZndDsgYXJlIGludHJvZHVjZWQuIEluc3RlYWQg
b2YgYmxhbWluZyBtZSBiZWNhdXNlIEkgcmVwb3J0IHRoZXNlPGJyPg0KJmd0OyAmZ3Q7IHJlZ3Jl
c3Npb25zIHlvdTxicj4NCiZndDsgJmd0OyBzaG91bGQgYmUgZ3JhdGVmdWwgdGhhdCBJIHRha2Ug
dGhlIHRpbWUgYW5kIGVmZm9ydCB0byByZXBvcnQgdGhlc2U8YnI+DQomZ3Q7ICZndDsgcmVncmVz
c2lvbnM8YnI+DQomZ3Q7ICZndDsgZWFybHkuIEFuZCBzaW5jZSB5b3UgYXJlIGVtcGxveWVkIGJ5
IGEgbGFyZ2Ugb3JnYW5pemF0aW9uIHRoYXQ8YnI+DQomZ3Q7ICZndDsgc2VsbHMgTGludXg8YnI+
DQomZ3Q7ICZndDsgc3VwcG9ydCBzZXJ2aWNlcywgeW91ciBlbXBsb3llciBzaG91bGQgaW52ZXN0
IGluIGRldmVsb3BpbmcgdGVzdDxicj4NCiZndDsgJmd0OyBjYXNlcyB0aGF0PGJyPg0KJmd0OyAm
Z3Q7IHJlYWNoIGEgaGlnaGVyIGNvdmVyYWdlIG9mIHRoZSBkbSwgU0NTSSBhbmQgYmxvY2sgbGF5
ZXIgY29kZS4gSTxicj4NCiZndDsgJmd0OyBkb24mIzM5O3QgdGhpbms8YnI+DQomZ3Q7ICZndDsg
dGhhdCBpdCYjMzk7cyBub3JtYWwgdGhhdCBteSB0ZXN0cyBkaXNjb3ZlcmVkIHNldmVyYWwgaXNz
dWVzIHRoYXQgd2VyZTxicj4NCiZndDsgJmd0OyBub3Q8YnI+DQomZ3Q7ICZndDsgZGlzY292ZXJl
ZCBieSBSZWQgSGF0JiMzOTtzIGludGVybmFsIHRlc3Qgc3VpdGUuIFRoYXQmIzM5O3Mgc29tZXRo
aW5nIFJlZDxicj4NCiZndDsgJmd0OyBIYXQgaGFzIHRvPGJyPg0KJmd0OyAmZ3Q7IGFkZHJlc3Mu
PGJyPg0KJmd0Ozxicj4NCiZndDsgWW91IGhhdmUgbm8gc2VsZi1hd2FyZW5lc3Mgb2YganVzdCBo
b3cgbXlwb2ljIHlvdSYjMzk7cmUgYmVpbmcgYWJvdXQ8YnI+DQomZ3Q7IHRoaXMuPGJyPg0KJmd0
Ozxicj4NCiZndDsgSSYjMzk7bSBub3QgaWdub3Jpbmcgb3IgYmxhbWluZyB5b3UgZm9yIHlvdXIg
dGVzdCBubyBsb25nZXIgcGFzc2luZy7CoMKgRmFyPGJyPg0KJmd0OyBmcm9tIGl0LsKgwqBJIHZl
cnkgbXVjaCB3YW50IHRvIGZpeCB0aGlzLsKgwqBCdXQgSSB3YW50IGl0IGZpeGVkIGluIGEgd2F5
PGJyPg0KJmd0OyB0aGF0IGRvZXNuJiMzOTt0IHBhcGVyIG92ZXIgdGhlIHJlYWwgYnVnKHMpIHdo
aWxlIGFsc28gaW50cm9kdWNpbmcgYmxpbmQ8YnI+DQomZ3Q7IHF1ZXVlIHJ1bnMgdGhhdCBjb21w
cm9taXNlIHRoZSBibGstbXEgUkVTVEFSVCBjb2RlJiMzOTtzIGFiaWxpdHkgdG8gd29yazxicj4N
CiZndDsgYXM8YnI+DQomZ3Q7IGludGVuZGVkLjxicj4NCiZndDs8YnI+DQomZ3Q7IEkmIzM5O2Qg
aGF2ZSB0aG91Z2h0IHlvdSBjb3VsZCBhcHByZWNpYXRlIHRoaXMuwqDCoFdlIG5lZWQgYSByb290
IGNhdXNlIG9uPGJyPg0KJmd0OyB0aGlzLCBub3QgaGFuZC13YXZpbmcganVzdGlmaWNhdGlvbnMg
b24gd2h5IHByb2JsZW1hdGljIGRlbGF5ZWQgcXVldWU8YnI+DQomZ3Q7IHJ1bnMgYXJlIGNvcnJl
Y3QuPGJyPg0KJmd0Ozxicj4NCiZndDsgUGxlYXNlIGp1c3QgZm9jdXMgb24gaGVscGluZyBMYXVy
ZW5jZSBnZXQgaGlzIHZlcnkgY2FwYWJsZSB0ZXN0YmVkIHRvPGJyPg0KJmd0OyByZXByb2R1Y2Ug
dGhpcyBpc3N1ZS7CoMKgT25jZSB3ZSBjYW4gcmVwcm9kdWNlIHRoZXNlICZxdW90O3Vua2lsbGFi
bGUmcXVvdDs8YnI+DQomZ3Q7ICZxdW90O3N0YWxscyZxdW90Ozxicj4NCiZndDsgaW4taG91c2Ug
aXQmIzM5O2xsIGJlIF9tdWNoXyBlYXNpZXIgdG8gYW5hbHl6ZSBhbmQgZml4Ljxicj4NCiZndDs8
YnI+DQomZ3Q7IFRoYW5rcyw8YnI+DQomZ3Q7IE1pa2U8YnI+DQo8YnI+DQo8L2Rpdj48L2Rpdj5I
ZWxsbyBCYXJ0PGJyPg0KPGJyPg0KT0ssIEkgcmFuIDUgYXQgb25jZSBvZiA1IHNlcGFyYXRlIG1v
dW50IHBvaW50cy48YnI+DQpJIGFtIHVzaW5nIDRrIGJsb2NrIHNpemVzPGJyPg0KSXRzIHNvbGlk
IGNvbnNpc3RlbnQgZm9yIG1lLiBObyBzdGFsbHMgbm8gZ2Fwcy48YnI+DQo8YnI+DQpbZ2xvYmFs
XTxicj4NCm5hbWU9MDItbXE8YnI+DQpmaWxlbmFtZT1maW8tb3V0cHV0LTAyLW1xLnR4dDxicj4N
CnJ3PXJhbmR3cml0ZTxicj4NCnZlcmlmeT1tZDU8YnI+DQo7cndtaXhyZWFkPTYwPGJyPg0KO3J3
bWl4d3JpdGU9NDA8YnI+DQpicz00Szxicj4NCjtkaXJlY3Q9MTxicj4NCjtudW1qb2JzPTQ8YnI+
DQo7dGltZV9iYXNlZD0xPGJyPg0KcnVudGltZT0xMjA8YnI+DQo8YnI+DQpbZmlsZTFdPGJyPg0K
c2l6ZT0zRzxicj4NCmlvZW5naW5lPWxpYmFpbzxicj4NCmlvZGVwdGg9MTY8YnI+DQo8YnI+DQpJ
IHdhdGNoIEkvTyBhbmQgSSBzZWUgaXQgcmFtcCB1cCBidXQgZmlvIHN0aWxsIHJ1bnMgYW5kIGl0
IGtpbmQgb2Y8YnI+DQpzaHV0cyBkb3duLjxicj4NCjxicj4NCiMhL2Jpbi9iYXNoPGJyPg0KZm9y
IGkgaW4gMSAyIDMgNCA1PGJyPg0KZG88YnI+DQrCoCDCoCDCoCDCoCBjZCAvZGF0YS0kacKgPGJy
Pg0KwqAgwqAgwqAgwqAgZmlvIC9yb290L3NycC10ZXN0LmxvYmUvZmlvX3Rlc3RzLzx3YnI+MDIt
bXEgMSZndDsvZGF0YS0kaS5vdXQgMiZndDsmYW1wOzEgJmFtcDs8YnI+DQpkb25lPGJyPg0KPGJy
Pg0KPGJyPg0KI1RpbWXCoMKgwqDCoMKgY3B1IHN5cyBpbnRlcsKgwqBjdHhzdyBLQlJlYWTCoMKg
UmVhZHMgS0JXcml0IFdyaXRlc8KgPGJyPg0KPGJyPg0KMTc6MTY6MDnCoMKgwqAzNMKgwqAxMiAz
NDQzMcKgwqAxMDM5M8KgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwIDI0OTg3MsKgwqAzNjA5NMKg
PGJyPg0KMTc6MTY6MTDCoMKgwqAzMcKgwqAxMCAxMzAwMcKgwqDCoDI2NznCoMKgwqDCoMKgwqAw
wqDCoMKgwqDCoMKgMMKgwqA8d2JyPjU3NjUywqDCoMKgNzk4MMKgPGJyPg0KMTc6MTY6MTHCoMKg
wqAzMsKgwqAxMSAxOTQ3M8KgwqDCoDQ0MTbCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMCAxNDMy
NDjCoMKgMTczNjLCoDxicj4NCjE3OjE2OjEywqDCoMKgMzHCoMKgwqA5wqDCoDgwNjjCoMKgwqA8
d2JyPjE2MDbCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgwqAyMDA4OMKgwqDCoDx3YnI+MjAy
NsKgPGJyPg0KMTc6MTY6MTPCoMKgwqAzMcKgwqDCoDnCoMKgNzcxOMKgwqDCoDx3YnI+MTUxOMKg
wqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqDCoDE1OTA4wqDCoMKgPHdicj4xMzU0wqA8YnI+DQox
NzoxNjoxNMKgwqDCoDM2wqDCoDE0IDQxMTMywqDCoMKgOTcxMMKgwqDCoMKgwqDCoDDCoMKgwqDC
oMKgwqAwIDY4NjIxNsKgwqA0NjY2McKgPGJyPg0KMTc6MTY6MTXCoMKgwqAzOcKgwqAxOCA2MzYy
MsKgwqAyMTAzM8KgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqDCoDx3YnI+MTI0NkvCoMKgNzUx
MDjCoDxicj4NCjE3OjE2OjE2wqDCoMKgMzjCoMKgMTYgNzYxMTTCoMKgwqA5MDEzwqDCoMKgwqDC
oMKgMMKgwqDCoMKgwqDCoDDCoMKgPHdicj4xMTQ2S8KgwqA4MjMzOMKgPGJyPg0KMTc6MTY6MTfC
oMKgwqAzM8KgwqAxMSAzMTk0McKgwqDCoDI3MzXCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMCAy
MzczNDDCoMKgMjUwMzTCoDxicj4NCjE3OjE2OjE4wqDCoMKgMzbCoMKgMTQgMjM5MDDCoMKgwqA0
OTgywqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDHCoMKgPHdicj4xNTY3S8KgwqA0MzI0NMKgPGJy
Pg0KMTc6MTY6MTnCoMKgwqAzN8KgwqAxNSA1NTg4NMKgwqDCoDQ5NzTCoMKgwqDCoMKgwqAwwqDC
oMKgwqDCoMKgNMKgwqA8d2JyPjEwMDNLwqDCoDY3MjUzwqA8YnI+DQoxNzoxNjoyMMKgwqDCoDI4
wqDCoDEywqDCoDc1NDLCoMKgwqA8d2JyPjQ5NzXCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKg
wqAxNjMwS8KgwqDCoDx3YnI+MzI2NsKgPGJyPg0KMTc6MTY6MjHCoMKgwqDCoDjCoMKgwqA2IDE0
NjUwwqDCoDM0NzIxwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoMKgPHdicj4yNTM1S8KgwqAy
MTIwNsKgPGJyPg0KMTc6MTY6MjLCoMKgwqDCoDLCoMKgwqAywqDCoDY2NTXCoMKgPHdicj4xNTgz
OcKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqDCoDIzMTlLwqDCoMKgPHdicj45ODk3wqA8YnI+
DQoxNzoxNjoyM8KgwqDCoDExwqDCoDExIDM3MzA1IDEzNDAzMMKgwqDCoMKgwqDCoDDCoMKgwqDC
oMKgwqAwwqDCoDEyNzVLwqDCoDx3YnI+ODcwMTDCoDxicj4NCjE3OjE2OjI0wqDCoMKgMjPCoMKg
MjIgNTkyNjYgMTE5MzUwwqDCoMKgNjU2MMKgwqDCoDE2NDDCoMKgMTEwMkvCoMKgPHdicj43ODAz
NMKgPGJyPg0KMTc6MTY6MjXCoMKgwqAyMcKgwqAxNyA2NTY5OSAxNDQ0NjIgMTQ4MDUywqDCoDM3
MDEzIDE1OTkwMMKgwqAyMjEyMMKgPGJyPg0KMTc6MTY6MjbCoMKgwqAxNMKgwqDCoDkgODA3MDAg
MTY0MDM0IDIxNjU4OMKgwqA1NDE0N8KgwqDCoMKgwqDCoDTCoMKgwqDCoMKgwqAxwqA8YnI+DQoj
wqDCoMKgwqDCoMKgwqDCoMKgJmx0Oy0tLS1DUFVbSFlQRVJdLS0tLS08d2JyPiZndDsmbHQ7LS0t
LS0tLS0tLURpc2tzLS0tLS0tLS0tLS0mZ3Q7PGJyPg0KI1RpbWXCoMKgwqDCoMKgY3B1IHN5cyBp
bnRlcsKgwqBjdHhzdyBLQlJlYWTCoMKgUmVhZHMgS0JXcml0IFdyaXRlc8KgPGJyPg0KMTc6MTY6
MjfCoMKgwqAxNMKgwqDCoDkgNzg2OTkgMTYyMDk1IDIxNDQxMsKgwqA1MzYwM8KgwqDCoMKgwqDC
oDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNjoyOMKgwqDCoDE0wqDCoMKgOSA3NTg5NSAxNTUz
NTIgMjA0OTMywqDCoDUxMjMzwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE2
OjI5wqDCoMKgMTTCoMKgwqA5IDc1Mzc3IDE2MTg3MSAyMTQxMzbCoMKgNTM1MzTCoMKgwqDCoMKg
wqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTY6MzDCoMKgwqAxNsKgwqAxMSA3OTI5OCAxNTU5
NjcgMjA2MTY0wqDCoDUxNTQxwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE2
OjMxwqDCoMKgMTTCoMKgwqA4IDgyMjgxIDE2NTI2NiAyMTg2NTLCoMKgNTQ2NjLCoMKgwqDCoMKg
wqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTY6MzLCoMKgwqAxNMKgwqDCoDkgODg2MzUgMTYz
MzAyIDIxNTg3NsKgwqA1Mzk3MMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzox
NjozM8KgwqDCoDE0wqDCoMKgOCA4ODc1NSAxNjg5NTggMjIzNTY4wqDCoDU1ODkywqDCoMKgwqDC
oMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE2OjM0wqDCoMKgMTXCoMKgwqA5IDgyMDczIDE1
NDMyMSAyMDM5MzbCoMKgNTA5ODTCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6
MTY6MzXCoMKgwqAxN8KgwqAxMCA4NzAwNCAxNjE0NjcgMjEzMzA4wqDCoDUzMzI3wqDCoMKgwqDC
oMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE2OjM2wqDCoMKgMTXCoMKgwqA5IDg2MTk4IDE2
MTI0NyAyMTI5NDDCoMKgNTMyMzXCoMKgwqDCoMKgwqA0wqDCoMKgwqDCoMKgMcKgPGJyPg0KMTc6
MTY6MzfCoMKgwqAxNcKgwqDCoDkgODM0MjkgMTYyODkwIDIxNTI3NsKgwqA1MzgxOcKgwqDCoMKg
wqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNjozOMKgwqDCoDE2wqDCoDEwIDgzMjcyIDE2
MDYxMSAyMTIyNjTCoMKgNTMwNjbCoMKgwqDCoMKgMjDCoMKgwqDCoMKgwqAywqA8YnI+DQoxNzox
NjozOcKgwqDCoDE2wqDCoDEwIDkzODUwIDE2ODE3OSAyMjIzNzbCoMKgNTU1OTTCoMKgwqDCoMKg
wqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTY6NDDCoMKgwqAxNcKgwqDCoDkgODY4MDEgMTY3
NTA3IDIyMTM3MsKgwqA1NTM0M8KgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzox
Njo0McKgwqDCoDE0wqDCoMKgOCA4MjY4OCAxNzEyNDkgMjI2NTYwwqDCoDU2NjQwwqDCoMKgwqDC
oMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE2OjQywqDCoMKgMTTCoMKgwqA4IDg2MjAyIDE1
OTE3MSAyMTAzNDTCoMKgNTI1ODbCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6
MTY6NDPCoMKgwqAxNsKgwqAxMCA4NjA2MyAxNTYwMDkgMjA2MzI4wqDCoDUxNTgywqDCoMKgwqDC
oMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE2OjQ0wqDCoMKgMTbCoMKgMTAgOTA5MjcgMTUz
OTYxIDIwMzU4NMKgwqA1MDg5NsKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzox
Njo0NcKgwqDCoDE1wqDCoMKgOSA5NTA4NCAxNTYzNzAgMjA2ODQ0wqDCoDUxNzEwwqDCoMKgwqAx
MzLCoMKgwqDCoMKgMTPCoDxicj4NCjE3OjE2OjQ2wqDCoMKgMTTCoMKgwqA4IDg1NTcyIDE1ODQ2
OSAyMDkzMDDCoMKgNTIzMjbCoMKgwqDCoMKgwqA0wqDCoMKgwqDCoMKgMcKgPGJyPg0KMTc6MTY6
NDfCoMKgwqAxNMKgwqDCoDggOTIwNzUgMTU4NDY5IDIwOTYwMMKgwqA1MjQwMMKgwqDCoMKgwqDC
oDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNjo0OMKgwqDCoDE2wqDCoDEwIDk1NDY5IDE1NDc3
MiAyMDQxNzbCoMKgNTEwNDTCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KI8KgwqDC
oMKgwqDCoMKgwqDCoCZsdDstLS0tQ1BVW0hZUEVSXS0tLS0tPHdicj4mZ3Q7Jmx0Oy0tLS0tLS0t
LS1EaXNrcy0tLS0tLS0tLS0tJmd0Ozxicj4NCiNUaW1lwqDCoMKgwqDCoGNwdSBzeXMgaW50ZXLC
oMKgY3R4c3cgS0JSZWFkwqDCoFJlYWRzIEtCV3JpdCBXcml0ZXPCoDxicj4NCjE3OjE2OjQ5wqDC
oMKgMTXCoMKgMTAgOTM4NTYgMTU0MTgyIDIwMzU2OMKgwqA1MDg5N8KgwqDCoMKgwqDCoDXCoMKg
wqDCoMKgwqA1wqA8YnI+DQoxNzoxNjo1MMKgwqDCoDE1wqDCoDEwIDkyMzA4IDE1MTk2NCAyMDA2
ODDCoMKgNTAxNzDCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTY6NTHCoMKg
wqAxNsKgwqAxMCA5NDAzNSAxNTUwNzYgMjA0ODY4wqDCoDUxMjE3wqDCoMKgwqDCoMKgMMKgwqDC
oMKgwqDCoDDCoDxicj4NCjE3OjE2OjUywqDCoMKgMTXCoMKgwqA5IDkzOTQ5IDE2NDk2OSAyMTc5
ODDCoMKgNTQ0OTXCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTY6NTPCoMKg
wqAxNMKgwqDCoDkgODU3NDQgMTQ5NTUzIDE5NzQyOMKgwqA0OTM1N8KgwqDCoMKgwqDCoDDCoMKg
wqDCoMKgwqAwwqA8YnI+DQoxNzoxNjo1NMKgwqDCoDE0wqDCoMKgOSA4MzA2NCAxNTU3ODggMjA1
Njg0wqDCoDUxNDIxwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE2OjU1wqDC
oMKgMTbCoMKgMTAgODM1NzkgMTY2MDg0IDIxODQ4MMKgwqA1NDYyMMKgwqDCoMKgwqDCoDDCoMKg
wqDCoMKgwqAwwqA8YnI+DQoxNzoxNjo1NsKgwqDCoDE1wqDCoMKgOSA3NDc2NiAxNTg3MjggMjA4
NTU2wqDCoDUyMTM5wqDCoMKgwqDCoMKgNMKgwqDCoMKgwqDCoDHCoDxicj4NCjE3OjE2OjU3wqDC
oMKgMTTCoMKgwqA5IDgyOTQ0IDE2MjcyMCAyMTUxMTbCoMKgNTM3NznCoMKgwqDCoMKgwqAwwqDC
oMKgwqDCoMKgMMKgPGJyPg0KMTc6MTY6NTjCoMKgwqAxMsKgwqDCoDcgODg1MjkgMTYzODE0IDIx
NjQ0MMKgwqA1NDExMMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNjo1OcKg
wqDCoDE0wqDCoMKgNyA4NTkzNiAxNjY3MjMgMjIwMzcywqDCoDU1MDkzwqDCoMKgwqDCoMKgNMKg
wqDCoMKgwqDCoDHCoDxicj4NCjE3OjE3OjAwwqDCoMKgMTPCoMKgwqA4IDg2NzAxIDE1MzcyOCAy
MDMwNTLCoMKgNTA3NjPCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6MDHC
oMKgwqAxNMKgwqDCoDkgOTI4NTkgMTU1OTYzIDIwNTk3MsKgwqA1MTQ5M8KgwqDCoMKgwqDCoDDC
oMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzowMsKgwqDCoDEzwqDCoMKgOCA4NTYyNCAxNDM3NDYg
MTg5NzU2wqDCoDQ3NDM5wqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjAz
wqDCoMKgMTPCoMKgwqA4IDg1MDI5IDE0MjU0MCAxODgwNDTCoMKgNDcwMTDCoMKgwqDCoMKgwqAw
wqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6MDTCoMKgwqAxNMKgwqDCoDggODcyOTEgMTQ0Nzkw
IDE5MTE0OMKgwqA0Nzc4OMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzow
NcKgwqDCoDE0wqDCoMKgOCA4MTkyMiAxNDQzNDIgMTkwNTQ0wqDCoDQ3NjM2wqDCoMKgwqDCoMKg
MMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjA2wqDCoMKgMTTCoMKgwqA4IDgxNTg3IDE2MTA0
MyAyMTI1NzbCoMKgNTMxNDTCoMKgwqDCoMKgwqA4wqDCoMKgwqDCoMKgMsKgPGJyPg0KMTc6MTc6
MDfCoMKgwqAxNcKgwqDCoDggODUwODAgMTQyMjg1IDE4NzY4OMKgwqA0NjkyMsKgwqDCoMKgwqDC
oDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzowOMKgwqDCoDEzwqDCoMKgOCA4Njk4MCAxNTAy
NDYgMTk3ODUywqDCoDQ5NDYzwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3
OjA5wqDCoMKgMTLCoMKgwqA4IDgxMzg4IDE0NDMzNSAxOTAzMTLCoMKgNDc1NzjCoMKgwqDCoMKg
wqA0wqDCoMKgwqDCoMKgMcKgPGJyPg0KMTc6MTc6MTDCoMKgwqAxM8KgwqDCoDggODg0MzYgMTQ2
OTU3IDE5NDA0MMKgwqA0ODUxMMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQojwqDC
oMKgwqDCoMKgwqDCoMKgJmx0Oy0tLS1DUFVbSFlQRVJdLS0tLS08d2JyPiZndDsmbHQ7LS0tLS0t
LS0tLURpc2tzLS0tLS0tLS0tLS0mZ3Q7PGJyPg0KI1RpbWXCoMKgwqDCoMKgY3B1IHN5cyBpbnRl
csKgwqBjdHhzdyBLQlJlYWTCoMKgUmVhZHMgS0JXcml0IFdyaXRlc8KgPGJyPg0KMTc6MTc6MTHC
oMKgwqAxMcKgwqDCoDcgNzg5OTcgMTM3ODQ3IDE4MTgyOMKgwqA0NTQ1N8KgwqDCoMKgwqDCoDDC
oMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzoxMsKgwqDCoDEywqDCoMKgOCA4NTcwOSAxNDg4NDcg
MTk2NzA4wqDCoDQ5MTc3wqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjEz
wqDCoMKgMTfCoMKgMTAgOTcyMjggMTcwNjQ2IDIyNTUyOMKgwqA1NjM4MsKgwqDCoMKgwqDCoDDC
oMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzoxNMKgwqDCoDE0wqDCoMKgOSA5NjAzMiAxNzM0NzQg
MjI5NDAwwqDCoDU3MzUwwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjE1
wqDCoMKgMTXCoMKgwqA5IDk1MzQwIDE2Nzk1MSAyMjE4NDjCoMKgNTU0NjLCoMKgwqDCoMKgwqAw
wqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6MTbCoMKgwqAxNsKgwqAxMCA4NzM5MiAxNTc0ODkg
MjA3NzQ4wqDCoDUxOTM3wqDCoMKgwqDCoDM4wqDCoMKgwqDCoMKgNcKgPGJyPg0KMTc6MTc6MTfC
oMKgwqAxNsKgwqAxMCA4NDc1NiAxNTI3NTMgMjAxNzE2wqDCoDUwNDI5wqDCoMKgwqDCoMKgMMKg
wqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjE4wqDCoMKgMTfCoMKgMTAgODUxMDkgMTUzMDAwIDIw
MjA4MMKgwqA1MDUyMMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzoxOcKg
wqDCoDE2wqDCoDEwIDkyMTA5IDE2NDUxNCAyMTczOTbCoMKgNTQzNDnCoMKgwqDCoMKgODDCoMKg
wqDCoMKgwqA1wqA8YnI+DQoxNzoxNzoyMMKgwqDCoDE1wqDCoMKgOSA5MTM0MiAxNTU2NzQgMjA1
ODA0wqDCoDUxNDUxwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjIxwqDC
oMKgMTLCoMKgwqA3IDczOTIxIDEyNjU3NyAxNjcwNjDCoMKgNDE3NjXCoMKgwqDCoMKgwqAwwqDC
oMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6MjLCoMKgwqAxM8KgwqDCoDggNzY5MTYgMTI2NzAxIDE2
NzE3NsKgwqA0MTc5NMKgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzoyM8Kg
wqDCoDEzwqDCoMKgOCA4NTE4NyAxNTEwNzQgMTk5NzY4wqDCoDQ5OTQywqDCoMKgwqDCoMKgMMKg
wqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjI0wqDCoMKgMTXCoMKgwqA5IDg1NzM3IDE1MzY2NCAy
MDMxNjjCoMKgNTA3OTLCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6MjXC
oMKgwqAxNcKgwqDCoDkgODcxMTMgMTQ3NjM2IDE5NTA4NMKgwqA0ODc3McKgwqDCoMKgwqDCoDDC
oMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzoyNsKgwqDCoDE0wqDCoMKgOCA4OTQ0MCAxNTc0MzMg
MjA4MTE2wqDCoDUyMDI5wqDCoMKgwqDCoMKgNMKgwqDCoMKgwqDCoDHCoDxicj4NCjE3OjE3OjI3
wqDCoMKgMTTCoMKgwqA5IDk1MjkwIDE3MjIyNCAyMjcwMzbCoMKgNTY3NTnCoMKgwqDCoMKgwqAw
wqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6MjjCoMKgwqAxNcKgwqAxMCA5MzkxOCAxNjc2MTEg
MjIwMTY0wqDCoDU1MDQxwqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjI5
wqDCoMKgMTPCoMKgwqA4IDgyNDA0IDE0OTI3NCAxOTczMTLCoMKgNDkzMjjCoMKgwqDCoMKgwqAw
wqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6MzDCoMKgwqAxMMKgwqDCoDcgNzU5NjEgMTM4Mjc2
IDE4MjY2OMKgwqA0NTY2N8KgwqDCoMKgwqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzoz
McKgwqDCoDEywqDCoMKgOCA4NDg5OSAxNTE4MjkgMjAwNzY0wqDCoDUwMTkxwqDCoMKgwqDCoMKg
MMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjMywqDCoMKgMTPCoMKgwqA4IDgxMzg2IDE0MTA5
MSAxODY0NDTCoMKgNDY2MTHCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6
MzPCoMKgwqAxNcKgwqDCoDnCoMKgMTAwSyAxNjc0ODkgMjIxNjQwwqDCoDU1NDEwwqDCoMKgwqDC
oMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3OjE3OjM0wqDCoMKgMTTCoMKgwqA5IDg5NjAxIDE1
ODc2NSAyMTAwMzLCoMKgNTI1MDjCoMKgwqDCoMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6
MTc6MzXCoMKgwqAxNMKgwqDCoDkgOTI0NDAgMTU1Mjg3IDIwNTIxNsKgwqA1MTMwNMKgwqDCoMKg
wqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzozNsKgwqDCoDE1wqDCoDEwIDkwMDQyIDE1
NTkzNCAyMDYxNjjCoMKgNTE1NDLCoMKgwqDCoMKgwqA0wqDCoMKgwqDCoMKgMcKgPGJyPg0KMTc6
MTc6MzfCoMKgwqAxNMKgwqDCoDkgOTE2NzAgMTY0NDU2IDIxNzY4NMKgwqA1NDQyMcKgwqDCoMKg
wqDCoDDCoMKgwqDCoMKgwqAwwqA8YnI+DQoxNzoxNzozOMKgwqDCoDE0wqDCoMKgOSA3ODYxMiAx
NjczNjggMjIxMzQ4wqDCoDU1MzM3wqDCoMKgwqDCoMKgMMKgwqDCoMKgwqDCoDDCoDxicj4NCjE3
OjE3OjM5wqDCoMKgMTXCoMKgwqA5IDkxMzI1IDE2MjU5OSAyMTQ2MTbCoMKgNTM2NTTCoMKgwqDC
oMKgwqAwwqDCoMKgwqDCoMKgMMKgPGJyPg0KMTc6MTc6NDDCoMKgwqAxNMKgwqDCoDkgNzkxMTIg
MTUxNTk1IDE5OTk4NMKgwqA1MDAwMMKgwqDCoMKgwqAyMcKgwqDCoMKgwqDCoDjCoDxicj4NCjE3
OjE3OjQxwqDCoMKgwqA5wqDCoMKgMyAzMjU2NcKgwqA2MDkzNsKgwqA3OTgzMsKgwqAxOTk2NMKg
wqDCoMKgPHdicj7CoDMywqDCoMKgwqDCoDEywqA8YnI+DQo8YnI+DQo8YnI+DQo8L2Jsb2NrcXVv
dGU+PC9kaXY+PGJyPjwvZGl2Pg0K
--001a1147a26c37834c0563145e89--


--===============0138700462631281455==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0138700462631281455==--
