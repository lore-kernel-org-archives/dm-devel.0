From: Vladimir Smolensky <arizal@gmail.com>
Subject: Re: dm-cache fs corruption
Date: Thu, 14 Nov 2013 17:21:21 +0200
Message-ID: <CALwk7=xBTqtOQqXx6WnGyLAAXz4+wrQ9W3MOjs66mWBRhmqxBw@mail.gmail.com>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
	<20131113131022.GA13882@debian>
	<CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
	<20131113144112.GF13882@debian>
	<CALwk7=zWxL1QD3_pujA-QpWOCLLbJKT31p5HqTrzJwYPETh26g@mail.gmail.com>
	<CALwk7=xi2NBOE+bGcoygtsqFYzSE8a7DsC7p7MCRd06QU6jihQ@mail.gmail.com>
	<33A0129EBFD46748804DE81B354CA1B21C031F48@SACEXCMBX06-PRD.hq.netapp.com>
	<20131114143832.GC17651@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7030602552244064424=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131114143832.GC17651@debian>
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

--===============7030602552244064424==
Content-Type: multipart/alternative; boundary=001a11c3657e57ccf404eb24a289

--001a11c3657e57ccf404eb24a289
Content-Type: text/plain; charset=ISO-8859-1

./cache_restore -V
0.2.8


On Thu, Nov 14, 2013 at 4:38 PM, Joe Thornber <thornber@redhat.com> wrote:

> On Wed, Nov 13, 2013 at 06:39:37PM +0000, Mears, Morgan wrote:
> > On Wed, Nov 13, 2013 at 11:29:26AM -0005, Vladimir Smolensky wrote:
> > > Hello,
> > > I'm compiling the for-linus branch, it shows 3.12.0-rc5, that's ok
> right?
> > >
> > > Where can I get cache_restore, cache_dump, etc. and info how to use
> them.
> >
> > Hi Vladimir,
> >
> > git clone https://github.com/jthornber/thin-provisioning-tools.git
> > cd thin-provisioning-tools
> > autoreconf
> > ./configure --enable-testing
> > make
> > sudo cp cache_check cache_dump cache_restore cache_repair /usr/sbin
> > cache_check --version
> >
> > This is mostly distilled from README.md in the repo; there are some
> > additional dependencies in there that you might have to address.
> >
> > All the tools have a --help option; not sure about other documentation.
> >
> > --Morgan
>
> 'make install' should work, and I believe there are some man pages.
>
> - Joe
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c3657e57ccf404eb24a289
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">./cache_restore -V<br>0.2.8<br></div><div class=3D"gmail_e=
xtra"><br><br><div class=3D"gmail_quote">On Thu, Nov 14, 2013 at 4:38 PM, J=
oe Thornber <span dir=3D"ltr">&lt;<a href=3D"mailto:thornber@redhat.com" ta=
rget=3D"_blank">thornber@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Wed, Nov 13, 2013 at 06=
:39:37PM +0000, Mears, Morgan wrote:<br>
&gt; On Wed, Nov 13, 2013 at 11:29:26AM -0005, Vladimir Smolensky wrote:<br=
>
&gt; &gt; Hello,<br>
&gt; &gt; I&#39;m compiling the for-linus branch, it shows 3.12.0-rc5, that=
&#39;s ok right?<br>
&gt; &gt;<br>
&gt; &gt; Where can I get cache_restore, cache_dump, etc. and info how to u=
se them.<br>
&gt;<br>
&gt; Hi Vladimir,<br>
&gt;<br>
&gt; git clone <a href=3D"https://github.com/jthornber/thin-provisioning-to=
ols.git" target=3D"_blank">https://github.com/jthornber/thin-provisioning-t=
ools.git</a><br>
&gt; cd thin-provisioning-tools<br>
&gt; autoreconf<br>
&gt; ./configure --enable-testing<br>
&gt; make<br>
&gt; sudo cp cache_check cache_dump cache_restore cache_repair /usr/sbin<br=
>
&gt; cache_check --version<br>
&gt;<br>
&gt; This is mostly distilled from README.md in the repo; there are some<br=
>
&gt; additional dependencies in there that you might have to address.<br>
&gt;<br>
&gt; All the tools have a --help option; not sure about other documentation=
.<br>
&gt;<br>
&gt; --Morgan<br>
<br>
</div>&#39;make install&#39; should work, and I believe there are some man =
pages.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
- Joe<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</div></div></blockquote></div><br></div>

--001a11c3657e57ccf404eb24a289--


--===============7030602552244064424==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7030602552244064424==--
