From: Nicolas Michel <be.nicolas.michel@gmail.com>
Subject: Re: How dm multipath handle IO
Date: Thu, 20 Mar 2014 07:26:55 +0100
Message-ID: <CAO5znauRwv2mH4W+7VLR-PEO-nHvLmoMP-fpih9Ri_E0Dkqt8A@mail.gmail.com>
References: <CAO5znatnsF_x=-EOKHpezw0M4QNZ5KXiawEGKQ7hkXMCwfQy2Q@mail.gmail.com>
	<5322C7E5.8020000@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7315812778052607619=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5322C7E5.8020000@gmail.com>
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

--===============7315812778052607619==
Content-Type: multipart/alternative; boundary=089e0118254408612104f503dbc9

--089e0118254408612104f503dbc9
Content-Type: text/plain; charset=UTF-8

Wonderfull. Thank you. I did google it but never found that doc ;)


2014-03-14 10:12 GMT+01:00 Akira Hayakawa <ruby.wktk@gmail.com>:

> Hi,
>
> Let's google it.
> Is this the article you are looking for?
> https://www.kernel.org/doc/ols/2007/ols2007v2-pages-235-244.pdf
>
> --
> Akira
>
> On 3/14/14 5:44 PM, Nicolas Michel wrote:
> > Hello Guys,
> >
> > It's a general question about how dm and particularly multipathd handle
> IO? I mean, is it a transaction? Is each IO initiated from the OS get back
> an acknowledgement? If it is, is there a retry mechanism?
> > Or are the IO sent blindingly to the block device?
> >
> > If someone have some good article on it, I would be very interested in
> understanding more deeply how IO are handled.
> >
> > Thanks a lot,
> >
> > --
> > Nicolas MICHEL
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Nicolas MICHEL

--089e0118254408612104f503dbc9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Wonderfull. Thank you. I did google it but never found tha=
t doc ;)</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote"=
>2014-03-14 10:12 GMT+01:00 Akira Hayakawa <span dir=3D"ltr">&lt;<a href=3D=
"mailto:ruby.wktk@gmail.com" target=3D"_blank">ruby.wktk@gmail.com</a>&gt;<=
/span>:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hi,<br>
<br>
Let&#39;s google it.<br>
Is this the article you are looking for?<br>
<a href=3D"https://www.kernel.org/doc/ols/2007/ols2007v2-pages-235-244.pdf"=
 target=3D"_blank">https://www.kernel.org/doc/ols/2007/ols2007v2-pages-235-=
244.pdf</a><br>
<br>
--<br>
Akira<br>
<div><div class=3D"h5"><br>
On 3/14/14 5:44 PM, Nicolas Michel wrote:<br>
&gt; Hello Guys,<br>
&gt;<br>
&gt; It&#39;s a general question about how dm and particularly multipathd h=
andle IO? I mean, is it a transaction? Is each IO initiated from the OS get=
 back an acknowledgement? If it is, is there a retry mechanism?<br>
&gt; Or are the IO sent blindingly to the block device?<br>
&gt;<br>
&gt; If someone have some good article on it, I would be very interested in=
 understanding more deeply how IO are handled.<br>
&gt;<br>
&gt; Thanks a lot,<br>
&gt;<br>
&gt; --<br>
&gt; Nicolas MICHEL<br>
&gt;<br>
&gt;<br>
</div></div>&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D=
"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
&gt;<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>Nicolas MICH=
EL
</div>

--089e0118254408612104f503dbc9--


--===============7315812778052607619==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7315812778052607619==--
