From: Tommy Cumberland <tcumberland77@gmail.com>
Subject: Re: dm-devel Digest, Vol 179, Issue 15
Date: Thu, 14 Feb 2019 04:11:13 -0500
Message-ID: <CAEsKJHeFZ_N-0SssruOsx3yOVwAOfbjqZKLwq1UaMFm=2qeuuQ@mail.gmail.com>
References: <mailman.53.1547917217.8468.dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8294918656980623542=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <mailman.53.1547917217.8468.dm-devel@redhat.com>
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

--===============8294918656980623542==
Content-Type: multipart/alternative; boundary="000000000000f36cab0581d70a09"

--000000000000f36cab0581d70a09
Content-Type: text/plain; charset="UTF-8"

Can u help me

On Sat, Jan 19, 2019, 12:00 PM <dm-devel-request@redhat.com> wrote:

> Send dm-devel mailing list submissions to
>         dm-devel@redhat.com
>
> To subscribe or unsubscribe via the World Wide Web, visit
>         https://www.redhat.com/mailman/listinfo/dm-devel
> or, via email, send a message with subject or body 'help' to
>         dm-devel-request@redhat.com
>
> You can reach the person managing the list at
>         dm-devel-owner@redhat.com
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of dm-devel digest..."
>
>
> Today's Topics:
>
>    1. Re: [PATCH] bcache: never writeback a discard operation (Coly Li)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Sat, 19 Jan 2019 19:03:36 +0800
> From: Coly Li <colyli@suse.de>
> To: Daniel Axtens <dja@axtens.net>
> Cc: Michael Lyle <mlyle@lyle.org>,      "Guilherme G . Piccoli"
>         <gpiccoli@canonical.com>,       linux-bcache@vger.kernel.org,
>         linux-block@vger.kernel.org,    dm-devel@redhat.com, Mauricio
> Oliveira
>         <mauricio.oliveira@canonical.com>,      Kent Overstreet
>         <kent.overstreet@gmail.com>
> Subject: Re: [dm-devel] [PATCH] bcache: never writeback a discard
>         operation
> Message-ID: <b269c2f9-91fe-3b61-75e7-f319ba2b39de@suse.de>
> Content-Type: text/plain; charset=gbk
>
> ? 2019/1/18 ??1:18, Daniel Axtens ??:
> > Some users see panics like the following when performing fstrim on a
> bcached volume:
> >
> > [  529.803060] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> > [  530.183928] #PF error: [normal kernel read fault]
> > [  530.412392] PGD 8000001f42163067 P4D 8000001f42163067 PUD 1f42168067
> PMD 0
> > [  530.750887] Oops: 0000 [#1] SMP PTI
> > [  530.920869] CPU: 10 PID: 4167 Comm: fstrim Kdump: loaded Not tainted
> 5.0.0-rc1+ #3
> > [  531.290204] Hardware name: HP ProLiant DL360 Gen9/ProLiant DL360
> Gen9, BIOS P89 12/27/2015
> > [  531.693137] RIP: 0010:blk_queue_split+0x148/0x620
> > [  531.922205] Code: 60 38 89 55 a0 45 31 db 45 31 f6 45 31 c9 31 ff 89
> 4d 98 85 db 0f 84 7f 04 00 00 44 8b 6d 98 4c 89 ee 48 c1 e6 04 49 03 70 78
> <8b> 46 08 44 8b 56 0c 48
> > 8b 16 44 29 e0 39 d8 48 89 55 a8 0f 47 c3
> > [  532.838634] RSP: 0018:ffffb9b708df39b0 EFLAGS: 00010246
> > [  533.093571] RAX: 00000000ffffffff RBX: 0000000000046000 RCX:
> 0000000000000000
> > [  533.441865] RDX: 0000000000000200 RSI: 0000000000000000 RDI:
> 0000000000000000
> > [  533.789922] RBP: ffffb9b708df3a48 R08: ffff940d3b3fdd20 R09:
> 0000000000000000
> > [  534.137512] R10: ffffb9b708df3958 R11: 0000000000000000 R12:
> 0000000000000000
> > [  534.485329] R13: 0000000000000000 R14: 0000000000000000 R15:
> ffff940d39212020
> > [  534.833319] FS:  00007efec26e3840(0000) GS:ffff940d1f480000(0000)
> knlGS:0000000000000000
> > [  535.224098] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  535.504318] CR2: 0000000000000008 CR3: 0000001f4e256004 CR4:
> 00000000001606e0
> > [  535.851759] Call Trace:
> > [  535.970308]  ? mempool_alloc_slab+0x15/0x20
> > [  536.174152]  ? bch_data_insert+0x42/0xd0 [bcache]
> > [  536.403399]  blk_mq_make_request+0x97/0x4f0
> > [  536.607036]  generic_make_request+0x1e2/0x410
> > [  536.819164]  submit_bio+0x73/0x150
> > [  536.980168]  ? submit_bio+0x73/0x150
> > [  537.149731]  ? bio_associate_blkg_from_css+0x3b/0x60
> > [  537.391595]  ? _cond_resched+0x1a/0x50
> > [  537.573774]  submit_bio_wait+0x59/0x90
> > [  537.756105]  blkdev_issue_discard+0x80/0xd0
> > [  537.959590]  ext4_trim_fs+0x4a9/0x9e0
> > [  538.137636]  ? ext4_trim_fs+0x4a9/0x9e0
> > [  538.324087]  ext4_ioctl+0xea4/0x1530
> > [  538.497712]  ? _copy_to_user+0x2a/0x40
> > [  538.679632]  do_vfs_ioctl+0xa6/0x600
> > [  538.853127]  ? __do_sys_newfstat+0x44/0x70
> > [  539.051951]  ksys_ioctl+0x6d/0x80
> > [  539.212785]  __x64_sys_ioctl+0x1a/0x20
> > [  539.394918]  do_syscall_64+0x5a/0x110
> > [  539.568674]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > We have observed it where both:
> > 1) LVM/devmapper is involved (bcache backing device is LVM volume) and
> > 2) writeback cache is involved (bcache cache_mode is writeback)
> >
> > On one machine, we can reliably reproduce it with:
> >
> >  # echo writeback > /sys/block/bcache0/bcache/cache_mode # not sure if
> this is required
> >  # mount /dev/bcache0 /test
> >  # for i in {0..10}; do file="$(mktemp /test/zero.XXX)"; dd if=/dev/zero
> of="$file" bs=1M count=256; sync; rm $file; done; fstrim -v /test
> >
> > Observing this with tracepoints on, we see the following writes:
> >
> > fstrim-18019 [022] .... 91107.302026: bcache_write:
> 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4260112 + 196352 hit 0
> bypass 1
> > fstrim-18019 [022] .... 91107.302050: bcache_write:
> 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4456464 + 262144 hit 0
> bypass 1
> > fstrim-18019 [022] .... 91107.302075: bcache_write:
> 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 4718608 + 81920 hit 0
> bypass 1
> > fstrim-18019 [022] .... 91107.302094: bcache_write:
> 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5324816 + 180224 hit 0
> bypass 1
> > fstrim-18019 [022] .... 91107.302121: bcache_write:
> 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5505040 + 262144 hit 0
> bypass 1
> > fstrim-18019 [022] .... 91107.302145: bcache_write:
> 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 5767184 + 81920 hit 0
> bypass 1
> > fstrim-18019 [022] .... 91107.308777: bcache_write:
> 73f95583-561c-408f-a93a-4cbd2498f5c8 inode 0  DS 6373392 + 180224 hit 1
> bypass 0
> > <crash>
> >
> > Note the final one has different hit/bypass flags.
> >
> > This is because in should_writeback(), we were hitting a case where
> > the partial stripe condition was returning true and so
> > should_writeback() was returning true early.
> >
> > If that hadn't been the case, it would have hit the would_skip test, and
> > as would_skip == s->iop.bypass == true, should_writeback() would have
> > returned false.
> >
> > Looking at the git history from 72c270612bd3 ("bcache: Write out full
> > stripes"), it looks like the idea was to optimise for raid5/6:
> >
> >        * If a stripe is already dirty, force writes to that stripe to
> >        writeback mode - to help build up full stripes of dirty data
> >
> > To fix this issue, make sure that should_writeback() on a discard op
> > never returns true.
> >
> > More details of debugging:
> https://www.spinics.net/lists/linux-bcache/msg06996.html
> >
> > Previous reports:
> >  - https://bugzilla.kernel.org/show_bug.cgi?id=201051
> >  - https://bugzilla.kernel.org/show_bug.cgi?id=196103
> >  - https://www.spinics.net/lists/linux-bcache/msg06885.html
> >
> > Cc: Kent Overstreet <koverstreet@google.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 72c270612bd3 ("bcache: Write out full stripes")
> > Signed-off-by: Daniel Axtens <dja@axtens.net>
> > ---
> >  drivers/md/bcache/writeback.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/md/bcache/writeback.h
> b/drivers/md/bcache/writeback.h
> > index 6a743d3bb338..4e4c6810dc3c 100644
> > --- a/drivers/md/bcache/writeback.h
> > +++ b/drivers/md/bcache/writeback.h
> > @@ -71,6 +71,9 @@ static inline bool should_writeback(struct cached_dev
> *dc, struct bio *bio,
> >           in_use > bch_cutoff_writeback_sync)
> >               return false;
> >
> > +     if (bio_op(bio) == REQ_OP_DISCARD)
> > +             return false;
> > +
> >       if (dc->partial_stripes_expensive &&
> >           bcache_dev_stripe_dirty(dc, bio->bi_iter.bi_sector,
> >                                   bio_sectors(bio)))
> >
>
> Hi Daniel,
>
> Nice catch! I add this one to my for-next directory, for v5.1 merge window.
>
> Thanks.
>
> --
>
> Coly Li
>
>
>
> ------------------------------
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
> End of dm-devel Digest, Vol 179, Issue 15
> *****************************************
>

--000000000000f36cab0581d70a09
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Can u help me=C2=A0</div><br><div class=3D"gmail_quote"><=
div dir=3D"ltr">On Sat, Jan 19, 2019, 12:00 PM  &lt;<a href=3D"mailto:dm-de=
vel-request@redhat.com">dm-devel-request@redhat.com</a>&gt; wrote:<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex">Send dm-devel mailing list submissions to<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:dm-devel@redhat.com" target=
=3D"_blank" rel=3D"noreferrer">dm-devel@redhat.com</a><br>
<br>
To subscribe or unsubscribe via the World Wide Web, visit<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"https://www.redhat.com/mailman/listi=
nfo/dm-devel" rel=3D"noreferrer noreferrer" target=3D"_blank">https://www.r=
edhat.com/mailman/listinfo/dm-devel</a><br>
or, via email, send a message with subject or body &#39;help&#39; to<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:dm-devel-request@redhat.com" =
target=3D"_blank" rel=3D"noreferrer">dm-devel-request@redhat.com</a><br>
<br>
You can reach the person managing the list at<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:dm-devel-owner@redhat.com" ta=
rget=3D"_blank" rel=3D"noreferrer">dm-devel-owner@redhat.com</a><br>
<br>
When replying, please edit your Subject line so it is more specific<br>
than &quot;Re: Contents of dm-devel digest...&quot;<br>
<br>
<br>
Today&#39;s Topics:<br>
<br>
=C2=A0 =C2=A01. Re: [PATCH] bcache: never writeback a discard operation (Co=
ly Li)<br>
<br>
<br>
----------------------------------------------------------------------<br>
<br>
Message: 1<br>
Date: Sat, 19 Jan 2019 19:03:36 +0800<br>
From: Coly Li &lt;<a href=3D"mailto:colyli@suse.de" target=3D"_blank" rel=
=3D"noreferrer">colyli@suse.de</a>&gt;<br>
To: Daniel Axtens &lt;<a href=3D"mailto:dja@axtens.net" target=3D"_blank" r=
el=3D"noreferrer">dja@axtens.net</a>&gt;<br>
Cc: Michael Lyle &lt;<a href=3D"mailto:mlyle@lyle.org" target=3D"_blank" re=
l=3D"noreferrer">mlyle@lyle.org</a>&gt;,=C2=A0 =C2=A0 =C2=A0 &quot;Guilherm=
e G . Piccoli&quot;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;<a href=3D"mailto:gpiccoli@canonical.com" t=
arget=3D"_blank" rel=3D"noreferrer">gpiccoli@canonical.com</a>&gt;,=C2=A0 =
=C2=A0 =C2=A0 =C2=A0<a href=3D"mailto:linux-bcache@vger.kernel.org" target=
=3D"_blank" rel=3D"noreferrer">linux-bcache@vger.kernel.org</a>,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"mailto:linux-block@vger.kernel.org" =
target=3D"_blank" rel=3D"noreferrer">linux-block@vger.kernel.org</a>,=C2=A0=
 =C2=A0 <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank" rel=3D"nor=
eferrer">dm-devel@redhat.com</a>, Mauricio Oliveira<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;<a href=3D"mailto:mauricio.oliveira@canonic=
al.com" target=3D"_blank" rel=3D"noreferrer">mauricio.oliveira@canonical.co=
m</a>&gt;,=C2=A0 =C2=A0 =C2=A0 Kent Overstreet<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;<a href=3D"mailto:kent.overstreet@gmail.com=
" target=3D"_blank" rel=3D"noreferrer">kent.overstreet@gmail.com</a>&gt;<br=
>
Subject: Re: [dm-devel] [PATCH] bcache: never writeback a discard<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 operation<br>
Message-ID: &lt;<a href=3D"mailto:b269c2f9-91fe-3b61-75e7-f319ba2b39de@suse=
.de" target=3D"_blank" rel=3D"noreferrer">b269c2f9-91fe-3b61-75e7-f319ba2b3=
9de@suse.de</a>&gt;<br>
Content-Type: text/plain; charset=3Dgbk<br>
<br>
? 2019/1/18 ??1:18, Daniel Axtens ??:<br>
&gt; Some users see panics like the following when performing fstrim on a b=
cached volume:<br>
&gt; <br>
&gt; [=C2=A0 529.803060] BUG: unable to handle kernel NULL pointer derefere=
nce at 0000000000000008<br>
&gt; [=C2=A0 530.183928] #PF error: [normal kernel read fault]<br>
&gt; [=C2=A0 530.412392] PGD 8000001f42163067 P4D 8000001f42163067 PUD 1f42=
168067 PMD 0<br>
&gt; [=C2=A0 530.750887] Oops: 0000 [#1] SMP PTI<br>
&gt; [=C2=A0 530.920869] CPU: 10 PID: 4167 Comm: fstrim Kdump: loaded Not t=
ainted 5.0.0-rc1+ #3<br>
&gt; [=C2=A0 531.290204] Hardware name: HP ProLiant DL360 Gen9/ProLiant DL3=
60 Gen9, BIOS P89 12/27/2015<br>
&gt; [=C2=A0 531.693137] RIP: 0010:blk_queue_split+0x148/0x620<br>
&gt; [=C2=A0 531.922205] Code: 60 38 89 55 a0 45 31 db 45 31 f6 45 31 c9 31=
 ff 89 4d 98 85 db 0f 84 7f 04 00 00 44 8b 6d 98 4c 89 ee 48 c1 e6 04 49 03=
 70 78 &lt;8b&gt; 46 08 44 8b 56 0c 48<br>
&gt; 8b 16 44 29 e0 39 d8 48 89 55 a8 0f 47 c3<br>
&gt; [=C2=A0 532.838634] RSP: 0018:ffffb9b708df39b0 EFLAGS: 00010246<br>
&gt; [=C2=A0 533.093571] RAX: 00000000ffffffff RBX: 0000000000046000 RCX: 0=
000000000000000<br>
&gt; [=C2=A0 533.441865] RDX: 0000000000000200 RSI: 0000000000000000 RDI: 0=
000000000000000<br>
&gt; [=C2=A0 533.789922] RBP: ffffb9b708df3a48 R08: ffff940d3b3fdd20 R09: 0=
000000000000000<br>
&gt; [=C2=A0 534.137512] R10: ffffb9b708df3958 R11: 0000000000000000 R12: 0=
000000000000000<br>
&gt; [=C2=A0 534.485329] R13: 0000000000000000 R14: 0000000000000000 R15: f=
fff940d39212020<br>
&gt; [=C2=A0 534.833319] FS:=C2=A0 00007efec26e3840(0000) GS:ffff940d1f4800=
00(0000) knlGS:0000000000000000<br>
&gt; [=C2=A0 535.224098] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005=
0033<br>
&gt; [=C2=A0 535.504318] CR2: 0000000000000008 CR3: 0000001f4e256004 CR4: 0=
0000000001606e0<br>
&gt; [=C2=A0 535.851759] Call Trace:<br>
&gt; [=C2=A0 535.970308]=C2=A0 ? mempool_alloc_slab+0x15/0x20<br>
&gt; [=C2=A0 536.174152]=C2=A0 ? bch_data_insert+0x42/0xd0 [bcache]<br>
&gt; [=C2=A0 536.403399]=C2=A0 blk_mq_make_request+0x97/0x4f0<br>
&gt; [=C2=A0 536.607036]=C2=A0 generic_make_request+0x1e2/0x410<br>
&gt; [=C2=A0 536.819164]=C2=A0 submit_bio+0x73/0x150<br>
&gt; [=C2=A0 536.980168]=C2=A0 ? submit_bio+0x73/0x150<br>
&gt; [=C2=A0 537.149731]=C2=A0 ? bio_associate_blkg_from_css+0x3b/0x60<br>
&gt; [=C2=A0 537.391595]=C2=A0 ? _cond_resched+0x1a/0x50<br>
&gt; [=C2=A0 537.573774]=C2=A0 submit_bio_wait+0x59/0x90<br>
&gt; [=C2=A0 537.756105]=C2=A0 blkdev_issue_discard+0x80/0xd0<br>
&gt; [=C2=A0 537.959590]=C2=A0 ext4_trim_fs+0x4a9/0x9e0<br>
&gt; [=C2=A0 538.137636]=C2=A0 ? ext4_trim_fs+0x4a9/0x9e0<br>
&gt; [=C2=A0 538.324087]=C2=A0 ext4_ioctl+0xea4/0x1530<br>
&gt; [=C2=A0 538.497712]=C2=A0 ? _copy_to_user+0x2a/0x40<br>
&gt; [=C2=A0 538.679632]=C2=A0 do_vfs_ioctl+0xa6/0x600<br>
&gt; [=C2=A0 538.853127]=C2=A0 ? __do_sys_newfstat+0x44/0x70<br>
&gt; [=C2=A0 539.051951]=C2=A0 ksys_ioctl+0x6d/0x80<br>
&gt; [=C2=A0 539.212785]=C2=A0 __x64_sys_ioctl+0x1a/0x20<br>
&gt; [=C2=A0 539.394918]=C2=A0 do_syscall_64+0x5a/0x110<br>
&gt; [=C2=A0 539.568674]=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xa9<br>
&gt; <br>
&gt; We have observed it where both:<br>
&gt; 1) LVM/devmapper is involved (bcache backing device is LVM volume) and=
<br>
&gt; 2) writeback cache is involved (bcache cache_mode is writeback)<br>
&gt; <br>
&gt; On one machine, we can reliably reproduce it with:<br>
&gt; <br>
&gt;=C2=A0 # echo writeback &gt; /sys/block/bcache0/bcache/cache_mode # not=
 sure if this is required<br>
&gt;=C2=A0 # mount /dev/bcache0 /test<br>
&gt;=C2=A0 # for i in {0..10}; do file=3D&quot;$(mktemp /test/zero.XXX)&quo=
t;; dd if=3D/dev/zero of=3D&quot;$file&quot; bs=3D1M count=3D256; sync; rm =
$file; done; fstrim -v /test<br>
&gt; <br>
&gt; Observing this with tracepoints on, we see the following writes:<br>
&gt; <br>
&gt; fstrim-18019 [022] .... 91107.302026: bcache_write: 73f95583-561c-408f=
-a93a-4cbd2498f5c8 inode 0=C2=A0 DS 4260112 + 196352 hit 0 bypass 1<br>
&gt; fstrim-18019 [022] .... 91107.302050: bcache_write: 73f95583-561c-408f=
-a93a-4cbd2498f5c8 inode 0=C2=A0 DS 4456464 + 262144 hit 0 bypass 1<br>
&gt; fstrim-18019 [022] .... 91107.302075: bcache_write: 73f95583-561c-408f=
-a93a-4cbd2498f5c8 inode 0=C2=A0 DS 4718608 + 81920 hit 0 bypass 1<br>
&gt; fstrim-18019 [022] .... 91107.302094: bcache_write: 73f95583-561c-408f=
-a93a-4cbd2498f5c8 inode 0=C2=A0 DS 5324816 + 180224 hit 0 bypass 1<br>
&gt; fstrim-18019 [022] .... 91107.302121: bcache_write: 73f95583-561c-408f=
-a93a-4cbd2498f5c8 inode 0=C2=A0 DS 5505040 + 262144 hit 0 bypass 1<br>
&gt; fstrim-18019 [022] .... 91107.302145: bcache_write: 73f95583-561c-408f=
-a93a-4cbd2498f5c8 inode 0=C2=A0 DS 5767184 + 81920 hit 0 bypass 1<br>
&gt; fstrim-18019 [022] .... 91107.308777: bcache_write: 73f95583-561c-408f=
-a93a-4cbd2498f5c8 inode 0=C2=A0 DS 6373392 + 180224 hit 1 bypass 0<br>
&gt; &lt;crash&gt;<br>
&gt; <br>
&gt; Note the final one has different hit/bypass flags.<br>
&gt; <br>
&gt; This is because in should_writeback(), we were hitting a case where<br=
>
&gt; the partial stripe condition was returning true and so<br>
&gt; should_writeback() was returning true early.<br>
&gt; <br>
&gt; If that hadn&#39;t been the case, it would have hit the would_skip tes=
t, and<br>
&gt; as would_skip =3D=3D s-&gt;iop.bypass =3D=3D true, should_writeback() =
would have<br>
&gt; returned false.<br>
&gt; <br>
&gt; Looking at the git history from 72c270612bd3 (&quot;bcache: Write out =
full<br>
&gt; stripes&quot;), it looks like the idea was to optimise for raid5/6:<br=
>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If a stripe is already dirty, force write=
s to that stripe to<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 writeback mode - to help build up full stri=
pes of dirty data<br>
&gt; <br>
&gt; To fix this issue, make sure that should_writeback() on a discard op<b=
r>
&gt; never returns true.<br>
&gt; <br>
&gt; More details of debugging: <a href=3D"https://www.spinics.net/lists/li=
nux-bcache/msg06996.html" rel=3D"noreferrer noreferrer" target=3D"_blank">h=
ttps://www.spinics.net/lists/linux-bcache/msg06996.html</a><br>
&gt; <br>
&gt; Previous reports:<br>
&gt;=C2=A0 - <a href=3D"https://bugzilla.kernel.org/show_bug.cgi?id=3D20105=
1" rel=3D"noreferrer noreferrer" target=3D"_blank">https://bugzilla.kernel.=
org/show_bug.cgi?id=3D201051</a><br>
&gt;=C2=A0 - <a href=3D"https://bugzilla.kernel.org/show_bug.cgi?id=3D19610=
3" rel=3D"noreferrer noreferrer" target=3D"_blank">https://bugzilla.kernel.=
org/show_bug.cgi?id=3D196103</a><br>
&gt;=C2=A0 - <a href=3D"https://www.spinics.net/lists/linux-bcache/msg06885=
.html" rel=3D"noreferrer noreferrer" target=3D"_blank">https://www.spinics.=
net/lists/linux-bcache/msg06885.html</a><br>
&gt; <br>
&gt; Cc: Kent Overstreet &lt;<a href=3D"mailto:koverstreet@google.com" targ=
et=3D"_blank" rel=3D"noreferrer">koverstreet@google.com</a>&gt;<br>
&gt; Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank" rel=3D=
"noreferrer">stable@vger.kernel.org</a><br>
&gt; Fixes: 72c270612bd3 (&quot;bcache: Write out full stripes&quot;)<br>
&gt; Signed-off-by: Daniel Axtens &lt;<a href=3D"mailto:dja@axtens.net" tar=
get=3D"_blank" rel=3D"noreferrer">dja@axtens.net</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/md/bcache/writeback.h | 3 +++<br>
&gt;=C2=A0 1 file changed, 3 insertions(+)<br>
&gt; <br>
&gt; diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeba=
ck.h<br>
&gt; index 6a743d3bb338..4e4c6810dc3c 100644<br>
&gt; --- a/drivers/md/bcache/writeback.h<br>
&gt; +++ b/drivers/md/bcache/writeback.h<br>
&gt; @@ -71,6 +71,9 @@ static inline bool should_writeback(struct cached_de=
v *dc, struct bio *bio,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0in_use &gt; bch_cutoff_writeba=
ck_sync)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br=
>
&gt;=C2=A0 <br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (bio_op(bio) =3D=3D REQ_OP_DISCARD)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (dc-&gt;partial_stripes_expensive &amp;&a=
mp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bcache_dev_stripe_dirty(dc, bi=
o-&gt;bi_iter.bi_sector,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio_sectors(bio)))<b=
r>
&gt; <br>
<br>
Hi Daniel,<br>
<br>
Nice catch! I add this one to my for-next directory, for v5.1 merge window.=
<br>
<br>
Thanks.<br>
<br>
-- <br>
<br>
Coly Li<br>
<br>
<br>
<br>
------------------------------<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank" rel=3D"noreferrer"=
>dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer noreferrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/d=
m-devel</a><br>
<br>
End of dm-devel Digest, Vol 179, Issue 15<br>
*****************************************<br>
</blockquote></div>

--000000000000f36cab0581d70a09--


--===============8294918656980623542==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8294918656980623542==--
