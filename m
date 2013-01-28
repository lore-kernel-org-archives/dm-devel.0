From: devicemapper niko <devicemapper.niko@gmail.com>
Subject: Re: dd between thin provisioned devices
Date: Mon, 28 Jan 2013 19:07:20 +0800
Message-ID: <CABSD0hL5Txymbnsj71OqJL934SYH9+Z=Bk9RpFFeBdvohp_i_g@mail.gmail.com>
References: <CABSD0hKsdtxyQCeZPzFhwpiKY7kmapkPxWJLFidK4VujHnTqTg@mail.gmail.com>
	<51063F8C.3090603@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2063765278693651592=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51063F8C.3090603@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2063765278693651592==
Content-Type: multipart/alternative; boundary=e89a8fb1f846e493b104d4574780

--e89a8fb1f846e493b104d4574780
Content-Type: text/plain; charset=ISO-8859-1

thanks for the reply. What i really wanna to ask is thin clone/mirror
supported or not.

I noticed the time later SCSI commad GET LBA STATUS can fullfil this
requiremnt .

Before block copy, send GET LBA STATUS to check the corresponding blocks
mapped or not.
if not, just skip copy.


On Mon, Jan 28, 2013 at 5:06 PM, Zdenek Kabelac <zdenek.kabelac@gmail.com>wrote:

> Dne 27.1.2013 11:01, devicemapper niko napsal(a):
>
>  Hi,everyone
>> if we dd between thin provisioned devices,
>> can we just get allocated blocks copied ?
>>
>
> Nope - devices mapper target operates on block level - not on the
> filesystem
> level - so it has no knowledge about file layout.
>
> What I could eventually imagine is some kind of block compactification
> (just like kernel does for hugepages) - but it's currently not being
> developed....
>
>
>
>  Will the output thin device get fully provisioned?
>> I glanced through the dm-thin code,
>> it turns out unmapped blocks return zeroed,am i right?
>>
>
> depends on settings - you could have either zeroed block or block
> with content left on the disk - i.e. running thin with 1MB block/chunk size
> means - before the first use whole 1MB must be zeroed - so it has its
> price.
>
>
>  Is there a trick to tell upper applications that all u got are zeroes.
>> or should they scan zeroed blocks themselves to trigger WRITE_SAME to
>> reduce
>> I/O load?
>>
>
>
> Documentation/device-mapper/**thin-provisioning.txt
> see flag: skip_block_zeroing
>
> Eventually for lvm2   lvcreate --zero y|n for thin pool creation.
>
> Zdenek
>
>

--e89a8fb1f846e493b104d4574780
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>thanks for the reply. What i really wanna to ask is=
=A0thin clone/mirror supported or not.</div><div>=A0</div><div>I noticed th=
e time later SCSI=A0commad GET LBA STATUS can fullfil=A0this requiremnt=A0.=
</div><div>
=A0</div><div>Before=A0block copy, send GET LBA STATUS to check the corresp=
onding blocks mapped or not.</div><div>if not,=A0just skip copy.=A0</div><d=
iv class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon, Jan 28,=
 2013 at 5:06 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=3D"mailto:zd=
enek.kabelac@gmail.com" target=3D"_blank">zdenek.kabelac@gmail.com</a>&gt;<=
/span> wrote:<br>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-=
color:rgb(204,204,204);border-left-width:1px;border-left-style:solid" class=
=3D"gmail_quote">Dne 27.1.2013 11:01, devicemapper niko napsal(a):<div clas=
s=3D"im">
<br>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-=
color:rgb(204,204,204);border-left-width:1px;border-left-style:solid" class=
=3D"gmail_quote">
Hi,everyone<br>
if we dd between thin provisioned devices,<br>
can we just get allocated blocks copied ?<br>
</blockquote>
<br></div>
Nope - devices mapper target operates on block level - not on the filesyste=
m<br>
level - so it has no knowledge about file layout.<br>
<br>
What I could eventually imagine is some kind of block compactification (jus=
t like kernel does for hugepages) - but it&#39;s currently not being develo=
ped....<div class=3D"im"><br>
<br>
<br>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-=
color:rgb(204,204,204);border-left-width:1px;border-left-style:solid" class=
=3D"gmail_quote">
Will the output thin device get fully provisioned?<br>
I glanced through the dm-thin code,<br>
it turns out unmapped blocks return zeroed,am i right?<br>
</blockquote>
<br></div>
depends on settings - you could have either zeroed block or block<br>
with content left on the disk - i.e. running thin with 1MB block/chunk size=
<br>
means - before the first use whole 1MB must be zeroed - so it has its price=
.<div class=3D"im"><br>
<br>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-=
color:rgb(204,204,204);border-left-width:1px;border-left-style:solid" class=
=3D"gmail_quote">
Is there a trick to tell upper applications that all u got are zeroes.<br>
or should they scan zeroed blocks themselves to trigger WRITE_SAME to reduc=
e<br>
I/O load?<br>
</blockquote>
<br>
<br></div>
Documentation/device-mapper/<u></u>thin-provisioning.txt<br>
see flag: skip_block_zeroing<br>
<br>
Eventually for lvm2 =A0 lvcreate --zero y|n for thin pool creation.<span><f=
ont color=3D"#888888"><br>
<br>
Zdenek<br>
<br>
</font></span></blockquote></div><br></div></div>

--e89a8fb1f846e493b104d4574780--


--===============2063765278693651592==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2063765278693651592==--
