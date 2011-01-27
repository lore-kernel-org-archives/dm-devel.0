From: nishant mungse <nishantmungse@gmail.com>
Subject: Re: Improving dm-mirror as a final year project
Date: Thu, 27 Jan 2011 03:28:38 -0500
Message-ID: <AANLkTi=dthTrJmWyJ8FT9GfYhdpu3+xWXVHanp5PL77i@mail.gmail.com>
References: <20110125155342.GG26864@genesis.frugalware.org>
	<AANLkTinK6u8zJyJn8f5j0jVPBQgstPVPFftfQfCw5vuH@mail.gmail.com>
	<20110126200420.GA29143@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1089137313067484915=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110126200420.GA29143@us.ibm.com>
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

--===============1089137313067484915==
Content-Type: multipart/alternative; boundary=90e6ba6154b682ed57049acfbcdd

--90e6ba6154b682ed57049acfbcdd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 26, 2011 at 3:04 PM, Malahal Naineni <malahal@us.ibm.com> wrote=
:

> nishant mungse [nishantmungse@gmail.com] wrote:
> >
> >    hello all,
> >    There is one doubt regarding the dm-raid1. As far as i know, in
> dm-raid1
> >    the data is written parallelly=EF=BF=BD on all the mirrors of mirror=
set and if
> any
> >    of the mirror fails to write the data then dm-mirror adds this mirro=
r
> to
> >    fail list by increasing the error count in "fail mirror" function in
> >    dm-raid1.
> >    Actually my doubt is where this error count is decremented? i.e afte=
r
> >    kcpyd or before and where exactly this error count is decremented?
>
> There is no actual 'fail list' of mirror legs. The error_count is never
> decremented. The 'error_count' is only used to tell if the mirror leg
> has encountered errors. The only way to clear that counter is
> re-loading the table!
>
> See the comment:
>
>        /*
>         * error_count is used for nothing more than a
>         * simple way to tell if a device has encountered
>         * errors.
>         */
>        atomic_inc(&m->error_count);
>
> Hope that helps,
> Malahal.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

Hi Malahal

Thanks for reply. I am not able to understand what  this
"INIT_WORK(&ms->kmirrord_work, do_mirror)" function does. It  is written in
mirror_ctr of dm-raid1. What i think is whenever a bio comes dm_mirror will
be called if that is case then why this is written in mirror_ctr. Please
answer this.

Regards,
Nishant.

--90e6ba6154b682ed57049acfbcdd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Wed, Jan 26, 2011 at 3:04 PM, Malahal=
 Naineni <span dir=3D"ltr">&lt;<a href=3D"mailto:malahal@us.ibm.com" target=
=3D"_blank">malahal@us.ibm.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin=
: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

<div>nishant mungse [<a href=3D"mailto:nishantmungse@gmail.com" target=3D"_=
blank">nishantmungse@gmail.com</a>] wrote:<br>
&gt;<br>
&gt; =C2=A0 =C2=A0hello all,<br>
&gt; =C2=A0 =C2=A0There is one doubt regarding the dm-raid1. As far as i kn=
ow, in dm-raid1<br>
&gt; =C2=A0 =C2=A0the data is written parallelly=EF=BF=BD on all the mirror=
s of mirrorset and if any<br>
&gt; =C2=A0 =C2=A0of the mirror fails to write the data then dm-mirror adds=
 this mirror to<br>
&gt; =C2=A0 =C2=A0fail list by increasing the error count in &quot;fail mir=
ror&quot; function in<br>
&gt; =C2=A0 =C2=A0dm-raid1.<br>
&gt; =C2=A0 =C2=A0Actually my doubt is where this error count is decremente=
d? i.e after<br>
&gt; =C2=A0 =C2=A0kcpyd or before and where exactly this error count is dec=
remented?<br>
<br>
</div>There is no actual &#39;fail list&#39; of mirror legs. The error_coun=
t is never<br>
decremented. The &#39;error_count&#39; is only used to tell if the mirror l=
eg<br>
has encountered errors. The only way to clear that counter is<br>
re-loading the table!<br>
<br>
See the comment:<br>
<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * error_count is used for nothing more than a<=
br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * simple way to tell if a device has encounter=
ed<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * errors.<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_inc(&amp;m-&gt;error_count);<br>
<br>
Hope that helps,<br>
<font color=3D"#888888">Malahal.<br>
</font><div><div></div><div><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a></div></div></block=
quote></div><br>Hi Malahal<br><br>Thanks for reply. I am not able to unders=
tand what=C2=A0 this &quot;INIT_WORK(&amp;ms-&gt;kmirrord_work, do_mirror)&=
quot; function does. It=C2=A0 is written in mirror_ctr of dm-raid1. What i =
think is whenever a bio comes dm_mirror will be called if that is case then=
 why this is written in mirror_ctr. Please answer this.<br>
<br>Regards,<br>Nishant.<br><br>
<br><br>

--90e6ba6154b682ed57049acfbcdd--


--===============1089137313067484915==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1089137313067484915==--
