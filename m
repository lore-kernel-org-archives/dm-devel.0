From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipath-tools 0.7.3
Date: Wed, 20 Sep 2017 19:18:24 +0200
Message-ID: <CABr-GncZ+_GR8y9YDCUYb3Ta-Pkiz=iNPgdWJJJ=x2_3RDyA0Q@mail.gmail.com>
References: <CABr-Gncov7Fb_ijSAeHRYYRrQPtonkObSNgdfqzUnnbhAfs4CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3384828331019700443=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gncov7Fb_ijSAeHRYYRrQPtonkObSNgdfqzUnnbhAfs4CA@mail.gmail.com>
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

--===============3384828331019700443==
Content-Type: multipart/alternative; boundary="94eb2c11cd46d0f7720559a2298c"

--94eb2c11cd46d0f7720559a2298c
Content-Type: text/plain; charset="UTF-8"

Oops, the shortlog was truncated.
Here it is again:

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
      kpartx.rules: create by-partuuid and by-partlabel symlinks
      kpartx.rules: generate type-name links only for multipath devices
      kpartx.rules: fix logic for adding partitions
      multipath/kpartx rules: avoid superfluous scanning
      kpartx/del-part-nodes.rules: new udev file
      kpartx.rules: move symlink code to other files

Xose Vazquez Perez (8):
      multipath-tools: minor edition and corrections in multipath.conf.5
      multipath-tools: clarify how to dump the multipathd config
      multipath-tools: replace "setting: array" with "setting: storage
device" at multipath output
      multipath-tools: remove Sun StorEdge T4(6020,6120,6320) arrays from
hwtable
      multipath-tools: add support for all arrays from Sun StorEdge 3000
family
      multipath-tools: add Xiotech iglu blaze arrays to hwtable
      multipath-tools: add Dot Hill/Seagate arrays to hwtable
      multipath-tools: add info about adding new hardware


On Wed, Sep 20, 2017 at 7:15 PM, Christophe Varoqui <
christophe.varoqui@opensvc.com> wrote:

> Arnon Yaari (1):
>       libmultipath: update INFINIDAT builtin config
>
> Benjamin Marzinski (5):
>       libmultipath: pull functions into util.c
>       libmultipath: change reservation_key to a be64
>       libmpathpersist: fix update_prflag code
>       multipath: add alternate reservation_key method
>       mpathpersist: add support for prkeys file
>
> Christophe Varoqui (1):
>       Bump version to 0.7.3
>
> Gris Ge (3):
>       multipath-tools: Remove the limitation of IPC command reply length.
>       multipath-tools: libdmmp: Improve timeout mechanism
>       multipath-tools: libdmmp: New function to flush and reconfig
>
> Guan Junxiong (1):
>       multipath-tools: fix incorrect length for strncmp in uevent.c
>
> Hannes Reinecke (6):
>       libmultipath: add pthread_cleanup hook for udev monitor
>       libmultipath: sanitize fd handling
>       discovery: sanitize NVMe discovery
>       libmultipath/discovery: modify NVMe path states
>       Add 'none' checker
>       hwtable: set 'none' as default checker for NVMe
>
> Martin Wilck (35):
>       multipathd: don't flood system with sd_notify calls
>       libmultipath: add_feature: skip pointless NULL check
>       libmultipath: add_feature: allow only 1 feature
>       kpartx/devmapper.h: remove dm_no_partitions
>       libmultipath: cli_add_map: Use CMD_NONE
>       multipath-tools: link internal libraries before foreigns
>       libmultipath: fix partition_delimiter config option
>       kpartx: helper functions for name and uuid generation
>       kpartx: search partitions by UUID, and rename
>       test-kpartx: add tests for renaming functionality
>       kpartx: fix a corner case when renaming partitions
>       kpartx: fix part deletion without partition table
>       test-kpartx: test deletion with empty part table
>       kpartx: only recognize dasd part table on DASD
>       libmultipath: support MPATH_UDEV_NO_PATHS_FLAG on map creation
>       libmultipath: add get_udev_device
>       libmultipath: get_refwwid: use get_udev_device
>       libmultipath: use const char* in some dm helpers
>       libmultipath: add DI_NOIO flag for pathinfo
>       libmultipath: add dm_get_multipath
>       multipath: implement "check usable paths" (-C/-U)
>       11-dm-mpath.rules: multipath -U for READY check
>       11-dm-mpath.rules: import more ID_FS_xxx vars from db
>       11-dm-mpath.rules: no need to test before IMPORT
>       11-dm-mpath.rules: handle new maps with READY==0
>       multipath.rules: set ID_FS_TYPE to "mpath_member"
>       kpartx.rules: don't rely on DM_DEPS and DM_TABLE_STATE
>       kpartx.rules: respect DM_UDEV_LOW_PRIORITY_FLAG
>       kpartx.rules: improved logic for by-uuid and by-label links
>
>

--94eb2c11cd46d0f7720559a2298c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Oops, the shortlog was truncated.</div><div>Here it i=
s again:</div><div><br></div><div><div class=3D"gmail-adn gmail-ads"><div c=
lass=3D"gmail-gs"><div id=3D"gmail-:61d" class=3D"gmail-ii gmail-gt gmail-a=
dP gmail-adO" style=3D"font-size:12.8px"><div id=3D"gmail-:61c" class=3D"gm=
ail-a3s gmail-aXjCH gmail-m15ea049c9d830a30"><div dir=3D"ltr"><div>Arnon Ya=
ari (1):</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: update INFINIDAT buil=
tin config</div><div><br></div><div>Benjamin Marzinski (5):</div><div>=C2=
=A0 =C2=A0 =C2=A0 libmultipath: pull functions into util.c</div><div>=C2=A0=
 =C2=A0 =C2=A0 libmultipath: change reservation_key to a be64</div><div>=C2=
=A0 =C2=A0 =C2=A0 libmpathpersist: fix update_prflag code</div><div>=C2=A0 =
=C2=A0 =C2=A0 multipath: add alternate reservation_key method</div><div>=C2=
=A0 =C2=A0 =C2=A0 mpathpersist: add support for prkeys file</div><div><br><=
/div><div>Christophe Varoqui (1):</div><div>=C2=A0 =C2=A0 =C2=A0 Bump versi=
on to 0.7.3</div><div><br></div><div>Gris Ge (3):</div><div>=C2=A0 =C2=A0 =
=C2=A0 multipath-tools: Remove the limitation of IPC command reply length.<=
/div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: libdmmp: Improve timeout me=
chanism</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: libdmmp: New functi=
on to flush and reconfig</div><div><br></div><div>Guan Junxiong (1):</div><=
div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: fix incorrect length for strncmp =
in uevent.c</div><div><br></div><div>Hannes Reinecke (6):</div><div>=C2=A0 =
=C2=A0 =C2=A0 libmultipath: add pthread_cleanup hook for udev monitor</div>=
<div>=C2=A0 =C2=A0 =C2=A0 libmultipath: sanitize fd handling</div><div>=C2=
=A0 =C2=A0 =C2=A0 discovery: sanitize NVMe discovery</div><div>=C2=A0 =C2=
=A0 =C2=A0 libmultipath/discovery: modify NVMe path states</div><div>=C2=A0=
 =C2=A0 =C2=A0 Add &#39;none&#39; checker</div><div>=C2=A0 =C2=A0 =C2=A0 hw=
table: set &#39;none&#39; as default checker for NVMe</div><div><br></div><=
div>Martin Wilck (35):</div><div>=C2=A0 =C2=A0 =C2=A0 multipathd: don&#39;t=
 flood system with sd_notify calls</div><div>=C2=A0 =C2=A0 =C2=A0 libmultip=
ath: add_feature: skip pointless NULL check</div><div>=C2=A0 =C2=A0 =C2=A0 =
libmultipath: add_feature: allow only 1 feature</div><div>=C2=A0 =C2=A0 =C2=
=A0 kpartx/devmapper.h: remove dm_no_partitions</div><div>=C2=A0 =C2=A0 =C2=
=A0 libmultipath: cli_add_map: Use CMD_NONE</div><div>=C2=A0 =C2=A0 =C2=A0 =
multipath-tools: link internal libraries before foreigns</div><div>=C2=A0 =
=C2=A0 =C2=A0 libmultipath: fix partition_delimiter config option</div><div=
>=C2=A0 =C2=A0 =C2=A0 kpartx: helper functions for name and uuid generation=
</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: search partitions by UUID, and rena=
me</div><div>=C2=A0 =C2=A0 =C2=A0 test-kpartx: add tests for renaming funct=
ionality</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: fix a corner case when rena=
ming partitions</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: fix part deletion wi=
thout partition table</div><div>=C2=A0 =C2=A0 =C2=A0 test-kpartx: test dele=
tion with empty part table</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: only reco=
gnize dasd part table on DASD</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: =
support MPATH_UDEV_NO_PATHS_FLAG on map creation</div><div>=C2=A0 =C2=A0 =
=C2=A0 libmultipath: add get_udev_device</div><div>=C2=A0 =C2=A0 =C2=A0 lib=
multipath: get_refwwid: use get_udev_device</div><div>=C2=A0 =C2=A0 =C2=A0 =
libmultipath: use const char* in some dm helpers</div><div>=C2=A0 =C2=A0 =
=C2=A0 libmultipath: add DI_NOIO flag for pathinfo</div><div>=C2=A0 =C2=A0 =
=C2=A0 libmultipath: add dm_get_multipath</div><div>=C2=A0 =C2=A0 =C2=A0 mu=
ltipath: implement &quot;check usable paths&quot; (-C/-U)</div><div>=C2=A0 =
=C2=A0 =C2=A0 11-dm-mpath.rules: multipath -U for READY check</div><div>=C2=
=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: import more ID_FS_xxx vars from db</di=
v><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: no need to test before IMPOR=
T</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: handle new maps with RE=
ADY=3D=3D0</div><div>=C2=A0 =C2=A0 =C2=A0 multipath.rules: set ID_FS_TYPE t=
o &quot;mpath_member&quot;</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: don=
&#39;t rely on DM_DEPS and DM_TABLE_STATE</div><div>=C2=A0 =C2=A0 =C2=A0 kp=
artx.rules: respect DM_UDEV_LOW_PRIORITY_FLAG</div><div>=C2=A0 =C2=A0 =C2=
=A0 kpartx.rules: improved logic for by-uuid and by-label links</div><div c=
lass=3D"gmail-yj6qo"></div></div></div></div><div class=3D"gmail-hi"></div>=
</div><div class=3D"gmail-ajx"></div></div><div class=3D"gmail-gA gmail-gt"=
 style=3D"font-size:12.8px"><div class=3D"gmail-gB gmail-acO"><div class=3D=
"gmail-ip gmail-adB"><div class=3D"gmail-M9"><div id=3D"gmail-:65t" style=
=3D"font-size:12.8px"></div></div></div></div></div></div><div><div>=C2=A0 =
=C2=A0 =C2=A0 kpartx.rules: create by-partuuid and by-partlabel symlinks</d=
iv><div>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: generate type-name links only fo=
r multipath devices</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: fix logic =
for adding partitions</div><div>=C2=A0 =C2=A0 =C2=A0 multipath/kpartx rules=
: avoid superfluous scanning</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx/del-part=
-nodes.rules: new udev file</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: mo=
ve symlink code to other files</div><div><br></div><div>Xose Vazquez Perez =
(8):</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: minor edition and corr=
ections in multipath.conf.5</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools:=
 clarify how to dump the multipathd config</div><div>=C2=A0 =C2=A0 =C2=A0 m=
ultipath-tools: replace &quot;setting: array&quot; with &quot;setting: stor=
age device&quot; at multipath output</div><div>=C2=A0 =C2=A0 =C2=A0 multipa=
th-tools: remove Sun StorEdge T4(6020,6120,6320) arrays from hwtable</div><=
div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: add support for all arrays from S=
un StorEdge 3000 family</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: add=
 Xiotech iglu blaze arrays to hwtable</div><div>=C2=A0 =C2=A0 =C2=A0 multip=
ath-tools: add Dot Hill/Seagate arrays to hwtable</div><div>=C2=A0 =C2=A0 =
=C2=A0 multipath-tools: add info about adding new hardware</div></div><div>=
<br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">O=
n Wed, Sep 20, 2017 at 7:15 PM, Christophe Varoqui <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:christophe.varoqui@opensvc.com" target=3D"_blank">christoph=
e.varoqui@opensvc.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><div dir=3D"ltr"><div>Arnon Yaari (1):</div><div>=C2=A0 =C2=A0 =C2=A0 li=
bmultipath: update INFINIDAT builtin config</div><div><br></div><div>Benjam=
in Marzinski (5):</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: pull functio=
ns into util.c</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: change reservat=
ion_key to a be64</div><div>=C2=A0 =C2=A0 =C2=A0 libmpathpersist: fix updat=
e_prflag code</div><div>=C2=A0 =C2=A0 =C2=A0 multipath: add alternate reser=
vation_key method</div><div>=C2=A0 =C2=A0 =C2=A0 mpathpersist: add support =
for prkeys file</div><div><br></div><div>Christophe Varoqui (1):</div><div>=
=C2=A0 =C2=A0 =C2=A0 Bump version to 0.7.3</div><div><br></div><div>Gris Ge=
 (3):</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: Remove the limitation=
 of IPC command reply length.</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tool=
s: libdmmp: Improve timeout mechanism</div><div>=C2=A0 =C2=A0 =C2=A0 multip=
ath-tools: libdmmp: New function to flush and reconfig</div><div><br></div>=
<div>Guan Junxiong (1):</div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: fix=
 incorrect length for strncmp in uevent.c</div><div><br></div><div>Hannes R=
einecke (6):</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add pthread_clean=
up hook for udev monitor</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: sanit=
ize fd handling</div><div>=C2=A0 =C2=A0 =C2=A0 discovery: sanitize NVMe dis=
covery</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath/discovery: modify NVMe p=
ath states</div><div>=C2=A0 =C2=A0 =C2=A0 Add &#39;none&#39; checker</div><=
div>=C2=A0 =C2=A0 =C2=A0 hwtable: set &#39;none&#39; as default checker for=
 NVMe</div><div><br></div><div>Martin Wilck (35):</div><div>=C2=A0 =C2=A0 =
=C2=A0 multipathd: don&#39;t flood system with sd_notify calls</div><div>=
=C2=A0 =C2=A0 =C2=A0 libmultipath: add_feature: skip pointless NULL check</=
div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add_feature: allow only 1 featu=
re</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx/devmapper.h: remove dm_no_partitio=
ns</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: cli_add_map: Use CMD_NONE</=
div><div>=C2=A0 =C2=A0 =C2=A0 multipath-tools: link internal libraries befo=
re foreigns</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: fix partition_deli=
miter config option</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: helper functions=
 for name and uuid generation</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx: search=
 partitions by UUID, and rename</div><div>=C2=A0 =C2=A0 =C2=A0 test-kpartx:=
 add tests for renaming functionality</div><div>=C2=A0 =C2=A0 =C2=A0 kpartx=
: fix a corner case when renaming partitions</div><div>=C2=A0 =C2=A0 =C2=A0=
 kpartx: fix part deletion without partition table</div><div>=C2=A0 =C2=A0 =
=C2=A0 test-kpartx: test deletion with empty part table</div><div>=C2=A0 =
=C2=A0 =C2=A0 kpartx: only recognize dasd part table on DASD</div><div>=C2=
=A0 =C2=A0 =C2=A0 libmultipath: support MPATH_UDEV_NO_PATHS_FLAG on map cre=
ation</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add get_udev_device</div=
><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: get_refwwid: use get_udev_device</=
div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: use const char* in some dm help=
ers</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add DI_NOIO flag for pathi=
nfo</div><div>=C2=A0 =C2=A0 =C2=A0 libmultipath: add dm_get_multipath</div>=
<div>=C2=A0 =C2=A0 =C2=A0 multipath: implement &quot;check usable paths&quo=
t; (-C/-U)</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: multipath -U f=
or READY check</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: import mor=
e ID_FS_xxx vars from db</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.rules: =
no need to test before IMPORT</div><div>=C2=A0 =C2=A0 =C2=A0 11-dm-mpath.ru=
les: handle new maps with READY=3D=3D0</div><div>=C2=A0 =C2=A0 =C2=A0 multi=
path.rules: set ID_FS_TYPE to &quot;mpath_member&quot;</div><div>=C2=A0 =C2=
=A0 =C2=A0 kpartx.rules: don&#39;t rely on DM_DEPS and DM_TABLE_STATE</div>=
<div>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: respect DM_UDEV_LOW_PRIORITY_FLAG</=
div><div>=C2=A0 =C2=A0 =C2=A0 kpartx.rules: improved logic for by-uuid and =
by-label links</div><div><br></div></div>
</blockquote></div><br></div>

--94eb2c11cd46d0f7720559a2298c--


--===============3384828331019700443==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3384828331019700443==--
