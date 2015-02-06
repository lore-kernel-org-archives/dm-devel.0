From: Zhichao Cao <caozhichao91@gmail.com>
Subject: dm-dedup can not make module
Date: Fri, 6 Feb 2015 16:51:48 -0600
Message-ID: <CAOhDoTEumgSehwa-NtrjwZjW7yOWPwXNEoqK1BPFY6Qe9XSkLw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7715423299268842786=="
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

--===============7715423299268842786==
Content-Type: multipart/alternative; boundary=047d7b6226e6fcf593050e734330

--047d7b6226e6fcf593050e734330
Content-Type: text/plain; charset=UTF-8

Hi Mike,

I'm a UMN CS student and just the beginer. I'm working on primary dedup
project and read the dm-dedup paper, which might be very useful for me, so
I want to try and learn it.

However, when I tried to make dm-dedup as a module and insmod it, it always
failed.

make -C /lib/modules/`uname -r`/build M=/root/Downloads/md
make[1]: Entering directory `/usr/src/linux-3.18.5'
  Building modules, stage 2.
  MODPOST 0 modules
make[1]: Leaving directory `/usr/src/linux-3.18.5'

No module was built after make, and my Makefile is:

dm-dedup-y += dm-dedup-target.o dm-dedup-hash.o dm-dedup-rw.o
dm-dedup-cbt.o dm-dedup-ram.o

obj-$(CONFIG_DM_DEDUP) += dm-dedup.o

ifeq ($(CONFIG_DM_UEVENT),y)
dm-mod-objs += dm-uevent.o
endif

all:
make -C /lib/modules/`uname -r`/build M=$(PWD)
clean:
make -C /lib/modules/`uname -r`/build M=$(PWD) clean
install:
install -m 755 *.ko /lib/modules/`uname -r`/kernel/drivers/md/

The dm-dedup source files are pulled from git://
git.fsl.cs.stonybrook.edu/linux-dmdedup.git
branch dm-dedup-devel

Can you help me and give me some advises?

Thanks a lot!


Zhichao

--047d7b6226e6fcf593050e734330
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><font size=3D"4">Hi Mike,</font><div style=3D"font-size:13=
px"><font size=3D"4"><br></font></div><div style=3D"font-size:13px"><font s=
ize=3D"4">I&#39;m a UMN CS student and just the beginer. I&#39;m working on=
 primary dedup project and read the dm-dedup paper, which might be very use=
ful for me, so I want to try and learn it.=C2=A0</font></div><div style=3D"=
font-size:13px"><font size=3D"4"><br></font></div><div style=3D"font-size:1=
3px"><font size=3D"4">However, when I tried to make dm-dedup as a module an=
d insmod it, it always failed.</font></div><div style=3D"font-size:13px"><b=
r></div><div style=3D"font-size:13px"><div>make -C /lib/modules/`uname -r`/=
build M=3D/root/Downloads/md</div><div>make[1]: Entering directory `/usr/sr=
c/linux-3.18.5&#39;</div><div>=C2=A0 Building modules, stage 2.</div><div>=
=C2=A0 MODPOST 0 modules</div><div>make[1]: Leaving directory `/usr/src/lin=
ux-3.18.5&#39;</div></div><div style=3D"font-size:13px"><br></div><div styl=
e=3D"font-size:13px"><font size=3D"4">No module was built after make, and m=
y Makefile is:</font></div><div style=3D"font-size:13px"><br></div><div sty=
le=3D"font-size:13px"><div>dm-dedup-y<span style=3D"white-space:pre-wrap">	=
</span>+=3D dm-dedup-target.o dm-dedup-hash.o dm-dedup-rw.o dm-dedup-cbt.o =
dm-dedup-ram.o</div><div><br></div><div>obj-$(CONFIG_DM_DEDUP)<span style=
=3D"white-space:pre-wrap">		</span>+=3D dm-dedup.o</div><div><br></div><div=
>ifeq ($(CONFIG_DM_UEVENT),y)</div><div>dm-mod-objs<span style=3D"white-spa=
ce:pre-wrap">			</span>+=3D dm-uevent.o</div><div>endif</div><div><br></div=
><div>all:</div><div><span style=3D"white-space:pre-wrap">	</span>make -C /=
lib/modules/`uname -r`/build M=3D$(PWD)</div><div>clean:</div><div><span st=
yle=3D"white-space:pre-wrap">	</span>make -C /lib/modules/`uname -r`/build =
M=3D$(PWD) clean</div><div>install:</div><div><span style=3D"white-space:pr=
e-wrap">	</span>install -m 755 *.ko /lib/modules/`uname -r`/kernel/drivers/=
md/</div></div><div style=3D"font-size:13px"><br></div><div><font size=3D"4=
">The dm-dedup source files are pulled from=C2=A0</font><code><span style=
=3D"font-family:&#39;Times New Roman&#39;,serif;color:black"><font size=3D"=
4">git://<a href=3D"http://git.fsl.cs.stonybrook.edu/linux-dmdedup.git">git=
.fsl.cs.stonybrook.edu/linux-dmdedup.git</a>=C2=A0</font></span></code></di=
v><div><code><span style=3D"font-family:&#39;Times New Roman&#39;,serif;col=
or:black"><font size=3D"4">branch dm-dedup-devel</font></span></code></div>=
<div><font size=3D"4"><br></font></div><div><font size=3D"4">Can you help m=
e and give me some advises?</font></div><div style=3D"font-size:13px"><font=
 size=3D"4"><br></font></div><div style=3D"font-size:13px"><font size=3D"4"=
>Thanks a lot!</font></div><div style=3D"font-size:13px"><br></div><div sty=
le=3D"font-size:13px"><font size=3D"4"><br></font></div><div style=3D"font-=
size:13px"><font size=3D"4">Zhichao</font></div></div>

--047d7b6226e6fcf593050e734330--


--===============7715423299268842786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7715423299268842786==--
