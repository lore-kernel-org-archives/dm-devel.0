From: Jeff Wasilko <jwasilko@ebay.com>
Subject: Tuning suggestions for large systems with many (6000+)
	paths
Date: Thu, 26 Sep 2013 14:19:33 -0400
Message-ID: <3A2A0F51850C264790C6008B7F92D047401AC4A92A@eeyore.ad.e-dialog.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8067125558146125258=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8067125558146125258==
Content-Language: en-US
Content-Type: multipart/related;
	boundary="_004_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_";
	type="multipart/alternative"

--_004_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_
Content-Type: multipart/alternative;
	boundary="_000_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_"

--_000_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello!

We have a 3-node database cluster running Oracle supporting a data warehous=
e application. To get the thruput we need, we have 4 dual-port HBAs, and th=
e hosts are zoned to 8 or 12 array ports. This ends up giving us a huge # o=
f paths for  DM to manage:

root@dbxx [/nfshome/jwasilko ] multipathd paths count
Paths: 6000
Busy: False

We're running OEL 6.3, and:
device-mapper-multipath-libs-0.4.9-64.0.1.el6.x86_64
device-mapper-multipath-0.4.9-64.0.1.el6.x86_64

We've seen issues like high CPU usage when paths return, and we're struggli=
ng to understand why we see a 30 second I/O stall across all paths when one=
 path is failed (by disabling the switch port in the FC switch).

Here's our multipath.conf:

blacklist {        devnode "*"
}
blacklist_exceptions {
        devnode "sd*"
}
defaults {
       user_friendly_names yes
        find_multipaths yes
        fast_io_fail_tmo        1
        dev_loss_tmo            30
        checker_timeout         10
        failback                immediate
        rr_weight               uniform
        no_path_retry           fail
        max_fds                 8192
        path_checker            tur
        #rr_min_io              8
        rr_min_io_rq            8
        polling_interval        5
        path_grouping_policy    multibus
        path_selector           "round-robin 0"
}
devices {
   device {
        vendor                  "VIOLIN"
        product                 "SAN ARRAY"
        path_grouping_policy    group_by_serial
        getuid_callout          "/sbin/scsi_id --whitelisted --replace-whit=
espace --page=3D0x80 --device=3D/dev/%n"
        features                "1 queue_if_no_path"
        hardware_handler        "0"
        }
   device {
        vendor "3PARdata"
          product "VV"
          path_grouping_policy multibus
          path_checker tur
          no_path_retry 12
          features "0"
          hardware_handler "0"
          path_selector   "round-robin 0"
          #path_selector          "queue-length 0"
          rr_weight     uniform
          rr_min_io     100
          failback      immediate
        #  fast_io_fail_tmo 1
        #  dev_loss_tmo 30
        }
}

Thanks,

-jeff

A little more detail on the # of luns we have:


root@dbxx [/nfshome/jwasilko ] multipathd show multipaths status
name                failback  queueing paths dm-st  write_prot
dbxx-data-prd-t2-78 immediate 12 chk   48    active rw
dbxx-data-prd-t1-21 immediate off      32    active rw
dbxx-data-prd-t1-22 immediate off      32    active rw
dbxx-data-prd-t1-23 immediate off      32    active rw
dbxx-data-prd-t1-18 immediate off      32    active rw
dbxx-data-prd-t1-24 immediate off      32    active rw
dbxx-data-prd-t1-19 immediate off      32    active rw
dbxx-data-prd-t1-25 immediate off      32    active rw
dbxx-data-prd-t1-20 immediate off      32    active rw
dbxx-data-prd-t1-27 immediate off      32    active rw
dbxx-data-prd-t1-29 immediate off      32    active rw
dbxx-data-prd-t1-28 immediate off      32    active rw
dbxx-data-prd-t1-30 immediate off      32    active rw
dbxx-data-prd-t1-31 immediate off      32    active rw
dbxx-reco2-1        immediate off      32    active rw
dbxx-reco2-2        immediate off      32    active rw
dbxx-reco2-3        immediate off      32    active rw
dbxx-data-prd-t1-26 immediate off      32    active rw
dbxx-data-prd-t1-17 immediate off      32    active rw
dbxx-reco2-4        immediate off      32    active rw
dbxx-vote-0         immediate 12 chk   48    active rw
dbxx-vote-1         immediate 12 chk   48    active rw
dbxx-vote-2         immediate 12 chk   48    active rw
dbxx-acfs-0         immediate 12 chk   48    active rw
dbxx-acfs-1         immediate 12 chk   48    active rw
dbxx-acfs-2         immediate 12 chk   48    active rw
dbxx-acfs-3         immediate 12 chk   48    active rw
dbxx-acfs-4         immediate 12 chk   48    active rw
dbxx-acfs-5         immediate 12 chk   48    active rw
dbxx-acfs-6         immediate 12 chk   48    active rw
dbxx-acfs-7         immediate 12 chk   48    active rw
dbxx-arch-0         immediate 12 chk   48    active rw
dbxx-arch-1         immediate 12 chk   48    active rw
dbxx-arch-2         immediate 12 chk   48    active rw
dbxx-arch-3         immediate 12 chk   48    active rw
dbxx-arch-4         immediate 12 chk   48    active rw
dbxx-arch-7         immediate 12 chk   48    active rw
dbxx-arch-6         immediate 12 chk   48    active rw
dbxx-data-prd-t2-0  immediate 12 chk   48    active rw
dbxx-arch-5         immediate 12 chk   48    active rw
dbxx-data-prd-t2-1  immediate 12 chk   48    active rw
dbxx-data-prd-t2-2  immediate 12 chk   48    active rw
dbxx-data-prd-t2-4  immediate 12 chk   48    active rw
dbxx-data-prd-t2-3  immediate 12 chk   48    active rw
dbxx-data-prd-t2-5  immediate 12 chk   48    active rw
dbxx-data-prd-t2-6  immediate 12 chk   48    active rw
dbxx-data-prd-t2-7  immediate 12 chk   48    active rw
dbxx-data-prd-t2-8  immediate 12 chk   48    active rw
dbxx-data-prd-t2-9  immediate 12 chk   48    active rw
dbxx-data-prd-t2-10 immediate 12 chk   48    active rw
dbxx-data-prd-t2-11 immediate 12 chk   48    active rw
dbxx-data-prd-t2-12 immediate 12 chk   48    active rw
dbxx-data-prd-t2-13 immediate 12 chk   48    active rw
dbxx-data-prd-t2-14 immediate 12 chk   48    active rw
dbxx-data-prd-t2-15 immediate 12 chk   48    active rw
dbxx-data-prd-t2-16 immediate 12 chk   48    active rw
dbxx-data-prd-t2-17 immediate 12 chk   48    active rw
dbxx-data-prd-t2-19 immediate 12 chk   48    active rw
dbxx-data-prd-t2-18 immediate 12 chk   48    active rw
dbxx-data-prd-t2-20 immediate 12 chk   48    active rw
dbxx-data-prd-t2-22 immediate 12 chk   48    active rw
dbxx-data-prd-t2-21 immediate 12 chk   48    active rw
dbxx-data-prd-t2-23 immediate 12 chk   48    active rw
dbxx-data-prd-t2-24 immediate 12 chk   48    active rw
dbxx-data-prd-t2-25 immediate 12 chk   48    active rw
dbxx-data-prd-t2-26 immediate 12 chk   48    active rw
dbxx-data-prd-t2-27 immediate 12 chk   48    active rw
dbxx-data-prd-t2-28 immediate 12 chk   48    active rw
dbxx-data-prd-t2-29 immediate 12 chk   48    active rw
dbxx-data-prd-t2-31 immediate 12 chk   48    active rw
dbxx-data-prd-t2-32 immediate 12 chk   48    active rw
dbxx-data-prd-t2-30 immediate 12 chk   48    active rw
dbxx-data-prd-t2-33 immediate 12 chk   48    active rw
dbxx-data-prd-t2-34 immediate 12 chk   48    active rw
dbxx-data-prd-t2-35 immediate 12 chk   48    active rw
dbxx-data-prd-t2-36 immediate 12 chk   48    active rw
dbxx-data-prd-t2-39 immediate 12 chk   48    active rw
dbxx-data-prd-t2-37 immediate 12 chk   48    active rw
dbxx-data-prd-t2-38 immediate 12 chk   48    active rw
dbxx-data-prd-t2-40 immediate 12 chk   48    active rw
dbxx-data-prd-t2-41 immediate 12 chk   48    active rw
dbxx-data-prd-t2-42 immediate 12 chk   48    active rw
dbxx-data-prd-t2-43 immediate 12 chk   48    active rw
dbxx-data-prd-t2-44 immediate 12 chk   48    active rw
dbxx-data-prd-t2-45 immediate 12 chk   48    active rw
dbxx-data-prd-t2-46 immediate 12 chk   48    active rw
dbxx-data-prd-t2-47 immediate 12 chk   48    active rw
dbxx-data-prd-t2-48 immediate 12 chk   48    active rw
dbxx-data-prd-t2-49 immediate 12 chk   48    active rw
dbxx-data-prd-t2-50 immediate 12 chk   48    active rw
dbxx-data-prd-t2-51 immediate 12 chk   48    active rw
dbxx-data-prd-t2-52 immediate 12 chk   48    active rw
dbxx-data-prd-t2-53 immediate 12 chk   48    active rw
dbxx-data-prd-t2-54 immediate 12 chk   48    active rw
dbxx-data-prd-t2-55 immediate 12 chk   48    active rw
dbxx-data-prd-t2-56 immediate 12 chk   48    active rw
dbxx-data-prd-t2-57 immediate 12 chk   48    active rw
dbxx-data-prd-t2-58 immediate 12 chk   48    active rw
dbxx-data-prd-t2-59 immediate 12 chk   48    active rw
dbxx-data-prd-t2-60 immediate 12 chk   48    active rw
dbxx-data-prd-t2-61 immediate 12 chk   48    active rw
dbxx-data-prd-t2-62 immediate 12 chk   48    active rw
dbxx-data-prd-t2-63 immediate 12 chk   48    active rw
dbxx-data-prd-t2-64 immediate 12 chk   48    active rw
dbxx-data-prd-t2-65 immediate 12 chk   48    active rw
dbxx-data-prd-t2-66 immediate 12 chk   48    active rw
dbxx-data-prd-t2-67 immediate 12 chk   48    active rw
dbxx-data-prd-t2-68 immediate 12 chk   48    active rw
dbxx-data-prd-t2-69 immediate 12 chk   48    active rw
dbxx-data-prd-t2-70 immediate 12 chk   48    active rw
dbxx-data-prd-t2-71 immediate 12 chk   48    active rw
dbxx-data-prd-t2-72 immediate 12 chk   48    active rw
dbxx-data-prd-t2-73 immediate 12 chk   48    active rw
dbxx-data-prd-t2-74 immediate 12 chk   48    active rw
dbxx-data-prd-t2-75 immediate 12 chk   48    active rw
dbxx-data-prd-t2-76 immediate 12 chk   48    active rw
dbxx-data-prd-t2-77 immediate 12 chk   48    active rw
dbxx-data-prd-t2-79 immediate 12 chk   48    active rw
dbxx-data-prd-t1-10 immediate off      32    active rw
dbxx-data-prd-t1-11 immediate off      32    active rw
dbxx-data-prd-t1-12 immediate off      32    active rw
dbxx-data-prd-t1-13 immediate off      32    active rw
dbxx-data-prd-t1-14 immediate off      32    active rw
dbxx-data-prd-t1-15 immediate off      32    active rw
dbxx-data-prd-t1-16 immediate off      32    active rw
dbxx-reco1-1        immediate off      32    active rw
dbxx-reco1-2        immediate off      32    active rw
dbxx-reco1-3        immediate off      32    active rw
dbxx-data-prd-t1-03 immediate off      32    active rw
dbxx-data-prd-t1-06 immediate off      32    active rw
dbxx-data-prd-t1-04 immediate off      32    active rw
dbxx-data-prd-t1-01 immediate off      32    active rw
dbxx-data-prd-t1-02 immediate off      32    active rw
dbxx-data-prd-t1-08 immediate off      32    active rw
dbxx-reco1-4        immediate off      32    active rw
dbxx-data-prd-t1-05 immediate off      32    active rw
dbxx-data-prd-t1-07 immediate off      32    active rw
dbxx-data-prd-t1-09 immediate off      32    active rw


--
Jeff Wasilko
Technical Architect, EEMS Platform Ops

eBay Enterprise
781 372 4992   M 781 820 0882   F 781 863 8118
jwasilko@ebay.com   ebayenterprise.com

[cid:image001.gif@01CEBAC1.6E2BECF0]


________________________________
The information contained in this electronic mail transmission is intended =
only for the use of the individual or entity named in this transmission. If=
 you are not the intended recipient of this transmission, you are hereby no=
tified that any disclosure, copying or distribution of the contents of this=
 transmission is strictly prohibited and that you should delete the content=
s of this transmission from your system immediately. Any comments or statem=
ents contained in this transmission do not necessarily reflect the views or=
 position of eBay Enterprise. or its subsidiaries and/or affiliates.

--_000_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:m=3D"http://schema=
s.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html=
40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-priority:99;
	mso-style-link:"Balloon Text";
	font-family:"Tahoma","sans-serif";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hello!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We have a 3-node database cluster running Oracle sup=
porting a data warehouse application. To get the thruput we need, we have 4=
 dual-port HBAs, and the hosts are zoned to 8 or 12 array ports. This ends =
up giving us a huge # of paths for
 &nbsp;DM to manage:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">root@dbxx [/nfshome/jwasilko ] multipathd paths count<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">Paths: 6000<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">Busy: False<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal">We&#8217;re running OEL 6.3, and:<o:p></o:p></p>
<p class=3D"MsoNormal">device-mapper-multipath-libs-0.4.9-64.0.1.el6.x86_64=
<o:p></o:p></p>
<p class=3D"MsoNormal">device-mapper-multipath-0.4.9-64.0.1.el6.x86_64<o:p>=
</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">We&#8217;ve seen issues like high CPU usage when pat=
hs return, and we&#8217;re struggling to understand why we see a 30 second =
I/O stall across all paths when one path is failed (by disabling the switch=
 port in the FC switch).<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Here&#8217;s our multipath.conf:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">blacklist {&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; devnode &quot;*&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">}<o:p></o:p></p>
<p class=3D"MsoNormal">blacklist_exceptions {<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &=
quot;sd*&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">}<o:p></o:p></p>
<p class=3D"MsoNormal">defaults {<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_n=
ames yes<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; find_mult=
ipaths yes<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fast_io_f=
ail_tmo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dev_loss_=
tmo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 30<o:=
p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; checker_t=
imeout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; immediate<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_weight=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; uniform<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_r=
etry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fail<o:p><=
/o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; max_fds&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 8192<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_chec=
ker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tur<o=
:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #rr_min_i=
o&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 8<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_min_io=
_rq&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8<o:p=
></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; polling_i=
nterval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grou=
ping_policy&nbsp;&nbsp;&nbsp; multibus<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_sele=
ctor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;roun=
d-robin 0&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">}<o:p></o:p></p>
<p class=3D"MsoNormal">devices {<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp; device {<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; &quot;VIOLIN&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; &quot;SAN ARRAY&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grou=
ping_policy&nbsp;&nbsp;&nbsp; group_by_serial<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getuid_ca=
llout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;/sbin/scs=
i_id --whitelisted --replace-whitespace --page=3D0x80 --device=3D/dev/%n&qu=
ot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; features&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; &quot;1 queue_if_no_path&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; hardware_=
handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;0&quot;<o:p></o:p><=
/p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o=
:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp; device {<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor &q=
uot;3PARdata&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; product &quot;VV&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; path_grouping_policy multibus<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; path_checker tur<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; no_path_retry 12<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; features &quot;0&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; hardware_handler &quot;0&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; path_selector&nbsp;&nbsp; &quot;round-robin 0&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; #path_selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &qu=
ot;queue-length 0&quot;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; rr_weight&nbsp;&nbsp;&nbsp;&nbsp; uniform<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; rr_min_io&nbsp;&nbsp;&nbsp; &nbsp;100<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; immediate<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #&nbsp; f=
ast_io_fail_tmo 1<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #&nbsp; d=
ev_loss_tmo 30<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o=
:p></p>
<p class=3D"MsoNormal">}<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks, <o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">-jeff<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">A little more detail on the # of luns we have:<o:p><=
/o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">root@dbxx [/nfshome/jwasilko ] multipathd show multipaths s=
tatus<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback&nbsp; queueing paths dm-st&nbs=
p; write_prot<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-78 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-21 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-22 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-23 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-18 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-24 immediate off &nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-19 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-25 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-20 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-27 immediate off&nbsp;&nbsp;&nbsp;&nbsp; &=
nbsp;32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-29 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-28 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-30 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-31 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco2-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco2-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco2-3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-26 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-17 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco2-4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-vote-0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-vote-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-vote-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-2 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-6&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp=
;immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-acfs-7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-0&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-arch-5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-1&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-2&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-4&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-3&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-5&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-6&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-7&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-8&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-9&nbsp; immediate 12 chk&nbsp;&nbsp; 48&nb=
sp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-10 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-11 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-12 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-13 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-14 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-15 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-16 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-17 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-19 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-18 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-20 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-22 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-21 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-23 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-24 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-25 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-26 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-27 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-28 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-29 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-31 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-32 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-30 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-33 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-34 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-35 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-36 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-39 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-37 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-38 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-40 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-41 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-42 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-43 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-44 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-45 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-46 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-47 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-48 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-49 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-50 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-51 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-52 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-53 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-54 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-55 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-56 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-57 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-58 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-59 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-60 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-61 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-62 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-63 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-64 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-65 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-66 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-67 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-68 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-69 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-70 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-71 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-72 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-73 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-74 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-75 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-76 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-77 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t2-79 immediate 12 chk&nbsp;&nbsp; 48&nbsp;&n=
bsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-10 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-11 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-12 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-13 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-14 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-15 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-16 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco1-1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco1-2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco1-3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-03 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-06 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-04 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-01 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-02 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-08 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-reco1-4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; imme=
diate off&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-05 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-07 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Cou=
rier New&quot;">dbxx-data-prd-t1-09 immediate off&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 32&nbsp;&nbsp;&nbsp; active rw&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"line-height:120%;text-autospace:none;vertic=
al-align:middle">
<span style=3D"font-size:12.0pt;line-height:120%;font-family:&quot;Arial&qu=
ot;,&quot;sans-serif&quot;">--<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:120%;text-autospace:none;vertic=
al-align:middle">
<span style=3D"font-size:12.0pt;line-height:120%;font-family:&quot;Arial&qu=
ot;,&quot;sans-serif&quot;">Jeff Wasilko<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:120%;text-autospace:none;vertic=
al-align:middle">
<span style=3D"font-size:10.0pt;line-height:120%;font-family:&quot;Arial&qu=
ot;,&quot;sans-serif&quot;;color:#58595B">Technical Architect, EEMS Platfor=
m Ops<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:120%;text-autospace:none;vertic=
al-align:middle">
<span style=3D"font-size:10.0pt;line-height:120%;font-family:&quot;Arial&qu=
ot;,&quot;sans-serif&quot;;color:#58595B"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:120%;text-autospace:none;vertic=
al-align:middle">
<span style=3D"font-size:10.0pt;line-height:120%;font-family:&quot;Arial&qu=
ot;,&quot;sans-serif&quot;;color:#58595B">eBay Enterprise<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal" style=3D"line-height:120%;text-autospace:none;vertic=
al-align:middle">
<span style=3D"font-size:10.0pt;line-height:120%;font-family:&quot;Arial&qu=
ot;,&quot;sans-serif&quot;;color:#58595B">781 372 4992&nbsp;&nbsp; M 781 82=
0 0882&nbsp;&nbsp; F 781 863 8118&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:120%;text-autospace:none;vertic=
al-align:middle">
<span style=3D"font-size:10.0pt;line-height:120%;font-family:&quot;Arial&qu=
ot;,&quot;sans-serif&quot;;color:#58595B">jwasilko@ebay.com&nbsp;&nbsp; eba=
yenterprise.com<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Arial&quot;,&quot;s=
ans-serif&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:&quot;Arial&quot;,&quot;s=
ans-serif&quot;"><img width=3D"190" height=3D"70" id=3D"Picture_x0020_4" sr=
c=3D"cid:image001.gif@01CEBAC1.6E2BECF0" alt=3D"logo-email.gif"><o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
<br>
<hr>
<font face=3D"Arial" color=3D"Black" size=3D"2">The information contained i=
n this electronic mail transmission is intended only for the use of the ind=
ividual or entity named in this transmission. If you are not the intended r=
ecipient of this transmission, you are
 hereby notified that any disclosure, copying or distribution of the conten=
ts of this transmission is strictly prohibited and that you should delete t=
he contents of this transmission from your system immediately. Any comments=
 or statements contained in this
 transmission do not necessarily reflect the views or position of eBay Ente=
rprise. or its subsidiaries and/or affiliates.<br>
</font>
</body>
</html>

--_000_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_--

--_004_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_
Content-Type: image/gif; name="image001.gif"
Content-Description: image001.gif
Content-Disposition: inline; filename="image001.gif"; size=3926;
	creation-date="Thu, 26 Sep 2013 18:19:33 GMT";
	modification-date="Thu, 26 Sep 2013 18:19:33 GMT"
Content-ID: <image001.gif@01CEBAC1.6E2BECF0>
Content-Transfer-Encoding: base64

R0lGODlhvgBGAMQAAPn8/jSE2+ry+8bc9SR62FOW4Yi36hlz1mik5HOq5gpq1EWO3pvC7aPH76vM
8PX5/dzq+eLt+pK97LLQ8rzW8wNm09Lj9/H2/czg9tbm+BFu1X6w6AZo01+e4wBk0v///yH/C1hN
UCBEYXRhWE1QPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtj
OWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUg
WE1QIENvcmUgNS4wLWMwNjAgNjEuMTM0Nzc3LCAyMDEwLzAyLzEyLTE3OjMyOjAwICAgICAgICAi
PiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5
bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXBNTT0iaHR0
cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9i
ZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFk
b2JlLmNvbS94YXAvMS4wLyIgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8x
LjEvIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InV1aWQ6NUQyMDg5MjQ5M0JGREIxMTkxNEE4
NTkwRDMxNTA4QzgiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NTg1MkRDNkJEOEY3MTFFMkFG
N0FDRjdFQTNCNEYxMjYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NTg1MkRDNkFEOEY3MTFF
MkFGN0FDRjdFQTNCNEYxMjYiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgSWxsdXN0cmF0b3IgQ1M1
Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InV1aWQ6YzM5YWZlNTAtMzJl
ZS00MmE0LWJlNjktMjAwZTU3NDRjNjRhIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjNGMjA1
RTcyQTVDRkUyMTFCNTZFQjhFQjdBMjg4M0E3Ii8+IDxkYzp0aXRsZT4gPHJkZjpBbHQ+IDxyZGY6
bGkgeG1sOmxhbmc9IngtZGVmYXVsdCI+ZWJheV9lbnRlcnByaXNlX3ZlcnRfdG1fcmdiPC9yZGY6
bGk+IDwvcmRmOkFsdD4gPC9kYzp0aXRsZT4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4g
PC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4B//79/Pv6+fj39vX08/Lx8O/u7ezr6uno
5+bl5OPi4eDf3t3c29rZ2NfW1dTT0tHQz87NzMvKycjHxsXEw8LBwL++vby7urm4t7a1tLOysbCv
rq2sq6qpqKempaSjoqGgn56dnJuamZiXlpWUk5KRkI+OjYyLiomIh4aFhIOCgYB/fn18e3p5eHd2
dXRzcnFwb25tbGtqaWhnZmVkY2JhYF9eXVxbWllYV1ZVVFNSUVBPTk1MS0pJSEdGRURDQkFAPz49
PDs6OTg3NjU0MzIxMC8uLSwrKikoJyYlJCMiISAfHh0cGxoZGBcWFRQTEhEQDw4NDAsKCQgHBgUE
AwIBAAAh+QQAAAAAACwAAAAAvgBGAAAF/+AnjmRpfhOnrdbpvnAsz3Rt33heO17vYbqgcEgsGoc8
H/DIbDqfUFOyt4xar9jsafrTer9gI7caLpvPW18XzW43L5H4xTUuwSECgO0hgEQED26CWA8OCAEH
CooHAR0TeiN1HxgJiIoaBB0OkCcAEwgLBxqXBAsJQBgMDasUNA+rDQytg7QMBGq4PQQTkWoWAgUV
uT4BvCYTAcNqFR0MHD4aEDMSagy0gg8duBwH3cJqCSJTHLY+FQoaz7gbJdTLmIm4BMk+4TEPtz0B
nNdoBWoEJGS48OCCBQMH1LCbcq7HAQMYBPRxsGDdCArfPFRAgIEgnAkVfajroSFCDHc9Gv/0a4PS
Q4E5JiKE1GhhQq4CAk44U2Psnw+VJ7T5UAAOBj5i/FaGuZDPQ4BALiIk7FHAppoFSUkwULMPQAAN
oha8kEpsqoeSL1o6UIqGy1oYG6AZUKOgBQyfPXhd2EsQxkxTRU8wJcYWjVAPBKC+GGBuwcgCMiio
QfCi4F4BFwAcDgDBLFoTLY0VLkPPKYUJqFOrnrBTV0YJMgSYDTACQKoOCwIQ6CZqxUgCH+bWM3G0
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

--_004_3A2A0F51850C264790C6008B7F92D047401AC4A92Aeeyoreadedial_--


--===============8067125558146125258==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8067125558146125258==--
