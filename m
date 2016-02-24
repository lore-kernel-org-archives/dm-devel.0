From: Avishay Traeger <avishay@stratoscale.com>
Subject: Re: Getting device-mapper failure notifications
Date: Wed, 24 Feb 2016 08:01:37 +0200
Message-ID: <CAHph7Jp5MWV_6RqZ_Yv1+Bes1T8KxtCB57YPtnzatYHsuwrW9Q@mail.gmail.com>
References: <CAHph7JrC0pU+Wy7DsHeCAhz7FWuJa29qGsdv+jD3OQq4aJ1bTA@mail.gmail.com>
	<56CD38FD.9010209@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5820425625946446225=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56CD38FD.9010209@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andy Grover <agrover@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============5820425625946446225==
Content-Type: multipart/alternative; boundary=001a113ea6928d9e2e052c7dcc52

--001a113ea6928d9e2e052c7dcc52
Content-Type: text/plain; charset=UTF-8

On Wed, Feb 24, 2016 at 7:00 AM, Andy Grover <agrover@redhat.com> wrote:

> On 02/01/2016 11:07 PM, Avishay Traeger wrote:
>
>> Hi all,
>> I have a system where various configurations are possible - iSCSI/FC,
>> single paths and multiple.  For multiple I of course use device-mapper.
>> I was wondering if it was possible to:
>> 1. use it for cases where I have a single path.
>> 2. create a monitoring process that can take some action (e.g., send a
>> notification via message queue) in the case of some failure that would
>> normally cause failover.
>>
>
> Does dm-multipath support a single path? I don't know...
>
> but for your #2, dm-multipath publishes a uevent when a path fails, maybe
> the process could look for that? Using libudev?
>
> HTH -- Andy
>
>
Thanks for pointing me in the right direction Andy!

-- 
*Avishay Traeger, PhD*
*System Architect*

Mobile: +972 54 447 1475
E-mail: avishay@stratoscale.com



Web <http://www.stratoscale.com/> | Blog <http://www.stratoscale.com/blog/>
 | Twitter <https://twitter.com/Stratoscale> | Google+
<https://plus.google.com/u/1/b/108421603458396133912/108421603458396133912/posts>
 | Linkedin <https://www.linkedin.com/company/stratoscale>

--001a113ea6928d9e2e052c7dcc52
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On W=
ed, Feb 24, 2016 at 7:00 AM, Andy Grover <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:agrover@redhat.com" target=3D"_blank">agrover@redhat.com</a>&gt;</spa=
n> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;b=
order-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 02/01/2016 =
11:07 PM, Avishay Traeger wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi all,<br>
I have a system where various configurations are possible - iSCSI/FC,<br>
single paths and multiple.=C2=A0 For multiple I of course use device-mapper=
.<br>
I was wondering if it was possible to:<br>
1. use it for cases where I have a single path.<br>
2. create a monitoring process that can take some action (e.g., send a<br>
notification via message queue) in the case of some failure that would<br>
normally cause failover.<br>
</blockquote>
<br></span>
Does dm-multipath support a single path? I don&#39;t know...<br>
<br>
but for your #2, dm-multipath publishes a uevent when a path fails, maybe t=
he process could look for that? Using libudev?<br>
<br>
HTH -- Andy<br>
<br>
</blockquote></div><br>Thanks for pointing me in the right direction Andy!<=
br clear=3D"all"><div><br></div>-- <br><div class=3D"gmail_signature"><div =
dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div dir=3D"ltr"><d=
iv dir=3D"ltr"><div><b style=3D"font-size:12.7272720336914px"><font color=
=3D"#666666">Avishay Traeger, PhD</font></b><br></div><div><font color=3D"#=
666666"><i>System Architect</i></font></div><div><span style=3D"color:rgb(1=
02,102,102);font-size:12.7272720336914px"><br></span></div><div><span style=
=3D"color:rgb(102,102,102)">Mobile:</span><span style=3D"color:rgb(102,102,=
102)">=C2=A0</span><a value=3D"+972524317955" style=3D"color:rgb(17,85,204)=
">+972 54 447 1475</a><br></div><div><font color=3D"#666666">E-mail:=C2=A0<=
a href=3D"mailto:avishay@stratoscale.com" style=3D"color:rgb(17,85,204)" ta=
rget=3D"_blank">avishay@stratoscale.com</a></font></div><div><font color=3D=
"#666666"><br></font></div><div><img src=3D"http://www.stratoscale.com/wp-c=
ontent/uploads/Logo-Signature-Stratoscale-230.jpg"><br></div><div><font col=
or=3D"#666666"><br></font></div><div><p style=3D"margin:0in"><a href=3D"htt=
p://www.stratoscale.com/" style=3D"color:rgb(17,85,204)" target=3D"_blank">=
<span style=3D"font-family:arial;font-size:9.75pt">Web</span></a><span styl=
e=3D"font-family:arial;font-size:9.75pt">=C2=A0|=C2=A0</span><a href=3D"htt=
p://www.stratoscale.com/blog/" style=3D"color:rgb(17,85,204)" target=3D"_bl=
ank"><span style=3D"font-family:arial;font-size:9.75pt">Blog</span></a><spa=
n style=3D"font-family:arial;font-size:9.75pt;color:rgb(108,163,214)">=C2=
=A0|=C2=A0</span><a href=3D"https://twitter.com/Stratoscale" style=3D"color=
:rgb(17,85,204)" target=3D"_blank"><span style=3D"font-family:arial;font-si=
ze:9.75pt">Twitter</span></a><span style=3D"font-family:arial;font-size:9.7=
5pt;color:rgb(108,163,214)">=C2=A0|=C2=A0<a href=3D"https://plus.google.com=
/u/1/b/108421603458396133912/108421603458396133912/posts" style=3D"color:rg=
b(17,85,204)" target=3D"_blank">Google+</a>=C2=A0|=C2=A0</span><span style=
=3D"font-family:arial;font-size:9.75pt"><a href=3D"https://www.linkedin.com=
/company/stratoscale" style=3D"color:rgb(17,85,204)" target=3D"_blank">Link=
edin</a></span></p></div></div></div></div></div></div></div></div></div>
</div></div>

--001a113ea6928d9e2e052c7dcc52--


--===============5820425625946446225==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5820425625946446225==--
