From: Marko Huttunen <marko@codito.se>
Subject: Re: XFS getting EAGAIN from block device
Date: Thu, 9 Jun 2011 17:42:00 +0200
Message-ID: <BANLkTi=p2U9y-Q2wSS71q=bhGswsk_VnoQ@mail.gmail.com>
References: <BANLkTinc-zSEY5uQ-8i__KzWPp24Q-yB+w@mail.gmail.com>
	<4DEF3CB1.20900@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0256074067478049106=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DEF3CB1.20900@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============0256074067478049106==
Content-Type: multipart/alternative; boundary=000e0ce0b19a46a7a204a5494b69

--000e0ce0b19a46a7a204a5494b69
Content-Type: text/plain; charset=ISO-8859-1

Hey guys,

The error messages stopped showing up in my syslog, without me doing
something.


Regards,

Marko



On Wed, Jun 8, 2011 at 11:11 AM, Bryn M. Reeves <bmr@redhat.com> wrote:

> On 06/07/2011 09:44 PM, Marko Huttunen wrote:
> > HW specs:
> > The XFS partition is run on a HW Raid on 2 x 1TB WD Black Caviar.
> Motherboard is
> > an ASUS Sabertooth P67 with Intel Sandy Bridge i5-2500K CPU @ 3.30GHz.
>
> As Mike said, it sounds like something further down the stack. You don't
> mention
> what sort of array this is (i.e. which hardware RAID driver it's using,
> whether
> it presents as a SCSI device etc.).
>
> Depending on the answer to that question your next steps might involve
> enabling
> debug in that driver, turning up the generic SCSI logging level or making
> use of
> blktrace to try to understand where the I/O is going (or rather, where it
> isn't
> going ;).
>
> Regards,
> Bryn.
>

--000e0ce0b19a46a7a204a5494b69
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hey guys,</div><div><br></div><div>The error messages stopped showing =
up in my syslog, without me doing something.</div><div><br></div><div><br><=
/div><div>Regards,</div><div><br></div><div>Marko</div><div><br></div><br>
<br><div class=3D"gmail_quote">On Wed, Jun 8, 2011 at 11:11 AM, Bryn M. Ree=
ves <span dir=3D"ltr">&lt;<a href=3D"mailto:bmr@redhat.com">bmr@redhat.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class=3D"im">On 06/07/2011 09:44 PM, Marko Huttunen wrote:<br>
&gt; HW specs:<br>
&gt; The XFS partition is run on a HW Raid on 2 x 1TB WD Black Caviar. Moth=
erboard is<br>
&gt; an ASUS Sabertooth P67 with Intel Sandy Bridge i5-2500K CPU @ 3.30GHz.=
<br>
<br>
</div>As Mike said, it sounds like something further down the stack. You do=
n&#39;t mention<br>
what sort of array this is (i.e. which hardware RAID driver it&#39;s using,=
 whether<br>
it presents as a SCSI device etc.).<br>
<br>
Depending on the answer to that question your next steps might involve enab=
ling<br>
debug in that driver, turning up the generic SCSI logging level or making u=
se of<br>
blktrace to try to understand where the I/O is going (or rather, where it i=
sn&#39;t<br>
going ;).<br>
<br>
Regards,<br>
<font color=3D"#888888">Bryn.<br>
</font></blockquote></div><br>

--000e0ce0b19a46a7a204a5494b69--


--===============0256074067478049106==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0256074067478049106==--
