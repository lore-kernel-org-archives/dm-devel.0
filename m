From: <tang.junhui@zte.com.cn>
Subject: Re:
	=?utf-8?q?=5BPATCH=5D_multipath-tools=3A_improve_proce?=
	=?utf-8?q?ssing_efficiency_for_addition_and_deletion_of_multipath_?=
	=?utf-8?q?devices?=
Date: Mon, 27 Feb 2017 17:18:34 +0800 (CST)
Message-ID: <201702271718339941089@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====_001_next====="
Return-path: <dm-devel-bounces@redhat.com>
References: 1487228041-1228-1-git-send-email-tang.junhui@zte.com.cn,
	20170216162700.GU22981@octiron.msp.redhat.com,
	CABr-GndcizxvxRkB9Qc+YnrQkR8FqeOXHWBNh0c_TgSH2+3LYQ@mail.gmail.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: tang.wenjun3@zte.com.cn, zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com, mwilck@suse.com
List-Id: dm-devel.ids


--=====_001_next=====
Content-Type: multipart/related;
	boundary="=====_002_next====="


--=====_002_next=====
Content-Type: multipart/alternative;
	boundary="=====_003_next====="


--=====_003_next=====
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christophe,




OK, I'll post it later.




regards,

Tang Junhui













=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6



=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A =EF=BC=9Cchristophe.varoqui@opensvc.co=
m=EF=BC=9E
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9A =EF=BC=9Cbmarzins@redhat.com=EF=BC=9E
=E6=8A=84=E9=80=81=E4=BA=BA=EF=BC=9A=E5=94=90=E6=96=87=E4=BF=8A10144149=E5=
=94=90=E5=86=9B=E8=BE=8910074136=E5=BC=A0=E5=87=AF10072500 =EF=BC=9Cdm-deve=
l@redhat.com=EF=BC=9E =EF=BC=9Cbart.vanassche@sandisk.com=EF=BC=9E =EF=BC=
=9Cmwilck@suse.com=EF=BC=9E
=E6=97=A5 =E6=9C=9F =EF=BC=9A2017=E5=B9=B402=E6=9C=8827=E6=97=A5 14:22
=E4=B8=BB =E9=A2=98 =EF=BC=9ARe: [dm-devel] [PATCH] multipath-tools: improv=
e processing efficiency for addition and deletion of multipath devices






Hi Junhui,


It seems I did not receive the patch version Acked by Ben,Can you rebase an=
d post please ?


Thanks.




On Thu, Feb 16, 2017 at 5:27 PM, Benjamin Marzinski =EF=BC=9Cbmarzins@redha=
t.com=EF=BC=9E wrote:
On Thu, Feb 16, 2017 at 02:54:01PM +0800, tang.junhui@zte.com.cn wrote:
 =EF=BC=9E From: "tang.junhui" =EF=BC=9Ctang.junhui@zte.com.cn=EF=BC=9E
=20
 ACK
=20
 Thanks for all your work on this.
 -Ben
=20


 =EF=BC=9E
 =EF=BC=9E Change-Id: I3f81a55fff389f991f915927000b281d7e263cc5
 =EF=BC=9E Signed-off-by: tang.junhui =EF=BC=9Ctang.junhui@zte.com.cn=EF=BC=
=9E
 =EF=BC=9E
 =EF=BC=9E This patch used to improve processing efficiency for addition an=
d deletion
 =EF=BC=9E of multipath devices.
 =EF=BC=9E
 =EF=BC=9E This patch is tested pass by ZTE multipath automatic testing sys=
tem.
 =EF=BC=9E The modification reduces the system consumption(such as CPU) and=
 shortens
 =EF=BC=9E the processing time obviously in scene of massive multipath devi=
ces
 =EF=BC=9E addition or deletion.
 =EF=BC=9E
 =EF=BC=9E The main processing flow of code is:
 =EF=BC=9E 1) add uid=5Fattrs configuration in the defaults section:
 =EF=BC=9E    It is configured udev attribute which providing a unique path=
 identifier
 =EF=BC=9E    for corresponding type of path devices. If this field is conf=
igured and
 =EF=BC=9E    matched with type of device, it would override any other meth=
ods providing
 =EF=BC=9E    for device unique identifier in config file, and it would act=
ivate merging
 =EF=BC=9E    uevents according to the identifier to promote effiecncy in p=
rocessing
 =EF=BC=9E    uevents. Tt has no default value, so defaultly only uevents f=
iltering
 =EF=BC=9E    works, and uevents merging does not works, if users want to i=
dentify path
 =EF=BC=9E    by udev attribute and to activate merging uevents for SCSI an=
d DAS device,
 =EF=BC=9E    they can set it's value as:
 =EF=BC=9E    "sd:ID=5FSERIAL dasd:ID=5FUID"
 =EF=BC=9E 2) uevents accumulation in uevents burst scene:
 =EF=BC=9E    wait one seconds for more uevents in uevent=5Flisten() in uev=
ents burst
 =EF=BC=9E    situations
 =EF=BC=9E 3) uevents preparing, filtering and merging:
 =EF=BC=9E    discard unuse uevents and fetch path idendifier from uevents
 =EF=BC=9E    filter uevents
 =EF=BC=9E    merge uevents.
 =EF=BC=9E 4) uevents proccessing:
 =EF=BC=9E    proccess the merged uevents in uev-=EF=BC=9Emerge=5Fnode list=
 without calling
 =EF=BC=9E    domap()
 =EF=BC=9E    proccess the last uevents uev with calling domap().
 =EF=BC=9E ---
 =EF=BC=9E  libmultipath/config.c      |   3 +
 =EF=BC=9E  libmultipath/config.h      |   1 +
 =EF=BC=9E  libmultipath/dict.c        |   3 +
 =EF=BC=9E  libmultipath/discovery.c   |   5 +-
 =EF=BC=9E  libmultipath/discovery.h   |   2 +-
 =EF=BC=9E  libmultipath/list.h        |  41 ++++++
 =EF=BC=9E  libmultipath/propsel.c     |   7 +
 =EF=BC=9E  libmultipath/uevent.c      | 320 ++++++++++++++++++++++++++++++=
+++++++++++++--
 =EF=BC=9E  libmultipath/uevent.h      |   2 +
 =EF=BC=9E  libmultipath/util.c        |  42 ++++++
 =EF=BC=9E  libmultipath/util.h        |   1 +
 =EF=BC=9E  multipath/multipath.conf.5 |  18 +++
 =EF=BC=9E  multipathd/cli=5Fhandlers.c  |   4 +-
 =EF=BC=9E  multipathd/main.c          |  93 +++++--------
 =EF=BC=9E  multipathd/main.h          |   4 +-
 =EF=BC=9E  15 files changed, 471 insertions(+), 75 deletions(-)
 =EF=BC=9E
 =EF=BC=9E diff --git a/libmultipath/config.c b/libmultipath/config.c
 =EF=BC=9E index 15ddbd8..765e91d 100644
 =EF=BC=9E --- a/libmultipath/config.c
 =EF=BC=9E +++ b/libmultipath/config.c
 =EF=BC=9E @@ -488,6 +488,9 @@ free=5Fconfig (struct config * conf)
 =EF=BC=9E       if (conf-=EF=BC=9Euid=5Fattribute)
 =EF=BC=9E               FREE(conf-=EF=BC=9Euid=5Fattribute)
 =EF=BC=9E
 =EF=BC=9E +     if (conf-=EF=BC=9Euid=5Fattrs)
 =EF=BC=9E +             FREE(conf-=EF=BC=9Euid=5Fattrs)
 =EF=BC=9E +
 =EF=BC=9E       if (conf-=EF=BC=9Egetuid)
 =EF=BC=9E               FREE(conf-=EF=BC=9Egetuid)
 =EF=BC=9E
 =EF=BC=9E diff --git a/libmultipath/config.h b/libmultipath/config.h
 =EF=BC=9E index 9670020..ab85930 100644
 =EF=BC=9E --- a/libmultipath/config.h
 =EF=BC=9E +++ b/libmultipath/config.h
 =EF=BC=9E @@ -153,6 +153,7 @@ struct config {
 =EF=BC=9E
 =EF=BC=9E       char * multipath=5Fdir
 =EF=BC=9E       char * selector
 =EF=BC=9E +     char * uid=5Fattrs
 =EF=BC=9E       char * uid=5Fattribute
 =EF=BC=9E       char * getuid
 =EF=BC=9E       char * features
 =EF=BC=9E diff --git a/libmultipath/dict.c b/libmultipath/dict.c
 =EF=BC=9E index dc21846..0a531d1 100644
 =EF=BC=9E --- a/libmultipath/dict.c
 =EF=BC=9E +++ b/libmultipath/dict.c
 =EF=BC=9E @@ -249,6 +249,8 @@ declare=5Fovr=5Fsnprint(selector, print=5Fst=
r)
 =EF=BC=9E  declare=5Fmp=5Fhandler(selector, set=5Fstr)
 =EF=BC=9E  declare=5Fmp=5Fsnprint(selector, print=5Fstr)
 =EF=BC=9E
 =EF=BC=9E +declare=5Fdef=5Fhandler(uid=5Fattrs, set=5Fstr)
 =EF=BC=9E +declare=5Fdef=5Fsnprint(uid=5Fattrs, print=5Fstr)
 =EF=BC=9E  declare=5Fdef=5Fhandler(uid=5Fattribute, set=5Fstr)
 =EF=BC=9E  declare=5Fdef=5Fsnprint=5Fdefstr(uid=5Fattribute, print=5Fstr, =
DEFAULT=5FUID=5FATTRIBUTE)
 =EF=BC=9E  declare=5Fovr=5Fhandler(uid=5Fattribute, set=5Fstr)
 =EF=BC=9E @@ -1367,6 +1369,7 @@ init=5Fkeywords(vector keywords)
 =EF=BC=9E       install=5Fkeyword("multipath=5Fdir", &def=5Fmultipath=5Fdi=
r=5Fhandler, &snprint=5Fdef=5Fmultipath=5Fdir)
 =EF=BC=9E       install=5Fkeyword("path=5Fselector", &def=5Fselector=5Fhan=
dler, &snprint=5Fdef=5Fselector)
 =EF=BC=9E       install=5Fkeyword("path=5Fgrouping=5Fpolicy", &def=5Fpgpol=
icy=5Fhandler, &snprint=5Fdef=5Fpgpolicy)
 =EF=BC=9E +     install=5Fkeyword("uid=5Fattrs", &def=5Fuid=5Fattrs=5Fhand=
ler, &snprint=5Fdef=5Fuid=5Fattrs)
 =EF=BC=9E       install=5Fkeyword("uid=5Fattribute", &def=5Fuid=5Fattribut=
e=5Fhandler, &snprint=5Fdef=5Fuid=5Fattribute)
 =EF=BC=9E       install=5Fkeyword("getuid=5Fcallout", &def=5Fgetuid=5Fhand=
ler, &snprint=5Fdef=5Fgetuid)
 =EF=BC=9E       install=5Fkeyword("prio", &def=5Fprio=5Fname=5Fhandler, &s=
nprint=5Fdef=5Fprio=5Fname)
 =EF=BC=9E diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
 =EF=BC=9E index d1aec31..14904f2 100644
 =EF=BC=9E --- a/libmultipath/discovery.c
 =EF=BC=9E +++ b/libmultipath/discovery.c
 =EF=BC=9E @@ -33,7 +33,7 @@
 =EF=BC=9E
 =EF=BC=9E  int
 =EF=BC=9E  alloc=5Fpath=5Fwith=5Fpathinfo (struct config *conf, struct ude=
v=5Fdevice *udevice,
 =EF=BC=9E -                       int flag, struct path **pp=5Fptr)
 =EF=BC=9E +                       char *wwid, int flag, struct path **pp=
=5Fptr)
 =EF=BC=9E  {
 =EF=BC=9E       int err =3D PATHINFO=5FFAILED
 =EF=BC=9E       struct path * pp
 =EF=BC=9E @@ -51,6 +51,9 @@ alloc=5Fpath=5Fwith=5Fpathinfo (struct config =
*conf, struct udev=5Fdevice *udevice,
 =EF=BC=9E       if (!pp)
 =EF=BC=9E               return PATHINFO=5FFAILED
 =EF=BC=9E
 =EF=BC=9E +     if(wwid)
 =EF=BC=9E +             strncpy(pp-=EF=BC=9Ewwid, wwid, sizeof(pp-=EF=BC=
=9Ewwid))
 =EF=BC=9E +
 =EF=BC=9E       if (safe=5Fsprintf(pp-=EF=BC=9Edev, "%s", devname)) {
 =EF=BC=9E               condlog(0, "pp-=EF=BC=9Edev too small")
 =EF=BC=9E       } else {
 =EF=BC=9E diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
 =EF=BC=9E index 3039268..d16a69a 100644
 =EF=BC=9E --- a/libmultipath/discovery.h
 =EF=BC=9E +++ b/libmultipath/discovery.h
 =EF=BC=9E @@ -37,7 +37,7 @@ int path=5Foffline (struct path *)
 =EF=BC=9E  int get=5Fstate (struct path * pp, struct config * conf, int da=
emon)
 =EF=BC=9E  int pathinfo (struct path * pp, struct config * conf, int mask)
 =EF=BC=9E  int alloc=5Fpath=5Fwith=5Fpathinfo (struct config *conf, struct=
 udev=5Fdevice *udevice,
 =EF=BC=9E -                           int flag, struct path **pp=5Fptr)
 =EF=BC=9E +                           char *wwid, int flag, struct path **=
pp=5Fptr)
 =EF=BC=9E  int store=5Fpathinfo (vector pathvec, struct config *conf,
 =EF=BC=9E                   struct udev=5Fdevice *udevice, int flag,
 =EF=BC=9E                   struct path **pp=5Fptr)
 =EF=BC=9E diff --git a/libmultipath/list.h b/libmultipath/list.h
 =EF=BC=9E index ceaa381..2b1dcf3 100644
 =EF=BC=9E --- a/libmultipath/list.h
 =EF=BC=9E +++ b/libmultipath/list.h
 =EF=BC=9E @@ -317,4 +317,45 @@ static inline void list=5Fsplice=5Ftail=5Fi=
nit(struct list=5Fhead *list,
 =EF=BC=9E            &pos-=EF=BC=9Emember !=3D (head)                     =
               \
 =EF=BC=9E            pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.next,=
 typeof(*n), member))
 =EF=BC=9E
 =EF=BC=9E +/**
 =EF=BC=9E + * list=5Ffor=5Feach=5Fentry=5Freverse=5Fsafe - iterate backwar=
ds over list of given type safe against removal of list entry
 =EF=BC=9E + * @pos:     the type * to use as a loop counter.
 =EF=BC=9E + * @n:               another type * to use as temporary storage
 =EF=BC=9E + * @head:    the head for your list.
 =EF=BC=9E + * @member:  the name of the list=5Fstruct within the struct.
 =EF=BC=9E + */
 =EF=BC=9E +#define list=5Ffor=5Feach=5Fentry=5Freverse=5Fsafe(pos, n, head=
, member)          \
 =EF=BC=9E +     for (pos =3D list=5Fentry((head)-=EF=BC=9Eprev, typeof(*po=
s), member),      \
 =EF=BC=9E +              n =3D list=5Fentry(pos-=EF=BC=9Emember.prev, type=
of(*pos), member)\
 =EF=BC=9E +          &pos-=EF=BC=9Emember !=3D (head)                     =
               \
 =EF=BC=9E +          pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.prev,=
 typeof(*n), member))
 =EF=BC=9E +
 =EF=BC=9E +/**
 =EF=BC=9E + * list=5Ffor=5Fsome=5Fentry=5Fsafe - iterate list from the giv=
en begin node to the given end node safe against removal of list entry
 =EF=BC=9E + * @pos:     the type * to use as a loop counter.
 =EF=BC=9E + * @n:               another type * to use as temporary storage
 =EF=BC=9E + * @from:    the begin node of the iteration.
 =EF=BC=9E + * @to:              the end node of the iteration.
 =EF=BC=9E + * @member:  the name of the list=5Fstruct within the struct.
 =EF=BC=9E + */
 =EF=BC=9E +#define list=5Ffor=5Fsome=5Fentry=5Fsafe(pos, n, from, to, memb=
er)              \
 =EF=BC=9E +     for (pos =3D list=5Fentry((from)-=EF=BC=9Enext, typeof(*po=
s), member),      \
 =EF=BC=9E +          n =3D list=5Fentry(pos-=EF=BC=9Emember.next, typeof(*=
pos), member)    \
 =EF=BC=9E +          &pos-=EF=BC=9Emember !=3D (to)                       =
               \
 =EF=BC=9E +          pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.next,=
 typeof(*n), member))
 =EF=BC=9E +
 =EF=BC=9E +/**
 =EF=BC=9E + * list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe - iterate backwar=
ds list from the given begin node to the given end node safe against remova=
l of list entry
 =EF=BC=9E + * @pos:     the type * to use as a loop counter.
 =EF=BC=9E + * @n:               another type * to use as temporary storage
 =EF=BC=9E + * @from:    the begin node of the iteration.
 =EF=BC=9E + * @to:              the end node of the iteration.
 =EF=BC=9E + * @member:  the name of the list=5Fstruct within the struct.
 =EF=BC=9E + */
 =EF=BC=9E +#define list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(pos, n, from=
, to, member)      \
 =EF=BC=9E +     for (pos =3D list=5Fentry((from)-=EF=BC=9Eprev, typeof(*po=
s), member),      \
 =EF=BC=9E +          n =3D list=5Fentry(pos-=EF=BC=9Emember.prev, typeof(*=
pos), member)    \
 =EF=BC=9E +          &pos-=EF=BC=9Emember !=3D (to)                       =
               \
 =EF=BC=9E +          pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.prev,=
 typeof(*n), member))
 =EF=BC=9E +
 =EF=BC=9E  #endif /* =5FLIST=5FH */
 =EF=BC=9E diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
 =EF=BC=9E index c0bc616..c47bd08 100644
 =EF=BC=9E --- a/libmultipath/propsel.c
 =EF=BC=9E +++ b/libmultipath/propsel.c
 =EF=BC=9E @@ -18,6 +18,7 @@
 =EF=BC=9E  #include "prio.h"
 =EF=BC=9E  #include "discovery.h"
 =EF=BC=9E  #include "dict.h"
 =EF=BC=9E +#include "util.h"
 =EF=BC=9E  #include "prioritizers/alua=5Frtpg.h"
 =EF=BC=9E  #include =EF=BC=9Cinttypes.h=EF=BC=9E
 =EF=BC=9E
 =EF=BC=9E @@ -339,6 +340,12 @@ int select=5Fgetuid(struct config *conf, st=
ruct path *pp)
 =EF=BC=9E  {
 =EF=BC=9E       char *origin
 =EF=BC=9E
 =EF=BC=9E +     pp-=EF=BC=9Euid=5Fattribute =3D parse=5Fuid=5Fattribute=5F=
by=5Fattrs(conf-=EF=BC=9Euid=5Fattrs, pp-=EF=BC=9Edev)
 =EF=BC=9E +     if (pp-=EF=BC=9Euid=5Fattribute) {
 =EF=BC=9E +             origin =3D "(setting: multipath.conf defaults sect=
ion)"
 =EF=BC=9E +             goto out
 =EF=BC=9E +     }
 =EF=BC=9E +
 =EF=BC=9E       pp=5Fset=5Fovr(getuid)
 =EF=BC=9E       pp=5Fset=5Fovr(uid=5Fattribute)
 =EF=BC=9E       pp=5Fset=5Fhwe(getuid)
 =EF=BC=9E diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
 =EF=BC=9E index 7edcce1..6e2527b 100644
 =EF=BC=9E --- a/libmultipath/uevent.c
 =EF=BC=9E +++ b/libmultipath/uevent.c
 =EF=BC=9E @@ -24,6 +24,7 @@
 =EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Cunistd.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Cstdio.h=EF=BC=9E
 =EF=BC=9E +#include =EF=BC=9Cstdbool.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Cerrno.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Cstdlib.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Cstddef.h=EF=BC=9E
 =EF=BC=9E @@ -38,6 +39,7 @@
 =EF=BC=9E  #include =EF=BC=9Clinux/netlink.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Cpthread.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Csys/mman.h=EF=BC=9E
 =EF=BC=9E +#include =EF=BC=9Csys/time.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Clibudev.h=EF=BC=9E
 =EF=BC=9E  #include =EF=BC=9Cerrno.h=EF=BC=9E
 =EF=BC=9E
 =EF=BC=9E @@ -46,6 +48,14 @@
 =EF=BC=9E  #include "list.h"
 =EF=BC=9E  #include "uevent.h"
 =EF=BC=9E  #include "vector.h"
 =EF=BC=9E +#include "structs.h"
 =EF=BC=9E +#include "util.h"
 =EF=BC=9E +#include "config.h"
 =EF=BC=9E +#include "blacklist.h"
 =EF=BC=9E +
 =EF=BC=9E +#define MAX=5FACCUMULATION=5FCOUNT 2048
 =EF=BC=9E +#define MAX=5FACCUMULATION=5FTIME 30*1000
 =EF=BC=9E +#define MIN=5FBURST=5FSPEED 10
 =EF=BC=9E
 =EF=BC=9E  typedef int (uev=5Ftrigger)(struct uevent *, void * trigger=5Fd=
ata)
 =EF=BC=9E
 =EF=BC=9E @@ -72,48 +82,301 @@ struct uevent * alloc=5Fuevent (void)
 =EF=BC=9E  {
 =EF=BC=9E       struct uevent *uev =3D MALLOC(sizeof(struct uevent))
 =EF=BC=9E
 =EF=BC=9E -     if (uev)
 =EF=BC=9E +     if (uev) {
 =EF=BC=9E               INIT=5FLIST=5FHEAD(&uev-=EF=BC=9Enode)
 =EF=BC=9E +             INIT=5FLIST=5FHEAD(&uev-=EF=BC=9Emerge=5Fnode)
 =EF=BC=9E +     }
 =EF=BC=9E
 =EF=BC=9E       return uev
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E  void
 =EF=BC=9E -service=5Fuevq(struct list=5Fhead *tmpq)
 =EF=BC=9E +uevq=5Fcleanup(struct list=5Fhead *tmpq)
 =EF=BC=9E  {
 =EF=BC=9E       struct uevent *uev, *tmp
 =EF=BC=9E
 =EF=BC=9E       list=5Ffor=5Feach=5Fentry=5Fsafe(uev, tmp, tmpq, node) {
 =EF=BC=9E               list=5Fdel=5Finit(&uev-=EF=BC=9Enode)
 =EF=BC=9E
 =EF=BC=9E -             if (my=5Fuev=5Ftrigger && my=5Fuev=5Ftrigger(uev, =
my=5Ftrigger=5Fdata))
 =EF=BC=9E -                     condlog(0, "uevent trigger error")
 =EF=BC=9E -
 =EF=BC=9E               if (uev-=EF=BC=9Eudev)
 =EF=BC=9E                       udev=5Fdevice=5Funref(uev-=EF=BC=9Eudev)
 =EF=BC=9E               FREE(uev)
 =EF=BC=9E       }
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E -static void uevent=5Fcleanup(void *arg)
 =EF=BC=9E +void
 =EF=BC=9E +uevent=5Fget=5Fwwid(struct uevent *uev)
 =EF=BC=9E  {
 =EF=BC=9E -     struct udev *udev =3D arg
 =EF=BC=9E +     int i
 =EF=BC=9E +     char *uid=5Fattribute
 =EF=BC=9E +     struct config * conf
 =EF=BC=9E
 =EF=BC=9E -     condlog(3, "Releasing uevent=5Flisten() resources")
 =EF=BC=9E -     udev=5Funref(udev)
 =EF=BC=9E +     conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E +     uid=5Fattribute =3D parse=5Fuid=5Fattribute=5Fby=5Fattrs(c=
onf-=EF=BC=9Euid=5Fattrs, uev-=EF=BC=9Ekernel)
 =EF=BC=9E +     put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E +
 =EF=BC=9E +     if (!uid=5Fattribute)
 =EF=BC=9E +             return
 =EF=BC=9E +
 =EF=BC=9E +     for (i =3D 0 uev-=EF=BC=9Eenvp[i] !=3D NULL i++) {
 =EF=BC=9E +             if (!strncmp(uev-=EF=BC=9Eenvp[i], uid=5Fattribute=
, strlen(uid=5Fattribute)) &&
 =EF=BC=9E +                 strlen(uev-=EF=BC=9Eenvp[i]) =EF=BC=9E strlen(=
uid=5Fattribute) &&
 =EF=BC=9E +                 uev-=EF=BC=9Eenvp[i][strlen(uid=5Fattribute)] =
=3D=3D '=3D') {
 =EF=BC=9E +                     uev-=EF=BC=9Ewwid =3D uev-=EF=BC=9Eenvp[i]=
 + strlen(uid=5Fattribute) + 1
 =EF=BC=9E +                     break
 =EF=BC=9E +             }
 =EF=BC=9E +     }
 =EF=BC=9E +     free(uid=5Fattribute)
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +bool
 =EF=BC=9E +uevent=5Fneed=5Fmerge(void)
 =EF=BC=9E +{
 =EF=BC=9E +     struct config * conf
 =EF=BC=9E +     bool need=5Fmerge =3D false
 =EF=BC=9E +
 =EF=BC=9E +     conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E +     if (conf-=EF=BC=9Euid=5Fattrs)
 =EF=BC=9E +             need=5Fmerge =3D true
 =EF=BC=9E +     put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E +
 =EF=BC=9E +     return need=5Fmerge
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +bool
 =EF=BC=9E +uevent=5Fcan=5Fdiscard(struct uevent *uev)
 =EF=BC=9E +{
 =EF=BC=9E +     char *tmp
 =EF=BC=9E +     char a[11], b[11]
 =EF=BC=9E +     struct config * conf
 =EF=BC=9E +
 =EF=BC=9E +     /*
 =EF=BC=9E +      * keep only block devices, discard partitions
 =EF=BC=9E +      */
 =EF=BC=9E +     tmp =3D strstr(uev-=EF=BC=9Edevpath, "/block/")
 =EF=BC=9E +     if (tmp =3D=3D NULL){
 =EF=BC=9E +             condlog(4, "no /block/ in '%s'", uev-=EF=BC=9Edevp=
ath)
 =EF=BC=9E +             return true
 =EF=BC=9E +     }
 =EF=BC=9E +     if (sscanf(tmp, "/block/%10s", a) !=3D 1 ||
 =EF=BC=9E +         sscanf(tmp, "/block/%10[^/]/%10s", a, b) =3D=3D 2) {
 =EF=BC=9E +             condlog(4, "discard event on %s", uev-=EF=BC=9Edev=
path)
 =EF=BC=9E +             return true
 =EF=BC=9E +     }
 =EF=BC=9E +
 =EF=BC=9E +     /*
 =EF=BC=9E +      * do not filter dm devices by devnode
 =EF=BC=9E +      */
 =EF=BC=9E +     if (!strncmp(uev-=EF=BC=9Ekernel, "dm-", 3))
 =EF=BC=9E +             return false
 =EF=BC=9E +     /*
 =EF=BC=9E +      * filter paths devices by devnode
 =EF=BC=9E +      */
 =EF=BC=9E +     conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E +     if (filter=5Fdevnode(conf-=EF=BC=9Eblist=5Fdevnode, conf-=
=EF=BC=9Eelist=5Fdevnode,
 =EF=BC=9E +                        uev-=EF=BC=9Ekernel) =EF=BC=9E 0) {
 =EF=BC=9E +             put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E +             return true
 =EF=BC=9E +     }
 =EF=BC=9E +     put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E +
 =EF=BC=9E +     return false
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +bool
 =EF=BC=9E +uevent=5Fcan=5Ffilter(struct uevent *earlier, struct uevent *la=
ter)
 =EF=BC=9E +{
 =EF=BC=9E +
 =EF=BC=9E +     /*
 =EF=BC=9E +      * filter earlier uvents if path has removed later. Eg:
 =EF=BC=9E +      * "add path1 |chang path1 |add path2 |remove path1"
 =EF=BC=9E +      * can filter as:
 =EF=BC=9E +      * "add path2 |remove path1"
 =EF=BC=9E +      * uevents "add path1" and "chang path1" are filtered out
 =EF=BC=9E +      */
 =EF=BC=9E +     if (!strcmp(earlier-=EF=BC=9Ekernel, later-=EF=BC=9Ekernel=
) &&
 =EF=BC=9E +             !strcmp(later-=EF=BC=9Eaction, "remove") &&
 =EF=BC=9E +             strncmp(later-=EF=BC=9Ekernel, "dm-", 3)) {
 =EF=BC=9E +             return true
 =EF=BC=9E +     }
 =EF=BC=9E +
 =EF=BC=9E +     /*
 =EF=BC=9E +      * filter change uvents if add uevents exist. Eg:
 =EF=BC=9E +      * "change path1| add path1 |add path2"
 =EF=BC=9E +      * can filter as:
 =EF=BC=9E +      * "add path1 |add path2"
 =EF=BC=9E +      * uevent "chang path1" is filtered out
 =EF=BC=9E +      */
 =EF=BC=9E +     if (!strcmp(earlier-=EF=BC=9Ekernel, later-=EF=BC=9Ekernel=
) &&
 =EF=BC=9E +             !strcmp(earlier-=EF=BC=9Eaction, "change") &&
 =EF=BC=9E +             !strcmp(later-=EF=BC=9Eaction, "add") &&
 =EF=BC=9E +             strncmp(later-=EF=BC=9Ekernel, "dm-", 3)) {
 =EF=BC=9E +             return true
 =EF=BC=9E +     }
 =EF=BC=9E +
 =EF=BC=9E +     return false
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +bool
 =EF=BC=9E +merge=5Fneed=5Fstop(struct uevent *earlier, struct uevent *late=
r)
 =EF=BC=9E +{
 =EF=BC=9E +     /*
 =EF=BC=9E +      * dm uevent do not try to merge with left uevents
 =EF=BC=9E +      */
 =EF=BC=9E +     if (!strncmp(later-=EF=BC=9Ekernel, "dm-", 3))
 =EF=BC=9E +             return true
 =EF=BC=9E +
 =EF=BC=9E +     /*
 =EF=BC=9E +      * we can not make a jugement without wwid,
 =EF=BC=9E +      * so it is sensible to stop merging
 =EF=BC=9E +      */
 =EF=BC=9E +     if (!earlier-=EF=BC=9Ewwid || !later-=EF=BC=9Ewwid)
 =EF=BC=9E +             return true
 =EF=BC=9E +     /*
 =EF=BC=9E +      * uevents merging stoped
 =EF=BC=9E +      * when we meet an opposite action uevent from the same LU=
N to AVOID
 =EF=BC=9E +      * "add path1 |remove path1 |add path2 |remove path2 |add =
path3"
 =EF=BC=9E +      * to merge as "remove path1, path2" and "add path1, path2=
, path3"
 =EF=BC=9E +      * OR
 =EF=BC=9E +      * "remove path1 |add path1 |remove path2 |add path2 |remo=
ve path3"
 =EF=BC=9E +      * to merge as "add path1, path2" and "remove path1, path2=
, path3"
 =EF=BC=9E +      * SO
 =EF=BC=9E +      * when we meet a non-change uevent from the same LUN
 =EF=BC=9E +      * with the same wwid and different action
 =EF=BC=9E +      * it would be better to stop merging.
 =EF=BC=9E +      */
 =EF=BC=9E +     if (!strcmp(earlier-=EF=BC=9Ewwid, later-=EF=BC=9Ewwid) &&
 =EF=BC=9E +         strcmp(earlier-=EF=BC=9Eaction, later-=EF=BC=9Eaction)=
 &&
 =EF=BC=9E +         strcmp(earlier-=EF=BC=9Eaction, "change") &&
 =EF=BC=9E +         strcmp(later-=EF=BC=9Eaction, "change"))
 =EF=BC=9E +             return true
 =EF=BC=9E +
 =EF=BC=9E +     return false
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +bool
 =EF=BC=9E +uevent=5Fcan=5Fmerge(struct uevent *earlier, struct uevent *lat=
er)
 =EF=BC=9E +{
 =EF=BC=9E +     /* merge paths uevents
 =EF=BC=9E +      * whose wwids exsit and are same
 =EF=BC=9E +      * and actions are same,
 =EF=BC=9E +      * and actions are addition or deletion
 =EF=BC=9E +      */
 =EF=BC=9E +     if (earlier-=EF=BC=9Ewwid && later-=EF=BC=9Ewwid &&
 =EF=BC=9E +         !strcmp(earlier-=EF=BC=9Ewwid, later-=EF=BC=9Ewwid) &&
 =EF=BC=9E +         !strcmp(earlier-=EF=BC=9Eaction, later-=EF=BC=9Eaction=
) &&
 =EF=BC=9E +         strncmp(earlier-=EF=BC=9Eaction, "change", 6) &&
 =EF=BC=9E +         strncmp(earlier-=EF=BC=9Ekernel, "dm-", 3)) {
 =EF=BC=9E +             return true
 =EF=BC=9E +     }
 =EF=BC=9E +
 =EF=BC=9E +     return false
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E  void
 =EF=BC=9E -uevq=5Fcleanup(struct list=5Fhead *tmpq)
 =EF=BC=9E +uevent=5Fprepare(struct list=5Fhead *tmpq)
 =EF=BC=9E +{
 =EF=BC=9E +     struct uevent *uev, *tmp
 =EF=BC=9E +
 =EF=BC=9E +     list=5Ffor=5Feach=5Fentry=5Freverse=5Fsafe(uev, tmp, tmpq,=
 node) {
 =EF=BC=9E +             if (uevent=5Fcan=5Fdiscard(uev)) {
 =EF=BC=9E +                     list=5Fdel=5Finit(&uev-=EF=BC=9Enode)
 =EF=BC=9E +                     if (uev-=EF=BC=9Eudev)
 =EF=BC=9E +                             udev=5Fdevice=5Funref(uev-=EF=BC=
=9Eudev)
 =EF=BC=9E +                     FREE(uev)
 =EF=BC=9E +                     continue
 =EF=BC=9E +             }
 =EF=BC=9E +
 =EF=BC=9E +             if (strncmp(uev-=EF=BC=9Ekernel, "dm-", 3) &&
 =EF=BC=9E +                 uevent=5Fneed=5Fmerge())
 =EF=BC=9E +                     uevent=5Fget=5Fwwid(uev)
 =EF=BC=9E +     }
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +void
 =EF=BC=9E +uevent=5Ffilter(struct uevent *later, struct list=5Fhead *tmpq)
 =EF=BC=9E +{
 =EF=BC=9E +     struct uevent *earlier, *tmp
 =EF=BC=9E +
 =EF=BC=9E +     list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(earlier, tmp, &=
later-=EF=BC=9Enode, tmpq, node) {
 =EF=BC=9E +             /*
 =EF=BC=9E +              * filter unnessary earlier uevents
 =EF=BC=9E +              * by the later uevent
 =EF=BC=9E +              */
 =EF=BC=9E +             if (uevent=5Fcan=5Ffilter(earlier, later)) {
 =EF=BC=9E +                     condlog(2, "uevent: %s-%s has filtered by =
uevent: %s-%s",
 =EF=BC=9E +                             earlier-=EF=BC=9Ekernel, earlier-=
=EF=BC=9Eaction,
 =EF=BC=9E +                             later-=EF=BC=9Ekernel, later-=EF=
=BC=9Eaction)
 =EF=BC=9E +
 =EF=BC=9E +                     list=5Fdel=5Finit(&earlier-=EF=BC=9Enode)
 =EF=BC=9E +                     if (earlier-=EF=BC=9Eudev)
 =EF=BC=9E +                             udev=5Fdevice=5Funref(earlier-=EF=
=BC=9Eudev)
 =EF=BC=9E +                     FREE(earlier)
 =EF=BC=9E +             }
 =EF=BC=9E +     }
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +void
 =EF=BC=9E +uevent=5Fmerge(struct uevent *later, struct list=5Fhead *tmpq)
 =EF=BC=9E +{
 =EF=BC=9E +     struct uevent *earlier, *tmp
 =EF=BC=9E +
 =EF=BC=9E +     list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(earlier, tmp, &=
later-=EF=BC=9Enode, tmpq, node) {
 =EF=BC=9E +             if (merge=5Fneed=5Fstop(earlier, later))
 =EF=BC=9E +                     break
 =EF=BC=9E +             /*
 =EF=BC=9E +              * merge earlier uevents to the later uevent
 =EF=BC=9E +              */
 =EF=BC=9E +             if (uevent=5Fcan=5Fmerge(earlier, later)) {
 =EF=BC=9E +                     condlog(2, "merged uevent: %s-%s-%s with u=
event: %s-%s-%s",
 =EF=BC=9E +                             earlier-=EF=BC=9Eaction, earlier-=
=EF=BC=9Ekernel, earlier-=EF=BC=9Ewwid,
 =EF=BC=9E +                             later-=EF=BC=9Eaction, later-=EF=
=BC=9Ekernel, later-=EF=BC=9Ewwid)
 =EF=BC=9E +
 =EF=BC=9E +                     list=5Fmove(&earlier-=EF=BC=9Enode, &later=
-=EF=BC=9Emerge=5Fnode)
 =EF=BC=9E +             }
 =EF=BC=9E +     }
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +void
 =EF=BC=9E +merge=5Fuevq(struct list=5Fhead *tmpq)
 =EF=BC=9E +{
 =EF=BC=9E +     struct uevent *later
 =EF=BC=9E +
 =EF=BC=9E +     uevent=5Fprepare(tmpq)
 =EF=BC=9E +     list=5Ffor=5Feach=5Fentry=5Freverse(later, tmpq, node) {
 =EF=BC=9E +             uevent=5Ffilter(later, tmpq)
 =EF=BC=9E +             if(uevent=5Fneed=5Fmerge())
 =EF=BC=9E +                     uevent=5Fmerge(later, tmpq)
 =EF=BC=9E +     }
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E +void
 =EF=BC=9E +service=5Fuevq(struct list=5Fhead *tmpq)
 =EF=BC=9E  {
 =EF=BC=9E       struct uevent *uev, *tmp
 =EF=BC=9E
 =EF=BC=9E       list=5Ffor=5Feach=5Fentry=5Fsafe(uev, tmp, tmpq, node) {
 =EF=BC=9E               list=5Fdel=5Finit(&uev-=EF=BC=9Enode)
 =EF=BC=9E +
 =EF=BC=9E +             if (my=5Fuev=5Ftrigger && my=5Fuev=5Ftrigger(uev, =
my=5Ftrigger=5Fdata))
 =EF=BC=9E +                     condlog(0, "uevent trigger error")
 =EF=BC=9E +
 =EF=BC=9E +             uevq=5Fcleanup(&uev-=EF=BC=9Emerge=5Fnode)
 =EF=BC=9E +
 =EF=BC=9E +             if (uev-=EF=BC=9Eudev)
 =EF=BC=9E +                     udev=5Fdevice=5Funref(uev-=EF=BC=9Eudev)
 =EF=BC=9E               FREE(uev)
 =EF=BC=9E       }
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E +static void uevent=5Fcleanup(void *arg)
 =EF=BC=9E +{
 =EF=BC=9E +     struct udev *udev =3D arg
 =EF=BC=9E +
 =EF=BC=9E +     condlog(3, "Releasing uevent=5Flisten() resources")
 =EF=BC=9E +     udev=5Funref(udev)
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E  /*
 =EF=BC=9E   * Service the uevent queue.
 =EF=BC=9E   */
 =EF=BC=9E @@ -142,6 +405,7 @@ int uevent=5Fdispatch(int (*uev=5Ftrigger)(s=
truct uevent *, void * trigger=5Fdata),
 =EF=BC=9E               pthread=5Fmutex=5Funlock(uevq=5Flockp)
 =EF=BC=9E               if (!my=5Fuev=5Ftrigger)
 =EF=BC=9E                       break
 =EF=BC=9E +             merge=5Fuevq(&uevq=5Ftmp)
 =EF=BC=9E               service=5Fuevq(&uevq=5Ftmp)
 =EF=BC=9E       }
 =EF=BC=9E       condlog(3, "Terminating uev service queue")
 =EF=BC=9E @@ -442,11 +706,43 @@ struct uevent *uevent=5Ffrom=5Fudev=5Fdevi=
ce(struct udev=5Fdevice *dev)
 =EF=BC=9E       return uev
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E +bool uevent=5Fburst(struct timeval *start=5Ftime, int events)
 =EF=BC=9E +{
 =EF=BC=9E +     struct timeval diff=5Ftime, end=5Ftime
 =EF=BC=9E +     unsigned long speed
 =EF=BC=9E +     unsigned long eclipse=5Fms
 =EF=BC=9E +
 =EF=BC=9E +     if(events =EF=BC=9E MAX=5FACCUMULATION=5FCOUNT) {
 =EF=BC=9E +             condlog(2, "burst got %u uevents, too much uevents=
, stopped", events)
 =EF=BC=9E +             return false
 =EF=BC=9E +     }
 =EF=BC=9E +
 =EF=BC=9E +     gettimeofday(&end=5Ftime, NULL)
 =EF=BC=9E +     timersub(&end=5Ftime, start=5Ftime, &diff=5Ftime)
 =EF=BC=9E +
 =EF=BC=9E +     eclipse=5Fms =3D diff=5Ftime.tv=5Fsec * 1000 + diff=5Ftime=
.tv=5Fusec / 1000
 =EF=BC=9E +
 =EF=BC=9E +     if (eclipse=5Fms =3D=3D 0)
 =EF=BC=9E +             return true
 =EF=BC=9E +
 =EF=BC=9E +     if (eclipse=5Fms =EF=BC=9E MAX=5FACCUMULATION=5FTIME) {
 =EF=BC=9E +             condlog(2, "burst continued %lu ms, too long time,=
 stopped", eclipse=5Fms)
 =EF=BC=9E +             return false
 =EF=BC=9E +     }
 =EF=BC=9E +
 =EF=BC=9E +     speed =3D (events * 1000) / eclipse=5Fms
 =EF=BC=9E +     if (speed =EF=BC=9E MIN=5FBURST=5FSPEED)
 =EF=BC=9E +             return true
 =EF=BC=9E +
 =EF=BC=9E +     return false
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E  int uevent=5Flisten(struct udev *udev)
 =EF=BC=9E  {
 =EF=BC=9E       int err =3D 2
 =EF=BC=9E       struct udev=5Fmonitor *monitor =3D NULL
 =EF=BC=9E       int fd, socket=5Fflags, events
 =EF=BC=9E +     struct timeval start=5Ftime
 =EF=BC=9E       int need=5Ffailback =3D 1
 =EF=BC=9E       int timeout =3D 30
 =EF=BC=9E       LIST=5FHEAD(uevlisten=5Ftmp)
 =EF=BC=9E @@ -500,6 +796,7 @@ int uevent=5Flisten(struct udev *udev)
 =EF=BC=9E       }
 =EF=BC=9E
 =EF=BC=9E       events =3D 0
 =EF=BC=9E +     gettimeofday(&start=5Ftime, NULL)
 =EF=BC=9E       while (1) {
 =EF=BC=9E               struct uevent *uev
 =EF=BC=9E               struct udev=5Fdevice *dev
 =EF=BC=9E @@ -514,7 +811,7 @@ int uevent=5Flisten(struct udev *udev)
 =EF=BC=9E               errno =3D 0
 =EF=BC=9E               fdcount =3D poll(&ev=5Fpoll, 1, poll=5Ftimeout)
 =EF=BC=9E               if (fdcount && ev=5Fpoll.revents & POLLIN) {
 =EF=BC=9E -                     timeout =3D 0
 =EF=BC=9E +                     timeout =3D uevent=5Fburst(&start=5Ftime, =
events + 1) ? 1 : 0
 =EF=BC=9E                       dev =3D udev=5Fmonitor=5Freceive=5Fdevice(=
monitor)
 =EF=BC=9E                       if (!dev) {
 =EF=BC=9E                               condlog(0, "failed getting udev de=
vice")
 =EF=BC=9E @@ -547,6 +844,7 @@ int uevent=5Flisten(struct udev *udev)
 =EF=BC=9E                       pthread=5Fmutex=5Funlock(uevq=5Flockp)
 =EF=BC=9E                       events =3D 0
 =EF=BC=9E               }
 =EF=BC=9E +             gettimeofday(&start=5Ftime, NULL)
 =EF=BC=9E               timeout =3D 30
 =EF=BC=9E       }
 =EF=BC=9E       need=5Ffailback =3D 0
 =EF=BC=9E diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
 =EF=BC=9E index 9d22dcd..61a4207 100644
 =EF=BC=9E --- a/libmultipath/uevent.h
 =EF=BC=9E +++ b/libmultipath/uevent.h
 =EF=BC=9E @@ -17,11 +17,13 @@ struct udev
 =EF=BC=9E
 =EF=BC=9E  struct uevent {
 =EF=BC=9E       struct list=5Fhead node
 =EF=BC=9E +     struct list=5Fhead merge=5Fnode
 =EF=BC=9E       struct udev=5Fdevice *udev
 =EF=BC=9E       char buffer[HOTPLUG=5FBUFFER=5FSIZE + OBJECT=5FSIZE]
 =EF=BC=9E       char *devpath
 =EF=BC=9E       char *action
 =EF=BC=9E       char *kernel
 =EF=BC=9E +     char *wwid
 =EF=BC=9E       unsigned long seqnum
 =EF=BC=9E       char *envp[HOTPLUG=5FNUM=5FENVP]
 =EF=BC=9E  }
 =EF=BC=9E diff --git a/libmultipath/util.c b/libmultipath/util.c
 =EF=BC=9E index 03a5738..e1e83cf 100644
 =EF=BC=9E --- a/libmultipath/util.c
 =EF=BC=9E +++ b/libmultipath/util.c
 =EF=BC=9E @@ -261,6 +261,48 @@ dev=5Ft parse=5Fdevt(const char *dev=5Ft)
 =EF=BC=9E       return makedev(maj, min)
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E +char *parse=5Fuid=5Fattribute=5Fby=5Fattrs(char *uid=5Fattrs, c=
har *path=5Fdev)
 =EF=BC=9E +{
 =EF=BC=9E +     char *uid=5Fattribute
 =EF=BC=9E +     char *uid=5Fattr=5Frecord
 =EF=BC=9E +     char *dev
 =EF=BC=9E +     char *attr
 =EF=BC=9E +     char *tmp
 =EF=BC=9E +     int  count
 =EF=BC=9E +
 =EF=BC=9E +     if(!uid=5Fattrs || !path=5Fdev)
 =EF=BC=9E +             return NULL
 =EF=BC=9E +
 =EF=BC=9E +     count =3D get=5Fword(uid=5Fattrs, &uid=5Fattr=5Frecord)
 =EF=BC=9E +     while (uid=5Fattr=5Frecord) {
 =EF=BC=9E +             tmp =3D strrchr(uid=5Fattr=5Frecord, ':')
 =EF=BC=9E +             if (!tmp) {
 =EF=BC=9E +                     free(uid=5Fattr=5Frecord)
 =EF=BC=9E +                     if (!count)
 =EF=BC=9E +                             break
 =EF=BC=9E +                     uid=5Fattrs +=3D count
 =EF=BC=9E +                     count =3D get=5Fword(uid=5Fattrs, &uid=5Fa=
ttr=5Frecord)
 =EF=BC=9E +                     continue
 =EF=BC=9E +             }
 =EF=BC=9E +             dev =3D uid=5Fattr=5Frecord
 =EF=BC=9E +             attr =3D tmp + 1
 =EF=BC=9E +             *tmp =3D '\0'
 =EF=BC=9E +
 =EF=BC=9E +             if(!strncmp(path=5Fdev, dev, strlen(dev))) {
 =EF=BC=9E +                     uid=5Fattribute =3D STRDUP(attr)
 =EF=BC=9E +                     free(uid=5Fattr=5Frecord)
 =EF=BC=9E +                     return uid=5Fattribute
 =EF=BC=9E +             }
 =EF=BC=9E +
 =EF=BC=9E +             free(uid=5Fattr=5Frecord)
 =EF=BC=9E +             if (!count)
 =EF=BC=9E +                     break
 =EF=BC=9E +             uid=5Fattrs +=3D count
 =EF=BC=9E +             count =3D get=5Fword(uid=5Fattrs, &uid=5Fattr=5Fre=
cord)
 =EF=BC=9E +     }
 =EF=BC=9E +     return NULL
 =EF=BC=9E +}
 =EF=BC=9E +
 =EF=BC=9E  void
 =EF=BC=9E  setup=5Fthread=5Fattr(pthread=5Fattr=5Ft *attr, size=5Ft stacks=
ize, int detached)
 =EF=BC=9E  {
 =EF=BC=9E diff --git a/libmultipath/util.h b/libmultipath/util.h
 =EF=BC=9E index f3b37ee..793f2b7 100644
 =EF=BC=9E --- a/libmultipath/util.h
 =EF=BC=9E +++ b/libmultipath/util.h
 =EF=BC=9E @@ -12,6 +12,7 @@ size=5Ft strlcat(char *dst, const char *src, s=
ize=5Ft size)
 =EF=BC=9E  int devt2devname (char *, int, char *)
 =EF=BC=9E  dev=5Ft parse=5Fdevt(const char *dev=5Ft)
 =EF=BC=9E  char *convert=5Fdev(char *dev, int is=5Fpath=5Fdevice)
 =EF=BC=9E +char *parse=5Fuid=5Fattribute=5Fby=5Fattrs(char *uid=5Fattrs, c=
har *path=5Fdev)
 =EF=BC=9E  void setup=5Fthread=5Fattr(pthread=5Fattr=5Ft *attr, size=5Ft s=
tacksize, int detached)
 =EF=BC=9E
 =EF=BC=9E  #define safe=5Fsprintf(var, format, args...)   \
 =EF=BC=9E diff --git a/multipath/multipath.conf.5 b/multipath/multipath.co=
nf.5
 =EF=BC=9E index 36589f5..63c63c2 100644
 =EF=BC=9E --- a/multipath/multipath.conf.5
 =EF=BC=9E +++ b/multipath/multipath.conf.5
 =EF=BC=9E @@ -209,6 +209,24 @@ The default is: \fBfailover\fR
 =EF=BC=9E  .
 =EF=BC=9E  .
 =EF=BC=9E  .TP
 =EF=BC=9E +.B uid=5Fattrs
 =EF=BC=9E +The udev attribute providing a unique path identifier for corre=
sponding
 =EF=BC=9E +type of path devices. If this field is configured and matched w=
ith type
 =EF=BC=9E +of device, it would override any other methods providing for de=
vice
 =EF=BC=9E +unique identifier in config file, and it would activate merging=
 uevents
 =EF=BC=9E +according to the identifier to promote effiecncy in processing =
uevents.
 =EF=BC=9E +Tt has no default value, if you want to identify path by udev a=
ttribute
 =EF=BC=9E +and to activate merging uevents for SCSI and DAS device, you ca=
n set
 =EF=BC=9E +it's value as:
 =EF=BC=9E +.RS
 =EF=BC=9E +.TP
 =EF=BC=9E +\fBuid=5Fattrs "sd:ID=5FSERIAL dasd:ID=5FUID"\fR
 =EF=BC=9E +.TP
 =EF=BC=9E +The default is: \fB=EF=BC=9Cunset=EF=BC=9E\fR
 =EF=BC=9E +.RE
 =EF=BC=9E +.
 =EF=BC=9E +.
 =EF=BC=9E +.TP
 =EF=BC=9E  .B uid=5Fattribute
 =EF=BC=9E  The udev attribute providing a unique path identifier.
 =EF=BC=9E  .RS
 =EF=BC=9E diff --git a/multipathd/cli=5Fhandlers.c b/multipathd/cli=5Fhand=
lers.c
 =EF=BC=9E index b0eeca6..12f85de 100644
 =EF=BC=9E --- a/multipathd/cli=5Fhandlers.c
 =EF=BC=9E +++ b/multipathd/cli=5Fhandlers.c
 =EF=BC=9E @@ -670,7 +670,7 @@ cli=5Fadd=5Fpath (void * v, char ** reply, i=
nt * len, void * data)
 =EF=BC=9E               pp-=EF=BC=9Echeckint =3D conf-=EF=BC=9Echeckint
 =EF=BC=9E       }
 =EF=BC=9E       put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E -     return ev=5Fadd=5Fpath(pp, vecs)
 =EF=BC=9E +     return ev=5Fadd=5Fpath(pp, vecs, 1)
 =EF=BC=9E  blacklisted:
 =EF=BC=9E       *reply =3D strdup("blacklisted\n")
 =EF=BC=9E       *len =3D strlen(*reply) + 1
 =EF=BC=9E @@ -692,7 +692,7 @@ cli=5Fdel=5Fpath (void * v, char ** reply, i=
nt * len, void * data)
 =EF=BC=9E               condlog(0, "%s: path already removed", param)
 =EF=BC=9E               return 1
 =EF=BC=9E       }
 =EF=BC=9E -     return ev=5Fremove=5Fpath(pp, vecs)
 =EF=BC=9E +     return ev=5Fremove=5Fpath(pp, vecs, 1)
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E  int
 =EF=BC=9E diff --git a/multipathd/main.c b/multipathd/main.c
 =EF=BC=9E index adc3258..e513f7d 100644
 =EF=BC=9E --- a/multipathd/main.c
 =EF=BC=9E +++ b/multipathd/main.c
 =EF=BC=9E @@ -608,7 +608,7 @@ ev=5Fremove=5Fmap (char * devname, char * al=
ias, int minor, struct vectors * vecs)
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E  static int
 =EF=BC=9E -uev=5Fadd=5Fpath (struct uevent *uev, struct vectors * vecs)
 =EF=BC=9E +uev=5Fadd=5Fpath (struct uevent *uev, struct vectors * vecs, in=
t need=5Fdo=5Fmap)
 =EF=BC=9E  {
 =EF=BC=9E       struct path *pp
 =EF=BC=9E       int ret =3D 0, i
 =EF=BC=9E @@ -641,7 +641,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct=
 vectors * vecs)
 =EF=BC=9E                                    DI=5FALL | DI=5FBLACKLIST)
 =EF=BC=9E                       put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E                       if (r =3D=3D PATHINFO=5FOK)
 =EF=BC=9E -                             ret =3D ev=5Fadd=5Fpath(pp, vecs)
 =EF=BC=9E +                             ret =3D ev=5Fadd=5Fpath(pp, vecs, =
need=5Fdo=5Fmap)
 =EF=BC=9E                       else if (r =3D=3D PATHINFO=5FSKIPPED) {
 =EF=BC=9E                               condlog(3, "%s: remove blacklisted=
 path",
 =EF=BC=9E                                       uev-=EF=BC=9Ekernel)
 =EF=BC=9E @@ -665,7 +665,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct=
 vectors * vecs)
 =EF=BC=9E        */
 =EF=BC=9E       conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E       ret =3D alloc=5Fpath=5Fwith=5Fpathinfo(conf, uev-=EF=BC=9E=
udev,
 =EF=BC=9E -                                    DI=5FALL, &pp)
 =EF=BC=9E +                                    uev-=EF=BC=9Ewwid, DI=5FALL=
, &pp)
 =EF=BC=9E       put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E       if (!pp) {
 =EF=BC=9E               if (ret =3D=3D PATHINFO=5FSKIPPED)
 =EF=BC=9E @@ -681,7 +681,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct=
 vectors * vecs)
 =EF=BC=9E               conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E               pp-=EF=BC=9Echeckint =3D conf-=EF=BC=9Echeckint
 =EF=BC=9E               put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E -             ret =3D ev=5Fadd=5Fpath(pp, vecs)
 =EF=BC=9E +             ret =3D ev=5Fadd=5Fpath(pp, vecs, need=5Fdo=5Fmap)
 =EF=BC=9E       } else {
 =EF=BC=9E               condlog(0, "%s: failed to store path info, "
 =EF=BC=9E                       "dropping event",
 =EF=BC=9E @@ -699,7 +699,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct=
 vectors * vecs)
 =EF=BC=9E   * 1: error
 =EF=BC=9E   */
 =EF=BC=9E  int
 =EF=BC=9E -ev=5Fadd=5Fpath (struct path * pp, struct vectors * vecs)
 =EF=BC=9E +ev=5Fadd=5Fpath (struct path * pp, struct vectors * vecs, int n=
eed=5Fdo=5Fmap)
 =EF=BC=9E  {
 =EF=BC=9E       struct multipath * mpp
 =EF=BC=9E       char params[PARAMS=5FSIZE] =3D {0}
 =EF=BC=9E @@ -767,6 +767,13 @@ rescan:
 =EF=BC=9E       /* persistent reservation check*/
 =EF=BC=9E       mpath=5Fpr=5Fevent=5Fhandle(pp)
 =EF=BC=9E
 =EF=BC=9E +     if (!need=5Fdo=5Fmap)
 =EF=BC=9E +             return 0
 =EF=BC=9E +
 =EF=BC=9E +     if (!dm=5Fmap=5Fpresent(mpp-=EF=BC=9Ealias)) {
 =EF=BC=9E +             mpp-=EF=BC=9Eaction =3D ACT=5FCREATE
 =EF=BC=9E +             start=5Fwaiter =3D 1
 =EF=BC=9E +     }
 =EF=BC=9E       /*
 =EF=BC=9E        * push the map to the device-mapper
 =EF=BC=9E        */
 =EF=BC=9E @@ -833,7 +840,7 @@ fail:
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E  static int
 =EF=BC=9E -uev=5Fremove=5Fpath (struct uevent *uev, struct vectors * vecs)
 =EF=BC=9E +uev=5Fremove=5Fpath (struct uevent *uev, struct vectors * vecs,=
 int need=5Fdo=5Fmap)
 =EF=BC=9E  {
 =EF=BC=9E       struct path *pp
 =EF=BC=9E       int ret
 =EF=BC=9E @@ -844,7 +851,7 @@ uev=5Fremove=5Fpath (struct uevent *uev, str=
uct vectors * vecs)
 =EF=BC=9E       pthread=5Ftestcancel()
 =EF=BC=9E       pp =3D find=5Fpath=5Fby=5Fdev(vecs-=EF=BC=9Epathvec, uev-=
=EF=BC=9Ekernel)
 =EF=BC=9E       if (pp)
 =EF=BC=9E -             ret =3D ev=5Fremove=5Fpath(pp, vecs)
 =EF=BC=9E +             ret =3D ev=5Fremove=5Fpath(pp, vecs, need=5Fdo=5Fm=
ap)
 =EF=BC=9E       lock=5Fcleanup=5Fpop(vecs-=EF=BC=9Elock)
 =EF=BC=9E       if (!pp) {
 =EF=BC=9E               /* Not an error path might have been purged earlie=
r */
 =EF=BC=9E @@ -855,7 +862,7 @@ uev=5Fremove=5Fpath (struct uevent *uev, str=
uct vectors * vecs)
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E  int
 =EF=BC=9E -ev=5Fremove=5Fpath (struct path *pp, struct vectors * vecs)
 =EF=BC=9E +ev=5Fremove=5Fpath (struct path *pp, struct vectors * vecs, int=
 need=5Fdo=5Fmap)
 =EF=BC=9E  {
 =EF=BC=9E       struct multipath * mpp
 =EF=BC=9E       int i, retval =3D 0
 =EF=BC=9E @@ -918,6 +925,8 @@ ev=5Fremove=5Fpath (struct path *pp, struct =
vectors * vecs)
 =EF=BC=9E                       goto out
 =EF=BC=9E               }
 =EF=BC=9E
 =EF=BC=9E +             if (!need=5Fdo=5Fmap)
 =EF=BC=9E +                     goto out
 =EF=BC=9E               /*
 =EF=BC=9E                * reload the map
 =EF=BC=9E                */
 =EF=BC=9E @@ -995,7 +1004,7 @@ uev=5Fupdate=5Fpath (struct uevent *uev, st=
ruct vectors * vecs)
 =EF=BC=9E               }
 =EF=BC=9E
 =EF=BC=9E               if (pp-=EF=BC=9Einitialized =3D=3D INIT=5FREQUESTE=
D=5FUDEV)
 =EF=BC=9E -                     retval =3D uev=5Fadd=5Fpath(uev, vecs)
 =EF=BC=9E +                     retval =3D uev=5Fadd=5Fpath(uev, vecs, 1)
 =EF=BC=9E               else if (mpp && ro =EF=BC=9E=3D 0) {
 =EF=BC=9E                       condlog(2, "%s: update path write=5Fprotec=
t to '%d' (uevent)", uev-=EF=BC=9Ekernel, ro)
 =EF=BC=9E
 =EF=BC=9E @@ -1016,7 +1025,7 @@ out:
 =EF=BC=9E                       int flag =3D DI=5FSYSFS | DI=5FWWID
 =EF=BC=9E
 =EF=BC=9E                       conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E -                     retval =3D alloc=5Fpath=5Fwith=5Fpathinfo(=
conf, uev-=EF=BC=9Eudev, flag, NULL)
 =EF=BC=9E +                     retval =3D alloc=5Fpath=5Fwith=5Fpathinfo(=
conf, uev-=EF=BC=9Eudev, uev-=EF=BC=9Ewwid, flag, NULL)
 =EF=BC=9E                       put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E
 =EF=BC=9E                       if (retval =3D=3D PATHINFO=5FSKIPPED) {
 =EF=BC=9E @@ -1077,40 +1086,15 @@ uxsock=5Ftrigger (char * str, char ** re=
ply, int * len, void * trigger=5Fdata)
 =EF=BC=9E       return r
 =EF=BC=9E  }
 =EF=BC=9E
 =EF=BC=9E -static int
 =EF=BC=9E -uev=5Fdiscard(char * devpath)
 =EF=BC=9E -{
 =EF=BC=9E -     char *tmp
 =EF=BC=9E -     char a[11], b[11]
 =EF=BC=9E -
 =EF=BC=9E -     /*
 =EF=BC=9E -      * keep only block devices, discard partitions
 =EF=BC=9E -      */
 =EF=BC=9E -     tmp =3D strstr(devpath, "/block/")
 =EF=BC=9E -     if (tmp =3D=3D NULL){
 =EF=BC=9E -             condlog(4, "no /block/ in '%s'", devpath)
 =EF=BC=9E -             return 1
 =EF=BC=9E -     }
 =EF=BC=9E -     if (sscanf(tmp, "/block/%10s", a) !=3D 1 ||
 =EF=BC=9E -         sscanf(tmp, "/block/%10[^/]/%10s", a, b) =3D=3D 2) {
 =EF=BC=9E -             condlog(4, "discard event on %s", devpath)
 =EF=BC=9E -             return 1
 =EF=BC=9E -     }
 =EF=BC=9E -     return 0
 =EF=BC=9E -}
 =EF=BC=9E -
 =EF=BC=9E  int
 =EF=BC=9E  uev=5Ftrigger (struct uevent * uev, void * trigger=5Fdata)
 =EF=BC=9E  {
 =EF=BC=9E       int r =3D 0
 =EF=BC=9E       struct vectors * vecs
 =EF=BC=9E -     struct config *conf
 =EF=BC=9E +     struct uevent *merge=5Fuev, *tmp
 =EF=BC=9E
 =EF=BC=9E       vecs =3D (struct vectors *)trigger=5Fdata
 =EF=BC=9E
 =EF=BC=9E -     if (uev=5Fdiscard(uev-=EF=BC=9Edevpath))
 =EF=BC=9E -             return 0
 =EF=BC=9E -
 =EF=BC=9E       pthread=5Fcleanup=5Fpush(config=5Fcleanup, NULL)
 =EF=BC=9E       pthread=5Fmutex=5Flock(&config=5Flock)
 =EF=BC=9E       if (running=5Fstate !=3D DAEMON=5FIDLE &&
 =EF=BC=9E @@ -1139,28 +1123,21 @@ uev=5Ftrigger (struct uevent * uev, void=
 * trigger=5Fdata)
 =EF=BC=9E       }
 =EF=BC=9E
 =EF=BC=9E       /*
 =EF=BC=9E -      * path add/remove event
 =EF=BC=9E +      * path add/remove/change event, add/remove maybe merged
 =EF=BC=9E        */
 =EF=BC=9E -     conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E -     if (filter=5Fdevnode(conf-=EF=BC=9Eblist=5Fdevnode, conf-=
=EF=BC=9Eelist=5Fdevnode,
 =EF=BC=9E -                        uev-=EF=BC=9Ekernel) =EF=BC=9E 0) {
 =EF=BC=9E -             put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E -             goto out
 =EF=BC=9E +     list=5Ffor=5Feach=5Fentry=5Fsafe(merge=5Fuev, tmp, &uev-=
=EF=BC=9Emerge=5Fnode, node) {
 =EF=BC=9E +             if (!strncmp(merge=5Fuev-=EF=BC=9Eaction, "add", 3=
))
 =EF=BC=9E +                     r +=3D uev=5Fadd=5Fpath(merge=5Fuev, vecs,=
 0)
 =EF=BC=9E +             if (!strncmp(merge=5Fuev-=EF=BC=9Eaction, "remove"=
, 6))
 =EF=BC=9E +                     r +=3D uev=5Fremove=5Fpath(merge=5Fuev, ve=
cs, 0)
 =EF=BC=9E       }
 =EF=BC=9E -     put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E
 =EF=BC=9E -     if (!strncmp(uev-=EF=BC=9Eaction, "add", 3)) {
 =EF=BC=9E -             r =3D uev=5Fadd=5Fpath(uev, vecs)
 =EF=BC=9E -             goto out
 =EF=BC=9E -     }
 =EF=BC=9E -     if (!strncmp(uev-=EF=BC=9Eaction, "remove", 6)) {
 =EF=BC=9E -             r =3D uev=5Fremove=5Fpath(uev, vecs)
 =EF=BC=9E -             goto out
 =EF=BC=9E -     }
 =EF=BC=9E -     if (!strncmp(uev-=EF=BC=9Eaction, "change", 6)) {
 =EF=BC=9E -             r =3D uev=5Fupdate=5Fpath(uev, vecs)
 =EF=BC=9E -             goto out
 =EF=BC=9E -     }
 =EF=BC=9E +     if (!strncmp(uev-=EF=BC=9Eaction, "add", 3))
 =EF=BC=9E +             r +=3D uev=5Fadd=5Fpath(uev, vecs, 1)
 =EF=BC=9E +     if (!strncmp(uev-=EF=BC=9Eaction, "remove", 6))
 =EF=BC=9E +             r +=3D uev=5Fremove=5Fpath(uev, vecs, 1)
 =EF=BC=9E +     if (!strncmp(uev-=EF=BC=9Eaction, "change", 6))
 =EF=BC=9E +             r +=3D uev=5Fupdate=5Fpath(uev, vecs)
 =EF=BC=9E
 =EF=BC=9E  out:
 =EF=BC=9E       return r
 =EF=BC=9E @@ -1570,7 +1547,7 @@ check=5Fpath (struct vectors * vecs, struc=
t path * pp, int ticks)
 =EF=BC=9E                       conf =3D get=5Fmultipath=5Fconfig()
 =EF=BC=9E                       ret =3D pathinfo(pp, conf, DI=5FALL | DI=
=5FBLACKLIST)
 =EF=BC=9E                       if (ret =3D=3D PATHINFO=5FOK) {
 =EF=BC=9E -                             ev=5Fadd=5Fpath(pp, vecs)
 =EF=BC=9E +                             ev=5Fadd=5Fpath(pp, vecs, 1)
 =EF=BC=9E                               pp-=EF=BC=9Etick =3D 1
 =EF=BC=9E                       } else if (ret =3D=3D PATHINFO=5FSKIPPED) {
 =EF=BC=9E                               put=5Fmultipath=5Fconfig(conf)
 =EF=BC=9E @@ -1686,7 +1663,7 @@ check=5Fpath (struct vectors * vecs, struc=
t path * pp, int ticks)
 =EF=BC=9E               }
 =EF=BC=9E               if (!disable=5Freinstate && reinstate=5Fpath(pp, a=
dd=5Factive)) {
 =EF=BC=9E                       condlog(3, "%s: reload map", pp-=EF=BC=9Ed=
ev)
 =EF=BC=9E -                     ev=5Fadd=5Fpath(pp, vecs)
 =EF=BC=9E +                     ev=5Fadd=5Fpath(pp, vecs, 1)
 =EF=BC=9E                       pp-=EF=BC=9Etick =3D 1
 =EF=BC=9E                       return 0
 =EF=BC=9E               }
 =EF=BC=9E @@ -1709,7 +1686,7 @@ check=5Fpath (struct vectors * vecs, struc=
t path * pp, int ticks)
 =EF=BC=9E                       /* Clear IO errors */
 =EF=BC=9E                       if (reinstate=5Fpath(pp, 0)) {
 =EF=BC=9E                               condlog(3, "%s: reload map", pp-=
=EF=BC=9Edev)
 =EF=BC=9E -                             ev=5Fadd=5Fpath(pp, vecs)
 =EF=BC=9E +                             ev=5Fadd=5Fpath(pp, vecs, 1)
 =EF=BC=9E                               pp-=EF=BC=9Etick =3D 1
 =EF=BC=9E                               return 0
 =EF=BC=9E                       }
 =EF=BC=9E diff --git a/multipathd/main.h b/multipathd/main.h
 =EF=BC=9E index f72580d..094b04f 100644
 =EF=BC=9E --- a/multipathd/main.h
 =EF=BC=9E +++ b/multipathd/main.h
 =EF=BC=9E @@ -22,8 +22,8 @@ void exit=5Fdaemon(void)
 =EF=BC=9E  const char * daemon=5Fstatus(void)
 =EF=BC=9E  int need=5Fto=5Fdelay=5Freconfig (struct vectors *)
 =EF=BC=9E  int reconfigure (struct vectors *)
 =EF=BC=9E -int ev=5Fadd=5Fpath (struct path *, struct vectors *)
 =EF=BC=9E -int ev=5Fremove=5Fpath (struct path *, struct vectors *)
 =EF=BC=9E +int ev=5Fadd=5Fpath (struct path *, struct vectors *, int)
 =EF=BC=9E +int ev=5Fremove=5Fpath (struct path *, struct vectors *, int)
 =EF=BC=9E  int ev=5Fadd=5Fmap (char *, char *, struct vectors *)
 =EF=BC=9E  int ev=5Fremove=5Fmap (char *, char *, int, struct vectors *)
 =EF=BC=9E  void sync=5Fmap=5Fstate (struct multipath *)
 =EF=BC=9E --
 =EF=BC=9E 2.8.1.windows.1
 =EF=BC=9E

--=====_003_next=====
Content-Type: text/html ;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div class=3D"zcontentRow"> <p><br></p><p>Hi Christophe,</p><p><br></p><p>O=
K, I'll post it later.</p><p><br></p><p>regards,</p><p>Tang Junhui</p><p><b=
r></p><p><br></p><div class=3D"zMailSign"></div><div class=3D"zMailFrom"></=
div><div><div class=3D"zhistoryRow" style=3D"display:block"><div class=3D"z=
historyDes" style=3D"width: 100%; height: 28px; line-height: 28px; backgrou=
nd-color: #E0E5E9; color: #1388FF; text-align: center;" language-data=3D"Hi=
storyOrgTxt">=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6</div><div id=3D"zwriteHis=
toryContainer"><div class=3D"control-group zhistoryPanel"><div class=3D"zhi=
storyHeader" style=3D"padding: 8px; background-color: #F5F6F8;"><div><stron=
g language-data=3D"HistorySenderTxt">=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A</=
strong><span class=3D"zreadUserName"> =EF=BC=9Cchristophe.varoqui@opensvc.c=
om=EF=BC=9E;</span></div><div><strong language-data=3D"HistoryTOTxt">=E6=94=
=B6=E4=BB=B6=E4=BA=BA=EF=BC=9A</strong><span class=3D"zreadUserName" style=
=3D"display: inline-block;"> =EF=BC=9Cbmarzins@redhat.com=EF=BC=9E;</span><=
/div><div><strong language-data=3D"HistoryCCTxt">=E6=8A=84=E9=80=81=E4=BA=
=BA=EF=BC=9A</strong><span class=3D"zreadUserName" style=3D"display: inline=
-block;">=E5=94=90=E6=96=87=E4=BF=8A10144149;</span><span class=3D"zreadUse=
rName" style=3D"display: inline-block;">=E5=94=90=E5=86=9B=E8=BE=8910074136=
;</span><span class=3D"zreadUserName" style=3D"display: inline-block;">=E5=
=BC=A0=E5=87=AF10072500;</span><span class=3D"zreadUserName" style=3D"displ=
ay: inline-block;"> =EF=BC=9Cdm-devel@redhat.com=EF=BC=9E;</span><span clas=
s=3D"zreadUserName" style=3D"display: inline-block;"> =EF=BC=9Cbart.vanassc=
he@sandisk.com=EF=BC=9E;</span><span class=3D"zreadUserName" style=3D"displ=
ay: inline-block;"> =EF=BC=9Cmwilck@suse.com=EF=BC=9E;</span></div><div><st=
rong language-data=3D"HistoryDateTxt">=E6=97=A5 =E6=9C=9F =EF=BC=9A</strong=
><span class=3D"">2017=E5=B9=B402=E6=9C=8827=E6=97=A5 14:22</span></div><di=
v><strong language-data=3D"HistorySubjectTxt">=E4=B8=BB =E9=A2=98 =EF=BC=9A=
</strong><span class=3D"zreadTitle"><strong>Re: [dm-devel] [PATCH] multipat=
h-tools: improve processing efficiency for addition and deletion of multipa=
th devices</strong></span></div></div><p class=3D"zhistoryContent"><br></p>=
<div><div dir=3D"ltr"><div>Hi Junhui,</div><div><br></div>It seems I did no=
t receive the patch version Acked by Ben,<div>Can you rebase and post pleas=
e ?</div><div><br></div><div>Thanks.</div></div><div class=3D"gmail=5Fextra=
"><br><div class=3D"gmail=5Fquote">On Thu, Feb 16, 2017 at 5:27 PM, Benjami=
n Marzinski <span dir=3D"ltr">=EF=BC=9C<a href=3D"mailto:bmarzins@redhat.co=
m" target=3D"=5Fblank">bmarzins@redhat.com</a>=EF=BC=9E</span> wrote:<br><b=
lockquote class=3D"gmail=5Fquote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><span class=3D"">On Thu, Feb 16, 2017 at 02:=
54:01PM +0800, <a href=3D"mailto:tang.junhui@zte.com.cn" target=3D"=5Fblank=
">tang.junhui@zte.com.cn</a> wrote:<br> =EF=BC=9E From: "tang.junhui" =EF=
=BC=9C<a href=3D"mailto:tang.junhui@zte.com.cn" target=3D"=5Fblank">tang.ju=
nhui@zte.com.cn</a>=EF=BC=9E<br> <br> </span>ACK<br> <br> Thanks for all yo=
ur work on this.<br> -Ben<br> <div class=3D"HOEnZb"><div class=3D"h5"><br> =
=EF=BC=9E<br> =EF=BC=9E Change-Id: I3f81a55fff389f991f915927000b2<wbr>81d7e=
263cc5<br> =EF=BC=9E Signed-off-by: tang.junhui =EF=BC=9C<a href=3D"mailto:=
tang.junhui@zte.com.cn" target=3D"=5Fblank">tang.junhui@zte.com.cn</a>=EF=
=BC=9E<br> =EF=BC=9E<br> =EF=BC=9E This patch used to improve processing ef=
ficiency for addition and deletion<br> =EF=BC=9E of multipath devices.<br> =
=EF=BC=9E<br> =EF=BC=9E This patch is tested pass by ZTE multipath automati=
c testing system.<br> =EF=BC=9E The modification reduces the system consump=
tion(such as CPU) and shortens<br> =EF=BC=9E the processing time obviously =
in scene of massive multipath devices<br> =EF=BC=9E addition or deletion.<b=
r> =EF=BC=9E<br> =EF=BC=9E The main processing flow of code is:<br> =EF=BC=
=9E 1) add uid=5Fattrs configuration in the defaults section:<br> =EF=BC=9E=
&nbsp; &nbsp; It is configured udev attribute which providing a unique path=
 identifier<br> =EF=BC=9E&nbsp; &nbsp; for corresponding type of path devic=
es. If this field is configured and<br> =EF=BC=9E&nbsp; &nbsp; matched with=
 type of device, it would override any other methods providing<br> =EF=BC=
=9E&nbsp; &nbsp; for device unique identifier in config file, and it would =
activate merging<br> =EF=BC=9E&nbsp; &nbsp; uevents according to the identi=
fier to promote effiecncy in processing<br> =EF=BC=9E&nbsp; &nbsp; uevents.=
 Tt has no default value, so defaultly only uevents filtering<br> =EF=BC=9E=
&nbsp; &nbsp; works, and uevents merging does not works, if users want to i=
dentify path<br> =EF=BC=9E&nbsp; &nbsp; by udev attribute and to activate m=
erging uevents for SCSI and DAS device,<br> =EF=BC=9E&nbsp; &nbsp; they can=
 set it's value as:<br> =EF=BC=9E&nbsp; &nbsp; "sd:ID=5FSERIAL dasd:ID=5FUI=
D"<br> =EF=BC=9E 2) uevents accumulation in uevents burst scene:<br> =EF=BC=
=9E&nbsp; &nbsp; wait one seconds for more uevents in uevent=5Flisten() in =
uevents burst<br> =EF=BC=9E&nbsp; &nbsp; situations<br> =EF=BC=9E 3) uevent=
s preparing, filtering and merging:<br> =EF=BC=9E&nbsp; &nbsp; discard unus=
e uevents and fetch path idendifier from uevents;<br> =EF=BC=9E&nbsp; &nbsp=
; filter uevents;<br> =EF=BC=9E&nbsp; &nbsp; merge uevents.<br> =EF=BC=9E 4=
) uevents proccessing:<br> =EF=BC=9E&nbsp; &nbsp; proccess the merged ueven=
ts in uev-=EF=BC=9Emerge=5Fnode list without calling<br> =EF=BC=9E&nbsp; &n=
bsp; domap();<br> =EF=BC=9E&nbsp; &nbsp; proccess the last uevents uev with=
 calling domap().<br> =EF=BC=9E ---<br> =EF=BC=9E&nbsp; libmultipath/config=
.c&nbsp; &nbsp; &nbsp; |&nbsp; &nbsp;3 +<br> =EF=BC=9E&nbsp; libmultipath/c=
onfig.h&nbsp; &nbsp; &nbsp; |&nbsp; &nbsp;1 +<br> =EF=BC=9E&nbsp; libmultip=
ath/dict.c&nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; &nbsp;3 +<br> =EF=BC=9E&nbsp;=
 libmultipath/discovery.c&nbsp; &nbsp;|&nbsp; &nbsp;5 +-<br> =EF=BC=9E&nbsp=
; libmultipath/discovery.h&nbsp; &nbsp;|&nbsp; &nbsp;2 +-<br> =EF=BC=9E&nbs=
p; libmultipath/list.h&nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; 41 ++++++<br> =EF=
=BC=9E&nbsp; libmultipath/propsel.c&nbsp; &nbsp; &nbsp;|&nbsp; &nbsp;7 +<br=
> =EF=BC=9E&nbsp; libmultipath/uevent.c&nbsp; &nbsp; &nbsp; | 320 +++++++++=
+++++++++++++++++++++<wbr>+++++++++++++--<br> =EF=BC=9E&nbsp; libmultipath/=
uevent.h&nbsp; &nbsp; &nbsp; |&nbsp; &nbsp;2 +<br> =EF=BC=9E&nbsp; libmulti=
path/util.c&nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; 42 ++++++<br> =EF=BC=9E&nbsp=
; libmultipath/util.h&nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; &nbsp;1 +<br> =EF=
=BC=9E&nbsp; multipath/multipath.conf.5 |&nbsp; 18 +++<br> =EF=BC=9E&nbsp; =
multipathd/cli=5Fhandlers.c&nbsp; |&nbsp; &nbsp;4 +-<br> =EF=BC=9E&nbsp; mu=
ltipathd/main.c&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&nbsp; 93 +++++--------<=
br> =EF=BC=9E&nbsp; multipathd/main.h&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; |&n=
bsp; &nbsp;4 +-<br> =EF=BC=9E&nbsp; 15 files changed, 471 insertions(+), 75=
 deletions(-)<br> =EF=BC=9E<br> =EF=BC=9E diff --git a/libmultipath/config.=
c b/libmultipath/config.c<br> =EF=BC=9E index 15ddbd8..765e91d 100644<br> =
=EF=BC=9E --- a/libmultipath/config.c<br> =EF=BC=9E +++ b/libmultipath/conf=
ig.c<br> =EF=BC=9E @@ -488,6 +488,9 @@ free=5Fconfig (struct config * conf)=
<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;if (conf-=EF=BC=9Euid=5Fattribute)=
<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;FREE(c=
onf-=EF=BC=9Euid=5Fattribute);<br> =EF=BC=9E<br> =EF=BC=9E +&nbsp; &nbsp; &=
nbsp;if (conf-=EF=BC=9Euid=5Fattrs)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp;FREE(conf-=EF=BC=9Euid=5Fattrs);<br> =EF=BC=9E +<br=
> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;if (conf-=EF=BC=9Egetuid)<br> =EF=BC=
=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;FREE(conf-=EF=BC=
=9Egetuid);<br> =EF=BC=9E<br> =EF=BC=9E diff --git a/libmultipath/config.h =
b/libmultipath/config.h<br> =EF=BC=9E index 9670020..ab85930 100644<br> =EF=
=BC=9E --- a/libmultipath/config.h<br> =EF=BC=9E +++ b/libmultipath/config.=
h<br> =EF=BC=9E @@ -153,6 +153,7 @@ struct config {<br> =EF=BC=9E<br> =EF=
=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;char * multipath=5Fdir;<br> =EF=BC=9E&nbsp=
; &nbsp; &nbsp; &nbsp;char * selector;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;c=
har * uid=5Fattrs;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;char * uid=5Fatt=
ribute;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;char * getuid;<br> =EF=BC=
=9E&nbsp; &nbsp; &nbsp; &nbsp;char * features;<br> =EF=BC=9E diff --git a/l=
ibmultipath/dict.c b/libmultipath/dict.c<br> =EF=BC=9E index dc21846..0a531=
d1 100644<br> =EF=BC=9E --- a/libmultipath/dict.c<br> =EF=BC=9E +++ b/libmu=
ltipath/dict.c<br> =EF=BC=9E @@ -249,6 +249,8 @@ declare=5Fovr=5Fsnprint(se=
lector, print=5Fstr)<br> =EF=BC=9E&nbsp; declare=5Fmp=5Fhandler(selector, s=
et=5Fstr)<br> =EF=BC=9E&nbsp; declare=5Fmp=5Fsnprint(selector, print=5Fstr)=
<br> =EF=BC=9E<br> =EF=BC=9E +declare=5Fdef=5Fhandler(uid=5F<wbr>attrs, set=
=5Fstr)<br> =EF=BC=9E +declare=5Fdef=5Fsnprint(uid=5F<wbr>attrs, print=5Fst=
r)<br> =EF=BC=9E&nbsp; declare=5Fdef=5Fhandler(uid=5F<wbr>attribute, set=5F=
str)<br> =EF=BC=9E&nbsp; declare=5Fdef=5Fsnprint=5Fdefstr(<wbr>uid=5Fattrib=
ute, print=5Fstr, DEFAULT=5FUID=5FATTRIBUTE)<br> =EF=BC=9E&nbsp; declare=5F=
ovr=5Fhandler(uid=5F<wbr>attribute, set=5Fstr)<br> =EF=BC=9E @@ -1367,6 +13=
69,7 @@ init=5Fkeywords(vector keywords)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; =
&nbsp;install=5Fkeyword("multipath=5F<wbr>dir", &amp;def=5Fmultipath=5Fdir=
=5Fhandler, &amp;snprint=5Fdef=5Fmultipath=5Fdir);<br> =EF=BC=9E&nbsp; &nbs=
p; &nbsp; &nbsp;install=5Fkeyword("path=5F<wbr>selector", &amp;def=5Fselect=
or=5Fhandler, &amp;snprint=5Fdef=5Fselector);<br> =EF=BC=9E&nbsp; &nbsp; &n=
bsp; &nbsp;install=5Fkeyword("path=5F<wbr>grouping=5Fpolicy", &amp;def=5Fpg=
policy=5Fhandler, &amp;snprint=5Fdef=5Fpgpolicy);<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp;install=5Fkeyword("uid=5Fattrs", &amp;def=5Fuid=5Fattrs=5Fhandler=
, &amp;snprint=5Fdef=5Fuid=5Fattrs);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbs=
p;install=5Fkeyword("uid=5F<wbr>attribute", &amp;def=5Fuid=5Fattribute=5Fha=
ndler, &amp;snprint=5Fdef=5Fuid=5Fattribute);<br> =EF=BC=9E&nbsp; &nbsp; &n=
bsp; &nbsp;install=5Fkeyword("getuid=5F<wbr>callout", &amp;def=5Fgetuid=5Fh=
andler, &amp;snprint=5Fdef=5Fgetuid);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nb=
sp;install=5Fkeyword("prio", &amp;def=5Fprio=5Fname=5Fhandler, &amp;snprint=
=5Fdef=5Fprio=5Fname);<br> =EF=BC=9E diff --git a/libmultipath/discovery.c =
b/libmultipath/discovery.c<br> =EF=BC=9E index d1aec31..14904f2 100644<br> =
=EF=BC=9E --- a/libmultipath/discovery.c<br> =EF=BC=9E +++ b/libmultipath/d=
iscovery.c<br> =EF=BC=9E @@ -33,7 +33,7 @@<br> =EF=BC=9E<br> =EF=BC=9E&nbsp=
; int<br> =EF=BC=9E&nbsp; alloc=5Fpath=5Fwith=5Fpathinfo (struct config *co=
nf, struct udev=5Fdevice *udevice,<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;int flag, struct =
path **pp=5Fptr)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;char *wwid, int flag, struct path *=
*pp=5Fptr)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;in=
t err =3D PATHINFO=5FFAILED;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;struct=
 path * pp;<br> =EF=BC=9E @@ -51,6 +51,9 @@ alloc=5Fpath=5Fwith=5Fpathinfo =
(struct config *conf, struct udev=5Fdevice *udevice,<br> =EF=BC=9E&nbsp; &n=
bsp; &nbsp; &nbsp;if (!pp)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;return PATHINFO=5FFAILED;<br> =EF=BC=9E<br> =EF=BC=9E +=
&nbsp; &nbsp; &nbsp;if(wwid)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp;strncpy(pp-=EF=BC=9Ewwid, wwid, sizeof(pp-=EF=BC=9Ewwid));=
<br> =EF=BC=9E +<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;if (safe=5Fsprintf=
(pp-=EF=BC=9Edev, "%s", devname)) {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;condlog(0, "pp-=EF=BC=9Edev too small");<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;} else {<br> =EF=BC=9E diff --git a/lib=
multipath/discovery.h b/libmultipath/discovery.h<br> =EF=BC=9E index 303926=
8..d16a69a 100644<br> =EF=BC=9E --- a/libmultipath/discovery.h<br> =EF=BC=
=9E +++ b/libmultipath/discovery.h<br> =EF=BC=9E @@ -37,7 +37,7 @@ int path=
=5Foffline (struct path *);<br> =EF=BC=9E&nbsp; int get=5Fstate (struct pat=
h * pp, struct config * conf, int daemon);<br> =EF=BC=9E&nbsp; int pathinfo=
 (struct path * pp, struct config * conf, int mask);<br> =EF=BC=9E&nbsp; in=
t alloc=5Fpath=5Fwith=5Fpathinfo (struct config *conf, struct udev=5Fdevice=
 *udevice,<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;int flag, struct path **pp=
=5Fptr);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;char *wwid, int flag, struct =
path **pp=5Fptr);<br> =EF=BC=9E&nbsp; int store=5Fpathinfo (vector pathvec,=
 struct config *conf,<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;struct udev=5Fdevice *udevice, int flag,<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;struct path **pp=5Fptr);<br> =EF=BC=9E diff --git a/libmultipath/list.h =
b/libmultipath/list.h<br> =EF=BC=9E index ceaa381..2b1dcf3 100644<br> =EF=
=BC=9E --- a/libmultipath/list.h<br> =EF=BC=9E +++ b/libmultipath/list.h<br=
> =EF=BC=9E @@ -317,4 +317,45 @@ static inline void list=5Fsplice=5Ftail=5F=
init(struct list=5Fhead *list,<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &amp;pos-=EF=BC=9Emember !=3D (head);&nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; \<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.next, typeof(*n), mem=
ber))<br> =EF=BC=9E<br> =EF=BC=9E +/**<br> =EF=BC=9E + * list=5Ffor=5Feach=
=5Fentry=5Freverse=5F<wbr>safe - iterate backwards over list of given type =
safe against removal of list entry<br> =EF=BC=9E + * @pos:&nbsp; &nbsp; &nb=
sp;the type * to use as a loop counter.<br> =EF=BC=9E + * @n:&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;another type * to use as temporary=
 storage<br> =EF=BC=9E + * @head:&nbsp; &nbsp; the head for your list.<br> =
=EF=BC=9E + * @member:&nbsp; the name of the list=5Fstruct within the struc=
t.<br> =EF=BC=9E + */<br> =EF=BC=9E +#define list=5Ffor=5Feach=5Fentry=5Fre=
verse=5F<wbr>safe(pos, n, head, member)&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \=
<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;for (pos =3D list=5Fentry((head)-=EF=BC=
=9Eprev, typeof(*pos), member),&nbsp; &nbsp; &nbsp; \<br> =EF=BC=9E +&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; n =3D list=5Fentry(pos-=EF=BC=9E=
member.prev, typeof(*pos), member);\<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &amp;pos-=EF=BC=9Emember !=3D (head);&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; \<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.prev, typeof(*n), member)=
)<br> =EF=BC=9E +<br> =EF=BC=9E +/**<br> =EF=BC=9E + * list=5Ffor=5Fsome=5F=
entry=5Fsafe - iterate list from the given begin node to the given end node=
 safe against removal of list entry<br> =EF=BC=9E + * @pos:&nbsp; &nbsp; &n=
bsp;the type * to use as a loop counter.<br> =EF=BC=9E + * @n:&nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;another type * to use as temporar=
y storage<br> =EF=BC=9E + * @from:&nbsp; &nbsp; the begin node of the itera=
tion.<br> =EF=BC=9E + * @to:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; the end node of the iteration.<br> =EF=BC=9E + * @member:&nbsp; the name =
of the list=5Fstruct within the struct.<br> =EF=BC=9E + */<br> =EF=BC=9E +#=
define list=5Ffor=5Fsome=5Fentry=5Fsafe(pos, n, from, to, member)&nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp=
;for (pos =3D list=5Fentry((from)-=EF=BC=9Enext, typeof(*pos), member),&nbs=
p; &nbsp; &nbsp; \<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; n =3D =
list=5Fentry(pos-=EF=BC=9Emember.next, typeof(*pos), member);&nbsp; &nbsp; =
\<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;pos-=EF=BC=9Emembe=
r !=3D (to);&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; pos =3D n, n =3D list=5Fentr=
y(n-=EF=BC=9Emember.next, typeof(*n), member))<br> =EF=BC=9E +<br> =EF=BC=
=9E +/**<br> =EF=BC=9E + * list=5Ffor=5Fsome=5Fentry=5Freverse=5F<wbr>safe =
- iterate backwards list from the given begin node to the given end node sa=
fe against removal of list entry<br> =EF=BC=9E + * @pos:&nbsp; &nbsp; &nbsp=
;the type * to use as a loop counter.<br> =EF=BC=9E + * @n:&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;another type * to use as temporary s=
torage<br> =EF=BC=9E + * @from:&nbsp; &nbsp; the begin node of the iteratio=
n.<br> =EF=BC=9E + * @to:&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t=
he end node of the iteration.<br> =EF=BC=9E + * @member:&nbsp; the name of =
the list=5Fstruct within the struct.<br> =EF=BC=9E + */<br> =EF=BC=9E +#def=
ine list=5Ffor=5Fsome=5Fentry=5Freverse=5F<wbr>safe(pos, n, from, to, membe=
r)&nbsp; &nbsp; &nbsp; \<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;for (pos =3D li=
st=5Fentry((from)-=EF=BC=9Eprev, typeof(*pos), member),&nbsp; &nbsp; &nbsp;=
 \<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; n =3D list=5Fentry(pos=
-=EF=BC=9Emember.prev, typeof(*pos), member);&nbsp; &nbsp; \<br> =EF=BC=9E =
+&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &amp;pos-=EF=BC=9Emember !=3D (to);&nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; \<br> =EF=BC=9E +&nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emem=
ber.prev, typeof(*n), member))<br> =EF=BC=9E +<br> =EF=BC=9E&nbsp; #endif /=
* =5FLIST=5FH */<br> =EF=BC=9E diff --git a/libmultipath/propsel.c b/libmul=
tipath/propsel.c<br> =EF=BC=9E index c0bc616..c47bd08 100644<br> =EF=BC=9E =
--- a/libmultipath/propsel.c<br> =EF=BC=9E +++ b/libmultipath/propsel.c<br>=
 =EF=BC=9E @@ -18,6 +18,7 @@<br> =EF=BC=9E&nbsp; #include "prio.h"<br> =EF=
=BC=9E&nbsp; #include "discovery.h"<br> =EF=BC=9E&nbsp; #include "dict.h"<b=
r> =EF=BC=9E +#include "util.h"<br> =EF=BC=9E&nbsp; #include "prioritizers/=
alua=5Frtpg.h"<br> =EF=BC=9E&nbsp; #include =EF=BC=9Cinttypes.h=EF=BC=9E<br=
> =EF=BC=9E<br> =EF=BC=9E @@ -339,6 +340,12 @@ int select=5Fgetuid(struct c=
onfig *conf, struct path *pp)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nb=
sp; &nbsp; &nbsp;char *origin;<br> =EF=BC=9E<br> =EF=BC=9E +&nbsp; &nbsp; &=
nbsp;pp-=EF=BC=9Euid=5Fattribute =3D parse=5Fuid=5Fattribute=5Fby=5Fattrs(<=
wbr>conf-=EF=BC=9Euid=5Fattrs, pp-=EF=BC=9Edev);<br> =EF=BC=9E +&nbsp; &nbs=
p; &nbsp;if (pp-=EF=BC=9Euid=5Fattribute) {<br> =EF=BC=9E +&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;origin =3D "(setting: multipath.conf defaul=
ts section)";<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;goto out;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +<br> =EF=BC=
=9E&nbsp; &nbsp; &nbsp; &nbsp;pp=5Fset=5Fovr(getuid);<br> =EF=BC=9E&nbsp; &=
nbsp; &nbsp; &nbsp;pp=5Fset=5Fovr(uid=5Fattribute);<br> =EF=BC=9E&nbsp; &nb=
sp; &nbsp; &nbsp;pp=5Fset=5Fhwe(getuid);<br> =EF=BC=9E diff --git a/libmult=
ipath/uevent.c b/libmultipath/uevent.c<br> =EF=BC=9E index 7edcce1..6e2527b=
 100644<br> =EF=BC=9E --- a/libmultipath/uevent.c<br> =EF=BC=9E +++ b/libmu=
ltipath/uevent.c<br> =EF=BC=9E @@ -24,6 +24,7 @@<br> =EF=BC=9E<br> =EF=BC=
=9E&nbsp; #include =EF=BC=9Cunistd.h=EF=BC=9E<br> =EF=BC=9E&nbsp; #include =
=EF=BC=9Cstdio.h=EF=BC=9E<br> =EF=BC=9E +#include =EF=BC=9Cstdbool.h=EF=BC=
=9E<br> =EF=BC=9E&nbsp; #include =EF=BC=9Cerrno.h=EF=BC=9E<br> =EF=BC=9E&nb=
sp; #include =EF=BC=9Cstdlib.h=EF=BC=9E<br> =EF=BC=9E&nbsp; #include =EF=BC=
=9Cstddef.h=EF=BC=9E<br> =EF=BC=9E @@ -38,6 +39,7 @@<br> =EF=BC=9E&nbsp; #i=
nclude =EF=BC=9Clinux/netlink.h=EF=BC=9E<br> =EF=BC=9E&nbsp; #include =EF=
=BC=9Cpthread.h=EF=BC=9E<br> =EF=BC=9E&nbsp; #include =EF=BC=9Csys/mman.h=
=EF=BC=9E<br> =EF=BC=9E +#include =EF=BC=9Csys/time.h=EF=BC=9E<br> =EF=BC=
=9E&nbsp; #include =EF=BC=9Clibudev.h=EF=BC=9E<br> =EF=BC=9E&nbsp; #include=
 =EF=BC=9Cerrno.h=EF=BC=9E<br> =EF=BC=9E<br> =EF=BC=9E @@ -46,6 +48,14 @@<b=
r> =EF=BC=9E&nbsp; #include "list.h"<br> =EF=BC=9E&nbsp; #include "uevent.h=
"<br> =EF=BC=9E&nbsp; #include "vector.h"<br> =EF=BC=9E +#include "structs.=
h"<br> =EF=BC=9E +#include "util.h"<br> =EF=BC=9E +#include "config.h"<br> =
=EF=BC=9E +#include "blacklist.h"<br> =EF=BC=9E +<br> =EF=BC=9E +#define MA=
X=5FACCUMULATION=5FCOUNT 2048<br> =EF=BC=9E +#define MAX=5FACCUMULATION=5FT=
IME 30*1000<br> =EF=BC=9E +#define MIN=5FBURST=5FSPEED 10<br> =EF=BC=9E<br>=
 =EF=BC=9E&nbsp; typedef int (uev=5Ftrigger)(struct uevent *, void * trigge=
r=5Fdata);<br> =EF=BC=9E<br> =EF=BC=9E @@ -72,48 +82,301 @@ struct uevent *=
 alloc=5Fuevent (void)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nb=
sp; &nbsp;struct uevent *uev =3D MALLOC(sizeof(struct uevent));<br> =EF=BC=
=9E<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;if (uev)<br> =EF=BC=9E +&nbsp; &nbsp=
; &nbsp;if (uev) {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;INIT=5FLIST=5FHEAD(&amp;uev-=EF=BC=9Enode);<br> =EF=BC=9E +&nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;INIT=5FLIST=5FHEAD(&amp;uev-=EF=
=BC=9Emerge=5F<wbr>node);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=
=9E<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;return uev;<br> =EF=BC=9E&nbsp;=
 }<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; void<br> =EF=BC=9E -service=5Fuevq(str=
uct list=5Fhead *tmpq)<br> =EF=BC=9E +uevq=5Fcleanup(struct list=5Fhead *tm=
pq)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;struct ue=
vent *uev, *tmp;<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;list=
=5Ffor=5Feach=5Fentry=5Fsafe(uev, tmp, tmpq, node) {<br> =EF=BC=9E&nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;list=5Fdel=5Finit(&amp;uev-=
=EF=BC=9Enode);<br> =EF=BC=9E<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp;if (my=5Fuev=5Ftrigger &amp;&amp; my=5Fuev=5Ftrigger(uev,=
 my=5Ftrigger=5Fdata))<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(0, "uevent trigger error");<=
br> =EF=BC=9E -<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp;if (uev-=EF=BC=9Eudev)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;udev=5Fdevice=5Funref(=
uev-=EF=BC=9Eudev);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;FREE(uev);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=
=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E -static void uevent=5Fcleanup(vo=
id *arg)<br> =EF=BC=9E +void<br> =EF=BC=9E +uevent=5Fget=5Fwwid(struct ueve=
nt *uev)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;struct ud=
ev *udev =3D arg;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;int i;<br> =EF=BC=9E +=
&nbsp; &nbsp; &nbsp;char *uid=5Fattribute;<br> =EF=BC=9E +&nbsp; &nbsp; &nb=
sp;struct config * conf;<br> =EF=BC=9E<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;c=
ondlog(3, "Releasing uevent=5Flisten() resources");<br> =EF=BC=9E -&nbsp; &=
nbsp; &nbsp;udev=5Funref(udev);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;conf =3D=
 get=5Fmultipath=5Fconfig();<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;uid=5Fattri=
bute =3D parse=5Fuid=5Fattribute=5Fby=5Fattrs(<wbr>conf-=EF=BC=9Euid=5Fattr=
s, uev-=EF=BC=9Ekernel);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;put=5Fmultipath=
=5Fconfig(conf);<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (!ui=
d=5Fattribute)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;return;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;for (i =3D 0;=
 uev-=EF=BC=9Eenvp[i] !=3D NULL; i++) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;if (!strncmp(uev-=EF=BC=9Eenvp[i], uid=5Fattrib=
ute, strlen(uid=5Fattribute)) &amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;strlen(uev-=EF=BC=9Eenvp[i]) =EF=
=BC=9E strlen(uid=5Fattribute) &amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;uev-=EF=BC=9Eenvp[i][strlen(uid=
=5F<wbr>attribute)] =3D=3D '=3D') {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;uev-=EF=BC=9Ewwid =3D u=
ev-=EF=BC=9Eenvp[i] + strlen(uid=5Fattribute) + 1;<br> =EF=BC=9E +&nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;break;<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;free(uid=5Fat=
tribute);<br> =EF=BC=9E +}<br> =EF=BC=9E +<br> =EF=BC=9E +bool<br> =EF=BC=
=9E +uevent=5Fneed=5Fmerge(void)<br> =EF=BC=9E +{<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp;struct config * conf;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;bool nee=
d=5Fmerge =3D false;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;con=
f =3D get=5Fmultipath=5Fconfig();<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (co=
nf-=EF=BC=9Euid=5Fattrs)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;need=5Fmerge =3D true;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;put=
=5Fmultipath=5Fconfig(conf);<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &=
nbsp;return need=5Fmerge;<br> =EF=BC=9E +}<br> =EF=BC=9E +<br> =EF=BC=9E +b=
ool<br> =EF=BC=9E +uevent=5Fcan=5Fdiscard(struct uevent *uev)<br> =EF=BC=9E=
 +{<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;char *tmp;<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp;char a[11], b[11];<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;struct conf=
ig * conf;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;/*<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; * keep only block devices, discard partitions<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;tmp =
=3D strstr(uev-=EF=BC=9Edevpath, "/block/");<br> =EF=BC=9E +&nbsp; &nbsp; &=
nbsp;if (tmp =3D=3D NULL){<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;condlog(4, "no /block/ in '%s'", uev-=EF=BC=9Edevpath);<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return true;<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (ss=
canf(tmp, "/block/%10s", a) !=3D 1 ||<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;sscanf(tmp, "/block/%10[^/]/%10s", a, b) =3D=3D 2) {<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(4, "discard ev=
ent on %s", uev-=EF=BC=9Edevpath);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;return true;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br=
> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E +&nbsp; &=
nbsp; &nbsp; * do not filter dm devices by devnode<br> =EF=BC=9E +&nbsp; &n=
bsp; &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (!strncmp(uev-=EF=BC=
=9Ekernel, "dm-", 3))<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;return false;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E=
 +&nbsp; &nbsp; &nbsp; * filter paths devices by devnode<br> =EF=BC=9E +&nb=
sp; &nbsp; &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;conf =3D get=5Fmult=
ipath=5Fconfig();<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (filter=5Fdevnode(c=
onf-=EF=BC=9Eblist=5F<wbr>devnode, conf-=EF=BC=9Eelist=5Fdevnode,<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; uev-=EF=BC=9Ekernel) =EF=BC=9E 0) {<br> =EF=BC=9E +&nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;put=5Fmultipath=5Fconfig(conf);<br=
> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return true;<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;put=
=5Fmultipath=5Fconfig(conf);<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &=
nbsp;return false;<br> =EF=BC=9E +}<br> =EF=BC=9E +<br> =EF=BC=9E +bool<br>=
 =EF=BC=9E +uevent=5Fcan=5Ffilter(struct uevent *earlier, struct uevent *la=
ter)<br> =EF=BC=9E +{<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;/*=
<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * filter earlier uvents if path has re=
moved later. Eg:<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * "add path1 |chang pa=
th1 |add path2 |remove path1"<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * can fil=
ter as:<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * "add path2 |remove path1"<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; * uevents "add path1" and "chang path1" ar=
e filtered out<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E +&nbsp;=
 &nbsp; &nbsp;if (!strcmp(earlier-=EF=BC=9Ekernel, later-=EF=BC=9Ekernel) &=
amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;!s=
trcmp(later-=EF=BC=9Eaction, "remove") &amp;&amp;<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;strncmp(later-=EF=BC=9Ekernel, "dm-",=
 3)) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;retur=
n true;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +<br> =EF=BC=9E =
+&nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * filter change=
 uvents if add uevents exist. Eg:<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * "ch=
ange path1| add path1 |add path2"<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * can=
 filter as:<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * "add path1 |add path2"<br=
> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * uevent "chang path1" is filtered out<br=
> =EF=BC=9E +&nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if =
(!strcmp(earlier-=EF=BC=9Ekernel, later-=EF=BC=9Ekernel) &amp;&amp;<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;!strcmp(earlier-=EF=
=BC=9Eaction, "change") &amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;!strcmp(later-=EF=BC=9Eaction, "add") &amp;&amp;<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;strncmp(later-=
=EF=BC=9Ekernel, "dm-", 3)) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp;return true;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=
=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;return false;<br> =EF=BC=9E +}<=
br> =EF=BC=9E +<br> =EF=BC=9E +bool<br> =EF=BC=9E +merge=5Fneed=5Fstop(stru=
ct uevent *earlier, struct uevent *later)<br> =EF=BC=9E +{<br> =EF=BC=9E +&=
nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * dm uevent do no=
t try to merge with left uevents<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; */<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (!strncmp(later-=EF=BC=9Ekernel, "dm-", =
3))<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return t=
rue;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E +&=
nbsp; &nbsp; &nbsp; * we can not make a jugement without wwid,<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; * so it is sensible to stop merging<br> =EF=BC=9E=
 +&nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (!earlier-=
=EF=BC=9Ewwid || !later-=EF=BC=9Ewwid)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;return true;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;=
/*<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * uevents merging stoped<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; * when we meet an opposite action uevent from the=
 same LUN to AVOID<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * "add path1 |remove=
 path1 |add path2 |remove path2 |add path3"<br> =EF=BC=9E +&nbsp; &nbsp; &n=
bsp; * to merge as "remove path1, path2" and "add path1, path2, path3"<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; * OR<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * =
"remove path1 |add path1 |remove path2 |add path2 |remove path3"<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; * to merge as "add path1, path2" and "remove path=
1, path2, path3"<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * SO<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp; * when we meet a non-change uevent from the same LUN<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; * with the same wwid and different action<=
br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * it would be better to stop merging.<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if=
 (!strcmp(earlier-=EF=BC=9Ewwid, later-=EF=BC=9Ewwid) &amp;&amp;<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;strcmp(earlier-=EF=BC=9Eaction, late=
r-=EF=BC=9Eaction) &amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp;strcmp(earlier-=EF=BC=9Eaction, "change") &amp;&amp;<br> =EF=BC=9E +&nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp;strcmp(later-=EF=BC=9Eaction, "change"))<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return true;<br=
> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;return false;<br> =EF=BC=
=9E +}<br> =EF=BC=9E +<br> =EF=BC=9E +bool<br> =EF=BC=9E +uevent=5Fcan=5Fme=
rge(struct uevent *earlier, struct uevent *later)<br> =EF=BC=9E +{<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp;/* merge paths uevents<br> =EF=BC=9E +&nbsp; &n=
bsp; &nbsp; * whose wwids exsit and are same<br> =EF=BC=9E +&nbsp; &nbsp; &=
nbsp; * and actions are same,<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * and act=
ions are addition or deletion<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; */<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp;if (earlier-=EF=BC=9Ewwid &amp;&amp; later-=
=EF=BC=9Ewwid &amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;!=
strcmp(earlier-=EF=BC=9Ewwid, later-=EF=BC=9Ewwid) &amp;&amp;<br> =EF=BC=9E=
 +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;!strcmp(earlier-=EF=BC=9Eaction, later-=
=EF=BC=9Eaction) &amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;strncmp(earlier-=EF=BC=9Eaction, "change", 6) &amp;&amp;<br> =EF=BC=9E +&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;strncmp(earlier-=EF=BC=9Ekernel, "dm-", 3)=
) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return t=
rue;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp;return false;<br> =EF=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=
=BC=9E&nbsp; void<br> =EF=BC=9E -uevq=5Fcleanup(struct list=5Fhead *tmpq)<b=
r> =EF=BC=9E +uevent=5Fprepare(struct list=5Fhead *tmpq)<br> =EF=BC=9E +{<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp;struct uevent *uev, *tmp;<br> =EF=BC=9E +=
<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;list=5Ffor=5Feach=5Fentry=5Freverse=5F<=
wbr>safe(uev, tmp, tmpq, node) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp;if (uevent=5Fcan=5Fdiscard(uev)) {<br> =EF=BC=9E +&nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;lis=
t=5Fdel=5Finit(&amp;uev-=EF=BC=9Enode);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (uev-=EF=BC=9Eud=
ev)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;udev=5Fdevice=5Funref(uev-=
=EF=BC=9Eudev);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;FREE(uev);<br> =EF=BC=9E +&nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;continue;<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E =
+<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (strncm=
p(uev-=EF=BC=9Ekernel, "dm-", 3) &amp;&amp;<br> =EF=BC=9E +&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;uevent=5Fneed=5Fmerge())<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;uevent=5Fget=5Fwwid(uev);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<=
br> =EF=BC=9E +}<br> =EF=BC=9E +<br> =EF=BC=9E +void<br> =EF=BC=9E +uevent=
=5Ffilter(struct uevent *later, struct list=5Fhead *tmpq)<br> =EF=BC=9E +{<=
br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;struct uevent *earlier, *tmp;<br> =EF=BC=
=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;list=5Ffor=5Fsome=5Fentry=5Frevers=
e=5F<wbr>safe(earlier, tmp, &amp;later-=EF=BC=9Enode, tmpq, node) {<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E +&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; * filter unnessary earlier =
uevents<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; * b=
y the later uevent<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;i=
f (uevent=5Fcan=5Ffilter(earlier, later)) {<br> =EF=BC=9E +&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(2, "uev=
ent: %s-%s has filtered by uevent: %s-%s",<br> =EF=BC=9E +&nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;earlier-=EF=BC=9Ekernel, earlier-=EF=BC=9Eaction,<br> =EF=BC=9E=
 +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp;later-=EF=BC=9Ekernel, later-=EF=BC=9Eaction=
);<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;list=5Fdel=5Finit(&amp;earlier-=EF=BC=9E=
node);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;if (earlier-=EF=BC=9Eudev)<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp;udev=5Fdevice=5Funref(earlier-=EF=BC=9E<wbr>udev);<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;FREE(earlier);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +}<br> =
=EF=BC=9E +<br> =EF=BC=9E +void<br> =EF=BC=9E +uevent=5Fmerge(struct uevent=
 *later, struct list=5Fhead *tmpq)<br> =EF=BC=9E +{<br> =EF=BC=9E +&nbsp; &=
nbsp; &nbsp;struct uevent *earlier, *tmp;<br> =EF=BC=9E +<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp;list=5Ffor=5Fsome=5Fentry=5Freverse=5F<wbr>safe(earlier, =
tmp, &amp;later-=EF=BC=9Enode, tmpq, node) {<br> =EF=BC=9E +&nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (merge=5Fneed=5Fstop(earlier, later))<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;break;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;/*<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; * merge earlier uevents to the later uevent<br> =EF=BC=9E +&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp;if (uevent=5Fcan=5Fmerge(earlier, later)) {<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;condlog(2, "merged uevent: %s-%s-%s with uevent: %s-%s-%s",<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;earlier-=EF=BC=9Eaction, earlier-=
=EF=BC=9Ekernel, earlier-=EF=BC=9Ewwid,<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp;later-=EF=BC=9Eaction, later-=EF=BC=9Ekernel, later-=EF=BC=9Ewwid)=
;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;list=5Fmove(&amp;earlier-=EF=BC=9Enode, &=
amp;later-=EF=BC=9Emerge=5Fnode);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E =
+}<br> =EF=BC=9E +<br> =EF=BC=9E +void<br> =EF=BC=9E +merge=5Fuevq(struct l=
ist=5Fhead *tmpq)<br> =EF=BC=9E +{<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;struc=
t uevent *later;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;uevent=
=5Fprepare(tmpq);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;list=5Ffor=5Feach=5Fen=
try=5Freverse(<wbr>later, tmpq, node) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;uevent=5Ffilter(later, tmpq);<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if(uevent=5Fneed=5Fmerge())<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;uevent=5Fmerge(later, tmpq);<br> =EF=BC=9E +&nbsp; &nbsp; &n=
bsp;}<br> =EF=BC=9E +}<br> =EF=BC=9E +<br> =EF=BC=9E +void<br> =EF=BC=9E +s=
ervice=5Fuevq(struct list=5Fhead *tmpq)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E=
&nbsp; &nbsp; &nbsp; &nbsp;struct uevent *uev, *tmp;<br> =EF=BC=9E<br> =EF=
=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;list=5Ffor=5Feach=5Fentry=5Fsafe(uev, tmp,=
 tmpq, node) {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp;list=5Fdel=5Finit(&amp;uev-=EF=BC=9Enode);<br> =EF=BC=9E +<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (my=5Fuev=5Ftrig=
ger &amp;&amp; my=5Fuev=5Ftrigger(uev, my=5Ftrigger=5Fdata))<br> =EF=BC=9E =
+&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;condlog(0, "uevent trigger error");<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;uevq=5Fcleanup(&amp;uev-=EF=BC=9E=
merge=5Fnode)<wbr>;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp;if (uev-=EF=BC=9Eudev)<br> =EF=BC=9E +&nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;udev=5Fdevic=
e=5Funref(uev-=EF=BC=9Eudev);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;FREE(uev);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;}=
<br> =EF=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E +static void uevent=5Fcl=
eanup(void *arg)<br> =EF=BC=9E +{<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;struct=
 udev *udev =3D arg;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;con=
dlog(3, "Releasing uevent=5Flisten() resources");<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp;udev=5Funref(udev);<br> =EF=BC=9E +}<br> =EF=BC=9E +<br> =EF=BC=
=9E&nbsp; /*<br> =EF=BC=9E&nbsp; &nbsp;* Service the uevent queue.<br> =EF=
=BC=9E&nbsp; &nbsp;*/<br> =EF=BC=9E @@ -142,6 +405,7 @@ int uevent=5Fdispat=
ch(int (*uev=5Ftrigger)(struct uevent *, void * trigger=5Fdata),<br> =EF=BC=
=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pthread=5Fmutex=
=5Funlock(uevq=5F<wbr>lockp);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;if (!my=5Fuev=5Ftrigger)<br> =EF=BC=9E&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;break;=
<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;merge=5Fuev=
q(&amp;uevq=5Ftmp);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;service=5Fuevq(&amp;uevq=5Ftmp);<br> =EF=BC=9E&nbsp; &nbsp; &n=
bsp; &nbsp;}<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;condlog(3, "Terminatin=
g uev service queue");<br> =EF=BC=9E @@ -442,11 +706,43 @@ struct uevent *u=
event=5Ffrom=5Fudev=5Fdevice(<wbr>struct udev=5Fdevice *dev)<br> =EF=BC=9E&=
nbsp; &nbsp; &nbsp; &nbsp;return uev;<br> =EF=BC=9E&nbsp; }<br> =EF=BC=9E<b=
r> =EF=BC=9E +bool uevent=5Fburst(struct timeval *start=5Ftime, int events)=
<br> =EF=BC=9E +{<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;struct timeval diff=5F=
time, end=5Ftime;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;unsigned long speed;<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp;unsigned long eclipse=5Fms;<br> =EF=BC=9E=
 +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if(events =EF=BC=9E MAX=5FACCUMULATIO=
N=5FCOUNT) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;condlog(2, "burst got %u uevents, too much uevents, stopped", events);<br>=
 =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return false;<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &=
nbsp; &nbsp;gettimeofday(&amp;end=5Ftime, NULL);<br> =EF=BC=9E +&nbsp; &nbs=
p; &nbsp;timersub(&amp;end=5Ftime, start=5Ftime, &amp;diff=5Ftime);<br> =EF=
=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;eclipse=5Fms =3D diff=5Ftime.tv=
=5Fsec * 1000 + diff=5Ftime.tv=5Fusec / 1000;<br> =EF=BC=9E +<br> =EF=BC=9E=
 +&nbsp; &nbsp; &nbsp;if (eclipse=5Fms =3D=3D 0)<br> =EF=BC=9E +&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return true;<br> =EF=BC=9E +<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp;if (eclipse=5Fms =EF=BC=9E MAX=5FACCUMULATION=
=5FTIME) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;c=
ondlog(2, "burst continued %lu ms, too long time, stopped", eclipse=5Fms);<=
br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return false=
;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp=
; &nbsp; &nbsp;speed =3D (events * 1000) / eclipse=5Fms;<br> =EF=BC=9E +&nb=
sp; &nbsp; &nbsp;if (speed =EF=BC=9E MIN=5FBURST=5FSPEED)<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return true;<br> =EF=BC=9E +<=
br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;return false;<br> =EF=BC=9E +}<br> =EF=
=BC=9E +<br> =EF=BC=9E&nbsp; int uevent=5Flisten(struct udev *udev)<br> =EF=
=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;int err =3D 2;<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;struct udev=5Fmonitor *monitor =3D NULL=
;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;int fd, socket=5Fflags, events;<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp;struct timeval start=5Ftime;<br> =EF=BC=
=9E&nbsp; &nbsp; &nbsp; &nbsp;int need=5Ffailback =3D 1;<br> =EF=BC=9E&nbsp=
; &nbsp; &nbsp; &nbsp;int timeout =3D 30;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp;=
 &nbsp;LIST=5FHEAD(uevlisten=5Ftmp);<br> =EF=BC=9E @@ -500,6 +796,7 @@ int =
uevent=5Flisten(struct udev *udev)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;=
}<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;events =3D 0;<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp;gettimeofday(&amp;start=5Ftime, NULL);<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;while (1) {<br> =EF=BC=9E&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;struct uevent *uev;<br> =EF=BC=9E&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;struct udev=5Fdevice =
*dev;<br> =EF=BC=9E @@ -514,7 +811,7 @@ int uevent=5Flisten(struct udev *ud=
ev)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;err=
no =3D 0;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;fdcount =3D poll(&amp;ev=5Fpoll, 1, poll=5Ftimeout);<br> =EF=BC=9E&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (fdcount &amp;&amp; ev=
=5Fpoll.revents &amp; POLLIN) {<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;timeout =3D 0;<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;timeout =3D uevent=5Fburst(&amp;start=5Ftime, events + 1) ? 1 : 0;<br=
> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp;dev =3D udev=5Fmonitor=5Freceive=5Fdevice(<wbr>monitor);=
<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;if (!dev) {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp;condlog(0, "failed getting udev device");<br> =EF=BC=9E @@ -547,6 +=
844,7 @@ int uevent=5Flisten(struct udev *udev)<br> =EF=BC=9E&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pthrea=
d=5Fmutex=5Funlock(uevq=5F<wbr>lockp);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;events =3D 0;<b=
r> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;gettimeofday(&am=
p;start=5Ftime, NULL);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp;timeout =3D 30;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;}<b=
r> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;need=5Ffailback =3D 0;<br> =EF=BC=9E=
 diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h<br> =EF=BC=9E i=
ndex 9d22dcd..61a4207 100644<br> =EF=BC=9E --- a/libmultipath/uevent.h<br> =
=EF=BC=9E +++ b/libmultipath/uevent.h<br> =EF=BC=9E @@ -17,11 +17,13 @@ str=
uct udev;<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; struct uevent {<br> =EF=BC=9E&n=
bsp; &nbsp; &nbsp; &nbsp;struct list=5Fhead node;<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp;struct list=5Fhead merge=5Fnode;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp=
; &nbsp;struct udev=5Fdevice *udev;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp=
;char buffer[HOTPLUG=5FBUFFER=5FSIZE + OBJECT=5FSIZE];<br> =EF=BC=9E&nbsp; =
&nbsp; &nbsp; &nbsp;char *devpath;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;=
char *action;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;char *kernel;<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp;char *wwid;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &=
nbsp;unsigned long seqnum;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;char *en=
vp[HOTPLUG=5FNUM=5FENVP];<br> =EF=BC=9E&nbsp; };<br> =EF=BC=9E diff --git a=
/libmultipath/util.c b/libmultipath/util.c<br> =EF=BC=9E index 03a5738..e1e=
83cf 100644<br> =EF=BC=9E --- a/libmultipath/util.c<br> =EF=BC=9E +++ b/lib=
multipath/util.c<br> =EF=BC=9E @@ -261,6 +261,48 @@ dev=5Ft parse=5Fdevt(co=
nst char *dev=5Ft)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;return makedev(m=
aj, min);<br> =EF=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E +char *parse=5F=
uid=5Fattribute=5Fby=5Fattrs(<wbr>char *uid=5Fattrs, char *path=5Fdev)<br> =
=EF=BC=9E +{<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;char *uid=5Fattribute;<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp;char *uid=5Fattr=5Frecord;<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp;char *dev;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;char *attr;=
<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;char *tmp;<br> =EF=BC=9E +&nbsp; &nbsp;=
 &nbsp;int&nbsp; count;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;=
if(!uid=5Fattrs || !path=5Fdev)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;return NULL;<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbs=
p; &nbsp;count =3D get=5Fword(uid=5Fattrs, &amp;uid=5Fattr=5Frecord);<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp;while (uid=5Fattr=5Frecord) {<br> =EF=BC=9E =
+&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;tmp =3D strrchr(uid=5Fattr=
=5Frecord, ':');<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp;if (!tmp) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;free(uid=5Fattr=5Frecord);<br> =EF=BC=9E +=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;if (!count)<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;break;<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;uid=5Fattrs +=3D count;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;count =3D get=5Fword(uid=5Fat=
trs, &amp;uid=5Fattr=5Frecord);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;continue;<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;dev =3D uid=5Fattr=5Frecord;<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;attr =3D tmp + 1;<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*tmp =3D '\0';<b=
r> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;if(!strncmp(path=5Fdev, dev, strlen(dev))) {<br> =EF=BC=9E +&nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;uid=5Fattri=
bute =3D STRDUP(attr);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;free(uid=5Fattr=5Frecord);<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp;return uid=5Fattribute;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;free(uid=5Fattr=5Frecord);<br> =EF=BC=9E +&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (!count)<br> =EF=BC=9E +&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;break=
;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;uid=5Fattr=
s +=3D count;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p;count =3D get=5Fword(uid=5Fattrs, &amp;uid=5Fattr=5Frecord);<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;return NULL;<=
br> =EF=BC=9E +}<br> =EF=BC=9E +<br> =EF=BC=9E&nbsp; void<br> =EF=BC=9E&nbs=
p; setup=5Fthread=5Fattr(pthread=5F<wbr>attr=5Ft *attr, size=5Ft stacksize,=
 int detached)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E diff --git a/libmultipat=
h/util.h b/libmultipath/util.h<br> =EF=BC=9E index f3b37ee..793f2b7 100644<=
br> =EF=BC=9E --- a/libmultipath/util.h<br> =EF=BC=9E +++ b/libmultipath/ut=
il.h<br> =EF=BC=9E @@ -12,6 +12,7 @@ size=5Ft strlcat(char *dst, const char=
 *src, size=5Ft size);<br> =EF=BC=9E&nbsp; int devt2devname (char *, int, c=
har *);<br> =EF=BC=9E&nbsp; dev=5Ft parse=5Fdevt(const char *dev=5Ft);<br> =
=EF=BC=9E&nbsp; char *convert=5Fdev(char *dev, int is=5Fpath=5Fdevice);<br>=
 =EF=BC=9E +char *parse=5Fuid=5Fattribute=5Fby=5Fattrs(<wbr>char *uid=5Fatt=
rs, char *path=5Fdev);<br> =EF=BC=9E&nbsp; void setup=5Fthread=5Fattr(pthre=
ad=5F<wbr>attr=5Ft *attr, size=5Ft stacksize, int detached);<br> =EF=BC=9E<=
br> =EF=BC=9E&nbsp; #define safe=5Fsprintf(var, format, args...)&nbsp; &nbs=
p;\<br> =EF=BC=9E diff --git a/multipath/multipath.conf.5 b/multipath/multi=
path.conf.5<br> =EF=BC=9E index 36589f5..63c63c2 100644<br> =EF=BC=9E --- a=
/multipath/multipath.conf.5<br> =EF=BC=9E +++ b/multipath/multipath.conf.5<=
br> =EF=BC=9E @@ -209,6 +209,24 @@ The default is: \fBfailover\fR<br> =EF=
=BC=9E&nbsp; .<br> =EF=BC=9E&nbsp; .<br> =EF=BC=9E&nbsp; .TP<br> =EF=BC=9E =
+.B uid=5Fattrs<br> =EF=BC=9E +The udev attribute providing a unique path i=
dentifier for corresponding<br> =EF=BC=9E +type of path devices. If this fi=
eld is configured and matched with type<br> =EF=BC=9E +of device, it would =
override any other methods providing for device<br> =EF=BC=9E +unique ident=
ifier in config file, and it would activate merging uevents<br> =EF=BC=9E +=
according to the identifier to promote effiecncy in processing uevents.<br>=
 =EF=BC=9E +Tt has no default value, if you want to identify path by udev a=
ttribute<br> =EF=BC=9E +and to activate merging uevents for SCSI and DAS de=
vice, you can set<br> =EF=BC=9E +it's value as:<br> =EF=BC=9E +.RS<br> =EF=
=BC=9E +.TP<br> =EF=BC=9E +\fBuid=5Fattrs "sd:ID=5FSERIAL dasd:ID=5FUID"\fR=
<br> =EF=BC=9E +.TP<br> =EF=BC=9E +The default is: \fB=EF=BC=9Cunset=EF=BC=
=9E\fR<br> =EF=BC=9E +.RE<br> =EF=BC=9E +.<br> =EF=BC=9E +.<br> =EF=BC=9E +=
.TP<br> =EF=BC=9E&nbsp; .B uid=5Fattribute<br> =EF=BC=9E&nbsp; The udev att=
ribute providing a unique path identifier.<br> =EF=BC=9E&nbsp; .RS<br> =EF=
=BC=9E diff --git a/multipathd/cli=5Fhandlers.c b/multipathd/cli=5Fhandlers=
.c<br> =EF=BC=9E index b0eeca6..12f85de 100644<br> =EF=BC=9E --- a/multipat=
hd/cli=5Fhandlers.c<br> =EF=BC=9E +++ b/multipathd/cli=5Fhandlers.c<br> =EF=
=BC=9E @@ -670,7 +670,7 @@ cli=5Fadd=5Fpath (void * v, char ** reply, int *=
 len, void * data)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;pp-=EF=BC=9Echeckint =3D conf-=EF=BC=9Echeckint;<br> =EF=BC=9E&=
nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;put=5Fm=
ultipath=5Fconfig(conf);<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;return ev=5Fadd=
=5Fpath(pp, vecs);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;return ev=5Fadd=5Fpat=
h(pp, vecs, 1);<br> =EF=BC=9E&nbsp; blacklisted:<br> =EF=BC=9E&nbsp; &nbsp;=
 &nbsp; &nbsp;*reply =3D strdup("blacklisted\n");<br> =EF=BC=9E&nbsp; &nbsp=
; &nbsp; &nbsp;*len =3D strlen(*reply) + 1;<br> =EF=BC=9E @@ -692,7 +692,7 =
@@ cli=5Fdel=5Fpath (void * v, char ** reply, int * len, void * data)<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(0, =
"%s: path already removed", param);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;return 1;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &n=
bsp;}<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;return ev=5Fremove=5Fpath(pp, vecs=
);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;return ev=5Fremove=5Fpath(pp, vecs, 1=
);<br> =EF=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; int<br> =EF=BC=
=9E diff --git a/multipathd/main.c b/multipathd/main.c<br> =EF=BC=9E index =
adc3258..e513f7d 100644<br> =EF=BC=9E --- a/multipathd/main.c<br> =EF=BC=9E=
 +++ b/multipathd/main.c<br> =EF=BC=9E @@ -608,7 +608,7 @@ ev=5Fremove=5Fma=
p (char * devname, char * alias, int minor, struct vectors * vecs)<br> =EF=
=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; static int<br> =EF=BC=9E -=
uev=5Fadd=5Fpath (struct uevent *uev, struct vectors * vecs)<br> =EF=BC=9E =
+uev=5Fadd=5Fpath (struct uevent *uev, struct vectors * vecs, int need=5Fdo=
=5Fmap)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;struc=
t path *pp;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;int ret =3D 0, i;<br> =
=EF=BC=9E @@ -641,7 +641,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct =
vectors * vecs)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; DI=5FALL | DI=5FBLACKLIST);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;put=5Fmultipath=5Fcon=
fig(conf);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;if (r =3D=3D PATHINFO=5FOK)<br> =EF=BC=9E -=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;ret =3D ev=5Fadd=5Fpath(pp, vecs);<br> =EF=BC=
=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ret =3D ev=5Fadd=5Fpath(pp, vecs, need=5F=
do=5Fmap);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp;else if (r =3D=3D PATHINFO=5FSKIPPED) {<br>=
 =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(3, "%s: remove blackl=
isted path",<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;uev-=EF=BC=9Ekernel);<br> =EF=BC=9E @@ -665,7 +665,7 @@ uev=
=5Fadd=5Fpath (struct uevent *uev, struct vectors * vecs)<br> =EF=BC=9E&nbs=
p; &nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;conf =3D=
 get=5Fmultipath=5Fconfig();<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;ret =
=3D alloc=5Fpath=5Fwith=5Fpathinfo(conf, uev-=EF=BC=9Eudev,<br> =EF=BC=9E -=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DI=5FALL, &amp;pp);<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; uev-=EF=BC=9E=
wwid, DI=5FALL, &amp;pp);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;put=5Fmul=
tipath=5Fconfig(conf);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;if (!pp) {<b=
r> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (ret =
=3D=3D PATHINFO=5FSKIPPED)<br> =EF=BC=9E @@ -681,7 +681,7 @@ uev=5Fadd=5Fpa=
th (struct uevent *uev, struct vectors * vecs)<br> =EF=BC=9E&nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;conf =3D get=5Fmultipath=5Fconfig()=
;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pp-=
=EF=BC=9Echeckint =3D conf-=EF=BC=9Echeckint;<br> =EF=BC=9E&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;put=5Fmultipath=5Fconfig(conf);<br> =
=EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ret =3D ev=5Fadd=
=5Fpath(pp, vecs);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp;ret =3D ev=5Fadd=5Fpath(pp, vecs, need=5Fdo=5Fmap);<br> =EF=BC=9E&nb=
sp; &nbsp; &nbsp; &nbsp;} else {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp;condlog(0, "%s: failed to store path info, "<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp;"dropping event",<br> =EF=BC=9E @@ -699,7 +699,7 @@ uev=5F=
add=5Fpath (struct uevent *uev, struct vectors * vecs)<br> =EF=BC=9E&nbsp; =
&nbsp;* 1: error<br> =EF=BC=9E&nbsp; &nbsp;*/<br> =EF=BC=9E&nbsp; int<br> =
=EF=BC=9E -ev=5Fadd=5Fpath (struct path * pp, struct vectors * vecs)<br> =
=EF=BC=9E +ev=5Fadd=5Fpath (struct path * pp, struct vectors * vecs, int ne=
ed=5Fdo=5Fmap)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbs=
p;struct multipath * mpp;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;char para=
ms[PARAMS=5FSIZE] =3D {0};<br> =EF=BC=9E @@ -767,6 +767,13 @@ rescan:<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;/* persistent reservation check*/<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;mpath=5Fpr=5Fevent=5Fhandle(pp);<br> =
=EF=BC=9E<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (!need=5Fdo=5Fmap)<br> =EF=
=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 0;<br> =EF=
=BC=9E +<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (!dm=5Fmap=5Fpresent(mpp-=EF=
=BC=9Ealias)) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp;mpp-=EF=BC=9Eaction =3D ACT=5FCREATE;<br> =EF=BC=9E +&nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp;start=5Fwaiter =3D 1;<br> =EF=BC=9E +&nbsp; &=
nbsp; &nbsp;}<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E&nbsp=
; &nbsp; &nbsp; &nbsp; * push the map to the device-mapper<br> =EF=BC=9E&nb=
sp; &nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E @@ -833,7 +840,7 @@ fail:<br> =EF=
=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; static int<br> =EF=BC=9E -=
uev=5Fremove=5Fpath (struct uevent *uev, struct vectors * vecs)<br> =EF=BC=
=9E +uev=5Fremove=5Fpath (struct uevent *uev, struct vectors * vecs, int ne=
ed=5Fdo=5Fmap)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbs=
p;struct path *pp;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;int ret;<br> =EF=
=BC=9E @@ -844,7 +851,7 @@ uev=5Fremove=5Fpath (struct uevent *uev, struct =
vectors * vecs)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;pthread=5Ftestcance=
l();<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;pp =3D find=5Fpath=5Fby=5Fdev(=
vecs-=EF=BC=9E<wbr>pathvec, uev-=EF=BC=9Ekernel);<br> =EF=BC=9E&nbsp; &nbsp=
; &nbsp; &nbsp;if (pp)<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp;ret =3D ev=5Fremove=5Fpath(pp, vecs);<br> =EF=BC=9E +&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ret =3D ev=5Fremove=5Fpath(pp, vecs, n=
eed=5Fdo=5Fmap);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;lock=5Fcleanup=5Fp=
op(vecs-=EF=BC=9Elock);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;if (!pp) {<=
br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/* Not =
an error; path might have been purged earlier */<br> =EF=BC=9E @@ -855,7 +8=
62,7 @@ uev=5Fremove=5Fpath (struct uevent *uev, struct vectors * vecs)<br>=
 =EF=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; int<br> =EF=BC=9E -ev=
=5Fremove=5Fpath (struct path *pp, struct vectors * vecs)<br> =EF=BC=9E +ev=
=5Fremove=5Fpath (struct path *pp, struct vectors * vecs, int need=5Fdo=5Fm=
ap)<br> =EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;struct mu=
ltipath * mpp;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;int i, retval =3D 0;=
<br> =EF=BC=9E @@ -918,6 +925,8 @@ ev=5Fremove=5Fpath (struct path *pp, str=
uct vectors * vecs)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;goto out;<br> =EF=BC=9E&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E<br> =EF=BC=9E +=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (!need=5Fdo=5Fmap)<br> =
=EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;goto out;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;/*<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; * reload the map<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E @@ -995,7 +1004,7 @@ uev=5Fupdate=
=5Fpath (struct uevent *uev, struct vectors * vecs)<br> =EF=BC=9E&nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E<br> =EF=BC=9E&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (pp-=EF=BC=9Einiti=
alized =3D=3D INIT=5FREQUESTED=5FUDEV)<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;retval =3D uev=5Fadd=
=5Fpath(uev, vecs);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;retval =3D uev=5Fadd=5Fpath(uev, vecs, =
1);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;els=
e if (mpp &amp;&amp; ro =EF=BC=9E=3D 0) {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(2, "=
%s: update path write=5Fprotect to '%d' (uevent)", uev-=EF=BC=9Ekernel, ro)=
;<br> =EF=BC=9E<br> =EF=BC=9E @@ -1016,7 +1025,7 @@ out:<br> =EF=BC=9E&nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;int flag =3D DI=5FSYSFS | DI=5FWWID;<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
conf =3D get=5Fmultipath=5Fconfig();<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;retval =3D alloc=5Fpat=
h=5Fwith=5Fpathinfo(conf, uev-=EF=BC=9Eudev, flag, NULL);<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;r=
etval =3D alloc=5Fpath=5Fwith=5Fpathinfo(conf, uev-=EF=BC=9Eudev, uev-=EF=
=BC=9Ewwid, flag, NULL);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;put=5Fmultipath=5Fconfig(conf=
);<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (retval =3D=3D PATHINFO=5FSKIPPED)=
 {<br> =EF=BC=9E @@ -1077,40 +1086,15 @@ uxsock=5Ftrigger (char * str, char=
 ** reply, int * len, void * trigger=5Fdata)<br> =EF=BC=9E&nbsp; &nbsp; &nb=
sp; &nbsp;return r;<br> =EF=BC=9E&nbsp; }<br> =EF=BC=9E<br> =EF=BC=9E -stat=
ic int<br> =EF=BC=9E -uev=5Fdiscard(char * devpath)<br> =EF=BC=9E -{<br> =
=EF=BC=9E -&nbsp; &nbsp; &nbsp;char *tmp;<br> =EF=BC=9E -&nbsp; &nbsp; &nbs=
p;char a[11], b[11];<br> =EF=BC=9E -<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;/*<=
br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; * keep only block devices, discard part=
itions<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; */<br> =EF=BC=9E -&nbsp; &nbsp; =
&nbsp;tmp =3D strstr(devpath, "/block/");<br> =EF=BC=9E -&nbsp; &nbsp; &nbs=
p;if (tmp =3D=3D NULL){<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp;condlog(4, "no /block/ in '%s'", devpath);<br> =EF=BC=9E -&nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 1;<br> =EF=BC=9E -&nbsp; =
&nbsp; &nbsp;}<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;if (sscanf(tmp, "/block/%=
10s", a) !=3D 1 ||<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;sscanf(=
tmp, "/block/%10[^/]/%10s", a, b) =3D=3D 2) {<br> =EF=BC=9E -&nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(4, "discard event on %s", devpath=
);<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 1;=
<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;re=
turn 0;<br> =EF=BC=9E -}<br> =EF=BC=9E -<br> =EF=BC=9E&nbsp; int<br> =EF=BC=
=9E&nbsp; uev=5Ftrigger (struct uevent * uev, void * trigger=5Fdata)<br> =
=EF=BC=9E&nbsp; {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;int r =3D 0;<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;struct vectors * vecs;<br> =EF=BC=9E -&=
nbsp; &nbsp; &nbsp;struct config *conf;<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;=
struct uevent *merge=5Fuev, *tmp;<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; &nbsp; =
&nbsp; &nbsp;vecs =3D (struct vectors *)trigger=5Fdata;<br> =EF=BC=9E<br> =
=EF=BC=9E -&nbsp; &nbsp; &nbsp;if (uev=5Fdiscard(uev-=EF=BC=9Edevpath))<br>=
 =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 0;<br> =
=EF=BC=9E -<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;pthread=5Fcleanup=5Fpus=
h(config=5F<wbr>cleanup, NULL);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;pth=
read=5Fmutex=5Flock(&amp;config=5F<wbr>lock);<br> =EF=BC=9E&nbsp; &nbsp; &n=
bsp; &nbsp;if (running=5Fstate !=3D DAEMON=5FIDLE &amp;&amp;<br> =EF=BC=9E =
@@ -1139,28 +1123,21 @@ uev=5Ftrigger (struct uevent * uev, void * trigger=
=5Fdata)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E<br> =EF=BC=
=9E&nbsp; &nbsp; &nbsp; &nbsp;/*<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; * path=
 add/remove event<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; * path add/remove/cha=
nge event, add/remove maybe merged<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;=
 */<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;conf =3D get=5Fmultipath=5Fconfig();=
<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;if (filter=5Fdevnode(conf-=EF=BC=9Eblis=
t=5F<wbr>devnode, conf-=EF=BC=9Eelist=5Fdevnode,<br> =EF=BC=9E -&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ue=
v-=EF=BC=9Ekernel) =EF=BC=9E 0) {<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;put=5Fmultipath=5Fconfig(conf);<br> =EF=BC=9E -&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;goto out;<br> =EF=BC=9E +&nbsp; &=
nbsp; &nbsp;list=5Ffor=5Feach=5Fentry=5Fsafe(<wbr>merge=5Fuev, tmp, &amp;ue=
v-=EF=BC=9Emerge=5Fnode, node) {<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp;if (!strncmp(merge=5Fuev-=EF=BC=9Eaction, "add", 3))<b=
r> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;r +=3D uev=5Fadd=5Fpath(merge=5Fuev, vecs, 0);<br> =EF=BC=9E=
 +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (!strncmp(merge=5Fuev-=
=EF=BC=9Eaction, "remove", 6))<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;r +=3D uev=5Fremove=5Fpath(m=
erge=5Fuev, vecs, 0);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=
=9E -&nbsp; &nbsp; &nbsp;put=5Fmultipath=5Fconfig(conf);<br> =EF=BC=9E<br> =
=EF=BC=9E -&nbsp; &nbsp; &nbsp;if (!strncmp(uev-=EF=BC=9Eaction, "add", 3))=
 {<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;r =3D uev=
=5Fadd=5Fpath(uev, vecs);<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp;goto out;<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E =
-&nbsp; &nbsp; &nbsp;if (!strncmp(uev-=EF=BC=9Eaction, "remove", 6)) {<br> =
=EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;r =3D uev=5Fremo=
ve=5Fpath(uev, vecs);<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;goto out;<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E -&nb=
sp; &nbsp; &nbsp;if (!strncmp(uev-=EF=BC=9Eaction, "change", 6)) {<br> =EF=
=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;r =3D uev=5Fupdate=
=5Fpath(uev, vecs);<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp;goto out;<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E +&nbsp=
; &nbsp; &nbsp;if (!strncmp(uev-=EF=BC=9Eaction, "add", 3))<br> =EF=BC=9E +=
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;r +=3D uev=5Fadd=5Fpath(uev=
, vecs, 1);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp;if (!strncmp(uev-=EF=BC=9Eac=
tion, "remove", 6))<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp;r +=3D uev=5Fremove=5Fpath(uev, vecs, 1);<br> =EF=BC=9E +&nbsp; &nb=
sp; &nbsp;if (!strncmp(uev-=EF=BC=9Eaction, "change", 6))<br> =EF=BC=9E +&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;r +=3D uev=5Fupdate=5Fpath(ue=
v, vecs);<br> =EF=BC=9E<br> =EF=BC=9E&nbsp; out:<br> =EF=BC=9E&nbsp; &nbsp;=
 &nbsp; &nbsp;return r;<br> =EF=BC=9E @@ -1570,7 +1547,7 @@ check=5Fpath (s=
truct vectors * vecs, struct path * pp, int ticks)<br> =EF=BC=9E&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;con=
f =3D get=5Fmultipath=5Fconfig();<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ret =3D pathinfo(pp,=
 conf, DI=5FALL | DI=5FBLACKLIST);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (ret =3D=3D PATH=
INFO=5FOK) {<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ev=5Fadd=5Fpath(pp=
, vecs);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ev=5Fadd=5Fpath(pp, ve=
cs, 1);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pp-=EF=BC=9Etick =
=3D 1;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;} else if (ret =3D=3D PATHINFO=5FSKIPPED) {<br>=
 =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;put=5Fmultipath=5Fconfig(conf=
);<br> =EF=BC=9E @@ -1686,7 +1663,7 @@ check=5Fpath (struct vectors * vecs,=
 struct path * pp, int ticks)<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp;if (!disable=5Freinstate &amp;&amp; reinstate=5Fpath(pp, =
add=5Factive)) {<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(3, "%s: reload map", pp-=EF=
=BC=9Edev);<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;ev=5Fadd=5Fpath(pp, vecs);<br> =EF=BC=9E +&nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ev=
=5Fadd=5Fpath(pp, vecs, 1);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pp-=EF=BC=9Etick =3D 1;<br=
> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp;return 0;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp;}<br> =EF=BC=9E @@ -1709,7 +1686,7 @@ check=5Fpath (s=
truct vectors * vecs, struct path * pp, int ticks)<br> =EF=BC=9E&nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/* =
Clear IO errors */<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;if (reinstate=5Fpath(pp, 0)) {<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;condlog(3, "%s: reload map", p=
p-=EF=BC=9Edev);<br> =EF=BC=9E -&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ev=5Fadd=5Fpat=
h(pp, vecs);<br> =EF=BC=9E +&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;ev=5Fadd=5Fpath(pp=
, vecs, 1);<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;pp-=EF=BC=9Eti=
ck =3D 1;<br> =EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;return 0;<br> =
=EF=BC=9E&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp;}<br> =EF=BC=9E diff --git a/multipathd/main.h b/multipath=
d/main.h<br> =EF=BC=9E index f72580d..094b04f 100644<br> =EF=BC=9E --- a/mu=
ltipathd/main.h<br> =EF=BC=9E +++ b/multipathd/main.h<br> =EF=BC=9E @@ -22,=
8 +22,8 @@ void exit=5Fdaemon(void);<br> =EF=BC=9E&nbsp; const char * daemo=
n=5Fstatus(void);<br> =EF=BC=9E&nbsp; int need=5Fto=5Fdelay=5Freconfig (str=
uct vectors *);<br> =EF=BC=9E&nbsp; int reconfigure (struct vectors *);<br>=
 =EF=BC=9E -int ev=5Fadd=5Fpath (struct path *, struct vectors *);<br> =EF=
=BC=9E -int ev=5Fremove=5Fpath (struct path *, struct vectors *);<br> =EF=
=BC=9E +int ev=5Fadd=5Fpath (struct path *, struct vectors *, int);<br> =EF=
=BC=9E +int ev=5Fremove=5Fpath (struct path *, struct vectors *, int);<br> =
=EF=BC=9E&nbsp; int ev=5Fadd=5Fmap (char *, char *, struct vectors *);<br> =
=EF=BC=9E&nbsp; int ev=5Fremove=5Fmap (char *, char *, int, struct vectors =
*);<br> =EF=BC=9E&nbsp; void sync=5Fmap=5Fstate (struct multipath *);<br> =
=EF=BC=9E --<br> =EF=BC=9E 2.8.1.windows.1<br> =EF=BC=9E<br> </div></div></=
blockquote></div><br></div></div><p><br></p></div></div></div></div><p><br>=
</p> </div>

--=====_003_next=====--

--=====_002_next=====--

--=====_001_next=====
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=====_001_next=====--
