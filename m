From: Avishay Traeger <avishay@stratoscale.com>
Subject: Getting device-mapper failure notifications
Date: Tue, 2 Feb 2016 09:07:11 +0200
Message-ID: <CAHph7JrC0pU+Wy7DsHeCAhz7FWuJa29qGsdv+jD3OQq4aJ1bTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0864469357347091949=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0864469357347091949==
Content-Type: multipart/alternative; boundary=001a11383ed47d4608052ac426a2

--001a11383ed47d4608052ac426a2
Content-Type: text/plain; charset=UTF-8

Hi all,
I have a system where various configurations are possible - iSCSI/FC,
single paths and multiple.  For multiple I of course use device-mapper.  I
was wondering if it was possible to:
1. use it for cases where I have a single path.
2. create a monitoring process that can take some action (e.g., send a
notification via message queue) in the case of some failure that would
normally cause failover.

Any help would be much appreciated.

Thanks,
Avishay

-- 
*Avishay Traeger, PhD*
*System Architect*

Mobile: +972 54 447 1475
E-mail: avishay@stratoscale.com



Web <http://www.stratoscale.com/> | Blog <http://www.stratoscale.com/blog/>
 | Twitter <https://twitter.com/Stratoscale> | Google+
<https://plus.google.com/u/1/b/108421603458396133912/108421603458396133912/posts>
 | Linkedin <https://www.linkedin.com/company/stratoscale>

--001a11383ed47d4608052ac426a2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<div>I have a system where various configurations a=
re possible - iSCSI/FC, single paths and multiple.=C2=A0 For multiple I of =
course use device-mapper.=C2=A0 I was wondering if it was possible to:</div=
><div>1. use it for cases where I have a single path.</div><div>2. create a=
 monitoring process that can take some action (e.g., send a notification vi=
a message queue) in the case of some failure that would normally cause fail=
over.</div><div><div><br></div><div>Any help would be much appreciated.</di=
v><div><br></div><div>Thanks,</div><div>Avishay</div><div><br></div>-- <br>=
<div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>=
<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div><b style=3D"font-si=
ze:12.7272720336914px"><font color=3D"#666666">Avishay Traeger, PhD</font><=
/b><br></div><div><font color=3D"#666666"><i>System Architect</i></font></d=
iv><div><span style=3D"color:rgb(102,102,102);font-size:12.7272720336914px"=
><br></span></div><div><span style=3D"color:rgb(102,102,102)">Mobile:</span=
><span style=3D"color:rgb(102,102,102)">=C2=A0</span><a value=3D"+972524317=
955" style=3D"color:rgb(17,85,204)">+972 54 447 1475</a><br></div><div><fon=
t color=3D"#666666">E-mail:=C2=A0<a href=3D"mailto:avishay@stratoscale.com"=
 style=3D"color:rgb(17,85,204)" target=3D"_blank">avishay@stratoscale.com</=
a></font></div><div><font color=3D"#666666"><br></font></div><div><img src=
=3D"http://www.stratoscale.com/wp-content/uploads/Logo-Signature-Stratoscal=
e-230.jpg"><br></div><div><font color=3D"#666666"><br></font></div><div><p =
style=3D"margin:0in"><a href=3D"http://www.stratoscale.com/" style=3D"color=
:rgb(17,85,204)" target=3D"_blank"><span style=3D"font-family:arial;font-si=
ze:9.75pt">Web</span></a><span style=3D"font-family:arial;font-size:9.75pt"=
>=C2=A0|=C2=A0</span><a href=3D"http://www.stratoscale.com/blog/" style=3D"=
color:rgb(17,85,204)" target=3D"_blank"><span style=3D"font-family:arial;fo=
nt-size:9.75pt">Blog</span></a><span style=3D"font-family:arial;font-size:9=
.75pt;color:rgb(108,163,214)">=C2=A0|=C2=A0</span><a href=3D"https://twitte=
r.com/Stratoscale" style=3D"color:rgb(17,85,204)" target=3D"_blank"><span s=
tyle=3D"font-family:arial;font-size:9.75pt">Twitter</span></a><span style=
=3D"font-family:arial;font-size:9.75pt;color:rgb(108,163,214)">=C2=A0|=C2=
=A0<a href=3D"https://plus.google.com/u/1/b/108421603458396133912/108421603=
458396133912/posts" style=3D"color:rgb(17,85,204)" target=3D"_blank">Google=
+</a>=C2=A0|=C2=A0</span><span style=3D"font-family:arial;font-size:9.75pt"=
><a href=3D"https://www.linkedin.com/company/stratoscale" style=3D"color:rg=
b(17,85,204)" target=3D"_blank">Linkedin</a></span></p></div></div></div></=
div></div></div></div></div></div>
</div></div>

--001a11383ed47d4608052ac426a2--


--===============0864469357347091949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0864469357347091949==--
