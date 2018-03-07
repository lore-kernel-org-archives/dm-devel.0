From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/6] Various multipath-tools patches
Date: Wed, 7 Mar 2018 10:56:56 +0100
Message-ID: <CABr-GncWfMGrBcoCnFtOFBCG+8sRn1mbW2A2Bv2hSexpbKevCQ@mail.gmail.com>
References: <20180301192935.14643-1-bart.vanassche@wdc.com>
	<20180306152518.GO14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2394009518600784182=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180306152518.GO14513@octiron.msp.redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2394009518600784182==
Content-Type: multipart/alternative; boundary="001a11478b9c5d78890566cf9450"

--001a11478b9c5d78890566cf9450
Content-Type: text/plain; charset="UTF-8"

Hi Bart,

I've finally merged the queued patches, so you can rebase this patchset
over the new head.

Thanks.


On Tue, Mar 6, 2018 at 4:25 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Thu, Mar 01, 2018 at 11:29:29AM -0800, Bart Van Assche wrote:
> > Hello Christophe,
> >
> > This series contains the following patches:
> > - Four patches address Coverity complaints.
> > - One patch makes a function argument const.
> > - One patch addresses a bug that I discovered while inspecting the
> multipath
> >   command line tool output.
> >
> > Please consider these patches for the multipath-tools project.
>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
>
> For the set. Buy I agree with Martin that we should fold some of these
> into his already posted patches.
>
> -Ben
>
> >
> > Thanks,
> >
> > Bart.
> >
> > Bart Van Assche (6):
> >   multipathd/main.c: Fix indentation
> >   libmultipath, alloc_path_with_pathinfo(): Ensure that pp->wwid is
> >     '\0'-terminated
> >   libmultipath, alloc_path_with_pathinfo(): Declare third argument const
> >   kpartx: Improve reliability of find_loop_by_file()
> >   libmultipath: Fix sgio_get_vpd()
> >   Introduce the ibmultipath/unaligned.h header file
> >
> >  kpartx/lopart.c                       |  7 ++++---
> >  libmpathpersist/mpath_pr_ioctl.c      |  8 ++++----
> >  libmultipath/checkers/hp_sw.c         |  4 ++--
> >  libmultipath/discovery.c              | 22 +++++++++++---------
> >  libmultipath/discovery.h              |  2 +-
> >  libmultipath/prioritizers/alua_rtpg.c | 13 ++++++------
> >  libmultipath/prioritizers/alua_spc3.h | 35
> ++------------------------------
> >  libmultipath/prioritizers/ontap.c     |  4 ++--
> >  libmultipath/unaligned.h              | 38
> +++++++++++++++++++++++++++++++++++
> >  multipathd/main.c                     |  4 ++--
> >  10 files changed, 74 insertions(+), 63 deletions(-)
> >  create mode 100644 libmultipath/unaligned.h
> >
> > --
> > 2.16.2
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11478b9c5d78890566cf9450
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Bart,<div><br></div><div>I&#39;ve finally merged the qu=
eued patches, so you can rebase this patchset over the new head.</div><div>=
<br></div><div>Thanks.</div><div><br></div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Tue, Mar 6, 2018 at 4:25 PM, Benjamin Ma=
rzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On Thu, Mar 01, 2018 at 11:29:29AM -0800, Ba=
rt Van Assche wrote:<br>
&gt; Hello Christophe,<br>
&gt;<br>
&gt; This series contains the following patches:<br>
&gt; - Four patches address Coverity complaints.<br>
&gt; - One patch makes a function argument const.<br>
&gt; - One patch addresses a bug that I discovered while inspecting the mul=
tipath<br>
&gt;=C2=A0 =C2=A0command line tool output.<br>
&gt;<br>
&gt; Please consider these patches for the multipath-tools project.<br>
<br>
</span>Reviewed-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redha=
t.com">bmarzins@redhat.com</a>&gt;<br>
<br>
For the set. Buy I agree with Martin that we should fold some of these<br>
into his already posted patches.<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; Thanks,<br>
&gt;<br>
&gt; Bart.<br>
&gt;<br>
&gt; Bart Van Assche (6):<br>
&gt;=C2=A0 =C2=A0multipathd/main.c: Fix indentation<br>
&gt;=C2=A0 =C2=A0libmultipath, alloc_path_with_pathinfo(): Ensure that pp-&=
gt;wwid is<br>
&gt;=C2=A0 =C2=A0 =C2=A0&#39;\0&#39;-terminated<br>
&gt;=C2=A0 =C2=A0libmultipath, alloc_path_with_pathinfo(): Declare third ar=
gument const<br>
&gt;=C2=A0 =C2=A0kpartx: Improve reliability of find_loop_by_file()<br>
&gt;=C2=A0 =C2=A0libmultipath: Fix sgio_get_vpd()<br>
&gt;=C2=A0 =C2=A0Introduce the ibmultipath/unaligned.h header file<br>
&gt;<br>
&gt;=C2=A0 kpartx/lopart.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 7 ++++---<br>
&gt;=C2=A0 libmpathpersist/mpath_pr_<wbr>ioctl.c=C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 8 ++++----<br>
&gt;=C2=A0 libmultipath/checkers/hp_sw.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 4 ++--<br>
&gt;=C2=A0 libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | 22 +++++++++++---------<br>
&gt;=C2=A0 libmultipath/discovery.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 libmultipath/prioritizers/<wbr>alua_rtpg.c | 13 ++++++------<br>
&gt;=C2=A0 libmultipath/prioritizers/<wbr>alua_spc3.h | 35 ++--------------=
--------------<wbr>--<br>
&gt;=C2=A0 libmultipath/prioritizers/<wbr>ontap.c=C2=A0 =C2=A0 =C2=A0|=C2=
=A0 4 ++--<br>
&gt;=C2=A0 libmultipath/unaligned.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | 38 ++++++++++++++++++++++++++++++<wbr>+++++<br>
&gt;=C2=A0 multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 4 ++--<br>
&gt;=C2=A0 10 files changed, 74 insertions(+), 63 deletions(-)<br>
&gt;=C2=A0 create mode 100644 libmultipath/unaligned.h<br>
&gt;<br>
&gt; --<br>
&gt; 2.16.2<br>
&gt;<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm=
-devel</a><br>
</font></span></blockquote></div><br></div>

--001a11478b9c5d78890566cf9450--


--===============2394009518600784182==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2394009518600784182==--
