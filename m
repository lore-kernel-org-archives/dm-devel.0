From: tom z <maillist.tom@gmail.com>
Subject: Re: help:"event number"
Date: Mon, 17 Jan 2011 14:06:22 +0800
Message-ID: <AANLkTimDxcNg-G7ibiFDsaXQqqYu5ijwdYCRxRpk1POK@mail.gmail.com>
References: <AANLkTi=k-HrQHsPYP3HPW2aw5=atBECF9nbkXYymCYbW@mail.gmail.com>
	<20110117032939.GC27133@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1276923590898281289=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110117032939.GC27133@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tom z <maillist.tom@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1276923590898281289==
Content-Type: multipart/alternative; boundary=90e6ba6e85f24b576b049a049522

--90e6ba6e85f24b576b049a049522
Content-Type: text/plain; charset=ISO-8859-1

Thanks,i got it.
But i have another question.Sometimes, i can't remove the device, in the
"dmsetup man", it said "because an uninterruptible process is waiting for
I/O to return from it", and what should i do for getting the PID or
something about this "uninterruptible process"? I know adding "--force" can
help me remove the device, but i am worried about this action will cause I/O
broken.

On Mon, Jan 17, 2011 at 11:29 AM, Alasdair G Kergon <agk@redhat.com> wrote:

> On Mon, Jan 17, 2011 at 10:12:51AM +0800, tom z wrote:
> >    What's the meaning of the "Event number". Is it number of the device's
> > I/O event? If the number is greater to zero, it means the I/O request's
> > happening?
>
> No.  Just means something happened that userspace ought to know about,
> like a path failing.  Used by 'wait' - see 'man dmsetup' and
> http://people.redhat.com/agk/talks/FOSDEM_2005/text51.html .
>
> Alasdair
>
>

--90e6ba6e85f24b576b049a049522
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks,i got it.<br>But i have another question.Sometimes, i can&#39;t remo=
ve the device, in the &quot;dmsetup man&quot;, it said &quot;because an
uninterruptible process is waiting for I/O to return from it&quot;, and wha=
t should i do for getting the PID or something about this &quot;uninterrupt=
ible process&quot;? I know adding &quot;--force&quot; can help me remove th=
e device, but i am worried about this action will cause I/O broken.<br>
<br><div class=3D"gmail_quote">On Mon, Jan 17, 2011 at 11:29 AM, Alasdair G=
 Kergon <span dir=3D"ltr">&lt;<a href=3D"mailto:agk@redhat.com">agk@redhat.=
com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding-=
left: 1ex;">
<div class=3D"im">On Mon, Jan 17, 2011 at 10:12:51AM +0800, tom z wrote:<br=
>
&gt; =A0 =A0What&#39;s the meaning of the &quot;Event number&quot;. Is it n=
umber of the device&#39;s<br>
&gt; I/O event? If the number is greater to zero, it means the I/O request&=
#39;s<br>
&gt; happening?<br>
<br>
</div>No. =A0Just means something happened that userspace ought to know abo=
ut,<br>
like a path failing. =A0Used by &#39;wait&#39; - see &#39;man dmsetup&#39; =
and<br>
<a href=3D"http://people.redhat.com/agk/talks/FOSDEM_2005/text51.html" targ=
et=3D"_blank">http://people.redhat.com/agk/talks/FOSDEM_2005/text51.html</a=
> .<br>
<font color=3D"#888888"><br>
Alasdair<br>
<br>
</font></blockquote></div><br>

--90e6ba6e85f24b576b049a049522--


--===============1276923590898281289==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1276923590898281289==--
