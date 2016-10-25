From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: how to refresh LV to apply fstrim online
Date: Tue, 25 Oct 2016 16:04:28 +0200
Message-ID: <CAG2kNCwn57jjbsCNq+b0Mkku9fA2oZJXCw9EUSpyj=F0CABjRg@mail.gmail.com>
References: <CAG2kNCwwDEeY0jHMvD6JxVb2WFHncY3pRM_Cy=QvAgJxaoa5MA@mail.gmail.com>
	<da58a0be-bdd9-a06d-f1a9-6b8c6e07b052@redhat.com>
	<CAG2kNCztXfyeU7xoT2KuN=YwNwhYj78J7XoriwcOPyBHimG9OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5206870263199105067=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAG2kNCztXfyeU7xoT2KuN=YwNwhYj78J7XoriwcOPyBHimG9OQ@mail.gmail.com>
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

--===============5206870263199105067==
Content-Type: multipart/alternative; boundary=001a113fa7daa5ab69053fb0fc2d

--001a113fa7daa5ab69053fb0fc2d
Content-Type: text/plain; charset=UTF-8

On Fri, Oct 21, 2016 at 1:32 AM, Gianluca Cecchi <gianluca.cecchi@gmail.com>
wrote:

>
> On Thu, Oct 20, 2016 at 1:40 PM, Zdenek Kabelac <zkabelac@redhat.com>
> wrote:
>
>>
>> Hi
>>
>> Please provide listing of all your 'multipath'  leg devices - are
>> they support TRIM ?
>> Then 'check' dm device.
>>
>> See  (and attach)
>>
>>  grep "" /sys/block/*/queue/discard_granularity
>>
>>
>> Also make sure you are NOT using 'ext2' filesystem which does not support
>> discard on RHEL6 and you are on latest available RHEL6 kernel.
>>
>>
>> Regards
>>
>> Zdenek
>>
>>
>>
> Hello,
> thanks for answer.
> I'm using ext3 filesystem that supports discard.
> Currently I'm on this kernel
>
> [root@dbatest1 ~]# uname -r
> 2.6.32-431.29.2.el6.x86_64
> [root@dbatest1 ~]#
>
>
> It seems that I was myself able to find a way to online refresh the
> logical volume and so to successfully run fstrim command against the
> related file system, without deactivating the lv and most important without
> generating downtime for my users.
> Please note that what I'm doing is working on a test system where I have
> the same situation as in production.
> Can you certify my approach and comment about it, so that I can eventually
> apply in production?
>
>
[snip]


>
> [root@dbatest1 ~]# dmsetup suspend /dev/dm-4 ; dmsetup reload /dev/dm-4
> my_dm_table ; dmsetup resume /dev/dm-4
> [root@dbatest1 ~]# echo $?
> 0
> [root@dbatest1 ~]#
>
> And now the magic:
>
> [root@dbatest1 ~]# fstrim /ALM/rdoffline
>

[snip]



I hope I wasn't too rude in asking "certification"... actually I meant
comment about the method and if anything nasty (eg the instant suspend
phase command...) could happen with that method....

If it is  anyway important, I have many multipath devices/ filsystems on
this test server and I can proceed to test one by one.
The LUNs indeed support trim.

In particular if I take one of the lun that yet needs to be trimmed, I have:


[g.cecchi@dbatest1 ~]$ sudo multipath -l 3600a098038303769752b495147377867
3600a098038303769752b495147377867 dm-47 NETAPP,LUN C-Mode
size=2.0G features='4 queue_if_no_path pg_init_retries 50
retain_attached_hw_handle' hwhandler='1 alua' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 7:0:5:21 sdea 128:32  active undef running
  `- 8:0:5:21 sdem 128:224 active undef running
[g.cecchi@dbatest1 ~]$


[g.cecchi@dbatest1 ~]$ for dev in sdea sdem
> do
> grep "" /sys/block/${dev}/queue/discard_granularity
> done
0
0
[g.cecchi@dbatest1 ~]$

and for the multipath device itself

[g.cecchi@dbatest1 ~]$ cat /sys/block/dm-47/queue/discard_granularity
0
[g.cecchi@dbatest1 ~]$


On devices where I was already able to reload/trim (previous post for
example), I had 0 too before as result, but now I have for example:

[g.cecchi@dbatest1 ~]$ for dev in sddt sdef; do grep ""
/sys/block/${dev}/queue/discard_granularity; done
1048576
1048576
[g.cecchi@dbatest1 ~]$

and also

[g.cecchi@dbatest1 ~]$ cat /sys/block/dm-4/queue/discard_granularity
1048576
[g.cecchi@dbatest1 ~]$

Hope I clarified ....

I don't understand though what you meant with 'check' dm device...

Thanks in advice for any help understanding if this can be the best
workflow to be able to run fstrim without giving downtime, in a safe way.

Gianluca

--001a113fa7daa5ab69053fb0fc2d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Fri, Oct 21, 2016 at 1:32 AM, Gianluca Cecchi <span dir=3D"ltr">&lt;=
<a href=3D"mailto:gianluca.cecchi@gmail.com" target=3D"_blank">gianluca.cec=
chi@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padd=
ing-left:1ex"><div dir=3D"ltr"><span class=3D"gmail-"><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote">On Thu, Oct 20, 2016 at 1:40 PM, Zdene=
k Kabelac <span dir=3D"ltr">&lt;<a href=3D"mailto:zkabelac@redhat.com" targ=
et=3D"_blank">zkabelac@redhat.com</a>&gt;</span> wrote:<br><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid r=
gb(204,204,204);padding-left:1ex"><div><div class=3D"gmail-m_-7714019981560=
999161gmail-h5"><br></div></div>
Hi<br>
<br>
Please provide listing of all your &#39;multipath&#39;=C2=A0 leg devices - =
are<br>
they support TRIM ?<br>
Then &#39;check&#39; dm device.<br>
<br>
See=C2=A0 (and attach)<br>
<br>
=C2=A0grep &quot;&quot; /sys/block/*/queue/discard_gra<wbr>nularity<br>
<br>
<br>
Also make sure you are NOT using &#39;ext2&#39; filesystem which does not s=
upport discard on RHEL6 and you are on latest available RHEL6 kernel.<br>
<br>
<br>
Regards<span class=3D"gmail-m_-7714019981560999161gmail-HOEnZb"><font color=
=3D"#888888"><br>
<br>
Zdenek<br>
<br>
<br>
</font></span></blockquote></div><br></div></span><div class=3D"gmail_extra=
">Hello,</div><div class=3D"gmail_extra">thanks for answer.</div><div class=
=3D"gmail_extra">I&#39;m using ext3 filesystem that supports discard.</div>=
<div class=3D"gmail_extra">Currently I&#39;m on this kernel</div><div class=
=3D"gmail_extra">=C2=A0</div><div class=3D"gmail_extra"><div class=3D"gmail=
_extra">[root@dbatest1 ~]# uname -r</div><div class=3D"gmail_extra">2.6.32-=
431.29.2.el6.x86_64</div><div class=3D"gmail_extra">[root@dbatest1 ~]#=C2=
=A0</div><div><br></div><div><br></div><div><div>It seems that I was myself=
 able to find a way to online refresh the logical volume and so to successf=
ully run fstrim command against the related file system, without deactivati=
ng the lv and most important without generating downtime for my users.</div=
><div>Please note that what I&#39;m doing is working on a test system where=
 I have the same situation as in production.</div><div>Can you certify my a=
pproach and comment about it, so that I can eventually apply in production?=
</div><div><br></div></div></div></div></blockquote><div><br></div><div>[sn=
ip]</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin=
:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"=
><div dir=3D"ltr"><div class=3D"gmail_extra"><div><div></div><div><br></div=
><div>[root@dbatest1 ~]# dmsetup suspend /dev/dm-4 ; dmsetup reload /dev/dm=
-4 my_dm_table ; dmsetup resume /dev/dm-4</div><div>[root@dbatest1 ~]# echo=
 $?</div><div>0</div><div>[root@dbatest1 ~]#</div><div><br></div><div>And n=
ow the magic:</div><span class=3D"gmail-"><div><br></div><div>[root@dbatest=
1 ~]# fstrim /ALM/rdoffline</div></span></div></div></div></blockquote><div=
><br></div><div>[snip]</div><div>=C2=A0</div><div><br></div><div><br></div>=
</div>I hope I wasn&#39;t too rude in asking &quot;certification&quot;... a=
ctually I meant comment about the method and if anything nasty (eg the inst=
ant suspend phase command...) could happen with that method....</div><div c=
lass=3D"gmail_extra"><br></div><div class=3D"gmail_extra">If it is =C2=A0an=
yway important, I have many multipath devices/ filsystems on this test serv=
er and I can proceed to test one by one.</div><div class=3D"gmail_extra">Th=
e LUNs indeed support trim.</div><div class=3D"gmail_extra"><br></div><div =
class=3D"gmail_extra">In particular if I take one of the lun that yet needs=
 to be trimmed, I have:</div><div class=3D"gmail_extra"><br></div><div clas=
s=3D"gmail_extra"><br></div><div class=3D"gmail_extra"><div class=3D"gmail_=
extra">[g.cecchi@dbatest1 ~]$ sudo multipath -l 3600a098038303769752b495147=
377867</div><div class=3D"gmail_extra">3600a098038303769752b495147377867 dm=
-47 NETAPP,LUN C-Mode</div><div class=3D"gmail_extra">size=3D2.0G features=
=3D&#39;4 queue_if_no_path pg_init_retries 50 retain_attached_hw_handle&#39=
; hwhandler=3D&#39;1 alua&#39; wp=3Drw</div><div class=3D"gmail_extra">`-+-=
 policy=3D&#39;round-robin 0&#39; prio=3D0 status=3Dactive</div><div class=
=3D"gmail_extra">=C2=A0 |- 7:0:5:21 sdea 128:32 =C2=A0active undef running<=
/div><div class=3D"gmail_extra">=C2=A0 `- 8:0:5:21 sdem 128:224 active unde=
f running</div><div class=3D"gmail_extra">[g.cecchi@dbatest1 ~]$=C2=A0</div=
><div><br></div><div><br></div><div><div>[g.cecchi@dbatest1 ~]$ for dev in =
sdea sdem</div><div>&gt; do</div><div>&gt; grep &quot;&quot; /sys/block/${d=
ev}/queue/discard_granularity</div><div>&gt; done</div><div>0</div><div>0</=
div><div>[g.cecchi@dbatest1 ~]$=C2=A0</div></div><div><br></div><div>and fo=
r the multipath device itself</div><div><br></div><div><div>[g.cecchi@dbate=
st1 ~]$ cat /sys/block/dm-47/queue/discard_granularity=C2=A0</div><div>0</d=
iv><div>[g.cecchi@dbatest1 ~]$=C2=A0</div></div><div><br></div><div><br></d=
iv><div>On devices where I was already able to reload/trim (previous post f=
or example), I had 0 too before as result, but now I have for example:</div=
><div><br></div><div><div>[g.cecchi@dbatest1 ~]$ for dev in sddt sdef; do g=
rep &quot;&quot; /sys/block/${dev}/queue/discard_granularity; done</div><di=
v>1048576</div><div>1048576</div><div>[g.cecchi@dbatest1 ~]$=C2=A0</div></d=
iv><div><br></div><div>and also</div><div><br></div><div><div>[g.cecchi@dba=
test1 ~]$ cat /sys/block/dm-4/queue/discard_granularity=C2=A0</div><div>104=
8576</div><div>[g.cecchi@dbatest1 ~]$=C2=A0</div></div><div><br></div><div>=
Hope I clarified ....</div><div><br></div><div>I don&#39;t understand thoug=
h what you meant with &#39;check&#39; dm device...</div><div><br></div><div=
>Thanks in advice for any help understanding if this can be the best workfl=
ow to be able to run fstrim without giving downtime, in a safe way.</div><d=
iv><br></div><div>Gianluca</div></div></div>

--001a113fa7daa5ab69053fb0fc2d--


--===============5206870263199105067==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5206870263199105067==--
