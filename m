From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: how to refresh LV to apply fstrim online
Date: Fri, 21 Oct 2016 01:32:06 +0200
Message-ID: <CAG2kNCztXfyeU7xoT2KuN=YwNwhYj78J7XoriwcOPyBHimG9OQ@mail.gmail.com>
References: <CAG2kNCwwDEeY0jHMvD6JxVb2WFHncY3pRM_Cy=QvAgJxaoa5MA@mail.gmail.com>
	<da58a0be-bdd9-a06d-f1a9-6b8c6e07b052@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7841825092958819659=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <da58a0be-bdd9-a06d-f1a9-6b8c6e07b052@redhat.com>
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

--===============7841825092958819659==
Content-Type: multipart/alternative; boundary=001a1140278c71610e053f5455ec

--001a1140278c71610e053f5455ec
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 20, 2016 at 1:40 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

>
> Hi
>
> Please provide listing of all your 'multipath'  leg devices - are
> they support TRIM ?
> Then 'check' dm device.
>
> See  (and attach)
>
>  grep "" /sys/block/*/queue/discard_granularity
>
>
> Also make sure you are NOT using 'ext2' filesystem which does not support
> discard on RHEL6 and you are on latest available RHEL6 kernel.
>
>
> Regards
>
> Zdenek
>
>
>
Hello,
thanks for answer.
I'm using ext3 filesystem that supports discard.
Currently I'm on this kernel

[root@dbatest1 ~]# uname -r
2.6.32-431.29.2.el6.x86_64
[root@dbatest1 ~]#


It seems that I was myself able to find a way to online refresh the logical
volume and so to successfully run fstrim command against the related file
system, without deactivating the lv and most important without generating
downtime for my users.
Please note that what I'm doing is working on a test system where I have
the same situation as in production.
Can you certify my approach and comment about it, so that I can eventually
apply in production?

At the end the logical volume itself is a dm device.
In my case

current situation:
[root@dbatest1 ~]# fstrim /ALM/rdoffline
fstrim: /ALM/rdoffline: FITRIM ioctl failed: Operation not supported
[root@dbatest1 ~]#

[root@dbatest1 ~]# ll /dev/VG_ALMTEST_RDOF/LV_ALMTEST_RDOF
lrwxrwxrwx 1 root root 7 Oct 20 10:39 /dev/VG_ALMTEST_RDOF/LV_ALMTEST_RDOF
-> ../dm-4
[root@dbatest1 ~]#

So I can "manipulate" it with dmsetup command.

[root@dbatest1 ~]# dmsetup info /dev/dm-4
Name:              VG_ALMTEST_RDOF-LV_ALMTEST_RDOF
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      253, 4
Number of targets: 1
UUID: LVM-yOzMkHqmlu9yJuNVWqLVNAx37BwOknEoysZeo9HhzO4P0tETT4WH3RVxNCBeQgRF

[root@dbatest1 ~]#

[root@dbatest1 ~]# dmsetup status /dev/dm-4
0 104849408 linear
[root@dbatest1 ~]#

In practice I work as if I had to resize the device, but specifying the
same table and reloading the dm device.

I save the table into a file
[root@dbatest1 ~]# dmsetup table /dev/dm-4 > my_dm_table
[root@dbatest1 ~]#

I reload the dm device specifying the same table; I read in some doc
references that they tend to suspend the device, before reloading and then
resume, running all the three commands in sequence. I don't know if it is
the best approach....

[root@dbatest1 ~]# dmsetup suspend /dev/dm-4 ; dmsetup reload /dev/dm-4
my_dm_table ; dmsetup resume /dev/dm-4
[root@dbatest1 ~]# echo $?
0
[root@dbatest1 ~]#

And now the magic:

[root@dbatest1 ~]# fstrim /ALM/rdoffline
[root@dbatest1 ~]# echo $?
0
[root@dbatest1 ~]#

Can you give a feedback?
Thanks,
Gianluca

--001a1140278c71610e053f5455ec
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Thu, Oct 20, 2016 at 1:40 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>=
&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><di=
v><div class=3D"gmail-h5"><br></div></div>
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
Regards<span class=3D"gmail-HOEnZb"><font color=3D"#888888"><br>
<br>
Zdenek<br>
<br>
<br>
</font></span></blockquote></div><br></div><div class=3D"gmail_extra">Hello=
,</div><div class=3D"gmail_extra">thanks for answer.</div><div class=3D"gma=
il_extra">I&#39;m using ext3 filesystem that supports discard.</div><div cl=
ass=3D"gmail_extra">Currently I&#39;m on this kernel</div><div class=3D"gma=
il_extra">=C2=A0</div><div class=3D"gmail_extra"><div class=3D"gmail_extra"=
>[root@dbatest1 ~]# uname -r</div><div class=3D"gmail_extra">2.6.32-431.29.=
2.el6.x86_64</div><div class=3D"gmail_extra">[root@dbatest1 ~]#=C2=A0</div>=
<div><br></div><div><br></div><div><div>It seems that I was myself able to =
find a way to online refresh the logical volume and so to successfully run =
fstrim command against the related file system, without deactivating the lv=
 and most important without generating downtime for my users.</div><div>Ple=
ase note that what I&#39;m doing is working on a test system where I have t=
he same situation as in production.</div><div>Can you certify my approach a=
nd comment about it, so that I can eventually apply in production?</div><di=
v><br></div><div>At the end the logical volume itself is a dm device.</div>=
<div>In my case</div><div><br></div><div>current situation:</div><div>[root=
@dbatest1 ~]# fstrim /ALM/rdoffline</div><div>fstrim: /ALM/rdoffline: FITRI=
M ioctl failed: Operation not supported</div><div>[root@dbatest1 ~]#</div><=
div><br></div><div>[root@dbatest1 ~]# ll /dev/VG_ALMTEST_RDOF/LV_ALMTEST_RD=
OF=C2=A0</div><div>lrwxrwxrwx 1 root root 7 Oct 20 10:39 /dev/VG_ALMTEST_RD=
OF/LV_ALMTEST_RDOF -&gt; ../dm-4</div><div>[root@dbatest1 ~]#</div><div><br=
></div><div>So I can &quot;manipulate&quot; it with dmsetup command.</div><=
div><br></div><div>[root@dbatest1 ~]# dmsetup info /dev/dm-4</div><div>Name=
: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0VG_ALMTEST_RDOF-LV_ALMTES=
T_RDOF</div><div>State: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ACTIVE</d=
iv><div>Read Ahead: =C2=A0 =C2=A0 =C2=A0 =C2=A0256</div><div>Tables present=
: =C2=A0 =C2=A0LIVE</div><div>Open count: =C2=A0 =C2=A0 =C2=A0 =C2=A01</div=
><div>Event number: =C2=A0 =C2=A0 =C2=A00</div><div>Major, minor: =C2=A0 =
=C2=A0 =C2=A0253, 4</div><div>Number of targets: 1</div><div>UUID: LVM-yOzM=
kHqmlu9yJuNVWqLVNAx37BwOknEoysZeo9HhzO4P0tETT4WH3RVxNCBeQgRF</div><div><br>=
</div><div>[root@dbatest1 ~]#=C2=A0</div><div><br></div><div>[root@dbatest1=
 ~]# dmsetup status /dev/dm-4</div><div>0 104849408 linear=C2=A0</div><div>=
[root@dbatest1 ~]#</div><div><br></div><div>In practice I work as if I had =
to resize the device, but specifying the same table and reloading the dm de=
vice.</div><div><br></div><div>I save the table into a file</div><div>[root=
@dbatest1 ~]# dmsetup table /dev/dm-4 &gt; my_dm_table</div><div>[root@dbat=
est1 ~]#=C2=A0</div><div><br></div><div>I reload the dm device specifying t=
he same table; I read in some doc references that they tend to suspend the =
device, before reloading and then resume, running all the three commands in=
 sequence. I don&#39;t know if it is the best approach....</div><div><br></=
div><div>[root@dbatest1 ~]# dmsetup suspend /dev/dm-4 ; dmsetup reload /dev=
/dm-4 my_dm_table ; dmsetup resume /dev/dm-4</div><div>[root@dbatest1 ~]# e=
cho $?</div><div>0</div><div>[root@dbatest1 ~]#</div><div><br></div><div>An=
d now the magic:</div><div><br></div><div>[root@dbatest1 ~]# fstrim /ALM/rd=
offline</div><div>[root@dbatest1 ~]# echo $?</div><div>0</div><div>[root@db=
atest1 ~]#=C2=A0</div><div><br></div><div>Can you give a feedback?</div><di=
v>Thanks,</div><div>Gianluca</div></div></div></div>

--001a1140278c71610e053f5455ec--


--===============7841825092958819659==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7841825092958819659==--
