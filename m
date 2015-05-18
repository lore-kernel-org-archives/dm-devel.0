From: Tejaswini Poluri <tejaswinipoluri3@gmail.com>
Subject: reinstate path not working
Date: Mon, 18 May 2015 14:09:27 +0530
Message-ID: <CAH=b03uWBZrOpVtAvifGmJxR83iNcGp5Q1KBzQBcpmsOwvpW=w@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0944046850506754166=="
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

--===============0944046850506754166==
Content-Type: multipart/alternative; boundary=20cf3011d9bbc006b00516572136

--20cf3011d9bbc006b00516572136
Content-Type: text/plain; charset=UTF-8

Hii,

We are trying to test multipath setup in our target and tried the various
commands of multipathd demaon and we find the following error:

root@x86-generic-64:~# multipathd -k"fail path sdc"; multipathd
-k'reinstate path
sdc'; multipathd -k"show paths";
[ 3962.708523] device-mapper: multipath: Failing path 8:32.
ok
ok
hcil    dev dev_t pri dm_st   chk_st   next_check
4:0:0:1 sdc 8:32  1   [active][faulty] .......... 1/20    <<<=== CHECK
5:0:0:1 sdd 8:48  1   [active][ready]  XX........ 4/20

sdc path becomes [active][ready] only after the polling interval but not
immediately after the reinstate path command.

I am observing this in latest multipath tools in ubuntu machine as well.

Please let me know if its a known issue or if I am doing something wrong.

Regards.
Tejaswini

--20cf3011d9bbc006b00516572136
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hii,<div><br></div><div>We are trying to test multipath se=
tup in our target and tried the various commands of multipathd demaon and w=
e find the following error:</div><div><br></div><div><span style=3D"font-si=
ze:12.8000001907349px">root@x86-generic-64:~# multipathd -k&quot;fail path =
sdc&quot;; multipathd -k&#39;reinstate path</span><br style=3D"font-size:12=
.8000001907349px"><span style=3D"font-size:12.8000001907349px">s</span><spa=
n style=3D"font-size:12.8000001907349px">dc&#39;; multipathd -k&quot;show p=
aths&quot;;</span></div><div><span style=3D"font-size:12.8000001907349px">[=
 3962.708523] device-mapper: multipath: Failing path=C2=A0</span><span clas=
s=3D"" tabindex=3D"0" style=3D"font-size:12.8000001907349px"><span class=3D=
"">8:32</span></span><span style=3D"font-size:12.8000001907349px">.</span><=
/div><div><span style=3D"font-size:12.8000001907349px">ok</span><br style=
=3D"font-size:12.8000001907349px"><span style=3D"font-size:12.8000001907349=
px">ok</span><br style=3D"font-size:12.8000001907349px"><span style=3D"font=
-size:12.8000001907349px">hcil=C2=A0 =C2=A0 dev dev_t pri dm_st=C2=A0 =C2=
=A0chk_st=C2=A0 =C2=A0next_check</span><br style=3D"font-size:12.8000001907=
349px"><span style=3D"font-size:12.8000001907349px">4:0:0:1 sdc=C2=A0</span=
><span class=3D"" tabindex=3D"0" style=3D"font-size:12.8000001907349px"><sp=
an class=3D"">8:32</span></span><span style=3D"font-size:12.8000001907349px=
">=C2=A0 1=C2=A0 =C2=A0[active][faulty] .......... 1/20=C2=A0 =C2=A0 &lt;&l=
t;&lt;=3D=3D=3D CHECK</span><br style=3D"font-size:12.8000001907349px"><spa=
n style=3D"font-size:12.8000001907349px">5:0:0:1 sdd=C2=A0</span><span clas=
s=3D"" tabindex=3D"0" style=3D"font-size:12.8000001907349px"><span class=3D=
"">8:48</span></span><span style=3D"font-size:12.8000001907349px">=C2=A0 1=
=C2=A0 =C2=A0[active][ready]=C2=A0 XX........ 4/20</span><br></div><div><sp=
an style=3D"font-size:12.8000001907349px"><br></span></div><div><span style=
=3D"font-size:12.8000001907349px">sdc path becomes [active][ready] only aft=
er the polling interval but not immediately after the reinstate path comman=
d.=C2=A0</span></div><div><br></div><div>I am observing this in latest mult=
ipath tools in ubuntu machine as well.</div><div><br></div><div>Please let =
me know if its a known issue or if I am doing something wrong.</div><div><b=
r></div><div>Regards.</div><div>Tejaswini</div><div><br></div><div><br></di=
v></div>

--20cf3011d9bbc006b00516572136--


--===============0944046850506754166==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0944046850506754166==--
