From: <tang.junhui@zte.com.cn>
Subject: Re:
	=?utf-8?q?=5BPATCH=5D_multipath-tools=3A_improve_proce?=
	=?utf-8?q?ssing_efficiency_for_addition_and_deletion_of_multipath_?=
	=?utf-8?q?devices?=
Date: Thu, 16 Feb 2017 15:07:21 +0800 (CST)
Message-ID: <201702161507215542733@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="=====_001_next====="
Return-path: <dm-devel-bounces@redhat.com>
References: 1484725113-5400-1-git-send-email-tang.junhui@zte.com.cn,
	20170215210805.GS22981@octiron.msp.redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmarzins@redhat.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, mwilck@suse.com, tang.wenjun3@zte.com.cn, bart.vanassche@sandisk.com
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

Hello Ben,




Good catch, you are so nice and responsible person.

I have modified those bugs and resended the patch just now,

Please have a review for it.




Thanks,

Tang Junhui















=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6



=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A =EF=BC=9Cbmarzins@redhat.com=EF=BC=9E
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9A=E5=94=90=E5=86=9B=E8=BE=8910074136
=E6=8A=84=E9=80=81=E4=BA=BA=EF=BC=9A=E5=94=90=E6=96=87=E4=BF=8A10144149=E5=
=BC=A0=E5=87=AF10072500 =EF=BC=9Cdm-devel@redhat.com=EF=BC=9E =EF=BC=9Cbart=
.vanassche@sandisk.com=EF=BC=9E =EF=BC=9Cmwilck@suse.com=EF=BC=9E
=E6=97=A5 =E6=9C=9F =EF=BC=9A2017=E5=B9=B402=E6=9C=8816=E6=97=A5 05:15
=E4=B8=BB =E9=A2=98 =EF=BC=9ARe: [dm-devel] [PATCH] multipath-tools: improv=
e processing efficiency for addition and deletion of multipath devices





On Wed, Jan 18, 2017 at 03:38:33PM +0800, tang.junhui@zte.com.cn wrote:
=EF=BC=9E From: "tang.junhui" =EF=BC=9Ctang.junhui@zte.com.cn=EF=BC=9E
=EF=BC=9E=20
=EF=BC=9E Change-Id: I3f81a55fff389f991f915927000b281d7e263cc5
=EF=BC=9E Signed-off-by: tang.junhui =EF=BC=9Ctang.junhui@zte.com.cn=EF=BC=
=9E
=EF=BC=9E=20
=EF=BC=9E This patch used to improve processing efficiency for addition and=
 deletion
=EF=BC=9E of multipath devices.
=EF=BC=9E=20
=EF=BC=9E This patch is tested pass by ZTE multipath automatic testing syst=
em.
=EF=BC=9E The modification reduces the system consumption(such as CPU) and =
shortens
=EF=BC=9E the processing time obviously in scene of massive multipath devic=
es
=EF=BC=9E addition or deletion.
=EF=BC=9E=20
=EF=BC=9E The main processing flow of code is:
=EF=BC=9E 1) add uid=5Fattrs configuration in the defaults section:
=EF=BC=9E    It is configured udev attribute which providing a unique path =
identifier
=EF=BC=9E    for corresponding type of path devices. If this field is confi=
gured and
=EF=BC=9E    matched with type of device, it would override any other metho=
ds providing
=EF=BC=9E    for device unique identifier in config file, and it would acti=
vate merging
=EF=BC=9E    uevents according to the identifier to promote effiecncy in pr=
ocessing
=EF=BC=9E    uevents. Tt has no default value, so defaultly only uevents fi=
ltering
=EF=BC=9E    works, and uevents merging does not works, if users want to id=
entify path
=EF=BC=9E    by udev attribute and to activate merging uevents for SCSI and=
 DAS device,
=EF=BC=9E    they can set it's value as:
=EF=BC=9E    "sd:ID=5FSERIAL dasd:ID=5FUID"
=EF=BC=9E 2) uevents accumulation in uevents burst scene:
=EF=BC=9E    wait one seconds for more uevents in uevent=5Flisten() in ueve=
nts burst
=EF=BC=9E    situations
=EF=BC=9E 3) uevents preparing, filtering and merging:
=EF=BC=9E    discard unuse uevents and fetch path idendifier from uevents
=EF=BC=9E    filter uevents
=EF=BC=9E    merge uevents.
=EF=BC=9E 4) uevents proccessing:
=EF=BC=9E    proccess the merged uevents in uev-=EF=BC=9Emerge=5Fnode list =
without calling
=EF=BC=9E    domap()
=EF=BC=9E    proccess the last uevents uev with calling domap().
=EF=BC=9E=20
=EF=BC=9E Any comment will be welcome, and it would be appreciated if these
=EF=BC=9E patches would be considered for inclusion in the upstream
=EF=BC=9E multipath-tools.

Sorry for letting this slip through the cracks. This patch is really
close. I just have a few issues. First off, this is completely
superficial, but select=5Fgetuid() should use the new style of origin
messages. instead of

origin =3D "(config file default)"

it should probably be

origin =3D "(setting: multipath.conf defaults/devices section)"

to match the other messages.


Second, there is a bug in parse=5Fuid=5Fattribute=5Fby=5Fattrs(). get=5Fwor=
d()
returns the number of characters that the returned word takes up in the
sentence, but you keep using it as the offset from the start of
uid=5Fattrs.  This doesn't effect the first call to get=5Fword(), since it
doesn't use count. The second time you call get=5Fword(), everything still
works because the number of characters that the first word took up is
also the offset from the start of uid=5Fattrs.  However, on a
(hypothetical) third call, count is just the size of the second word,
but you use are using it as the offset from the start of uid=5Fattrs (the
size of the first and second word combined). This means that the a third
call won't start at the correct place, and can get stuck in an endless
loop. Obviously, as long as uid=5Fattrs only has two words in the value,
this isn't a problem.  But if we ever add another uid attribute to the
list, it will break.


Finally, in uevent=5Fget=5Fwwid, the goal is to see an environment variable
like

ID=5FSERIAL=3D3600d0230000000000e13955cc3757800

and correctly grab "3600d0230000000000e13955cc3757800" as the wwid.
Unfortunately in the list of environment variables for scsi devices,
there is also

ID=5FSERIAL=5FSHORT=3D600d0230000000000e13955cc3757800

If multipath happened to see this environment variable first, it would
grab "SHORT=3D600d0230000000000e13955cc3757800" as the wwid. It needs to
check that the character after strlen(uid=5Fattribute) is an equals sign.
Now, I realize that code all over multipath-tools doesn't bother
checking for an equals sign, but in this specific case there is a known
evironment variable that could cause problems if we don't check (not
that those other cases don't need fixing eventually).

otherwise, it looks great.

Thanks
-Ben

=EF=BC=9E Thank you all,
=EF=BC=9E Tang Junhui
=EF=BC=9E ---
=EF=BC=9E  libmultipath/config.c      |   3 +
=EF=BC=9E  libmultipath/config.h      |   1 +
=EF=BC=9E  libmultipath/dict.c        |   3 +
=EF=BC=9E  libmultipath/discovery.c   |   5 +-
=EF=BC=9E  libmultipath/discovery.h   |   2 +-
=EF=BC=9E  libmultipath/list.h        |  41 ++++++
=EF=BC=9E  libmultipath/propsel.c     |   7 +
=EF=BC=9E  libmultipath/uevent.c      | 319 +++++++++++++++++++++++++++++++=
++++++++++++--
=EF=BC=9E  libmultipath/uevent.h      |   2 +
=EF=BC=9E  libmultipath/util.c        |  40 ++++++
=EF=BC=9E  libmultipath/util.h        |   1 +
=EF=BC=9E  multipath/multipath.conf.5 |  18 +++
=EF=BC=9E  multipathd/cli=5Fhandlers.c  |   4 +-
=EF=BC=9E  multipathd/main.c          |  93 +++++--------
=EF=BC=9E  multipathd/main.h          |   4 +-
=EF=BC=9E  15 files changed, 468 insertions(+), 75 deletions(-)
=EF=BC=9E=20
=EF=BC=9E diff --git a/libmultipath/config.c b/libmultipath/config.c
=EF=BC=9E index 15ddbd8..765e91d 100644
=EF=BC=9E --- a/libmultipath/config.c
=EF=BC=9E +++ b/libmultipath/config.c
=EF=BC=9E @@ -488,6 +488,9 @@ free=5Fconfig (struct config * conf)
=EF=BC=9E      if (conf-=EF=BC=9Euid=5Fattribute)
=EF=BC=9E          FREE(conf-=EF=BC=9Euid=5Fattribute)
=EF=BC=9E =20
=EF=BC=9E +    if (conf-=EF=BC=9Euid=5Fattrs)
=EF=BC=9E +        FREE(conf-=EF=BC=9Euid=5Fattrs)
=EF=BC=9E +
=EF=BC=9E      if (conf-=EF=BC=9Egetuid)
=EF=BC=9E          FREE(conf-=EF=BC=9Egetuid)
=EF=BC=9E =20
=EF=BC=9E diff --git a/libmultipath/config.h b/libmultipath/config.h
=EF=BC=9E index 9670020..ab85930 100644
=EF=BC=9E --- a/libmultipath/config.h
=EF=BC=9E +++ b/libmultipath/config.h
=EF=BC=9E @@ -153,6 +153,7 @@ struct config {
=EF=BC=9E =20
=EF=BC=9E      char * multipath=5Fdir
=EF=BC=9E      char * selector
=EF=BC=9E +    char * uid=5Fattrs
=EF=BC=9E      char * uid=5Fattribute
=EF=BC=9E      char * getuid
=EF=BC=9E      char * features
=EF=BC=9E diff --git a/libmultipath/dict.c b/libmultipath/dict.c
=EF=BC=9E index dc21846..0a531d1 100644
=EF=BC=9E --- a/libmultipath/dict.c
=EF=BC=9E +++ b/libmultipath/dict.c
=EF=BC=9E @@ -249,6 +249,8 @@ declare=5Fovr=5Fsnprint(selector, print=5Fstr)
=EF=BC=9E  declare=5Fmp=5Fhandler(selector, set=5Fstr)
=EF=BC=9E  declare=5Fmp=5Fsnprint(selector, print=5Fstr)
=EF=BC=9E =20
=EF=BC=9E +declare=5Fdef=5Fhandler(uid=5Fattrs, set=5Fstr)
=EF=BC=9E +declare=5Fdef=5Fsnprint(uid=5Fattrs, print=5Fstr)
=EF=BC=9E  declare=5Fdef=5Fhandler(uid=5Fattribute, set=5Fstr)
=EF=BC=9E  declare=5Fdef=5Fsnprint=5Fdefstr(uid=5Fattribute, print=5Fstr, D=
EFAULT=5FUID=5FATTRIBUTE)
=EF=BC=9E  declare=5Fovr=5Fhandler(uid=5Fattribute, set=5Fstr)
=EF=BC=9E @@ -1367,6 +1369,7 @@ init=5Fkeywords(vector keywords)
=EF=BC=9E      install=5Fkeyword("multipath=5Fdir", &def=5Fmultipath=5Fdir=
=5Fhandler, &snprint=5Fdef=5Fmultipath=5Fdir)
=EF=BC=9E      install=5Fkeyword("path=5Fselector", &def=5Fselector=5Fhandl=
er, &snprint=5Fdef=5Fselector)
=EF=BC=9E      install=5Fkeyword("path=5Fgrouping=5Fpolicy", &def=5Fpgpolic=
y=5Fhandler, &snprint=5Fdef=5Fpgpolicy)
=EF=BC=9E +    install=5Fkeyword("uid=5Fattrs", &def=5Fuid=5Fattrs=5Fhandle=
r, &snprint=5Fdef=5Fuid=5Fattrs)
=EF=BC=9E      install=5Fkeyword("uid=5Fattribute", &def=5Fuid=5Fattribute=
=5Fhandler, &snprint=5Fdef=5Fuid=5Fattribute)
=EF=BC=9E      install=5Fkeyword("getuid=5Fcallout", &def=5Fgetuid=5Fhandle=
r, &snprint=5Fdef=5Fgetuid)
=EF=BC=9E      install=5Fkeyword("prio", &def=5Fprio=5Fname=5Fhandler, &snp=
rint=5Fdef=5Fprio=5Fname)
=EF=BC=9E diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
=EF=BC=9E index d1aec31..14904f2 100644
=EF=BC=9E --- a/libmultipath/discovery.c
=EF=BC=9E +++ b/libmultipath/discovery.c
=EF=BC=9E @@ -33,7 +33,7 @@
=EF=BC=9E =20
=EF=BC=9E  int
=EF=BC=9E  alloc=5Fpath=5Fwith=5Fpathinfo (struct config *conf, struct udev=
=5Fdevice *udevice,
=EF=BC=9E -              int flag, struct path **pp=5Fptr)
=EF=BC=9E +              char *wwid, int flag, struct path **pp=5Fptr)
=EF=BC=9E  {
=EF=BC=9E      int err =3D PATHINFO=5FFAILED
=EF=BC=9E      struct path * pp
=EF=BC=9E @@ -51,6 +51,9 @@ alloc=5Fpath=5Fwith=5Fpathinfo (struct config *=
conf, struct udev=5Fdevice *udevice,
=EF=BC=9E      if (!pp)
=EF=BC=9E          return PATHINFO=5FFAILED
=EF=BC=9E =20
=EF=BC=9E +    if(wwid)
=EF=BC=9E +        strncpy(pp-=EF=BC=9Ewwid, wwid, sizeof(pp-=EF=BC=9Ewwid))
=EF=BC=9E +
=EF=BC=9E      if (safe=5Fsprintf(pp-=EF=BC=9Edev, "%s", devname)) {
=EF=BC=9E          condlog(0, "pp-=EF=BC=9Edev too small")
=EF=BC=9E      } else {
=EF=BC=9E diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
=EF=BC=9E index 3039268..d16a69a 100644
=EF=BC=9E --- a/libmultipath/discovery.h
=EF=BC=9E +++ b/libmultipath/discovery.h
=EF=BC=9E @@ -37,7 +37,7 @@ int path=5Foffline (struct path *)
=EF=BC=9E  int get=5Fstate (struct path * pp, struct config * conf, int dae=
mon)
=EF=BC=9E  int pathinfo (struct path * pp, struct config * conf, int mask)
=EF=BC=9E  int alloc=5Fpath=5Fwith=5Fpathinfo (struct config *conf, struct =
udev=5Fdevice *udevice,
=EF=BC=9E -                  int flag, struct path **pp=5Fptr)
=EF=BC=9E +                  char *wwid, int flag, struct path **pp=5Fptr)
=EF=BC=9E  int store=5Fpathinfo (vector pathvec, struct config *conf,
=EF=BC=9E              struct udev=5Fdevice *udevice, int flag,
=EF=BC=9E              struct path **pp=5Fptr)
=EF=BC=9E diff --git a/libmultipath/list.h b/libmultipath/list.h
=EF=BC=9E index ceaa381..2b1dcf3 100644
=EF=BC=9E --- a/libmultipath/list.h
=EF=BC=9E +++ b/libmultipath/list.h
=EF=BC=9E @@ -317,4 +317,45 @@ static inline void list=5Fsplice=5Ftail=5Fin=
it(struct list=5Fhead *list,
=EF=BC=9E           &pos-=EF=BC=9Emember !=3D (head)                    \
=EF=BC=9E           pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.next, t=
ypeof(*n), member))
=EF=BC=9E =20
=EF=BC=9E +/**
=EF=BC=9E + * list=5Ffor=5Feach=5Fentry=5Freverse=5Fsafe - iterate backward=
s over list of given type safe against removal of list entry
=EF=BC=9E + * @pos:    the type * to use as a loop counter.
=EF=BC=9E + * @n:        another type * to use as temporary storage
=EF=BC=9E + * @head:    the head for your list.
=EF=BC=9E + * @member:    the name of the list=5Fstruct within the struct.
=EF=BC=9E + */
=EF=BC=9E +#define list=5Ffor=5Feach=5Fentry=5Freverse=5Fsafe(pos, n, head,=
 member)          \
=EF=BC=9E +    for (pos =3D list=5Fentry((head)-=EF=BC=9Eprev, typeof(*pos)=
, member),      \
=EF=BC=9E +         n =3D list=5Fentry(pos-=EF=BC=9Emember.prev, typeof(*po=
s), member)\
=EF=BC=9E +         &pos-=EF=BC=9Emember !=3D (head)                       =
             \
=EF=BC=9E +         pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.prev, t=
ypeof(*n), member))
=EF=BC=9E +
=EF=BC=9E +/**
=EF=BC=9E + * list=5Ffor=5Fsome=5Fentry=5Fsafe - iterate list from the give=
n begin node to the given end node safe against removal of list entry
=EF=BC=9E + * @pos:    the type * to use as a loop counter.
=EF=BC=9E + * @n:        another type * to use as temporary storage
=EF=BC=9E + * @from:    the begin node of the iteration.
=EF=BC=9E + * @to:        the end node of the iteration.
=EF=BC=9E + * @member:    the name of the list=5Fstruct within the struct.
=EF=BC=9E + */
=EF=BC=9E +#define list=5Ffor=5Fsome=5Fentry=5Fsafe(pos, n, from, to, membe=
r)              \
=EF=BC=9E +    for (pos =3D list=5Fentry((from)-=EF=BC=9Enext, typeof(*pos)=
, member),      \
=EF=BC=9E +         n =3D list=5Fentry(pos-=EF=BC=9Emember.next, typeof(*po=
s), member)    \
=EF=BC=9E +         &pos-=EF=BC=9Emember !=3D (to)                         =
             \
=EF=BC=9E +         pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.next, t=
ypeof(*n), member))
=EF=BC=9E +
=EF=BC=9E +/**
=EF=BC=9E + * list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe - iterate backward=
s list from the given begin node to the given end node safe against removal=
 of list entry
=EF=BC=9E + * @pos:    the type * to use as a loop counter.
=EF=BC=9E + * @n:        another type * to use as temporary storage
=EF=BC=9E + * @from:    the begin node of the iteration.
=EF=BC=9E + * @to:        the end node of the iteration.
=EF=BC=9E + * @member:    the name of the list=5Fstruct within the struct.
=EF=BC=9E + */
=EF=BC=9E +#define list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(pos, n, from,=
 to, member)      \
=EF=BC=9E +    for (pos =3D list=5Fentry((from)-=EF=BC=9Eprev, typeof(*pos)=
, member),      \
=EF=BC=9E +         n =3D list=5Fentry(pos-=EF=BC=9Emember.prev, typeof(*po=
s), member)    \
=EF=BC=9E +         &pos-=EF=BC=9Emember !=3D (to)                         =
             \
=EF=BC=9E +         pos =3D n, n =3D list=5Fentry(n-=EF=BC=9Emember.prev, t=
ypeof(*n), member))
=EF=BC=9E +
=EF=BC=9E  #endif /* =5FLIST=5FH */
=EF=BC=9E diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
=EF=BC=9E index c0bc616..5a58dc0 100644
=EF=BC=9E --- a/libmultipath/propsel.c
=EF=BC=9E +++ b/libmultipath/propsel.c
=EF=BC=9E @@ -18,6 +18,7 @@
=EF=BC=9E  #include "prio.h"
=EF=BC=9E  #include "discovery.h"
=EF=BC=9E  #include "dict.h"
=EF=BC=9E +#include "util.h"
=EF=BC=9E  #include "prioritizers/alua=5Frtpg.h"
=EF=BC=9E  #include =EF=BC=9Cinttypes.h=EF=BC=9E
=EF=BC=9E =20
=EF=BC=9E @@ -339,6 +340,12 @@ int select=5Fgetuid(struct config *conf, str=
uct path *pp)
=EF=BC=9E  {
=EF=BC=9E      char *origin
=EF=BC=9E =20
=EF=BC=9E +    pp-=EF=BC=9Euid=5Fattribute =3D parse=5Fuid=5Fattribute=5Fby=
=5Fattrs(conf-=EF=BC=9Euid=5Fattrs, pp-=EF=BC=9Edev)
=EF=BC=9E +    if (pp-=EF=BC=9Euid=5Fattribute) {
=EF=BC=9E +        origin =3D "(config file default)"
=EF=BC=9E +        goto out
=EF=BC=9E +    }
=EF=BC=9E +
=EF=BC=9E      pp=5Fset=5Fovr(getuid)
=EF=BC=9E      pp=5Fset=5Fovr(uid=5Fattribute)
=EF=BC=9E      pp=5Fset=5Fhwe(getuid)
=EF=BC=9E diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
=EF=BC=9E index 7edcce1..7e4ac04 100644
=EF=BC=9E --- a/libmultipath/uevent.c
=EF=BC=9E +++ b/libmultipath/uevent.c
=EF=BC=9E @@ -24,6 +24,7 @@
=EF=BC=9E =20
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
=EF=BC=9E =20
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
=EF=BC=9E =20
=EF=BC=9E  typedef int (uev=5Ftrigger)(struct uevent *, void * trigger=5Fda=
ta)
=EF=BC=9E =20
=EF=BC=9E @@ -72,48 +82,300 @@ struct uevent * alloc=5Fuevent (void)
=EF=BC=9E  {
=EF=BC=9E      struct uevent *uev =3D MALLOC(sizeof(struct uevent))
=EF=BC=9E =20
=EF=BC=9E -    if (uev)
=EF=BC=9E +    if (uev) {
=EF=BC=9E          INIT=5FLIST=5FHEAD(&uev-=EF=BC=9Enode)
=EF=BC=9E +        INIT=5FLIST=5FHEAD(&uev-=EF=BC=9Emerge=5Fnode)
=EF=BC=9E +    }
=EF=BC=9E =20
=EF=BC=9E      return uev
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E  void
=EF=BC=9E -service=5Fuevq(struct list=5Fhead *tmpq)
=EF=BC=9E +uevq=5Fcleanup(struct list=5Fhead *tmpq)
=EF=BC=9E  {
=EF=BC=9E      struct uevent *uev, *tmp
=EF=BC=9E =20
=EF=BC=9E      list=5Ffor=5Feach=5Fentry=5Fsafe(uev, tmp, tmpq, node) {
=EF=BC=9E          list=5Fdel=5Finit(&uev-=EF=BC=9Enode)
=EF=BC=9E =20
=EF=BC=9E -        if (my=5Fuev=5Ftrigger && my=5Fuev=5Ftrigger(uev, my=5Ft=
rigger=5Fdata))
=EF=BC=9E -            condlog(0, "uevent trigger error")
=EF=BC=9E -
=EF=BC=9E          if (uev-=EF=BC=9Eudev)
=EF=BC=9E              udev=5Fdevice=5Funref(uev-=EF=BC=9Eudev)
=EF=BC=9E          FREE(uev)
=EF=BC=9E      }
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E -static void uevent=5Fcleanup(void *arg)
=EF=BC=9E +void
=EF=BC=9E +uevent=5Fget=5Fwwid(struct uevent *uev)
=EF=BC=9E  {
=EF=BC=9E -    struct udev *udev =3D arg
=EF=BC=9E +    int i
=EF=BC=9E +    char *uid=5Fattribute
=EF=BC=9E +    struct config * conf
=EF=BC=9E +   =20
=EF=BC=9E +    conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E +    uid=5Fattribute =3D parse=5Fuid=5Fattribute=5Fby=5Fattrs(con=
f-=EF=BC=9Euid=5Fattrs, uev-=EF=BC=9Ekernel)
=EF=BC=9E +    put=5Fmultipath=5Fconfig(conf)   =20
=EF=BC=9E +   =20
=EF=BC=9E +    if (!uid=5Fattribute)
=EF=BC=9E +        return
=EF=BC=9E +   =20
=EF=BC=9E +    for (i =3D 0 uev-=EF=BC=9Eenvp[i] !=3D NULL i++) {
=EF=BC=9E +        if (!strncmp(uev-=EF=BC=9Eenvp[i], uid=5Fattribute, strl=
en(uid=5Fattribute)) &&
=EF=BC=9E +            strlen(uev-=EF=BC=9Eenvp[i]) =EF=BC=9E strlen(uid=5F=
attribute)) {
=EF=BC=9E +            uev-=EF=BC=9Ewwid =3D uev-=EF=BC=9Eenvp[i] + strlen(=
uid=5Fattribute) + 1
=EF=BC=9E +            break
=EF=BC=9E +        }
=EF=BC=9E +    }
=EF=BC=9E +    free(uid=5Fattribute)
=EF=BC=9E +}
=EF=BC=9E =20
=EF=BC=9E -    condlog(3, "Releasing uevent=5Flisten() resources")
=EF=BC=9E -    udev=5Funref(udev)
=EF=BC=9E +bool
=EF=BC=9E +uevent=5Fneed=5Fmerge(void)
=EF=BC=9E +{
=EF=BC=9E +    struct config * conf
=EF=BC=9E +    bool need=5Fmerge =3D false
=EF=BC=9E +
=EF=BC=9E +    conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E +    if (conf-=EF=BC=9Euid=5Fattrs)
=EF=BC=9E +        need=5Fmerge =3D true
=EF=BC=9E +    put=5Fmultipath=5Fconfig(conf)   =20
=EF=BC=9E +
=EF=BC=9E +    return need=5Fmerge
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +bool
=EF=BC=9E +uevent=5Fcan=5Fdiscard(struct uevent *uev)
=EF=BC=9E +{
=EF=BC=9E +    char *tmp
=EF=BC=9E +    char a[11], b[11]
=EF=BC=9E +    struct config * conf
=EF=BC=9E +
=EF=BC=9E +    /*
=EF=BC=9E +     * keep only block devices, discard partitions
=EF=BC=9E +     */
=EF=BC=9E +    tmp =3D strstr(uev-=EF=BC=9Edevpath, "/block/")
=EF=BC=9E +    if (tmp =3D=3D NULL){
=EF=BC=9E +        condlog(4, "no /block/ in '%s'", uev-=EF=BC=9Edevpath)
=EF=BC=9E +        return true
=EF=BC=9E +    }
=EF=BC=9E +    if (sscanf(tmp, "/block/%10s", a) !=3D 1 ||
=EF=BC=9E +        sscanf(tmp, "/block/%10[^/]/%10s", a, b) =3D=3D 2) {
=EF=BC=9E +        condlog(4, "discard event on %s", uev-=EF=BC=9Edevpath)
=EF=BC=9E +        return true
=EF=BC=9E +    }
=EF=BC=9E +
=EF=BC=9E +    /*=20
=EF=BC=9E +     * do not filter dm devices by devnode
=EF=BC=9E +     */
=EF=BC=9E +    if (!strncmp(uev-=EF=BC=9Ekernel, "dm-", 3))
=EF=BC=9E +        return false
=EF=BC=9E +    /*=20
=EF=BC=9E +     * filter paths devices by devnode
=EF=BC=9E +     */
=EF=BC=9E +    conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E +    if (filter=5Fdevnode(conf-=EF=BC=9Eblist=5Fdevnode, conf-=EF=
=BC=9Eelist=5Fdevnode,
=EF=BC=9E +               uev-=EF=BC=9Ekernel) =EF=BC=9E 0) {
=EF=BC=9E +        put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E +        return true
=EF=BC=9E +    }
=EF=BC=9E +    put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E +
=EF=BC=9E +    return false
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +bool
=EF=BC=9E +uevent=5Fcan=5Ffilter(struct uevent *earlier, struct uevent *lat=
er)
=EF=BC=9E +{
=EF=BC=9E +
=EF=BC=9E +    /*
=EF=BC=9E +     * filter earlier uvents if path has removed later. Eg:
=EF=BC=9E +     * "add path1 |chang path1 |add path2 |remove path1"
=EF=BC=9E +     * can filter as:
=EF=BC=9E +     * "add path2 |remove path1"
=EF=BC=9E +     * uevents "add path1" and "chang path1" are filtered out
=EF=BC=9E +     */
=EF=BC=9E +    if (!strcmp(earlier-=EF=BC=9Ekernel, later-=EF=BC=9Ekernel) =
&&
=EF=BC=9E +        !strcmp(later-=EF=BC=9Eaction, "remove") &&
=EF=BC=9E +        strncmp(later-=EF=BC=9Ekernel, "dm-", 3)) {
=EF=BC=9E +        return true
=EF=BC=9E +    }
=EF=BC=9E +
=EF=BC=9E +    /*
=EF=BC=9E +     * filter change uvents if add uevents exist. Eg:
=EF=BC=9E +     * "change path1| add path1 |add path2"
=EF=BC=9E +     * can filter as:
=EF=BC=9E +     * "add path1 |add path2"
=EF=BC=9E +     * uevent "chang path1" is filtered out
=EF=BC=9E +     */
=EF=BC=9E +    if (!strcmp(earlier-=EF=BC=9Ekernel, later-=EF=BC=9Ekernel) =
&&
=EF=BC=9E +        !strcmp(earlier-=EF=BC=9Eaction, "change") &&
=EF=BC=9E +        !strcmp(later-=EF=BC=9Eaction, "add") &&
=EF=BC=9E +        strncmp(later-=EF=BC=9Ekernel, "dm-", 3)) {
=EF=BC=9E +        return true
=EF=BC=9E +    }
=EF=BC=9E +
=EF=BC=9E +    return false
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +bool
=EF=BC=9E +merge=5Fneed=5Fstop(struct uevent *earlier, struct uevent *later)
=EF=BC=9E +{
=EF=BC=9E +    /*
=EF=BC=9E +     * dm uevent do not try to merge with left uevents
=EF=BC=9E +     */
=EF=BC=9E +    if (!strncmp(later-=EF=BC=9Ekernel, "dm-", 3))
=EF=BC=9E +        return true
=EF=BC=9E +
=EF=BC=9E +    /*
=EF=BC=9E +     * we can not make a jugement without wwid,
=EF=BC=9E +     * so it is sensible to stop merging
=EF=BC=9E +     */
=EF=BC=9E +    if (!earlier-=EF=BC=9Ewwid || !later-=EF=BC=9Ewwid)
=EF=BC=9E +        return true
=EF=BC=9E +    /*
=EF=BC=9E +     * uevents merging stoped
=EF=BC=9E +     * when we meet an opposite action uevent from the same LUN =
to AVOID
=EF=BC=9E +     * "add path1 |remove path1 |add path2 |remove path2 |add pa=
th3"
=EF=BC=9E +     * to merge as "remove path1, path2" and "add path1, path2, =
path3"
=EF=BC=9E +     * OR
=EF=BC=9E +     * "remove path1 |add path1 |remove path2 |add path2 |remove=
 path3"
=EF=BC=9E +     * to merge as "add path1, path2" and "remove path1, path2, =
path3"
=EF=BC=9E +     * SO
=EF=BC=9E +     * when we meet a non-change uevent from the same LUN
=EF=BC=9E +     * with the same wwid and different action
=EF=BC=9E +     * it would be better to stop merging.
=EF=BC=9E +     */
=EF=BC=9E +    if (!strcmp(earlier-=EF=BC=9Ewwid, later-=EF=BC=9Ewwid) &&
=EF=BC=9E +        strcmp(earlier-=EF=BC=9Eaction, later-=EF=BC=9Eaction) &&
=EF=BC=9E +        strcmp(earlier-=EF=BC=9Eaction, "change") &&
=EF=BC=9E +        strcmp(later-=EF=BC=9Eaction, "change"))
=EF=BC=9E +        return true
=EF=BC=9E +
=EF=BC=9E +    return false
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +bool
=EF=BC=9E +uevent=5Fcan=5Fmerge(struct uevent *earlier, struct uevent *late=
r)
=EF=BC=9E +{
=EF=BC=9E +    /* merge paths uevents
=EF=BC=9E +     * whose wwids exsit and are same
=EF=BC=9E +     * and actions are same,
=EF=BC=9E +     * and actions are addition or deletion
=EF=BC=9E +     */
=EF=BC=9E +    if (earlier-=EF=BC=9Ewwid && later-=EF=BC=9Ewwid &&
=EF=BC=9E +        !strcmp(earlier-=EF=BC=9Ewwid, later-=EF=BC=9Ewwid) &&
=EF=BC=9E +        !strcmp(earlier-=EF=BC=9Eaction, later-=EF=BC=9Eaction) =
&&
=EF=BC=9E +        strncmp(earlier-=EF=BC=9Eaction, "change", 6) &&
=EF=BC=9E +        strncmp(earlier-=EF=BC=9Ekernel, "dm-", 3)) {
=EF=BC=9E +        return true
=EF=BC=9E +    }
=EF=BC=9E +
=EF=BC=9E +    return false
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E  void
=EF=BC=9E -uevq=5Fcleanup(struct list=5Fhead *tmpq)
=EF=BC=9E +uevent=5Fprepare(struct list=5Fhead *tmpq)
=EF=BC=9E +{
=EF=BC=9E +    struct uevent *uev, *tmp
=EF=BC=9E +
=EF=BC=9E +    list=5Ffor=5Feach=5Fentry=5Freverse=5Fsafe(uev, tmp, tmpq, n=
ode) {
=EF=BC=9E +        if (uevent=5Fcan=5Fdiscard(uev)) {
=EF=BC=9E +            list=5Fdel=5Finit(&uev-=EF=BC=9Enode)
=EF=BC=9E +            if (uev-=EF=BC=9Eudev)
=EF=BC=9E +                udev=5Fdevice=5Funref(uev-=EF=BC=9Eudev)
=EF=BC=9E +            FREE(uev)
=EF=BC=9E +            continue
=EF=BC=9E +        }
=EF=BC=9E +
=EF=BC=9E +        if (strncmp(uev-=EF=BC=9Ekernel, "dm-", 3) &&
=EF=BC=9E +            uevent=5Fneed=5Fmerge())
=EF=BC=9E +            uevent=5Fget=5Fwwid(uev)
=EF=BC=9E +    }
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +void
=EF=BC=9E +uevent=5Ffilter(struct uevent *later, struct list=5Fhead *tmpq)
=EF=BC=9E +{
=EF=BC=9E +    struct uevent *earlier, *tmp
=EF=BC=9E +
=EF=BC=9E +    list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(earlier, tmp, &la=
ter-=EF=BC=9Enode, tmpq, node) {
=EF=BC=9E +        /*
=EF=BC=9E +         * filter unnessary earlier uevents=20
=EF=BC=9E +         * by the later uevent
=EF=BC=9E +         */
=EF=BC=9E +        if (uevent=5Fcan=5Ffilter(earlier, later)) {
=EF=BC=9E +            condlog(2, "uevent: %s-%s has filtered by uevent: %s=
-%s",
=EF=BC=9E +                earlier-=EF=BC=9Ekernel, earlier-=EF=BC=9Eaction=
,=20
=EF=BC=9E +                later-=EF=BC=9Ekernel, later-=EF=BC=9Eaction)
=EF=BC=9E +
=EF=BC=9E +            list=5Fdel=5Finit(&earlier-=EF=BC=9Enode)
=EF=BC=9E +            if (earlier-=EF=BC=9Eudev)
=EF=BC=9E +                udev=5Fdevice=5Funref(earlier-=EF=BC=9Eudev)
=EF=BC=9E +            FREE(earlier)
=EF=BC=9E +        }
=EF=BC=9E +    }
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +void
=EF=BC=9E +uevent=5Fmerge(struct uevent *later, struct list=5Fhead *tmpq)
=EF=BC=9E +{
=EF=BC=9E +    struct uevent *earlier, *tmp
=EF=BC=9E +
=EF=BC=9E +    list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(earlier, tmp, &la=
ter-=EF=BC=9Enode, tmpq, node) {
=EF=BC=9E +        if (merge=5Fneed=5Fstop(earlier, later))
=EF=BC=9E +            break
=EF=BC=9E +        /*
=EF=BC=9E +         * merge earlier uevents to the later uevent
=EF=BC=9E +         */
=EF=BC=9E +        if (uevent=5Fcan=5Fmerge(earlier, later)) {
=EF=BC=9E +            condlog(2, "merged uevent: %s-%s-%s with uevent: %s-=
%s-%s",
=EF=BC=9E +                earlier-=EF=BC=9Eaction, earlier-=EF=BC=9Ekernel=
, earlier-=EF=BC=9Ewwid,
=EF=BC=9E +                later-=EF=BC=9Eaction, later-=EF=BC=9Ekernel, la=
ter-=EF=BC=9Ewwid)
=EF=BC=9E +
=EF=BC=9E +            list=5Fmove(&earlier-=EF=BC=9Enode, &later-=EF=BC=9E=
merge=5Fnode)
=EF=BC=9E +        }
=EF=BC=9E +    }
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +void
=EF=BC=9E +merge=5Fuevq(struct list=5Fhead *tmpq)
=EF=BC=9E +{
=EF=BC=9E +    struct uevent *later
=EF=BC=9E +
=EF=BC=9E +    uevent=5Fprepare(tmpq)
=EF=BC=9E +    list=5Ffor=5Feach=5Fentry=5Freverse(later, tmpq, node) {
=EF=BC=9E +        uevent=5Ffilter(later, tmpq)
=EF=BC=9E +        if(uevent=5Fneed=5Fmerge())
=EF=BC=9E +            uevent=5Fmerge(later, tmpq)
=EF=BC=9E +    }
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E +void
=EF=BC=9E +service=5Fuevq(struct list=5Fhead *tmpq)
=EF=BC=9E  {
=EF=BC=9E      struct uevent *uev, *tmp
=EF=BC=9E =20
=EF=BC=9E      list=5Ffor=5Feach=5Fentry=5Fsafe(uev, tmp, tmpq, node) {
=EF=BC=9E          list=5Fdel=5Finit(&uev-=EF=BC=9Enode)
=EF=BC=9E +
=EF=BC=9E +        if (my=5Fuev=5Ftrigger && my=5Fuev=5Ftrigger(uev, my=5Ft=
rigger=5Fdata))
=EF=BC=9E +            condlog(0, "uevent trigger error")
=EF=BC=9E +
=EF=BC=9E +        uevq=5Fcleanup(&uev-=EF=BC=9Emerge=5Fnode)
=EF=BC=9E +
=EF=BC=9E +        if (uev-=EF=BC=9Eudev)
=EF=BC=9E +            udev=5Fdevice=5Funref(uev-=EF=BC=9Eudev)
=EF=BC=9E          FREE(uev)
=EF=BC=9E      }
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E +static void uevent=5Fcleanup(void *arg)
=EF=BC=9E +{
=EF=BC=9E +    struct udev *udev =3D arg
=EF=BC=9E +
=EF=BC=9E +    condlog(3, "Releasing uevent=5Flisten() resources")
=EF=BC=9E +    udev=5Funref(udev)
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E  /*
=EF=BC=9E   * Service the uevent queue.
=EF=BC=9E   */
=EF=BC=9E @@ -142,6 +404,7 @@ int uevent=5Fdispatch(int (*uev=5Ftrigger)(st=
ruct uevent *, void * trigger=5Fdata),
=EF=BC=9E          pthread=5Fmutex=5Funlock(uevq=5Flockp)
=EF=BC=9E          if (!my=5Fuev=5Ftrigger)
=EF=BC=9E              break
=EF=BC=9E +        merge=5Fuevq(&uevq=5Ftmp)
=EF=BC=9E          service=5Fuevq(&uevq=5Ftmp)
=EF=BC=9E      }
=EF=BC=9E      condlog(3, "Terminating uev service queue")
=EF=BC=9E @@ -442,11 +705,43 @@ struct uevent *uevent=5Ffrom=5Fudev=5Fdevic=
e(struct udev=5Fdevice *dev)
=EF=BC=9E      return uev
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E +bool uevent=5Fburst(struct timeval *start=5Ftime, int events)
=EF=BC=9E +{
=EF=BC=9E +    struct timeval diff=5Ftime, end=5Ftime
=EF=BC=9E +    unsigned long speed
=EF=BC=9E +    unsigned long eclipse=5Fms
=EF=BC=9E +
=EF=BC=9E +    if(events =EF=BC=9E MAX=5FACCUMULATION=5FCOUNT) {
=EF=BC=9E +        condlog(2, "burst got %u uevents, too much uevents, stop=
ped", events)
=EF=BC=9E +        return false
=EF=BC=9E +    }
=EF=BC=9E +
=EF=BC=9E +    gettimeofday(&end=5Ftime, NULL)
=EF=BC=9E +    timersub(&end=5Ftime, start=5Ftime, &diff=5Ftime)
=EF=BC=9E +
=EF=BC=9E +    eclipse=5Fms =3D diff=5Ftime.tv=5Fsec * 1000 + diff=5Ftime.t=
v=5Fusec / 1000
=EF=BC=9E +
=EF=BC=9E +    if (eclipse=5Fms =3D=3D 0)
=EF=BC=9E +        return true
=EF=BC=9E +
=EF=BC=9E +    if (eclipse=5Fms =EF=BC=9E MAX=5FACCUMULATION=5FTIME) {
=EF=BC=9E +        condlog(2, "burst continued %lu ms, too long time, stopp=
ed", eclipse=5Fms)
=EF=BC=9E +        return false
=EF=BC=9E +    }
=EF=BC=9E +
=EF=BC=9E +    speed =3D (events * 1000) / eclipse=5Fms
=EF=BC=9E +    if (speed =EF=BC=9E MIN=5FBURST=5FSPEED)
=EF=BC=9E +        return true
=EF=BC=9E +
=EF=BC=9E +    return false
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E  int uevent=5Flisten(struct udev *udev)
=EF=BC=9E  {
=EF=BC=9E      int err =3D 2
=EF=BC=9E      struct udev=5Fmonitor *monitor =3D NULL
=EF=BC=9E      int fd, socket=5Fflags, events
=EF=BC=9E +    struct timeval start=5Ftime
=EF=BC=9E      int need=5Ffailback =3D 1
=EF=BC=9E      int timeout =3D 30
=EF=BC=9E      LIST=5FHEAD(uevlisten=5Ftmp)
=EF=BC=9E @@ -500,6 +795,7 @@ int uevent=5Flisten(struct udev *udev)
=EF=BC=9E      }
=EF=BC=9E =20
=EF=BC=9E      events =3D 0
=EF=BC=9E +    gettimeofday(&start=5Ftime, NULL)
=EF=BC=9E      while (1) {
=EF=BC=9E          struct uevent *uev
=EF=BC=9E          struct udev=5Fdevice *dev
=EF=BC=9E @@ -514,7 +810,7 @@ int uevent=5Flisten(struct udev *udev)
=EF=BC=9E          errno =3D 0
=EF=BC=9E          fdcount =3D poll(&ev=5Fpoll, 1, poll=5Ftimeout)
=EF=BC=9E          if (fdcount && ev=5Fpoll.revents & POLLIN) {
=EF=BC=9E -            timeout =3D 0
=EF=BC=9E +            timeout =3D uevent=5Fburst(&start=5Ftime, events + 1=
) ? 1 : 0
=EF=BC=9E              dev =3D udev=5Fmonitor=5Freceive=5Fdevice(monitor)
=EF=BC=9E              if (!dev) {
=EF=BC=9E                  condlog(0, "failed getting udev device")
=EF=BC=9E @@ -547,6 +843,7 @@ int uevent=5Flisten(struct udev *udev)
=EF=BC=9E              pthread=5Fmutex=5Funlock(uevq=5Flockp)
=EF=BC=9E              events =3D 0
=EF=BC=9E          }
=EF=BC=9E +        gettimeofday(&start=5Ftime, NULL)
=EF=BC=9E          timeout =3D 30
=EF=BC=9E      }
=EF=BC=9E      need=5Ffailback =3D 0
=EF=BC=9E diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
=EF=BC=9E index 9d22dcd..61a4207 100644
=EF=BC=9E --- a/libmultipath/uevent.h
=EF=BC=9E +++ b/libmultipath/uevent.h
=EF=BC=9E @@ -17,11 +17,13 @@ struct udev
=EF=BC=9E =20
=EF=BC=9E  struct uevent {
=EF=BC=9E      struct list=5Fhead node
=EF=BC=9E +    struct list=5Fhead merge=5Fnode
=EF=BC=9E      struct udev=5Fdevice *udev
=EF=BC=9E      char buffer[HOTPLUG=5FBUFFER=5FSIZE + OBJECT=5FSIZE]
=EF=BC=9E      char *devpath
=EF=BC=9E      char *action
=EF=BC=9E      char *kernel
=EF=BC=9E +    char *wwid
=EF=BC=9E      unsigned long seqnum
=EF=BC=9E      char *envp[HOTPLUG=5FNUM=5FENVP]
=EF=BC=9E  }
=EF=BC=9E diff --git a/libmultipath/util.c b/libmultipath/util.c
=EF=BC=9E index 03a5738..e5a4a28 100644
=EF=BC=9E --- a/libmultipath/util.c
=EF=BC=9E +++ b/libmultipath/util.c
=EF=BC=9E @@ -261,6 +261,46 @@ dev=5Ft parse=5Fdevt(const char *dev=5Ft)
=EF=BC=9E      return makedev(maj, min)
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E +char *parse=5Fuid=5Fattribute=5Fby=5Fattrs(char *uid=5Fattrs, ch=
ar *path=5Fdev)
=EF=BC=9E +{
=EF=BC=9E +    char *uid=5Fattribute
=EF=BC=9E +    char *uid=5Fattr=5Frecord
=EF=BC=9E +    char *dev
=EF=BC=9E +    char *attr
=EF=BC=9E +    char *tmp
=EF=BC=9E +    int  count
=EF=BC=9E +
=EF=BC=9E +    if(!uid=5Fattrs || !path=5Fdev)
=EF=BC=9E +        return NULL
=EF=BC=9E +
=EF=BC=9E +    count =3D get=5Fword(uid=5Fattrs, &uid=5Fattr=5Frecord)
=EF=BC=9E +    while (uid=5Fattr=5Frecord) {
=EF=BC=9E +        tmp =3D strrchr(uid=5Fattr=5Frecord, ':')
=EF=BC=9E +        if (!tmp) {
=EF=BC=9E +            free(uid=5Fattr=5Frecord)
=EF=BC=9E +            if (!count)
=EF=BC=9E +                break
=EF=BC=9E +            count =3D get=5Fword(uid=5Fattrs + count, &uid=5Fatt=
r=5Frecord)
=EF=BC=9E +            continue
=EF=BC=9E +        }
=EF=BC=9E +        dev =3D uid=5Fattr=5Frecord
=EF=BC=9E +        attr =3D tmp + 1
=EF=BC=9E +        *tmp =3D '\0'
=EF=BC=9E +
=EF=BC=9E +        if(!strncmp(path=5Fdev, dev, strlen(dev))) {
=EF=BC=9E +            uid=5Fattribute =3D STRDUP(attr)
=EF=BC=9E +            free(uid=5Fattr=5Frecord)
=EF=BC=9E +            return uid=5Fattribute
=EF=BC=9E +        }
=EF=BC=9E +
=EF=BC=9E +        free(uid=5Fattr=5Frecord)
=EF=BC=9E +        if (!count)
=EF=BC=9E +            break
=EF=BC=9E +        count =3D get=5Fword(uid=5Fattrs + count, &uid=5Fattr=5F=
record)
=EF=BC=9E +    }
=EF=BC=9E +    return NULL
=EF=BC=9E +}
=EF=BC=9E +
=EF=BC=9E  void
=EF=BC=9E  setup=5Fthread=5Fattr(pthread=5Fattr=5Ft *attr, size=5Ft stacksi=
ze, int detached)
=EF=BC=9E  {
=EF=BC=9E diff --git a/libmultipath/util.h b/libmultipath/util.h
=EF=BC=9E index f3b37ee..793f2b7 100644
=EF=BC=9E --- a/libmultipath/util.h
=EF=BC=9E +++ b/libmultipath/util.h
=EF=BC=9E @@ -12,6 +12,7 @@ size=5Ft strlcat(char *dst, const char *src, si=
ze=5Ft size)
=EF=BC=9E  int devt2devname (char *, int, char *)
=EF=BC=9E  dev=5Ft parse=5Fdevt(const char *dev=5Ft)
=EF=BC=9E  char *convert=5Fdev(char *dev, int is=5Fpath=5Fdevice)
=EF=BC=9E +char *parse=5Fuid=5Fattribute=5Fby=5Fattrs(char *uid=5Fattrs, ch=
ar *path=5Fdev)
=EF=BC=9E  void setup=5Fthread=5Fattr(pthread=5Fattr=5Ft *attr, size=5Ft st=
acksize, int detached)
=EF=BC=9E =20
=EF=BC=9E  #define safe=5Fsprintf(var, format, args...)    \
=EF=BC=9E diff --git a/multipath/multipath.conf.5 b/multipath/multipath.con=
f.5
=EF=BC=9E index 36589f5..63c63c2 100644
=EF=BC=9E --- a/multipath/multipath.conf.5
=EF=BC=9E +++ b/multipath/multipath.conf.5
=EF=BC=9E @@ -209,6 +209,24 @@ The default is: \fBfailover\fR
=EF=BC=9E  .
=EF=BC=9E  .
=EF=BC=9E  .TP
=EF=BC=9E +.B uid=5Fattrs
=EF=BC=9E +The udev attribute providing a unique path identifier for corres=
ponding=20
=EF=BC=9E +type of path devices. If this field is configured and matched wi=
th type
=EF=BC=9E +of device, it would override any other methods providing for dev=
ice
=EF=BC=9E +unique identifier in config file, and it would activate merging =
uevents
=EF=BC=9E +according to the identifier to promote effiecncy in processing u=
events.
=EF=BC=9E +Tt has no default value, if you want to identify path by udev at=
tribute
=EF=BC=9E +and to activate merging uevents for SCSI and DAS device, you can=
 set
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
=EF=BC=9E diff --git a/multipathd/cli=5Fhandlers.c b/multipathd/cli=5Fhandl=
ers.c
=EF=BC=9E index b0eeca6..12f85de 100644
=EF=BC=9E --- a/multipathd/cli=5Fhandlers.c
=EF=BC=9E +++ b/multipathd/cli=5Fhandlers.c
=EF=BC=9E @@ -670,7 +670,7 @@ cli=5Fadd=5Fpath (void * v, char ** reply, in=
t * len, void * data)
=EF=BC=9E          pp-=EF=BC=9Echeckint =3D conf-=EF=BC=9Echeckint
=EF=BC=9E      }
=EF=BC=9E      put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E -    return ev=5Fadd=5Fpath(pp, vecs)
=EF=BC=9E +    return ev=5Fadd=5Fpath(pp, vecs, 1)
=EF=BC=9E  blacklisted:
=EF=BC=9E      *reply =3D strdup("blacklisted\n")
=EF=BC=9E      *len =3D strlen(*reply) + 1
=EF=BC=9E @@ -692,7 +692,7 @@ cli=5Fdel=5Fpath (void * v, char ** reply, in=
t * len, void * data)
=EF=BC=9E          condlog(0, "%s: path already removed", param)
=EF=BC=9E          return 1
=EF=BC=9E      }
=EF=BC=9E -    return ev=5Fremove=5Fpath(pp, vecs)
=EF=BC=9E +    return ev=5Fremove=5Fpath(pp, vecs, 1)
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E  int
=EF=BC=9E diff --git a/multipathd/main.c b/multipathd/main.c
=EF=BC=9E index adc3258..e513f7d 100644
=EF=BC=9E --- a/multipathd/main.c
=EF=BC=9E +++ b/multipathd/main.c
=EF=BC=9E @@ -608,7 +608,7 @@ ev=5Fremove=5Fmap (char * devname, char * ali=
as, int minor, struct vectors * vecs)
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E  static int
=EF=BC=9E -uev=5Fadd=5Fpath (struct uevent *uev, struct vectors * vecs)
=EF=BC=9E +uev=5Fadd=5Fpath (struct uevent *uev, struct vectors * vecs, int=
 need=5Fdo=5Fmap)
=EF=BC=9E  {
=EF=BC=9E      struct path *pp
=EF=BC=9E      int ret =3D 0, i
=EF=BC=9E @@ -641,7 +641,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct =
vectors * vecs)
=EF=BC=9E                       DI=5FALL | DI=5FBLACKLIST)
=EF=BC=9E              put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E              if (r =3D=3D PATHINFO=5FOK)
=EF=BC=9E -                ret =3D ev=5Fadd=5Fpath(pp, vecs)
=EF=BC=9E +                ret =3D ev=5Fadd=5Fpath(pp, vecs, need=5Fdo=5Fma=
p)
=EF=BC=9E              else if (r =3D=3D PATHINFO=5FSKIPPED) {
=EF=BC=9E                  condlog(3, "%s: remove blacklisted path",
=EF=BC=9E                      uev-=EF=BC=9Ekernel)
=EF=BC=9E @@ -665,7 +665,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct =
vectors * vecs)
=EF=BC=9E       */
=EF=BC=9E      conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E      ret =3D alloc=5Fpath=5Fwith=5Fpathinfo(conf, uev-=EF=BC=9Eud=
ev,
=EF=BC=9E -                       DI=5FALL, &pp)
=EF=BC=9E +                       uev-=EF=BC=9Ewwid, DI=5FALL, &pp)
=EF=BC=9E      put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E      if (!pp) {
=EF=BC=9E          if (ret =3D=3D PATHINFO=5FSKIPPED)
=EF=BC=9E @@ -681,7 +681,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct =
vectors * vecs)
=EF=BC=9E          conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E          pp-=EF=BC=9Echeckint =3D conf-=EF=BC=9Echeckint
=EF=BC=9E          put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E -        ret =3D ev=5Fadd=5Fpath(pp, vecs)
=EF=BC=9E +        ret =3D ev=5Fadd=5Fpath(pp, vecs, need=5Fdo=5Fmap)
=EF=BC=9E      } else {
=EF=BC=9E          condlog(0, "%s: failed to store path info, "
=EF=BC=9E              "dropping event",
=EF=BC=9E @@ -699,7 +699,7 @@ uev=5Fadd=5Fpath (struct uevent *uev, struct =
vectors * vecs)
=EF=BC=9E   * 1: error
=EF=BC=9E   */
=EF=BC=9E  int
=EF=BC=9E -ev=5Fadd=5Fpath (struct path * pp, struct vectors * vecs)
=EF=BC=9E +ev=5Fadd=5Fpath (struct path * pp, struct vectors * vecs, int ne=
ed=5Fdo=5Fmap)
=EF=BC=9E  {
=EF=BC=9E      struct multipath * mpp
=EF=BC=9E      char params[PARAMS=5FSIZE] =3D {0}
=EF=BC=9E @@ -767,6 +767,13 @@ rescan:
=EF=BC=9E      /* persistent reservation check*/
=EF=BC=9E      mpath=5Fpr=5Fevent=5Fhandle(pp)
=EF=BC=9E =20
=EF=BC=9E +    if (!need=5Fdo=5Fmap)
=EF=BC=9E +        return 0
=EF=BC=9E +
=EF=BC=9E +    if (!dm=5Fmap=5Fpresent(mpp-=EF=BC=9Ealias)) {
=EF=BC=9E +        mpp-=EF=BC=9Eaction =3D ACT=5FCREATE
=EF=BC=9E +        start=5Fwaiter =3D 1
=EF=BC=9E +    }
=EF=BC=9E      /*
=EF=BC=9E       * push the map to the device-mapper
=EF=BC=9E       */
=EF=BC=9E @@ -833,7 +840,7 @@ fail:
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E  static int
=EF=BC=9E -uev=5Fremove=5Fpath (struct uevent *uev, struct vectors * vecs)
=EF=BC=9E +uev=5Fremove=5Fpath (struct uevent *uev, struct vectors * vecs, =
int need=5Fdo=5Fmap)
=EF=BC=9E  {
=EF=BC=9E      struct path *pp
=EF=BC=9E      int ret
=EF=BC=9E @@ -844,7 +851,7 @@ uev=5Fremove=5Fpath (struct uevent *uev, stru=
ct vectors * vecs)
=EF=BC=9E      pthread=5Ftestcancel()
=EF=BC=9E      pp =3D find=5Fpath=5Fby=5Fdev(vecs-=EF=BC=9Epathvec, uev-=EF=
=BC=9Ekernel)
=EF=BC=9E      if (pp)
=EF=BC=9E -        ret =3D ev=5Fremove=5Fpath(pp, vecs)
=EF=BC=9E +        ret =3D ev=5Fremove=5Fpath(pp, vecs, need=5Fdo=5Fmap)
=EF=BC=9E      lock=5Fcleanup=5Fpop(vecs-=EF=BC=9Elock)
=EF=BC=9E      if (!pp) {
=EF=BC=9E          /* Not an error path might have been purged earlier */
=EF=BC=9E @@ -855,7 +862,7 @@ uev=5Fremove=5Fpath (struct uevent *uev, stru=
ct vectors * vecs)
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E  int
=EF=BC=9E -ev=5Fremove=5Fpath (struct path *pp, struct vectors * vecs)
=EF=BC=9E +ev=5Fremove=5Fpath (struct path *pp, struct vectors * vecs, int =
need=5Fdo=5Fmap)
=EF=BC=9E  {
=EF=BC=9E      struct multipath * mpp
=EF=BC=9E      int i, retval =3D 0
=EF=BC=9E @@ -918,6 +925,8 @@ ev=5Fremove=5Fpath (struct path *pp, struct v=
ectors * vecs)
=EF=BC=9E              goto out
=EF=BC=9E          }
=EF=BC=9E =20
=EF=BC=9E +        if (!need=5Fdo=5Fmap)
=EF=BC=9E +            goto out
=EF=BC=9E          /*
=EF=BC=9E           * reload the map
=EF=BC=9E           */
=EF=BC=9E @@ -995,7 +1004,7 @@ uev=5Fupdate=5Fpath (struct uevent *uev, str=
uct vectors * vecs)
=EF=BC=9E          }
=EF=BC=9E =20
=EF=BC=9E          if (pp-=EF=BC=9Einitialized =3D=3D INIT=5FREQUESTED=5FUD=
EV)
=EF=BC=9E -            retval =3D uev=5Fadd=5Fpath(uev, vecs)
=EF=BC=9E +            retval =3D uev=5Fadd=5Fpath(uev, vecs, 1)
=EF=BC=9E          else if (mpp && ro =EF=BC=9E=3D 0) {
=EF=BC=9E              condlog(2, "%s: update path write=5Fprotect to '%d' =
(uevent)", uev-=EF=BC=9Ekernel, ro)
=EF=BC=9E =20
=EF=BC=9E @@ -1016,7 +1025,7 @@ out:
=EF=BC=9E              int flag =3D DI=5FSYSFS | DI=5FWWID
=EF=BC=9E =20
=EF=BC=9E              conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E -            retval =3D alloc=5Fpath=5Fwith=5Fpathinfo(conf, uev-=
=EF=BC=9Eudev, flag, NULL)
=EF=BC=9E +            retval =3D alloc=5Fpath=5Fwith=5Fpathinfo(conf, uev-=
=EF=BC=9Eudev, uev-=EF=BC=9Ewwid, flag, NULL)
=EF=BC=9E              put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E =20
=EF=BC=9E              if (retval =3D=3D PATHINFO=5FSKIPPED) {
=EF=BC=9E @@ -1077,40 +1086,15 @@ uxsock=5Ftrigger (char * str, char ** rep=
ly, int * len, void * trigger=5Fdata)
=EF=BC=9E      return r
=EF=BC=9E  }
=EF=BC=9E =20
=EF=BC=9E -static int
=EF=BC=9E -uev=5Fdiscard(char * devpath)
=EF=BC=9E -{
=EF=BC=9E -    char *tmp
=EF=BC=9E -    char a[11], b[11]
=EF=BC=9E -
=EF=BC=9E -    /*
=EF=BC=9E -     * keep only block devices, discard partitions
=EF=BC=9E -     */
=EF=BC=9E -    tmp =3D strstr(devpath, "/block/")
=EF=BC=9E -    if (tmp =3D=3D NULL){
=EF=BC=9E -        condlog(4, "no /block/ in '%s'", devpath)
=EF=BC=9E -        return 1
=EF=BC=9E -    }
=EF=BC=9E -    if (sscanf(tmp, "/block/%10s", a) !=3D 1 ||
=EF=BC=9E -        sscanf(tmp, "/block/%10[^/]/%10s", a, b) =3D=3D 2) {
=EF=BC=9E -        condlog(4, "discard event on %s", devpath)
=EF=BC=9E -        return 1
=EF=BC=9E -    }
=EF=BC=9E -    return 0
=EF=BC=9E -}
=EF=BC=9E -
=EF=BC=9E  int
=EF=BC=9E  uev=5Ftrigger (struct uevent * uev, void * trigger=5Fdata)
=EF=BC=9E  {
=EF=BC=9E      int r =3D 0
=EF=BC=9E      struct vectors * vecs
=EF=BC=9E -    struct config *conf
=EF=BC=9E +    struct uevent *merge=5Fuev, *tmp
=EF=BC=9E =20
=EF=BC=9E      vecs =3D (struct vectors *)trigger=5Fdata
=EF=BC=9E =20
=EF=BC=9E -    if (uev=5Fdiscard(uev-=EF=BC=9Edevpath))
=EF=BC=9E -        return 0
=EF=BC=9E -
=EF=BC=9E      pthread=5Fcleanup=5Fpush(config=5Fcleanup, NULL)
=EF=BC=9E      pthread=5Fmutex=5Flock(&config=5Flock)
=EF=BC=9E      if (running=5Fstate !=3D DAEMON=5FIDLE &&
=EF=BC=9E @@ -1139,28 +1123,21 @@ uev=5Ftrigger (struct uevent * uev, void =
* trigger=5Fdata)
=EF=BC=9E      }
=EF=BC=9E =20
=EF=BC=9E      /*
=EF=BC=9E -     * path add/remove event
=EF=BC=9E +     * path add/remove/change event, add/remove maybe merged
=EF=BC=9E       */
=EF=BC=9E -    conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E -    if (filter=5Fdevnode(conf-=EF=BC=9Eblist=5Fdevnode, conf-=EF=
=BC=9Eelist=5Fdevnode,
=EF=BC=9E -               uev-=EF=BC=9Ekernel) =EF=BC=9E 0) {
=EF=BC=9E -        put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E -        goto out
=EF=BC=9E +    list=5Ffor=5Feach=5Fentry=5Fsafe(merge=5Fuev, tmp, &uev-=EF=
=BC=9Emerge=5Fnode, node) {
=EF=BC=9E +        if (!strncmp(merge=5Fuev-=EF=BC=9Eaction, "add", 3))
=EF=BC=9E +            r +=3D uev=5Fadd=5Fpath(merge=5Fuev, vecs, 0)
=EF=BC=9E +        if (!strncmp(merge=5Fuev-=EF=BC=9Eaction, "remove", 6))
=EF=BC=9E +            r +=3D uev=5Fremove=5Fpath(merge=5Fuev, vecs, 0)
=EF=BC=9E      }
=EF=BC=9E -    put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E =20
=EF=BC=9E -    if (!strncmp(uev-=EF=BC=9Eaction, "add", 3)) {
=EF=BC=9E -        r =3D uev=5Fadd=5Fpath(uev, vecs)
=EF=BC=9E -        goto out
=EF=BC=9E -    }
=EF=BC=9E -    if (!strncmp(uev-=EF=BC=9Eaction, "remove", 6)) {
=EF=BC=9E -        r =3D uev=5Fremove=5Fpath(uev, vecs)
=EF=BC=9E -        goto out
=EF=BC=9E -    }
=EF=BC=9E -    if (!strncmp(uev-=EF=BC=9Eaction, "change", 6)) {
=EF=BC=9E -        r =3D uev=5Fupdate=5Fpath(uev, vecs)
=EF=BC=9E -        goto out
=EF=BC=9E -    }
=EF=BC=9E +    if (!strncmp(uev-=EF=BC=9Eaction, "add", 3))
=EF=BC=9E +        r +=3D uev=5Fadd=5Fpath(uev, vecs, 1)
=EF=BC=9E +    if (!strncmp(uev-=EF=BC=9Eaction, "remove", 6))
=EF=BC=9E +        r +=3D uev=5Fremove=5Fpath(uev, vecs, 1)
=EF=BC=9E +    if (!strncmp(uev-=EF=BC=9Eaction, "change", 6))
=EF=BC=9E +        r +=3D uev=5Fupdate=5Fpath(uev, vecs)
=EF=BC=9E =20
=EF=BC=9E  out:
=EF=BC=9E      return r
=EF=BC=9E @@ -1570,7 +1547,7 @@ check=5Fpath (struct vectors * vecs, struct=
 path * pp, int ticks)
=EF=BC=9E              conf =3D get=5Fmultipath=5Fconfig()
=EF=BC=9E              ret =3D pathinfo(pp, conf, DI=5FALL | DI=5FBLACKLIST)
=EF=BC=9E              if (ret =3D=3D PATHINFO=5FOK) {
=EF=BC=9E -                ev=5Fadd=5Fpath(pp, vecs)
=EF=BC=9E +                ev=5Fadd=5Fpath(pp, vecs, 1)
=EF=BC=9E                  pp-=EF=BC=9Etick =3D 1
=EF=BC=9E              } else if (ret =3D=3D PATHINFO=5FSKIPPED) {
=EF=BC=9E                  put=5Fmultipath=5Fconfig(conf)
=EF=BC=9E @@ -1686,7 +1663,7 @@ check=5Fpath (struct vectors * vecs, struct=
 path * pp, int ticks)
=EF=BC=9E          }
=EF=BC=9E          if (!disable=5Freinstate && reinstate=5Fpath(pp, add=5Fa=
ctive)) {
=EF=BC=9E              condlog(3, "%s: reload map", pp-=EF=BC=9Edev)
=EF=BC=9E -            ev=5Fadd=5Fpath(pp, vecs)
=EF=BC=9E +            ev=5Fadd=5Fpath(pp, vecs, 1)
=EF=BC=9E              pp-=EF=BC=9Etick =3D 1
=EF=BC=9E              return 0
=EF=BC=9E          }
=EF=BC=9E @@ -1709,7 +1686,7 @@ check=5Fpath (struct vectors * vecs, struct=
 path * pp, int ticks)
=EF=BC=9E              /* Clear IO errors */
=EF=BC=9E              if (reinstate=5Fpath(pp, 0)) {
=EF=BC=9E                  condlog(3, "%s: reload map", pp-=EF=BC=9Edev)
=EF=BC=9E -                ev=5Fadd=5Fpath(pp, vecs)
=EF=BC=9E +                ev=5Fadd=5Fpath(pp, vecs, 1)
=EF=BC=9E                  pp-=EF=BC=9Etick =3D 1
=EF=BC=9E                  return 0
=EF=BC=9E              }
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
=EF=BC=9E --=20
=EF=BC=9E 2.8.1.windows.1
=EF=BC=9E=20

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

--=====_003_next=====
Content-Type: text/html ;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div class=3D"zcontentRow"> <p>Hello Ben,</p><p><br></p><p>Good catch, you =
are so nice and responsible person.</p><p>I have modified those bugs and re=
sended the patch just now,</p><p>Please have a review for it.</p><p><br></p=
><p>Thanks,</p><p>Tang Junhui</p><p><br></p><p><br></p><p><br></p><p><br></=
p><div><div class=3D"zhistoryRow" style=3D"display:block"><div class=3D"zhi=
storyDes" style=3D"width: 100%; height: 28px; line-height: 28px; background=
-color: #E0E5E9; color: #1388FF; text-align: center;" language-data=3D"Hist=
oryOrgTxt">=E5=8E=9F=E5=A7=8B=E9=82=AE=E4=BB=B6</div><div id=3D"zwriteHisto=
ryContainer"><div class=3D"control-group zhistoryPanel"><div class=3D"zhist=
oryHeader" style=3D"padding: 8px; background-color: #F5F6F8;"><div><strong =
language-data=3D"HistorySenderTxt">=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9A</st=
rong><span class=3D"zreadUserName"> =EF=BC=9Cbmarzins@redhat.com=EF=BC=9E;<=
/span></div><div><strong language-data=3D"HistoryTOTxt">=E6=94=B6=E4=BB=B6=
=E4=BA=BA=EF=BC=9A</strong><span class=3D"zreadUserName" style=3D"display: =
inline-block;">=E5=94=90=E5=86=9B=E8=BE=8910074136;</span></div><div><stron=
g language-data=3D"HistoryCCTxt">=E6=8A=84=E9=80=81=E4=BA=BA=EF=BC=9A</stro=
ng><span class=3D"zreadUserName" style=3D"display: inline-block;">=E5=94=90=
=E6=96=87=E4=BF=8A10144149;</span><span class=3D"zreadUserName" style=3D"di=
splay: inline-block;">=E5=BC=A0=E5=87=AF10072500;</span><span class=3D"zrea=
dUserName" style=3D"display: inline-block;"> =EF=BC=9Cdm-devel@redhat.com=
=EF=BC=9E;</span><span class=3D"zreadUserName" style=3D"display: inline-blo=
ck;"> =EF=BC=9Cbart.vanassche@sandisk.com=EF=BC=9E;</span><span class=3D"zr=
eadUserName" style=3D"display: inline-block;"> =EF=BC=9Cmwilck@suse.com=EF=
=BC=9E;</span></div><div><strong language-data=3D"HistoryDateTxt">=E6=97=A5=
 =E6=9C=9F =EF=BC=9A</strong><span class=3D"">2017=E5=B9=B402=E6=9C=8816=E6=
=97=A5 05:15</span></div><div><strong language-data=3D"HistorySubjectTxt">=
=E4=B8=BB =E9=A2=98 =EF=BC=9A</strong><span class=3D"zreadTitle"><strong>Re=
: [dm-devel] [PATCH] multipath-tools: improve processing efficiency for add=
ition and deletion of multipath devices</strong></span></div></div><p class=
=3D"zhistoryContent"><br></p><div>On&nbsp;Wed,&nbsp;Jan&nbsp;18,&nbsp;2017&=
nbsp;at&nbsp;03:38:33PM&nbsp;+0800,&nbsp;tang.junhui@zte.com.cn&nbsp;wrote:=
<br>=EF=BC=9E&nbsp;From:&nbsp;"tang.junhui"&nbsp;=EF=BC=9Ctang.junhui@zte.c=
om.cn=EF=BC=9E<br>=EF=BC=9E&nbsp;<br>=EF=BC=9E&nbsp;Change-Id:&nbsp;I3f81a5=
5fff389f991f915927000b281d7e263cc5<br>=EF=BC=9E&nbsp;Signed-off-by:&nbsp;ta=
ng.junhui&nbsp;=EF=BC=9Ctang.junhui@zte.com.cn=EF=BC=9E<br>=EF=BC=9E&nbsp;<=
br>=EF=BC=9E&nbsp;This&nbsp;patch&nbsp;used&nbsp;to&nbsp;improve&nbsp;proce=
ssing&nbsp;efficiency&nbsp;for&nbsp;addition&nbsp;and&nbsp;deletion<br>=EF=
=BC=9E&nbsp;of&nbsp;multipath&nbsp;devices.<br>=EF=BC=9E&nbsp;<br>=EF=BC=9E=
&nbsp;This&nbsp;patch&nbsp;is&nbsp;tested&nbsp;pass&nbsp;by&nbsp;ZTE&nbsp;m=
ultipath&nbsp;automatic&nbsp;testing&nbsp;system.<br>=EF=BC=9E&nbsp;The&nbs=
p;modification&nbsp;reduces&nbsp;the&nbsp;system&nbsp;consumption(such&nbsp=
;as&nbsp;CPU)&nbsp;and&nbsp;shortens<br>=EF=BC=9E&nbsp;the&nbsp;processing&=
nbsp;time&nbsp;obviously&nbsp;in&nbsp;scene&nbsp;of&nbsp;massive&nbsp;multi=
path&nbsp;devices<br>=EF=BC=9E&nbsp;addition&nbsp;or&nbsp;deletion.<br>=EF=
=BC=9E&nbsp;<br>=EF=BC=9E&nbsp;The&nbsp;main&nbsp;processing&nbsp;flow&nbsp=
;of&nbsp;code&nbsp;is:<br>=EF=BC=9E&nbsp;1)&nbsp;add&nbsp;uid=5Fattrs&nbsp;=
configuration&nbsp;in&nbsp;the&nbsp;defaults&nbsp;section:<br>=EF=BC=9E&nbs=
p;&nbsp;&nbsp;&nbsp;It&nbsp;is&nbsp;configured&nbsp;udev&nbsp;attribute&nbs=
p;which&nbsp;providing&nbsp;a&nbsp;unique&nbsp;path&nbsp;identifier<br>=EF=
=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;for&nbsp;corresponding&nbsp;type&nbsp;of&nbsp=
;path&nbsp;devices.&nbsp;If&nbsp;this&nbsp;field&nbsp;is&nbsp;configured&nb=
sp;and<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;matched&nbsp;with&nbsp;type&nbsp=
;of&nbsp;device,&nbsp;it&nbsp;would&nbsp;override&nbsp;any&nbsp;other&nbsp;=
methods&nbsp;providing<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;for&nbsp;device&=
nbsp;unique&nbsp;identifier&nbsp;in&nbsp;config&nbsp;file,&nbsp;and&nbsp;it=
&nbsp;would&nbsp;activate&nbsp;merging<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;=
uevents&nbsp;according&nbsp;to&nbsp;the&nbsp;identifier&nbsp;to&nbsp;promot=
e&nbsp;effiecncy&nbsp;in&nbsp;processing<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbs=
p;uevents.&nbsp;Tt&nbsp;has&nbsp;no&nbsp;default&nbsp;value,&nbsp;so&nbsp;d=
efaultly&nbsp;only&nbsp;uevents&nbsp;filtering<br>=EF=BC=9E&nbsp;&nbsp;&nbs=
p;&nbsp;works,&nbsp;and&nbsp;uevents&nbsp;merging&nbsp;does&nbsp;not&nbsp;w=
orks,&nbsp;if&nbsp;users&nbsp;want&nbsp;to&nbsp;identify&nbsp;path<br>=EF=
=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;by&nbsp;udev&nbsp;attribute&nbsp;and&nbsp;to&=
nbsp;activate&nbsp;merging&nbsp;uevents&nbsp;for&nbsp;SCSI&nbsp;and&nbsp;DA=
S&nbsp;device,<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;they&nbsp;can&nbsp;set&n=
bsp;it's&nbsp;value&nbsp;as:<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;"sd:ID=5FS=
ERIAL&nbsp;dasd:ID=5FUID"<br>=EF=BC=9E&nbsp;2)&nbsp;uevents&nbsp;accumulati=
on&nbsp;in&nbsp;uevents&nbsp;burst&nbsp;scene:<br>=EF=BC=9E&nbsp;&nbsp;&nbs=
p;&nbsp;wait&nbsp;one&nbsp;seconds&nbsp;for&nbsp;more&nbsp;uevents&nbsp;in&=
nbsp;uevent=5Flisten()&nbsp;in&nbsp;uevents&nbsp;burst<br>=EF=BC=9E&nbsp;&n=
bsp;&nbsp;&nbsp;situations<br>=EF=BC=9E&nbsp;3)&nbsp;uevents&nbsp;preparing=
,&nbsp;filtering&nbsp;and&nbsp;merging:<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp=
;discard&nbsp;unuse&nbsp;uevents&nbsp;and&nbsp;fetch&nbsp;path&nbsp;idendif=
ier&nbsp;from&nbsp;uevents;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;filter&nbsp=
;uevents;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;merge&nbsp;uevents.<br>=EF=BC=
=9E&nbsp;4)&nbsp;uevents&nbsp;proccessing:<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&n=
bsp;proccess&nbsp;the&nbsp;merged&nbsp;uevents&nbsp;in&nbsp;uev-=EF=BC=9Eme=
rge=5Fnode&nbsp;list&nbsp;without&nbsp;calling<br>=EF=BC=9E&nbsp;&nbsp;&nbs=
p;&nbsp;domap();<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;proccess&nbsp;the&nbsp=
;last&nbsp;uevents&nbsp;uev&nbsp;with&nbsp;calling&nbsp;domap().<br>=EF=BC=
=9E&nbsp;<br>=EF=BC=9E&nbsp;Any&nbsp;comment&nbsp;will&nbsp;be&nbsp;welcome=
,&nbsp;and&nbsp;it&nbsp;would&nbsp;be&nbsp;appreciated&nbsp;if&nbsp;these<b=
r>=EF=BC=9E&nbsp;patches&nbsp;would&nbsp;be&nbsp;considered&nbsp;for&nbsp;i=
nclusion&nbsp;in&nbsp;the&nbsp;upstream<br>=EF=BC=9E&nbsp;multipath-tools.<=
br><br>Sorry&nbsp;for&nbsp;letting&nbsp;this&nbsp;slip&nbsp;through&nbsp;th=
e&nbsp;cracks.&nbsp;This&nbsp;patch&nbsp;is&nbsp;really<br>close.&nbsp;I&nb=
sp;just&nbsp;have&nbsp;a&nbsp;few&nbsp;issues.&nbsp;First&nbsp;off,&nbsp;th=
is&nbsp;is&nbsp;completely<br>superficial,&nbsp;but&nbsp;select=5Fgetuid()&=
nbsp;should&nbsp;use&nbsp;the&nbsp;new&nbsp;style&nbsp;of&nbsp;origin<br>me=
ssages.&nbsp;instead&nbsp;of<br><br>origin&nbsp;=3D&nbsp;"(config&nbsp;file=
&nbsp;default)";<br><br>it&nbsp;should&nbsp;probably&nbsp;be<br><br>origin&=
nbsp;=3D&nbsp;"(setting:&nbsp;multipath.conf&nbsp;defaults/devices&nbsp;sec=
tion)"<br><br>to&nbsp;match&nbsp;the&nbsp;other&nbsp;messages.<br><br><br>S=
econd,&nbsp;there&nbsp;is&nbsp;a&nbsp;bug&nbsp;in&nbsp;parse=5Fuid=5Fattrib=
ute=5Fby=5Fattrs().&nbsp;get=5Fword()<br>returns&nbsp;the&nbsp;number&nbsp;=
of&nbsp;characters&nbsp;that&nbsp;the&nbsp;returned&nbsp;word&nbsp;takes&nb=
sp;up&nbsp;in&nbsp;the<br>sentence,&nbsp;but&nbsp;you&nbsp;keep&nbsp;using&=
nbsp;it&nbsp;as&nbsp;the&nbsp;offset&nbsp;from&nbsp;the&nbsp;start&nbsp;of<=
br>uid=5Fattrs.&nbsp;&nbsp;This&nbsp;doesn't&nbsp;effect&nbsp;the&nbsp;firs=
t&nbsp;call&nbsp;to&nbsp;get=5Fword(),&nbsp;since&nbsp;it<br>doesn't&nbsp;u=
se&nbsp;count.&nbsp;The&nbsp;second&nbsp;time&nbsp;you&nbsp;call&nbsp;get=
=5Fword(),&nbsp;everything&nbsp;still<br>works&nbsp;because&nbsp;the&nbsp;n=
umber&nbsp;of&nbsp;characters&nbsp;that&nbsp;the&nbsp;first&nbsp;word&nbsp;=
took&nbsp;up&nbsp;is<br>also&nbsp;the&nbsp;offset&nbsp;from&nbsp;the&nbsp;s=
tart&nbsp;of&nbsp;uid=5Fattrs.&nbsp;&nbsp;However,&nbsp;on&nbsp;a<br>(hypot=
hetical)&nbsp;third&nbsp;call,&nbsp;count&nbsp;is&nbsp;just&nbsp;the&nbsp;s=
ize&nbsp;of&nbsp;the&nbsp;second&nbsp;word,<br>but&nbsp;you&nbsp;use&nbsp;a=
re&nbsp;using&nbsp;it&nbsp;as&nbsp;the&nbsp;offset&nbsp;from&nbsp;the&nbsp;=
start&nbsp;of&nbsp;uid=5Fattrs&nbsp;(the<br>size&nbsp;of&nbsp;the&nbsp;firs=
t&nbsp;and&nbsp;second&nbsp;word&nbsp;combined).&nbsp;This&nbsp;means&nbsp;=
that&nbsp;the&nbsp;a&nbsp;third<br>call&nbsp;won't&nbsp;start&nbsp;at&nbsp;=
the&nbsp;correct&nbsp;place,&nbsp;and&nbsp;can&nbsp;get&nbsp;stuck&nbsp;in&=
nbsp;an&nbsp;endless<br>loop.&nbsp;Obviously,&nbsp;as&nbsp;long&nbsp;as&nbs=
p;uid=5Fattrs&nbsp;only&nbsp;has&nbsp;two&nbsp;words&nbsp;in&nbsp;the&nbsp;=
value,<br>this&nbsp;isn't&nbsp;a&nbsp;problem.&nbsp;&nbsp;But&nbsp;if&nbsp;=
we&nbsp;ever&nbsp;add&nbsp;another&nbsp;uid&nbsp;attribute&nbsp;to&nbsp;the=
<br>list,&nbsp;it&nbsp;will&nbsp;break.<br><br><br>Finally,&nbsp;in&nbsp;ue=
vent=5Fget=5Fwwid,&nbsp;the&nbsp;goal&nbsp;is&nbsp;to&nbsp;see&nbsp;an&nbsp=
;environment&nbsp;variable<br>like<br><br>ID=5FSERIAL=3D3600d0230000000000e=
13955cc3757800<br><br>and&nbsp;correctly&nbsp;grab&nbsp;"3600d0230000000000=
e13955cc3757800"&nbsp;as&nbsp;the&nbsp;wwid.<br>Unfortunately&nbsp;in&nbsp;=
the&nbsp;list&nbsp;of&nbsp;environment&nbsp;variables&nbsp;for&nbsp;scsi&nb=
sp;devices,<br>there&nbsp;is&nbsp;also<br><br>ID=5FSERIAL=5FSHORT=3D600d023=
0000000000e13955cc3757800<br><br>If&nbsp;multipath&nbsp;happened&nbsp;to&nb=
sp;see&nbsp;this&nbsp;environment&nbsp;variable&nbsp;first,&nbsp;it&nbsp;wo=
uld<br>grab&nbsp;"SHORT=3D600d0230000000000e13955cc3757800"&nbsp;as&nbsp;th=
e&nbsp;wwid.&nbsp;It&nbsp;needs&nbsp;to<br>check&nbsp;that&nbsp;the&nbsp;ch=
aracter&nbsp;after&nbsp;strlen(uid=5Fattribute)&nbsp;is&nbsp;an&nbsp;equals=
&nbsp;sign.<br>Now,&nbsp;I&nbsp;realize&nbsp;that&nbsp;code&nbsp;all&nbsp;o=
ver&nbsp;multipath-tools&nbsp;doesn't&nbsp;bother<br>checking&nbsp;for&nbsp=
;an&nbsp;equals&nbsp;sign,&nbsp;but&nbsp;in&nbsp;this&nbsp;specific&nbsp;ca=
se&nbsp;there&nbsp;is&nbsp;a&nbsp;known<br>evironment&nbsp;variable&nbsp;th=
at&nbsp;could&nbsp;cause&nbsp;problems&nbsp;if&nbsp;we&nbsp;don't&nbsp;chec=
k&nbsp;(not<br>that&nbsp;those&nbsp;other&nbsp;cases&nbsp;don't&nbsp;need&n=
bsp;fixing&nbsp;eventually).<br><br>otherwise,&nbsp;it&nbsp;looks&nbsp;grea=
t.<br><br>Thanks<br>-Ben<br><br>=EF=BC=9E&nbsp;Thank&nbsp;you&nbsp;all,<br>=
=EF=BC=9E&nbsp;Tang&nbsp;Junhui<br>=EF=BC=9E&nbsp;---<br>=EF=BC=9E&nbsp;&nb=
sp;libmultipath/config.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&n=
bsp;3&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;libmultipath/config.h&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;1&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;libm=
ultipath/dict.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp=
;&nbsp;3&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;libmultipath/discovery.c&nbsp;&nbsp=
;&nbsp;|&nbsp;&nbsp;&nbsp;5&nbsp;+-<br>=EF=BC=9E&nbsp;&nbsp;libmultipath/di=
scovery.h&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;2&nbsp;+-<br>=EF=BC=9E&nbsp;&=
nbsp;libmultipath/list.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&n=
bsp;&nbsp;41&nbsp;++++++<br>=EF=BC=9E&nbsp;&nbsp;libmultipath/propsel.c&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;7&nbsp;+<br>=EF=BC=9E&nbsp;&nb=
sp;libmultipath/uevent.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;319&nbsp=
;+++++++++++++++++++++++++++++++++++++++++++--<br>=EF=BC=9E&nbsp;&nbsp;libm=
ultipath/uevent.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;2&n=
bsp;+<br>=EF=BC=9E&nbsp;&nbsp;libmultipath/util.c&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;40&nbsp;++++++<br>=EF=BC=9E&nbsp;&nbsp;l=
ibmultipath/util.h&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&n=
bsp;&nbsp;1&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;multipath/multipath.conf.5&nbsp;=
|&nbsp;&nbsp;18&nbsp;+++<br>=EF=BC=9E&nbsp;&nbsp;multipathd/cli=5Fhandlers.=
c&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;4&nbsp;+-<br>=EF=BC=9E&nbsp;&nbsp;multipath=
d/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;=
&nbsp;93&nbsp;+++++--------<br>=EF=BC=9E&nbsp;&nbsp;multipathd/main.h&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;4&=
nbsp;+-<br>=EF=BC=9E&nbsp;&nbsp;15&nbsp;files&nbsp;changed,&nbsp;468&nbsp;i=
nsertions(+),&nbsp;75&nbsp;deletions(-)<br>=EF=BC=9E&nbsp;<br>=EF=BC=9E&nbs=
p;diff&nbsp;--git&nbsp;a/libmultipath/config.c&nbsp;b/libmultipath/config.c=
<br>=EF=BC=9E&nbsp;index&nbsp;15ddbd8..765e91d&nbsp;100644<br>=EF=BC=9E&nbs=
p;---&nbsp;a/libmultipath/config.c<br>=EF=BC=9E&nbsp;+++&nbsp;b/libmultipat=
h/config.c<br>=EF=BC=9E&nbsp;@@&nbsp;-488,6&nbsp;+488,9&nbsp;@@&nbsp;free=
=5Fconfig&nbsp;(struct&nbsp;config&nbsp;*&nbsp;conf)<br>=EF=BC=9E&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(conf-=EF=BC=9Euid=5Fattribute)<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FREE(conf-=
=EF=BC=9Euid=5Fattribute);<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;+&nbs=
p;&nbsp;&nbsp;&nbsp;if&nbsp;(conf-=EF=BC=9Euid=5Fattrs)<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FREE(conf-=EF=BC=9Euid=5Fat=
trs);<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;i=
f&nbsp;(conf-=EF=BC=9Egetuid)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;FREE(conf-=EF=BC=9Egetuid);<br>=EF=BC=9E&nbsp;&n=
bsp;<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/libmultipath/config.h&nbsp;b/=
libmultipath/config.h<br>=EF=BC=9E&nbsp;index&nbsp;9670020..ab85930&nbsp;10=
0644<br>=EF=BC=9E&nbsp;---&nbsp;a/libmultipath/config.h<br>=EF=BC=9E&nbsp;+=
++&nbsp;b/libmultipath/config.h<br>=EF=BC=9E&nbsp;@@&nbsp;-153,6&nbsp;+153,=
7&nbsp;@@&nbsp;struct&nbsp;config&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*&nbsp;multipath=5Fdir;<br=
>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*&nbsp;selector;<br=
>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*&nbsp;uid=5Fattrs;<br>=
=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*&nbsp;uid=5Fattribu=
te;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*&nbsp;getuid=
;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*&nbsp;features=
;<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/libmultipath/dict.c&nbsp;b/libmu=
ltipath/dict.c<br>=EF=BC=9E&nbsp;index&nbsp;dc21846..0a531d1&nbsp;100644<br=
>=EF=BC=9E&nbsp;---&nbsp;a/libmultipath/dict.c<br>=EF=BC=9E&nbsp;+++&nbsp;b=
/libmultipath/dict.c<br>=EF=BC=9E&nbsp;@@&nbsp;-249,6&nbsp;+249,8&nbsp;@@&n=
bsp;declare=5Fovr=5Fsnprint(selector,&nbsp;print=5Fstr)<br>=EF=BC=9E&nbsp;&=
nbsp;declare=5Fmp=5Fhandler(selector,&nbsp;set=5Fstr)<br>=EF=BC=9E&nbsp;&nb=
sp;declare=5Fmp=5Fsnprint(selector,&nbsp;print=5Fstr)<br>=EF=BC=9E&nbsp;&nb=
sp;<br>=EF=BC=9E&nbsp;+declare=5Fdef=5Fhandler(uid=5Fattrs,&nbsp;set=5Fstr)=
<br>=EF=BC=9E&nbsp;+declare=5Fdef=5Fsnprint(uid=5Fattrs,&nbsp;print=5Fstr)<=
br>=EF=BC=9E&nbsp;&nbsp;declare=5Fdef=5Fhandler(uid=5Fattribute,&nbsp;set=
=5Fstr)<br>=EF=BC=9E&nbsp;&nbsp;declare=5Fdef=5Fsnprint=5Fdefstr(uid=5Fattr=
ibute,&nbsp;print=5Fstr,&nbsp;DEFAULT=5FUID=5FATTRIBUTE)<br>=EF=BC=9E&nbsp;=
&nbsp;declare=5Fovr=5Fhandler(uid=5Fattribute,&nbsp;set=5Fstr)<br>=EF=BC=9E=
&nbsp;@@&nbsp;-1367,6&nbsp;+1369,7&nbsp;@@&nbsp;init=5Fkeywords(vector&nbsp=
;keywords)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;install=5Fkeywor=
d("multipath=5Fdir",&nbsp;&amp;def=5Fmultipath=5Fdir=5Fhandler,&nbsp;&amp;s=
nprint=5Fdef=5Fmultipath=5Fdir);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;install=5Fkeyword("path=5Fselector",&nbsp;&amp;def=5Fselector=5Fhandl=
er,&nbsp;&amp;snprint=5Fdef=5Fselector);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;install=5Fkeyword("path=5Fgrouping=5Fpolicy",&nbsp;&amp;def=
=5Fpgpolicy=5Fhandler,&nbsp;&amp;snprint=5Fdef=5Fpgpolicy);<br>=EF=BC=9E&nb=
sp;+&nbsp;&nbsp;&nbsp;&nbsp;install=5Fkeyword("uid=5Fattrs",&nbsp;&amp;def=
=5Fuid=5Fattrs=5Fhandler,&nbsp;&amp;snprint=5Fdef=5Fuid=5Fattrs);<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;install=5Fkeyword("uid=5Fattribute",=
&nbsp;&amp;def=5Fuid=5Fattribute=5Fhandler,&nbsp;&amp;snprint=5Fdef=5Fuid=
=5Fattribute);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;install=5Fke=
yword("getuid=5Fcallout",&nbsp;&amp;def=5Fgetuid=5Fhandler,&nbsp;&amp;snpri=
nt=5Fdef=5Fgetuid);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;install=
=5Fkeyword("prio",&nbsp;&amp;def=5Fprio=5Fname=5Fhandler,&nbsp;&amp;snprint=
=5Fdef=5Fprio=5Fname);<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/libmultipat=
h/discovery.c&nbsp;b/libmultipath/discovery.c<br>=EF=BC=9E&nbsp;index&nbsp;=
d1aec31..14904f2&nbsp;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/libmultipath/disc=
overy.c<br>=EF=BC=9E&nbsp;+++&nbsp;b/libmultipath/discovery.c<br>=EF=BC=9E&=
nbsp;@@&nbsp;-33,7&nbsp;+33,7&nbsp;@@<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E=
&nbsp;&nbsp;int<br>=EF=BC=9E&nbsp;&nbsp;alloc=5Fpath=5Fwith=5Fpathinfo&nbsp=
;(struct&nbsp;config&nbsp;*conf,&nbsp;struct&nbsp;udev=5Fdevice&nbsp;*udevi=
ce,<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;flag,&nbsp;struct&nbsp;path&nbsp;*=
*pp=5Fptr)<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*wwid,&nbsp;int&nbsp;flag,=
&nbsp;struct&nbsp;path&nbsp;**pp=5Fptr)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;err&nbsp;=3D&nbsp;PATHINFO=
=5FFAILED;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;path=
&nbsp;*&nbsp;pp;<br>=EF=BC=9E&nbsp;@@&nbsp;-51,6&nbsp;+51,9&nbsp;@@&nbsp;al=
loc=5Fpath=5Fwith=5Fpathinfo&nbsp;(struct&nbsp;config&nbsp;*conf,&nbsp;stru=
ct&nbsp;udev=5Fdevice&nbsp;*udevice,<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;if&nbsp;(!pp)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;return&nbsp;PATHINFO=5FFAILED;<br>=EF=BC=9E&nbsp;&nbsp=
;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if(wwid)<br>=EF=BC=9E&nbsp;+&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;strncpy(pp-=EF=BC=9Ewwid,&nbs=
p;wwid,&nbsp;sizeof(pp-=EF=BC=9Ewwid));<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(safe=5Fsprintf(pp-=EF=BC=9Edev,&n=
bsp;"%s",&nbsp;devname))&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(0,&nbsp;"pp-=EF=BC=9Edev&nbsp;too&nbsp=
;small");<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;else&nbsp;=
{<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/libmultipath/discovery.h&nbsp;b/=
libmultipath/discovery.h<br>=EF=BC=9E&nbsp;index&nbsp;3039268..d16a69a&nbsp=
;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/libmultipath/discovery.h<br>=EF=BC=9E&=
nbsp;+++&nbsp;b/libmultipath/discovery.h<br>=EF=BC=9E&nbsp;@@&nbsp;-37,7&nb=
sp;+37,7&nbsp;@@&nbsp;int&nbsp;path=5Foffline&nbsp;(struct&nbsp;path&nbsp;*=
);<br>=EF=BC=9E&nbsp;&nbsp;int&nbsp;get=5Fstate&nbsp;(struct&nbsp;path&nbsp=
;*&nbsp;pp,&nbsp;struct&nbsp;config&nbsp;*&nbsp;conf,&nbsp;int&nbsp;daemon)=
;<br>=EF=BC=9E&nbsp;&nbsp;int&nbsp;pathinfo&nbsp;(struct&nbsp;path&nbsp;*&n=
bsp;pp,&nbsp;struct&nbsp;config&nbsp;*&nbsp;conf,&nbsp;int&nbsp;mask);<br>=
=EF=BC=9E&nbsp;&nbsp;int&nbsp;alloc=5Fpath=5Fwith=5Fpathinfo&nbsp;(struct&n=
bsp;config&nbsp;*conf,&nbsp;struct&nbsp;udev=5Fdevice&nbsp;*udevice,<br>=EF=
=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;flag,&nbsp;struct&nb=
sp;path&nbsp;**pp=5Fptr);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;char&nbsp;*wwid,&nbsp;int&nbsp;flag,&nbsp;struct&nbsp;path&nbsp;**pp=5Fp=
tr);<br>=EF=BC=9E&nbsp;&nbsp;int&nbsp;store=5Fpathinfo&nbsp;(vector&nbsp;pa=
thvec,&nbsp;struct&nbsp;config&nbsp;*conf,<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp=
;udev=5Fdevice&nbsp;*udevice,&nbsp;int&nbsp;flag,<br>=EF=BC=9E&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stru=
ct&nbsp;path&nbsp;**pp=5Fptr);<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/lib=
multipath/list.h&nbsp;b/libmultipath/list.h<br>=EF=BC=9E&nbsp;index&nbsp;ce=
aa381..2b1dcf3&nbsp;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/libmultipath/list.h=
<br>=EF=BC=9E&nbsp;+++&nbsp;b/libmultipath/list.h<br>=EF=BC=9E&nbsp;@@&nbsp=
;-317,4&nbsp;+317,45&nbsp;@@&nbsp;static&nbsp;inline&nbsp;void&nbsp;list=5F=
splice=5Ftail=5Finit(struct&nbsp;list=5Fhead&nbsp;*list,<br>=EF=BC=9E&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&amp;pos-=EF=BC=
=9Emember&nbsp;!=3D&nbsp;(head);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;\<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;pos&nbsp;=3D&nbsp;n,&nbsp;n&nbsp;=3D&nbsp;list=5Fentry(n-=EF=BC=9Eme=
mber.next,&nbsp;typeof(*n),&nbsp;member))<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=
=BC=9E&nbsp;+/**<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;list=5Ffor=5Feach=5Fentry=
=5Freverse=5Fsafe&nbsp;-&nbsp;iterate&nbsp;backwards&nbsp;over&nbsp;list&nb=
sp;of&nbsp;given&nbsp;type&nbsp;safe&nbsp;against&nbsp;removal&nbsp;of&nbsp=
;list&nbsp;entry<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@pos:&nbsp;&nbsp;&nbsp;&nb=
sp;the&nbsp;type&nbsp;*&nbsp;to&nbsp;use&nbsp;as&nbsp;a&nbsp;loop&nbsp;coun=
ter.<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@n:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;another&nbsp;type&nbsp;*&nbsp;to&nbsp;use&nbsp;as&nbsp;tempora=
ry&nbsp;storage<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@head:&nbsp;&nbsp;&nbsp;&nb=
sp;the&nbsp;head&nbsp;for&nbsp;your&nbsp;list.<br>=EF=BC=9E&nbsp;+&nbsp;*&n=
bsp;@member:&nbsp;&nbsp;&nbsp;&nbsp;the&nbsp;name&nbsp;of&nbsp;the&nbsp;lis=
t=5Fstruct&nbsp;within&nbsp;the&nbsp;struct.<br>=EF=BC=9E&nbsp;+&nbsp;*/<br=
>=EF=BC=9E&nbsp;+#define&nbsp;list=5Ffor=5Feach=5Fentry=5Freverse=5Fsafe(po=
s,&nbsp;n,&nbsp;head,&nbsp;member)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;for&nbsp;(p=
os&nbsp;=3D&nbsp;list=5Fentry((head)-=EF=BC=9Eprev,&nbsp;typeof(*pos),&nbsp=
;member),&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n&nbsp;=3D&nbsp;list=5Fentry(p=
os-=EF=BC=9Emember.prev,&nbsp;typeof(*pos),&nbsp;member);\<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&amp;pos-=EF=BC=9E=
member&nbsp;!=3D&nbsp;(head);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;pos&nbsp;=3D&nbsp;n,&nbsp;n&nbsp;=3D&nbsp;list=5Fentry(=
n-=EF=BC=9Emember.prev,&nbsp;typeof(*n),&nbsp;member))<br>=EF=BC=9E&nbsp;+<=
br>=EF=BC=9E&nbsp;+/**<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;list=5Ffor=5Fsome=5F=
entry=5Fsafe&nbsp;-&nbsp;iterate&nbsp;list&nbsp;from&nbsp;the&nbsp;given&nb=
sp;begin&nbsp;node&nbsp;to&nbsp;the&nbsp;given&nbsp;end&nbsp;node&nbsp;safe=
&nbsp;against&nbsp;removal&nbsp;of&nbsp;list&nbsp;entry<br>=EF=BC=9E&nbsp;+=
&nbsp;*&nbsp;@pos:&nbsp;&nbsp;&nbsp;&nbsp;the&nbsp;type&nbsp;*&nbsp;to&nbsp=
;use&nbsp;as&nbsp;a&nbsp;loop&nbsp;counter.<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp=
;@n:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;another&nbsp;type&nbsp;=
*&nbsp;to&nbsp;use&nbsp;as&nbsp;temporary&nbsp;storage<br>=EF=BC=9E&nbsp;+&=
nbsp;*&nbsp;@from:&nbsp;&nbsp;&nbsp;&nbsp;the&nbsp;begin&nbsp;node&nbsp;of&=
nbsp;the&nbsp;iteration.<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@to:&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the&nbsp;end&nbsp;node&nbsp;of&nbsp;the&n=
bsp;iteration.<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@member:&nbsp;&nbsp;&nbsp;&n=
bsp;the&nbsp;name&nbsp;of&nbsp;the&nbsp;list=5Fstruct&nbsp;within&nbsp;the&=
nbsp;struct.<br>=EF=BC=9E&nbsp;+&nbsp;*/<br>=EF=BC=9E&nbsp;+#define&nbsp;li=
st=5Ffor=5Fsome=5Fentry=5Fsafe(pos,&nbsp;n,&nbsp;from,&nbsp;to,&nbsp;member=
)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;for&nbsp;(pos&nbsp;=
=3D&nbsp;list=5Fentry((from)-=EF=BC=9Enext,&nbsp;typeof(*pos),&nbsp;member)=
,&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n&nbsp;=3D&nbsp;list=5Fentry(pos-=EF=
=BC=9Emember.next,&nbsp;typeof(*pos),&nbsp;member);&nbsp;&nbsp;&nbsp;&nbsp;=
\<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&amp;pos-=EF=BC=9Emember&nbsp;!=3D&nbsp;(to);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pos&nbsp;=3D&nbsp;n,&nbsp;n=
&nbsp;=3D&nbsp;list=5Fentry(n-=EF=BC=9Emember.next,&nbsp;typeof(*n),&nbsp;m=
ember))<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+/**<br>=EF=BC=9E&nbsp;+&nbsp=
;*&nbsp;list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe&nbsp;-&nbsp;iterate&nbsp=
;backwards&nbsp;list&nbsp;from&nbsp;the&nbsp;given&nbsp;begin&nbsp;node&nbs=
p;to&nbsp;the&nbsp;given&nbsp;end&nbsp;node&nbsp;safe&nbsp;against&nbsp;rem=
oval&nbsp;of&nbsp;list&nbsp;entry<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@pos:&nbs=
p;&nbsp;&nbsp;&nbsp;the&nbsp;type&nbsp;*&nbsp;to&nbsp;use&nbsp;as&nbsp;a&nb=
sp;loop&nbsp;counter.<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@n:&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;another&nbsp;type&nbsp;*&nbsp;to&nbsp;use&nbs=
p;as&nbsp;temporary&nbsp;storage<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@from:&nbs=
p;&nbsp;&nbsp;&nbsp;the&nbsp;begin&nbsp;node&nbsp;of&nbsp;the&nbsp;iteratio=
n.<br>=EF=BC=9E&nbsp;+&nbsp;*&nbsp;@to:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;the&nbsp;end&nbsp;node&nbsp;of&nbsp;the&nbsp;iteration.<br>=EF=
=BC=9E&nbsp;+&nbsp;*&nbsp;@member:&nbsp;&nbsp;&nbsp;&nbsp;the&nbsp;name&nbs=
p;of&nbsp;the&nbsp;list=5Fstruct&nbsp;within&nbsp;the&nbsp;struct.<br>=EF=
=BC=9E&nbsp;+&nbsp;*/<br>=EF=BC=9E&nbsp;+#define&nbsp;list=5Ffor=5Fsome=5Fe=
ntry=5Freverse=5Fsafe(pos,&nbsp;n,&nbsp;from,&nbsp;to,&nbsp;member)&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;fo=
r&nbsp;(pos&nbsp;=3D&nbsp;list=5Fentry((from)-=EF=BC=9Eprev,&nbsp;typeof(*p=
os),&nbsp;member),&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;n&nbsp;=3D&nbsp;list=
=5Fentry(pos-=EF=BC=9Emember.prev,&nbsp;typeof(*pos),&nbsp;member);&nbsp;&n=
bsp;&nbsp;&nbsp;\<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&amp;pos-=EF=BC=9Emember&nbsp;!=3D&nbsp;(to);&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pos&nbsp;=
=3D&nbsp;n,&nbsp;n&nbsp;=3D&nbsp;list=5Fentry(n-=EF=BC=9Emember.prev,&nbsp;=
typeof(*n),&nbsp;member))<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;#endi=
f&nbsp;/*&nbsp;=5FLIST=5FH&nbsp;*/<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a=
/libmultipath/propsel.c&nbsp;b/libmultipath/propsel.c<br>=EF=BC=9E&nbsp;ind=
ex&nbsp;c0bc616..5a58dc0&nbsp;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/libmultip=
ath/propsel.c<br>=EF=BC=9E&nbsp;+++&nbsp;b/libmultipath/propsel.c<br>=EF=BC=
=9E&nbsp;@@&nbsp;-18,6&nbsp;+18,7&nbsp;@@<br>=EF=BC=9E&nbsp;&nbsp;#include&=
nbsp;"prio.h"<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;"discovery.h"<br>=EF=BC=
=9E&nbsp;&nbsp;#include&nbsp;"dict.h"<br>=EF=BC=9E&nbsp;+#include&nbsp;"uti=
l.h"<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;"prioritizers/alua=5Frtpg.h"<br>=
=EF=BC=9E&nbsp;&nbsp;#include&nbsp;=EF=BC=9Cinttypes.h=EF=BC=9E<br>=EF=BC=
=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;@@&nbsp;-339,6&nbsp;+340,12&nbsp;@@&nbsp;=
int&nbsp;select=5Fgetuid(struct&nbsp;config&nbsp;*conf,&nbsp;struct&nbsp;pa=
th&nbsp;*pp)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;char&nbsp;*origin;<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;pp-=EF=BC=9Euid=5Fattribute&nbsp;=3D&nbsp;parse=5Fu=
id=5Fattribute=5Fby=5Fattrs(conf-=EF=BC=9Euid=5Fattrs,&nbsp;pp-=EF=BC=9Edev=
);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(pp-=EF=BC=9Euid=5Fat=
tribute)&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;origin&nbsp;=3D&nbsp;"(config&nbsp;file&nbsp;default)";<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;goto&nbsp;out;<br=
>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pp=5Fset=5Fovr(getuid);<br>=EF=BC=9E&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pp=5Fset=5Fovr(uid=5Fattribute);<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pp=5Fset=5Fhwe(getuid);<br>=EF=BC=9E=
&nbsp;diff&nbsp;--git&nbsp;a/libmultipath/uevent.c&nbsp;b/libmultipath/ueve=
nt.c<br>=EF=BC=9E&nbsp;index&nbsp;7edcce1..7e4ac04&nbsp;100644<br>=EF=BC=9E=
&nbsp;---&nbsp;a/libmultipath/uevent.c<br>=EF=BC=9E&nbsp;+++&nbsp;b/libmult=
ipath/uevent.c<br>=EF=BC=9E&nbsp;@@&nbsp;-24,6&nbsp;+24,7&nbsp;@@<br>=EF=BC=
=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;=EF=BC=9Cunistd.h=EF=
=BC=9E<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;=EF=BC=9Cstdio.h=EF=BC=9E<br>=
=EF=BC=9E&nbsp;+#include&nbsp;=EF=BC=9Cstdbool.h=EF=BC=9E<br>=EF=BC=9E&nbsp=
;&nbsp;#include&nbsp;=EF=BC=9Cerrno.h=EF=BC=9E<br>=EF=BC=9E&nbsp;&nbsp;#inc=
lude&nbsp;=EF=BC=9Cstdlib.h=EF=BC=9E<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;=
=EF=BC=9Cstddef.h=EF=BC=9E<br>=EF=BC=9E&nbsp;@@&nbsp;-38,6&nbsp;+39,7&nbsp;=
@@<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;=EF=BC=9Clinux/netlink.h=EF=BC=9E<=
br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;=EF=BC=9Cpthread.h=EF=BC=9E<br>=EF=BC=
=9E&nbsp;&nbsp;#include&nbsp;=EF=BC=9Csys/mman.h=EF=BC=9E<br>=EF=BC=9E&nbsp=
;+#include&nbsp;=EF=BC=9Csys/time.h=EF=BC=9E<br>=EF=BC=9E&nbsp;&nbsp;#inclu=
de&nbsp;=EF=BC=9Clibudev.h=EF=BC=9E<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;=
=EF=BC=9Cerrno.h=EF=BC=9E<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;@@&nbs=
p;-46,6&nbsp;+48,14&nbsp;@@<br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;"list.h"<=
br>=EF=BC=9E&nbsp;&nbsp;#include&nbsp;"uevent.h"<br>=EF=BC=9E&nbsp;&nbsp;#i=
nclude&nbsp;"vector.h"<br>=EF=BC=9E&nbsp;+#include&nbsp;"structs.h"<br>=EF=
=BC=9E&nbsp;+#include&nbsp;"util.h"<br>=EF=BC=9E&nbsp;+#include&nbsp;"confi=
g.h"<br>=EF=BC=9E&nbsp;+#include&nbsp;"blacklist.h"<br>=EF=BC=9E&nbsp;+<br>=
=EF=BC=9E&nbsp;+#define&nbsp;MAX=5FACCUMULATION=5FCOUNT&nbsp;2048<br>=EF=BC=
=9E&nbsp;+#define&nbsp;MAX=5FACCUMULATION=5FTIME&nbsp;30*1000<br>=EF=BC=9E&=
nbsp;+#define&nbsp;MIN=5FBURST=5FSPEED&nbsp;10<br>=EF=BC=9E&nbsp;&nbsp;<br>=
=EF=BC=9E&nbsp;&nbsp;typedef&nbsp;int&nbsp;(uev=5Ftrigger)(struct&nbsp;ueve=
nt&nbsp;*,&nbsp;void&nbsp;*&nbsp;trigger=5Fdata);<br>=EF=BC=9E&nbsp;&nbsp;<=
br>=EF=BC=9E&nbsp;@@&nbsp;-72,48&nbsp;+82,300&nbsp;@@&nbsp;struct&nbsp;ueve=
nt&nbsp;*&nbsp;alloc=5Fuevent&nbsp;(void)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=
=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;*uev&nbsp=
;=3D&nbsp;MALLOC(sizeof(struct&nbsp;uevent));<br>=EF=BC=9E&nbsp;&nbsp;<br>=
=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(uev)<br>=EF=BC=9E&nbsp;+&n=
bsp;&nbsp;&nbsp;&nbsp;if&nbsp;(uev)&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INIT=5FLIST=5FHEAD(&amp;uev-=EF=BC=
=9Enode);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;INIT=5FLIST=5FHEAD(&amp;uev-=EF=BC=9Emerge=5Fnode);<br>=EF=BC=9E&nbsp;+&n=
bsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;return&nbsp;uev;<br>=EF=BC=9E&nbsp;&nbsp;}<br>=EF=BC=
=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;void<br>=EF=BC=9E&nbsp;-service=5Fu=
evq(struct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&nbsp;+uevq=5Fcleanup(s=
truct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;*uev,&nbsp;*tmp;<=
br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;li=
st=5Ffor=5Feach=5Fentry=5Fsafe(uev,&nbsp;tmp,&nbsp;tmpq,&nbsp;node)&nbsp;{<=
br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;lis=
t=5Fdel=5Finit(&amp;uev-=EF=BC=9Enode);<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=
=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(my=5Fuev=
=5Ftrigger&nbsp;&amp;&amp;&nbsp;my=5Fuev=5Ftrigger(uev,&nbsp;my=5Ftrigger=
=5Fdata))<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;condlog(0,&nbsp;"uevent&nbsp;trigger&nbsp;error")=
;<br>=EF=BC=9E&nbsp;-<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;if&nbsp;(uev-=EF=BC=9Eudev)<br>=EF=BC=9E&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;udev=5F=
device=5Funref(uev-=EF=BC=9Eudev);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FREE(uev);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=
=BC=9E&nbsp;-static&nbsp;void&nbsp;uevent=5Fcleanup(void&nbsp;*arg)<br>=EF=
=BC=9E&nbsp;+void<br>=EF=BC=9E&nbsp;+uevent=5Fget=5Fwwid(struct&nbsp;uevent=
&nbsp;*uev)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;=
&nbsp;struct&nbsp;udev&nbsp;*udev&nbsp;=3D&nbsp;arg;<br>=EF=BC=9E&nbsp;+&nb=
sp;&nbsp;&nbsp;&nbsp;int&nbsp;i;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;char&nbsp;*uid=5Fattribute;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;str=
uct&nbsp;config&nbsp;*&nbsp;conf;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbs=
p;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;conf&nbsp;=3D&nbsp;get=5Fmult=
ipath=5Fconfig();<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;uid=5Fattribut=
e&nbsp;=3D&nbsp;parse=5Fuid=5Fattribute=5Fby=5Fattrs(conf-=EF=BC=9Euid=5Fat=
trs,&nbsp;uev-=EF=BC=9Ekernel);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;=
put=5Fmultipath=5Fconfig(conf);&nbsp;&nbsp;&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp=
;(!uid=5Fattribute)<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;return;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;for&nbsp;(i&nbsp;=3D&nbsp;0;&nbsp;uev-=EF=
=BC=9Eenvp[i]&nbsp;!=3D&nbsp;NULL;&nbsp;i++)&nbsp;{<br>=EF=BC=9E&nbsp;+&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(uev-=EF=BC=9E=
envp[i],&nbsp;uid=5Fattribute,&nbsp;strlen(uid=5Fattribute))&nbsp;&amp;&amp=
;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;strlen(uev-=EF=BC=9Eenvp[i])&nbsp;=EF=BC=9E&nbsp;strlen(u=
id=5Fattribute))&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uev-=EF=BC=9Ewwid&nbsp;=3D&nbsp;uev=
-=EF=BC=9Eenvp[i]&nbsp;+&nbsp;strlen(uid=5Fattribute)&nbsp;+&nbsp;1;<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;break;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;}<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;free(uid=5Fattribute);<br>=EF=BC=9E&nbsp;+}<br>=EF=
=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;condlog(3,&nb=
sp;"Releasing&nbsp;uevent=5Flisten()&nbsp;resources");<br>=EF=BC=9E&nbsp;-&=
nbsp;&nbsp;&nbsp;&nbsp;udev=5Funref(udev);<br>=EF=BC=9E&nbsp;+bool<br>=EF=
=BC=9E&nbsp;+uevent=5Fneed=5Fmerge(void)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&=
nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;config&nbsp;*&nbsp;conf;<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;bool&nbsp;need=5Fmerge&nbsp;=3D&nbsp;f=
alse;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;conf&n=
bsp;=3D&nbsp;get=5Fmultipath=5Fconfig();<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nb=
sp;&nbsp;if&nbsp;(conf-=EF=BC=9Euid=5Fattrs)<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;need=5Fmerge&nbsp;=3D&nbsp;true;<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmultipath=5Fconfig(conf);&nbs=
p;&nbsp;&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nb=
sp;&nbsp;return&nbsp;need=5Fmerge;<br>=EF=BC=9E&nbsp;+}<br>=EF=BC=9E&nbsp;+=
<br>=EF=BC=9E&nbsp;+bool<br>=EF=BC=9E&nbsp;+uevent=5Fcan=5Fdiscard(struct&n=
bsp;uevent&nbsp;*uev)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;char&nbsp;*tmp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;char&=
nbsp;a[11],&nbsp;b[11];<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&n=
bsp;config&nbsp;*&nbsp;conf;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&=
nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp=
;keep&nbsp;only&nbsp;block&nbsp;devices,&nbsp;discard&nbsp;partitions<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;+&nbsp;&=
nbsp;&nbsp;&nbsp;tmp&nbsp;=3D&nbsp;strstr(uev-=EF=BC=9Edevpath,&nbsp;"/bloc=
k/");<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(tmp&nbsp;=3D=3D&n=
bsp;NULL){<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;condlog(4,&nbsp;"no&nbsp;/block/&nbsp;in&nbsp;'%s'",&nbsp;uev-=EF=BC=9Ed=
evpath);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;return&nbsp;true;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(sscanf(tmp,&nbsp;"/block/%10s",&=
nbsp;a)&nbsp;!=3D&nbsp;1&nbsp;||<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;sscanf(tmp,&nbsp;"/block/%10[^/]/%10s",&nbsp;a,&nb=
sp;b)&nbsp;=3D=3D&nbsp;2)&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;condlog(4,&nbsp;"discard&nbsp;event&nbsp;on&nbsp;%=
s",&nbsp;uev-=EF=BC=9Edevpath);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;true;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&n=
bsp;&nbsp;}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;=
/*&nbsp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;do&nbsp;no=
t&nbsp;filter&nbsp;dm&nbsp;devices&nbsp;by&nbsp;devnode<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;if&nbsp;(!strncmp(uev-=EF=BC=9Ekernel,&nbsp;"dm-",&nbsp;3))<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;false;<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;/*&nbsp;<br>=EF=BC=9E&nbsp;+&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;filter&nbsp;paths&nbsp;devices&nbsp;by&nbsp;d=
evnode<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;conf&nbsp;=3D&nbsp;get=5Fmultipath=5Fconfig();<b=
r>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(filter=5Fdevnode(conf-=
=EF=BC=9Eblist=5Fdevnode,&nbsp;conf-=EF=BC=9Eelist=5Fdevnode,<br>=EF=BC=9E&=
nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;uev-=EF=BC=9Ekernel)&nbsp;=EF=BC=9E&nbsp;0)&nbsp;{<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmulti=
path=5Fconfig(conf);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;return&nbsp;true;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}=
<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmultipath=5Fconfig(conf);=
<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp=
;false;<br>=EF=BC=9E&nbsp;+}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+bool<br=
>=EF=BC=9E&nbsp;+uevent=5Fcan=5Ffilter(struct&nbsp;uevent&nbsp;*earlier,&nb=
sp;struct&nbsp;uevent&nbsp;*later)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&nbsp;+=
<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;*&nbsp;filter&nbsp;earlier&nbsp;uvents&nbsp;if&nbsp;pa=
th&nbsp;has&nbsp;removed&nbsp;later.&nbsp;Eg:<br>=EF=BC=9E&nbsp;+&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;*&nbsp;"add&nbsp;path1&nbsp;|chang&nbsp;path1&nbsp;|add=
&nbsp;path2&nbsp;|remove&nbsp;path1"<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;*&nbsp;can&nbsp;filter&nbsp;as:<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;*&nbsp;"add&nbsp;path2&nbsp;|remove&nbsp;path1"<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;uevents&nbsp;"add&nbsp;path1=
"&nbsp;and&nbsp;"chang&nbsp;path1"&nbsp;are&nbsp;filtered&nbsp;out<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;+&nbsp;&nbs=
p;&nbsp;&nbsp;if&nbsp;(!strcmp(earlier-=EF=BC=9Ekernel,&nbsp;later-=EF=BC=
=9Ekernel)&nbsp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;!strcmp(later-=EF=BC=9Eaction,&nbsp;"remove")&nbsp;&amp;=
&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;st=
rncmp(later-=EF=BC=9Ekernel,&nbsp;"dm-",&nbsp;3))&nbsp;{<br>=EF=BC=9E&nbsp;=
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;true;<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;*&nbsp;filter&nbsp;change&nbsp;uvents&nbsp;if&nbsp;add&nbsp;uevents&nbs=
p;exist.&nbsp;Eg:<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;"=
change&nbsp;path1|&nbsp;add&nbsp;path1&nbsp;|add&nbsp;path2"<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;can&nbsp;filter&nbsp;as:<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;"add&nbsp;path1&nbsp;|add=
&nbsp;path2"<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;uevent=
&nbsp;"chang&nbsp;path1"&nbsp;is&nbsp;filtered&nbsp;out<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;if&nbsp;(!strcmp(earlier-=EF=BC=9Ekernel,&nbsp;later-=EF=BC=9Ekernel)&nbsp=
;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;!strcmp(earlier-=EF=BC=9Eaction,&nbsp;"change")&nbsp;&amp;&amp;<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;!strcmp(later-=
=EF=BC=9Eaction,&nbsp;"add")&nbsp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;strncmp(later-=EF=BC=9Ekernel,&nbsp;"d=
m-",&nbsp;3))&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;return&nbsp;true;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}=
<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp=
;false;<br>=EF=BC=9E&nbsp;+}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+bool<br=
>=EF=BC=9E&nbsp;+merge=5Fneed=5Fstop(struct&nbsp;uevent&nbsp;*earlier,&nbsp=
;struct&nbsp;uevent&nbsp;*later)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&nbsp;+&n=
bsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*=
&nbsp;dm&nbsp;uevent&nbsp;do&nbsp;not&nbsp;try&nbsp;to&nbsp;merge&nbsp;with=
&nbsp;left&nbsp;uevents<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/=
<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(later-=EF=BC=
=9Ekernel,&nbsp;"dm-",&nbsp;3))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;true;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&=
nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;*&nbsp;we&nbsp;can&nbsp;not&nbsp;make&nbsp;a&nbsp;jugement&nbsp;with=
out&nbsp;wwid,<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;so&n=
bsp;it&nbsp;is&nbsp;sensible&nbsp;to&nbsp;stop&nbsp;merging<br>=EF=BC=9E&nb=
sp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&=
nbsp;if&nbsp;(!earlier-=EF=BC=9Ewwid&nbsp;||&nbsp;!later-=EF=BC=9Ewwid)<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp=
;true;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;uevents&nbsp;merging&nbsp;stoped<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;when&nbsp;we&nbsp;meet&nb=
sp;an&nbsp;opposite&nbsp;action&nbsp;uevent&nbsp;from&nbsp;the&nbsp;same&nb=
sp;LUN&nbsp;to&nbsp;AVOID<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
*&nbsp;"add&nbsp;path1&nbsp;|remove&nbsp;path1&nbsp;|add&nbsp;path2&nbsp;|r=
emove&nbsp;path2&nbsp;|add&nbsp;path3"<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;*&nbsp;to&nbsp;merge&nbsp;as&nbsp;"remove&nbsp;path1,&nbsp;pat=
h2"&nbsp;and&nbsp;"add&nbsp;path1,&nbsp;path2,&nbsp;path3"<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;OR<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;*&nbsp;"remove&nbsp;path1&nbsp;|add&nbsp;path1&nbsp;|remov=
e&nbsp;path2&nbsp;|add&nbsp;path2&nbsp;|remove&nbsp;path3"<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;to&nbsp;merge&nbsp;as&nbsp;"add&nbs=
p;path1,&nbsp;path2"&nbsp;and&nbsp;"remove&nbsp;path1,&nbsp;path2,&nbsp;pat=
h3"<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;SO<br>=EF=BC=9E=
&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;when&nbsp;we&nbsp;meet&nbsp;a&n=
bsp;non-change&nbsp;uevent&nbsp;from&nbsp;the&nbsp;same&nbsp;LUN<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;with&nbsp;the&nbsp;same&nbsp=
;wwid&nbsp;and&nbsp;different&nbsp;action<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;*&nbsp;it&nbsp;would&nbsp;be&nbsp;better&nbsp;to&nbsp;stop&=
nbsp;merging.<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!strcmp(earlier-=EF=BC=9Ewwid,&n=
bsp;later-=EF=BC=9Ewwid)&nbsp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;strcmp(earlier-=EF=BC=9Eaction,&nbsp;later=
-=EF=BC=9Eaction)&nbsp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;strcmp(earlier-=EF=BC=9Eaction,&nbsp;"change")&nb=
sp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;strcmp(later-=EF=BC=9Eaction,&nbsp;"change"))<br>=EF=BC=9E&nbsp;+&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;true;<br>=EF=BC=9E&=
nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;false;<br>=EF=
=BC=9E&nbsp;+}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+bool<br>=EF=BC=9E&nbs=
p;+uevent=5Fcan=5Fmerge(struct&nbsp;uevent&nbsp;*earlier,&nbsp;struct&nbsp;=
uevent&nbsp;*later)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nb=
sp;&nbsp;/*&nbsp;merge&nbsp;paths&nbsp;uevents<br>=EF=BC=9E&nbsp;+&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;*&nbsp;whose&nbsp;wwids&nbsp;exsit&nbsp;and&nbsp;are&n=
bsp;same<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;and&nbsp;a=
ctions&nbsp;are&nbsp;same,<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;*&nbsp;and&nbsp;actions&nbsp;are&nbsp;addition&nbsp;or&nbsp;deletion<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;+&nbsp;&=
nbsp;&nbsp;&nbsp;if&nbsp;(earlier-=EF=BC=9Ewwid&nbsp;&amp;&amp;&nbsp;later-=
=EF=BC=9Ewwid&nbsp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;!strcmp(earlier-=EF=BC=9Ewwid,&nbsp;later-=EF=BC=9Eww=
id)&nbsp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;!strcmp(earlier-=EF=BC=9Eaction,&nbsp;later-=EF=BC=9Eaction)&nb=
sp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;strncmp(earlier-=EF=BC=9Eaction,&nbsp;"change",&nbsp;6)&nbsp;&amp;&am=
p;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;strnc=
mp(earlier-=EF=BC=9Ekernel,&nbsp;"dm-",&nbsp;3))&nbsp;{<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;true;<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;false;<br>=EF=BC=9E&nbsp;&nbsp;}<br>=EF=
=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;void<br>=EF=BC=9E&nbsp;-uevq=5Fc=
leanup(struct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&nbsp;+uevent=5Fprep=
are(struct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;*uev,&nbsp;*tmp;<br>=
=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;list=5Ffor=5Fea=
ch=5Fentry=5Freverse=5Fsafe(uev,&nbsp;tmp,&nbsp;tmpq,&nbsp;node)&nbsp;{<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(ue=
vent=5Fcan=5Fdiscard(uev))&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;list=5Fdel=5Finit(&amp;ue=
v-=EF=BC=9Enode);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(uev-=EF=BC=9Eudev)<br>=EF=BC=9E&=
nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;udev=5Fdevice=5Funref(uev-=EF=BC=9Eudev);<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;FREE(uev);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;continue;<br>=EF=BC=9E&nbsp;+&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(strncmp(uev-=
=EF=BC=9Ekernel,&nbsp;"dm-",&nbsp;3)&nbsp;&amp;&amp;<br>=EF=BC=9E&nbsp;+&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uevent=
=5Fneed=5Fmerge())<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uevent=5Fget=5Fwwid(uev);<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+}<br>=EF=BC=9E&nbsp;+<br>=
=EF=BC=9E&nbsp;+void<br>=EF=BC=9E&nbsp;+uevent=5Ffilter(struct&nbsp;uevent&=
nbsp;*later,&nbsp;struct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&nbsp;+{<=
br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;*earlier=
,&nbsp;*tmp;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(earlier,&nbsp;tmp,&nbsp;&amp;la=
ter-=EF=BC=9Enode,&nbsp;tmpq,&nbsp;node)&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;filter&nbsp;unnessary&nbsp;=
earlier&nbsp;uevents&nbsp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;by&nbsp;the&nbsp;later&nbsp;uevent<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(ue=
vent=5Fcan=5Ffilter(earlier,&nbsp;later))&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(2,=
&nbsp;"uevent:&nbsp;%s-%s&nbsp;has&nbsp;filtered&nbsp;by&nbsp;uevent:&nbsp;=
%s-%s",<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;earlier-=EF=BC=9Ekernel,&nb=
sp;earlier-=EF=BC=9Eaction,&nbsp;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;l=
ater-=EF=BC=9Ekernel,&nbsp;later-=EF=BC=9Eaction);<br>=EF=BC=9E&nbsp;+<br>=
=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;list=5Fdel=5Finit(&amp;earlier-=EF=BC=9Enode);<br>=EF=BC=9E&nb=
sp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;if&nbsp;(earlier-=EF=BC=9Eudev)<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ud=
ev=5Fdevice=5Funref(earlier-=EF=BC=9Eudev);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FREE(earlier);<=
br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+}<br>=EF=BC=9E&nb=
sp;+<br>=EF=BC=9E&nbsp;+void<br>=EF=BC=9E&nbsp;+uevent=5Fmerge(struct&nbsp;=
uevent&nbsp;*later,&nbsp;struct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&n=
bsp;+{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;*=
earlier,&nbsp;*tmp;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbs=
p;&nbsp;list=5Ffor=5Fsome=5Fentry=5Freverse=5Fsafe(earlier,&nbsp;tmp,&nbsp;=
&amp;later-=EF=BC=9Enode,&nbsp;tmpq,&nbsp;node)&nbsp;{<br>=EF=BC=9E&nbsp;+&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(merge=5Fneed=5Fstop=
(earlier,&nbsp;later))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br>=EF=BC=9E&nbsp;+&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;merge&nbsp;earlier&nbsp;ueven=
ts&nbsp;to&nbsp;the&nbsp;later&nbsp;uevent<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(uevent=5Fcan=5Fmerge(earlier,&=
nbsp;later))&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(2,&nbsp;"merged&nbsp;uevent:&nb=
sp;%s-%s-%s&nbsp;with&nbsp;uevent:&nbsp;%s-%s-%s",<br>=EF=BC=9E&nbsp;+&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;earlier-=EF=BC=9Eaction,&nbsp;earlier-=EF=BC=9Ekernel,&nbsp=
;earlier-=EF=BC=9Ewwid,<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;later-=EF=
=BC=9Eaction,&nbsp;later-=EF=BC=9Ekernel,&nbsp;later-=EF=BC=9Ewwid);<br>=EF=
=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;list=5Fmove(&amp;earlier-=EF=BC=9Enode,&nbsp;=
&amp;later-=EF=BC=9Emerge=5Fnode);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<b=
r>=EF=BC=9E&nbsp;+}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+void<br>=EF=BC=
=9E&nbsp;+merge=5Fuevq(struct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&nbs=
p;+{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;*la=
ter;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;uevent=
=5Fprepare(tmpq);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;list=5Ffor=5Fe=
ach=5Fentry=5Freverse(later,&nbsp;tmpq,&nbsp;node)&nbsp;{<br>=EF=BC=9E&nbsp=
;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uevent=5Ffilter(later,&nb=
sp;tmpq);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;if(uevent=5Fneed=5Fmerge())<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uevent=5Fmerge(later,&nbsp;tm=
pq);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+}<br>=
=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+void<br>=EF=BC=9E&nbsp;+service=5Fuevq(=
struct&nbsp;list=5Fhead&nbsp;*tmpq)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;*uev,&nbsp;*tmp;=
<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;l=
ist=5Ffor=5Feach=5Fentry=5Fsafe(uev,&nbsp;tmp,&nbsp;tmpq,&nbsp;node)&nbsp;{=
<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;li=
st=5Fdel=5Finit(&amp;uev-=EF=BC=9Enode);<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(my=5Fuev=5Ftr=
igger&nbsp;&amp;&amp;&nbsp;my=5Fuev=5Ftrigger(uev,&nbsp;my=5Ftrigger=5Fdata=
))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;condlog(0,&nbsp;"uevent&nbsp;trigger&nbsp;error");<br>=
=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;uevq=5Fcleanup(&amp;uev-=EF=BC=9Emerge=5Fnode);<br>=EF=BC=9E&nbsp;=
+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbs=
p;(uev-=EF=BC=9Eudev)<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;udev=5Fdevice=5Funref(uev-=EF=BC=9Eud=
ev);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;FREE(uev);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E=
&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;+static&nbsp;void&=
nbsp;uevent=5Fcleanup(void&nbsp;*arg)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;udev&nbsp;*udev&nbsp;=3D&nbsp;arg;<b=
r>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;condlog(3,&nb=
sp;"Releasing&nbsp;uevent=5Flisten()&nbsp;resources");<br>=EF=BC=9E&nbsp;+&=
nbsp;&nbsp;&nbsp;&nbsp;udev=5Funref(udev);<br>=EF=BC=9E&nbsp;+}<br>=EF=BC=
=9E&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;*&nbsp;=
Service&nbsp;the&nbsp;uevent&nbsp;queue.<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;*/<b=
r>=EF=BC=9E&nbsp;@@&nbsp;-142,6&nbsp;+404,7&nbsp;@@&nbsp;int&nbsp;uevent=5F=
dispatch(int&nbsp;(*uev=5Ftrigger)(struct&nbsp;uevent&nbsp;*,&nbsp;void&nbs=
p;*&nbsp;trigger=5Fdata),<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;pthread=5Fmutex=5Funlock(uevq=5Flockp);<br>=EF=BC=9E=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!my=5F=
uev=5Ftrigger)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;merge=5Fuevq(&amp;uevq=5Ftmp);<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;service=5Fue=
vq(&amp;uevq=5Ftmp);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=
=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(3,&nbsp;"Terminating&n=
bsp;uev&nbsp;service&nbsp;queue");<br>=EF=BC=9E&nbsp;@@&nbsp;-442,11&nbsp;+=
705,43&nbsp;@@&nbsp;struct&nbsp;uevent&nbsp;*uevent=5Ffrom=5Fudev=5Fdevice(=
struct&nbsp;udev=5Fdevice&nbsp;*dev)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;return&nbsp;uev;<br>=EF=BC=9E&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbs=
p;<br>=EF=BC=9E&nbsp;+bool&nbsp;uevent=5Fburst(struct&nbsp;timeval&nbsp;*st=
art=5Ftime,&nbsp;int&nbsp;events)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&nbsp;+&=
nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;timeval&nbsp;diff=5Ftime,&nbsp;end=5Ftim=
e;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;unsigned&nbsp;long&nbsp;speed=
;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;unsigned&nbsp;long&nbsp;eclips=
e=5Fms;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if(e=
vents&nbsp;=EF=BC=9E&nbsp;MAX=5FACCUMULATION=5FCOUNT)&nbsp;{<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(2,&nbsp;"burst=
&nbsp;got&nbsp;%u&nbsp;uevents,&nbsp;too&nbsp;much&nbsp;uevents,&nbsp;stopp=
ed",&nbsp;events);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;return&nbsp;false;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<=
br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;gettimeofday=
(&amp;end=5Ftime,&nbsp;NULL);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;ti=
mersub(&amp;end=5Ftime,&nbsp;start=5Ftime,&nbsp;&amp;diff=5Ftime);<br>=EF=
=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;eclipse=5Fms&nbsp;=
=3D&nbsp;diff=5Ftime.tv=5Fsec&nbsp;*&nbsp;1000&nbsp;+&nbsp;diff=5Ftime.tv=
=5Fusec&nbsp;/&nbsp;1000;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbs=
p;&nbsp;&nbsp;if&nbsp;(eclipse=5Fms&nbsp;=3D=3D&nbsp;0)<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;true;<br>=EF=BC=
=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(eclipse=5Fms=
&nbsp;=EF=BC=9E&nbsp;MAX=5FACCUMULATION=5FTIME)&nbsp;{<br>=EF=BC=9E&nbsp;+&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(2,&nbsp;"burst&nbsp;=
continued&nbsp;%lu&nbsp;ms,&nbsp;too&nbsp;long&nbsp;time,&nbsp;stopped",&nb=
sp;eclipse=5Fms);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;return&nbsp;false;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<b=
r>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;speed&nbsp;=
=3D&nbsp;(events&nbsp;*&nbsp;1000)&nbsp;/&nbsp;eclipse=5Fms;<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(speed&nbsp;=EF=BC=9E&nbsp;MIN=5FBURST=
=5FSPEED)<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;return&nbsp;true;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbs=
p;&nbsp;return&nbsp;false;<br>=EF=BC=9E&nbsp;+}<br>=EF=BC=9E&nbsp;+<br>=EF=
=BC=9E&nbsp;&nbsp;int&nbsp;uevent=5Flisten(struct&nbsp;udev&nbsp;*udev)<br>=
=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&=
nbsp;err&nbsp;=3D&nbsp;2;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;s=
truct&nbsp;udev=5Fmonitor&nbsp;*monitor&nbsp;=3D&nbsp;NULL;<br>=EF=BC=9E&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;fd,&nbsp;socket=5Fflags,&nbsp;eve=
nts;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;timeval&nbsp;st=
art=5Ftime;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;need=
=5Ffailback&nbsp;=3D&nbsp;1;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;int&nbsp;timeout&nbsp;=3D&nbsp;30;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;LIST=5FHEAD(uevlisten=5Ftmp);<br>=EF=BC=9E&nbsp;@@&nbsp;-500,6&nb=
sp;+795,7&nbsp;@@&nbsp;int&nbsp;uevent=5Flisten(struct&nbsp;udev&nbsp;*udev=
)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp=
;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;events&nbsp;=3D&nbsp;0;<b=
r>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;gettimeofday(&amp;start=5Ftime,&n=
bsp;NULL);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;while&nbsp;(1)&n=
bsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;struct&nbsp;uevent&nbsp;*uev;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;udev=5Fdevice&nbsp;*dev;<br>=EF=
=BC=9E&nbsp;@@&nbsp;-514,7&nbsp;+810,7&nbsp;@@&nbsp;int&nbsp;uevent=5Fliste=
n(struct&nbsp;udev&nbsp;*udev)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;errno&nbsp;=3D&nbsp;0;<br>=EF=BC=9E&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;fdcount&nbsp;=3D&nbsp;poll(=
&amp;ev=5Fpoll,&nbsp;1,&nbsp;poll=5Ftimeout);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(fdcount&nbsp;&amp;&amp;=
&nbsp;ev=5Fpoll.revents&nbsp;&amp;&nbsp;POLLIN)&nbsp;{<br>=EF=BC=9E&nbsp;-&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;time=
out&nbsp;=3D&nbsp;0;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;timeout&nbsp;=3D&nbsp;uevent=5Fburst(&=
amp;start=5Ftime,&nbsp;events&nbsp;+&nbsp;1)&nbsp;?&nbsp;1&nbsp;:&nbsp;0;<b=
r>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;dev&nbsp;=3D&nbsp;udev=5Fmonitor=5Freceive=5Fdevice(mon=
itor);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!dev)&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;condlog(0,&nbsp;"failed&nbsp;getting&nbsp;udev&nbsp;dev=
ice");<br>=EF=BC=9E&nbsp;@@&nbsp;-547,6&nbsp;+843,7&nbsp;@@&nbsp;int&nbsp;u=
event=5Flisten(struct&nbsp;udev&nbsp;*udev)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pthread=5F=
mutex=5Funlock(uevq=5Flockp);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;events&nbsp;=3D&nbsp;0;<=
br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<b=
r>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;gettimeof=
day(&amp;start=5Ftime,&nbsp;NULL);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;timeout&nbsp;=3D&nbsp;30;<br>=EF=BC=9E&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;need=5Ffailback&nbsp;=3D&nbsp;0;<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nb=
sp;a/libmultipath/uevent.h&nbsp;b/libmultipath/uevent.h<br>=EF=BC=9E&nbsp;i=
ndex&nbsp;9d22dcd..61a4207&nbsp;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/libmult=
ipath/uevent.h<br>=EF=BC=9E&nbsp;+++&nbsp;b/libmultipath/uevent.h<br>=EF=BC=
=9E&nbsp;@@&nbsp;-17,11&nbsp;+17,13&nbsp;@@&nbsp;struct&nbsp;udev;<br>=EF=
=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;struct&nbsp;uevent&nbsp;{<br>=EF=
=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;list=5Fhead&nbsp;node=
;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;list=5Fhead&nbsp;m=
erge=5Fnode;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;ud=
ev=5Fdevice&nbsp;*udev;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cha=
r&nbsp;buffer[HOTPLUG=5FBUFFER=5FSIZE&nbsp;+&nbsp;OBJECT=5FSIZE];<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*devpath;<br>=EF=BC=9E&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*action;<br>=EF=BC=9E&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*kernel;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;char&nbsp;*wwid;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;unsigned&nbsp;long&nbsp;seqnum;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;char&nbsp;*envp[HOTPLUG=5FNUM=5FENVP];<br>=EF=BC=9E&nbsp;&nbsp;};<br>=
=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/libmultipath/util.c&nbsp;b/libmultipa=
th/util.c<br>=EF=BC=9E&nbsp;index&nbsp;03a5738..e5a4a28&nbsp;100644<br>=EF=
=BC=9E&nbsp;---&nbsp;a/libmultipath/util.c<br>=EF=BC=9E&nbsp;+++&nbsp;b/lib=
multipath/util.c<br>=EF=BC=9E&nbsp;@@&nbsp;-261,6&nbsp;+261,46&nbsp;@@&nbsp=
;dev=5Ft&nbsp;parse=5Fdevt(const&nbsp;char&nbsp;*dev=5Ft)<br>=EF=BC=9E&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;makedev(maj,&nbsp;min);<br>=EF=
=BC=9E&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;+char&nbsp;*=
parse=5Fuid=5Fattribute=5Fby=5Fattrs(char&nbsp;*uid=5Fattrs,&nbsp;char&nbsp=
;*path=5Fdev)<br>=EF=BC=9E&nbsp;+{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nb=
sp;char&nbsp;*uid=5Fattribute;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;c=
har&nbsp;*uid=5Fattr=5Frecord;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;c=
har&nbsp;*dev;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*attr;<=
br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;*tmp;<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;&nbsp;count;<br>=EF=BC=9E&nbsp;+<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if(!uid=5Fattrs&nbsp;||&nbsp;!path=5Fd=
ev)<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;retu=
rn&nbsp;NULL;<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbs=
p;count&nbsp;=3D&nbsp;get=5Fword(uid=5Fattrs,&nbsp;&amp;uid=5Fattr=5Frecord=
);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;while&nbsp;(uid=5Fattr=5Freco=
rd)&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;tmp&nbsp;=3D&nbsp;strrchr(uid=5Fattr=5Frecord,&nbsp;':');<br>=EF=BC=9E&n=
bsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!tmp)&nbsp;{<=
br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;free(uid=5Fattr=5Frecord);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!count)=
<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br>=EF=BC=9E&nbsp;+&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;count&nbsp;=
=3D&nbsp;get=5Fword(uid=5Fattrs&nbsp;+&nbsp;count,&nbsp;&amp;uid=5Fattr=5Fr=
ecord);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;continue;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;dev&nbsp;=3D&nbsp;uid=5Fattr=5Frecord;<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;attr&nbsp;=3D&nbsp;tmp&n=
bsp;+&nbsp;1;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;*tmp&nbsp;=3D&nbsp;'\0';<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if(!strncmp(path=5Fdev,&nbsp;dev=
,&nbsp;strlen(dev)))&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uid=5Fattribute&nbsp;=3D&nbsp;S=
TRDUP(attr);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;free(uid=5Fattr=5Frecord);<br>=EF=BC=9E&nbsp;+=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ret=
urn&nbsp;uid=5Fattribute;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;free(uid=5Fattr=5Frecord);<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!count)<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;break;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;count&nbsp;=3D&nbsp;get=5Fword(uid=5Fattrs&nbsp;+&nbsp;count,&nbsp=
;&amp;uid=5Fattr=5Frecord);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;}<br=
>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;NULL;<br>=EF=BC=9E&nbs=
p;+}<br>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;&nbsp;void<br>=EF=BC=9E&nbsp;&nb=
sp;setup=5Fthread=5Fattr(pthread=5Fattr=5Ft&nbsp;*attr,&nbsp;size=5Ft&nbsp;=
stacksize,&nbsp;int&nbsp;detached)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&n=
bsp;diff&nbsp;--git&nbsp;a/libmultipath/util.h&nbsp;b/libmultipath/util.h<b=
r>=EF=BC=9E&nbsp;index&nbsp;f3b37ee..793f2b7&nbsp;100644<br>=EF=BC=9E&nbsp;=
---&nbsp;a/libmultipath/util.h<br>=EF=BC=9E&nbsp;+++&nbsp;b/libmultipath/ut=
il.h<br>=EF=BC=9E&nbsp;@@&nbsp;-12,6&nbsp;+12,7&nbsp;@@&nbsp;size=5Ft&nbsp;=
strlcat(char&nbsp;*dst,&nbsp;const&nbsp;char&nbsp;*src,&nbsp;size=5Ft&nbsp;=
size);<br>=EF=BC=9E&nbsp;&nbsp;int&nbsp;devt2devname&nbsp;(char&nbsp;*,&nbs=
p;int,&nbsp;char&nbsp;*);<br>=EF=BC=9E&nbsp;&nbsp;dev=5Ft&nbsp;parse=5Fdevt=
(const&nbsp;char&nbsp;*dev=5Ft);<br>=EF=BC=9E&nbsp;&nbsp;char&nbsp;*convert=
=5Fdev(char&nbsp;*dev,&nbsp;int&nbsp;is=5Fpath=5Fdevice);<br>=EF=BC=9E&nbsp=
;+char&nbsp;*parse=5Fuid=5Fattribute=5Fby=5Fattrs(char&nbsp;*uid=5Fattrs,&n=
bsp;char&nbsp;*path=5Fdev);<br>=EF=BC=9E&nbsp;&nbsp;void&nbsp;setup=5Fthrea=
d=5Fattr(pthread=5Fattr=5Ft&nbsp;*attr,&nbsp;size=5Ft&nbsp;stacksize,&nbsp;=
int&nbsp;detached);<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;#defin=
e&nbsp;safe=5Fsprintf(var,&nbsp;format,&nbsp;args...)&nbsp;&nbsp;&nbsp;&nbs=
p;\<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/multipath/multipath.conf.5&nbs=
p;b/multipath/multipath.conf.5<br>=EF=BC=9E&nbsp;index&nbsp;36589f5..63c63c=
2&nbsp;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/multipath/multipath.conf.5<br>=
=EF=BC=9E&nbsp;+++&nbsp;b/multipath/multipath.conf.5<br>=EF=BC=9E&nbsp;@@&n=
bsp;-209,6&nbsp;+209,24&nbsp;@@&nbsp;The&nbsp;default&nbsp;is:&nbsp;\fBfail=
over\fR<br>=EF=BC=9E&nbsp;&nbsp;.<br>=EF=BC=9E&nbsp;&nbsp;.<br>=EF=BC=9E&nb=
sp;&nbsp;.TP<br>=EF=BC=9E&nbsp;+.B&nbsp;uid=5Fattrs<br>=EF=BC=9E&nbsp;+The&=
nbsp;udev&nbsp;attribute&nbsp;providing&nbsp;a&nbsp;unique&nbsp;path&nbsp;i=
dentifier&nbsp;for&nbsp;corresponding&nbsp;<br>=EF=BC=9E&nbsp;+type&nbsp;of=
&nbsp;path&nbsp;devices.&nbsp;If&nbsp;this&nbsp;field&nbsp;is&nbsp;configur=
ed&nbsp;and&nbsp;matched&nbsp;with&nbsp;type<br>=EF=BC=9E&nbsp;+of&nbsp;dev=
ice,&nbsp;it&nbsp;would&nbsp;override&nbsp;any&nbsp;other&nbsp;methods&nbsp=
;providing&nbsp;for&nbsp;device<br>=EF=BC=9E&nbsp;+unique&nbsp;identifier&n=
bsp;in&nbsp;config&nbsp;file,&nbsp;and&nbsp;it&nbsp;would&nbsp;activate&nbs=
p;merging&nbsp;uevents<br>=EF=BC=9E&nbsp;+according&nbsp;to&nbsp;the&nbsp;i=
dentifier&nbsp;to&nbsp;promote&nbsp;effiecncy&nbsp;in&nbsp;processing&nbsp;=
uevents.<br>=EF=BC=9E&nbsp;+Tt&nbsp;has&nbsp;no&nbsp;default&nbsp;value,&nb=
sp;if&nbsp;you&nbsp;want&nbsp;to&nbsp;identify&nbsp;path&nbsp;by&nbsp;udev&=
nbsp;attribute<br>=EF=BC=9E&nbsp;+and&nbsp;to&nbsp;activate&nbsp;merging&nb=
sp;uevents&nbsp;for&nbsp;SCSI&nbsp;and&nbsp;DAS&nbsp;device,&nbsp;you&nbsp;=
can&nbsp;set<br>=EF=BC=9E&nbsp;+it's&nbsp;value&nbsp;as:<br>=EF=BC=9E&nbsp;=
+.RS<br>=EF=BC=9E&nbsp;+.TP<br>=EF=BC=9E&nbsp;+\fBuid=5Fattrs&nbsp;"sd:ID=
=5FSERIAL&nbsp;dasd:ID=5FUID"\fR<br>=EF=BC=9E&nbsp;+.TP<br>=EF=BC=9E&nbsp;+=
The&nbsp;default&nbsp;is:&nbsp;\fB=EF=BC=9Cunset=EF=BC=9E\fR<br>=EF=BC=9E&n=
bsp;+.RE<br>=EF=BC=9E&nbsp;+.<br>=EF=BC=9E&nbsp;+.<br>=EF=BC=9E&nbsp;+.TP<b=
r>=EF=BC=9E&nbsp;&nbsp;.B&nbsp;uid=5Fattribute<br>=EF=BC=9E&nbsp;&nbsp;The&=
nbsp;udev&nbsp;attribute&nbsp;providing&nbsp;a&nbsp;unique&nbsp;path&nbsp;i=
dentifier.<br>=EF=BC=9E&nbsp;&nbsp;.RS<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nb=
sp;a/multipathd/cli=5Fhandlers.c&nbsp;b/multipathd/cli=5Fhandlers.c<br>=EF=
=BC=9E&nbsp;index&nbsp;b0eeca6..12f85de&nbsp;100644<br>=EF=BC=9E&nbsp;---&n=
bsp;a/multipathd/cli=5Fhandlers.c<br>=EF=BC=9E&nbsp;+++&nbsp;b/multipathd/c=
li=5Fhandlers.c<br>=EF=BC=9E&nbsp;@@&nbsp;-670,7&nbsp;+670,7&nbsp;@@&nbsp;c=
li=5Fadd=5Fpath&nbsp;(void&nbsp;*&nbsp;v,&nbsp;char&nbsp;**&nbsp;reply,&nbs=
p;int&nbsp;*&nbsp;len,&nbsp;void&nbsp;*&nbsp;data)<br>=EF=BC=9E&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pp-=EF=BC=9Echeckint&nbsp;=
=3D&nbsp;conf-=EF=BC=9Echeckint;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmultipath=5Fc=
onfig(conf);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;ev=5Fad=
d=5Fpath(pp,&nbsp;vecs);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;return&=
nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs,&nbsp;1);<br>=EF=BC=9E&nbsp;&nbsp;blackl=
isted:<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*reply&nbsp;=3D&nbsp=
;strdup("blacklisted\n");<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*=
len&nbsp;=3D&nbsp;strlen(*reply)&nbsp;+&nbsp;1;<br>=EF=BC=9E&nbsp;@@&nbsp;-=
692,7&nbsp;+692,7&nbsp;@@&nbsp;cli=5Fdel=5Fpath&nbsp;(void&nbsp;*&nbsp;v,&n=
bsp;char&nbsp;**&nbsp;reply,&nbsp;int&nbsp;*&nbsp;len,&nbsp;void&nbsp;*&nbs=
p;data)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;condlog(0,&nbsp;"%s:&nbsp;path&nbsp;already&nbsp;removed",&nbsp;param)=
;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;r=
eturn&nbsp;1;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=
=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;ev=5Fremove=5Fpath(pp,&nbsp;v=
ecs);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;ev=5Fremove=5F=
path(pp,&nbsp;vecs,&nbsp;1);<br>=EF=BC=9E&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&n=
bsp;<br>=EF=BC=9E&nbsp;&nbsp;int<br>=EF=BC=9E&nbsp;diff&nbsp;--git&nbsp;a/m=
ultipathd/main.c&nbsp;b/multipathd/main.c<br>=EF=BC=9E&nbsp;index&nbsp;adc3=
258..e513f7d&nbsp;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/multipathd/main.c<br>=
=EF=BC=9E&nbsp;+++&nbsp;b/multipathd/main.c<br>=EF=BC=9E&nbsp;@@&nbsp;-608,=
7&nbsp;+608,7&nbsp;@@&nbsp;ev=5Fremove=5Fmap&nbsp;(char&nbsp;*&nbsp;devname=
,&nbsp;char&nbsp;*&nbsp;alias,&nbsp;int&nbsp;minor,&nbsp;struct&nbsp;vector=
s&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=
=EF=BC=9E&nbsp;&nbsp;static&nbsp;int<br>=EF=BC=9E&nbsp;-uev=5Fadd=5Fpath&nb=
sp;(struct&nbsp;uevent&nbsp;*uev,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs=
)<br>=EF=BC=9E&nbsp;+uev=5Fadd=5Fpath&nbsp;(struct&nbsp;uevent&nbsp;*uev,&n=
bsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs,&nbsp;int&nbsp;need=5Fdo=5Fmap)<br=
>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;str=
uct&nbsp;path&nbsp;*pp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int=
&nbsp;ret&nbsp;=3D&nbsp;0,&nbsp;i;<br>=EF=BC=9E&nbsp;@@&nbsp;-641,7&nbsp;+6=
41,7&nbsp;@@&nbsp;uev=5Fadd=5Fpath&nbsp;(struct&nbsp;uevent&nbsp;*uev,&nbsp=
;struct&nbsp;vectors&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DI=5FALL&nbsp;|&nbsp;DI=5FBLACKLIST)=
;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;put=5Fmultipath=5Fconfig(conf);<br>=EF=BC=9E&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;if&nbsp;(r&nbsp;=3D=3D&nbsp;PATHINFO=5FOK)<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;ret&nbsp;=3D&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs);<br>=EF=BC=9E&nbs=
p;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;ret&nbsp;=3D&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs,&nb=
sp;need=5Fdo=5Fmap);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;else&nbsp;if&nbsp;(r&nbsp;=3D=3D&=
nbsp;PATHINFO=5FSKIPPED)&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;condlog(3,&nbsp;"%s:&nbsp;remove&nbsp;blacklisted&nbsp;path",<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uev-=EF=BC=9Eke=
rnel);<br>=EF=BC=9E&nbsp;@@&nbsp;-665,7&nbsp;+665,7&nbsp;@@&nbsp;uev=5Fadd=
=5Fpath&nbsp;(struct&nbsp;uevent&nbsp;*uev,&nbsp;struct&nbsp;vectors&nbsp;*=
&nbsp;vecs)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=
=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;conf&nbsp;=3D&nbsp;get=5Fmultipat=
h=5Fconfig();<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ret&nbsp;=3D&=
nbsp;alloc=5Fpath=5Fwith=5Fpathinfo(conf,&nbsp;uev-=EF=BC=9Eudev,<br>=EF=BC=
=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DI=
=5FALL,&nbsp;&amp;pp);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;uev-=EF=BC=9Ewwid,&nbsp;DI=5FALL,&nbsp;&amp;p=
p);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmultipath=5Fconfi=
g(conf);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!pp)&nbsp=
;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
if&nbsp;(ret&nbsp;=3D=3D&nbsp;PATHINFO=5FSKIPPED)<br>=EF=BC=9E&nbsp;@@&nbsp=
;-681,7&nbsp;+681,7&nbsp;@@&nbsp;uev=5Fadd=5Fpath&nbsp;(struct&nbsp;uevent&=
nbsp;*uev,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;conf&nbsp;=3D&nbsp;get=
=5Fmultipath=5Fconfig();<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;pp-=EF=BC=9Echeckint&nbsp;=3D&nbsp;conf-=EF=BC=9Echec=
kint;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;put=5Fmultipath=5Fconfig(conf);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;ret&nbsp;=3D&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs)=
;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ret&nb=
sp;=3D&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs,&nbsp;need=5Fdo=5Fmap);<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;else&nbsp;{<br>=EF=BC=9E&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(0,&nbsp;"%s:=
&nbsp;failed&nbsp;to&nbsp;store&nbsp;path&nbsp;info,&nbsp;"<br>=EF=BC=9E&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;"dropping&nbsp;event",<br>=EF=BC=9E&nbsp;@@&nbsp;-699,7&nbsp;+699,7&n=
bsp;@@&nbsp;uev=5Fadd=5Fpath&nbsp;(struct&nbsp;uevent&nbsp;*uev,&nbsp;struc=
t&nbsp;vectors&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;*&nbsp;1:&nb=
sp;error<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;&nbsp;int<br>=
=EF=BC=9E&nbsp;-ev=5Fadd=5Fpath&nbsp;(struct&nbsp;path&nbsp;*&nbsp;pp,&nbsp=
;struct&nbsp;vectors&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;+ev=5Fadd=5Fpath&n=
bsp;(struct&nbsp;path&nbsp;*&nbsp;pp,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;=
vecs,&nbsp;int&nbsp;need=5Fdo=5Fmap)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;multipath&nbsp;*&nbsp;mpp;<=
br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;params[PARAMS=5FS=
IZE]&nbsp;=3D&nbsp;{0};<br>=EF=BC=9E&nbsp;@@&nbsp;-767,6&nbsp;+767,13&nbsp;=
@@&nbsp;rescan:<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*&nbsp;per=
sistent&nbsp;reservation&nbsp;check*/<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;mpath=5Fpr=5Fevent=5Fhandle(pp);<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=
=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!need=5Fdo=5Fmap)<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;0;<br=
>=EF=BC=9E&nbsp;+<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!dm=
=5Fmap=5Fpresent(mpp-=EF=BC=9Ealias))&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mpp-=EF=BC=9Eaction&nbsp;=3D&nbsp;ACT=
=5FCREATE;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;start=5Fwaiter&nbsp;=3D&nbsp;1;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nb=
sp;}<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;push&nbsp;the&nbsp;map&nbsp;to&nb=
sp;the&nbsp;device-mapper<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;*/<br>=EF=BC=9E&nbsp;@@&nbsp;-833,7&nbsp;+840,7&nbsp;@@&nbsp;fail:<br>=
=EF=BC=9E&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;sta=
tic&nbsp;int<br>=EF=BC=9E&nbsp;-uev=5Fremove=5Fpath&nbsp;(struct&nbsp;ueven=
t&nbsp;*uev,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;+=
uev=5Fremove=5Fpath&nbsp;(struct&nbsp;uevent&nbsp;*uev,&nbsp;struct&nbsp;ve=
ctors&nbsp;*&nbsp;vecs,&nbsp;int&nbsp;need=5Fdo=5Fmap)<br>=EF=BC=9E&nbsp;&n=
bsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;path&nbsp=
;*pp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;ret;<br>=EF=
=BC=9E&nbsp;@@&nbsp;-844,7&nbsp;+851,7&nbsp;@@&nbsp;uev=5Fremove=5Fpath&nbs=
p;(struct&nbsp;uevent&nbsp;*uev,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs)=
<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pthread=5Ftestcancel();<br=
>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pp&nbsp;=3D&nbsp;find=5Fpath=
=5Fby=5Fdev(vecs-=EF=BC=9Epathvec,&nbsp;uev-=EF=BC=9Ekernel);<br>=EF=BC=9E&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(pp)<br>=EF=BC=9E&nbsp;-&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ret&nbsp;=3D&nbsp;ev=5Fremove=5Fpat=
h(pp,&nbsp;vecs);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;ret&nbsp;=3D&nbsp;ev=5Fremove=5Fpath(pp,&nbsp;vecs,&nbsp;need=5Fd=
o=5Fmap);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;lock=5Fcleanup=5F=
pop(vecs-=EF=BC=9Elock);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if=
&nbsp;(!pp)&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;/*&nbsp;Not&nbsp;an&nbsp;error;&nbsp;path&nbsp;might&nbsp;h=
ave&nbsp;been&nbsp;purged&nbsp;earlier&nbsp;*/<br>=EF=BC=9E&nbsp;@@&nbsp;-8=
55,7&nbsp;+862,7&nbsp;@@&nbsp;uev=5Fremove=5Fpath&nbsp;(struct&nbsp;uevent&=
nbsp;*uev,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;&nb=
sp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;int<br>=EF=BC=9E&nbsp=
;-ev=5Fremove=5Fpath&nbsp;(struct&nbsp;path&nbsp;*pp,&nbsp;struct&nbsp;vect=
ors&nbsp;*&nbsp;vecs)<br>=EF=BC=9E&nbsp;+ev=5Fremove=5Fpath&nbsp;(struct&nb=
sp;path&nbsp;*pp,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs,&nbsp;int&nbsp;=
need=5Fdo=5Fmap)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;struct&nbsp;multipath&nbsp;*&nbsp;mpp;<br>=EF=BC=9E&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;i,&nbsp;retval&nbsp;=3D&nbsp;0;<br>=EF=
=BC=9E&nbsp;@@&nbsp;-918,6&nbsp;+925,8&nbsp;@@&nbsp;ev=5Fremove=5Fpath&nbsp=
;(struct&nbsp;path&nbsp;*pp,&nbsp;struct&nbsp;vectors&nbsp;*&nbsp;vecs)<br>=
=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;goto&nbsp;out;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;=
+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!need=5Fdo=5Fmap)=
<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;goto&nbsp;out;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;reload&nbsp;the&nbsp;map<br>=EF=
=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<=
br>=EF=BC=9E&nbsp;@@&nbsp;-995,7&nbsp;+1004,7&nbsp;@@&nbsp;uev=5Fupdate=5Fp=
ath&nbsp;(struct&nbsp;uevent&nbsp;*uev,&nbsp;struct&nbsp;vectors&nbsp;*&nbs=
p;vecs)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(pp-=EF=BC=9Einitialized&nbsp;=3D=3D&n=
bsp;INIT=5FREQUESTED=5FUDEV)<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;retval&nbsp;=3D&nbsp;uev=5Fadd=
=5Fpath(uev,&nbsp;vecs);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;retval&nbsp;=3D&nbsp;uev=5Fadd=5Fp=
ath(uev,&nbsp;vecs,&nbsp;1);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;else&nbsp;if&nbsp;(mpp&nbsp;&amp;&amp;&nbsp;ro&nb=
sp;=EF=BC=9E=3D&nbsp;0)&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(2,&nbsp;"%s:&nb=
sp;update&nbsp;path&nbsp;write=5Fprotect&nbsp;to&nbsp;'%d'&nbsp;(uevent)",&=
nbsp;uev-=EF=BC=9Ekernel,&nbsp;ro);<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&n=
bsp;@@&nbsp;-1016,7&nbsp;+1025,7&nbsp;@@&nbsp;out:<br>=EF=BC=9E&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int=
&nbsp;flag&nbsp;=3D&nbsp;DI=5FSYSFS&nbsp;|&nbsp;DI=5FWWID;<br>=EF=BC=9E&nbs=
p;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;conf&nbsp;=3D&nbsp;get=5Fmultipath=5Fconfig()=
;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;retval&nbsp;=3D&nbsp;alloc=5Fpath=5Fwith=5Fpathinfo(conf,=
&nbsp;uev-=EF=BC=9Eudev,&nbsp;flag,&nbsp;NULL);<br>=EF=BC=9E&nbsp;+&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;retval&nbsp=
;=3D&nbsp;alloc=5Fpath=5Fwith=5Fpathinfo(conf,&nbsp;uev-=EF=BC=9Eudev,&nbsp=
;uev-=EF=BC=9Ewwid,&nbsp;flag,&nbsp;NULL);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmulti=
path=5Fconfig(conf);<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;=
(retval&nbsp;=3D=3D&nbsp;PATHINFO=5FSKIPPED)&nbsp;{<br>=EF=BC=9E&nbsp;@@&nb=
sp;-1077,40&nbsp;+1086,15&nbsp;@@&nbsp;uxsock=5Ftrigger&nbsp;(char&nbsp;*&n=
bsp;str,&nbsp;char&nbsp;**&nbsp;reply,&nbsp;int&nbsp;*&nbsp;len,&nbsp;void&=
nbsp;*&nbsp;trigger=5Fdata)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;return&nbsp;r;<br>=EF=BC=9E&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=
=BC=9E&nbsp;-static&nbsp;int<br>=EF=BC=9E&nbsp;-uev=5Fdiscard(char&nbsp;*&n=
bsp;devpath)<br>=EF=BC=9E&nbsp;-{<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbs=
p;char&nbsp;*tmp;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;char&nbsp;a[11=
],&nbsp;b[11];<br>=EF=BC=9E&nbsp;-<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nb=
sp;/*<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;keep&nbsp;onl=
y&nbsp;block&nbsp;devices,&nbsp;discard&nbsp;partitions<br>=EF=BC=9E&nbsp;-=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp=
;tmp&nbsp;=3D&nbsp;strstr(devpath,&nbsp;"/block/");<br>=EF=BC=9E&nbsp;-&nbs=
p;&nbsp;&nbsp;&nbsp;if&nbsp;(tmp&nbsp;=3D=3D&nbsp;NULL){<br>=EF=BC=9E&nbsp;=
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(4,&nbsp;"no&nbsp;/=
block/&nbsp;in&nbsp;'%s'",&nbsp;devpath);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;1;<br>=EF=BC=9E&nbsp;-&nbsp;&=
nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(ssca=
nf(tmp,&nbsp;"/block/%10s",&nbsp;a)&nbsp;!=3D&nbsp;1&nbsp;||<br>=EF=BC=9E&n=
bsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sscanf(tmp,&nbsp;"/blo=
ck/%10[^/]/%10s",&nbsp;a,&nbsp;b)&nbsp;=3D=3D&nbsp;2)&nbsp;{<br>=EF=BC=9E&n=
bsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(4,&nbsp;"disca=
rd&nbsp;event&nbsp;on&nbsp;%s",&nbsp;devpath);<br>=EF=BC=9E&nbsp;-&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;1;<br>=EF=BC=9E&nbsp;-&n=
bsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;return&n=
bsp;0;<br>=EF=BC=9E&nbsp;-}<br>=EF=BC=9E&nbsp;-<br>=EF=BC=9E&nbsp;&nbsp;int=
<br>=EF=BC=9E&nbsp;&nbsp;uev=5Ftrigger&nbsp;(struct&nbsp;uevent&nbsp;*&nbsp=
;uev,&nbsp;void&nbsp;*&nbsp;trigger=5Fdata)<br>=EF=BC=9E&nbsp;&nbsp;{<br>=
=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int&nbsp;r&nbsp;=3D&nbsp;0;<br=
>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;vectors&nbsp;*&nb=
sp;vecs;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;config&nbsp=
;*conf;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;struct&nbsp;uevent&nbsp;=
*merge=5Fuev,&nbsp;*tmp;<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;vecs&nbsp;=3D&nbsp;(struct&nbsp;vectors&nbsp;*)trigg=
er=5Fdata;<br>=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&n=
bsp;if&nbsp;(uev=5Fdiscard(uev-=EF=BC=9Edevpath))<br>=EF=BC=9E&nbsp;-&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;0;<br>=EF=BC=9E&nbsp;=
-<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pthread=5Fcleanup=5Fpush(=
config=5Fcleanup,&nbsp;NULL);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;pthread=5Fmutex=5Flock(&amp;config=5Flock);<br>=EF=BC=9E&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;if&nbsp;(running=5Fstate&nbsp;!=3D&nbsp;DAEMON=5FIDLE&n=
bsp;&amp;&amp;<br>=EF=BC=9E&nbsp;@@&nbsp;-1139,28&nbsp;+1123,21&nbsp;@@&nbs=
p;uev=5Ftrigger&nbsp;(struct&nbsp;uevent&nbsp;*&nbsp;uev,&nbsp;void&nbsp;*&=
nbsp;trigger=5Fdata)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=
=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br=
>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;path&nbsp;add/remove&=
nbsp;event<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*&nbsp;path&nbs=
p;add/remove/change&nbsp;event,&nbsp;add/remove&nbsp;maybe&nbsp;merged<br>=
=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>=EF=BC=9E&nbsp;-&n=
bsp;&nbsp;&nbsp;&nbsp;conf&nbsp;=3D&nbsp;get=5Fmultipath=5Fconfig();<br>=EF=
=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(filter=5Fdevnode(conf-=EF=BC=
=9Eblist=5Fdevnode,&nbsp;conf-=EF=BC=9Eelist=5Fdevnode,<br>=EF=BC=9E&nbsp;-=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;uev-=EF=BC=9Ekernel)&nbsp;=EF=BC=9E&nbsp;0)&nbsp;{<br>=EF=BC=
=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmultipath=
=5Fconfig(conf);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;goto&nbsp;out;<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;list=5Ff=
or=5Feach=5Fentry=5Fsafe(merge=5Fuev,&nbsp;tmp,&nbsp;&amp;uev-=EF=BC=9Emerg=
e=5Fnode,&nbsp;node)&nbsp;{<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(merge=5Fuev-=EF=BC=9Eaction,&nbsp;"ad=
d",&nbsp;3))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;r&nbsp;+=3D&nbsp;uev=5Fadd=5Fpath(merge=5Fuev,=
&nbsp;vecs,&nbsp;0);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;if&nbsp;(!strncmp(merge=5Fuev-=EF=BC=9Eaction,&nbsp;"remove",&=
nbsp;6))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;r&nbsp;+=3D&nbsp;uev=5Fremove=5Fpath(merge=5Fuev,&=
nbsp;vecs,&nbsp;0);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=
=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;put=5Fmultipath=5Fconfig(conf);<br>=
=EF=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!=
strncmp(uev-=EF=BC=9Eaction,&nbsp;"add",&nbsp;3))&nbsp;{<br>=EF=BC=9E&nbsp;=
-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;r&nbsp;=3D&nbsp;uev=5Fadd=
=5Fpath(uev,&nbsp;vecs);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;goto&nbsp;out;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;=
}<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(uev-=EF=BC=
=9Eaction,&nbsp;"remove",&nbsp;6))&nbsp;{<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;r&nbsp;=3D&nbsp;uev=5Fremove=5Fpath(uev,&=
nbsp;vecs);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;goto&nbsp;out;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=
=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(uev-=EF=BC=9Eaction,&nb=
sp;"change",&nbsp;6))&nbsp;{<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;r&nbsp;=3D&nbsp;uev=5Fupdate=5Fpath(uev,&nbsp;vecs);<b=
r>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;goto&nbsp=
;out;<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;+&nbsp=
;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(uev-=EF=BC=9Eaction,&nbsp;"add",&nbsp;=
3))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;r&nb=
sp;+=3D&nbsp;uev=5Fadd=5Fpath(uev,&nbsp;vecs,&nbsp;1);<br>=EF=BC=9E&nbsp;+&=
nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(uev-=EF=BC=9Eaction,&nbsp;"remove"=
,&nbsp;6))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;r&nbsp;+=3D&nbsp;uev=5Fremove=5Fpath(uev,&nbsp;vecs,&nbsp;1);<br>=EF=BC=
=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!strncmp(uev-=EF=BC=9Eaction,&nb=
sp;"change",&nbsp;6))<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;r&nbsp;+=3D&nbsp;uev=5Fupdate=5Fpath(uev,&nbsp;vecs);<br>=EF=
=BC=9E&nbsp;&nbsp;<br>=EF=BC=9E&nbsp;&nbsp;out:<br>=EF=BC=9E&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;return&nbsp;r;<br>=EF=BC=9E&nbsp;@@&nbsp;-1570,7&nbsp;=
+1547,7&nbsp;@@&nbsp;check=5Fpath&nbsp;(struct&nbsp;vectors&nbsp;*&nbsp;vec=
s,&nbsp;struct&nbsp;path&nbsp;*&nbsp;pp,&nbsp;int&nbsp;ticks)<br>=EF=BC=9E&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;conf&nbsp;=3D&nbsp;get=5Fmultipath=5Fconfig();<br>=EF=BC=9E&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;ret&nbsp;=3D&nbsp;pathinfo(pp,&nbsp;conf,&nbsp;DI=5FALL&nbsp;|&nbsp;DI=5FB=
LACKLIST);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(ret&nbsp;=3D=3D&nbsp;PATHINFO=5FOK=
)&nbsp;{<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;v=
ecs);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs=
,&nbsp;1);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pp-=EF=BC=9Etick&nb=
sp;=3D&nbsp;1;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}&nbsp;else&nbsp;if&nbsp;(ret&nbsp;=3D=
=3D&nbsp;PATHINFO=5FSKIPPED)&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;put=5Fmultipath=5Fconfig(conf);<br>=EF=BC=9E&nbsp;@@&nbsp;-1686,7&nbs=
p;+1663,7&nbsp;@@&nbsp;check=5Fpath&nbsp;(struct&nbsp;vectors&nbsp;*&nbsp;v=
ecs,&nbsp;struct&nbsp;path&nbsp;*&nbsp;pp,&nbsp;int&nbsp;ticks)<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=
=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(!di=
sable=5Freinstate&nbsp;&amp;&amp;&nbsp;reinstate=5Fpath(pp,&nbsp;add=5Facti=
ve))&nbsp;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(3,&nbsp;"%s:&nbsp;reload&nbsp;map"=
,&nbsp;pp-=EF=BC=9Edev);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs);<br=
>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs,&nbsp;1);<br>=EF=BC=9E&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
pp-=EF=BC=9Etick&nbsp;=3D&nbsp;1;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;return&nbsp;0;<br>=
=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=
=EF=BC=9E&nbsp;@@&nbsp;-1709,7&nbsp;+1686,7&nbsp;@@&nbsp;check=5Fpath&nbsp;=
(struct&nbsp;vectors&nbsp;*&nbsp;vecs,&nbsp;struct&nbsp;path&nbsp;*&nbsp;pp=
,&nbsp;int&nbsp;ticks)<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*&nbsp;Clear&nbsp;IO&nbsp;erro=
rs&nbsp;*/<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if&nbsp;(reinstate=5Fpath(pp,&nbsp;0))&nbsp=
;{<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;condlog(3,&nbsp;"%s:&nbsp;r=
eload&nbsp;map",&nbsp;pp-=EF=BC=9Edev);<br>=EF=BC=9E&nbsp;-&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;ev=5Fadd=5Fpath(pp,&nbsp;vecs);<br>=EF=BC=9E&nbsp;+&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;ev=5Fadd=5Fpath(pp,&nbsp;vecs,&nbsp;1);<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;pp-=EF=BC=9Etick&nbsp;=3D&nbsp;1;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;return&nbsp;0;<br>=EF=BC=9E&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>=EF=BC=9E&nbsp;dif=
f&nbsp;--git&nbsp;a/multipathd/main.h&nbsp;b/multipathd/main.h<br>=EF=BC=9E=
&nbsp;index&nbsp;f72580d..094b04f&nbsp;100644<br>=EF=BC=9E&nbsp;---&nbsp;a/=
multipathd/main.h<br>=EF=BC=9E&nbsp;+++&nbsp;b/multipathd/main.h<br>=EF=BC=
=9E&nbsp;@@&nbsp;-22,8&nbsp;+22,8&nbsp;@@&nbsp;void&nbsp;exit=5Fdaemon(void=
);<br>=EF=BC=9E&nbsp;&nbsp;const&nbsp;char&nbsp;*&nbsp;daemon=5Fstatus(void=
);<br>=EF=BC=9E&nbsp;&nbsp;int&nbsp;need=5Fto=5Fdelay=5Freconfig&nbsp;(stru=
ct&nbsp;vectors&nbsp;*);<br>=EF=BC=9E&nbsp;&nbsp;int&nbsp;reconfigure&nbsp;=
(struct&nbsp;vectors&nbsp;*);<br>=EF=BC=9E&nbsp;-int&nbsp;ev=5Fadd=5Fpath&n=
bsp;(struct&nbsp;path&nbsp;*,&nbsp;struct&nbsp;vectors&nbsp;*);<br>=EF=BC=
=9E&nbsp;-int&nbsp;ev=5Fremove=5Fpath&nbsp;(struct&nbsp;path&nbsp;*,&nbsp;s=
truct&nbsp;vectors&nbsp;*);<br>=EF=BC=9E&nbsp;+int&nbsp;ev=5Fadd=5Fpath&nbs=
p;(struct&nbsp;path&nbsp;*,&nbsp;struct&nbsp;vectors&nbsp;*,&nbsp;int);<br>=
=EF=BC=9E&nbsp;+int&nbsp;ev=5Fremove=5Fpath&nbsp;(struct&nbsp;path&nbsp;*,&=
nbsp;struct&nbsp;vectors&nbsp;*,&nbsp;int);<br>=EF=BC=9E&nbsp;&nbsp;int&nbs=
p;ev=5Fadd=5Fmap&nbsp;(char&nbsp;*,&nbsp;char&nbsp;*,&nbsp;struct&nbsp;vect=
ors&nbsp;*);<br>=EF=BC=9E&nbsp;&nbsp;int&nbsp;ev=5Fremove=5Fmap&nbsp;(char&=
nbsp;*,&nbsp;char&nbsp;*,&nbsp;int,&nbsp;struct&nbsp;vectors&nbsp;*);<br>=
=EF=BC=9E&nbsp;&nbsp;void&nbsp;sync=5Fmap=5Fstate&nbsp;(struct&nbsp;multipa=
th&nbsp;*);<br>=EF=BC=9E&nbsp;--&nbsp;<br>=EF=BC=9E&nbsp;2.8.1.windows.1<br=
>=EF=BC=9E&nbsp;<br><br>--<br>dm-devel&nbsp;mailing&nbsp;list<br>dm-devel@r=
edhat.com<br>https://www.redhat.com/mailman/listinfo/dm-devel<br></div><p><=
br></p></div></div></div></div><p><br></p> </div>

--=====_003_next=====--

--=====_002_next=====--

--=====_001_next=====
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=====_001_next=====--
