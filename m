From: Eyal Gordon <eyal.gordon@gmail.com>
Subject: Re: multipath-tools make rpm failure
Date: Thu, 22 Oct 2009 15:24:29 +0200
Message-ID: <4ebf5d590910220624s4553c468h2e4225a4b7562bbe@mail.gmail.com>
References: <4ebf5d590910220144n37fdf3c2s870d7c22e810b252@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0137493237=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ebf5d590910220144n37fdf3c2s870d7c22e810b252@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0137493237==
Content-Type: multipart/alternative; boundary=0016e6d6454bd9deaa04768603aa

--0016e6d6454bd9deaa04768603aa
Content-Type: text/plain; charset=ISO-8859-1

Forgot to mention, this is run on CentOS 5.3

Eyal

On Thu, Oct 22, 2009 at 10:44 AM, Eyal Gordon <eyal.gordon@gmail.com> wrote:

> Hello,
>
> I received the following error while trying to run 'make rpm' for
> multipath-tools. My local git repository is a clone of the upstream master
> branch from today.
>
> # make rpm
> sed -e "s/__VERSION__//" \
>         multipath-tools.spec.in > multipath-tools.spec
> rpmbuild -bb multipath-tools.spec
> error: line 6: Empty tag: Version:
> make: *** [rpm] Error 1
>
>
> After looking at the Makefile and adding echo statements to debug, it seems
> that a ${VERSION} variable is required for the above 'sed' statement, but it
> is not defined.
>
> Could anyone help me please?
>
> Thanks,
>  Eyal
>
>

--0016e6d6454bd9deaa04768603aa
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Forgot to mention, this is run on CentOS 5.3<br><br>Eyal<b=
r><br><div class=3D"gmail_quote">On Thu, Oct 22, 2009 at 10:44 AM, Eyal Gor=
don <span dir=3D"ltr">&lt;<a href=3D"mailto:eyal.gordon@gmail.com">eyal.gor=
don@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, =
204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div dir=3D"ltr">=
Hello,<br><br>I received the following error while trying to run &#39;make =
rpm&#39; for multipath-tools. My local git repository is a clone of the ups=
tream master branch from today.<br>
<br># make rpm<br>sed -e &quot;s/__VERSION__//&quot; \<br>
=A0=A0=A0=A0=A0=A0=A0 <a href=3D"http://multipath-tools.spec.in" target=3D"=
_blank">multipath-tools.spec.in</a> &gt; multipath-tools.spec<br>rpmbuild -=
bb multipath-tools.spec<br>error: line 6: Empty tag: Version:<br>make: *** =
[rpm] Error 1<br>
<br><br>After looking at the Makefile and adding echo statements to debug, =
it seems that a ${VERSION} variable is required for the above &#39;sed&#39;=
 statement, but it is not defined.<br>
<br>Could anyone help me please? <br><br>Thanks,<br>=A0Eyal<br><br></div>
</blockquote></div><br></div>

--0016e6d6454bd9deaa04768603aa--


--===============0137493237==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0137493237==--
