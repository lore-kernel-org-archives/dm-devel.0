From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: limits->max_sectors is getting set to 0,
 why/where? [was: Re: dm: kernel oops by divide error on v4.16+]
Date: Mon, 09 Apr 2018 22:11:55 +0000
Message-ID: <CA+55aFxfxZLOGqNPwk2BaPvysXWx7UhfObWh8HhjwXZvzVORUQ@mail.gmail.com>
References: <20180408040005.GA19128@ming.t460p>
	<20180409155120.GA10990@redhat.com>
	<20180409183836.GA11256@redhat.com>
	<db4499d6-05b8-73f3-76d0-a91af91430b0@kernel.dk>
	<70f1d349-f091-19a2-9ec6-978ac1e7dda0@kernel.dk>
	<78732cb7-3666-e1b0-e6d3-2a3409a0d4ca@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3395880416313488056=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <78732cb7-3666-e1b0-e6d3-2a3409a0d4ca@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Chris Mason <clm@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============3395880416313488056==
Content-Type: multipart/alternative; boundary="00000000000035df8d056971b20f"

--00000000000035df8d056971b20f
Content-Type: text/plain; charset="UTF-8"

On mobile, sorry for html crud and top posting, but here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e9092d0d97961146655ce51f43850907d95f68c3

 Should fix it.

     Linus




On Mon, Apr 9, 2018, 14:56 Jens Axboe <axboe@kernel.dk> wrote:

> On 4/9/18 3:26 PM, Jens Axboe wrote:
> > On 4/9/18 1:32 PM, Jens Axboe wrote:
> >> On 4/9/18 12:38 PM, Mike Snitzer wrote:
> >>> On Mon, Apr 09 2018 at 11:51am -0400,
> >>> Mike Snitzer <snitzer@redhat.com> wrote:
> >>>
> >>>> On Sun, Apr 08 2018 at 12:00am -0400,
> >>>> Ming Lei <ming.lei@redhat.com> wrote:
> >>>>
> >>>>> Hi,
> >>>>>
> >>>>> The following kernel oops(divide error) is triggered when running
> >>>>> xfstest(generic/347) on ext4.
> >>>>>
> >>>>> [  442.632954] run fstests generic/347 at 2018-04-07 18:06:44
> >>>>> [  443.839480] divide error: 0000 [#1] PREEMPT SMP PTI
> >>>>> [  443.840201] Dumping ftrace buffer:
> >>>>> [  443.840692]    (ftrace buffer empty)
> >>> ...
> >>>>> [  443.845756] CPU: 1 PID: 29607 Comm: dmsetup Not tainted
> 4.16.0_f605ba97fb80_master+ #1
> >>>>> [  443.846968] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 1.10.2-2.fc27 04/01/2014
> >>>>> [  443.848147] RIP: 0010:pool_io_hints+0x77/0x153 [dm_thin_pool]
> >>>
> >>> ...
> >>>
> >>>> I was able to reproduce (in my case RIP was pool_io_hints+0x45)
> >>>>
> >>>> Which on my kernel, is:
> >>>>
> >>>> crash> dis -l pool_io_hints+0x45
> >>>> /root/snitm/git/linux/drivers/md/dm-thin.c: 2748
> >>>> 0xffffffffc0765165 <pool_io_hints+69>:  div    %rdi
> >>>>
> >>>> Which is drivers/md/dm-thin.c:is_factor()'s return
> >>>> !sector_div(block_size, n);
> >>>>
> >>>> SO looking at pool_io_hints() it would seem limits->max_sectors is 0
> for
> >>>> this xfstests device... why would that be!?
> >>>>
> >>>> Clearly pool_io_hints() could stand to be more defensive with a
> >>>> !limits->max_sectors negative check but is it ever really valid for
> >>>> max_sectors to be 0?
> >>>>
> >>>> Pretty sure the ultimate bug is outside DM (but not seeing an obvious
> >>>> place where block core would set max_sectors to 0, all blk-settings.c
> >>>> uses min_not_zero(), etc).
> >>>
> >>> I successfully ran this test against the linux-dm.git
> >>> "for-4.17/dm-changes" tag that Linus merged after the block changes:
> >>>  git://
> git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> tags/for-4.17/dm-changes
> >>>
> >>> # ./check tests/generic/347
> >>> FSTYP         -- ext4
> >>> PLATFORM      -- Linux/x86_64 thegoat 4.16.0-rc5.snitm
> >>> MKFS_OPTIONS  -- /dev/mapper/test-xfstests_scratch
> >>> MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-xfstests_scratch
> /scratch
> >>>
> >>> generic/347      65s
> >>> Ran: generic/347
> >>> Passed all 1 tests
> >>>
> >>> SO this would seem to implicate some regression in the 4.17 block layer
> >>> changes.
> >>
> >> No immediate ideas come to mind, we didn't have a lot of changes and I
> >> don't see anything that looks problematic. Maybe you can try and
> >> bisect it and see what you come up with?
> >
> > I ran it, problematic commit is:
> >
> > commit 3c8ba0d61d04ced9f8d9ff93977995a9e4e96e91
> > Author: Kees Cook <keescook@chromium.org>
> > Date:   Fri Mar 30 18:52:36 2018 -0700
> >
> >     kernel.h: Retain constant expression output for max()/min()
> >
>
> The fun continues. Thinking I'd try a userspace repro and thinking it
> would be difficult to reproduce, try the attached min.c that just copies
> all the bits from include/linux/kernel.h
>
> axboe@x1:~ $ gcc -Wall -O2 -o min min.c
> axboe@x1:~ $ ./min 128 256
> min_not_zero(128, 256) = 0
>
> --
> Jens Axboe
>
>

--00000000000035df8d056971b20f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>On mobile, sorry for html crud and top posting, but =
here:<div dir=3D"auto"><br><div dir=3D"auto"><a href=3D"https://git.kernel.=
org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3De9092d0d979611=
46655ce51f43850907d95f68c3">https://git.kernel.org/pub/scm/linux/kernel/git=
/torvalds/linux.git/commit/?id=3De9092d0d97961146655ce51f43850907d95f68c3</=
a><br></div><div dir=3D"auto"><br></div><div dir=3D"auto">=C2=A0Should fix =
it.</div><div dir=3D"auto"><br></div><div dir=3D"auto">=C2=A0 =C2=A0 =C2=A0=
Linus</div><div dir=3D"auto"><br></div><div dir=3D"auto"><br></div></div><b=
r><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Mon, Apr 9, 2018, 14:5=
6 Jens Axboe &lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt;=
 wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">On 4/9/18 3:26 PM, Jens Axb=
oe wrote:<br>
&gt; On 4/9/18 1:32 PM, Jens Axboe wrote:<br>
&gt;&gt; On 4/9/18 12:38 PM, Mike Snitzer wrote:<br>
&gt;&gt;&gt; On Mon, Apr 09 2018 at 11:51am -0400,<br>
&gt;&gt;&gt; Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com" target=
=3D"_blank" rel=3D"noreferrer">snitzer@redhat.com</a>&gt; wrote:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; On Sun, Apr 08 2018 at 12:00am -0400,<br>
&gt;&gt;&gt;&gt; Ming Lei &lt;<a href=3D"mailto:ming.lei@redhat.com" target=
=3D"_blank" rel=3D"noreferrer">ming.lei@redhat.com</a>&gt; wrote:<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Hi,<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; The following kernel oops(divide error) is triggered w=
hen running<br>
&gt;&gt;&gt;&gt;&gt; xfstest(generic/347) on ext4.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; [=C2=A0 442.632954] run fstests generic/347 at 2018-04=
-07 18:06:44<br>
&gt;&gt;&gt;&gt;&gt; [=C2=A0 443.839480] divide error: 0000 [#1] PREEMPT SM=
P PTI<br>
&gt;&gt;&gt;&gt;&gt; [=C2=A0 443.840201] Dumping ftrace buffer:<br>
&gt;&gt;&gt;&gt;&gt; [=C2=A0 443.840692]=C2=A0 =C2=A0 (ftrace buffer empty)=
<br>
&gt;&gt;&gt; ...<br>
&gt;&gt;&gt;&gt;&gt; [=C2=A0 443.845756] CPU: 1 PID: 29607 Comm: dmsetup No=
t tainted 4.16.0_f605ba97fb80_master+ #1<br>
&gt;&gt;&gt;&gt;&gt; [=C2=A0 443.846968] Hardware name: QEMU Standard PC (Q=
35 + ICH9, 2009), BIOS 1.10.2-2.fc27 04/01/2014<br>
&gt;&gt;&gt;&gt;&gt; [=C2=A0 443.848147] RIP: 0010:pool_io_hints+0x77/0x153=
 [dm_thin_pool]<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; ...<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; I was able to reproduce (in my case RIP was pool_io_hints+=
0x45)<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Which on my kernel, is:<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; crash&gt; dis -l pool_io_hints+0x45<br>
&gt;&gt;&gt;&gt; /root/snitm/git/linux/drivers/md/dm-thin.c: 2748<br>
&gt;&gt;&gt;&gt; 0xffffffffc0765165 &lt;pool_io_hints+69&gt;:=C2=A0 div=C2=
=A0 =C2=A0 %rdi<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Which is drivers/md/dm-thin.c:is_factor()&#39;s return<br>
&gt;&gt;&gt;&gt; !sector_div(block_size, n);<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; SO looking at pool_io_hints() it would seem limits-&gt;max=
_sectors is 0 for<br>
&gt;&gt;&gt;&gt; this xfstests device... why would that be!?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Clearly pool_io_hints() could stand to be more defensive w=
ith a<br>
&gt;&gt;&gt;&gt; !limits-&gt;max_sectors negative check but is it ever real=
ly valid for<br>
&gt;&gt;&gt;&gt; max_sectors to be 0?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Pretty sure the ultimate bug is outside DM (but not seeing=
 an obvious<br>
&gt;&gt;&gt;&gt; place where block core would set max_sectors to 0, all blk=
-settings.c<br>
&gt;&gt;&gt;&gt; uses min_not_zero(), etc).<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I successfully ran this test against the linux-dm.git<br>
&gt;&gt;&gt; &quot;for-4.17/dm-changes&quot; tag that Linus merged after th=
e block changes:<br>
&gt;&gt;&gt;=C2=A0 git://<a href=3D"http://git.kernel.org/pub/scm/linux/ker=
nel/git/device-mapper/linux-dm.git" rel=3D"noreferrer noreferrer" target=3D=
"_blank">git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git=
</a> tags/for-4.17/dm-changes<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; # ./check tests/generic/347<br>
&gt;&gt;&gt; FSTYP=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-- ext4<br>
&gt;&gt;&gt; PLATFORM=C2=A0 =C2=A0 =C2=A0 -- Linux/x86_64 thegoat 4.16.0-rc=
5.snitm<br>
&gt;&gt;&gt; MKFS_OPTIONS=C2=A0 -- /dev/mapper/test-xfstests_scratch<br>
&gt;&gt;&gt; MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-xfstests_s=
cratch /scratch<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; generic/347=C2=A0 =C2=A0 =C2=A0 65s<br>
&gt;&gt;&gt; Ran: generic/347<br>
&gt;&gt;&gt; Passed all 1 tests<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; SO this would seem to implicate some regression in the 4.17 bl=
ock layer<br>
&gt;&gt;&gt; changes.<br>
&gt;&gt;<br>
&gt;&gt; No immediate ideas come to mind, we didn&#39;t have a lot of chang=
es and I<br>
&gt;&gt; don&#39;t see anything that looks problematic. Maybe you can try a=
nd<br>
&gt;&gt; bisect it and see what you come up with?<br>
&gt;<br>
&gt; I ran it, problematic commit is:<br>
&gt;<br>
&gt; commit 3c8ba0d61d04ced9f8d9ff93977995a9e4e96e91<br>
&gt; Author: Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org" target=
=3D"_blank" rel=3D"noreferrer">keescook@chromium.org</a>&gt;<br>
&gt; Date:=C2=A0 =C2=A0Fri Mar 30 18:52:36 2018 -0700<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0kernel.h: Retain constant expression output for max=
()/min()<br>
&gt;<br>
<br>
The fun continues. Thinking I&#39;d try a userspace repro and thinking it<b=
r>
would be difficult to reproduce, try the attached min.c that just copies<br=
>
all the bits from include/linux/kernel.h<br>
<br>
axboe@x1:~ $ gcc -Wall -O2 -o min min.c<br>
axboe@x1:~ $ ./min 128 256<br>
min_not_zero(128, 256) =3D 0<br>
<br>
--<br>
Jens Axboe<br>
<br>
</blockquote></div></div></div>

--00000000000035df8d056971b20f--


--===============3395880416313488056==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3395880416313488056==--
