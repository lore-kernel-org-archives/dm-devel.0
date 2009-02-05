From: =?ISO-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 20:13:30 +0100
Message-ID: <1a4a774c0902051113u513d9d43sda8278ebaf6899bd@mail.gmail.com>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
	<E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1829778672=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4663975E3@cosmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--===============1829778672==
Content-Type: multipart/alternative; boundary=001636c5b4dd2eeb93046230b3df

--001636c5b4dd2eeb93046230b3df
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Thu, Feb 5, 2009 at 6:37 PM, Moger, Babu <Babu.Moger@lsi.com> wrote:

>
> Like Bryn said, you cannot have both MPP and device mapper together. MPP
> will be the first one to load. So it will claim all the devices.
>
> I have modified your multipath.conf file. Please try this one below.
>
> devices {
>  device {
>                vendor                  "DELL"
>                product                 "MD3000i"
>                 product_blacklist       "Universal Xport"
>                features                "1 queue_if_no_path"
>                path_grouping_policy    group_by_prio
>                     prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
>                    getuid_callout          "/sbin/scsi_id -g -u -s
> /block/%n"
>                 hardware_handler        "1 rdac"
>                path_checker            rdac
>                prio                    "rdac"
>                failback                immediate
>        }
> }
>
> Hi

Thank you for the information.

I changed my multipath.conf to the following:

cat /etc/multipath.conf
defaults {
        udev_dir                /dev
        user_friendly_names     yes
}
blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^sda"
        devnode "^sda[0-9]"
}


devices {
 device {
               vendor                  "DELL"
               product                 "MD Virtual Disk"
               product_blacklist       "Universal Xport"
               features                "1 queue_if_no_path"
               path_grouping_policy    group_by_prio
               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
               hardware_handler        "1 rdac"
               path_checker            rdac
               prio                    "rdac"
               failback                immediate
       }
}


then did:
# multipath -F
# service multipathd restart

Now I get:

# multipath -ll
mpathe (36002219000918b4c00005b6c497e6632) dm-4 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:1  sdi 8:128 [active][ready]
mpathd (36002219000918b3300002e6e497e6315) dm-3 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:2  sdj 8:144 [active][ready]
mpathc (36002219000918b4c00005b6f497e6695) dm-2 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:3  sdk 8:160 [active][ready]
mpathb (36002219000918b3300002e71497e6378) dm-1 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:4  sdl 8:176 [active][ready]
mpatha (36002219000918b4c00005b72497e66f3) dm-0 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:5  sdm 8:192 [active][ready]
mpathl (36002219000918b3300002e6b497e62a6) dm-11 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:0:0  sdb 8:16  [active][ready]
mpathk (36002219000922cdf000004a4497e53f5) dm-10 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:1:10 sdc 8:32  [active][ready]
mpathj (36002219000918b2e000004b2497e581c) dm-9 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:1:11 sdd 8:48  [active][ready]
mpathi (36002219000922cdf000004a7497e54dd) dm-8 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:1:12 sde 8:64  [active][ready]
mpathh (36002219000918b2e000004b5497e587e) dm-7 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:1:13 sdf 8:80  [active][ready]
mpathg (36002219000922cdf000004aa497e5532) dm-6 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:1:14 sdg 8:96  [active][ready]
mpathf (36002219000918b2e000004b8497e58dc) dm-5 DELL,MD Virtual Disk
[size=5.5T][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=6][active]
 \_ 9:0:1:15 sdh 8:112 [active][ready]


Thank you
Christian

--001636c5b4dd2eeb93046230b3df
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Feb 5, 2009 at 6:37 PM, Moger, B=
abu <span dir=3D"ltr">&lt;<a href=3D"mailto:Babu.Moger@lsi.com">Babu.Moger@=
lsi.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padd=
ing-left: 1ex;">
<br>
Like Bryn said, you cannot have both MPP and device mapper together. MPP wi=
ll be the first one to load. So it will claim all the devices.<br>
<br>
I have modified your multipath.conf file. Please try this one below.<br>
<div class=3D"Ih2E3d"><br>
devices {<br>
 &nbsp;device {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;vendor &nbsp; &nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;DELL&quot;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;product &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;MD3000i&quot;<br>
</div><div class=3D"Ih2E3d"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp;product_blacklist &nbsp; &nbsp; &nbsp; &quot;Universal Xport&quot;=
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;features &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;1 queue_if_no_path&quot;=
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;path_grouping_polic=
y &nbsp; &nbsp;group_by_prio<br>
</div> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
;prio_callout &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;/sbin/mpath_pr=
io_rdac /dev/%n&quot;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;getui=
d_callout &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;/sbin/scsi_id -g -u -s /b=
lock/%n&quot;<br>
<div class=3D"Ih2E3d"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;hardware_handler &nbsp; &nbsp; &nbsp; &nbsp;&quot;1 rdac&quot;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;path_checker &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;rdac<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;prio &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&quot;rdac&quot;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;failback &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;immediate<br>
 &nbsp; &nbsp; &nbsp; &nbsp;}<br>
}<br>
<br>
</div></blockquote><div>Hi<br><br>Thank you for the information.<br><br>I c=
hanged my multipath.conf to the following:<br><br>cat /etc/multipath.conf<b=
r>defaults {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; udev_dir&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; /dev<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_na=
mes&nbsp;&nbsp;&nbsp;&nbsp; yes<br>
}<br>blacklist {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quo=
t;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;<br>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; devnode &quot;^hd[a-z]&quot;<br>&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; devnode &quot;^sda&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; devnode &quot;^sda[0-9]&quot;<br>}<br><br><br>
devices {<br>&nbsp;device {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&quot;DELL&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;MD Virtual=
 Disk&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; product_blacklist&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; &quot;Universal Xport&quot;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1 queue_if_no_path&quot;<br>&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; path_grouping_policy&nbsp;&nbsp;&nbsp; group_by_prio<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio_c=
allout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &q=
uot;/sbin/mpath_prio_rdac /dev/%n&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getuid_callout&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/scsi_id -g -u -s=
 /block/%n&quot;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;=
1 rdac&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rdac<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; prio&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; &quot;rdac&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
}<br><br><br>then did:<br># multipath -F<br># service multipathd restart<br=
><br>Now I get:<br><br># multipath -ll<br>mpathe (36002219000918b4c00005b6c=
497e6632) dm-4 DELL,MD Virtual Disk<br>[size=3D5.5T][features=3D1 queue_if_=
no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D6][active]<br>&nbsp;\_ 9:0:0:1&nbsp; sdi 8:128 [ac=
tive][ready]<br>mpathd (36002219000918b3300002e6e497e6315) dm-3 DELL,MD Vir=
tual Disk<br>[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rda=
c]<br>\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 9:0:0:2&nbsp; sdj 8:144 [active][ready]<br>mpathc (36002219000918b=
4c00005b6f497e6695) dm-2 DELL,MD Virtual Disk<br>[size=3D5.5T][features=3D1=
 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [prio=3D6][activ=
e]<br>&nbsp;\_ 9:0:0:3&nbsp; sdk 8:160 [active][ready]<br>
mpathb (36002219000918b3300002e71497e6378) dm-1 DELL,MD Virtual Disk<br>[si=
ze=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-r=
obin 0 [prio=3D6][active]<br>&nbsp;\_ 9:0:0:4&nbsp; sdl 8:176 [active][read=
y]<br>mpatha (36002219000918b4c00005b72497e66f3) dm-0 DELL,MD Virtual Disk<=
br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ roun=
d-robin 0 [prio=3D6][active]<br>&nbsp;\_ 9:0:0:5&nbsp; sdm 8:192 [active][r=
eady]<br>mpathl (36002219000918b3300002e6b497e62a6) dm-11 DELL,MD Virtual D=
isk<br>[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D6][active]<br>&nbsp;\_ 9:0:0:0&nbsp; sdb 8:16&nbsp=
; [active][ready]<br>mpathk (36002219000922cdf000004a4497e53f5) dm-10 DELL,=
MD Virtual Disk<br>[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=
=3D1 rdac]<br>\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 9:0:1:10 sdc 8:32&nbsp; [active][ready]<br>mpathj (36002219000918b=
2e000004b2497e581c) dm-9 DELL,MD Virtual Disk<br>[size=3D5.5T][features=3D1=
 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-robin 0 [prio=3D6][activ=
e]<br>&nbsp;\_ 9:0:1:11 sdd 8:48&nbsp; [active][ready]<br>
mpathi (36002219000922cdf000004a7497e54dd) dm-8 DELL,MD Virtual Disk<br>[si=
ze=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ round-r=
obin 0 [prio=3D6][active]<br>&nbsp;\_ 9:0:1:12 sde 8:64&nbsp; [active][read=
y]<br>mpathh (36002219000918b2e000004b5497e587e) dm-7 DELL,MD Virtual Disk<=
br>
[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>\_ roun=
d-robin 0 [prio=3D6][active]<br>&nbsp;\_ 9:0:1:13 sdf 8:80&nbsp; [active][r=
eady]<br>mpathg (36002219000922cdf000004aa497e5532) dm-6 DELL,MD Virtual Di=
sk<br>[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rdac]<br>
\_ round-robin 0 [prio=3D6][active]<br>&nbsp;\_ 9:0:1:14 sdg 8:96&nbsp; [ac=
tive][ready]<br>mpathf (36002219000918b2e000004b8497e58dc) dm-5 DELL,MD Vir=
tual Disk<br>[size=3D5.5T][features=3D1 queue_if_no_path][hwhandler=3D1 rda=
c]<br>\_ round-robin 0 [prio=3D6][active]<br>
&nbsp;\_ 9:0:1:15 sdh 8:112 [active][ready]<br><br><br>Thank you<br>Christi=
an <br></div></div><br>

--001636c5b4dd2eeb93046230b3df--


--===============1829778672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1829778672==--
