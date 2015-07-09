From: Doug Dumitru <doug@easyco.com>
Subject: Re: API for multi-segment atomic IO
Date: Thu, 9 Jul 2015 08:41:10 -0700
Message-ID: <CAFx4rwR980To5cK=UgW1-qe8psgeQFYYm0-g_sPz1cEs48JiYg@mail.gmail.com>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
	<559D43F7.9010506@sandisk.com>
	<CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
	<20150708193832.GA26268@infradead.org>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0464730813509028136=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150708193832.GA26268@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0464730813509028136==
Content-Type: multipart/alternative; boundary=089e0111d57c64461f051a7317d5

--089e0111d57c64461f051a7317d5
Content-Type: text/plain; charset=UTF-8

Mr. Hellwig,

I usually like to start with an interface and then implement the driver's
from there.

In this case, this is a block-level interface that supports new
functionality (atomic writes).  In the past, you would approach this type
of problem by having the atomic and user layers as a monolithic solution.
Consider database updates and the complexity that they go through to insure
database integrity.  If a block device could provide a database with an
atomic update interface, the database would get a lot simpler.  The same
discussion holds true for file systems.  Depending on the atomic update
implementation, you might end up in the same place in terms of total code,
but you might also end up somewhere completely different.

The impetus for this is some research on file system "write
amplification".  In general, file system design seems to be heading in the
direction of higher and higher write amplification.  For example, the tree
structure of zfs is shockingly inefficient in terms of write overhead.
This is happening at the same time as Flash is becoming popular but is also
moving to smaller and smaller geometries.  So write efficiency is becoming
more and more important.

By decoupling the atomic update semantics from file system and other block
device "users", this gives devices the opportunity to implement atomic
updates internal to or in cooperation with Flash management algorithms.  In
theory, you can implement atomic updates without any extra writes.  In
practice, some devices will be better than others.

I was hoping to stumble across someone interested in this as a concept, or
someone who has researched this area, as I don't have any near production
existing code.  I could pretty easily hack in a couple of extra fields in
struct bio that would accomplish what I see, but others might have
differing input.

Doug Dumitru

On Wed, Jul 8, 2015 at 12:38 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> On Wed, Jul 08, 2015 at 09:21:21AM -0700, Doug Dumitru wrote:
> > I have a "smart" block device that can implement multi-segment atomic
> > writes.
>
> How about submitting your driver upstream first and then we can work
> with you on an API that fits the devices and the consumers needs.
>



-- 
Doug Dumitru
EasyCo LLC

--089e0111d57c64461f051a7317d5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Mr. Hellwig,<br><br></div><div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:s=
mall">I usually like to start with an interface and then implement the driv=
er&#39;s from there.<br><br></div><div class=3D"gmail_default" style=3D"fon=
t-family:arial,helvetica,sans-serif;font-size:small">In this case, this is =
a block-level interface that supports new functionality (atomic writes).=C2=
=A0 In the past, you would approach this type of problem by having the atom=
ic and user layers as a monolithic solution.=C2=A0 Consider database update=
s and the complexity that they go through to insure database integrity.=C2=
=A0 If a block device could provide a database with an atomic update interf=
ace, the database would get a lot simpler.=C2=A0 The same discussion holds =
true for file systems.=C2=A0 Depending on the atomic update implementation,=
 you might end up in the same place in terms of total code, but you might a=
lso end up somewhere completely different.<br><br></div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">=
The impetus for this is some research on file system &quot;write amplificat=
ion&quot;.=C2=A0 In general, file system design seems to be heading in the =
direction of higher and higher write amplification.=C2=A0 For example, the =
tree structure of zfs is shockingly inefficient in terms of write overhead.=
=C2=A0 This is happening at the same time as Flash is becoming popular but =
is also moving to smaller and smaller geometries.=C2=A0 So write efficiency=
 is becoming more and more important.<br><br></div><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">By de=
coupling the atomic update semantics from file system and other block devic=
e &quot;users&quot;, this gives devices the opportunity to implement atomic=
 updates internal to or in cooperation with Flash management algorithms.=C2=
=A0 In theory, you can implement atomic updates without any extra writes.=
=C2=A0 In practice, some devices will be better than others.<br><br></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
;font-size:small">I was hoping to stumble across someone interested in this=
 as a concept, or someone who has researched this area, as I don&#39;t have=
 any near production existing code.=C2=A0 I could pretty easily hack in a c=
ouple of extra fields in struct bio that would accomplish what I see, but o=
thers might have differing input.<br><br></div><div class=3D"gmail_default"=
 style=3D"font-family:arial,helvetica,sans-serif;font-size:small">Doug Dumi=
tru<br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote=
">On Wed, Jul 8, 2015 at 12:38 PM, Christoph Hellwig <span dir=3D"ltr">&lt;=
<a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infradead.org</a=
>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On W=
ed, Jul 08, 2015 at 09:21:21AM -0700, Doug Dumitru wrote:<br>
&gt; I have a &quot;smart&quot; block device that can implement multi-segme=
nt atomic<br>
&gt; writes.<br>
<br>
</span>How about submitting your driver upstream first and then we can work=
<br>
with you on an API that fits the devices and the consumers needs.<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--089e0111d57c64461f051a7317d5--


--===============0464730813509028136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0464730813509028136==--
