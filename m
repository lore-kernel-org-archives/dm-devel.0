From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: dm-dedup can not make module
Date: Mon, 9 Feb 2015 13:11:12 +0100
Message-ID: <CA+res+Q-oyxopdHWJnsxgb3kirqCDxs8qTC+Ca8=yrZgkYg-ig@mail.gmail.com>
References: <CAOhDoTEumgSehwa-NtrjwZjW7yOWPwXNEoqK1BPFY6Qe9XSkLw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8822347570331066276=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAOhDoTEumgSehwa-NtrjwZjW7yOWPwXNEoqK1BPFY6Qe9XSkLw@mail.gmail.com>
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

--===============8822347570331066276==
Content-Type: multipart/alternative; boundary=001a1140c48e913f4b050ea6aa68

--001a1140c48e913f4b050ea6aa68
Content-Type: text/plain; charset=UTF-8

Hi Zhichao.

Please change
 obj-$(CONFIG_DM_DEDUP) += dm-dedup.o
to
obj-m += dm-dedup.o

Regards,
Jack
2015-02-06 23:51 GMT+01:00 Zhichao Cao <caozhichao91@gmail.com>:

> Hi Mike,
>
> I'm a UMN CS student and just the beginer. I'm working on primary dedup
> project and read the dm-dedup paper, which might be very useful for me, so
> I want to try and learn it.
>
> However, when I tried to make dm-dedup as a module and insmod it, it
> always failed.
>
> make -C /lib/modules/`uname -r`/build M=/root/Downloads/md
> make[1]: Entering directory `/usr/src/linux-3.18.5'
>   Building modules, stage 2.
>   MODPOST 0 modules
> make[1]: Leaving directory `/usr/src/linux-3.18.5'
>
> No module was built after make, and my Makefile is:
>
> dm-dedup-y += dm-dedup-target.o dm-dedup-hash.o dm-dedup-rw.o
> dm-dedup-cbt.o dm-dedup-ram.o
>
> obj-$(CONFIG_DM_DEDUP) += dm-dedup.o
>
> ifeq ($(CONFIG_DM_UEVENT),y)
> dm-mod-objs += dm-uevent.o
> endif
>
> all:
> make -C /lib/modules/`uname -r`/build M=$(PWD)
> clean:
> make -C /lib/modules/`uname -r`/build M=$(PWD) clean
> install:
> install -m 755 *.ko /lib/modules/`uname -r`/kernel/drivers/md/
>
> The dm-dedup source files are pulled from git://
> git.fsl.cs.stonybrook.edu/linux-dmdedup.git
> branch dm-dedup-devel
>
> Can you help me and give me some advises?
>
> Thanks a lot!
>
>
> Zhichao
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a1140c48e913f4b050ea6aa68
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><span style=3D"font-size:13px">Hi Zhichao.</span></di=
v><span style=3D"font-size:13px"><div><span style=3D"font-size:13px"><br></=
span></div>Please change</span><div><span style=3D"font-size:13px">=C2=A0ob=
j-$(CONFIG_DM_DEDUP)</span><span style=3D"font-size:13px;white-space:pre-wr=
ap">		</span><span style=3D"font-size:13px">+=3D dm-dedup.o=C2=A0</span></d=
iv><div><span style=3D"font-size:13px">to=C2=A0</span><div><span style=3D"f=
ont-size:13px">obj-m +=3D dm-dedup.o</span><br></div></div><div class=3D"gm=
ail_extra"><br></div><div class=3D"gmail_extra">Regards,</div><div class=3D=
"gmail_extra">Jack<br><div class=3D"gmail_quote">2015-02-06 23:51 GMT+01:00=
 Zhichao Cao <span dir=3D"ltr">&lt;<a href=3D"mailto:caozhichao91@gmail.com=
" target=3D"_blank">caozhichao91@gmail.com</a>&gt;</span>:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex"><div dir=3D"ltr"><font size=3D"4">Hi Mike,</font><div sty=
le=3D"font-size:13px"><font size=3D"4"><br></font></div><div style=3D"font-=
size:13px"><font size=3D"4">I&#39;m a UMN CS student and just the beginer. =
I&#39;m working on primary dedup project and read the dm-dedup paper, which=
 might be very useful for me, so I want to try and learn it.=C2=A0</font></=
div><div style=3D"font-size:13px"><font size=3D"4"><br></font></div><div st=
yle=3D"font-size:13px"><font size=3D"4">However, when I tried to make dm-de=
dup as a module and insmod it, it always failed.</font></div><div style=3D"=
font-size:13px"><br></div><div style=3D"font-size:13px"><div>make -C /lib/m=
odules/`uname -r`/build M=3D/root/Downloads/md</div><div>make[1]: Entering =
directory `/usr/src/linux-3.18.5&#39;</div><div>=C2=A0 Building modules, st=
age 2.</div><div>=C2=A0 MODPOST 0 modules</div><div>make[1]: Leaving direct=
ory `/usr/src/linux-3.18.5&#39;</div></div><div style=3D"font-size:13px"><b=
r></div><div style=3D"font-size:13px"><font size=3D"4">No module was built =
after make, and my Makefile is:</font></div><div style=3D"font-size:13px"><=
br></div><div style=3D"font-size:13px"><div>dm-dedup-y<span style=3D"white-=
space:pre-wrap">	</span>+=3D dm-dedup-target.o dm-dedup-hash.o dm-dedup-rw.=
o dm-dedup-cbt.o dm-dedup-ram.o</div><div><br></div><div>obj-$(CONFIG_DM_DE=
DUP)<span style=3D"white-space:pre-wrap">		</span>+=3D dm-dedup.o</div><div=
><br></div><div>ifeq ($(CONFIG_DM_UEVENT),y)</div><div>dm-mod-objs<span sty=
le=3D"white-space:pre-wrap">			</span>+=3D dm-uevent.o</div><div>endif</div=
><div><br></div><div>all:</div><div><span style=3D"white-space:pre-wrap">	<=
/span>make -C /lib/modules/`uname -r`/build M=3D$(PWD)</div><div>clean:</di=
v><div><span style=3D"white-space:pre-wrap">	</span>make -C /lib/modules/`u=
name -r`/build M=3D$(PWD) clean</div><div>install:</div><div><span style=3D=
"white-space:pre-wrap">	</span>install -m 755 *.ko /lib/modules/`uname -r`/=
kernel/drivers/md/</div></div><div style=3D"font-size:13px"><br></div><div>=
<font size=3D"4">The dm-dedup source files are pulled from=C2=A0</font><cod=
e><span style=3D"font-family:&#39;Times New Roman&#39;,serif;color:black"><=
font size=3D"4">git://<a href=3D"http://git.fsl.cs.stonybrook.edu/linux-dmd=
edup.git" target=3D"_blank">git.fsl.cs.stonybrook.edu/linux-dmdedup.git</a>=
=C2=A0</font></span></code></div><div><code><span style=3D"font-family:&#39=
;Times New Roman&#39;,serif;color:black"><font size=3D"4">branch dm-dedup-d=
evel</font></span></code></div><div><font size=3D"4"><br></font></div><div>=
<font size=3D"4">Can you help me and give me some advises?</font></div><div=
 style=3D"font-size:13px"><font size=3D"4"><br></font></div><div style=3D"f=
ont-size:13px"><font size=3D"4">Thanks a lot!</font></div><span class=3D"HO=
EnZb"><font color=3D"#888888"><div style=3D"font-size:13px"><br></div><div =
style=3D"font-size:13px"><font size=3D"4"><br></font></div><div style=3D"fo=
nt-size:13px"><font size=3D"4">Zhichao</font></div></font></span></div>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></=
div><br></div></div>

--001a1140c48e913f4b050ea6aa68--


--===============8822347570331066276==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8822347570331066276==--
