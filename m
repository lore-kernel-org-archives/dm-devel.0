From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Changing features configuration on the fly possible?
Date: Mon, 7 Jan 2013 11:18:50 +0100
Message-ID: <CAG2kNCxeMg8_oRPoBnRah6R93sFpoNdQgZDpS5Fdii4touHeVw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0981345677493249116=="
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
List-Id: dm-devel.ids

--===============0981345677493249116==
Content-Type: multipart/alternative; boundary=f46d042f9e00d23dfa04d2b02792

--f46d042f9e00d23dfa04d2b02792
Content-Type: text/plain; charset=UTF-8

Hello,
having a definition in multipath.conf such as this

devices {
        device {
                vendor                  "NETAPP"
                product                 "LUN"
...
                features                "1 queue_if_no_path"
...
                hardware_handler        "1 alua"
...
        }

is it possible to change it to
devices {
        device {
                vendor                 "NETAPP"
                product                 "LUN"
...
                features                "0"
                no_path_retry           5
                hardware_handler        "1 alua"
...
        }

and get immediately on the fly the cnages with

multipath -v2 ?
Or are these changes that require a reboot?
If the answer is yes, can it be that a former blocked device not giving
back error because of its "queue" configuration, then after the change and
5 retries now gives error to the SCSI layer?

System is RH EL 5.8 with
kernel 2.6.18-308.24.1.el5
and
device-mapper-multipath-0.4.7-48.el5_8.1

Thanks in advance,
Gianluca

--f46d042f9e00d23dfa04d2b02792
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div><div style>having a definition in multipath.con=
f such as this</div><div style><br></div><div style><div>devices {</div><di=
v>=C2=A0 =C2=A0 =C2=A0 =C2=A0 device {</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;NETAPP&quot;</div>
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;LUN&quot;</div><div=
>...</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 feat=
ures =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;1 queue_i=
f_no_path&quot;</div><div>...</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 hardware_handler =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;1 al=
ua&quot;</div>
<div>...</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 }</div><div><br></div><div s=
tyle>is it possible to change it to=C2=A0</div><div><div>devices {</div><di=
v>=C2=A0 =C2=A0 =C2=A0 =C2=A0 device {</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 &quot;NETAPP&quot;</div><div>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;LUN&quot;</div><div>...=
</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 features=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;0&quot;</div>=
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_path_retry =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 5=C2=A0</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hardware_handler =C2=A0 =C2=A0 =C2=A0 =
=C2=A0&quot;1 alua&quot;</div>
<div>...</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 }</div></div><div><br></div>=
<div style>and get immediately on the fly the cnages with=C2=A0</div><div s=
tyle><br></div><div style>multipath -v2 ?</div><div style>Or are these chan=
ges that require a reboot?</div>
<div style>If the answer is yes, can it be that a former blocked device not=
 giving back error because of its &quot;queue&quot; configuration, then aft=
er the change and 5 retries now gives error to the SCSI layer?</div><div st=
yle>
<br></div><div style>System is RH EL 5.8 with=C2=A0</div><div style>kernel=
=C2=A02.6.18-308.24.1.el5</div><div style>and</div><div style>device-mapper=
-multipath-0.4.7-48.el5_8.1<br></div><div style><br></div><div style>Thanks=
 in advance,</div>
<div style>Gianluca</div></div></div></div>

--f46d042f9e00d23dfa04d2b02792--


--===============0981345677493249116==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0981345677493249116==--
