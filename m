From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 17:46:23 +0100
Message-ID: <CAG2kNCzQOo8OYTLdLDeUpGN3wNJQWv-ibGxUAxMnQBtQq-r3kw@mail.gmail.com>
References: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
	<54773621.5090301@redhat.com>
	<CAG2kNCyDcgCdCpUAzZ51mAyqS8LF9i9Tau3Lke5E2ZJy352_ig@mail.gmail.com>
	<54774220.7080709@redhat.com>
	<CAG2kNCz7hmtcMQBeVQRbryVTzsE_DKr9y8Pg8rfKmSf8UDVDRQ@mail.gmail.com>
	<5477469A.1080103@redhat.com>
	<CAG2kNCz_SKbHc4b56L1Dzkb19HsozW9aKs1Ln4MmYY9iUiLJOg@mail.gmail.com>
	<54774BCC.6020709@redhat.com>
	<CAG2kNCz=KuBKcLog-Z=iZBNAg9J31KwFRa7RgJ0GLXNqsd4UYQ@mail.gmail.com>
	<547752E4.70304@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2840681419505530041=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <547752E4.70304@redhat.com>
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

--===============2840681419505530041==
Content-Type: multipart/alternative; boundary=089e01176a4b78f6490508d9e24d

--089e01176a4b78f6490508d9e24d
Content-Type: text/plain; charset=UTF-8

On Thu, Nov 27, 2014 at 5:35 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

>
>>
> As I've been pointed our cgroups could play some role -
>

mhh I don't think I'm using Control Groups at all....
[root@orapr2 ~]# rpm -qa |grep group
[root@orapr2 ~]#

[root@orapr2 ~]# ll /etc/cgconfig.conf
ls: cannot access /etc/cgconfig.conf: No such file or directory


> so lets repeat with  /proc/*/mountinfo
>
>
[root@orapr2 ~]# cat /proc/*/mountinfo > /tmp/proc.log
cat: /proc/33700/mountinfo: Invalid argument
cat: /proc/33735/mountinfo: No such file or directory

[root@orapr2 ~]# wc -l /tmp/proc.log
55050 /tmp/proc.log

 [root@orapr2 ~]# grep 253:49 /tmp/proc.log
[root@orapr2 ~]#


Also check  /proc/swaps ?
>
>
 [root@orapr2 ~]# cat /proc/swaps
Filename Type Size Used Priority
/dev/sda2                               partition 16777212 0 -1

--089e01176a4b78f6490508d9e24d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
hu, Nov 27, 2014 at 5:35 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex"><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(2=
04,204,204);border-left-style:solid;padding-left:1ex"><span class=3D""><br>
</span></blockquote>
<br>
As I&#39;ve been pointed our cgroups could play some role -<br></blockquote=
><div><br></div><div>mhh I don&#39;t think I&#39;m using Control Groups at =
all....</div><div>[root@orapr2 ~]# rpm -qa |grep group</div><div>[root@orap=
r2 ~]#=C2=A0</div><div><br></div><div><div>[root@orapr2 ~]# ll /etc/cgconfi=
g.conf</div><div>ls: cannot access /etc/cgconfig.conf: No such file or dire=
ctory</div></div><div><br></div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,20=
4,204);border-left-style:solid;padding-left:1ex">
<br>
so lets repeat with=C2=A0 /proc/*/mountinfo<br>
<br></blockquote><div><div><br></div><div>[root@orapr2 ~]# cat /proc/*/moun=
tinfo &gt; /tmp/proc.log</div><div>cat: /proc/33700/mountinfo: Invalid argu=
ment</div><div>cat: /proc/33735/mountinfo: No such file or directory</div><=
div><br></div><div>[root@orapr2 ~]# wc -l /tmp/proc.log=C2=A0<br></div><div=
>55050 /tmp/proc.log</div></div><div><br></div><div>=C2=A0[root@orapr2 ~]# =
grep 253:49 /tmp/proc.log=C2=A0</div><div>[root@orapr2 ~]#</div><div><br></=
div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex">
Also check=C2=A0 /proc/swaps ?<div class=3D""><div class=3D"h5"><br></div><=
/div></blockquote><div><br></div><div>=C2=A0[root@orapr2 ~]# cat /proc/swap=
s=C2=A0</div><div>Filename<span class=3D"" style=3D"white-space:pre">				</=
span>Type<span class=3D"" style=3D"white-space:pre">		</span>Size<span clas=
s=3D"" style=3D"white-space:pre">	</span>Used<span class=3D"" style=3D"whit=
e-space:pre">	</span>Priority</div><div>/dev/sda2 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 partition<span class=3D"" style=3D"white-space:pre">	</span>16777212=
<span class=3D"" style=3D"white-space:pre">	</span>0<span class=3D"" style=
=3D"white-space:pre">	</span>-1</div><div><br></div></div></div></div>

--089e01176a4b78f6490508d9e24d--


--===============2840681419505530041==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2840681419505530041==--
