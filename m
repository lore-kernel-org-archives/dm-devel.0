From: Qinling <mail.qinling@huawei.com>
Subject: bcache performance test problem
Date: Thu, 24 May 2012 01:14:01 +0000
Message-ID: <205C8BB0A6FD70439409355AE09A1FC629172FA3@szxeml509-mbx>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)"
Return-path: <dm-devel-bounces@redhat.com>
Content-language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "koverstreet@google.com" <koverstreet@google.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Lizefan <lizefan@huawei.com>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Keliang <kernel.ke@huawei.com>
List-Id: dm-devel.ids


--Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)
Content-type: multipart/alternative;
	boundary="Boundary_(ID_sJ1twyAUhTErGUEX8MGTmA)"


--Boundary_(ID_sJ1twyAUhTErGUEX8MGTmA)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT

Hi Kent,

I have tested bcache on my platform, but the result is not good. I think maybe the wrong config caused it. Would you pls help me to check the config, or give me some advice for bcache performance testing?

My SSD card is  a PCIe SSD card (about 120,000 IOPS), and I used 10GB.

I have download the code from git://evilpiepirate.org/~kent/linux-bcache.git.
The commands creating bcache is below:
make-bcache -B /dev/sdb8
make-bcache -C -w4k -b1M -writeback /dev/hioa5

I use FIO to test the seq./random IO performance, and the result is below:
write             read                    randwrite    randread
bcache               10809 KB/s    164502.5 KB/s     2713 KB/s    29640 KB/s
cache_hit_rate  80                  79                         94                92


And the basic test result is:
Write                   read                  randwrite             randread
HDD      81211.6 KB/s       172242 KB/s     2606 KB/s             1855 KB/s
SSD       250948.2 KB/s     813855 KB/s     238892.7 KB/s      657319.5 KB/s


--Boundary_(ID_sJ1twyAUhTErGUEX8MGTmA)
Content-type: text/html; charset=us-ascii
Content-transfer-encoding: 7BIT

<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">
<meta name="Generator" content="Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:\5B8B\4F53;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@\5B8B\4F53";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext="edit" spidmax="1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext="edit">
<o:idmap v:ext="edit" data="1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang="ZH-CN" link="blue" vlink="purple" style="text-justify-trim:punctuation">
<div class="WordSection1">
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">Hi Kent,<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">I have tested bcache on my platform, but the result is not good. I think maybe the wrong config caused it. Would you pls help me to check the config, or give me some advice for bcache
 performance testing?<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">My SSD card is &nbsp;a PCIe SSD card (about 120,000 IOPS), and I used 10GB.<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">I have download the code from git://evilpiepirate.org/~kent/linux-bcache.git.<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">The commands creating bcache is below:<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">make-bcache &#8211;B /dev/sdb8<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">make-bcache &#8211;C &#8211;w4k &#8211;b1M &#8211;writeback /dev/hioa5
<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">I use FIO to test the seq./random IO performance, and the result is below:<o:p></o:p></span></p>
<p class="MsoNormal" style="text-indent:84.0pt"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">write&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;read&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;randwrite&nbsp;&nbsp;&nbsp; randread<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">bcache&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10809 KB/s&nbsp; &nbsp;&nbsp;164502.5 KB/s&nbsp;&nbsp;&nbsp;&nbsp; 2713 KB/s&nbsp;&nbsp;&nbsp; 29640 KB/s<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">cache_hit_rate&nbsp; 80&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;79&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;94&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;92<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">And the basic test result is:<o:p></o:p></span></p>
<p class="MsoNormal" style="text-indent:42.0pt"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">Write &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;read&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; randwrite&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;randread<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">HDD&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 81211.6 KB/s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 172242 KB/s&nbsp;&nbsp;&nbsp;&nbsp; 2606 KB/s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;1855 KB/s<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt;color:#1F497D">SSD&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 250948.2 KB/s&nbsp;&nbsp;&nbsp;&nbsp; 813855 KB/s&nbsp;&nbsp;&nbsp;&nbsp; 238892.7 KB/s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 657319.5 KB/s<o:p></o:p></span></p>
<p class="MsoNormal"><span lang="EN-US" style="font-size:12.0pt"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--Boundary_(ID_sJ1twyAUhTErGUEX8MGTmA)--

--Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)
Content-type: application/octet-stream; name=test-write.sh
Content-transfer-encoding: base64
Content-disposition: attachment; filename=test-write.sh; size=1197;
	creation-date="Tue, 22 May 2012 02:48:16 GMT";
	modification-date="Tue, 22 May 2012 02:48:16 GMT"
Content-description: test-write.sh

W2dsb2JhbF0KZGlyZWN0PTEKYnM9NGsKYmE9NGsKaW9lbmdpbmU9bGliYWlvCmRpcmVjdG9yeT0v
bW50CmlvZGVwdGg9MjU2Cmdyb3VwX3JlcG9ydGluZwojaW9kZXB0aF9iYXRjaD02NAoKCltmaWxl
MV0Kcnc9d3JpdGUKZmlsZW5hbWU9ZmlsZTEKZmlsZXNpemU9NzUwTQpzaXplPTc1ME0KbnVtam9i
cz0xCiAKW2ZpbGUyXQpydz13cml0ZQpmaWxlbmFtZT1maWxlMgpmaWxlc2l6ZT03NTBNCnNpemU9
NzUwTQpudW1qb2JzPTEKCltmaWxlM10Kcnc9d3JpdGUKZmlsZW5hbWU9ZmlsZTMKZmlsZXNpemU9
NzUwTQpzaXplPTc1ME0KbnVtam9icz0xCgpbZmlsZTRdCnJ3PXdyaXRlCmZpbGVuYW1lPWZpbGU0
CmZpbGVzaXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9MQoKW2ZpbGU1XQpydz13cml0ZQpmaWxl
bmFtZT1maWxlNQpmaWxlc2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlNl0Kcnc9
d3JpdGUKZmlsZW5hbWU9ZmlsZTYKZmlsZXNpemU9NzUwTQpzaXplPTc1ME0KbnVtam9icz0xCiAK
W2ZpbGU3XQpydz13cml0ZQpmaWxlbmFtZT1maWxlNwpmaWxlc2l6ZT03NTBNCnNpemU9NzUwTQpu
dW1qb2JzPTEKCltmaWxlOF0Kcnc9d3JpdGUKZmlsZW5hbWU9ZmlsZTgKZmlsZXNpemU9NzUwTQpz
aXplPTc1ME0KbnVtam9icz0xCgpbZmlsZTldCnJ3PXdyaXRlCmZpbGVuYW1lPWZpbGU5CmZpbGVz
aXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9MQoKW2ZpbGUxMF0Kcnc9d3JpdGUKZmlsZW5hbWU9
ZmlsZTEwCmZpbGVzaXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9MQoKW2ZpbGUxMV0Kcnc9d3Jp
dGUKZmlsZW5hbWU9ZmlsZTExCmZpbGVzaXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9MQogCltm
aWxlMTJdCnJ3PXdyaXRlCmZpbGVuYW1lPWZpbGUxMgpmaWxlc2l6ZT03NTBNCnNpemU9NzUwTQpu
dW1qb2JzPTEKCltmaWxlMTNdCnJ3PXdyaXRlCmZpbGVuYW1lPWZpbGUxMwpmaWxlc2l6ZT03NTBN
CnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlMTRdCnJ3PXdyaXRlCmZpbGVuYW1lPWZpbGUxNApm
aWxlc2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlMTVdCnJ3PXdyaXRlCmZpbGVu
YW1lPWZpbGUxNQpmaWxlc2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlMTZdCnJ3
PXdyaXRlCmZpbGVuYW1lPWZpbGUxNgpmaWxlc2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEK

--Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)
Content-type: application/octet-stream; name=test-read.sh
Content-transfer-encoding: base64
Content-disposition: attachment; filename=test-read.sh; size=1180;
	creation-date="Tue, 22 May 2012 02:48:16 GMT";
	modification-date="Tue, 22 May 2012 02:48:16 GMT"
Content-description: test-read.sh

W2dsb2JhbF0KZGlyZWN0PTEKYnM9NGsKYmE9NGsKaW9lbmdpbmU9bGliYWlvCmRpcmVjdG9yeT0v
bW50CmlvZGVwdGg9MjU2Cmdyb3VwX3JlcG9ydGluZwojaW9kZXB0aF9iYXRjaD02NAoKW2ZpbGUx
XQpydz1yZWFkCmZpbGVuYW1lPWZpbGUxCmZpbGVzaXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9
MQogCltmaWxlMl0Kcnc9cmVhZApmaWxlbmFtZT1maWxlMgpmaWxlc2l6ZT03NTBNCnNpemU9NzUw
TQpudW1qb2JzPTEKCltmaWxlM10Kcnc9cmVhZApmaWxlbmFtZT1maWxlMwpmaWxlc2l6ZT03NTBN
CnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlNF0Kcnc9cmVhZApmaWxlbmFtZT1maWxlNApmaWxl
c2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlNV0Kcnc9cmVhZApmaWxlbmFtZT1m
aWxlNQpmaWxlc2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlNl0Kcnc9cmVhZApm
aWxlbmFtZT1maWxlNgpmaWxlc2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEKIApbZmlsZTdd
CnJ3PXJlYWQKZmlsZW5hbWU9ZmlsZTcKZmlsZXNpemU9NzUwTQpzaXplPTc1ME0KbnVtam9icz0x
CgpbZmlsZThdCnJ3PXJlYWQKZmlsZW5hbWU9ZmlsZTgKZmlsZXNpemU9NzUwTQpzaXplPTc1ME0K
bnVtam9icz0xCgpbZmlsZTldCnJ3PXJlYWQKZmlsZW5hbWU9ZmlsZTkKZmlsZXNpemU9NzUwTQpz
aXplPTc1ME0KbnVtam9icz0xCgpbZmlsZTEwXQpydz1yZWFkCmZpbGVuYW1lPWZpbGUxMApmaWxl
c2l6ZT03NTBNCnNpemU9NzUwTQpudW1qb2JzPTEKCltmaWxlMTFdCnJ3PXJlYWQKZmlsZW5hbWU9
ZmlsZTExCmZpbGVzaXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9MQogCltmaWxlMTJdCnJ3PXJl
YWQKZmlsZW5hbWU9ZmlsZTEyCmZpbGVzaXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9MQoKW2Zp
bGUxM10Kcnc9cmVhZApmaWxlbmFtZT1maWxlMTMKZmlsZXNpemU9NzUwTQpzaXplPTc1ME0KbnVt
am9icz0xCgpbZmlsZTE0XQpydz1yZWFkCmZpbGVuYW1lPWZpbGUxNApmaWxlc2l6ZT03NTBNCnNp
emU9NzUwTQpudW1qb2JzPTEKCltmaWxlMTVdCnJ3PXJlYWQKZmlsZW5hbWU9ZmlsZTE1CmZpbGVz
aXplPTc1ME0Kc2l6ZT03NTBNCm51bWpvYnM9MQoKW2ZpbGUxNl0Kcnc9cmVhZApmaWxlbmFtZT1m
aWxlMTYKZmlsZXNpemU9NzUwTQpzaXplPTc1ME0KbnVtam9icz0xCg==

--Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)
Content-type: application/octet-stream; name=test-randwrite-1.2g.sh
Content-transfer-encoding: base64
Content-disposition: attachment; filename=test-randwrite-1.2g.sh; size=1244;
	creation-date="Tue, 22 May 2012 02:48:16 GMT";
	modification-date="Tue, 22 May 2012 02:48:16 GMT"
Content-description: test-randwrite-1.2g.sh

W2dsb2JhbF0KZGlyZWN0PTEKYnM9NGsKYmE9NGsKaW9lbmdpbmU9bGliYWlvCmRpcmVjdG9yeT0v
bW50CmlvZGVwdGg9MjU2Cmdyb3VwX3JlcG9ydGluZwojaW9kZXB0aF9iYXRjaD02NAoKW2ZpbGUx
XQpydz1yYW5kd3JpdGUKZmlsZW5hbWU9ZmlsZTEKZmlsZXNpemU9NzUwTQpzaXplPTc1TQpudW1q
b2JzPTEKIApbZmlsZTJdCnJ3PXJhbmR3cml0ZQpmaWxlbmFtZT1maWxlMgpmaWxlc2l6ZT03NTBN
CnNpemU9NzVNCm51bWpvYnM9MQoKW2ZpbGUzXQpydz1yYW5kd3JpdGUKZmlsZW5hbWU9ZmlsZTMK
ZmlsZXNpemU9NzUwTQpzaXplPTc1TQpudW1qb2JzPTEKCltmaWxlNF0Kcnc9cmFuZHdyaXRlCmZp
bGVuYW1lPWZpbGU0CmZpbGVzaXplPTc1ME0Kc2l6ZT03NU0KbnVtam9icz0xCgpbZmlsZTVdCnJ3
PXJhbmR3cml0ZQpmaWxlbmFtZT1maWxlNQpmaWxlc2l6ZT03NTBNCnNpemU9NzVNCm51bWpvYnM9
MQoKW2ZpbGU2XQpydz1yYW5kd3JpdGUKZmlsZW5hbWU9ZmlsZTYKZmlsZXNpemU9NzUwTQpzaXpl
PTc1TQpudW1qb2JzPTEKIApbZmlsZTddCnJ3PXJhbmR3cml0ZQpmaWxlbmFtZT1maWxlNwpmaWxl
c2l6ZT03NTBNCnNpemU9NzVNCm51bWpvYnM9MQoKW2ZpbGU4XQpydz1yYW5kd3JpdGUKZmlsZW5h
bWU9ZmlsZTgKZmlsZXNpemU9NzUwTQpzaXplPTc1TQpudW1qb2JzPTEKCltmaWxlOV0Kcnc9cmFu
ZHdyaXRlCmZpbGVuYW1lPWZpbGU5CmZpbGVzaXplPTc1ME0Kc2l6ZT03NU0KbnVtam9icz0xCgpb
ZmlsZTEwXQpydz1yYW5kd3JpdGUKZmlsZW5hbWU9ZmlsZTEwCmZpbGVzaXplPTc1ME0Kc2l6ZT03
NU0KbnVtam9icz0xCgpbZmlsZTExXQpydz1yYW5kd3JpdGUKZmlsZW5hbWU9ZmlsZTExCmZpbGVz
aXplPTc1ME0Kc2l6ZT03NU0KbnVtam9icz0xCiAKW2ZpbGUxMl0Kcnc9cmFuZHdyaXRlCmZpbGVu
YW1lPWZpbGUxMgpmaWxlc2l6ZT03NTBNCnNpemU9NzVNCm51bWpvYnM9MQoKW2ZpbGUxM10Kcnc9
cmFuZHdyaXRlCmZpbGVuYW1lPWZpbGUxMwpmaWxlc2l6ZT03NTBNCnNpemU9NzVNCm51bWpvYnM9
MQoKW2ZpbGUxNF0Kcnc9cmFuZHdyaXRlCmZpbGVuYW1lPWZpbGUxNApmaWxlc2l6ZT03NTBNCnNp
emU9NzVNCm51bWpvYnM9MQoKW2ZpbGUxNV0Kcnc9cmFuZHdyaXRlCmZpbGVuYW1lPWZpbGUxNQpm
aWxlc2l6ZT03NTBNCnNpemU9NzVNCm51bWpvYnM9MQoKW2ZpbGUxNl0Kcnc9cmFuZHdyaXRlCmZp
bGVuYW1lPWZpbGUxNgpmaWxlc2l6ZT03NTBNCnNpemU9NzVNCm51bWpvYnM9MQo=

--Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)
Content-type: application/octet-stream; name=test-randread-1.2g.sh
Content-transfer-encoding: base64
Content-disposition: attachment; filename=test-randread-1.2g.sh; size=1228;
	creation-date="Tue, 22 May 2012 02:48:15 GMT";
	modification-date="Tue, 22 May 2012 02:48:15 GMT"
Content-description: test-randread-1.2g.sh

W2dsb2JhbF0KZGlyZWN0PTEKYnM9NGsKYmE9NGsKaW9lbmdpbmU9bGliYWlvCmRpcmVjdG9yeT0v
bW50CmlvZGVwdGg9MjU2Cmdyb3VwX3JlcG9ydGluZwojaW9kZXB0aF9iYXRjaD02NAoKW2ZpbGUx
XQpydz1yYW5kcmVhZApmaWxlbmFtZT1maWxlMQpmaWxlc2l6ZT03NTBNCnNpemU9NzVNCm51bWpv
YnM9MQogCltmaWxlMl0Kcnc9cmFuZHJlYWQKZmlsZW5hbWU9ZmlsZTIKZmlsZXNpemU9NzUwTQpz
aXplPTc1TQpudW1qb2JzPTEKCltmaWxlM10Kcnc9cmFuZHJlYWQKZmlsZW5hbWU9ZmlsZTMKZmls
ZXNpemU9NzUwTQpzaXplPTc1TQpudW1qb2JzPTEKCltmaWxlNF0Kcnc9cmFuZHJlYWQKZmlsZW5h
bWU9ZmlsZTQKZmlsZXNpemU9NzUwTQpzaXplPTc1TQpudW1qb2JzPTEKCltmaWxlNV0Kcnc9cmFu
ZHJlYWQKZmlsZW5hbWU9ZmlsZTUKZmlsZXNpemU9NzUwTQpzaXplPTc1TQpudW1qb2JzPTEKCltm
aWxlNl0Kcnc9cmFuZHJlYWQKZmlsZW5hbWU9ZmlsZTYKZmlsZXNpemU9NzUwTQpzaXplPTc1TQpu
dW1qb2JzPTEKIApbZmlsZTddCnJ3PXJhbmRyZWFkCmZpbGVuYW1lPWZpbGU3CmZpbGVzaXplPTc1
ME0Kc2l6ZT03NU0KbnVtam9icz0xCgpbZmlsZThdCnJ3PXJhbmRyZWFkCmZpbGVuYW1lPWZpbGU4
CmZpbGVzaXplPTc1ME0Kc2l6ZT03NU0KbnVtam9icz0xCgpbZmlsZTldCnJ3PXJhbmRyZWFkCmZp
bGVuYW1lPWZpbGU5CmZpbGVzaXplPTc1ME0Kc2l6ZT03NU0KbnVtam9icz0xCgpbZmlsZTEwXQpy
dz1yYW5kcmVhZApmaWxlbmFtZT1maWxlMTAKZmlsZXNpemU9NzUwTQpzaXplPTc1TQpudW1qb2Jz
PTEKCltmaWxlMTFdCnJ3PXJhbmRyZWFkCmZpbGVuYW1lPWZpbGUxMQpmaWxlc2l6ZT03NTBNCnNp
emU9NzVNCm51bWpvYnM9MQogCltmaWxlMTJdCnJ3PXJhbmRyZWFkCmZpbGVuYW1lPWZpbGUxMgpm
aWxlc2l6ZT03NTBNCnNpemU9NzVNCm51bWpvYnM9MQoKW2ZpbGUxM10Kcnc9cmFuZHJlYWQKZmls
ZW5hbWU9ZmlsZTEzCmZpbGVzaXplPTc1ME0Kc2l6ZT03NU0KbnVtam9icz0xCgpbZmlsZTE0XQpy
dz1yYW5kcmVhZApmaWxlbmFtZT1maWxlMTQKZmlsZXNpemU9NzUwTQpzaXplPTc1TQpudW1qb2Jz
PTEKCltmaWxlMTVdCnJ3PXJhbmRyZWFkCmZpbGVuYW1lPWZpbGUxNQpmaWxlc2l6ZT03NTBNCnNp
emU9NzVNCm51bWpvYnM9MQoKW2ZpbGUxNl0Kcnc9cmFuZHJlYWQKZmlsZW5hbWU9ZmlsZTE2CmZp
bGVzaXplPTc1ME0Kc2l6ZT03NU0KbnVtam9icz0xCg==

--Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Boundary_(ID_h/t+Tme3+TEeyFaUt2/z0g)--
