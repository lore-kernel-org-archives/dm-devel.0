From: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@netapp.com>
Subject: dm-cache mq policy warmup issue
Date: Mon, 4 Nov 2013 17:22:20 +0000
Message-ID: <9BDA3ECEC2A5454BB4294114677019E131B6C2F9@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1538477234262599722=="
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
To: device-mapper development <dm-devel@redhat.com>
Cc: "Mears, Morgan" <Morgan.Mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

--===============1538477234262599722==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_9BDA3ECEC2A5454BB4294114677019E131B6C2F9SACEXCMBX02PRDh_"

--_000_9BDA3ECEC2A5454BB4294114677019E131B6C2F9SACEXCMBX02PRDh_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Mike,



I was doing some testing with latest dm-cache code (from 'for-next' branch)=
. I am having difficulty in making the cache to warm-up. I used the below s=
cript to read range of blocks repeatedly to get them promoted. I assume aft=
er reading a block for mq->promote_threshold + 4 times, a block will be pro=
moted. But it is not happening. I also tested the same with the sequential_=
threshold set to very high value.



Cache warming-up was relatively easier in the previous dm-cache code. Is th=
is something you have seen in your testing?. Is there anything different sh=
ould I do?



Note: /dev/mapper/mydev is the dm-cache target device. I ran the below scri=
pt with "64k 100 100 0" as argument.

-----------

#!/bin/bash



if [[ $# -lt 4 ]]

then

        echo "Usage: $0 <cache_block_size> <nblocks to promote> <nread of a=
 block> <start_block>"

        exit 1

fi



BSSIZE=3D$1

((TOTAL=3D$2+$4))

HITCNT=3D$3



# Read even numbered blocks

blkcnt=3D$4

while [[ blkcnt -lt $TOTAL ]]

do

        i=3D0

        echo "Reading block $blkcnt $HITCNT times"

        while [[ $i -lt $HITCNT ]]

        do

                dd if=3D/dev/mapper/mydev of=3D/dev/null bs=3D$BSSIZE skip=
=3D$blkcnt count=3D1 conv=3Dnotrunc iflag=3Ddirect 2> /dev/null

                if [[ $? -ne 0 ]]

               then

                        echo "I/O failure. exiting."

                        exit 1

                fi

                ((i=3Di+1))

        done



        ((blkcnt=3Dblkcnt+2))



        PROMOTED=3D$(dmsetup status mydev | awk '{print $11}')

        echo "Promoted blocks so far: $PROMOTED"

done



# Read odd numbered blocks

((blkcnt=3D$4+1))

while [[ blkcnt -lt $TOTAL ]]

do

        i=3D0

        echo "Reading block $blkcnt $HITCNT times"

        while [[ $i -lt $HITCNT ]]

        do

                dd if=3D/dev/mapper/mydev of=3D/dev/null bs=3D$BSSIZE skip=
=3D$blkcnt count=3D1 conv=3Dnotrunc iflag=3Ddirect 2> /dev/null

                if [[ $? -ne 0 ]]

                then

                        echo "I/O failure. exiting."

                        exit 1

                fi

                ((i=3Di+1))

        done



        ((blkcnt=3Dblkcnt+2))



        PROMOTED=3D$(dmsetup status mydev | awk '{print $11}')

        echo "Promoted blocks so far: $PROMOTED"

done

------------



Regards,

Somu.



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Mike Snitzer
Sent: Thursday, October 24, 2013 1:30 PM
To: dm-devel@redhat.com
Cc: Mears, Morgan; Heinz Mauelshagen; Joe Thornber; Mike Snitzer
Subject: [dm-devel] [PATCH 00/24] dm cache: proposed changes for v3.13 merg=
e



The following patches have been published to the 'for-next' branch of the d=
evice-mapper git repository:

git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git



The patches marked as RFC (19-24) could use the most review.  But all revie=
w would be appreciated.



Thanks,

Mike



Heinz Mauelshagen (11):

  dm cache policy mq: return NULL if mq->free list is empty in alloc_entry

  dm cache policy: variable hints support

  dm cache policy: have policy_writeback_work return -ENODATA by default

  dm cache: use is_write_io() in more places

  dm cache: use cell_defer() boolean argument consistently

  dm cache: log error message if dm_kcopyd_copy() fails

  dm cache: use a boolean when setting cache->quiescing

  dm cache: optimize commit_if_needed

  dm cache: add hints policy

  dm cache: add cache block invalidation API

  dm cache policy era: add cache block invalidation support



Joe Thornber (9):

  dm: nest targets used for testing under DM_TEST_TARGETS

  dm space map disk: optimise sm_disk_dec_block

  dm cache policy: remove return from void policy_remove_mapping

  dm cache policy mq: a few small fixes

  dm cache policy mq: implement writeback_work() and mq_{set,clear}_dirty()

  dm cache: be much more aggressive about promoting writes to discarded blo=
cks

  dm cache metadata: return bool from __superblock_all_zeroes

  dm cache metadata: check the metadata version when reading the superblock

  dm cache: add passthrough mode



Mike Snitzer (1):

  dm table: print error on preresume failure



Morgan Mears (3):

  dm cache: support for stackable caching policies

  dm cache: add era policy shim

  dm cache: add trc policy shim



drivers/md/Kconfig                             |  68 ++-

drivers/md/Makefile                            |   9 +-

drivers/md/dm-cache-metadata.c                 | 189 +++++-

drivers/md/dm-cache-metadata.h                 |  28 +-

drivers/md/dm-cache-policy-cleaner.c           |  10 +-

drivers/md/dm-cache-policy-era.c               | 542 +++++++++++++++++

drivers/md/dm-cache-policy-hints.c             | 769 ++++++++++++++++++++++=
+++

drivers/md/dm-cache-policy-internal.h          |  31 +-

drivers/md/dm-cache-policy-mq.c                | 343 ++++++++---

drivers/md/dm-cache-policy-trc.c               | 263 +++++++++

drivers/md/dm-cache-policy.c                   |  66 ++-

drivers/md/dm-cache-policy.h                   |  77 ++-

drivers/md/dm-cache-shim-utils.c               | 217 +++++++

drivers/md/dm-cache-shim-utils.h               |  73 +++

drivers/md/dm-cache-stack-utils.c              | 239 ++++++++

drivers/md/dm-cache-stack-utils.h              |  34 ++

drivers/md/dm-cache-target.c                   | 417 ++++++++++++--

drivers/md/dm-table.c                          |   5 +-

drivers/md/persistent-data/dm-space-map-disk.c |  18 +-

19 files changed, 3167 insertions(+), 231 deletions(-)  create mode 100644 =
drivers/md/dm-cache-policy-era.c  create mode 100644 drivers/md/dm-cache-po=
licy-hints.c

create mode 100644 drivers/md/dm-cache-policy-trc.c  create mode 100644 dri=
vers/md/dm-cache-shim-utils.c  create mode 100644 drivers/md/dm-cache-shim-=
utils.h  create mode 100644 drivers/md/dm-cache-stack-utils.c  create mode =
100644 drivers/md/dm-cache-stack-utils.h



--

1.8.1.4



--

dm-devel mailing list

dm-devel@redhat.com<mailto:dm-devel@redhat.com>

https://www.redhat.com/mailman/listinfo/dm-devel

--_000_9BDA3ECEC2A5454BB4294114677019E131B6C2F9SACEXCMBX02PRDh_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Latha;
	panose-1:2 11 6 4 2 2 2 2 2 4;}
@font-face
	{font-family:Latha;
	panose-1:2 11 6 4 2 2 2 2 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:"Calibri","sans-serif";}
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
<p class=3D"MsoPlainText">Mike,<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">I was doing some testing with latest dm-cache cod=
e (from 'for-next' branch). I am having difficulty in making the cache to w=
arm-up. I used the below script to read range of blocks repeatedly to get t=
hem promoted. I assume after reading
 a block for mq-&gt;promote_threshold &#43; 4 times, a block will be promot=
ed. But it is not happening. I also tested the same with the sequential_thr=
eshold set to very high value.
<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Cache warming-up was relatively easier in the pre=
vious dm-cache code. Is this something you have seen in your testing?. Is t=
here anything different should I do?<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Note: /dev/mapper/mydev is the dm-cache target de=
vice. I ran the below script with &#8220;64k 100 100 0&#8221; as argument.<=
o:p></o:p></p>
<p class=3D"MsoPlainText">-----------<o:p></o:p></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">#!/bin/bash<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">if [[ $# -lt 4 ]]<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">then<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo &quot;Usage: $0 &lt;cach=
e_block_size&gt; &lt;nblocks to promote&gt; &lt;nread of a block&gt; &lt;st=
art_block&gt;&quot;<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; exit 1<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">fi<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">BSSIZE=3D$1<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">((TOTAL=3D$2&#43;$4))<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">HITCNT=3D$3<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"># Read even numbered blocks<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">blkcnt=3D$4<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">while [[ blkcnt -lt $TOTAL ]]<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">do<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i=3D0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo &quot;Reading block $blk=
cnt $HITCNT times&quot;<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while [[ $i -lt $HITCNT ]]<o:=
p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; do<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; dd if=3D/dev/mapper/mydev of=3D/dev/null bs=3D$BSSIZE sk=
ip=3D$blkcnt count=3D1 conv=3Dnotrunc iflag=3Ddirect 2&gt; /dev/null<o:p></=
o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; if [[ $? -ne 0 ]]<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;then<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo &qu=
ot;I/O failure. exiting.&quot;<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; exit 1<o=
:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; fi<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; ((i=3Di&#43;1))<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; done<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ((blkcnt=3Dblkcnt&#43;2))<o:p=
></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PROMOTED=3D$(dmsetup status m=
ydev | awk '{print $11}')<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;echo &quot;Promoted blocks so=
 far: $PROMOTED&quot;<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">done<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"># Read odd numbered blocks<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">((blkcnt=3D$4&#43;1))<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">while [[ blkcnt -lt $TOTAL ]]<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">do<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; i=3D0<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo &quot;Reading block $blk=
cnt $HITCNT times&quot;<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; while [[ $i -lt $HITCNT ]]<o:=
p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; do<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; dd if=3D/dev/mapper/mydev of=3D/dev/null bs=3D$BSSIZE sk=
ip=3D$blkcnt count=3D1 conv=3Dnotrunc iflag=3Ddirect 2&gt; /dev/null<o:p></=
o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; if [[ $? -ne 0 ]]<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; then<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo &qu=
ot;I/O failure. exiting.&quot;<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; exit 1<o=
:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; fi<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; ((i=3Di&#43;1))<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; done<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ((blkcnt=3Dblkcnt&#43;2))<o:p=
></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PROMOTED=3D$(dmsetup status m=
ydev | awk '{print $11}')<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; echo &quot;Promoted blocks so=
 far: $PROMOTED&quot;<o:p></o:p></span></p>
<p class=3D"MsoPlainText"><span style=3D"font-family:&quot;Courier New&quot=
;">done<o:p></o:p></span></p>
<p class=3D"MsoPlainText">------------<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Regards,<o:p></o:p></p>
<p class=3D"MsoPlainText">Somu.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">-----Original Message-----<br>
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On B=
ehalf Of Mike Snitzer<br>
Sent: Thursday, October 24, 2013 1:30 PM<br>
To: dm-devel@redhat.com<br>
Cc: Mears, Morgan; Heinz Mauelshagen; Joe Thornber; Mike Snitzer<br>
Subject: [dm-devel] [PATCH 00/24] dm cache: proposed changes for v3.13 merg=
e</p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">The following patches have been published to the =
'for-next' branch of the device-mapper git repository:<o:p></o:p></p>
<p class=3D"MsoPlainText">git://git.kernel.org/pub/scm/linux/kernel/git/dev=
ice-mapper/linux-dm.git<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">The patches marked as RFC (19-24) could use the m=
ost review.&nbsp; But all review would be appreciated.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Thanks,<o:p></o:p></p>
<p class=3D"MsoPlainText">Mike<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Heinz Mauelshagen (11):<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache policy mq: return NULL if mq-&gt;=
free list is empty in alloc_entry<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache policy: variable hints support<o:=
p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache policy: have policy_writeback_wor=
k return -ENODATA by default<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: use is_write_io() in more places=
<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: use cell_defer() boolean argumen=
t consistently<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: log error message if dm_kcopyd_c=
opy() fails<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: use a boolean when setting cache=
-&gt;quiescing<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: optimize commit_if_needed<o:p></=
o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: add hints policy<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: add cache block invalidation API=
<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache policy era: add cache block inval=
idation support<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Joe Thornber (9):<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm: nest targets used for testing under DM=
_TEST_TARGETS<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm space map disk: optimise sm_disk_dec_bl=
ock<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache policy: remove return from void p=
olicy_remove_mapping<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache policy mq: a few small fixes<o:p>=
</o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache policy mq: implement writeback_wo=
rk() and mq_{set,clear}_dirty()<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: be much more aggressive about pr=
omoting writes to discarded blocks<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache metadata: return bool from __supe=
rblock_all_zeroes<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache metadata: check the metadata vers=
ion when reading the superblock<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: add passthrough mode<o:p></o:p><=
/p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Mike Snitzer (1):<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm table: print error on preresume failure=
<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">Morgan Mears (3):<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: support for stackable caching po=
licies<o:p></o:p></p>
<p class=3D"MsoPlainText">&nbsp; dm cache: add era policy shim<o:p></o:p></=
p>
<p class=3D"MsoPlainText">&nbsp; dm cache: add trc policy shim<o:p></o:p></=
p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">drivers/md/Kconfig&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 68 &=
#43;&#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/Makefile&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; 9 &=
#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-metadata.c&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; | 189 &#43;&#43;&#43;&#43;&#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-metadata.h&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; |&nbsp; 28 &#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy-cleaner.c&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 10 &#43;-<o:p></o:p=
></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy-era.c&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 542 &=
#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&=
#43;&#43;<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy-hints.c&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 769 &#43;&#43;&=
#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&=
#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy-internal.h&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 31 &#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy-mq.c&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | =
343 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;---<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy-trc.c&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 263 &=
#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy.c&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; |&nbsp; 66 &#43;&#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-policy.h&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; |&nbsp; 77 &#43;&#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-shim-utils.c&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 217 &=
#43;&#43;&#43;&#43;&#43;&#43;&#43;<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-shim-utils.h&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;=
 73 &#43;&#43;&#43;<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-stack-utils.c&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 239 &#43;&=
#43;&#43;&#43;&#43;&#43;&#43;&#43;<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-stack-utils.h&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp; 34 &=
#43;&#43;<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-cache-target.c&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; | 417 &#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&=
#43;--<o:p></o:p></p>
<p class=3D"MsoPlainText">drivers/md/dm-table.c&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |&nbsp;&nbsp; 5 &#43;-<o:p>=
</o:p></p>
<p class=3D"MsoPlainText">drivers/md/persistent-data/dm-space-map-disk.c |&=
nbsp; 18 &#43;-<o:p></o:p></p>
<p class=3D"MsoPlainText">19 files changed, 3167 insertions(&#43;), 231 del=
etions(-)&nbsp; create mode 100644 drivers/md/dm-cache-policy-era.c&nbsp; c=
reate mode 100644 drivers/md/dm-cache-policy-hints.c<o:p></o:p></p>
<p class=3D"MsoPlainText">create mode 100644 drivers/md/dm-cache-policy-trc=
.c&nbsp; create mode 100644 drivers/md/dm-cache-shim-utils.c&nbsp; create m=
ode 100644 drivers/md/dm-cache-shim-utils.h&nbsp; create mode 100644 driver=
s/md/dm-cache-stack-utils.c&nbsp; create mode 100644 drivers/md/dm-cache-st=
ack-utils.h<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">--<o:p></o:p></p>
<p class=3D"MsoPlainText">1.8.1.4<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">--<o:p></o:p></p>
<p class=3D"MsoPlainText">dm-devel mailing list<o:p></o:p></p>
<p class=3D"MsoPlainText"><a href=3D"mailto:dm-devel@redhat.com"><span styl=
e=3D"color:windowtext;text-decoration:none">dm-devel@redhat.com</span></a><=
o:p></o:p></p>
<p class=3D"MsoPlainText"><a href=3D"https://www.redhat.com/mailman/listinf=
o/dm-devel"><span style=3D"color:windowtext;text-decoration:none">https://w=
ww.redhat.com/mailman/listinfo/dm-devel</span></a><o:p></o:p></p>
</div>
</body>
</html>

--_000_9BDA3ECEC2A5454BB4294114677019E131B6C2F9SACEXCMBX02PRDh_--


--===============1538477234262599722==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1538477234262599722==--
