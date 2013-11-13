From: Vladimir Smolensky <arizal@gmail.com>
Subject: Re: dm-cache fs corruption
Date: Wed, 13 Nov 2013 15:48:18 +0200
Message-ID: <CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
	<20131113131022.GA13882@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2865082844455246289=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131113131022.GA13882@debian>
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

--===============2865082844455246289==
Content-Type: multipart/alternative; boundary=047d7ba97804b5fc5b04eb0f3732

--047d7ba97804b5fc5b04eb0f3732
Content-Type: text/plain; charset=ISO-8859-1

Hello Joe,
I can provide you with the setup to test if you want.
Problem is, 3TB cache gets filled very slowly - about 2 weeks.

regards,
Vladimir Smolensky


On Wed, Nov 13, 2013 at 3:10 PM, Joe Thornber <thornber@redhat.com> wrote:

> On Wed, Nov 13, 2013 at 12:24:03PM +0200, Vladimir Smolensky wrote:
> > Hello,
> > I've been testing dm-cache for use with static web content.
> > It appears that, when using big cache ~3TB(+20TB origin dev) dm-cache
> > device corrupts the filesystem after block eviction starts to happen.
> > If I set smaller cache size - single 480GB ssd(again with 20TB origin
> dev),
> > the dm-cache dev works just fine.
>
> Hi Vladmimir,
>
> Sorry you've been having trouble, and thanks for taking the time to
> report.  I'll see if I can scrape together enough disks to reproduce
> the problem, and get back to you.
>
> - Joe
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--047d7ba97804b5fc5b04eb0f3732
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hello Joe,<br></div>I can provide you with =
the setup to test if you want.<br></div><div>Problem is, 3TB cache gets fil=
led very slowly - about 2 weeks.<br></div><div><br></div>regards,<br></div>
Vladimir Smolensky</div><div class=3D"gmail_extra"><br><br><div class=3D"gm=
ail_quote">On Wed, Nov 13, 2013 at 3:10 PM, Joe Thornber <span dir=3D"ltr">=
&lt;<a href=3D"mailto:thornber@redhat.com" target=3D"_blank">thornber@redha=
t.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Wed, Nov 13, 2013 at 12=
:24:03PM +0200, Vladimir Smolensky wrote:<br>
&gt; Hello,<br>
&gt; I&#39;ve been testing dm-cache for use with static web content.<br>
&gt; It appears that, when using big cache ~3TB(+20TB origin dev) dm-cache<=
br>
&gt; device corrupts the filesystem after block eviction starts to happen.<=
br>
&gt; If I set smaller cache size - single 480GB ssd(again with 20TB origin =
dev),<br>
&gt; the dm-cache dev works just fine.<br>
<br>
</div>Hi Vladmimir,<br>
<br>
Sorry you&#39;ve been having trouble, and thanks for taking the time to<br>
report. =A0I&#39;ll see if I can scrape together enough disks to reproduce<=
br>
the problem, and get back to you.<br>
<br>
- Joe<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--047d7ba97804b5fc5b04eb0f3732--


--===============2865082844455246289==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2865082844455246289==--
