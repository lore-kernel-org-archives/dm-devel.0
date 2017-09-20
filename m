From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: multipath-tools 0.7.3
Date: Wed, 20 Sep 2017 19:15:43 +0200
Message-ID: <CABr-Gncov7Fb_ijSAeHRYYRrQPtonkObSNgdfqzUnnbhAfs4CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4189320120829385276=="
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

--===============4189320120829385276==
Content-Type: multipart/alternative; boundary="089e0825fb8c3fd4170559a22046"

--089e0825fb8c3fd4170559a22046
Content-Type: text/plain; charset="UTF-8"

Arnon Yaari (1):
      libmultipath: update INFINIDAT builtin config

Benjamin Marzinski (5):
      libmultipath: pull functions into util.c
      libmultipath: change reservation_key to a be64
      libmpathpersist: fix update_prflag code
      multipath: add alternate reservation_key method
      mpathpersist: add support for prkeys file

Christophe Varoqui (1):
      Bump version to 0.7.3

Gris Ge (3):
      multipath-tools: Remove the limitation of IPC command reply length.
      multipath-tools: libdmmp: Improve timeout mechanism
      multipath-tools: libdmmp: New function to flush and reconfig

Guan Junxiong (1):
      multipath-tools: fix incorrect length for strncmp in uevent.c

Hannes Reinecke (6):
      libmultipath: add pthread_cleanup hook for udev monitor
      libmultipath: sanitize fd handling
      discovery: sanitize NVMe discovery
      libmultipath/discovery: modify NVMe path states
      Add 'none' checker
      hwtable: set 'none' as default checker for NVMe

Martin Wilck (35):
      multipathd: don't flood system with sd_notify calls
      libmultipath: add_feature: skip pointless NULL check
      libmultipath: add_feature: allow only 1 feature
      kpartx/devmapper.h: remove dm_no_partitions
      libmultipath: cli_add_map: Use CMD_NONE
      multipath-tools: link internal libraries before foreigns
      libmultipath: fix partition_delimiter config option
      kpartx: helper functions for name and uuid generation
      kpartx: search partitions by UUID, and rename
      test-kpartx: add tests for renaming functionality
      kpartx: fix a corner case when renaming partitions
      kpartx: fix part deletion without partition table
      test-kpartx: test deletion with empty part table
      kpartx: only recognize dasd part table on DASD
      libmultipath: support MPATH_UDEV_NO_PATHS_FLAG on map creation
      libmultipath: add get_udev_device
      libmultipath: get_refwwid: use get_udev_device
      libmultipath: use const char* in some dm helpers
      libmultipath: add DI_NOIO flag for pathinfo
      libmultipath: add dm_get_multipath
      multipath: implement "check usable paths" (-C/-U)
      11-dm-mpath.rules: multipath -U for READY check
      11-dm-mpath.rules: import more ID_FS_xxx vars from db
      11-dm-mpath.rules: no need to test before IMPORT
      11-dm-mpath.rules: handle new maps with READY==0
      multipath.rules: set ID_FS_TYPE to "mpath_member"
      kpartx.rules: don't rely on DM_DEPS and DM_TABLE_STATE
      kpartx.rules: respect DM_UDEV_LOW_PRIORITY_FLAG
      kpartx.rules: improved logic for by-uuid and by-label links

--089e0825fb8c3fd4170559a22046
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Arnon Yaari (1):</div><div>=C2=A0 =C2=A0 =C2=A0 libmu=
ltipath: update INFINIDAT builtin config</div><div><br></div><div>Benjamin =
Marzinski (5):</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: pull functions =
into util.c</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: change reservation=
_key to a be64</div><div>=C2=A0 =C2=A0 =C2=A0 libmpathpersist: fix update_p=
rflag code</div><div>=C2=A0 =C2=A0 =C2=A0 multipath: add alternate reservat=
ion_key method</div><div>=C2=A0 =C2=A0 =C2=A0 mpathpersist: add support for=
 prkeys file</div><div><br></div><div>Christophe Varoqui (1):</div><div>=C2=
=A0 =C2=A0 =C2=A0 Bump version to 0.7.3</div><div><br></div><div>Gris Ge (3=
):</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: Remove the limitation of=
 IPC command reply length.</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: =
libdmmp: Improve timeout mechanism</div><div>=C2=A0 =C2=A0 =C2=A0 multipath=
-tools: libdmmp: New function to flush and reconfig</div><div><br></div><di=
v>Guan Junxiong (1):</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: fix in=
correct length for strncmp in uevent.c</div><div><br></div><div>Hannes Rein=
ecke (6):</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add pthread_cleanup =
hook for udev monitor</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: sanitize=
 fd handling</div><div>=C2=A0 =C2=A0 =C2=A0 discovery: sanitize NVMe discov=
ery</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath/discovery: modify NVMe path=
 states</div><div>=C2=A0 =C2=A0 =C2=A0 Add &#39;none&#39; checker</div><div=
>=C2=A0 =C2=A0 =C2=A0 hwtable: set &#39;none&#39; as default checker for NV=
Me</div><div><br></div><div>Martin Wilck (35):</div><div>=C2=A0 =C2=A0 =C2=
=A0 multipathd: don&#39;t flood system with sd_notify calls</div><div>=C2=
=A0 =C2=A0 =C2=A0 libmultipath: add_feature: skip pointless NULL check</div=
><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add_feature: allow only 1 feature<=
/div><div>=C2=A0 =C2=A0 =C2=A0 kpartx/devmapper.h: remove dm_no_partitions<=
/div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: cli_add_map: Use CMD_NONE</div=
><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: link internal libraries before =
foreigns</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: fix partition_delimit=
er config option</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: helper functions fo=
r name and uuid generation</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: search pa=
rtitions by UUID, and rename</div><div>=C2=A0 =C2=A0 =C2=A0 test-kpartx: ad=
d tests for renaming functionality</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: f=
ix a corner case when renaming partitions</div><div>=C2=A0 =C2=A0 =C2=A0 kp=
artx: fix part deletion without partition table</div><div>=C2=A0 =C2=A0 =C2=
=A0 test-kpartx: test deletion with empty part table</div><div>=C2=A0 =C2=
=A0 =C2=A0 kpartx: only recognize dasd part table on DASD</div><div>=C2=A0 =
=C2=A0 =C2=A0 libmultipath: support MPATH_UDEV_NO_PATHS_FLAG on map creatio=
n</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add get_udev_device</div><di=
v>=C2=A0 =C2=A0 =C2=A0 libmultipath: get_refwwid: use get_udev_device</div>=
<div>=C2=A0 =C2=A0 =C2=A0 libmultipath: use const char* in some dm helpers<=
/div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add DI_NOIO flag for pathinfo<=
/div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add dm_get_multipath</div><div=
>=C2=A0 =C2=A0 =C2=A0 multipath: implement &quot;check usable paths&quot; (=
-C/-U)</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: multipath -U for R=
EADY check</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: import more ID=
_FS_xxx vars from db</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: no n=
eed to test before IMPORT</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules:=
 handle new maps with READY=3D=3D0</div><div>=C2=A0 =C2=A0 =C2=A0 multipath=
.rules: set ID_FS_TYPE to &quot;mpath_member&quot;</div><div>=C2=A0 =C2=A0 =
=C2=A0 kpartx.rules: don&#39;t rely on DM_DEPS and DM_TABLE_STATE</div><div=
>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: respect DM_UDEV_LOW_PRIORITY_FLAG</div>=
<div>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: improved logic for by-uuid and by-l=
abel links</div><div><br></div></div>

--089e0825fb8c3fd4170559a22046--


--===============4189320120829385276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4189320120829385276==--
