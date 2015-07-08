From: Doug Dumitru <doug@easyco.com>
Subject: Re: API for multi-segment atomic IO
Date: Wed, 8 Jul 2015 09:21:21 -0700
Message-ID: <CAFx4rwTEe5i1s0na0oncht9OEbJVhtgJe21VmS_0E-zxK_Vdrg@mail.gmail.com>
References: <CAFx4rwRyVL4Kt_DgHyHMRZ9SBM3Ao=VubCk7nXBS3Qg68YD_hw@mail.gmail.com>
	<559D43F7.9010506@sandisk.com>
Reply-To: doug@easyco.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2119123284988187850=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <559D43F7.9010506@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2119123284988187850==
Content-Type: multipart/alternative; boundary=001a11c2c8804d5048051a5f89c4

--001a11c2c8804d5048051a5f89c4
Content-Type: text/plain; charset=UTF-8

Mr. Assche,

Thank you for the T10 links.  I was actually looking for something at a
different level.

I have a "smart" block device that can implement multi-segment atomic
writes.  This is more than what T10 envisions in that the writes can span
multiple LBA ranges, and multiple devices in the case of an array.  Thus I
was looking at creating an OS level API for this type of operation.

My initial thought was to create two new fields in the bio struct.

u64 bi_atomic_transaction_id;
u32 bi_atomic_transaction_length;

A writer would populate multiple bio requests with the same transaction_id
and a single write length which is the length of all bio requests.  The bio
requests do not need to be linear or adjacent.  There would probably need
to be alignment rules.  There would be no requirement that all of the
requests are submitted at the same time.  There would probably need to be
size and concurrency limits to keep the engine reasonable.

My concern with just "making up an experimental API" is that, to be useful,
it needs to play nice inside of the block layer with other pieces.  For
example, if I have a device that supports this API, I would like to be able
to use LVM on top of it, or have it as a member of a software mirror set.
This implies that the block stack has a convention to handle layered
devices with these transactions embedded within them.

Again, thank you for the links.

Doug Dumitru

On Wed, Jul 8, 2015 at 8:38 AM, Bart Van Assche <bart.vanassche@sandisk.com>
wrote:

> On 07/07/2015 08:33 PM, Doug Dumitru wrote:
>
>> ... is anyone working on such an animal.  I was thinking of a "struct
>> bio" extension.  I know that Fusion had a private API for this, but I am
>> not a Fusion customer so I have not seen their concepts.
>>
>
> The following document may be helpful: "SBC-4 SPC-5 Atomic writes and
> reads" (http://www.t10.org/cgi-bin/ac.pl?t=d&f=13-064r9.pdf). Please note
> that the information about atomic writes in that document has been
> superseded by the section in the SBC-4 document about atomic writes (
> http://www.t10.org/cgi-bin/ac.pl?t=f&f=sbc4r07c.pdf).
>
> Bart.
>



-- 
Doug Dumitru
EasyCo LLC

--001a11c2c8804d5048051a5f89c4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;font-size:small">Mr. Assche,<br><br></div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:sm=
all">Thank you for the T10 links.=C2=A0 I was actually looking for somethin=
g at a different level.<br><br></div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif;font-size:small">I have a &quot;smar=
t&quot; block device that can implement multi-segment atomic writes.=C2=A0 =
This is more than what T10 envisions in that the writes can span multiple L=
BA ranges, and multiple devices in the case of an array.=C2=A0 Thus I was l=
ooking at creating an OS level API for this type of operation.<br><br></div=
><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-ser=
if;font-size:small">My initial thought was to create two new fields in the =
bio struct.<br><br></div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif;font-size:small">u64 bi_atomic_transaction_id;<b=
r></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif;font-size:small">u32 bi_atomic_transaction_length;<br><br></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
;font-size:small">A writer would populate multiple bio requests with the sa=
me transaction_id and a single write length which is the length of all bio =
requests.=C2=A0 The bio requests do not need to be linear or adjacent.=C2=
=A0 There would probably need to be alignment rules.=C2=A0 There would be n=
o requirement that all of the requests are submitted at the same time.=C2=
=A0 There would probably need to be size and concurrency limits to keep the=
 engine reasonable.<br><br></div><div class=3D"gmail_default" style=3D"font=
-family:arial,helvetica,sans-serif;font-size:small">My concern with just &q=
uot;making up an experimental API&quot; is that, to be useful, it needs to =
play nice inside of the block layer with other pieces.=C2=A0 For example, i=
f I have a device that supports this API, I would like to be able to use LV=
M on top of it, or have it as a member of a software mirror set.=C2=A0 This=
 implies that the block stack has a convention to handle layered devices wi=
th these transactions embedded within them.<br><br></div><div class=3D"gmai=
l_default" style=3D"font-family:arial,helvetica,sans-serif;font-size:small"=
>Again, thank you for the links.<br><br></div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;font-size:small">Doug Dumit=
ru<br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote"=
>On Wed, Jul 8, 2015 at 8:38 AM, Bart Van Assche <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@=
sandisk.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span c=
lass=3D"">On 07/07/2015 08:33 PM, Doug Dumitru wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
... is anyone working on such an animal.=C2=A0 I was thinking of a &quot;st=
ruct<br>
bio&quot; extension.=C2=A0 I know that Fusion had a private API for this, b=
ut I am<br>
not a Fusion customer so I have not seen their concepts.<br>
</blockquote>
<br></span>
The following document may be helpful: &quot;SBC-4 SPC-5 Atomic writes and =
reads&quot; (<a href=3D"http://www.t10.org/cgi-bin/ac.pl?t=3Dd&amp;f=3D13-0=
64r9.pdf" rel=3D"noreferrer" target=3D"_blank">http://www.t10.org/cgi-bin/a=
c.pl?t=3Dd&amp;f=3D13-064r9.pdf</a>). Please note that the information abou=
t atomic writes in that document has been superseded by the section in the =
SBC-4 document about atomic writes (<a href=3D"http://www.t10.org/cgi-bin/a=
c.pl?t=3Df&amp;f=3Dsbc4r07c.pdf" rel=3D"noreferrer" target=3D"_blank">http:=
//www.t10.org/cgi-bin/ac.pl?t=3Df&amp;f=3Dsbc4r07c.pdf</a>).<span class=3D"=
HOEnZb"><font color=3D"#888888"><br>
<br>
Bart.<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><div clas=
s=3D"gmail_signature">Doug Dumitru<br>EasyCo LLC<br></div>
</div>

--001a11c2c8804d5048051a5f89c4--


--===============2119123284988187850==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2119123284988187850==--
