From: Frederick Grose <fgrose@gmail.com>
Subject: Re: Dumb question; please help
Date: Thu, 7 May 2015 14:04:33 -0400
Message-ID: <CAEcBt+Wm=dR9q5CLuMGPZsjsUF9fV7S=W5vH3TpMLVV=vgRAFg@mail.gmail.com>
References: <CAC5dixFNZ_FBQ8osQiCgDuvXrWBNydC2A173o4RfYqcWCX814Q@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6292603418018375938=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAC5dixFNZ_FBQ8osQiCgDuvXrWBNydC2A173o4RfYqcWCX814Q@mail.gmail.com>
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

--===============6292603418018375938==
Content-Type: multipart/alternative; boundary=001a1134cf34d2ca95051581c0c3

--001a1134cf34d2ca95051581c0c3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 6, 2015 at 1:45 PM, Locane <locane@gmail.com> wrote:

> Hello, I apologize in advance for asking this question, but I can't seem
> to find the information in documentation or anything online.
>
> Short explanation:
>
> - I have a CentOS 6.6 LiveCD that is dying after lots of file system thra=
sh
> - I use "dmsetup status" to check on when it's dying
> - I don't know what the numbers in "dmsetup status" represent - they're
> not labeled
>
> Can anyone answer this question
> <http://superuser.com/questions/900783/dmsetup-status-fields-explained> o=
r
> label the following fields for me and explain what they are?
>
> [root@localhost ~]# dmsetup status
> live-osimg-min: 0 4194304 snapshot 1272/1272 16
> live-rw: 0 4194304 snapshot 7568/1048576 40
>
> What are the <number>/<number>s?  What is the 2 digit number following
> them?
>

<sectors_allocated>/<total_sectors> <metadata_sectors>
=E2=80=8B

> My LiveCD dies when the 7568 number in this example gets to the (I assume
> gibabyte) 1048576 number.  Can I increase this base size?
>

=E2=80=8BWith=E2=80=8B

=E2=80=8Brecent dracut versions, there are startup options, rd.live.overlay=
.size
and rd.writable.fsimg=E2=80=8B, that may be considered.

See
http://git.kernel.org/?p=3Dboot/dracut/dracut.git;a=3Dblob;f=3Dmodules.d/90=
dmsquash-live/dmsquash-live-root.sh;hb=3DHEAD

https://fedoraproject.org/wiki/LiveOS_image may also be helpful.

        --Fred


>
> I apologize again for asking such a rudimentary question on this mailing
> list, but I am desperate.
>
> Thanks in advance.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1134cf34d2ca95051581c0c3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:&#39;tre=
buchet ms&#39;,sans-serif;font-size:small;color:rgb(0,0,153)"><span style=
=3D"font-family:arial,sans-serif;color:rgb(34,34,34)">On Wed, May 6, 2015 a=
t 1:45 PM, Locane </span><span dir=3D"ltr" style=3D"font-family:arial,sans-=
serif;color:rgb(34,34,34)">&lt;<a href=3D"mailto:locane@gmail.com" target=
=3D"_blank">locane@gmail.com</a>&gt;</span><span style=3D"font-family:arial=
,sans-serif;color:rgb(34,34,34)"> wrote:</span><br></div><div class=3D"gmai=
l_extra"><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex"><div dir=3D"ltr">Hello=
, I apologize in advance for asking this question, but I can&#39;t seem to =
find the information in documentation or anything online.<div><br></div><di=
v>Short explanation:</div><div><br></div><div>- I have a CentOS 6.6 LiveCD =
that is dying after lots of file system thrash</div><div>- I use &quot;dmse=
tup status&quot; to check on when it&#39;s dying</div><div>- I don&#39;t kn=
ow what the numbers in &quot;dmsetup status&quot; represent - they&#39;re n=
ot labeled</div><div><br></div><div>Can anyone <a href=3D"http://superuser.=
com/questions/900783/dmsetup-status-fields-explained" target=3D"_blank">ans=
wer this question</a>=C2=A0or label the following fields for me and explain=
 what they are?</div><div><font face=3D"monospace, monospace"><br></font></=
div><font face=3D"monospace, monospace">[root@localhost ~]# dmsetup status=
=C2=A0</font><div><font face=3D"monospace, monospace">live-osimg-min: 0 419=
4304 snapshot 1272/1272 16=C2=A0</font></div><div><font face=3D"monospace, =
monospace">live-rw: 0 4194304 snapshot 7568/1048576 40</font></div><div><fo=
nt face=3D"monospace, monospace"><br></font></div><div><font face=3D"arial,=
 helvetica, sans-serif">What are the &lt;number&gt;/&lt;number&gt;s?=C2=A0 =
What is the 2 digit number following them?</font></div></div></blockquote><=
div><br></div><div class=3D"gmail_default" style=3D"font-family:&#39;trebuc=
het ms&#39;,sans-serif;font-size:small;color:rgb(0,0,153)"><span style=3D"c=
olor:rgb(0,0,0);white-space:pre-wrap;font-family:arial,sans-serif">&lt;sect=
ors_allocated&gt;/&lt;total_sectors&gt; &lt;metadata_sectors&gt;</span><br>=
</div><div class=3D"gmail_default" style=3D"font-family:&#39;trebuchet ms&#=
39;,sans-serif;font-size:small;color:rgb(0,0,153)">=E2=80=8B</div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-widt=
h:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-le=
ft:1ex"><div dir=3D"ltr"><div><span style=3D"font-family:arial,helvetica,sa=
ns-serif">My LiveCD dies when the 7568 number in this example gets to the (=
I assume gibabyte) 1048576 number.=C2=A0 Can I increase this base size?</sp=
an></div></div></blockquote><div><br></div><div><div class=3D"gmail_default=
" style=3D"font-family:&#39;trebuchet ms&#39;,sans-serif;font-size:small;co=
lor:rgb(0,0,153);display:inline">=E2=80=8BWith=E2=80=8B</div>=C2=A0<div cla=
ss=3D"gmail_default" style=3D"font-family:&#39;trebuchet ms&#39;,sans-serif=
;font-size:small;color:rgb(0,0,153);display:inline">=E2=80=8Brecent dracut =
versions, there are startup options, rd.live.overlay.size and rd.writable.f=
simg=E2=80=8B, that may be considered.</div></div><div><div class=3D"gmail_=
default" style=3D"font-family:&#39;trebuchet ms&#39;,sans-serif;font-size:s=
mall;color:rgb(0,0,153);display:inline"><br></div></div><div><div class=3D"=
gmail_default" style=3D"font-family:&#39;trebuchet ms&#39;,sans-serif;font-=
size:small;color:rgb(0,0,153);display:inline">See <a href=3D"http://git.ker=
nel.org/?p=3Dboot/dracut/dracut.git;a=3Dblob;f=3Dmodules.d/90dmsquash-live/=
dmsquash-live-root.sh;hb=3DHEAD">http://git.kernel.org/?p=3Dboot/dracut/dra=
cut.git;a=3Dblob;f=3Dmodules.d/90dmsquash-live/dmsquash-live-root.sh;hb=3DH=
EAD</a></div></div><div><div class=3D"gmail_default" style=3D"font-family:&=
#39;trebuchet ms&#39;,sans-serif;font-size:small;color:rgb(0,0,153);display=
:inline"><br></div></div><div><div class=3D"gmail_default" style=3D"display=
:inline"><font color=3D"#000099" face=3D"trebuchet ms, sans-serif"><a href=
=3D"https://fedoraproject.org/wiki/LiveOS_image">https://fedoraproject.org/=
wiki/LiveOS_image</a> may also be helpful.</font><br></div></div><div><div =
class=3D"gmail_default" style=3D"display:inline"><font color=3D"#000099" fa=
ce=3D"trebuchet ms, sans-serif"><br></font></div></div><div><div class=3D"g=
mail_default" style=3D"display:inline"><font color=3D"#000099" face=3D"treb=
uchet ms, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0 --Fred</font></div></div>=
<div><div class=3D"gmail_default" style=3D"font-family:&#39;trebuchet ms&#3=
9;,sans-serif;font-size:small;color:rgb(0,0,153);display:inline"><br></div>=
</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;b=
order-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:s=
olid;padding-left:1ex"><div dir=3D"ltr"><div><br></div><div><font face=3D"a=
rial, helvetica, sans-serif"><br></font></div><div><font face=3D"arial, hel=
vetica, sans-serif">I apologize again for asking such a rudimentary questio=
n on this mailing list, but I am desperate.</font></div><div><font face=3D"=
arial, helvetica, sans-serif"><br></font></div><div><font face=3D"arial, he=
lvetica, sans-serif">Thanks in advance.</font></div></div>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></=
div><br></div></div>

--001a1134cf34d2ca95051581c0c3--


--===============6292603418018375938==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6292603418018375938==--
