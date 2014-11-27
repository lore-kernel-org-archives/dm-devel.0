From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Unable to deactivate lv,
	pehaps due to semaphore problem...
Date: Thu, 27 Nov 2014 15:26:11 +0100
Message-ID: <CAG2kNCxiZhRpfnifa58bDODfcyhaArLmP4kbgPfPs=2Lq_tYWw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2112325171152899419=="
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

--===============2112325171152899419==
Content-Type: multipart/alternative; boundary=f46d043c7ef80e2d800508d7ed19

--f46d043c7ef80e2d800508d7ed19
Content-Type: text/plain; charset=UTF-8

Hello,
I'm unable to deactivate an lvm.

My system is RHEL 6.5 with lvm2-2.02.100-8.el6.x86_64 and kernel
2.6.32-431.29.2.el6.x86_64

I get error code 5 with message
  Logical volume VG_AAA_TEMP/LV_AAA_TEMP in use.

You can find output of
lvchange -d -d -d -d -d -d -an VG_AAA_TEMP/LV_AAA_TEMP
here:
https://drive.google.com/file/d/0BwoPbcrMv8mvTjlBMkRUbG9nczA/view?usp=sharing

Recreating sources from the related src.rpm the problem (as stated anyway
in error message too) is in code

activate/activate.c:711   Logical volume in use

that is
        while (open_count_check_retries--) {
                if (info->open_count > 0) {
                        if (open_count_check_retries) {
                                usleep(OPEN_COUNT_CHECK_USLEEP_DELAY);
                                log_debug_activation("Retrying open_count
check for %s/%s.",
                                                     lv->vg->name,
lv->name);
                                if (!lv_info(cmd, lv, 0, info, 1, 0))
                                        return -1;
                                continue;
                        }
                        log_error("Logical volume %s/%s in use.",
                                  lv->vg->name, lv->name);
                        return 0;
                } else
                        break;
        }

In fact I get this information querying device:

[root@orapr2 activate]# dmsetup info --checks
360a9800037543544465d424130533177
Name:              360a9800037543544465d424130533177
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      23
Major, minor:      253, 4
Number of targets: 1
UUID: mpath-360a9800037543544465d424130533177

[root@orapr2 activate]# dmsetup table 360a9800037543544465d424130533177
0 2097152 multipath 4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handler 1 alua 2 1 round-robin 0 4 1 66:160 1 69:192 1
133:224 1 8:288 1 round-robin 0 4 1 8:96 1 68:48 1 129:32 1 130:128 1

I got in past days a problem related to sempahores
(maximum number of semaphore sets has been exceeded)
and I suspect that some resource could have been incorrectly locked.

The device is sort of
  [root@orapr2 ~]# multipath -l  360a9800037543544465d424130533177
360a9800037543544465d424130533177 dm-4 NETAPP,LUN
size=1.0G features='4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle' hwhandler='1 alua' wp=rw
|-+- policy='round-robin 0' prio=0 status=active
| |- 1:0:1:7  sdaq 66:160  active undef  running
| |- 1:0:2:7  sdco 69:192  active undef  running
| |- 2:0:2:7  sdho 133:224 active undef  running
| `- 2:0:3:7  sdiy 8:288   active undef  running
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 1:0:0:7  sdg  8:96    active undef  running
  |- 2:0:0:7  sdbp 68:48   active undef  running
  |- 1:0:3:7  sdeq 129:32  active undef  running
  `- 2:0:1:7  sdfm 130:128 active undef  running

and the filesystem on it has been successfully umounted, but

[root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP
  LV          VG          Attr       LSize    Pool Origin Data%  Move Log
Cpy%Sync Convert
  LV_AAA_TEMP VG_AAA_TEMP -wi-ao---- 1020.00m

How can I see the responsible for the reference that apparently keeps it
open?

Open count:        1
so I can check and eventually fix??

Thanks in advance.

Gianluca

--f46d043c7ef80e2d800508d7ed19
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<div>I&#39;m unable to deactivate an lvm.</div><div>=
<br></div><div>My system is RHEL 6.5 with lvm2-2.02.100-8.el6.x86_64 and ke=
rnel 2.6.32-431.29.2.el6.x86_64</div><div><br></div><div>I get error code 5=
 with message<br></div><div>=C2=A0 Logical volume VG_AAA_TEMP/LV_AAA_TEMP i=
n use.<br></div><div><br></div><div>You can find output of</div><div>lvchan=
ge -d -d -d -d -d -d -an VG_AAA_TEMP/LV_AAA_TEMP<br></div><div>here:</div><=
div><a href=3D"https://drive.google.com/file/d/0BwoPbcrMv8mvTjlBMkRUbG9nczA=
/view?usp=3Dsharing">https://drive.google.com/file/d/0BwoPbcrMv8mvTjlBMkRUb=
G9nczA/view?usp=3Dsharing</a><br></div><div><br></div><div>Recreating sourc=
es from the related src.rpm the problem (as stated anyway in error message =
too) is in code</div><div><br></div><div>activate/activate.c:711 =C2=A0 Log=
ical volume in use<br></div><div><br></div><div>that is</div><div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 while (open_count_check_retries--) {</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (info-&gt;open_coun=
t &gt; 0) {</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (open_count_check_retries) {</div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 usleep(OPEN_COUNT_CHECK_USLEEP_DELAY=
);</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 log_debug_activation(&quo=
t;Retrying open_count check for %s/%s.&quot;,</div><div>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0lv-&gt;vg-&gt;name, lv-&gt;name);</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!lv_info(cmd, lv, 0, info, 1, 0))</div>=
<div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retur=
n -1;</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;</div><div>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 log_error(&quot;Logical volume %s/%s in use=
.&quot;,</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lv-&gt;vg-&g=
t;name, lv-&gt;name);</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;</div><div>=C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else</div><div>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break=
;</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 }</div></div><div><br></div><div>In=
 fact I get this information querying device:</div><div><br></div><div><div=
>[root@orapr2 activate]# dmsetup info --checks 360a9800037543544465d4241305=
33177</div><div>Name: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0360a9=
800037543544465d424130533177</div><div>State: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 ACTIVE</div><div>Read Ahead: =C2=A0 =C2=A0 =C2=A0 =C2=A0256</=
div><div>Tables present: =C2=A0 =C2=A0LIVE</div><div>Open count: =C2=A0 =C2=
=A0 =C2=A0 =C2=A01</div><div>Event number: =C2=A0 =C2=A0 =C2=A023</div><div=
>Major, minor: =C2=A0 =C2=A0 =C2=A0253, 4</div><div>Number of targets: 1</d=
iv><div>UUID: mpath-360a9800037543544465d424130533177</div></div><div><br><=
/div><div><div>[root@orapr2 activate]# dmsetup table 360a9800037543544465d4=
24130533177</div><div>0 2097152 multipath 4 queue_if_no_path pg_init_retrie=
s 50 retain_attached_hw_handler 1 alua 2 1 round-robin 0 4 1 66:160 1 69:19=
2 1 133:224 1 8:288 1 round-robin 0 4 1 8:96 1 68:48 1 129:32 1 130:128 1=
=C2=A0</div></div><div><br></div><div>I got in past days a problem related =
to sempahores=C2=A0</div><div>(maximum number of semaphore sets has been ex=
ceeded)</div><div>and I suspect that some resource could have been incorrec=
tly locked.</div><div><br></div><div>The device is sort of</div><div>=C2=A0=
 [root@orapr2 ~]# multipath -l =C2=A0360a9800037543544465d424130533177</div=
><div>360a9800037543544465d424130533177 dm-4 NETAPP,LUN</div><div>size=3D1.=
0G features=3D&#39;4 queue_if_no_path pg_init_retries 50 retain_attached_hw=
_handle&#39; hwhandler=3D&#39;1 alua&#39; wp=3Drw</div><div>|-+- policy=3D&=
#39;round-robin 0&#39; prio=3D0 status=3Dactive</div><div>| |- 1:0:1:7 =C2=
=A0sdaq 66:160 =C2=A0active undef =C2=A0running</div><div>| |- 1:0:2:7 =C2=
=A0sdco 69:192 =C2=A0active undef =C2=A0running</div><div>| |- 2:0:2:7 =C2=
=A0sdho 133:224 active undef =C2=A0running</div><div>| `- 2:0:3:7 =C2=A0sdi=
y 8:288 =C2=A0 active undef =C2=A0running</div><div>`-+- policy=3D&#39;roun=
d-robin 0&#39; prio=3D0 status=3Denabled</div><div>=C2=A0 |- 1:0:0:7 =C2=A0=
sdg =C2=A08:96 =C2=A0 =C2=A0active undef =C2=A0running</div><div>=C2=A0 |- =
2:0:0:7 =C2=A0sdbp 68:48 =C2=A0 active undef =C2=A0running</div><div>=C2=A0=
 |- 1:0:3:7 =C2=A0sdeq 129:32 =C2=A0active undef =C2=A0running</div><div>=
=C2=A0 `- 2:0:1:7 =C2=A0sdfm 130:128 active undef =C2=A0running</div><div><=
br></div><div>and the filesystem on it has been successfully umounted, but<=
/div><div><br></div><div><div>[root@orapr2 ~]# lvs VG_AAA_TEMP/LV_AAA_TEMP<=
/div><div>=C2=A0 LV =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0VG =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0Attr =C2=A0 =C2=A0 =C2=A0 LSize =C2=A0 =C2=A0Pool Origin D=
ata% =C2=A0Move Log Cpy%Sync Convert</div><div>=C2=A0 LV_AAA_TEMP VG_AAA_TE=
MP -wi-ao---- 1020.00m</div></div><div><br></div><div>How can I see the res=
ponsible for the reference that apparently keeps it open?</div><div><br></d=
iv><div>Open count: =C2=A0 =C2=A0 =C2=A0 =C2=A01<br></div><div>so I can che=
ck and eventually fix??</div><div><br></div><div>Thanks in advance.<br></di=
v><div><br></div><div>Gianluca</div></div>

--f46d043c7ef80e2d800508d7ed19--


--===============2112325171152899419==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2112325171152899419==--
