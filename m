From: nishant mungse <nishantmungse@gmail.com>
Subject: Re: Improving dm-mirror as a final year project
Date: Wed, 26 Jan 2011 12:24:59 -0500
Message-ID: <AANLkTinK6u8zJyJn8f5j0jVPBQgstPVPFftfQfCw5vuH@mail.gmail.com>
References: <20110125155342.GG26864@genesis.frugalware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2226289234271101398=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110125155342.GG26864@genesis.frugalware.org>
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

--===============2226289234271101398==
Content-Type: multipart/alternative; boundary=90e6ba6153ded8dd6b049ac31cb9

--90e6ba6153ded8dd6b049ac31cb9
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 25, 2011 at 10:53 AM, Miklos Vajna <vmiklos@frugalware.org>wrote:

> Hi,
>
> I got the possibility to work on dm-mirror as a final year project at
> ULX, the Hungarian distributor of Red Hat.
>
> Get my feet wet, I created two small patches:
>
> 1) dm-mirror: allow setting ios count to 0
>
> Always read from the default_mirror in that case.
>
> 2) dm-mirror: allow setting the default mirror
>
> These can help in case one data leg of a mirror is a remote (iSCSI) one,
> so the default RR aproach is not optimal for reading. (One may set the
> ios count to 0, set the default mirror to the local one, and that will
> cause a read speedup.)
>
> I do not yet have the right to send those patches (I do this in
> university time, so the copyright is not mine), but I hope to be able to
> do so - to get them reviewed.
>
> So the final year project's aim is to improve "the fault tolerance and
> performance of dm-mirror". We (I and my mentors) have two ideas in that
> area, not counting the above patches:
>
> 1) Make the currently hardwired RR read approach modular, that would
> allow implementing for example a weighted RR algorithm. (In case one
> disk is two times faster than the other one, etc.)
>
> 2) From our experiments, it seems that in case the dm-mirror looses one
> of its legs and there is a write to the mirror, it gets converted to a
> linear volume. It would be nice (not sure how easy) to use the mirror
> log to mark the dirty blocks, so that the volume would not be converted
> to a linear one: once the other leg is back, it could be updated based
> on the mirror log.
>
> The question: what do you (who have much more experience with dm-mirror
> than me) think - are these reasonable goals? If not, what would you
> improve/change/add/remove to the above list?
>
> Thanks,
>
> Miklos
>
> PS: I'm not subscribed, please keep me in CC.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>


hello all,
There is one doubt regarding the dm-raid1. As far as i know, in dm-raid1 the
data is written parallelly  on all the mirrors of mirrorset and if any of
the mirror fails to write the data then dm-mirror adds this mirror to fail
list by increasing the error count in "fail mirror" function in dm-raid1.
Actually my doubt is where this error count is decremented? i.e after kcpyd
or before and where exactly this error count is decremented?


Regards,
Nishant.

--90e6ba6153ded8dd6b049ac31cb9
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Tue, Jan 25, 2011 at 10:53 AM, Miklos=
 Vajna <span dir=3D"ltr">&lt;<a href=3D"mailto:vmiklos@frugalware.org">vmik=
los@frugalware.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quot=
e" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt =
0.8ex; padding-left: 1ex;">
<div><div></div><div class=3D"h5">Hi,<br>
<br>
I got the possibility to work on dm-mirror as a final year project at<br>
ULX, the Hungarian distributor of Red Hat.<br>
<br>
Get my feet wet, I created two small patches:<br>
<br>
1) dm-mirror: allow setting ios count to 0<br>
<br>
Always read from the default_mirror in that case.<br>
<br>
2) dm-mirror: allow setting the default mirror<br>
<br>
These can help in case one data leg of a mirror is a remote (iSCSI) one,<br=
>
so the default RR aproach is not optimal for reading. (One may set the<br>
ios count to 0, set the default mirror to the local one, and that will<br>
cause a read speedup.)<br>
<br>
I do not yet have the right to send those patches (I do this in<br>
university time, so the copyright is not mine), but I hope to be able to<br=
>
do so - to get them reviewed.<br>
<br>
So the final year project&#39;s aim is to improve &quot;the fault tolerance=
 and<br>
performance of dm-mirror&quot;. We (I and my mentors) have two ideas in tha=
t<br>
area, not counting the above patches:<br>
<br>
1) Make the currently hardwired RR read approach modular, that would<br>
allow implementing for example a weighted RR algorithm. (In case one<br>
disk is two times faster than the other one, etc.)<br>
<br>
2) From our experiments, it seems that in case the dm-mirror looses one<br>
of its legs and there is a write to the mirror, it gets converted to a<br>
linear volume. It would be nice (not sure how easy) to use the mirror<br>
log to mark the dirty blocks, so that the volume would not be converted<br>
to a linear one: once the other leg is back, it could be updated based<br>
on the mirror log.<br>
<br>
The question: what do you (who have much more experience with dm-mirror<br>
than me) think - are these reasonable goals? If not, what would you<br>
improve/change/add/remove to the above list?<br>
<br>
Thanks,<br>
<br>
Miklos<br>
<br>
</div></div>PS: I&#39;m not subscribed, please keep me in CC.<br>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></=
div><br><br>hello all,<br>There is one doubt regarding the dm-raid1. As far=
 as i know, in dm-raid1 the data is written parallelly=A0 on all the mirror=
s of mirrorset and if any of the mirror fails to write the data then dm-mir=
ror adds this mirror to fail list by increasing the error count in &quot;fa=
il mirror&quot; function in dm-raid1. <br>
Actually my doubt is where this error count is decremented? i.e after kcpyd=
 or before and where exactly this error count is decremented?<br><br><br>Re=
gards,<br>Nishant.<br>

--90e6ba6153ded8dd6b049ac31cb9--


--===============2226289234271101398==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2226289234271101398==--
