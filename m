From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: fix SIGUSR2 handling
Date: Thu, 16 Mar 2017 07:43:51 +0100
Message-ID: <CABr-Gne8L4yn_g4c2Vv6fZcSOa+Nbx1Rtd5YTVaitaJ8q5a6cA@mail.gmail.com>
References: <1482998174-11884-1-git-send-email-tang.junhui@zte.com.cn>
	<20170103185909.GB2732@octiron.msp.redhat.com>
	<1489534179.2676.18.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7650286848736454321=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1489534179.2676.18.camel@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>, "zhang.kai16@zte.com.cn" <zhang.kai16@zte.com.cn>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

--===============7650286848736454321==
Content-Type: multipart/alternative; boundary=94eb2c0b86ec5ab43e054ad362fe

--94eb2c0b86ec5ab43e054ad362fe
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Wed, Mar 15, 2017 at 12:29 AM, Bart Van Assche <
Bart.VanAssche@sandisk.com> wrote:

> On Tue, 2017-01-03 at 12:59 -0600, Benjamin Marzinski wrote:
> > On Thu, Dec 29, 2016 at 03:56:14PM +0800, tang.junhui@zte.com.cn wrote:
> > > From: "tang.junhui" <tang.junhui@zte.com.cn>
> > >
> > > SIGUSR2 is not blocked by default, it would cause bellow conflict
> > > in removing of the last path:
> >
> > ACK
>
> Hello Christophe,
>
> This patch was posted more than two months ago. Do you think it should
> be reposted?
>
> Thanks,
>
> Bart.

--94eb2c0b86ec5ab43e054ad362fe
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Wed, Mar 15, 2017 at 12:29 AM, Bart Van =
Assche <span dir=3D"ltr">&lt;<a href=3D"mailto:Bart.VanAssche@sandisk.com" =
target=3D"_blank">Bart.VanAssche@sandisk.com</a>&gt;</span> wrote:<br><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex"><span class=3D"">On Tue, 2017-01-03 at 12:59 -060=
0, Benjamin Marzinski wrote:<br>
&gt; On Thu, Dec 29, 2016 at 03:56:14PM +0800, <a href=3D"mailto:tang.junhu=
i@zte.com.cn">tang.junhui@zte.com.cn</a> wrote:<br>
&gt; &gt; From: &quot;tang.junhui&quot; &lt;<a href=3D"mailto:tang.junhui@z=
te.com.cn">tang.junhui@zte.com.cn</a>&gt;<br>
&gt; &gt;<br>
&gt; &gt; SIGUSR2 is not blocked by default, it would cause bellow conflict=
<br>
&gt; &gt; in removing of the last path:<br>
&gt;<br>
&gt; ACK<br>
<br>
</span>Hello Christophe,<br>
<br>
This patch was posted more than two months ago. Do you think it should<br>
be reposted?<br>
<br>
Thanks,<br>
<br>
Bart.</blockquote></div><br></div>

--94eb2c0b86ec5ab43e054ad362fe--


--===============7650286848736454321==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7650286848736454321==--
