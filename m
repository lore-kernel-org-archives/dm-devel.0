From: Geremy Condra <gcondra@google.com>
Subject: Re: [PATCH] dm: verity: Add support for emitting uevents
 on dm-verity errors.
Date: Thu, 20 Jun 2013 18:12:07 -0700
Message-ID: <CAEQjtanyk2mw2LHMruU+4ujj4KsTtgyfh=3ABk+3g77Bn-6W3g@mail.gmail.com>
References: <1371763260-9933-1-git-send-email-gcondra@google.com>
	<20130621005905.GI23042@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4465848192937723501=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130621005905.GI23042@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Geremy Condra <gcondra@google.com>, dm-devel@redhat.com, wad@chromium.org, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--===============4465848192937723501==
Content-Type: multipart/alternative; boundary=047d7b676a7c6d447004df9fc035

--047d7b676a7c6d447004df9fc035
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jun 20, 2013 at 5:59 PM, Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Jun 20, 2013 at 02:21:00PM -0700, Geremy Condra wrote:
> > With this change and config option, dm-verity errors
> > will cause uevents to be sent to userspace, notifying
> > it that an error has occurred and potentially
> > triggering recovery actions.
>
> > +config DM_VERITY_ERROR_NOTIFY
> > +     tristate "Notify userspace of verity errors through uevents"
> > +     depends on DM_VERITY && DM_UEVENT
> > +     ---help---
> > +       This option instructs dm-verity to send uevents on error.
> > +
>
> Would it cause any problems if we had this feature enabled all the time,
> controlled only by DM_UEVENT?
>
> In other words, if we delete DM_VERITY_ERROR_NOTIFY from the upstream
> patch?
>

Assuming nobody currently using DM_UEVENT minds it doesn't cause any
problems for me. Any current users object?

Geremy Condra


>
> Alasdair
>
>

--047d7b676a7c6d447004df9fc035
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra">On Thu, Jun 20, 2013 at 5:59 PM=
, Alasdair G Kergon <span dir=3D"ltr">&lt;<a href=3D"mailto:agk@redhat.com"=
 target=3D"_blank">agk@redhat.com</a>&gt;</span> wrote:<br><div class=3D"gm=
ail_quote">
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Thu, Jun 20, 2013 at 02=
:21:00PM -0700, Geremy Condra wrote:<br>
&gt; With this change and config option, dm-verity errors<br>
&gt; will cause uevents to be sent to userspace, notifying<br>
&gt; it that an error has occurred and potentially<br>
&gt; triggering recovery actions.<br>
<br>
</div><div class=3D"im">&gt; +config DM_VERITY_ERROR_NOTIFY<br>
&gt; + =A0 =A0 tristate &quot;Notify userspace of verity errors through uev=
ents&quot;<br>
&gt; + =A0 =A0 depends on DM_VERITY &amp;&amp; DM_UEVENT<br>
&gt; + =A0 =A0 ---help---<br>
&gt; + =A0 =A0 =A0 This option instructs dm-verity to send uevents on error=
.<br>
&gt; +<br>
<br>
</div>Would it cause any problems if we had this feature enabled all the ti=
me,<br>
controlled only by DM_UEVENT?<br>
<br>
In other words, if we delete DM_VERITY_ERROR_NOTIFY from the upstream patch=
?<br></blockquote><div><br></div><div>Assuming nobody currently using DM_UE=
VENT minds it doesn&#39;t cause any problems for me. Any current users obje=
ct?</div>
<div><br></div><div>Geremy Condra</div><div>=A0</div><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Alasdair<br>
<br>
</font></span></blockquote></div><br></div></div>

--047d7b676a7c6d447004df9fc035--


--===============4465848192937723501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4465848192937723501==--
