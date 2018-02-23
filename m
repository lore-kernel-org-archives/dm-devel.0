From: Gigi W <gigitekwork@gmail.com>
Subject: Re: Integrity checking fails with Atmel SHA hw
	accelerator enabled
Date: Fri, 23 Feb 2018 14:25:09 +0200
Message-ID: <CAAm399Tvq7nLs=LUb+u+oob1r37Nsstz6vm-=WGF+wQ+6189UA@mail.gmail.com>
References: <CAAm399SnigNFoHgNL4v4q167K3NheyYHzRp76Lxi9xpu6W0YPw@mail.gmail.com>
	<CAOtvUMdwtUg4dRq6=bcRjvtuJByQPUhJLGrLvF-Dxxt3fc1iJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6353299958936197948=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOtvUMdwtUg4dRq6=bcRjvtuJByQPUhJLGrLvF-Dxxt3fc1iJw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6353299958936197948==
Content-Type: multipart/alternative; boundary="94eb2c0ef36a5070670565e0400e"

--94eb2c0ef36a5070670565e0400e
Content-Type: text/plain; charset="UTF-8"

Thanks for the input!

See below


On Fri, Feb 23, 2018 at 10:53 AM Gilad Ben-Yossef <gilad@benyossef.com>
wrote:

> On Fri, Feb 23, 2018 at 10:30 AM, Gigi W <gigitekwork@gmail.com> wrote:
> > Hi
> >
> > I'm having some trouble using dm-verity for a squashfs root file system
> that
> > seems to be related to the
> > Atmel SHA hw accelerator in the kernel, CONFIG_CRYPTO_DEV_ATMEL_SHA
> >
> > Some info about my setup:
> > * I'm using a board with a SAMA5D4 CPU.
> > * I'm using Yocto rocko for building an image for that device.
> >
> > The idea is that Using the 4.14.14 Kernel, Integrity checking using
> Kernel
> > crypto fails with Atmel SHA hw accelerator enabled in kernel.
> > By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=n`, and using the software
> > sha256 algo, integrity checking works as expected.
> > This is my kernel config [3]
> >
> > Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled, everything
> was
> > ok.
> >
> > This is what triggers the error during verified boot:
> >
> > status=`veritysetup create vroot $root_dev $verity_dev --hash-offset
> > $hashoffset $root_hash`
> >
> >     mount /dev/mapper/vroot /mnt/
> >     mount_ok=`cat /proc/mounts | grep mnt`
> >     if [ -z "$mount_ok" ] ; then
> >         echo "Failed to mount $root_dev on mnt/"
> >     else
> >         echo "Switch rootfs"
> >         exec switch_root -c /dev/console /mnt /sbin/init
> >     fi
> >
> > The mount operation fails:
> >
> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> > EXT4-fs (dm-0): unable to read superblock
> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> > EXT4-fs (dm-0): unable to read superblock
> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> > EXT4-fs (dm-0): unable to read superblock
> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> > SQUASHFS error: squashfs_read_data failed to read block 0x0
> > squashfs: SQUASHFS error: unable to read squashfs_super_block
> > device-mapper: verity: 179:4: metadata block 2 is corrupted
> > FAT-fs (dm-0): unable to read boot sector
> > mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/output error
> > Failed to mount /dev/mmcblk0p4 on mnt/
> > reboot: Restarting system
> > Reboot failed -- System halted
> >
> > Using veritysetup to verify the integrity against the hashes is
> successful,
> > as it's not using the kernel for that ...
> >
> >
> > So it looks like it something changed from 4.8.4 to 4.14.14.
>
> If I am not mistaken the Atmel SHA hw accelerator is an async (read:
> off CPU) crypto accelerator.
>  Up until 4.12 (I think...) DM-Verity did not use async crypto
> accelerators (even if present and have high
> priority). I've changed this is commit d1ac3ff008fb ("dm verity:
> switch to using asynchronous hash crypto API").
>

This would explain some things, like the same speeds while reading from a
verity device, having the *CONFIG_CRYPTO_DEV_ATMEL_SHA* enabled and then
disabled, on the 4.8.4 kernel -> it was always using the sync API.


>
> Is it possible that whatever issue you are seeing has always been
> there and when DM-Verity started using
> async. accelerators it was only exposed?
>

It looks like it.

From my understandings + tests described above, Atmel SHA hw accelerator
works correctly - output hashes are ok, dm-verity with other async crypto
accelerators is working ok,
but dm-verity + Atmel SHA hw accelerator don't play nice together.

I couldn't find anyone else complaining about this.

Best regards.


>
> > Using the 4.14.14 kernel, I removed the patches that were applied on the
> > atmel-sha.c file in the kernel, one by one, until I got the version from
> the
> > 4.8.4
> > Basically I reverted the changes from
> > here:https://git.kernel.org/pub/scm/linux/kernel/git/
> stable/linux-stable.git/log/drivers/crypto/atmel-sha.c?h=v4.14.14
> > until I got this:
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/
> linux-stable.git/log/drivers/crypto/atmel-sha.c?h=v4.8.4
> >
> > It still didn't work. I assumed something there broke the hashing, not
> the
> > case. It was still not working with all those commits reverted.
> >
> > Furthermore, using the Cryptodev-linux module [1], and the sample [2],
> > adapted to use sha256, I tested the output hashes, with
> > CONFIG_CRYPTO_DEV_ATMEL_SHA enabled and then disabled.
> >
> > I got the same results in both cases, hardware and software algorithm.
> So it
> > doesn't look like the SHA hw accelerator is broken.
> >
> >
> > Any help is appreciated !
> >
> > Thanks in advanced and have a nice day.
> >
> >
> > [1] http://cryptodev-linux.org/documentation.html
> > [2] https://github.com/nmav/cryptodev-linux/blob/master/examples/sha.c
> > [3]
> > https://gist.githubusercontent.com/gmircea/
> 6e1cc029ef5ed7a16b0fedb8b9524f66/raw/eece8a8faadd2de9373e150ef1daf3
> cf25f4135c/.config
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> "If you take a class in large-scale robotics, can you end up in a
> situation where the homework eats your dog?"
>  -- Jean-Baptiste Queru
>

--94eb2c0ef36a5070670565e0400e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thanks for the input!<br></div><br>See below <br><br>=
<br><div class=3D"gmail_quote"><div dir=3D"ltr">On Fri, Feb 23, 2018 at 10:=
53 AM Gilad Ben-Yossef &lt;<a href=3D"mailto:gilad@benyossef.com" target=3D=
"_blank">gilad@benyossef.com</a>&gt; wrote:<br></div><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">On Fri, Feb 23, 2018 at 10:30 AM, Gigi W &lt;<a href=3D"mailto:gig=
itekwork@gmail.com" target=3D"_blank">gigitekwork@gmail.com</a>&gt; wrote:<=
br>
&gt; Hi<br>
&gt;<br>
&gt; I&#39;m having some trouble using dm-verity for a squashfs root file s=
ystem that<br>
&gt; seems to be related to the<br>
&gt; Atmel SHA hw accelerator in the kernel, CONFIG_CRYPTO_DEV_ATMEL_SHA<br=
>
&gt;<br>
&gt; Some info about my setup:<br>
&gt; * I&#39;m using a board with a SAMA5D4 CPU.<br>
&gt; * I&#39;m using Yocto rocko for building an image for that device.<br>
&gt;<br>
&gt; The idea is that Using the 4.14.14 Kernel, Integrity checking using Ke=
rnel<br>
&gt; crypto fails with Atmel SHA hw accelerator enabled in kernel.<br>
&gt; By disabling it, `CONFIG_CRYPTO_DEV_ATMEL_SHA=3D<wbr>n`, and using the=
 software<br>
&gt; sha256 algo, integrity checking works as expected.<br>
&gt; This is my kernel config [3]<br>
&gt;<br>
&gt; Using the 4.8.4 Kernel and Atmel SHA hw accelerator enabled, everythin=
g was<br>
&gt; ok.<br>
&gt;<br>
&gt; This is what triggers the error during verified boot:<br>
&gt;<br>
&gt; status=3D`veritysetup create vroot $root_dev $verity_dev --hash-offset=
<br>
&gt; $hashoffset $root_hash`<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0mount /dev/mapper/vroot /mnt/<br>
&gt;=C2=A0 =C2=A0 =C2=A0mount_ok=3D`cat /proc/mounts | grep mnt`<br>
&gt;=C2=A0 =C2=A0 =C2=A0if [ -z &quot;$mount_ok&quot; ] ; then<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;Failed to mount $root_dev =
on mnt/&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0else<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;Switch rootfs&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0exec switch_root -c /dev/console /mnt=
 /sbin/init<br>
&gt;=C2=A0 =C2=A0 =C2=A0fi<br>
&gt;<br>
&gt; The mount operation fails:<br>
&gt;<br>
&gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
&gt; EXT4-fs (dm-0): unable to read superblock<br>
&gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
&gt; EXT4-fs (dm-0): unable to read superblock<br>
&gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
&gt; EXT4-fs (dm-0): unable to read superblock<br>
&gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
&gt; SQUASHFS error: squashfs_read_data failed to read block 0x0<br>
&gt; squashfs: SQUASHFS error: unable to read squashfs_super_block<br>
&gt; device-mapper: verity: 179:4: metadata block 2 is corrupted<br>
&gt; FAT-fs (dm-0): unable to read boot sector<br>
&gt; mount: mounting /dev/mapper/vroot on /mnt/ failed: Input/output error<=
br>
&gt; Failed to mount /dev/mmcblk0p4 on mnt/<br>
&gt; reboot: Restarting system<br>
&gt; Reboot failed -- System halted<br>
&gt;<br>
&gt; Using veritysetup to verify the integrity against the hashes is succes=
sful,<br>
&gt; as it&#39;s not using the kernel for that ...<br>
&gt;<br>
&gt;<br>
&gt; So it looks like it something changed from 4.8.4 to 4.14.14.<br>
<br>
If I am not mistaken the Atmel SHA hw accelerator is an async (read:<br>
off CPU) crypto accelerator.<br>
=C2=A0Up until 4.12 (I think...) DM-Verity did not use async crypto<br>
accelerators (even if present and have high<br>
priority). I&#39;ve changed this is commit d1ac3ff008fb (&quot;dm verity:<b=
r>
switch to using asynchronous hash crypto API&quot;).<br></blockquote><div><=
br>This would explain some things, like the same speeds while reading from =
a verity device, having the <b>CONFIG_CRYPTO_DEV_ATMEL_SHA</b> enabled and =
then disabled, on the 4.8.4 kernel -&gt; it was always using the sync API.<=
br>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex">
<br>
Is it possible that whatever issue you are seeing has always been<br>
there and when DM-Verity started using<br>
async. accelerators it was only exposed?<br></blockquote><div><br></div><di=
v>It looks like it.<br><br>From my understandings + tests described above, =
Atmel SHA hw accelerator works correctly - output hashes are ok, dm-verity =
with other async crypto accelerators is working ok, <br>but dm-verity + Atm=
el SHA hw accelerator don&#39;t play nice together.</div><br></div><div cla=
ss=3D"gmail_quote">I couldn&#39;t find anyone else complaining about this.<=
br><br></div><div class=3D"gmail_quote">Best regards.<br></div><div class=
=3D"gmail_quote"><br></div><div class=3D"gmail_quote"><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">
<br>
<br>
&gt; Using the 4.14.14 kernel, I removed the patches that were applied on t=
he<br>
&gt; atmel-sha.c file in the kernel, one by one, until I got the version fr=
om the<br>
&gt; 4.8.4<br>
&gt; Basically I reverted the changes from<br>
&gt; here:<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/stable=
/linux-stable.git/log/drivers/crypto/atmel-sha.c?h=3Dv4.14.14" rel=3D"noref=
errer" target=3D"_blank">https://git.kernel.org/<wbr>pub/scm/linux/kernel/g=
it/<wbr>stable/linux-stable.git/log/<wbr>drivers/crypto/atmel-sha.c?h=3D<wb=
r>v4.14.14</a><br>
&gt; until I got this:<br>
&gt; <a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable.git/log/drivers/crypto/atmel-sha.c?h=3Dv4.8.4" rel=3D"noreferrer" =
target=3D"_blank">https://git.kernel.org/pub/<wbr>scm/linux/kernel/git/stab=
le/<wbr>linux-stable.git/log/drivers/<wbr>crypto/atmel-sha.c?h=3Dv4.8.4</a>=
<br>
&gt;<br>
&gt; It still didn&#39;t work. I assumed something there broke the hashing,=
 not the<br>
&gt; case. It was still not working with all those commits reverted.<br>
&gt;<br>
&gt; Furthermore, using the Cryptodev-linux module [1], and the sample [2],=
<br>
&gt; adapted to use sha256, I tested the output hashes, with<br>
&gt; CONFIG_CRYPTO_DEV_ATMEL_SHA enabled and then disabled.<br>
&gt;<br>
&gt; I got the same results in both cases, hardware and software algorithm.=
 So it<br>
&gt; doesn&#39;t look like the SHA hw accelerator is broken.<br>
&gt;<br>
&gt;<br>
&gt; Any help is appreciated !<br>
&gt;<br>
&gt; Thanks in advanced and have a nice day.<br>
&gt;<br>
&gt;<br>
&gt; [1] <a href=3D"http://cryptodev-linux.org/documentation.html" rel=3D"n=
oreferrer" target=3D"_blank">http://cryptodev-linux.org/<wbr>documentation.=
html</a><br>
&gt; [2] <a href=3D"https://github.com/nmav/cryptodev-linux/blob/master/exa=
mples/sha.c" rel=3D"noreferrer" target=3D"_blank">https://github.com/nmav/<=
wbr>cryptodev-linux/blob/master/<wbr>examples/sha.c</a><br>
&gt; [3]<br>
&gt; <a href=3D"https://gist.githubusercontent.com/gmircea/6e1cc029ef5ed7a1=
6b0fedb8b9524f66/raw/eece8a8faadd2de9373e150ef1daf3cf25f4135c/.config" rel=
=3D"noreferrer" target=3D"_blank">https://gist.<wbr>githubusercontent.com/g=
mircea/<wbr>6e1cc029ef5ed7a16b0fedb8b9524f<wbr>66/raw/<wbr>eece8a8faadd2de9=
373e150ef1daf3<wbr>cf25f4135c/.config</a><br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redh=
at.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm=
-devel</a><br>
<br>
<br>
<br>
--<br>
Gilad Ben-Yossef<br>
Chief Coffee Drinker<br>
<br>
&quot;If you take a class in large-scale robotics, can you end up in a<br>
situation where the homework eats your dog?&quot;<br>
=C2=A0-- Jean-Baptiste Queru<br>
</blockquote></div></div>

--94eb2c0ef36a5070670565e0400e--


--===============6353299958936197948==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6353299958936197948==--
