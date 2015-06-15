From: Doug Dumitru <doug@easyco.com>
Subject: Re: Newbie device mapper questions
Date: Mon, 15 Jun 2015 12:52:57 -0700
Message-ID: <CAFx4rwQ0ganzZn5FjQZTVtk1DK1Qr1pmMCTxRCwxd793+-anHg@mail.gmail.com>
References: <557F1BFA.2080504@gmx.de>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6899733958648592556=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <557F1BFA.2080504@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6899733958648592556==
Content-Type: multipart/alternative; boundary=047d7b414088eb1857051893cd80

--047d7b414088eb1857051893cd80
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2015 at 11:39 AM, Johannes Bauer <dfnsonfsduifb@gmx.de>
wrote:

> Hi list,
>
> so I've had this idea stuck in my head for a while and am finally not
> intimidated enough my the dm API to actually give it a shot and play
> around. I'm just getting used to the DM internals so please apologize if
> I sound like an idiot, I'm just new to the DM.
>
> Something that I would like to implement first is a device mapper target
> that takes three block devices as input: Two equally sized devices (src1
> and src2) and a separate metadata device (meta). I want to map chunks of
> the src devices to bits of a bitmap in the meta device. If the bit is
> set in the meta device decides whether src1 and src2 is returned.
>
> Sounds pretty easy and I also got surprisingly far with my little kernel
> module. I've so far implemented ctr, dtr, map and status.
>

=E2=80=8BCongratulations, you are actually a long way there.=E2=80=8B


>
> In map() I actually do the switching operation. I've looked at how
> dm-linear implements this and copied a lot of information. Currently I
> do static switching (fixed block size, ingoring the meta device). Here
> are my questions:
>
> - How can I read within the kernel from the block device lc->meta->bdev?
> If I call "read_dev_sector" from "map" this results in a deadlock, I'm
> guessing this is now how it's supposed to work. The bcache module must
> perform something similar (because it also reads and writes metadata,
> only much more complex), but I'll be damned but couldn't find out where
> the actual reading/writing is performed in the code. What are things
> that I should look at?
>

=E2=80=8BYou have to allocate a bio, populate it, allocate pages for buffer=
,
populate the bvec, and call make_request (or generic make request).  You
will get the completion from the bio on the bottom half of the interrupt
handler, so how much work you can do there is debatable.  You cannot start
an new IO from there, which you need to.  You will probably want to start a
helper thread and have the completion routine schedule itself onto your
thread.  Once you are back on your thread, you can do just about anything.

Because you need to do IO, you will not be able to do a simple bio "bounce
redirect".  You will need to do the IO youself (ie, call another make
request), but you can use the callers bvec for this, so there is no data
copy required.  Once the request completes, you can then fin the caller.
=E2=80=8B


>
> - Is the ctr callback the appropriate place to fail if a logical error
> occurs? For example, if two src devices of dissimilar size are passed to
> dmsetup?
>

=E2=80=8BIf you cannot continue because devices are not present or the righ=
t size,
yes you should fail the ctr routine.

If you want to setup /proc or other monitoring stuff, you can use the init
routine, probably plus some statics, to setup "views" into your module.  If
you want to support multiple instances (and you should), setup a
/proc/{yourname} directory on the init and then populate it with
sub-directories every time you create a device.
=E2=80=8B


>
> - Is i_size_read(lc->src1dev->bdev->bd_inode) the correct way of
> determining the size of the underlying block device? If not, which
> function is?
>

=E2=80=8B... I am happy to leave out answers that I don't know ...=E2=80=8B


>
> - Can I safely assume the logical sector size is fixed to be 512 bytes
> in all cases?
>

=E2=80=8BProbably not, but maybe.  You are in control of the hardware.=E2=
=80=8B


>
> - In the dm-linear example, bio_sectors(bio) is checked. This gives, if
> I understand it correctly, the size in sectors of the BIO (usually this
> is 8). What I don't understand is in which cases this can become zero
> (dm-linear has a if that checks for bio_sectors(bio) !=3D 0).
>

=E2=80=8B.. just a sanity check.  If you get a call of zero size, it means
something else is broken.=E2=80=8B


>
> - Can I determine the size the bio in map() will have already in ctr()
> somehow? Can I assume it will never change if it was once determined?
> The reason is that for my example I need to make sure the chunk size is
> a integer multiple of the bio size and I would only like to check this
> once (in ctr) and not every time (in map).
>

=E2=80=8BBlock size will not change.  The size of requests to you is limite=
d by the
setup of ti->max_io_len.  If you don't set this with recent kernels, you
will only get 4K, which is not all that efficient.  This is actually part
of another big topic of "stacked limits", which someone could write a book
on (and I would read it).=E2=80=8B


>
> Thank you very much for helping out a complete newbie :-)
> Best regards,
> Johannes
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Doug Dumitru
EasyCo LLC

--047d7b414088eb1857051893cd80
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small"><br></div><div class=3D"gmail_extra"><b=
r><div class=3D"gmail_quote">On Mon, Jun 15, 2015 at 11:39 AM, Johannes Bau=
er <span dir=3D"ltr">&lt;<a href=3D"mailto:dfnsonfsduifb@gmx.de" target=3D"=
_blank">dfnsonfsduifb@gmx.de</a>&gt;</span> wrote:<br><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">Hi list,<br>
<br>
so I&#39;ve had this idea stuck in my head for a while and am finally not<b=
r>
intimidated enough my the dm API to actually give it a shot and play<br>
around. I&#39;m just getting used to the DM internals so please apologize i=
f<br>
I sound like an idiot, I&#39;m just new to the DM.<br>
<br>
Something that I would like to implement first is a device mapper target<br=
>
that takes three block devices as input: Two equally sized devices (src1<br=
>
and src2) and a separate metadata device (meta). I want to map chunks of<br=
>
the src devices to bits of a bitmap in the meta device. If the bit is<br>
set in the meta device decides whether src1 and src2 is returned.<br>
<br>
Sounds pretty easy and I also got surprisingly far with my little kernel<br=
>
module. I&#39;ve so far implemented ctr, dtr, map and status.<br></blockquo=
te><div><br><div class=3D"gmail_default" style=3D"font-family:arial,helveti=
ca,sans-serif;font-size:small;display:inline">=E2=80=8BCongratulations, you=
 are actually a long way there.=E2=80=8B</div>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
<br>
In map() I actually do the switching operation. I&#39;ve looked at how<br>
dm-linear implements this and copied a lot of information. Currently I<br>
do static switching (fixed block size, ingoring the meta device). Here<br>
are my questions:<br>
<br>
- How can I read within the kernel from the block device lc-&gt;meta-&gt;bd=
ev?<br>
If I call &quot;read_dev_sector&quot; from &quot;map&quot; this results in =
a deadlock, I&#39;m<br>
guessing this is now how it&#39;s supposed to work. The bcache module must<=
br>
perform something similar (because it also reads and writes metadata,<br>
only much more complex), but I&#39;ll be damned but couldn&#39;t find out w=
here<br>
the actual reading/writing is performed in the code. What are things<br>
that I should look at?<br></blockquote><div><br><div class=3D"gmail_default=
" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:i=
nline">=E2=80=8BYou have to allocate a bio, populate it, allocate pages for=
 buffer, populate the bvec, and call make_request (or generic make request)=
.=C2=A0 You will get the completion from the bio on the bottom half of the =
interrupt handler, so how much work you can do there is debatable.=C2=A0 Yo=
u cannot start an new IO from there, which you need to.=C2=A0 You will prob=
ably want to start a helper thread and have the completion routine schedule=
 itself onto your thread.=C2=A0 Once you are back on your thread, you can d=
o just about anything.<br><br></div><div class=3D"gmail_default" style=3D"f=
ont-family:arial,helvetica,sans-serif;font-size:small;display:inline">Becau=
se you need to do IO, you will not be able to do a simple bio &quot;bounce =
redirect&quot;.=C2=A0 You will need to do the IO youself (ie, call another =
make request), but you can use the callers bvec for this, so there is no da=
ta copy required.=C2=A0 Once the request completes, you can then fin the ca=
ller.<br>=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
- Is the ctr callback the appropriate place to fail if a logical error<br>
occurs? For example, if two src devices of dissimilar size are passed to<br=
>
dmsetup?<br></blockquote><div><br><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif;font-size:small;display:inline">=E2=80=
=8BIf you cannot continue because devices are not present or the right size=
, yes you should fail the ctr routine.<br><br></div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small;displ=
ay:inline">If you want to setup /proc or other monitoring stuff, you can us=
e the init routine, probably plus some statics, to setup &quot;views&quot; =
into your module.=C2=A0 If you want to support multiple instances (and you =
should), setup a /proc/{yourname} directory on the init and then populate i=
t with sub-directories every time you create a device.<br>=E2=80=8B</div>=
=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex">
<br>
- Is i_size_read(lc-&gt;src1dev-&gt;bdev-&gt;bd_inode) the correct way of<b=
r>
determining the size of the underlying block device? If not, which<br>
function is?<br></blockquote><div><br><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif;font-size:small;display:inline">=E2=
=80=8B... I am happy to leave out answers that I don&#39;t know ...=E2=80=
=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
- Can I safely assume the logical sector size is fixed to be 512 bytes<br>
in all cases?<br></blockquote><div><br><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif;font-size:small;display:inline">=
=E2=80=8BProbably not, but maybe.=C2=A0 You are in control of the hardware.=
=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
- In the dm-linear example, bio_sectors(bio) is checked. This gives, if<br>
I understand it correctly, the size in sectors of the BIO (usually this<br>
is 8). What I don&#39;t understand is in which cases this can become zero<b=
r>
(dm-linear has a if that checks for bio_sectors(bio) !=3D 0).<br></blockquo=
te><div><br><div class=3D"gmail_default" style=3D"font-family:arial,helveti=
ca,sans-serif;font-size:small;display:inline">=E2=80=8B.. just a sanity che=
ck.=C2=A0 If you get a call of zero size, it means something else is broken=
.=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
- Can I determine the size the bio in map() will have already in ctr()<br>
somehow? Can I assume it will never change if it was once determined?<br>
The reason is that for my example I need to make sure the chunk size is<br>
a integer multiple of the bio size and I would only like to check this<br>
once (in ctr) and not every time (in map).<br></blockquote><div><br><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-=
size:small;display:inline">=E2=80=8BBlock size will not change.=C2=A0 The s=
ize of requests to you is limited by the setup of ti-&gt;max_io_len.=C2=A0 =
If you don&#39;t set this with recent kernels, you will only get 4K, which =
is not all that efficient.=C2=A0 This is actually part of another big topic=
 of &quot;stacked limits&quot;, which someone could write a book on (and I =
would read it).=E2=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Thank you very much for helping out a complete newbie :-)<br>
Best regards,<br>
Johannes<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature">Doug Dumitru<br>EasyCo LLC<br></div>
</div></div>

--047d7b414088eb1857051893cd80--


--===============6899733958648592556==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6899733958648592556==--
