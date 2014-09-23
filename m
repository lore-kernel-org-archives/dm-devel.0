From: Ali Poursamadi <ali@firstperson.is>
Subject: Re: DM-Multipath limiting IO to 127.000 MB/Sec
Date: Tue, 23 Sep 2014 12:56:37 -0700
Message-ID: <CAAPTtDqHcPR-icrueadhf2e3YHTMsuEZ+1t8PBk4MGbte22xmg@mail.gmail.com>
References: <CAAPTtDr2K8eb0H+iBVoKGOyK25uOVz2DD9p9gdZcW2rVUg=BpA@mail.gmail.com>
	<499e7a9fb338440eb125c65daa1dd4a4@hioexcmbx08-prd.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7578813488632195142=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <499e7a9fb338440eb125c65daa1dd4a4@hioexcmbx08-prd.hq.netapp.com>
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

--===============7578813488632195142==
Content-Type: multipart/alternative; boundary=047d7b34340c137de00503c0f7d3

--047d7b34340c137de00503c0f7d3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks ShivaKrishna,

max_sectors_kb , max_segments, max_segment_size is identical on both sdx-s
and the relevan dm-x device and are as follows :
max_sectors_kb : 512
max_segments : 1024
max_segment_size :  65536

I did the iostat tests, turns out that average Request Size show close
readings ( 244,251 for dm-x, sdx respectively ) but the Average Queue Size
is close to 1.9 for sdx vs 1.1 for dm-x and also the device utilization
(%util) is ~99% on sd-x vs ~60% on dm-xx. It seems that dm multipath is
under-utilizing the underlaying devices.
is there a way to change this behavior ?

-Ali Poursamadi





On Tue, Sep 23, 2014 at 7:45 AM, Merla, ShivaKrishna <
ShivaKrishna.Merla@netapp.com> wrote:

> > Hi Gurus,
>
> > I'm experiencing an issue with DM-Multipath on Centos 6.5.
> > DD reads 2.5 times faster when reading from a device directly compared
> to Multipath-ed device.
> > I'm using device-mapper-multipath-0.4.9-72.el6_5.2.x86_64.
> > Apparently Multipath is limiting throughput to 127.000 MB/s even though
> the underlying device is capable of more throughput which to me it looks
> like a software imposed limit.
>
> > [root@JS2 ~]# multipath -l mpathaf
> > mpathaf (--------) dm-89 Rorke,G4S-16L-4F8
> > size=3D7.3T features=3D'0' hwhandler=3D'0' wp=3Drw
> > `-+- policy=3D'round-robin 0' prio=3D0 status=3Dactive
> >   |- 0:0:0:1  sdb  8:16   active undef running
> >   |- 0:0:10:2 sdbb 67:80  active undef running
> >   |- 1:0:11:1 sddl 71:48  active undef running
> >   `- 1:0:12:2 sddp 71:112 active undef running
>
> > [root@JS2 ~]#dd if=3D/dev/sddl of=3D/dev/null bs=3D128k count=3D32000 s=
kip=3D14000
> > 32000+0 records in
> > 32000+0 records out
> > 4194304000 bytes (4.2 GB) copied, 11.8166 s, 355 MB/s
>
> > [root@JS2 ~]# dd if=3D/dev/dm-89 of=3D/dev/null bs=3D128k count=3D32000
> skip=3D84000 # skipping 2GB array cache data
> > 32000+0 records in
> > 32000+0 records out
> > 4194304000 bytes (4.2 GB) copied, 31.4959 s, 133 MB/s
>
>
> > This is on a machine connected over 2x8Gb/s links to a fiber switch and
> then to an HDX4 disk array, exporting the volume to 2 of it's 4 8Gbps fib=
er
> ports .
>
> > Multipath.conf looks like this :
> >
> > defaults {
> >         user_friendly_names yes
> > }
>
> > devices {
> >
> >        device { # normal HDX4 Disk arrays
> >                vendor "Rorke"
> >                product "G4S-16L-4F8"
> >                path_grouping_policy multibus
> >             }
> >
> > }
>
> > blacklist {
> > #blacklisting almost everything
> >         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
> >         devnode "^hd[a-z][0-9]*"
> > }
>
> Check the request queue parameters for both dm and sd devices. Parameters
> that could affect this are
>
> #cat /sys/block/<dm-x>/queue/max_sectors_kb
> #cat /sys/block/<dm-x>/queue/max_segments
> #cat /sys/block/<dm-x>/queue/max_segment_size
>
> #cat /sys/block/<sdx>/queue/max_sectors_kb
> #cat /sys/block/<sdx>/queue/max_segments
> #cat /sys/block/<sdx>/queue/max_segment_size
>
> You can monitor the average request size(avgrq-sz) on both dm and sd
> device using
> #iostat =E2=80=93xm =E2=80=93d /dev/dm-x /dev/sdx =E2=80=93t 2
>
> Compare this with the request size while running I/O only sd device
> directly. There was a patch to fix
> block stacking limits on dm devices upstream.
>
>
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel




--=20

[image: First Person Logo] <http://firstperson.is/>

[image: Signature]

[image: Facebook]
<https://www.facebook.com/pages/First-Person/677554662257977>[image:
LinkedIn]  <http://www.linkedin.com/company/first-person>[image: Twitter]
<https://twitter.com/FirstPersonsf>

--047d7b34340c137de00503c0f7d3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><br></div><div>Thanks ShivaKrishna,<br></di=
v><div><br></div><div>max_sectors_kb , max_segments, max_segment_size is id=
entical on both sdx-s and the relevan dm-x device and are as follows : <br>=
</div>max_sectors_kb : 512<br>max_segments : 1024<br>max_segment_size :=C2=
=A0 65536<br></div><div><br>I did the iostat tests, turns out that average =
Request Size show close readings ( 244,251 for dm-x, sdx respectively ) but=
 the Average Queue Size is close to 1.9 for sdx vs 1.1 for dm-x and also th=
e device utilization (%util) is ~99% on sd-x vs ~60% on dm-xx. It seems tha=
t dm multipath is under-utilizing the underlaying devices.<br></div><div>is=
 there a way to change this behavior ? <br><br></div><div>-Ali Poursamadi<b=
r><br></div></div><div><div><div><div><div><br><br><br></div></div></div></=
div></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">O=
n Tue, Sep 23, 2014 at 7:45 AM, Merla, ShivaKrishna <span dir=3D"ltr">&lt;<=
a href=3D"mailto:ShivaKrishna.Merla@netapp.com" target=3D"_blank">ShivaKris=
hna.Merla@netapp.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><div class=3D"HOEnZb"><div class=3D"h5">&gt; Hi Gurus,<br>
<br>
&gt; I&#39;m experiencing an issue with DM-Multipath on Centos 6.5.<br>
&gt; DD reads 2.5 times faster when reading from a device directly compared=
 to Multipath-ed device.<br>
&gt; I&#39;m using=C2=A0device-mapper-multipath-0.4.9-72.el6_5.2.x86_64.<br=
>
&gt; Apparently Multipath is limiting throughput to 127.000 MB/s even thoug=
h the=C2=A0underlying=C2=A0device is capable of more throughput which to me=
 it looks like a software imposed limit.=C2=A0<br>
<br>
&gt; [root@JS2 ~]# multipath -l mpathaf<br>
&gt; mpathaf (--------) dm-89 Rorke,G4S-16L-4F8<br>
&gt; size=3D7.3T features=3D&#39;0&#39; hwhandler=3D&#39;0&#39; wp=3Drw<br>
&gt; `-+- policy=3D&#39;round-robin 0&#39; prio=3D0 status=3Dactive<br>
&gt; =C2=A0 |- 0:0:0:1 =C2=A0sdb =C2=A08:16 =C2=A0 active undef running<br>
&gt; =C2=A0 |- 0:0:10:2 sdbb 67:80 =C2=A0active undef running<br>
&gt; =C2=A0 |- 1:0:11:1 sddl 71:48 =C2=A0active undef running<br>
&gt; =C2=A0 `- 1:0:12:2 sddp 71:112 active undef running<br>
<br>
&gt; [root@JS2 ~]#dd if=3D/dev/sddl of=3D/dev/null bs=3D128k count=3D32000 =
skip=3D14000<br>
&gt; 32000+0 records in<br>
&gt; 32000+0 records out<br>
&gt; <a href=3D"tel:4194304000" value=3D"+14194304000">4194304000</a>=C2=A0=
bytes (4.2 GB) copied, 11.8166 s, 355 MB/s<br>
<br>
&gt; [root@JS2 ~]# dd if=3D/dev/dm-89 of=3D/dev/null bs=3D128k count=3D3200=
0 skip=3D84000 # skipping 2GB array cache data=C2=A0<br>
&gt; 32000+0 records in<br>
&gt; 32000+0 records out<br>
&gt; <a href=3D"tel:4194304000" value=3D"+14194304000">4194304000</a>=C2=A0=
bytes (4.2 GB) copied, 31.4959 s, 133 MB/s<br>
<br>
<br>
&gt; This is on a machine connected over 2x8Gb/s links to a fiber switch an=
d then to an HDX4 disk array, exporting the volume to 2 of it&#39;s 4 8Gbps=
 fiber ports .=C2=A0<br>
<br>
&gt; Multipath.conf looks like this :=C2=A0<br>
&gt;<br>
&gt; defaults {<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 user_friendly_names yes<br>
&gt; }<br>
=C2=A0<br>
&gt; devices {<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 device { # normal HDX4 Disk arrays<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vendor &quot;Ro=
rke&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 product &quot;G=
4S-16L-4F8&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 path_grouping_p=
olicy multibus<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
&gt;<br>
&gt; }<br>
=C2=A0<br>
&gt; blacklist {<br>
&gt; #blacklisting almost everything<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 devnode &quot;^(ram|raw|loop|fd|md|dm-|sr|=
scd|st)[0-9]*&quot;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 devnode &quot;^hd[a-z][0-9]*&quot;<br>
&gt; }<br>
<br>
</div></div>Check the request queue parameters for both dm and sd devices. =
Parameters that could affect this are<br>
<br>
#cat /sys/block/&lt;dm-x&gt;/queue/max_sectors_kb<br>
#cat /sys/block/&lt;dm-x&gt;/queue/max_segments<br>
#cat /sys/block/&lt;dm-x&gt;/queue/max_segment_size<br>
<br>
#cat /sys/block/&lt;sdx&gt;/queue/max_sectors_kb<br>
#cat /sys/block/&lt;sdx&gt;/queue/max_segments<br>
#cat /sys/block/&lt;sdx&gt;/queue/max_segment_size<br>
<br>
You can monitor the average request size(avgrq-sz) on both dm and sd device=
 using<br>
#iostat =E2=80=93xm =E2=80=93d /dev/dm-x /dev/sdx =E2=80=93t 2<br>
<br>
Compare this with the request size while running I/O only sd device directl=
y. There was a patch to fix<br>
block stacking limits on dm devices upstream.<br>
<br>
<br>
<br>
<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a></blockquote></div>=
<br><br clear=3D"all"><br>-- <br><div dir=3D"ltr"><br><table><tbody><tr><td=
></td></tr></tbody></table><table style=3D"font-family:Helvetica,&#39;Trebu=
chet MS&#39;,sans-serif;font-size:9pt"><tbody><tr><td style=3D"vertical-ali=
gn:top"><p><a href=3D"http://firstperson.is/" style=3D"border:none;text-dec=
oration:none" target=3D"_blank"><img src=3D"http://westernized.com/email_as=
sets/fp_email_sig-fp_logo-2x.png" width=3D"40px" height=3D"44px" alt=3D"Fir=
st Person Logo" border=3D"0" style=3D"border:none;margin-right:20px"></a></=
p></td><td style=3D"vertical-align:top"><p><img src=3D"http://westernized.c=
om/email_assets/signatures/fp_email_sig-ali_poursamadi-2x.png" width=3D"320=
px" height=3D"154px" alt=3D"Signature" border=3D"0"></p><p><a href=3D"https=
://www.facebook.com/pages/First-Person/677554662257977" style=3D"border:non=
e;text-decoration:none" target=3D"_blank"><img src=3D"http://westernized.co=
m/email_assets/fp_email_sig-facebook-2x.png" width=3D"22px" height=3D"22px"=
 alt=3D"Facebook" border=3D"0">=C2=A0</a><a href=3D"http://www.linkedin.com=
/company/first-person" style=3D"border:none;text-decoration:none" target=3D=
"_blank"><img src=3D"http://westernized.com/email_assets/fp_email_sig-linke=
din-2x.png" width=3D"22px" height=3D"22px" alt=3D"LinkedIn" border=3D"0">=
=C2=A0</a><a href=3D"https://twitter.com/FirstPersonsf" style=3D"border:non=
e;text-decoration:none" target=3D"_blank"><img src=3D"http://westernized.co=
m/email_assets/fp_email_sig-twitter-2x.png" width=3D"22px" height=3D"22px" =
alt=3D"Twitter" border=3D"0"></a></p></td></tr></tbody></table></div>
</div>

--047d7b34340c137de00503c0f7d3--


--===============7578813488632195142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7578813488632195142==--
