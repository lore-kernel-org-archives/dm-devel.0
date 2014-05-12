From: Wayne Chou <gmmark12@gmail.com>
Subject: Performance question when blocks in thin-pool are assume
	zeroed
Date: Mon, 12 May 2014 16:54:23 +0800
Message-ID: <CAGj=0YKTvxwojR-0Xp6--o=u7zwBYdLMMaiUSA58f_fZ7RdhvQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7975262541073452112=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============7975262541073452112==
Content-Type: multipart/alternative; boundary=001a11390f1c027f0d04f93018d0

--001a11390f1c027f0d04f93018d0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

I am using 4 drives to construct a RAID5 and build a thin
volume on it. To get better performance, I use '-Zn' option
in 'lvcreate' to make the thin pool assume all blocks are
already zeroed.  The chunk size in RAID5 and thin-pool are
both 512KB and the stripe_cache_size=3D4096 on RAID5.

The following is the performance result I got when writes to
a RAID5 device and a thin volume:

dd if=3D/dev/zero of=3D/dev/md5 bs=3D2M count=3D1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB) copied, 6.02630 seconds, 348 MB/s

dd if=3D/dev/zero of=3D/dev/mapper/vg1-lv1 bs=3D2M count=3D1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB) copied, 11.58648 seconds, 181 MB/s

To find out what may cause the performance dropped so much, I
made some traces in codes and finally got some interesting
result. First, the bio size with dd command is 4KB, thus every
128 bios would fill up a thin-block/RAID-chunk in my situation.
Since I have set =E2=80=98pool->pf.zero_new_blocks=E2=80=99 =3D false, it s=
eems
when a new block is provisioned for a bio, this bio would be
put back to the tail of =E2=80=98pool->deferred_bios=E2=80=99 list but rath=
er
than issue it immediately. Thus, this made a re-arrangement
for the incoming bio sequences.

For example, the bi_sector of the incoming each =E2=80=98PAGE_SIZE=E2=80=99=
 bios
are:
bi_sector :  [0, 8, 16, 32,......1024]
After each of them got mapped, the orders of issuing to the lower
layer become non-sequential as:
bi_sector :  [8,16,24,=E2=80=A6136,144,152, =E2=80=A61016] + [0,128,256,384=
,512,
640,768,896,1024]

As you can see, the bios which triggered the provision_block()
got re-arranged and separated with other consecutive ones. Thus,
if the lower layer device cannot merge them back, this may cause
some read-modify-writes or seek latency overhead.

According to this observation, I made a rough patch on kernel 3.6
to maintain the sequential order of bios when
=E2=80=98pool->pf.zero_new_blocks=E2=80=99 =3D false:

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index b0a5ed9..76cda40 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1321,6 +1321,7 @@ static void schedule_zero(struct thin_c *tc,
dm_block_t virt_block,
 {
  struct pool *pool =3D tc->pool;
  struct new_mapping *m =3D get_next_mapping(pool);
+ int r;

  INIT_LIST_HEAD(&m->list);
  m->quiesced =3D 1;
@@ -1337,9 +1338,20 @@ static void schedule_zero(struct thin_c *tc,
dm_block_t virt_block,
  * zeroing pre-existing data, we can issue the bio immediately.
  * Otherwise we use kcopyd to zero the data first.
  */
- if (!pool->pf.zero_new_blocks)
- process_prepared_mapping(m);
-
+ if (!pool->pf.zero_new_blocks) {
+ r =3D dm_thin_insert_block(tc->td, m->virt_block, m->data_block, 0);
+ if (r) {
+ DMERR("schedule_zero() failed");
+ cell_error(m->cell);
+ }
+ else {
+ inc_all_io_entry(pool, bio);
+ cell_defer_except(tc, cell);
+ remap_and_issue(tc, bio, data_block);
+ }
+ list_del(&m->list);
+ mempool_free(m, tc->pool->mapping_pool);
+ }
  else if (io_overwrites_block(pool, bio)) {
  struct endio_hook *h =3D dm_get_mapinfo(bio)->ptr;
  h->overwrite_mapping =3D m;

And the performance also got better:
dd if=3D/dev/zero of=3D/dev/mapper/vg1-lv1 bs=3D2M count=3D1000
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB) copied, 6.16819 seconds, 340 MB/s

Suppose my thin-pool is setup with pf->zero_new_blocks =3D false,
I think it's OK to issue one bio immediately rather than put it
back to the pool->deferred_bios when the mapping is known. Thus,
the sequential order can be maintained in this way. However, I
wonder if I would miss some cases in this rough patch, any
suggestions would be helpful.

--001a11390f1c027f0d04f93018d0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hello,=C2=A0</div><div><br></div><div>I am using 4 dr=
ives to construct a RAID5 and build a thin=C2=A0</div><div>volume on it. To=
 get better performance, I use &#39;-Zn&#39; option</div><div>in &#39;lvcre=
ate&#39; to make the thin pool assume all blocks are=C2=A0</div>
<div>already zeroed. =C2=A0The chunk size in RAID5 and thin-pool are=C2=A0<=
/div><div>both 512KB and the stripe_cache_size=3D4096 on RAID5.</div><div><=
br></div><div>The following is the performance result I got when writes to<=
/div><div>
a RAID5 device and a thin volume:</div><div><br></div><div>dd if=3D/dev/zer=
o of=3D/dev/md5 bs=3D2M count=3D1000</div><div>1000+0 records in</div><div>=
1000+0 records out</div><div>2097152000 bytes (2.1 GB) copied, 6.02630 seco=
nds, 348 MB/s</div>
<div><br></div><div>dd if=3D/dev/zero of=3D/dev/mapper/vg1-lv1 bs=3D2M coun=
t=3D1000</div><div>1000+0 records in</div><div>1000+0 records out</div><div=
>2097152000 bytes (2.1 GB) copied, 11.58648 seconds, 181 MB/s</div><div><br=
></div>
<div>To find out what may cause the performance dropped so much, I=C2=A0</d=
iv><div>made some traces in codes and finally got some interesting=C2=A0</d=
iv><div>result. First, the bio size with dd command is 4KB, thus every</div=
><div>
128 bios would fill up a thin-block/RAID-chunk in my situation.=C2=A0</div>=
<div>Since I have set =E2=80=98pool-&gt;pf.zero_new_blocks=E2=80=99 =3D fal=
se, it seems</div><div>when a new block is provisioned for a bio, this bio =
would be=C2=A0</div><div>
put back to the tail of =E2=80=98pool-&gt;deferred_bios=E2=80=99 list but r=
ather</div><div>than issue it immediately. Thus, this made a re-arrangement=
=C2=A0</div><div>for the incoming bio sequences.=C2=A0</div><div><br></div>=
<div>For example, the bi_sector of the incoming each =E2=80=98PAGE_SIZE=E2=
=80=99 bios</div>
<div>are:</div><div>bi_sector : =C2=A0[0, 8, 16, 32,......1024]</div><div>A=
fter each of them got mapped, the orders of issuing to the lower</div><div>=
layer become non-sequential as:</div><div>bi_sector : =C2=A0[8,16,24,=E2=80=
=A6136,144,152, =E2=80=A61016] + [0,128,256,384,512,=C2=A0</div>
<div>640,768,896,1024]</div><div><br></div><div>As you can see, the bios wh=
ich triggered the provision_block()=C2=A0</div><div>got re-arranged and sep=
arated with other consecutive ones. Thus,=C2=A0</div><div>if the lower laye=
r device cannot merge them back, this may cause=C2=A0</div>
<div>some read-modify-writes or seek latency overhead.</div><div><br></div>=
<div>According to this observation, I made a rough patch on kernel 3.6</div=
><div>to maintain the sequential order of bios when=C2=A0</div><div>=E2=80=
=98pool-&gt;pf.zero_new_blocks=E2=80=99 =3D false:</div>
<div><br></div><div>diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.=
c</div><div>index b0a5ed9..76cda40 100644</div><div>--- a/drivers/md/dm-thi=
n.c</div><div>+++ b/drivers/md/dm-thin.c</div><div>@@ -1321,6 +1321,7 @@ st=
atic void schedule_zero(struct thin_c *tc, dm_block_t virt_block,</div>
<div>=C2=A0{</div><div>=C2=A0<span class=3D"" style=3D"white-space:pre">	</=
span>struct pool *pool =3D tc-&gt;pool;</div><div>=C2=A0<span class=3D"" st=
yle=3D"white-space:pre">	</span>struct new_mapping *m =3D get_next_mapping(=
pool);</div><div>+<span class=3D"" style=3D"white-space:pre">	</span>int r;=
</div>
<div>=C2=A0</div><div>=C2=A0<span class=3D"" style=3D"white-space:pre">	</s=
pan>INIT_LIST_HEAD(&amp;m-&gt;list);</div><div>=C2=A0<span class=3D"" style=
=3D"white-space:pre">	</span>m-&gt;quiesced =3D 1;</div><div>@@ -1337,9 +13=
38,20 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block=
,</div>
<div>=C2=A0<span class=3D"" style=3D"white-space:pre">	</span> * zeroing pr=
e-existing data, we can issue the bio immediately.</div><div>=C2=A0<span cl=
ass=3D"" style=3D"white-space:pre">	</span> * Otherwise we use kcopyd to ze=
ro the data first.</div>
<div>=C2=A0<span class=3D"" style=3D"white-space:pre">	</span> */</div><div=
>-<span class=3D"" style=3D"white-space:pre">	</span>if (!pool-&gt;pf.zero_=
new_blocks)</div><div>-<span class=3D"" style=3D"white-space:pre">		</span>=
process_prepared_mapping(m);</div>
<div>-</div><div>+<span class=3D"" style=3D"white-space:pre">	</span>if (!p=
ool-&gt;pf.zero_new_blocks) {</div><div>+<span class=3D"" style=3D"white-sp=
ace:pre">		</span>r =3D dm_thin_insert_block(tc-&gt;td, m-&gt;virt_block, m=
-&gt;data_block, 0);</div>
<div>+<span class=3D"" style=3D"white-space:pre">		</span>if (r) {</div><di=
v>+<span class=3D"" style=3D"white-space:pre">			</span>DMERR(&quot;schedul=
e_zero() failed&quot;);</div><div>+<span class=3D"" style=3D"white-space:pr=
e">			</span>cell_error(m-&gt;cell);</div>
<div>+<span class=3D"" style=3D"white-space:pre">		</span>}</div><div>+<spa=
n class=3D"" style=3D"white-space:pre">		</span>else {</div><div>+<span cla=
ss=3D"" style=3D"white-space:pre">			</span>inc_all_io_entry(pool, bio);</d=
iv><div>
+<span class=3D"" style=3D"white-space:pre">			</span>cell_defer_except(tc,=
 cell);</div><div>+<span class=3D"" style=3D"white-space:pre">			</span>rem=
ap_and_issue(tc, bio, data_block);</div><div>+<span class=3D"" style=3D"whi=
te-space:pre">		</span>}</div>
<div>+<span class=3D"" style=3D"white-space:pre">		</span>list_del(&amp;m-&=
gt;list);</div><div>+<span class=3D"" style=3D"white-space:pre">		</span>me=
mpool_free(m, tc-&gt;pool-&gt;mapping_pool);</div><div>+<span class=3D"" st=
yle=3D"white-space:pre">	</span>}</div>
<div>=C2=A0<span class=3D"" style=3D"white-space:pre">	</span>else if (io_o=
verwrites_block(pool, bio)) {</div><div>=C2=A0<span class=3D"" style=3D"whi=
te-space:pre">		</span>struct endio_hook *h =3D dm_get_mapinfo(bio)-&gt;ptr=
;</div><div>=C2=A0<span class=3D"" style=3D"white-space:pre">		</span>h-&gt=
;overwrite_mapping =3D m;</div>
<div><br></div><div>And the performance also got better:</div><div>dd if=3D=
/dev/zero of=3D/dev/mapper/vg1-lv1 bs=3D2M count=3D1000</div><div>1000+0 re=
cords in</div><div>1000+0 records out</div><div>2097152000 bytes (2.1 GB) c=
opied, 6.16819 seconds, 340 MB/s</div>
<div><br></div><div>Suppose my thin-pool is setup with pf-&gt;zero_new_bloc=
ks =3D false,</div><div>I think it&#39;s OK to issue one bio immediately ra=
ther than put it=C2=A0</div><div>back to the pool-&gt;deferred_bios when th=
e mapping is known. Thus,=C2=A0</div>
<div>the sequential order can be maintained in this way. However, I=C2=A0</=
div><div>wonder if I would miss some cases in this rough patch, any=C2=A0</=
div><div>suggestions would be helpful.</div><div><br></div><div><br></div><=
/div>

--001a11390f1c027f0d04f93018d0--


--===============7975262541073452112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7975262541073452112==--
