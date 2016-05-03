From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 19/57] multipathd: Do not print misleading
 message 'not found in pathvec'
Date: Tue, 3 May 2016 09:27:26 +0200
Message-ID: <CABr-GnfFFLNRJ844w-Wq9LjeNVNzGQCEOmjNNXH7LOU5aYRAdw@mail.gmail.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-20-git-send-email-hare@suse.de>
	<20160502154029.GQ26117@octiron.msp.redhat.com>
	<57283B78.6010003@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4802908482049765626=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57283B78.6010003@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============4802908482049765626==
Content-Type: multipart/alternative; boundary=047d7b343ef477ad340531eb0a27

--047d7b343ef477ad340531eb0a27
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The patch was merged as-is, so reinstating the warning, using another
non-conflicting phrasing, would require a new patch.

On Tue, May 3, 2016 at 7:47 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 05/02/2016 05:40 PM, Benjamin Marzinski wrote:
> > On Wed, Apr 27, 2016 at 01:10:20PM +0200, Hannes Reinecke wrote:
> >> When looking up a path in the existing configuration it is perfectly
> >> possible for the path not to be present.
> >> This should not generate a message as it might be errorneously
> >> interpreted as an error.
> >>
> >
> > Do you feel really strongly that these messages should go? I don't thin=
k
> > that they are essential, but they can be useful when debugging an issue
> > to see the route the code took. We could move them to level 4, but
> > personally, I find the amount of messages generated at log level 4 to b=
e
> > so high that it's a pain to use to track bugs that don't occur right
> > away. Another possibility would be to change the message to something
> > more innocuous.
> >
> I'm not particulary attached to this patch.
> The main issues I have is that we're generating two identical messages
> at two different locations (ie making it hard to debug), and that the
> message don't indicate whether it's an error or not.
>
> But sure, I can easily drop this patch.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)
>

--047d7b343ef477ad340531eb0a27
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The patch was merged as-is, so reinstating the warning, us=
ing another non-conflicting phrasing, would require a new patch.</div><div =
class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, May 3, 2016 at=
 7:47 AM, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse=
.de" target=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex"><span class=3D"">On 05/02/2016 05:40 PM, Benjamin Marzinsk=
i wrote:<br>
&gt; On Wed, Apr 27, 2016 at 01:10:20PM +0200, Hannes Reinecke wrote:<br>
&gt;&gt; When looking up a path in the existing configuration it is perfect=
ly<br>
&gt;&gt; possible for the path not to be present.<br>
&gt;&gt; This should not generate a message as it might be errorneously<br>
&gt;&gt; interpreted as an error.<br>
&gt;&gt;<br>
&gt;<br>
&gt; Do you feel really strongly that these messages should go? I don&#39;t=
 think<br>
&gt; that they are essential, but they can be useful when debugging an issu=
e<br>
&gt; to see the route the code took. We could move them to level 4, but<br>
&gt; personally, I find the amount of messages generated at log level 4 to =
be<br>
&gt; so high that it&#39;s a pain to use to track bugs that don&#39;t occur=
 right<br>
&gt; away. Another possibility would be to change the message to something<=
br>
&gt; more innocuous.<br>
&gt;<br>
</span>I&#39;m not particulary attached to this patch.<br>
The main issues I have is that we&#39;re generating two identical messages<=
br>
at two different locations (ie making it hard to debug), and that the<br>
message don&#39;t indicate whether it&#39;s an error or not.<br>
<br>
But sure, I can easily drop this patch.<br>
<br>
Cheers,<br>
<br>
Hannes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0zSeries &amp; Storage<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"=
tel:%2B49%20911%2074053%20688" value=3D"+4991174053688">+49 911 74053 688</=
a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)<br=
>
</font></span></blockquote></div><br></div>

--047d7b343ef477ad340531eb0a27--


--===============4802908482049765626==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4802908482049765626==--
