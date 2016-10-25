From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: how to refresh LV to apply fstrim online
Date: Tue, 25 Oct 2016 17:38:48 +0200
Message-ID: <CAG2kNCw69jco30o=+NcomZxu-wPgzPt0kONts4R2ZendRhGXbA@mail.gmail.com>
References: <CAG2kNCwwDEeY0jHMvD6JxVb2WFHncY3pRM_Cy=QvAgJxaoa5MA@mail.gmail.com>
	<da58a0be-bdd9-a06d-f1a9-6b8c6e07b052@redhat.com>
	<CAG2kNCztXfyeU7xoT2KuN=YwNwhYj78J7XoriwcOPyBHimG9OQ@mail.gmail.com>
	<CAG2kNCwn57jjbsCNq+b0Mkku9fA2oZJXCw9EUSpyj=F0CABjRg@mail.gmail.com>
	<fc98716c-2bc8-07a5-d0d3-d39a14397127@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0635137121220808583=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fc98716c-2bc8-07a5-d0d3-d39a14397127@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0635137121220808583==
Content-Type: multipart/alternative; boundary=001a114113940241d6053fb24e55

--001a114113940241d6053fb24e55
Content-Type: text/plain; charset=UTF-8

On Tue, Oct 25, 2016 at 4:12 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

>
>> t giving downtime, in a safe way.
>
>
> Normally it's not advised  to use 'dmsetup' command for  LV.
> The above sequence should be equivalent to:
>
> lvchange --refresh  vg/lv
> (or  vgchange --refresh vg  -  doing it for every active LV in VG)
>
> It's unclear how this could help  - unless you we doing some 'pvmove'
> operations (which might be worth a BZ).
>
> You should collect all states  while it 'DOES NOT' work.
> And then  run  the --refresh (which you thing it's fixing it for your)
> ATM I'm clueless how you get mapping without TRIM where --refresh can fix
> it.
>
>
> Regards
>
> Zdenek
>
>
>

When I rescan the single devices (the legs) I do have then
[root@dbatest1 ~]# for dev in sdea sdem ; do grep ""
/sys/block/${dev}/queue/discard_granularity; done
1048576
1048576
[root@dbatest1 ~]#

But the problem is the device mapper device of the LV itself, while the
multipath one is ok.
I had tried with both

vgchange --refresh VG_TEST_REDO
and
lvchange --refresh VG_TEST_REDO/LV_TEST_REDO

BTW: The VG contains only this LV

yes the current device has been the target of a pvmove operation, where
initially the LUN was not configured as thin provisioned.

but the underlying dm device still contains 0 in its granularity. And the
fstrim command fails.
in this new test it is dm-14 (while the multipath device of the related PV
is dm-47 and it is ok)

[root@dbatest1 ~]# multipath -l
/dev/mapper/3600a098038303769752b4951473778673600a098038303769752b495147377867
dm-47 NETAPP,LUN C-Mode
size=2.0G features='4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle' hwhandler='1 alua' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 7:0:5:21 sdea 128:32  active undef running
  `- 8:0:5:21 sdem 128:224 active undef running
[root@dbatest1 ~]#

[root@dbatest1 ~]# ll /dev/VG_TEST_REDO/LV_TEST_REDO
lrwxrwxrwx 1 root root 8 Oct 25 17:25 /dev/VG_TEST_REDO/LV_TEST_REDO ->
../dm-14
[root@dbatest1 ~]#


[root@dbatest1 ~]# cat /sys/block/dm-47/queue/discard_granularity
1048576
[root@dbatest1 ~]#


[root@dbatest1 ~]# cat /sys/block/dm-14/queue/discard_granularity
0
[root@dbatest1 ~]#

So the problem seems to find a way to get the discard_granularity inside
dm-14.
One way to obtain it is my method:

[root@dbatest1 ~]# dmsetup info /dev/dm-14
Name:              VG_TEST_REDO-LV_TEST_REDO
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      253, 14
Number of targets: 1
UUID: LVM-ebT3iin7JZdFZCoR05NEPpXcDosNQ3Y46HwejMdu0o9qfeeeMcRTemcuGtUVqMds

[root@dbatest1 ~]# dmsetup table /dev/dm-14 > my_dm_table

[root@dbatest1 ~]# dmsetup suspend /dev/dm-14 ; dmsetup reload /dev/dm-14
my_dm_table ; dmsetup resume /dev/dm-14
[root@dbatest1 ~]#

And now
[root@dbatest1 ~]# cat /sys/block/dm-14/queue/discard_granularity
1048576
[root@dbatest1 ~]#

and
[root@dbatest1 ~]# fstrim /TEST/redolog/
[root@dbatest1 ~]#

--001a114113940241d6053fb24e55
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
ue, Oct 25, 2016 at 4:12 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:=
1px solid rgb(204,204,204);padding-left:1ex"><div><div class=3D"gmail-h5"><=
br>
</div></div></blockquote><span class=3D"gmail-">
t giving downtime, in a safe way.<br>
<br>
<br></span>
Normally it&#39;s not advised=C2=A0 to use &#39;dmsetup&#39; command for=C2=
=A0 LV.<br>
The above sequence should be equivalent to:<br>
<br>
lvchange --refresh=C2=A0 vg/lv<br>
(or=C2=A0 vgchange --refresh vg=C2=A0 -=C2=A0 doing it for every active LV =
in VG)<br>
<br>
It&#39;s unclear how this could help=C2=A0 - unless you we doing some &#39;=
pvmove&#39;<br>
operations (which might be worth a BZ).<br>
<br>
You should collect all states=C2=A0 while it &#39;DOES NOT&#39; work.<br>
And then=C2=A0 run=C2=A0 the --refresh (which you thing it&#39;s fixing it =
for your)<br>
ATM I&#39;m clueless how you get mapping without TRIM where --refresh can f=
ix it.<br>
<br>
<br>
Regards<span class=3D"gmail-HOEnZb"><font color=3D"#888888"><br>
<br>
Zdenek<br>
<br>
<br>
</font></span></blockquote></div><br></div><div class=3D"gmail_extra"><br><=
/div><div class=3D"gmail_extra">When I rescan the single devices (the legs)=
 I do have then=C2=A0</div><div class=3D"gmail_extra"><div class=3D"gmail_e=
xtra">[root@dbatest1 ~]# for dev in sdea sdem ; do grep &quot;&quot; /sys/b=
lock/${dev}/queue/discard_granularity; done</div><div class=3D"gmail_extra"=
>1048576</div><div class=3D"gmail_extra">1048576</div><div class=3D"gmail_e=
xtra">[root@dbatest1 ~]#</div><div class=3D"gmail_extra"><br></div><div cla=
ss=3D"gmail_extra">But the problem is the device mapper device of the LV it=
self, while the multipath one is ok.</div><div class=3D"gmail_extra">I had =
tried with both=C2=A0</div><div class=3D"gmail_extra"><br></div><div class=
=3D"gmail_extra"><div class=3D"gmail_extra">vgchange --refresh VG_TEST_REDO=
<br></div><div class=3D"gmail_extra">and</div><div class=3D"gmail_extra">lv=
change --refresh VG_TEST_REDO/LV_TEST_REDO<br></div><div class=3D"gmail_ext=
ra"><br></div><div class=3D"gmail_extra">BTW: The VG contains only this LV<=
/div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">yes th=
e current device has been the target of a pvmove operation, where initially=
 the LUN was not configured as thin provisioned.</div><div class=3D"gmail_e=
xtra"><br></div><div class=3D"gmail_extra">but the underlying dm device sti=
ll contains 0 in its granularity. And the fstrim command fails.</div><div c=
lass=3D"gmail_extra">in this new test it is dm-14 (while the multipath devi=
ce of the related PV is dm-47 and it is ok)</div><div class=3D"gmail_extra"=
><br></div><div class=3D"gmail_extra"><div class=3D"gmail_extra">[root@dbat=
est1 ~]# multipath -l /dev/mapper/3600a098038303769752b4951473778673600a098=
038303769752b495147377867 dm-47 NETAPP,LUN C-Mode</div><div class=3D"gmail_=
extra">size=3D2.0G features=3D&#39;4 queue_if_no_path pg_init_retries 50 re=
tain_attached_hw_handle&#39; hwhandler=3D&#39;1 alua&#39; wp=3Drw</div><div=
 class=3D"gmail_extra">`-+- policy=3D&#39;round-robin 0&#39; prio=3D0 statu=
s=3Dactive</div><div class=3D"gmail_extra">=C2=A0 |- 7:0:5:21 sdea 128:32 =
=C2=A0active undef running</div><div class=3D"gmail_extra">=C2=A0 `- 8:0:5:=
21 sdem 128:224 active undef running</div><div class=3D"gmail_extra">[root@=
dbatest1 ~]#=C2=A0</div><div><br></div></div></div><div class=3D"gmail_extr=
a"><div class=3D"gmail_extra">[root@dbatest1 ~]# ll /dev/VG_TEST_REDO/LV_TE=
ST_REDO</div><div class=3D"gmail_extra">lrwxrwxrwx 1 root root 8 Oct 25 17:=
25 /dev/VG_TEST_REDO/LV_TEST_REDO -&gt; ../dm-14</div><div class=3D"gmail_e=
xtra">[root@dbatest1 ~]#</div><div class=3D"gmail_extra"><br></div><div cla=
ss=3D"gmail_extra"><br></div></div><div class=3D"gmail_extra"><div class=3D=
"gmail_extra">[root@dbatest1 ~]# cat /sys/block/dm-47/queue/discard_granula=
rity</div><div class=3D"gmail_extra">1048576</div><div class=3D"gmail_extra=
">[root@dbatest1 ~]#=C2=A0</div><div><br></div><div><br></div><div><div>[ro=
ot@dbatest1 ~]# cat /sys/block/dm-14/queue/discard_granularity</div><div>0<=
/div><div>[root@dbatest1 ~]#</div></div><div><br></div><div>So the problem =
seems to find a way to get the discard_granularity inside dm-14.</div><div>=
One way to obtain it is my method:</div><div><br></div><div><div>[root@dbat=
est1 ~]# dmsetup info /dev/dm-14</div><div>Name: =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0VG_TEST_REDO-LV_TEST_REDO</div><div>State: =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ACTIVE</div><div>Read Ahead: =C2=A0 =C2=
=A0 =C2=A0 =C2=A0256</div><div>Tables present: =C2=A0 =C2=A0LIVE</div><div>=
Open count: =C2=A0 =C2=A0 =C2=A0 =C2=A01</div><div>Event number: =C2=A0 =C2=
=A0 =C2=A00</div><div>Major, minor: =C2=A0 =C2=A0 =C2=A0253, 14</div><div>N=
umber of targets: 1</div><div>UUID: LVM-ebT3iin7JZdFZCoR05NEPpXcDosNQ3Y46Hw=
ejMdu0o9qfeeeMcRTemcuGtUVqMds</div><div><br></div></div><div>[root@dbatest1=
 ~]# dmsetup table /dev/dm-14 &gt; my_dm_table<br></div><div><br></div><div=
><div>[root@dbatest1 ~]# dmsetup suspend /dev/dm-14 ; dmsetup reload /dev/d=
m-14 my_dm_table ; dmsetup resume /dev/dm-14</div><div>[root@dbatest1 ~]#</=
div></div><div><br></div><div>And now</div><div><div>[root@dbatest1 ~]# cat=
 /sys/block/dm-14/queue/discard_granularity</div><div>1048576</div><div>[ro=
ot@dbatest1 ~]#=C2=A0</div></div><div><br></div><div>and</div><div><div>[ro=
ot@dbatest1 ~]# fstrim /TEST/redolog/</div><div>[root@dbatest1 ~]#=C2=A0</d=
iv></div><div><br></div></div></div></div>

--001a114113940241d6053fb24e55--


--===============0635137121220808583==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0635137121220808583==--
