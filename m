From: Doug Dumitru <doug@easyco.com>
Subject: Re: API for multi-segment atomic IO
Date: Thu, 9 Jul 2015 10:08:48 -0700
Message-ID: <CAFx4rwRBh4ix1d84rzo=_0MiLABNObA54cbBNZ5RKTnWpT78mg@mail.gmail.com>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
	<559D43F7.9010506@sandisk.com>
	<CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
	<20150708193832.GA26268@infradead.org>
	<CAFx4rwR980To5cK=UgW1-qe8psgeQFYYm0-g_sPz1cEs48JiYg@mail.gmail.com>
	<559EA29D.9000700@sandisk.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7593910060014722433=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <559EA29D.9000700@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7593910060014722433==
Content-Type: multipart/alternative; boundary=bcaec547cbb5ca6e28051a745095

--bcaec547cbb5ca6e28051a745095
Content-Type: text/plain; charset=UTF-8

Mr. Assche,

The problem with this is that the SCSI commands do not go far enough to
actually address the needs of applications that need atomic updates.  An
application would "like" to be able to update a large arbitrary set, of
sectors on a device with atomic semantics.  The SCSI commands require the
set to be contiguous.  Application design starts to get interesting when
the contiguous restriction goes away.

My initial thoughts are to tag multiple IO requests with an ID and combined
length field.  This would be compatible with the SCSI spec if the request
was contiguous, but nonsensical if the request were multi-segment.  On the
other hand, just hitting the SCSI spec is probably as simple as adding an
"atomic" bit to the current structure so that IO pieces are not cut up.
But then, you don't address the multi-segment functionality that is
possible.  Regardless, there will be issues as pieces of the current stack
don't lend themselves well to propagating atomic operations up and down the
stack.  Just how do you split an atomic write across scsi devices in a raid
set anyway?

What I am most interested in is keeping the stack working with at least 1:1
mapping layers, and with 1:many layers below the layer that implements the
atomic functionality.  Think of a dm-atomic.ko device that uses a log
internally to implement multi-segment atomic writes.  It can talk safely to
raid below it, but lvm should be able to sit above it and still have a file
system that expects atomic functionality to work.  Now getting a SAN
connection to work like this would involve a new transport as iSCSI doesn't
really have the semantics for this, but maybe there are some extra
"transaction ID" bits that could be put into play (it has been a long time
since I dug into the depths of the SCSI layers).

Doug


On Thu, Jul 9, 2015 at 9:34 AM, Bart Van Assche <bart.vanassche@sandisk.com>
wrote:

> On 07/09/2015 08:41 AM, Doug Dumitru wrote:> Mr. Hellwig,
>
>> On Wed, Jul 8, 2015 at 12:38 PM, Christoph Hellwig <hch@infradead.org
>> <mailto:hch@infradead.org>> wrote:
>>
>>     On Wed, Jul 08, 2015 at 09:21:21AM -0700, Doug Dumitru wrote:
>>     > I have a "smart" block device that can implement multi-segment
>> atomic
>>     > writes.
>>
>>     How about submitting your driver upstream first and then we can work
>>     with you on an API that fits the devices and the consumers needs.
>>
>> I usually like to start with an interface and then implement the
>> driver's from there.
>>
>> In this case, this is a block-level interface that supports new
>> functionality (atomic writes).  In the past, you would approach this
>> type of problem by having the atomic and user layers as a monolithic
>> solution.  Consider database updates and the complexity that they go
>> through to insure database integrity.  If a block device could provide a
>> database with an atomic update interface, the database would get a lot
>> simpler.  The same discussion holds true for file systems.  Depending on
>> the atomic update implementation, you might end up in the same place in
>> terms of total code, but you might also end up somewhere completely
>> different.
>>
>> The impetus for this is some research on file system "write
>> amplification".  In general, file system design seems to be heading in
>> the direction of higher and higher write amplification.  For example,
>> the tree structure of zfs is shockingly inefficient in terms of write
>> overhead.  This is happening at the same time as Flash is becoming
>> popular but is also moving to smaller and smaller geometries.  So write
>> efficiency is becoming more and more important.
>>
>> By decoupling the atomic update semantics from file system and other
>> block device "users", this gives devices the opportunity to implement
>> atomic updates internal to or in cooperation with Flash management
>> algorithms.  In theory, you can implement atomic updates without any
>> extra writes.  In practice, some devices will be better than others.
>>
>> I was hoping to stumble across someone interested in this as a concept,
>> or someone who has researched this area, as I don't have any near
>> production existing code.  I could pretty easily hack in a couple of
>> extra fields in struct bio that would accomplish what I see, but others
>> might have differing input.
>>
>
> Hello Doug,
>
> When designing such an API, please try to stay close to the semantics of
> the already standardized SCSI commands. As you probably know the Linux SCSI
> core has been implemented as a block driver. Any new command that is added
> to the Linux block layer has to be translated by the Linux SCSI core into a
> SCSI command. An example of a patch series that adds support for a new
> block layer primitive is the patch series that adds compare-and-write
> support (http://thread.gmane.org/gmane.linux.scsi/95869). Although that
> patch series is not yet upstream I think it is a good example of how to add
> new functionality to the block layer and SCSI core.
>
> Bart.
>



-- 
Doug Dumitru
EasyCo LLC

--bcaec547cbb5ca6e28051a745095
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Mr. Assche,<br><br></div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:sm=
all">The problem with this is that the SCSI commands do not go far enough t=
o actually address the needs of applications that need atomic updates.=C2=
=A0 An application would &quot;like&quot; to be able to update a large arbi=
trary set, of sectors on a device with atomic semantics.=C2=A0 The SCSI com=
mands require the set to be contiguous.=C2=A0 Application design starts to =
get interesting when the contiguous restriction goes away.<br><br></div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;f=
ont-size:small">My initial thoughts are to tag multiple IO requests with an=
 ID and combined length field.=C2=A0 This would be compatible with the SCSI=
 spec if the request was contiguous, but nonsensical if the request were mu=
lti-segment.=C2=A0 On the other hand, just hitting the SCSI spec is probabl=
y as simple as adding an &quot;atomic&quot; bit to the current structure so=
 that IO pieces are not cut up.=C2=A0 But then, you don&#39;t address the m=
ulti-segment functionality that is possible.=C2=A0 Regardless, there will b=
e issues as pieces of the current stack don&#39;t lend themselves well to p=
ropagating atomic operations up and down the stack.=C2=A0 Just how do you s=
plit an atomic write across scsi devices in a raid set anyway?<br><br></div=
><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-ser=
if;font-size:small">What I am most interested in is keeping the stack worki=
ng with at least 1:1 mapping layers, and with 1:many layers below the layer=
 that implements the atomic functionality.=C2=A0 Think of a dm-atomic.ko de=
vice that uses a log internally to implement multi-segment atomic writes.=
=C2=A0 It can talk safely to raid below it, but lvm should be able to sit a=
bove it and still have a file system that expects atomic functionality to w=
ork.=C2=A0 Now getting a SAN connection to work like this would involve a n=
ew transport as iSCSI doesn&#39;t really have the semantics for this, but m=
aybe there are some extra &quot;transaction ID&quot; bits that could be put=
 into play (it has been a long time since I dug into the depths of the SCSI=
 layers).<br></div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif;font-size:small"><br></div><div class=3D"gmail_default=
" style=3D"font-family:arial,helvetica,sans-serif;font-size:small">Doug<br>=
<br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">O=
n Thu, Jul 9, 2015 at 9:34 AM, Bart Van Assche <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@sa=
ndisk.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On 07/09=
/2015 08:41 AM, Doug Dumitru wrote:&gt; Mr. Hellwig,<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><span class=3D"">
On Wed, Jul 8, 2015 at 12:38 PM, Christoph Hellwig &lt;<a href=3D"mailto:hc=
h@infradead.org" target=3D"_blank">hch@infradead.org</a><br></span><span cl=
ass=3D"">
&lt;mailto:<a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infra=
dead.org</a>&gt;&gt; wrote:<br>
<br>
=C2=A0 =C2=A0 On Wed, Jul 08, 2015 at 09:21:21AM -0700, Doug Dumitru wrote:=
<br>
=C2=A0 =C2=A0 &gt; I have a &quot;smart&quot; block device that can impleme=
nt multi-segment atomic<br>
=C2=A0 =C2=A0 &gt; writes.<br>
<br>
=C2=A0 =C2=A0 How about submitting your driver upstream first and then we c=
an work<br>
=C2=A0 =C2=A0 with you on an API that fits the devices and the consumers ne=
eds.<br>
<br></span><div><div class=3D"h5">
I usually like to start with an interface and then implement the<br>
driver&#39;s from there.<br>
<br>
In this case, this is a block-level interface that supports new<br>
functionality (atomic writes).=C2=A0 In the past, you would approach this<b=
r>
type of problem by having the atomic and user layers as a monolithic<br>
solution.=C2=A0 Consider database updates and the complexity that they go<b=
r>
through to insure database integrity.=C2=A0 If a block device could provide=
 a<br>
database with an atomic update interface, the database would get a lot<br>
simpler.=C2=A0 The same discussion holds true for file systems.=C2=A0 Depen=
ding on<br>
the atomic update implementation, you might end up in the same place in<br>
terms of total code, but you might also end up somewhere completely<br>
different.<br>
<br>
The impetus for this is some research on file system &quot;write<br>
amplification&quot;.=C2=A0 In general, file system design seems to be headi=
ng in<br>
the direction of higher and higher write amplification.=C2=A0 For example,<=
br>
the tree structure of zfs is shockingly inefficient in terms of write<br>
overhead.=C2=A0 This is happening at the same time as Flash is becoming<br>
popular but is also moving to smaller and smaller geometries.=C2=A0 So writ=
e<br>
efficiency is becoming more and more important.<br>
<br>
By decoupling the atomic update semantics from file system and other<br>
block device &quot;users&quot;, this gives devices the opportunity to imple=
ment<br>
atomic updates internal to or in cooperation with Flash management<br>
algorithms.=C2=A0 In theory, you can implement atomic updates without any<b=
r>
extra writes.=C2=A0 In practice, some devices will be better than others.<b=
r>
<br>
I was hoping to stumble across someone interested in this as a concept,<br>
or someone who has researched this area, as I don&#39;t have any near<br>
production existing code.=C2=A0 I could pretty easily hack in a couple of<b=
r>
extra fields in struct bio that would accomplish what I see, but others<br>
might have differing input.<br>
</div></div></blockquote>
<br>
Hello Doug,<br>
<br>
When designing such an API, please try to stay close to the semantics of th=
e already standardized SCSI commands. As you probably know the Linux SCSI c=
ore has been implemented as a block driver. Any new command that is added t=
o the Linux block layer has to be translated by the Linux SCSI core into a =
SCSI command. An example of a patch series that adds support for a new bloc=
k layer primitive is the patch series that adds compare-and-write support (=
<a href=3D"http://thread.gmane.org/gmane.linux.scsi/95869" rel=3D"noreferre=
r" target=3D"_blank">http://thread.gmane.org/gmane.linux.scsi/95869</a>). A=
lthough that patch series is not yet upstream I think it is a good example =
of how to add new functionality to the block layer and SCSI core.<span clas=
s=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
Bart.<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--bcaec547cbb5ca6e28051a745095--


--===============7593910060014722433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7593910060014722433==--
