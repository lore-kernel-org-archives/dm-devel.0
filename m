From: Eivind Sarto <eivindsarto@gmail.com>
Subject: howto create read-only thin snapshot with lvm2app
Date: Sun, 25 Feb 2018 15:19:10 -0800
Message-ID: <CAB3weQ85OYN_drE40RNcSafL5g37XDprVbG9BzVQ3QOu4wFNAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6123722354323690266=="
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

--===============6123722354323690266==
Content-Type: multipart/alternative; boundary="f4f5e8078628f4d3d40566119ef3"

--f4f5e8078628f4d3d40566119ef3
Content-Type: text/plain; charset="UTF-8"

I am using liblvm2app to create thin snapshots by doing:
*   params = lvm_lv_params_create_snapshot(thin_lv, snapname, 0ULL);*
*   snap_lv = lvm_lv_create(params);*

The snapshots are read-write permission by default.  But, I cannot figure
out howto create a read-only snapshot.  l cannot seem to find the right
API/arguments to modify the params before calling lvm_lv_create().  What do
I need to do?

-eivind

--f4f5e8078628f4d3d40566119ef3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I am using liblvm2app to create thin snapshots by doing:<d=
iv><b style=3D"">=C2=A0 =C2=A0params =3D lvm_lv_params_create_snapshot(thin=
_lv, snapname, 0ULL);</b></div><div><b>=C2=A0 =C2=A0snap_lv =3D lvm_lv_crea=
te(params);</b></div><div><br></div><div>The snapshots are read-write permi=
ssion by default.=C2=A0 But, I cannot figure out howto create a read-only s=
napshot.=C2=A0 l cannot seem to find the right API/arguments to modify the =
params before calling lvm_lv_create().=C2=A0 What do I need to do?</div><di=
v><br></div><div>-eivind</div></div>

--f4f5e8078628f4d3d40566119ef3--


--===============6123722354323690266==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6123722354323690266==--
