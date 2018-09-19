From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: device-mapper: ioctl: ioctl interface mismatch:
 kernel(4.37.0), user(4.39.0), cmd(16)
Date: Wed, 19 Sep 2018 11:34:19 -0400
Message-ID: <20180919153418.GB9101@redhat.com>
References: <CAPUHmCpwJ7jX-d6PHdmOWQC47zOBkT1-c6o2DH4xS9_Uq13vBA@mail.gmail.com>
	<09dfe022-a4a1-3fec-f998-ecfb0a477e44@redhat.com>
	<CAPUHmCodFP=PFK8DqrV_Qz_cgT6uaRXUihhTaPhjJpJ=bSCy-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3036103749501354848=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPUHmCodFP=PFK8DqrV_Qz_cgT6uaRXUihhTaPhjJpJ=bSCy-A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?iso-8859-1?Q?=D6zkan_G=F6ksu?= <ozkangksu@gmail.com>
Cc: dm-devel@redhat.com, zkabelac@redhat.com
List-Id: dm-devel.ids

--===============3036103749501354848==
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Right, this is a multipath-tools problem (AFAIK regression).. not aware
of any new ioctl requirements that a newer multipathd would have to
warrant the stricter use of a newer DM ioctl version.

Mike

On Wed, Sep 19 2018 at 11:30am -0400,
Ã–zkan GÃ¶ksu <ozkangksu@gmail.com> wrote:

>    Hello.
>    After your mail I tried something;
>    I just curious what will happen when I downgrade multipath-tools package
>    and the rest was latest.
>    lvm2 2.02.181-1
>    device-mapper 2.02.181-1
>    I just downgrade to: multipath-tools 0.7.6-1
>    Everything works great. I didnt saw any problem.
>    I was thinking the problem related to device-mapper but now its seems
>    something else.
>    This is compile process from Arch-linux AUR repository:
>    [1]https://paste.ubuntu.com/p/zV58g56gVT/
>    If I'm not mistaken this is the log you want. If its not then tell me
>    where should I look for the log you want?
>    [root@SMDEV2  service]# ldd /usr/bin/multipathd
>            linux-vdso.so.1 (0x00007fffea4fe000)
>            libmultipath.so.0 => /usr/lib/libmultipath.so.0
>    (0x00007f729711e000)
>            libmpathpersist.so.0 => /usr/lib/libmpathpersist.so.0
>    (0x00007f7297114000)
>            libmpathcmd.so.0 => /usr/lib/libmpathcmd.so.0 (0x00007f729710f000)
>            libudev.so.1 => /usr/lib/libudev.so.1 (0x00007f72970ef000)
>            libdl.so.2 => /usr/lib/libdl.so.2 (0x00007f72970ea000)
>            liburcu.so.6 => /usr/lib/liburcu.so.6 (0x00007f7296ee2000)
>            libpthread.so.0 => /usr/lib/libpthread.so.0 (0x00007f7296ebf000)
>            libdevmapper.so.1.02 => /usr/lib/libdevmapper.so.1.02
>    (0x00007f7296c69000)
>            libreadline.so.7 => /usr/lib/libreadline.so.7 (0x00007f7296a1c000)
>            libsystemd.so.0 => /usr/lib/libsystemd.so.0 (0x00007f7296990000)
>            libc.so.6 => /usr/lib/libc.so.6 (0x00007f72967cc000)
>            libaio.so.1 => /usr/lib/libaio.so.1 (0x00007f72965ca000)
>            /lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2
>    (0x00007f72971b5000)
>            liburcu-common.so.6 => /usr/lib/liburcu-common.so.6
>    (0x00007f72963c3000)
>            libm.so.6 => /usr/lib/libm.so.6 (0x00007f729623e000)
>            libncursesw.so.6 => /usr/lib/libncursesw.so.6 (0x00007f7295fd1000)
>            librt.so.1 => /usr/lib/librt.so.1 (0x00007f7295fc7000)
>            liblzma.so.5 => /usr/lib/liblzma.so.5 (0x00007f7295da1000)
>            liblz4.so.1 => /usr/lib/liblz4.so.1 (0x00007f7295b84000)
>            libgcrypt.so.20 => /usr/lib/libgcrypt.so.20 (0x00007f7295866000)
>            libgpg-error.so.0 => /usr/lib/libgpg-error.so.0
>    (0x00007f7295646000)
>    I did not tried to compile from GIT by myself. But my knowledge the aur
>    package also takes the code from your git repository
>    If you need anything else just ask me please.
> 
>    Zdenek Kabelac <[2]zkabelac@redhat.com>, 19 Eyl 2018 Çar, 15:52 tarihinde
>    sunu yazdi:
> 
>      Dne 19.9.2018 v 12:35 Özkan Göksu napsal(a):
>      > Hello.
>      > I just upgraded my Kernel to: 4.14.70-1-lts | device-mapper 2.02.181-1
>      |
>      > multipath-tools 0.7.7-1
>      > After that multipathd started to giving the log: // device-mapper:
>      ioctl:
>      > ioctl interface mismatch: kernel(4.37.0), user(4.39.0), cmd(16)
>      > It was working great on my ex kernel "4.14.30-1-lts" with |
>      device-mapper
>      > 2.02.177-5 | multipath-tools 0.7.6-1
>      > Also I tried multipath git version but nothing change.
>      >
>      > I think the problem related to device-mapper and my device mapper
>      Build Date:
>      > 2018-08-01 19:05 UTC =
>      > [3]https://www.archlinux.org/packages/core/x86_64/device-mapper/
>      > Do I need to compile device mapper git version or what should I do?
>      >
> 
>      Hi
> 
>      Can you pastebin how is your package linked while being compiled (gcc
>      log) and
>      how is then used runtime  (ldd) ?
> 
>      It seems the code was linked with different .so library then it's using
>      in
>      runtime.
> 
>      libdm  is supposed to handle all kernel versions.
> 
>      Regards
> 
>      Zdenek
> 
> References
> 
>    Visible links
>    1. https://paste.ubuntu.com/p/zV58g56gVT/
>    2. mailto:zkabelac@redhat.com
>    3. https://www.archlinux.org/packages/core/x86_64/device-mapper/

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


--===============3036103749501354848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3036103749501354848==--
