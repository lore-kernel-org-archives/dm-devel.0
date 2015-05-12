From: "BK, GirishKumar" <GirishKumar.BK@netapp.com>
Subject: Writes going to source device in write-back mode
Date: Tue, 12 May 2015 13:36:16 +0000
Message-ID: <D177FFA7.18BDB%GirishKumar.BK@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1161560119258936846=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1161560119258936846==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D177FFA718BDBGirishKumarBKnetappcom_"

--_000_D177FFA718BDBGirishKumarBKnetappcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

I have observed (via iostat) dm-cache is writing to source device also in w=
rite back mode (equivalent to IOS going to cache device) even though cache =
is filled with 25% cache size.

Any explanation as to why this behavior when it is expected that none of th=
e IOS (random 4 K writes) should be going to source device in write back mo=
de?

Thanks,
#Girish_BK

Here are test parameters:
RHEL: 7.0 (3.19 kernel)
Dm-cache policy set to 'write back' and cache block size set to 32K.

0 16384000 cache 8 637/2048000 64 17/256000 189 84 84 524204 0 17 0 1 write=
back 2 migration_threshold 2048 mq 10 random_threshold 4 sequential_thresho=
ld 512 discard_promote_adjustment 1 read_promote_adjustment 4 write_promote=
_adjustment 8

Test run was with fio: Random 4K write (100%)




--_000_D177FFA718BDBGirishKumarBKnetappcom_
Content-Type: text/html; charset="iso-8859-1"
Content-ID: <C5DAA546F40471458AE066759CABD2BF@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-lin=
e-break: after-white-space; color: rgb(0, 0, 0); font-size: 14px; font-fami=
ly: Calibri, sans-serif;">
<div>Hi,</div>
<div><br>
</div>
<div>I have observed (via iostat) dm-cache is writing to source device also=
 in write back mode (equivalent to IOS going to cache device) even though c=
ache is filled with 25% cache size.</div>
<div><br>
</div>
<div>Any explanation as to why this behavior when it is expected that none =
of the IOS (random 4 K writes) should be going to source device in write ba=
ck mode?</div>
<div><br>
</div>
<div>Thanks,</div>
<div>#Girish_BK</div>
<div><br>
</div>
<div><b><u>Here are test parameters:</u></b></div>
<div>RHEL: 7.0 (3.19 kernel)</div>
<div>Dm-cache policy set to &#8216;write back&#8217; and cache block size s=
et to 32K.</div>
<div><br>
</div>
<div><span style=3D"color: rgb(31, 73, 125); font-size: 15px;">0 16384000 c=
ache 8 637/2048000 64 17/256000 189 84 84 524204 0 17 0 1 writeback 2 migra=
tion_threshold 2048 mq 10 random_threshold 4 sequential_threshold 512 disca=
rd_promote_adjustment 1 read_promote_adjustment
 4 write_promote_adjustment 8</span></div>
<div><br>
</div>
<div>Test run was with fio: Random 4K write (100%) &nbsp;</div>
<div><br>
</div>
<div><br>
</div>
<br>
</body>
</html>

--_000_D177FFA718BDBGirishKumarBKnetappcom_--


--===============1161560119258936846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1161560119258936846==--
