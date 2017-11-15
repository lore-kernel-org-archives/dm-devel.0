From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: multipath-tools 0.7.4
Date: Wed, 15 Nov 2017 23:55:36 +0100
Message-ID: <CABr-GndectUC-AcsGdeB1N6h5o3LcMViKHkO8VEWtEmCEnprdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2354672528473615976=="
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

--===============2354672528473615976==
Content-Type: multipart/alternative; boundary="f403045d9d8cdad812055e0d66d6"

--f403045d9d8cdad812055e0d66d6
Content-Type: text/plain; charset="UTF-8"

Here's a shortlog of the merged patches.

Benjamin Marzinski (5):
      mpathpersist: Fix invalid condition check
      multipath: add man page info for my prkey changes
      multipath: there is no "none" path state
      mutipath: updated Huawei storage config
      multipath: fix doc typo

Christophe Varoqui (1):
      Bump version to 0.7.4

Guan Junxiong (6):
      multipath-tools: intermittent IO error accounting to improve
reliability
      multipath-tools: discard san_path_err_XXX feature
      multipath-tools: use direct IO for path latency prioritizer
      multipath-tools: move get_next_string to util
      multipath-tools: use user-friendly prio_args for path-latency
      multipath-tools: calculate standard deviation on a logarithmic scale
for prioritizer path_latency

Martin Wilck (2):
      libmultipath: ensure checker->fd == -1 if not set
      limbultipath: prefer RDAC checker with detect_checker

Michael Lass (2):
      multipathd: fix build without systemd
      multipath-tools: libdmmp: Fix build for members of samba domain

Xose Vazquez Perez (5):
      multipath-tools: add XIOtech/Magnitude to hardware table
      multipath-tools: add XIV/NEXTRA to hardware table
      multipath-tools: delete libdmmp.pc in uninstall
      multipath-tools: add TMS/RamSan to hardware table
      multipath-tools: add AccelStor/NeoSapphire to hardware table

--f403045d9d8cdad812055e0d66d6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Here&#39;s a shortlog of the merged patches.<div><div><br>=
</div><div><div>Benjamin Marzinski (5):</div><div>=C2=A0 =C2=A0 =C2=A0 mpat=
hpersist: Fix invalid condition check</div><div>=C2=A0 =C2=A0 =C2=A0 multip=
ath: add man page info for my prkey changes</div><div>=C2=A0 =C2=A0 =C2=A0 =
multipath: there is no &quot;none&quot; path state</div><div>=C2=A0 =C2=A0 =
=C2=A0 mutipath: updated Huawei storage config</div><div>=C2=A0 =C2=A0 =C2=
=A0 multipath: fix doc typo</div><div><br></div><div>Christophe Varoqui (1)=
:</div><div>=C2=A0 =C2=A0 =C2=A0 Bump version to 0.7.4</div><div><br></div>=
<div>Guan Junxiong (6):</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: int=
ermittent IO error accounting to improve reliability</div><div>=C2=A0 =C2=
=A0 =C2=A0 multipath-tools: discard san_path_err_XXX feature</div><div>=C2=
=A0 =C2=A0 =C2=A0 multipath-tools: use direct IO for path latency prioritiz=
er</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: move get_next_string to =
util</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: use user-friendly prio=
_args for path-latency</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: calc=
ulate standard deviation on a logarithmic scale for prioritizer path_latenc=
y</div><div><br></div><div>Martin Wilck (2):</div><div>=C2=A0 =C2=A0 =C2=A0=
 libmultipath: ensure checker-&gt;fd =3D=3D -1 if not set</div><div>=C2=A0 =
=C2=A0 =C2=A0 limbultipath: prefer RDAC checker with detect_checker</div><d=
iv><br></div><div>Michael Lass (2):</div><div>=C2=A0 =C2=A0 =C2=A0 multipat=
hd: fix build without systemd</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tool=
s: libdmmp: Fix build for members of samba domain</div><div><br></div><div>=
Xose Vazquez Perez (5):</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: add=
 XIOtech/Magnitude to hardware table</div><div>=C2=A0 =C2=A0 =C2=A0 multipa=
th-tools: add XIV/NEXTRA to hardware table</div><div>=C2=A0 =C2=A0 =C2=A0 m=
ultipath-tools: delete libdmmp.pc in uninstall</div><div>=C2=A0 =C2=A0 =C2=
=A0 multipath-tools: add TMS/RamSan to hardware table</div><div>=C2=A0 =C2=
=A0 =C2=A0 multipath-tools: add AccelStor/NeoSapphire to hardware table</di=
v></div><div><br></div></div></div>

--f403045d9d8cdad812055e0d66d6--


--===============2354672528473615976==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2354672528473615976==--
