From: Doug Dumitru <doug@easyco.com>
Subject: Re: Newbie device mapper questions
Date: Tue, 16 Jun 2015 14:05:48 -0700
Message-ID: <CAFx4rwRuUVYnrBzWwh=ntnEniShcdVjDgPLgkCZLLOJUVqk-8w@mail.gmail.com>
References: <557F1BFA.2080504@gmx.de>
	<CAFx4rwQ0ganzZn5FjQZTVtk1DK1Qr1pmMCTxRCwxd793+-anHg@mail.gmail.com>
	<558070E9.70607@gmx.de>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4377230157866156217=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <558070E9.70607@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4377230157866156217==
Content-Type: multipart/alternative; boundary=bcaec51b9b634f83480518a8f05e

--bcaec51b9b634f83480518a8f05e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Johannes,

I was not trying to scare you, just tell you the rough path.  I have been
exactly where you are.

On Tue, Jun 16, 2015 at 11:54 AM, Johannes Bauer <dfnsonfsduifb@gmx.de>
wrote:

> On 15.06.2015 21:52, Doug Dumitru wrote:
>
> >> Sounds pretty easy and I also got surprisingly far with my little kern=
el
> >> module. I've so far implemented ctr, dtr, map and status.
> >
> > =E2=80=8BCongratulations, you are actually a long way there.=E2=80=8B
>
> Thanks but I think I have the mountain still ahead -- still, I would
> really like to figure out the nitty-gritty.
>
> > =E2=80=8BYou have to allocate a bio, populate it, allocate pages for bu=
ffer,
> > populate the bvec, and call make_request (or generic make request).  Yo=
u
> > will get the completion from the bio on the bottom half of the interrup=
t
> > handler, so how much work you can do there is debatable.  You cannot
> start
> > an new IO from there, which you need to.  You will probably want to
> start a
> > helper thread and have the completion routine schedule itself onto your
> > thread.  Once you are back on your thread, you can do just about
> anything.
> >
> > Because you need to do IO, you will not be able to do a simple bio
> "bounce
> > redirect".  You will need to do the IO youself (ie, call another make
> > request), but you can use the callers bvec for this, so there is no dat=
a
> > copy required.  Once the request completes, you can then fin the caller=
.
>
> Oh, wow. This sounds truly terrifying. Let's dive in!
>
> I tried to read your hints one word at a time. So here's the somewhat
> pseudocodish solution to my homework:
>
> struct bio *b =3D bio_alloc(GFP_NOIO, 1);
> b->bi_size =3D 8;
> bio_alloc_pages(b, GFP_NOIO);
> b->bi_sector =3D 1234;
> b->bi_bdev =3D lc->metadev->bdev;
> b->bi_rw =3D READ;
> b->bi_private =3D local_ctx;
> b->bi_end_io =3D read_complete_callback;
> generic_make_request(bi);
>

=E2=80=8Bsize is in bytes

biovec count is in pages

you will need to allocate local_ctx (it cannot be on the stack).  You
probably need to allocate a structure in the .ctr routine that is your
"device context".  Each "operation" then gets it's own alloc that points
back to the device context.
=E2=80=8B


>
> static void read_complete_callback(struct bio *b, int error) {
>   // ???
>   printk(KERN_INFO "First read byte: %02x\n",
>      b->bi_io_vec[0]->bv_page[0]);
> }
>

=E2=80=8BHere you usally do:

Q_WORK *q =3D bio->bi_private
DEV *dev =3D q->dev;

to get your context back.=E2=80=8B


>
> So I hope this is even remotely close to what I should end up with.
>
> This will alloc a new bio with, as I understand it, one page buffer in
> b->bi_io_vec. This buffer is then allocated with bio_alloc_pages to 8
> sectors in size (i.e. exactly one page of 4096 bytes). Then the read
> address, block device and read mode is set. I pass some kind of local
> context so I can do something meaningful in the callback and specify the
> callback function. Then I execute the request.
>
> As I understand, this executes asynchronously. So here comes the
> threading into play, right? Just pseudocode (because I can't judge how
> far I'm off here), but let's say this is map():
>
> void read_complete_callback() {
>     semaphore_inc(local_ctx);
> }
>
> void map() {
>    local_ctx->semaphore->value =3D 0;
>
>    // Issue read as above
>    generic_make_request(bi);
>
>    semaphore_dec(&local_ctx->semaphore);
>
>    // Now the concurrent async IO has finished and we interpret the data
>    [...]
> }
>

=E2=80=8BIt is more like:  (really psuedo code)

thread_helper(...)

DEV *dev =3D thread_param;
while ( 1 ) {
  if ( dev->shutdown_flg ) break;
  spinlock(dev->workqueue_slock,flags);
  if ( dev->workqueue_head) {
    q =3D dev->workqueue_head;
    dev->workqueue_head =3D dev->workqueue_head->nxt;
    spinunlock(dev->workqueue_slock,flags);
    ... process q work
    continue;
  }
  spinunlock(dev->workqueue_slock,flags);
  down(dev->workqueue_sem);
}

You have to start the thread, setup a semaphore and spinlock.  Better is to
use a waitq, but semaphores do work.

When you want to schedule on the background, you add your new "q" item to
the head/tail single linked list.  A double linked list is fine and easier
to program, but overkill.
    =E2=80=8B


>
> Oh boy I really don't know if this is even remotely close. Any hints, as
> easy as they may seem to you guys, are really greatly appreciated. I've
> never worked with this stuff.
>

=E2=80=8BStart by creating a thread in module load and destroying it in mod=
ule
unload.  You can use statics as the DEV.  You should use atomics as "thread
counters", so when the thread starts, it increments the "running thread
count".  When a thread exits, it decrements the counter.  This way, the
module unload routine can set the "dev->shutddown_flag", do a bunch of
up(...) to wake up the threads, and then wait for the threads to exit by
watching the counter.  Throw in some sleeps to keep the loop waiting for
exits from killing the box.

If you do it correctly, you can start a bunch of copies of the worker
thread.  If you are after a lot of bandwidth or IOPS, this might be
helpful.  Otherwise, you can probably get away with just one.  Having just
one helper is nice because you don't have to set as many locks to protect
yourself from yourself.

Once you have your first live thread, you can build a queue to give it work
to do.  Once you have work you can give it, you are off to the races.
=E2=80=8B


>
> > =E2=80=8BIf you cannot continue because devices are not present or the =
right
> size,
> > yes you should fail the ctr routine.
>
> Alright!
>
> > If you want to setup /proc or other monitoring stuff, you can use the
> init
> > routine, probably plus some statics, to setup "views" into your module.
> If
> > you want to support multiple instances (and you should), setup a
> > /proc/{yourname} directory on the init and then populate it with
> > sub-directories every time you create a device.
>
> Okay, I'll try to do this (want to make statistics available via procfs
> later on), but one construction site at a time for me.
>
> >> - Can I determine the size the bio in map() will have already in ctr()
> >> somehow? Can I assume it will never change if it was once determined?
> >> The reason is that for my example I need to make sure the chunk size i=
s
> >> a integer multiple of the bio size and I would only like to check this
> >> once (in ctr) and not every time (in map).
> >
> > =E2=80=8BBlock size will not change.  The size of requests to you is li=
mited by
> the
> > setup of ti->max_io_len.  If you don't set this with recent kernels, yo=
u
> > will only get 4K, which is not all that efficient.  This is actually pa=
rt
> > of another big topic of "stacked limits", which someone could write a
> book
> > on (and I would read it).=E2=80=8B
>
> So if I would want to do a large I/O operation (say write one megabyte
> of data to a block device somewhere within my driver) I'd have to make
> lots of calls to generic_make_request?
>
> Thank you so much for your help,
> Best regards,
> Johannes
>



--=20
Doug Dumitru
EasyCo LLC

--bcaec51b9b634f83480518a8f05e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Johannes,<br><br></div><div class=3D"gm=
ail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:smal=
l">I was not trying to scare you, just tell you the rough path.=C2=A0 I hav=
e been exactly where you are.<br></div><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">On Tue, Jun 16, 2015 at 11:54 AM, Johannes Bauer <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:dfnsonfsduifb@gmx.de" target=3D"_blank"=
>dfnsonfsduifb@gmx.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><span class=3D"">On 15.06.2015 21:52, Doug Dumitru wrote:<br>
<br>
&gt;&gt; Sounds pretty easy and I also got surprisingly far with my little =
kernel<br>
&gt;&gt; module. I&#39;ve so far implemented ctr, dtr, map and status.<br>
&gt;<br>
&gt; =E2=80=8BCongratulations, you are actually a long way there.=E2=80=8B<=
br>
<br>
</span>Thanks but I think I have the mountain still ahead -- still, I would=
<br>
really like to figure out the nitty-gritty.<br>
<span class=3D""><br>
&gt; =E2=80=8BYou have to allocate a bio, populate it, allocate pages for b=
uffer,<br>
&gt; populate the bvec, and call make_request (or generic make request).=C2=
=A0 You<br>
&gt; will get the completion from the bio on the bottom half of the interru=
pt<br>
&gt; handler, so how much work you can do there is debatable.=C2=A0 You can=
not start<br>
&gt; an new IO from there, which you need to.=C2=A0 You will probably want =
to start a<br>
&gt; helper thread and have the completion routine schedule itself onto you=
r<br>
&gt; thread.=C2=A0 Once you are back on your thread, you can do just about =
anything.<br>
&gt;<br>
&gt; Because you need to do IO, you will not be able to do a simple bio &qu=
ot;bounce<br>
&gt; redirect&quot;.=C2=A0 You will need to do the IO youself (ie, call ano=
ther make<br>
&gt; request), but you can use the callers bvec for this, so there is no da=
ta<br>
&gt; copy required.=C2=A0 Once the request completes, you can then fin the =
caller.<br>
<br>
</span>Oh, wow. This sounds truly terrifying. Let&#39;s dive in!<br>
<br>
I tried to read your hints one word at a time. So here&#39;s the somewhat<b=
r>
pseudocodish solution to my homework:<br>
<br>
struct bio *b =3D bio_alloc(GFP_NOIO, 1);<br>
b-&gt;bi_size =3D 8;<br>
bio_alloc_pages(b, GFP_NOIO);<br>
b-&gt;bi_sector =3D 1234;<br>
b-&gt;bi_bdev =3D lc-&gt;metadev-&gt;bdev;<br>
b-&gt;bi_rw =3D READ;<br>
b-&gt;bi_private =3D local_ctx;<br>
b-&gt;bi_end_io =3D read_complete_callback;<br>
generic_make_request(bi);<br></blockquote><div><br><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;displa=
y:inline">=E2=80=8Bsize is in bytes<br></div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inli=
ne"><br>biovec count is in pages<br></div><div class=3D"gmail_default" styl=
e=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inline"=
><br>you will need to allocate local_ctx (it cannot be on the stack).=C2=A0=
 You probably need to allocate a structure in the .ctr routine that is your=
 &quot;device context&quot;.=C2=A0 Each &quot;operation&quot; then gets it&=
#39;s own alloc that points back to the device context.<br>=E2=80=8B</div>=
=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex">
<br>
static void read_complete_callback(struct bio *b, int error) {<br>
=C2=A0 // ???<br>
=C2=A0 printk(KERN_INFO &quot;First read byte: %02x\n&quot;,<br>
=C2=A0 =C2=A0 =C2=A0b-&gt;bi_io_vec[0]-&gt;bv_page[0]);<br>
}<br></blockquote><div><br><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif;font-size:small;display:inline">=E2=80=8BHere =
you usally do:<br><br></div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif;font-size:small;display:inline">Q_WORK *q =3D=
 bio-&gt;bi_private<br></div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif;font-size:small;display:inline">DEV *dev =3D=
 q-&gt;dev;<br><br></div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif;font-size:small;display:inline">to get your cont=
ext back.=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
So I hope this is even remotely close to what I should end up with.<br>
<br>
This will alloc a new bio with, as I understand it, one page buffer in<br>
b-&gt;bi_io_vec. This buffer is then allocated with bio_alloc_pages to 8<br=
>
sectors in size (i.e. exactly one page of 4096 bytes). Then the read<br>
address, block device and read mode is set. I pass some kind of local<br>
context so I can do something meaningful in the callback and specify the<br=
>
callback function. Then I execute the request.<br>
<br>
As I understand, this executes asynchronously. So here comes the<br>
threading into play, right? Just pseudocode (because I can&#39;t judge how<=
br>
far I&#39;m off here), but let&#39;s say this is map():<br>
<br>
void read_complete_callback() {<br>
=C2=A0 =C2=A0 semaphore_inc(local_ctx);<br>
}<br>
<br>
void map() {<br>
=C2=A0 =C2=A0local_ctx-&gt;semaphore-&gt;value =3D 0;<br>
<br>
=C2=A0 =C2=A0// Issue read as above<br>
=C2=A0 =C2=A0generic_make_request(bi);<br>
<br>
=C2=A0 =C2=A0semaphore_dec(&amp;local_ctx-&gt;semaphore);<br>
<br>
=C2=A0 =C2=A0// Now the concurrent async IO has finished and we interpret t=
he data<br>
=C2=A0 =C2=A0[...]<br>
}<br></blockquote><div><br><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif;font-size:small;display:inline">=E2=80=8BIt is=
 more like:=C2=A0 (really psuedo code)<br><br></div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;displ=
ay:inline">thread_helper(...)<br><br></div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inline=
">DEV *dev =3D thread_param;<br></div><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif;font-size:small;display:inline">whi=
le ( 1 ) {<br></div><div class=3D"gmail_default" style=3D"font-family:arial=
,helvetica,sans-serif;font-size:small;display:inline">=C2=A0 if ( dev-&gt;s=
hutdown_flg ) break;<br></div><div class=3D"gmail_default" style=3D"font-fa=
mily:arial,helvetica,sans-serif;font-size:small;display:inline">=C2=A0 spin=
lock(dev-&gt;workqueue_slock,flags);<br></div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inl=
ine">=C2=A0 if ( dev-&gt;workqueue_head) {<br></div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;displ=
ay:inline">=C2=A0=C2=A0=C2=A0 q =3D dev-&gt;workqueue_head;<br></div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font=
-size:small;display:inline">=C2=A0=C2=A0=C2=A0 dev-&gt;workqueue_head =3D d=
ev-&gt;workqueue_head-&gt;nxt;<br></div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inline">=
=C2=A0=C2=A0=C2=A0 spinunlock(dev-&gt;workqueue_slock,flags);<br></div><div=
 class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;fo=
nt-size:small;display:inline">=C2=A0=C2=A0=C2=A0 ... process q work<br></di=
v><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-se=
rif;font-size:small;display:inline">=C2=A0=C2=A0=C2=A0 continue;<br></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
;font-size:small;display:inline">=C2=A0 }<br></div><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;displa=
y:inline">=C2=A0 spinunlock(dev-&gt;workqueue_slock,flags);<br></div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font=
-size:small;display:inline">=C2=A0 down(dev-&gt;workqueue_sem);<br>}<br><br=
></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;font-size:small;display:inline">You have to start the thread, setu=
p a semaphore and spinlock.=C2=A0 Better is to use a waitq, but semaphores =
do work.<br><br></div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif;font-size:small;display:inline">When you want to sc=
hedule on the background, you add your new &quot;q&quot; item to the head/t=
ail single linked list.=C2=A0 A double linked list is fine and easier to pr=
ogram, but overkill.<br></div><div class=3D"gmail_default" style=3D"font-fa=
mily:arial,helvetica,sans-serif;font-size:small;display:inline">=C2=A0=C2=
=A0=C2=A0 =E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Oh boy I really don&#39;t know if this is even remotely close. Any hints, a=
s<br>
easy as they may seem to you guys, are really greatly appreciated. I&#39;ve=
<br>
never worked with this stuff.<br></blockquote><div><br><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;di=
splay:inline">=E2=80=8BStart by creating a thread in module load and destro=
ying it in module unload.=C2=A0 You can use statics as the DEV.=C2=A0 You s=
hould use atomics as &quot;thread counters&quot;, so when the thread starts=
, it increments the &quot;running thread count&quot;.=C2=A0 When a thread e=
xits, it decrements the counter.=C2=A0 This way, the module unload routine =
can set the &quot;dev-&gt;shutddown_flag&quot;, do a bunch of up(...) to wa=
ke up the threads, and then wait for the threads to exit by watching the co=
unter.=C2=A0 Throw in some sleeps to keep the loop waiting for exits from k=
illing the box.<br><br></div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif;font-size:small;display:inline">If you do it=
 correctly, you can start a bunch of copies of the worker thread.=C2=A0 If =
you are after a lot of bandwidth or IOPS, this might be helpful.=C2=A0 Othe=
rwise, you can probably get away with just one.=C2=A0 Having just one helpe=
r is nice because you don&#39;t have to set as many locks to protect yourse=
lf from yourself.<br><br></div><div class=3D"gmail_default" style=3D"font-f=
amily:arial,helvetica,sans-serif;font-size:small;display:inline">Once you h=
ave your first live thread, you can build a queue to give it work to do.=C2=
=A0 Once you have work you can give it, you are off to the races.<br>=E2=80=
=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D""><br>
&gt; =E2=80=8BIf you cannot continue because devices are not present or the=
 right size,<br>
&gt; yes you should fail the ctr routine.<br>
<br>
</span>Alright!<br>
<span class=3D""><br>
&gt; If you want to setup /proc or other monitoring stuff, you can use the =
init<br>
&gt; routine, probably plus some statics, to setup &quot;views&quot; into y=
our module.=C2=A0 If<br>
&gt; you want to support multiple instances (and you should), setup a<br>
&gt; /proc/{yourname} directory on the init and then populate it with<br>
&gt; sub-directories every time you create a device.<br>
<br>
</span>Okay, I&#39;ll try to do this (want to make statistics available via=
 procfs<br>
later on), but one construction site at a time for me.<br>
<span class=3D""><br>
&gt;&gt; - Can I determine the size the bio in map() will have already in c=
tr()<br>
&gt;&gt; somehow? Can I assume it will never change if it was once determin=
ed?<br>
&gt;&gt; The reason is that for my example I need to make sure the chunk si=
ze is<br>
&gt;&gt; a integer multiple of the bio size and I would only like to check =
this<br>
&gt;&gt; once (in ctr) and not every time (in map).<br>
&gt;<br>
&gt; =E2=80=8BBlock size will not change.=C2=A0 The size of requests to you=
 is limited by the<br>
&gt; setup of ti-&gt;max_io_len.=C2=A0 If you don&#39;t set this with recen=
t kernels, you<br>
&gt; will only get 4K, which is not all that efficient.=C2=A0 This is actua=
lly part<br>
&gt; of another big topic of &quot;stacked limits&quot;, which someone coul=
d write a book<br>
&gt; on (and I would read it).=E2=80=8B<br>
<br>
</span>So if I would want to do a large I/O operation (say write one megaby=
te<br>
of data to a block device somewhere within my driver) I&#39;d have to make<=
br>
lots of calls to generic_make_request?<br>
<br>
Thank you so much for your help,<br>
Best regards,<br>
Johannes<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature">Doug Dumitru<br>EasyCo LLC<br></div>
</div></div>

--bcaec51b9b634f83480518a8f05e--


--===============4377230157866156217==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4377230157866156217==--
