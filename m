From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Fwd: multipath-tools: incompatibility with systemd (or
	udev) >= 213
Date: Thu, 30 Oct 2014 17:33:12 +0100
Message-ID: <CABr-Gnc+u_gf0F3OpSLunNOhPKK=xH1ijnBGkEQ90QAG0mVFLQ@mail.gmail.com>
References: <545252D0.9040905@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2878148002408341951=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <545252D0.9040905@gmail.com>
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

--===============2878148002408341951==
Content-Type: multipart/alternative; boundary=001a11c3f5d4b764d10506a66f85

--001a11c3f5d4b764d10506a66f85
Content-Type: text/plain; charset=UTF-8

Alasdair,

did lvm2 also need to workaround this bad inter-flocking behaviour with
systemd/udev ?
If so, can you share advice on a possible fix ?

FYI, multipathd acquires non-blocking and exclusive locks on each multipath
path before creating the multipath dm map, and releases the locks
immediately after.

Best regards,
Christophe Varoqui

---------- Forwarded message ----------
From: Alexander E. Patrakov <patrakov@gmail.com>
Date: Thu, Oct 30, 2014 at 4:01 PM
Subject: multipath-tools: incompatibility with systemd (or udev) >= 213
To: christophe.varoqui@opensvc.com


Hello.

Some time ago, I have complained to the systemd-devel that my computer
(which, at that time, had multipath-tools installed needlessly) boots
unreliably:

http://lists.freedesktop.org/archives/systemd-devel/2014-
September/022812.html

Further investigation of this issue:

http://lists.freedesktop.org/archives/systemd-devel/2014-October/024572.html

I have CC:ed dm-devel (https://www.redhat.com/archives/dm-devel/2014-
October/msg00197.html) when I found the root cause of the unreliable boot,
but so far received no reaction. Hence this poke. The bug is quite
critical, because mere installation of your package and regenerating the
dracut-based initramfs must not lead to unbootable system, but it does.

Basically, the trouble maker is multipathd. As a part of its operation, it
locks various block devices (including /dev/sda) using the flock system
call. Such locking is incompatible with udevd from systemd >= 213, because
systemd-udevd locks the device itself for rule processing, and does not
process rules if the device is already locked by someone else. Arguably, it
is a bug in systemd that it does not retry later, but who am I to say so?
Still, lack of rule processing means that symlinks in /dev/disk/by-*
pointing to the partitions are not created, and thus the root device is
never found.

Please either persuade systemd maintainers to stop locking block devices
because this API is already used for a different purpose, or persuade them
to retry rule processing (they can probably do so when they detect via
inotify or similar means that the device has been closed), or stop locking
block devices in multipathd (i.e. lock something else like zero-length
files in /run/lock).

By the way, I suspect that this lock contention also has impact on
multipathd itself, potentially causing it to disregard some paths because
their block devices were locked by systemd-udevd when multipathd attempted
to look at them. I am not an expert here, because I don't have any hardware
that needs multipath.

-- 
Alexander E. Patrakov

--001a11c3f5d4b764d10506a66f85
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Alasdair,<div><br></div><div>did lvm2 also need to workaro=
und this bad inter-flocking behaviour with systemd/udev ?</div><div>If so, =
can you share advice on a possible fix ?</div><div><br></div><div>FYI, mult=
ipathd acquires non-blocking and exclusive locks on each multipath path bef=
ore creating the multipath dm map, and releases the locks immediately after=
.</div><div><br></div><div>Best regards,</div><div>Christophe Varoqui</div>=
<div><br><div class=3D"gmail_quote">---------- Forwarded message ----------=
<br>From: <b class=3D"gmail_sendername">Alexander E. Patrakov</b> <span dir=
=3D"ltr">&lt;<a href=3D"mailto:patrakov@gmail.com">patrakov@gmail.com</a>&g=
t;</span><br>Date: Thu, Oct 30, 2014 at 4:01 PM<br>Subject: multipath-tools=
: incompatibility with systemd (or udev) &gt;=3D 213<br>To: <a href=3D"mail=
to:christophe.varoqui@opensvc.com">christophe.varoqui@opensvc.com</a><br><b=
r><br>Hello.<br>
<br>
Some time ago, I have complained to the systemd-devel that my computer (whi=
ch, at that time, had multipath-tools installed needlessly) boots unreliabl=
y:<br>
<br>
<a href=3D"http://lists.freedesktop.org/archives/systemd-devel/2014-Septemb=
er/022812.html" target=3D"_blank">http://lists.freedesktop.org/<u></u>archi=
ves/systemd-devel/2014-<u></u>September/022812.html</a><br>
<br>
Further investigation of this issue:<br>
<br>
<a href=3D"http://lists.freedesktop.org/archives/systemd-devel/2014-October=
/024572.html" target=3D"_blank">http://lists.freedesktop.org/<u></u>archive=
s/systemd-devel/2014-<u></u>October/024572.html</a><br>
<br>
I have CC:ed dm-devel (<a href=3D"https://www.redhat.com/archives/dm-devel/=
2014-October/msg00197.html" target=3D"_blank">https://www.redhat.com/<u></u=
>archives/dm-devel/2014-<u></u>October/msg00197.html</a>) when I found the =
root cause of the unreliable boot, but so far received no reaction. Hence t=
his poke. The bug is quite critical, because mere installation of your pack=
age and regenerating the dracut-based initramfs must not lead to unbootable=
 system, but it does.<br>
<br>
Basically, the trouble maker is multipathd. As a part of its operation, it =
locks various block devices (including /dev/sda) using the flock system cal=
l. Such locking is incompatible with udevd from systemd &gt;=3D 213, becaus=
e systemd-udevd locks the device itself for rule processing, and does not p=
rocess rules if the device is already locked by someone else. Arguably, it =
is a bug in systemd that it does not retry later, but who am I to say so? S=
till, lack of rule processing means that symlinks in /dev/disk/by-* pointin=
g to the partitions are not created, and thus the root device is never foun=
d.<br>
<br>
Please either persuade systemd maintainers to stop locking block devices be=
cause this API is already used for a different purpose, or persuade them to=
 retry rule processing (they can probably do so when they detect via inotif=
y or similar means that the device has been closed), or stop locking block =
devices in multipathd (i.e. lock something else like zero-length files in /=
run/lock).<br>
<br>
By the way, I suspect that this lock contention also has impact on multipat=
hd itself, potentially causing it to disregard some paths because their blo=
ck devices were locked by systemd-udevd when multipathd attempted to look a=
t them. I am not an expert here, because I don&#39;t have any hardware that=
 needs multipath.<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
-- <br>
Alexander E. Patrakov<br>
</font></span></div><br></div></div>

--001a11c3f5d4b764d10506a66f85--


--===============2878148002408341951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2878148002408341951==--
