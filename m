From: James Shoemaker <james@dhlake.com>
Subject: Re: multipath bug and patch
Date: Fri, 4 Nov 2016 11:54:05 -0500
Message-ID: <CAN2Lq2vq29RioJXFqzM9=U8f93eTR-NvqC3qcYDjmsdqC-c9-g@mail.gmail.com>
References: <CALRmJ1tJvjrVe9V9ZTeX+K-R9BMVf9wzbVVY5PV5jSXU3EG6Fg@mail.gmail.com>
	<20161104164531.GH1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6624094652452148440=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161104164531.GH1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============6624094652452148440==
Content-Type: multipart/alternative; boundary=94eb2c079324a6cfa005407c851a

--94eb2c079324a6cfa005407c851a
Content-Type: text/plain; charset=UTF-8

   I can add those checks instead.  I'll look at it this weekend and make
up a new set of patches.  I'll admit my fix is a bit of a hack.

   If I remember I did it this way to reduce the amount of change
required.  I hacked this in something like 2 years ago and kept telling
myself I needed to push a change upstream so I didn't have to keep
rebuilding libmultipath every time I updated things.

   I'll have a cleaner patch sent up this weekend.

James Shoemaker

On Fri, Nov 4, 2016 at 11:45 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Thu, Nov 03, 2016 at 01:34:17PM -0500, James Shoemaker wrote:
> >       If a device returns an empty string for inquiry data the current
> >    multipath tool ignores it on reload.  I added the following patch and
> I
> >    can hotplug these devices that don't return all the proper data.
>
> I feel like returning "none" if you try and strchop an empty string is
> pretty surprising behavior. I'd rather see this dealt with in the
> function that has problems with the empty string.
>
> -Ben
>
> >
> >    diff --git a/libmultipath/util.c b/libmultipath/util.c
> >    index ac0d1b2..045e660 100644
> >    --- a/libmultipath/util.c
> >    +++ b/libmultipath/util.c
> >    @@ -17,6 +17,10 @@ strchop(char *str)
> >
> >            for (i=strlen(str)-1; i >=0 && isspace(str[i]); --i) ;
> >            str[++i] = '\0';
> >    +       if(strlen(str)==0)
> >    +       {
> >    +               strcpy(str,"none");
> >    +       }
> >            return strlen(str);
> >     }
> >
> >    James Shoemaker
>
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
>

--94eb2c079324a6cfa005407c851a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">=C2=A0 =C2=A0I can add those checks instead.=C2=A0 I&#39;l=
l look at it this weekend and make up a new set of patches.=C2=A0 I&#39;ll =
admit my fix is a bit of a hack. =C2=A0<div><br></div><div>=C2=A0 =C2=A0If =
I remember I did it this way to reduce the amount of change required.=C2=A0=
 I hacked this in something like 2 years ago and kept telling myself I need=
ed to push a change upstream so I didn&#39;t have to keep rebuilding libmul=
tipath every time I updated things.</div><div><br></div><div>=C2=A0 =C2=A0I=
&#39;ll have a cleaner patch sent up this weekend.<br><div><br></div><div>J=
ames Shoemaker</div></div></div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Fri, Nov 4, 2016 at 11:45 AM, Benjamin Marzinski <span =
dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bm=
arzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">O=
n Thu, Nov 03, 2016 at 01:34:17PM -0500, James Shoemaker wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0 If a device returns an empty string for inqu=
iry data the current<br>
&gt;=C2=A0 =C2=A0 multipath tool ignores it on reload.=C2=A0 I added the fo=
llowing patch and I<br>
&gt;=C2=A0 =C2=A0 can hotplug these devices that don&#39;t return all the p=
roper data.<br>
<br>
I feel like returning &quot;none&quot; if you try and strchop an empty stri=
ng is<br>
pretty surprising behavior. I&#39;d rather see this dealt with in the<br>
function that has problems with the empty string.<br>
<br>
-Ben<br>
<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 diff --git a/libmultipath/util.c b/libmultipath/util.c<br=
>
&gt;=C2=A0 =C2=A0 index ac0d1b2..045e660 100644<br>
&gt;=C2=A0 =C2=A0 --- a/libmultipath/util.c<br>
&gt;=C2=A0 =C2=A0 +++ b/libmultipath/util.c<br>
&gt;=C2=A0 =C2=A0 @@ -17,6 +17,10 @@ strchop(char *str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (i=3Dstrle=
n(str)-1; i &gt;=3D0 &amp;&amp; isspace(str[i]); --i) ;<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 str[++i] =3D &=
#39;\0&#39;;<br>
&gt;=C2=A0 =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if(strlen(str)=3D=
=3D0)<br>
&gt;=C2=A0 =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strcpy(str,&quot;none&quot;);<br>
&gt;=C2=A0 =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }<br>
&gt;=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return strlen(=
str);<br>
&gt;=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 James Shoemaker<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm=
-devel</a><br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c079324a6cfa005407c851a--


--===============6624094652452148440==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6624094652452148440==--
