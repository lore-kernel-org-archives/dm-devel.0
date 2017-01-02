From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: error while loading multipathd
Date: Mon, 2 Jan 2017 08:25:22 +0100
Message-ID: <CABr-GndHXr9Cb4ndxENXLJJc2jYveHqr0uAG9c8e-2Khyr4JDw@mail.gmail.com>
References: <39bd29aea5ed4648b01c101c2206b93a@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7037181362428973408=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <39bd29aea5ed4648b01c101c2206b93a@BRMWP-EXMB12.corp.brocade.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Muneendra Kumar M <mmandala@brocade.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7037181362428973408==
Content-Type: multipart/alternative; boundary=001a114110686c1c9305451774d7

--001a114110686c1c9305451774d7
Content-Type: text/plain; charset=UTF-8

liburcu is not shipped with the multipath-tools code base.
It should be installed in the system, likely through the distribution
package manager.
The package is "userspace RCU library".

Best regards,
Christophe Varoqui
OpenSVC

On Mon, Jan 2, 2017 at 8:14 AM, Muneendra Kumar M <mmandala@brocade.com>
wrote:

> Hi All,
>
>  Iam using CentOS Linux release 7.2.1511 .
>
> I downloaded the latest sourcecode from git clone http://git.opensvc.com/
> multipath-tools/.git.
>
> And I linked my binaries to the newly built libmultipath, using ldd, and
> not to a package-installed one using the below command from the build dir.
>
>
>
> export LD_LIBRARY_PATH=libmultipath/:libmpathpersist/:libmpathcmd/:
> multipath/multipath-h
>
>
>
> With this when I run the multipath utility and the output is fine as
> expected
>
>
>
> But when I run the multipathd iam getting the below error.
>
> ./multipathd/multipathd: error while loading shared libraries:
> liburcu.so.4: cannot open shared object file: No such file or directory
>
>
>
> Can anyone help me regarding this so that i can start working on my
> private build instead of default..
>
>
>
>
>
>
>
> Regards,
>
> Muneendra.
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a114110686c1c9305451774d7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">liburcu is not shipped with the multipath-tools code base.=
<div>It should be installed in the system, likely through the distribution =
package manager.</div><div>The package is &quot;userspace RCU library&quot;=
.</div><div><br></div><div>Best regards,</div><div>Christophe Varoqui</div>=
<div>OpenSVC</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_=
quote">On Mon, Jan 2, 2017 at 8:14 AM, Muneendra Kumar M <span dir=3D"ltr">=
&lt;<a href=3D"mailto:mmandala@brocade.com" target=3D"_blank">mmandala@broc=
ade.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">





<div lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"m_5581026209367921541WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:#1f497d">Hi All,<u></u><u></u><=
/span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d">=C2=A0Iam using CentOS Linux release 7.2.1511 .<u></u><u></u></span></=
p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d">I downloaded the latest sourcecode from=C2=A0git clone=C2=A0<a href=3D=
"http://git.opensvc.com/multipath-tools/.git" target=3D"_blank"><span style=
=3D"color:#1f497d;text-decoration:none">http://git.opensvc.com/<wbr>multipa=
th-tools/.git</span></a>.
<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d">And I linked my binaries to the newly built libmultipath, using ldd, a=
nd not to a package-installed one using the below command from the build di=
r.<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d">export LD_LIBRARY_PATH=3Dlibmultipath/:<wbr>libmpathpersist/:libmpathc=
md/:<wbr>multipath/multipath-h<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d">With this when I run the multipath utility and the output is fine as e=
xpected<u></u><u></u></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d"><u></u>=C2=A0<u></u></span></p>
<p class=3D"MsoNormal" style=3D"background:white"><span style=3D"color:#1f4=
97d">But when I run the multipathd iam getting the below error.<u></u><u></=
u></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d">./multipathd/multipath=
d: error while loading shared libraries: liburcu.so.4: cannot open shared o=
bject file: No such file or directory<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d"><u></u>=C2=A0<u></u></=
span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d">Can anyone help me reg=
arding this so that i can start working on my private build instead of defa=
ult..<u></u><u></u></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d"><u></u>=C2=A0<u></u></=
span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d"><u></u>=C2=A0<u></u></=
span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d"><u></u>=C2=A0<u></u></=
span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d">Regards,<u></u><u></u>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1f497d">Muneendra.<u></u><u></=
u></span></p>
<p class=3D"MsoNormal"><u></u>=C2=A0<u></u></p>
</div>
</div>

<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br></blockquote></div><br></div>

--001a114110686c1c9305451774d7--


--===============7037181362428973408==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7037181362428973408==--
