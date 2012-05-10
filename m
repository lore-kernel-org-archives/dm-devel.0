From: Adarsh <adarshanto@gmail.com>
Subject: Identify failed device from device map & multipath -ll
Date: Thu, 10 May 2012 16:46:06 +0530
Message-ID: <CAH2zp-g7YyTnsTkn4kQ0ohB_94z0a3Qxqngz8feb=OrNvy9XsA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3961839909476822556=="
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

--===============3961839909476822556==
Content-Type: multipart/alternative; boundary=bcaec554001af79bca04bfacbe75

--bcaec554001af79bca04bfacbe75
Content-Type: text/plain; charset=ISO-8859-1

Hi All,
I have 2 paths to a device and one path becomes faulty.
How can I identify which is the failed device using command line (Eg:
/dev/sda)

360a98000572d54726c5a6a74544c684d dm-2 NETAPP,LUN
[size=200M][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=10][enabled]
 \_ 1:0:1:0  sde 8:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ #:#:#:#  -   #:#   [active][faulty]       ====> the device name is not
mentioned here

thanks in advance,
Adarsh.

--bcaec554001af79bca04bfacbe75
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,<div>I have 2 paths to a device and one path becomes faulty.</div><d=
iv>How can I identify which is the failed device using command line (Eg: /d=
ev/sda)</div><div><br></div><div><div><div>360a98000572d54726c5a6a74544c684=
d dm-2 NETAPP,LUN</div>
<div>[size=3D200M][features=3D1 queue_if_no_path][hwhandler=3D0][rw]</div><=
/div><div>\_ round-robin 0 [prio=3D10][enabled]</div><div>=A0\_ 1:0:1:0 =A0=
sde 8:64 =A0[active][ready]</div></div><div><div>\_ round-robin 0 [prio=3D0=
][enabled]</div>
<div>=A0\_ #:#:#:# =A0- =A0 #:# =A0 [active][faulty] =A0 =A0 =A0 =3D=3D=3D=
=3D&gt; the device name is not mentioned here</div></div><div><br></div><di=
v>thanks in advance,</div><div>Adarsh.</div>

--bcaec554001af79bca04bfacbe75--


--===============3961839909476822556==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3961839909476822556==--
