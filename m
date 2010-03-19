From: David Zeuthen <zeuthen@gmail.com>
Subject: Re: [PATCH 1/3] Send KOBJ_ADD event after dm resume
	ioctl.
Date: Fri, 19 Mar 2010 12:08:52 -0400
Message-ID: <7b13a0f81003190908v8258f1dqb77d2bbcaba84134@mail.gmail.com>
References: <1268920694-10960-1-git-send-email-mbroz@redhat.com>
	<ac3eb2511003180913t5f69e0bs29ff3dcfd1209c60@mail.gmail.com>
	<4BA29CA4.9070000@redhat.com>
	<ac3eb2511003190127n1aa2dda5pbd4e0841a46830bc@mail.gmail.com>
	<20100319090656.GR6379@soda.linbit>
	<ac3eb2511003190224u1eb19e4lfeda36bbab18939@mail.gmail.com>
	<4BA37B06.1040107@redhat.com>
	<ac3eb2511003190643u32a8e702l4e7774e7ec924a12@mail.gmail.com>
	<7b13a0f81003190658i78664328ocb94aa0048054a17@mail.gmail.com>
	<20100319155541.GA24051@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0019086404253987353=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100319155541.GA24051@redhat.com>
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

--===============0019086404253987353==
Content-Type: multipart/alternative; boundary=00c09f8c24574670f1048229904f

--00c09f8c24574670f1048229904f
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 19, 2010 at 11:55 AM, Mike Snitzer <snitzer@redhat.com> wrote:

> Thing is, this isn't scalable at all.  Having all these arbitrary rules
> issuing IOs to devices that aren't usable is a complete waste of time.
> On enterprise systems that have 100s (*shudder* 1000s) of LUNs, this
> udev rules' freedom to access such unusable devices is really working
> against us (if the goal is to activate devices as quickly and reliably
> as possible).
>

Please, Mike, whether to probe devices or not is a separate discussion
and it's not really helpful to reiterate that discussion.

(Please do see various mailing lists archives for that particular
discussion;
FWIW, you will notice that what udev is doing is actually desirable. If you
examine the kernel sources, you will find that the kernel itself submits
IO to the block devices - partition table probing for starters. If you
search
harder you will find *raw numbers* (instead of speculation like "100s
(*shudder* 1000s)" showing what udev is doing is not a problem...)

    David

--00c09f8c24574670f1048229904f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 19, 2010 at 11:55 AM, Mike Snitzer <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:snitzer@redhat.com">snitzer@redhat.com</a>&gt;</span> wrote:<br=
><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
Thing is, this isn&#39;t scalable at all. =A0Having all these arbitrary rul=
es<br>
issuing IOs to devices that aren&#39;t usable is a complete waste of time.<=
br>
On enterprise systems that have 100s (*shudder* 1000s) of LUNs, this<br>
udev rules&#39; freedom to access such unusable devices is really working<b=
r>
against us (if the goal is to activate devices as quickly and reliably<br>
as possible).<br></blockquote><div><br></div><div>Please, Mike, whether to =
probe devices or not is a separate discussion</div><div>and it&#39;s=A0not =
really helpful to reiterate that discussion.</div><div><br></div><div>(Plea=
se do see various mailing lists archives=A0for=A0that particular discussion=
;</div>
<div>FWIW, you will notice that what udev is=A0doing is actually desirable.=
 If=A0you</div><div>examine the kernel sources, you will find that the kern=
el itself=A0submits</div><div>IO to the block devices - partition table pro=
bing for starters. If you search</div>
<div>harder you will find *raw numbers* (instead of speculation like &quot;=
100s</div><div>(*shudder* 1000s)&quot; showing what udev is doing is not a =
problem...)</div><div><br></div><div>=A0=A0 =A0David</div><div><br></div></=
div>

--00c09f8c24574670f1048229904f--


--===============0019086404253987353==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0019086404253987353==--
