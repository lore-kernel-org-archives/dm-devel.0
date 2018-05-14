From: Pankaj Agarwal <pankaj@releasemanager.in>
Subject: Re: how to set higher then 128 nr_requests on LV's
Date: Mon, 14 May 2018 19:57:48 -0400
Message-ID: <CAHJ=Of=YHV6eK3wFRmUh2=bb+d7V5D=ac8kVcm4G6nrzG28DJw@mail.gmail.com>
References: <CAHJ=Ofm_j2B6TeNZR_1GZk40L_fiAqMT=umehupKSnNd+ZHY2A@mail.gmail.com>
	<20180514161312.GA14685@redhat.com> <20180514175354.GA15053@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1089423544212304932=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180514175354.GA15053@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

--===============1089423544212304932==
Content-Type: multipart/alternative; boundary="000000000000c6effa056c334073"

--000000000000c6effa056c334073
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hannes,

While you are working on the feature code, is there a sequence of system
commands I can use ?

thanks,

Pankaj



On Mon, May 14, 2018 at 1:53 PM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, May 14 2018 at 12:13pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
> > On Sun, May 13 2018 at  8:47pm -0400,
> > Pankaj Agarwal <pankaj@releasemanager.in> wrote:
> >
> > >    Hi,
> > >    How do i set the nr_request value for LV's as it's not writable
> like other
> > >    drives on a linux system.
> > >    LV's are set as dm-0 and dm-1 on my system.
> > >     #cat /sys/block/dm-0/queue/nr_requests
> > >    128
> > >    # echo 256 > /sys/block/dm-0/queue/nr_requests
> > >    -bash: echo: write error: Invalid argument
> >
> > In the block layer, bio-based devices cannot have their nr_requests
> > changed, see: block/blk-sysfs.c:queue_requests_store()
> >
> > So any bio-based DM device (e.g. linear target) won't be allowed to
> > change nr_requests.
> >
> > The only way to change this would be from the bottom up:
> > 1) change the underlying request-based device(s) (e.g. /dev/sda)
> > 2) dmsetup suspend + dmsetup resume any bio-based DM device(s) that are
> >    stacked ontop of the request-based device(s) you changed in 1)
> >    -- this will restack the queue_limits from the bottom up; so the DM
> >    device will then reflect the underlying devices' limits.
>
> I was mistaken.  DM core (in the kernel) will only restack the
> queue_limits (nr_requests included) if a new DM table is loaded.
>
> So a simple suspend+resume will _not_ change the bio-based DM device's
> queue_limits:
>
> [root@thegoat ~]# lsblk /dev/nullb0
> NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> nullb0 253:0    0  250G  0 disk
> =E2=94=94=E2=94=80foo  252:0    0  250G  0 dm
> [root@thegoat ~]# cat /sys/block/nullb0/queue/nr_requests
> 128
> [root@thegoat ~]# cat /sys/block/dm-0/queue/nr_requests
> 128
> [root@thegoat ~]# echo 64 > /sys/block/nullb0/queue/nr_requests
> [root@thegoat ~]# cat /sys/block/nullb0/queue/nr_requests
> 64
> [root@thegoat ~]# cat /sys/block/dm-0/queue/nr_requests
> 128
> [root@thegoat ~]# dmsetup suspend foo
> [root@thegoat ~]# dmsetup resume foo
> [root@thegoat ~]# cat /sys/block/dm-0/queue/nr_requests
> 128
>
> There was some related work started in this area by Hannes (now cc'd)
> during LSF last month.  He added a chain-notifier to DM devices so that
> if any underlying devices (devices referenced in a DM device's table)
> were changed then the enture device stack would have its limits
> reloaded.
>
> Not sure where Hannes ended up with that.  Would love to get it polished
> now and staged for 4.18 inclusion.
>
> Hannes?
>

--000000000000c6effa056c334073
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hannes,<div><br></div><div>While you are working on the fe=
ature code, is there a sequence of system commands I can use ?</div><div><b=
r></div><div>thanks,</div><div><br></div><div>Pankaj</div><div><br></div><d=
iv><br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote=
">On Mon, May 14, 2018 at 1:53 PM, Mike Snitzer <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:snitzer@redhat.com" target=3D"_blank">snitzer@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Mon,=
 May 14 2018 at 12:13pm -0400,<br>
Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com">snitzer@redhat.com</=
a>&gt; wrote:<br>
<br>
&gt; On Sun, May 13 2018 at=C2=A0 8:47pm -0400,<br>
&gt; Pankaj Agarwal &lt;<a href=3D"mailto:pankaj@releasemanager.in">pankaj@=
releasemanager.in</a>&gt; wrote:<br>
&gt; <br>
&gt; &gt;=C2=A0 =C2=A0 Hi,<br>
&gt; &gt;=C2=A0 =C2=A0 How do i set the nr_request value for LV&#39;s as it=
&#39;s not writable like other<br>
&gt; &gt;=C2=A0 =C2=A0 drives on a linux system.<br>
&gt; &gt;=C2=A0 =C2=A0 LV&#39;s are set as dm-0 and dm-1 on my system.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0#cat /sys/block/dm-0/queue/nr_<wbr>requests<br=
>
&gt; &gt;=C2=A0 =C2=A0 128<br>
&gt; &gt;=C2=A0 =C2=A0 # echo 256 &gt; /sys/block/dm-0/queue/nr_<wbr>reques=
ts<br>
&gt; &gt;=C2=A0 =C2=A0 -bash: echo: write error: Invalid argument<br>
&gt; <br>
&gt; In the block layer, bio-based devices cannot have their nr_requests<br=
>
&gt; changed, see: block/blk-sysfs.c:queue_<wbr>requests_store()<br>
&gt; <br>
&gt; So any bio-based DM device (e.g. linear target) won&#39;t be allowed t=
o<br>
&gt; change nr_requests.<br>
&gt; <br>
&gt; The only way to change this would be from the bottom up:<br>
&gt; 1) change the underlying request-based device(s) (e.g. /dev/sda)<br>
&gt; 2) dmsetup suspend + dmsetup resume any bio-based DM device(s) that ar=
e<br>
&gt;=C2=A0 =C2=A0 stacked ontop of the request-based device(s) you changed =
in 1)<br>
&gt;=C2=A0 =C2=A0 -- this will restack the queue_limits from the bottom up;=
 so the DM<br>
&gt;=C2=A0 =C2=A0 device will then reflect the underlying devices&#39; limi=
ts.<br>
<br>
</span>I was mistaken.=C2=A0 DM core (in the kernel) will only restack the<=
br>
queue_limits (nr_requests included) if a new DM table is loaded.<br>
<br>
So a simple suspend+resume will _not_ change the bio-based DM device&#39;s<=
br>
queue_limits:<br>
<br>
[root@thegoat ~]# lsblk /dev/nullb0<br>
NAME=C2=A0 =C2=A0MAJ:MIN RM=C2=A0 SIZE RO TYPE MOUNTPOINT<br>
nullb0 253:0=C2=A0 =C2=A0 0=C2=A0 250G=C2=A0 0 disk<br>
=E2=94=94=E2=94=80foo=C2=A0 252:0=C2=A0 =C2=A0 0=C2=A0 250G=C2=A0 0 dm<br>
[root@thegoat ~]# cat /sys/block/nullb0/queue/nr_<wbr>requests<br>
128<br>
[root@thegoat ~]# cat /sys/block/dm-0/queue/nr_<wbr>requests<br>
128<br>
[root@thegoat ~]# echo 64 &gt; /sys/block/nullb0/queue/nr_<wbr>requests<br>
[root@thegoat ~]# cat /sys/block/nullb0/queue/nr_<wbr>requests<br>
64<br>
[root@thegoat ~]# cat /sys/block/dm-0/queue/nr_<wbr>requests<br>
128<br>
[root@thegoat ~]# dmsetup suspend foo<br>
[root@thegoat ~]# dmsetup resume foo<br>
[root@thegoat ~]# cat /sys/block/dm-0/queue/nr_<wbr>requests<br>
128<br>
<br>
There was some related work started in this area by Hannes (now cc&#39;d)<b=
r>
during LSF last month.=C2=A0 He added a chain-notifier to DM devices so tha=
t<br>
if any underlying devices (devices referenced in a DM device&#39;s table)<b=
r>
were changed then the enture device stack would have its limits<br>
reloaded.<br>
<br>
Not sure where Hannes ended up with that.=C2=A0 Would love to get it polish=
ed<br>
now and staged for 4.18 inclusion.<br>
<br>
Hannes?<br>
</blockquote></div><br></div>

--000000000000c6effa056c334073--


--===============1089423544212304932==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1089423544212304932==--
