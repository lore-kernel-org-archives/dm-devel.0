From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: arrange compilation options
	for binaries
Date: Thu, 23 Mar 2017 15:55:07 +0100
Message-ID: <CABr-GneY28F_bP=dpsQEAWZAreoT3dBzJcz5Pik2ZHHbk9F_rA@mail.gmail.com>
References: <20170317224002.8967-1-xose.vazquez@gmail.com>
	<CABr-GndoZc+maRDaerfgUupPw4TeSgzf+aF9gZh0VNtKsjfQCA@mail.gmail.com>
	<CABr-GnfmGzcnW0GcqMLWs0Zg30Txw0k+3Er6zyrRpRrmcN-gwQ@mail.gmail.com>
	<20d24d9d-566f-cd2b-8f45-86167ffdd0df@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3990387388183174716=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20d24d9d-566f-cd2b-8f45-86167ffdd0df@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3990387388183174716==
Content-Type: multipart/alternative; boundary=001a113e17401fe471054b67107e

--001a113e17401fe471054b67107e
Content-Type: text/plain; charset=UTF-8

Yes indeed, the build really failed on my box.

Toolchain versions :
* gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.2)
* GNU ld (GNU Binutils for Ubuntu) 2.26.1

make log :

cc -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int
-Werror=implicit-function-declaration -Werror=format-security
-Wno-sign-compare -Wno-unused-parameter -Wno-clobbered
-Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong --param=ssp-buffer-size=4
-fPIC -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -I../libmultipath
-I../libmpathcmd  -lpthread -ldevmapper -ldl -L../libmultipath -lmultipath
-ludev -L../libmpathcmd -lmpathcmd main.o -o multipath
main.o: In function `get_dm_mpvec':
/home/cvaroqui/multipath-tools/multipath/main.c:209: undefined reference to
`dm_get_maps'
/home/cvaroqui/multipath-tools/multipath/main.c:228: undefined reference to
`dm_get_map'
/home/cvaroqui/multipath-tools/multipath/main.c:229: undefined reference to
`dlog'
/home/cvaroqui/multipath-tools/multipath/main.c:230: undefined reference to
`dm_get_status'
/home/cvaroqui/multipath-tools/multipath/main.c:231: undefined reference to
`dlog'
/home/cvaroqui/multipath-tools/multipath/main.c:233: undefined reference to
`disassemble_map'
...
<snip: many more reference errors>
...
collect2: error: ld returned 1 exit status
Makefile:18: recipe for target 'multipath' failed
make[1]: *** [multipath] Error 1
make[1]: Leaving directory '/home/cvaroqui/multipath-tools/multipath'
Makefile:46: recipe for target 'recurse' failed
make: *** [recurse] Error 2


On Thu, Mar 23, 2017 at 3:02 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 03/23/2017 10:09 AM, Christophe Varoqui wrote:
>
> > And reverted:
> > hh
> > From http://eli.thegreenplace.net/2013/07/09/library-order-in-
> static-linking:
> >
> >     If object or library AA needs a symbol from library BB, then AA
> should
> >     come /before/ library BB in the command-line invocation of the
> linker.
>
> Did you get a toolchain error?
>

--001a113e17401fe471054b67107e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Yes indeed, the build really failed on my box.<div><br><di=
v>Toolchain versions :</div><div><div>* gcc version 5.4.0 20160609 (Ubuntu =
5.4.0-6ubuntu1~16.04.2)=C2=A0</div></div><div><div>* GNU ld (GNU Binutils f=
or Ubuntu) 2.26.1</div></div><div><br></div></div><div>make log :</div><div=
><br></div><div><div>cc -O2 -g -pipe -Wall -Wextra -Wformat=3D2 -Werror=3Di=
mplicit-int -Werror=3Dimplicit-function-declaration -Werror=3Dformat-securi=
ty -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wp,-D_FORTIFY_SO=
URCE=3D2 -fstack-protector-strong --param=3Dssp-buffer-size=3D4 -fPIC -DLIB=
_STRING=3D\&quot;lib64\&quot; -DRUN_DIR=3D\&quot;run\&quot; -I../libmultipa=
th -I../libmpathcmd =C2=A0-lpthread -ldevmapper -ldl -L../libmultipath -lmu=
ltipath -ludev -L../libmpathcmd -lmpathcmd main.o -o multipath</div><div>ma=
in.o: In function `get_dm_mpvec&#39;:</div><div>/home/cvaroqui/multipath-to=
ols/multipath/main.c:209: undefined reference to `dm_get_maps&#39;</div><di=
v>/home/cvaroqui/multipath-tools/multipath/main.c:228: undefined reference =
to `dm_get_map&#39;</div><div>/home/cvaroqui/multipath-tools/multipath/main=
.c:229: undefined reference to `dlog&#39;</div><div>/home/cvaroqui/multipat=
h-tools/multipath/main.c:230: undefined reference to `dm_get_status&#39;</d=
iv><div>/home/cvaroqui/multipath-tools/multipath/main.c:231: undefined refe=
rence to `dlog&#39;</div><div>/home/cvaroqui/multipath-tools/multipath/main=
.c:233: undefined reference to `disassemble_map&#39;</div><div>...</div><di=
v>&lt;snip: many more reference errors&gt;</div><div>...</div><div>collect2=
: error: ld returned 1 exit status<br></div><div>Makefile:18: recipe for ta=
rget &#39;multipath&#39; failed</div><div>make[1]: *** [multipath] Error 1<=
/div><div>make[1]: Leaving directory &#39;/home/cvaroqui/multipath-tools/mu=
ltipath&#39;</div><div>Makefile:46: recipe for target &#39;recurse&#39; fai=
led</div><div>make: *** [recurse] Error 2</div></div><div><br></div></div><=
div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Mar 23, 20=
17 at 3:02 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:x=
ose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</sp=
an> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;=
border-left:1px #ccc solid;padding-left:1ex">On 03/23/2017 10:09 AM, Christ=
ophe Varoqui wrote:<br>
<br>
&gt; And reverted:<br>
&gt; hh<br>
<span class=3D"">&gt; From <a href=3D"http://eli.thegreenplace.net/2013/07/=
09/library-order-in-static-linking" rel=3D"noreferrer" target=3D"_blank">ht=
tp://eli.thegreenplace.net/<wbr>2013/07/09/library-order-in-<wbr>static-lin=
king</a>:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0If object or library AA needs a symbol from library=
 BB, then AA should<br>
</span>&gt;=C2=A0 =C2=A0 =C2=A0come /before/ library BB in the command-line=
 invocation of the linker.<br>
<br>
Did you get a toolchain error?<br>
</blockquote></div><br></div>

--001a113e17401fe471054b67107e--


--===============3990387388183174716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3990387388183174716==--
