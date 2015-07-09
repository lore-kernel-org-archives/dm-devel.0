From: Doug Dumitru <doug@easyco.com>
Subject: Re: API for multi-segment atomic IO
Date: Thu, 9 Jul 2015 13:39:19 -0700
Message-ID: <CAFx4rwSyd7MVrtPbDvqTmCRZnXqKm7tz-2iWFWR1wqg6r9VArw@mail.gmail.com>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
	<559D43F7.9010506@sandisk.com>
	<CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
	<20150708193832.GA26268@infradead.org>
	<CAFx4rwR980To5cK=UgW1-qe8psgeQFYYm0-g_sPz1cEs48JiYg@mail.gmail.com>
	<559EA29D.9000700@sandisk.com>
	<CAFx4rwRBh4ix1d84rzo=_0MiLABNObA54cbBNZ5RKTnWpT78mg@mail.gmail.com>
	<559EAE46.8000706@sandisk.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4039537066141677996=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <559EAE46.8000706@sandisk.com>
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

--===============4039537066141677996==
Content-Type: multipart/alternative; boundary=20cf3078151caf74bf051a774195

--20cf3078151caf74bf051a774195
Content-Type: text/plain; charset=UTF-8

Mr. Assche,

Thank you for the link.  The proposal describes quite well "why"
multi-segment atomic writes are useful.  I am not sure that this proposal
actually made it into the SPC-5 spec.  It looks like it might overload some
of the data integrity fields and use them to link transactions together,
but I am rusty at reading specs like these.  I will re-read it again over
the weekend.  If anyone "knows" whether the multi-segment support is IN or
OUT of the SPC-5 spec, please chime in.

Doug




On Thu, Jul 9, 2015 at 10:24 AM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> On 07/09/2015 10:09 AM, Doug Dumitru wrote:
>
>> The problem with this is that the SCSI commands do not go far enough to
>> actually address the needs of applications that need atomic updates.  An
>> application would "like" to be able to update a large arbitrary set, of
>> sectors on a device with atomic semantics. The SCSI commands require the
>> set to be contiguous.  Application design starts to get interesting when
>> the contiguous restriction goes away.
>>
>> My initial thoughts are to tag multiple IO requests with an ID and
>> combined length field.  This would be compatible with the SCSI spec if
>> the request was contiguous, but nonsensical if the request were
>> multi-segment.  On the other hand, just hitting the SCSI spec is
>> probably as simple as adding an "atomic" bit to the current structure so
>> that IO pieces are not cut up.  But then, you don't address the
>> multi-segment functionality that is possible.  Regardless, there will be
>> issues as pieces of the current stack don't lend themselves well to
>> propagating atomic operations up and down the stack.  Just how do you
>> split an atomic write across scsi devices in a raid set anyway?
>>
>> What I am most interested in is keeping the stack working with at least
>> 1:1 mapping layers, and with 1:many layers below the layer that
>> implements the atomic functionality.  Think of a dm-atomic.ko device
>> that uses a log internally to implement multi-segment atomic writes.  It
>> can talk safely to raid below it, but lvm should be able to sit above it
>> and still have a file system that expects atomic functionality to work.
>> Now getting a SAN connection to work like this would involve a new
>> transport as iSCSI doesn't really have the semantics for this, but maybe
>> there are some extra "transaction ID" bits that could be put into play
>> (it has been a long time since I dug into the depths of the SCSI layers).
>>
>
> Hello Doug,
>
> The original proposal, from which the SBC-4 ATOMIC WRITE specification has
> been derived, had support for scattered writes and gathered reads. The
> title of that document is "SBC-4 SPC-5 Atomic writes and reads" (
> http://www.t10.org/cgi-bin/ac.pl?t=d&f=14-043r4.pdf).
>
> Bart.
>
>


-- 
Doug Dumitru
EasyCo LLC

--20cf3078151caf74bf051a774195
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Mr. Assche,<br><br></div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:sm=
all">Thank you for the link.=C2=A0 The proposal describes quite well &quot;=
why&quot; multi-segment atomic writes are useful.=C2=A0 I am not sure that =
this proposal actually made it into the SPC-5 spec.=C2=A0 It looks like it =
might overload some of the data integrity fields and use them to link trans=
actions together, but I am rusty at reading specs like these.=C2=A0 I will =
re-read it again over the weekend.=C2=A0 If anyone &quot;knows&quot; whethe=
r the multi-segment support is IN or OUT of the SPC-5 spec, please chime in=
.<br><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif;font-size:small">Doug<br><br></div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif;font-size:small"><br>=
<br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">O=
n Thu, Jul 9, 2015 at 10:24 AM, Bart Van Assche <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@s=
andisk.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div cla=
ss=3D"HOEnZb"><div class=3D"h5">On 07/09/2015 10:09 AM, Doug Dumitru wrote:=
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
The problem with this is that the SCSI commands do not go far enough to<br>
actually address the needs of applications that need atomic updates.=C2=A0 =
An<br>
application would &quot;like&quot; to be able to update a large arbitrary s=
et, of<br>
sectors on a device with atomic semantics. The SCSI commands require the<br=
>
set to be contiguous.=C2=A0 Application design starts to get interesting wh=
en<br>
the contiguous restriction goes away.<br>
<br>
My initial thoughts are to tag multiple IO requests with an ID and<br>
combined length field.=C2=A0 This would be compatible with the SCSI spec if=
<br>
the request was contiguous, but nonsensical if the request were<br>
multi-segment.=C2=A0 On the other hand, just hitting the SCSI spec is<br>
probably as simple as adding an &quot;atomic&quot; bit to the current struc=
ture so<br>
that IO pieces are not cut up.=C2=A0 But then, you don&#39;t address the<br=
>
multi-segment functionality that is possible.=C2=A0 Regardless, there will =
be<br>
issues as pieces of the current stack don&#39;t lend themselves well to<br>
propagating atomic operations up and down the stack.=C2=A0 Just how do you<=
br>
split an atomic write across scsi devices in a raid set anyway?<br>
<br>
What I am most interested in is keeping the stack working with at least<br>
1:1 mapping layers, and with 1:many layers below the layer that<br>
implements the atomic functionality.=C2=A0 Think of a dm-atomic.ko device<b=
r>
that uses a log internally to implement multi-segment atomic writes.=C2=A0 =
It<br>
can talk safely to raid below it, but lvm should be able to sit above it<br=
>
and still have a file system that expects atomic functionality to work.<br>
Now getting a SAN connection to work like this would involve a new<br>
transport as iSCSI doesn&#39;t really have the semantics for this, but mayb=
e<br>
there are some extra &quot;transaction ID&quot; bits that could be put into=
 play<br>
(it has been a long time since I dug into the depths of the SCSI layers).<b=
r>
</blockquote>
<br></div></div>
Hello Doug,<br>
<br>
The original proposal, from which the SBC-4 ATOMIC WRITE specification has =
been derived, had support for scattered writes and gathered reads. The titl=
e of that document is &quot;SBC-4 SPC-5 Atomic writes and reads&quot; (<a h=
ref=3D"http://www.t10.org/cgi-bin/ac.pl?t=3Dd&amp;f=3D14-043r4.pdf" rel=3D"=
noreferrer" target=3D"_blank">http://www.t10.org/cgi-bin/ac.pl?t=3Dd&amp;f=
=3D14-043r4.pdf</a>).<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
Bart.<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--20cf3078151caf74bf051a774195--


--===============4039537066141677996==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4039537066141677996==--
