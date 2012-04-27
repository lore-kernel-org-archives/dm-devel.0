From: Adarsh <adarshanto@gmail.com>
Subject: Re: device mapper / multipath
Date: Fri, 27 Apr 2012 13:43:29 +0530
Message-ID: <CAH2zp-gXgC-i2XWCJdygOCiawVRx58Bzkc3w7uPHqnL6We-PgQ@mail.gmail.com>
References: <CAH2zp-hvdzD+sZWhU1D6NPtDUVnpQ=nkm5-u14zK3aBqF2EKvA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6428299141663702470=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAH2zp-hvdzD+sZWhU1D6NPtDUVnpQ=nkm5-u14zK3aBqF2EKvA@mail.gmail.com>
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

--===============6428299141663702470==
Content-Type: multipart/alternative; boundary=bcaec554001af6a3f504bea4adf6

--bcaec554001af6a3f504bea4adf6
Content-Type: text/plain; charset=ISO-8859-1

Hello,

Please note that when I remove a LUN, I will follow the "Clean Device
Removal"

http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/removing_devices.html

However, sometimes people won't  follow those steps.
I want to handle such scenarios gracefully.

regards,
Adarsh.


On 27 April 2012 12:58, Adarsh <adarshanto@gmail.com> wrote:

> Hello,
>
> I am trying to setup a RH Linux multipath setup with 256 LUNs.
> I am facing an issue.
>
> After deleting a LUN, I am invoking "multipath" command to immediately
> update the MPIO database.
> However, it takes 30-40 minutes mostly.
> Kindly advice how I can reduce the time taken to a few minutes at the max.
>
> Also, how often does multipathd update the MPIO database.
> Basically, I am trying to remove the stale LUN as soon as possible from
> the database (say 5-8 seconds)
> Is there any way to ensure/force that.
>
> Any help will be really appreciated.
>
> regards,
> Adarsh.
>
>
> Setup:
> =====
> RHEL 5.6 (Linux x336-207-59 2.6.18-238.9.1.el5)
> Multipath tools: 0.4.7
>
> multipath.conf:
> ============
> defaults {
>         user_friendly_names     no
>         max_fds                max
>         queue_without_daemon   no
>         pg_prio_calc           avg
>         flush_on_last_del      yes
> }
>
> blacklist {
>         wwid                   SIBM-ESXSMAW3073NC_FDAR9P6402P4G
>         wwid                   SIBM-ESXSMAW3073NC_FDAR9P6402PU9
>         devnode                "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode                "^hd[a-z]"
>         devnode                "^cciss.*"
> }
>
> devices {
>         device {
>                 vendor "NETAPP"
>                 product "LUN"
>                 getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
>                 prio_callout "/sbin/mpath_prio_alua /dev/%n"
>                 hardware_handler "0"
>                 failback immediate
>                 flush_on_last_del yes
>         }
> }
>

--bcaec554001af6a3f504bea4adf6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_extra">Hello,</div><div class=3D"gmail_extra"><br></div=
><div class=3D"gmail_extra">Please note that when I remove a LUN, I will fo=
llow the &quot;Clean Device Removal&quot;</div><div class=3D"gmail_extra"><=
p class=3D"MsoNormal">
<a href=3D"http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5/htm=
l/Online_Storage_Reconfiguration_Guide/removing_devices.html">http://docs.r=
edhat.com/docs/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfi=
guration_Guide/removing_devices.html</a><span style=3D"color:#1f497d"></spa=
n></p>
</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Howev=
er, sometimes people won&#39;t =A0follow those steps.</div><div class=3D"gm=
ail_extra">I want to handle such scenarios gracefully.</div><div class=3D"g=
mail_extra">
<br></div><div class=3D"gmail_extra">regards,</div><div class=3D"gmail_extr=
a">Adarsh.</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quot=
e">On 27 April 2012 12:58, Adarsh <span dir=3D"ltr">&lt;<a href=3D"mailto:a=
darshanto@gmail.com" target=3D"_blank">adarshanto@gmail.com</a>&gt;</span> =
wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hello,<div><br></div><div><span>I am trying =
to setup a RH Linux multipath setup with 256 LUNs.</span></div><div><span>I=
 am facing an issue.</span></div>
<div><span><br></span></div><div><span>After deleting a LUN, I am invoking =
&quot;multipath&quot; command to immediately update the MPIO database.</spa=
n></div>
<div><span>However, it takes 30-40 minutes mostly.</span></div><div><font c=
olor=3D"#222222" face=3D"arial, sans-serif">Kindly advice how I can reduce =
the time taken to a few minutes at the max.</font></div><div><font color=3D=
"#222222" face=3D"arial, sans-serif"><br>

</font></div><div><font color=3D"#222222" face=3D"arial, sans-serif">Also, =
how often does multipathd update the MPIO database.</font></div><div><font =
color=3D"#222222" face=3D"arial, sans-serif">Basically, I am trying to remo=
ve the stale LUN as soon as possible from the database (say 5-8 seconds)</f=
ont></div>

<div><font color=3D"#222222" face=3D"arial, sans-serif">Is there any way to=
 ensure/force that.</font></div><div><font color=3D"#222222" face=3D"arial,=
 sans-serif"><br></font></div><div><font color=3D"#222222" face=3D"arial, s=
ans-serif">Any help will be really appreciated.</font></div>

<div><font color=3D"#222222" face=3D"arial, sans-serif"><br></font></div><d=
iv><span style=3D"color:rgb(34,34,34);font-family:arial,sans-serif">regards=
,</span></div><div><font color=3D"#222222" face=3D"arial, sans-serif">Adars=
h.</font></div>

<div><font color=3D"#222222" face=3D"arial, sans-serif"><br></font></div><d=
iv><font color=3D"#222222" face=3D"arial, sans-serif"><br></font></div><div=
><font color=3D"#222222" face=3D"arial, sans-serif">Setup:</font></div><div=
><font color=3D"#222222" face=3D"arial, sans-serif">=3D=3D=3D=3D=3D</font><=
/div>

<div><font color=3D"#222222" face=3D"arial, sans-serif">RHEL 5.6 (Linux x33=
6-207-59 2.6.18-238.9.1.el5)</font></div><div><font color=3D"#222222" face=
=3D"arial, sans-serif">Multipath tools: 0.4.7</font></div><div><font color=
=3D"#222222" face=3D"arial, sans-serif"><br>

</font></div><div><font color=3D"#222222" face=3D"arial, sans-serif">multip=
ath.conf:</font></div><div><font color=3D"#222222" face=3D"arial, sans-seri=
f">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</font></div><div><font color=3D"#22=
2222" face=3D"arial, sans-serif"><div>

defaults {</div><div>=A0 =A0 =A0 =A0 user_friendly_names =A0 =A0 no</div><d=
iv>=A0 =A0 =A0 =A0 max_fds =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0max</div><div>=A0=
 =A0 =A0 =A0 queue_without_daemon =A0 no</div><div>=A0 =A0 =A0 =A0 pg_prio_=
calc =A0 =A0 =A0 =A0 =A0 avg</div><div>=A0 =A0 =A0 =A0 flush_on_last_del =
=A0 =A0 =A0yes</div>

<div>}</div><div><br></div><div>blacklist {</div><div>=A0 =A0 =A0 =A0 wwid =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SIBM-ESXSMAW3073NC_FDAR9P6402P4G</div><=
div>=A0 =A0 =A0 =A0 wwid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SIBM-ESXSMAW30=
73NC_FDAR9P6402PU9</div><div>=A0 =A0 =A0 =A0 devnode =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;</div>

<div>=A0 =A0 =A0 =A0 devnode =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quot;^hd[a-z]&=
quot;</div><div>=A0 =A0 =A0 =A0 devnode =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&quo=
t;^cciss.*&quot;</div><div>}</div><div><br></div><div>devices {</div><div>=
=A0 =A0 =A0 =A0 device {</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vendor &=
quot;NETAPP&quot;</div>

<div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 product &quot;LUN&quot;</div><div>=A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 getuid_callout &quot;/sbin/scsi_id -g -u -s /bl=
ock/%n&quot;</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 prio_callout &quot;/=
sbin/mpath_prio_alua /dev/%n&quot;</div><div>

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hardware_handler &quot;0&quot;</div><div>=
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failback immediate</div><div>=A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 flush_on_last_del yes</div><div>=A0 =A0 =A0 =A0 }</div>=
<div>}</div></font></div>
</blockquote></div><br></div>

--bcaec554001af6a3f504bea4adf6--


--===============6428299141663702470==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6428299141663702470==--
