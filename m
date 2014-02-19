From: "George ." <george@ucdn.com>
Subject: Re: dm-cache data corruption
Date: Wed, 19 Feb 2014 15:32:07 +0200
Message-ID: <CAPi_w4ygpSCEAS+dTgB_vZkVUoF7+jQjuF5goivCmBb_bPk+eg@mail.gmail.com>
References: <CAPi_w4wWnJa8XDXsXscgPzYukvAB4eADgvPDLKcGNEU3ykfjiQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e013c62204f710204f2c26a62
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPi_w4wWnJa8XDXsXscgPzYukvAB4eADgvPDLKcGNEU3ykfjiQ@mail.gmail.com>
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

--089e013c62204f710204f2c26a62
Content-Type: multipart/alternative; boundary=089e013c62204f70fd04f2c26a60

--089e013c62204f70fd04f2c26a60
Content-Type: text/plain; charset=ISO-8859-1

forget the script, here it is ...


On Wed, Feb 19, 2014 at 2:31 PM, George . <george@ucdn.com> wrote:

> Hi,
>
> I'm currently testing dm-cache on 'debian 3.12-1-amd64 #1 SMP Debian
> 3.12.9-1' vanilla kernel and finally reproduced the issue with data
> corruption on cached device.
>
> Using small and simple setup:
>
>
>
> * root@debian:~# blockdev --getsz /dev/sda5 1951744root@debian:~# blockdev
> --getsz /dev/sda6 122880root@debian:~# blockdev --getsz /dev/sda7 28672*
> *root@debian:~# dmsetup create cached --table '0 1951744 cache /dev/sda7
> /dev/sda6 /dev/sda5  512 1 writeback default 0'*
>
> and a script that actually starts many (let's say 100) instances of
> *badblock* tool,  writing, reading and comparing 0x55, 0xaa, 0xff, 0x00
> patterns, where each instance repeats that procedure over is own range of
> blocks. See my bash script (attached)
>
> Here how I run it:
> *./dm-stress-test.sh -n 100 -r 10000 -d /dev/mapper/cached -t p*
>
> /dev/mapper/cached, 512, 1951744
> running parallel test
> checking blocks 0 to 19516
> checking blocks 19517 to 39033
> *.*
> *.*
> *.*
> *checking blocks 1932183 to 1951699*
> *waiting for bad blocks*
> *file has bad blocks, ./bad_block_43*
> *839295*
> *file has bad blocks, ./bad_block_43*
> *839295*
> *file has bad blocks, ./bad_block_43*
> *839295*
> *^CCTRL-C exiting ...*
>
> here is the dm-cache status at the time of first corrupted block:
>
> *root@debian:~# dmsetup status *
> *cached: 0 1951744 cache 7/3584 852 126848 1040 166813 0 85 85 71 0 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 51*2
>
>
> I've also tried this test on custom build kernel 'Linux george 3.13.0+ #3
> SMP Mon Feb 17 10:44:59 EET 2014 x86_64 x86_64 x86_64 GNU/Linux' and
> there is the same issue
>
> If using ram device for cache and sata for origin the first corrupted
> blocks appears almost  immediately .
>
>
> We been testing dm-cache on larger setups (see https://www.redhat
> .com/archives/dm-devel/2014-January/msg00135.html) but there we were able
> to corrupt cached device after several days under heavy traffic.
>

--089e013c62204f70fd04f2c26a60
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">forget the script, here it is ...=A0</div><div class=3D"gm=
ail_extra"><br><br><div class=3D"gmail_quote">On Wed, Feb 19, 2014 at 2:31 =
PM, George . <span dir=3D"ltr">&lt;<a href=3D"mailto:george@ucdn.com" targe=
t=3D"_blank">george@ucdn.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">Hi,<div><br></div><div>I&#3=
9;m currently testing <span style=3D"background-color:yellow"><span style=
=3D"background-color:yellow"><span>dm</span></span></span>-cache on &#39;<f=
ont color=3D"#000000"><span style=3D"background-color:yellow"><span style=
=3D"background-color:yellow"><span>debian</span></span></span> 3.12-1-amd64=
 #1 <span style=3D"background-color:yellow"><span style=3D"background-color=
:yellow"><span>SMP</span></span></span> Debian 3.12.9-1&#39; vanilla kernel=
 and finally reproduced the issue with data corruption on cached device.</f=
ont></div>

<div><font color=3D"#000000"><br></font></div><div><font color=3D"#000000">=
Using small and simple setup:</font></div><div><font color=3D"#000000"><br>=
</font></div><div><font color=3D"#000000"><br></font></div><div><font color=
=3D"#000000"><i><div>

root@<span style=3D"background-color:yellow"><span style=3D"background-colo=
r:yellow"><span>debian</span></span></span>:~# <span style=3D"background-co=
lor:yellow"><span style=3D"background-color:yellow"><span>blockdev</span></=
span></span> --<span style=3D"background-color:yellow"><span style=3D"backg=
round-color:yellow"><span>getsz</span></span></span> /<span style=3D"backgr=
ound-color:yellow"><span style=3D"background-color:yellow"><span>dev</span>=
</span></span>/sda5</div>

<div>1951744</div><div>root@<span style=3D"background-color:yellow"><span s=
tyle=3D"background-color:yellow"><span>debian</span></span></span>:~# <span=
 style=3D"background-color:yellow"><span style=3D"background-color:yellow">=
<span>blockdev</span></span></span> --<span style=3D"background-color:yello=
w"><span style=3D"background-color:yellow"><span>getsz</span></span></span>=
 /<span style=3D"background-color:yellow"><span style=3D"background-color:y=
ellow"><span>dev</span></span></span>/sda6</div>

<div>122880</div><div>root@<span style=3D"background-color:yellow"><span st=
yle=3D"background-color:yellow"><span>debian</span></span></span>:~# <span =
style=3D"background-color:yellow"><span style=3D"background-color:yellow"><=
span>blockdev</span></span></span> --<span style=3D"background-color:yellow=
"><span style=3D"background-color:yellow"><span>getsz</span></span></span> =
/<span style=3D"background-color:yellow"><span style=3D"background-color:ye=
llow"><span>dev</span></span></span>/sda7</div>

<div>28672</div><div><br></div></i></font></div><div><font color=3D"#000000=
"><i>root@<span style=3D"background-color:yellow"><span style=3D"background=
-color:yellow"><span>debian</span></span></span>:~# <span style=3D"backgrou=
nd-color:yellow"><span style=3D"background-color:yellow"><span>dmsetup</spa=
n></span></span> create cached --table &#39;0 1951744 cache /<span style=3D=
"background-color:yellow"><span style=3D"background-color:yellow"><span>dev=
</span></span></span>/sda7 /<span style=3D"background-color:yellow"><span s=
tyle=3D"background-color:yellow"><span>dev</span></span></span>/sda6 /<span=
 style=3D"background-color:yellow"><span style=3D"background-color:yellow">=
<span>dev</span></span></span>/sda5 =A0512 1 <span style=3D"background-colo=
r:yellow"><span style=3D"background-color:yellow"><span>writeback</span></s=
pan></span> default 0&#39;</i><br>

</font></div><div><font color=3D"#000000"><br></font></div><div><font color=
=3D"#000000">and a script that actually starts many (let&#39;s say 100) ins=
tances=A0of <i><b><span style=3D"background-color:yellow"><span style=3D"ba=
ckground-color:yellow"><span>badblock</span></span></span></b></i> tool, =
=A0writing, reading and comparing 0x55,=A0</font><span style>0x</span><span=
 style><span style=3D"background-color:yellow"><span style=3D"background-co=
lor:yellow"><span>aa</span></span></span>,=A0</span><span style>0x</span><s=
pan style>ff,=A0</span><span style>0x</span><span style>00 patterns, where =
each instance repeats that procedure over is own range of blocks. See my ba=
sh script (attached)</span></div>

<div><font color=3D"#000000"><br></font></div><div><font color=3D"#000000">=
Here how I run it:</font></div><div><font color=3D"#000000"><i>./<span styl=
e=3D"background-color:yellow"><span>dm</span></span>-stress-test.sh -n 100 =
-r 10000 -d /<span style=3D"background-color:yellow"><span>dev</span></span=
>/mapper/cached -t p</i><br>

</font></div><div><br></div><div><div>/<span>dev</span>/mapper/cached, 512,=
 1951744</div><div>running parallel test</div><div>checking blocks 0 to 195=
16</div><div>checking blocks 19517 to 39033</div></div><div>
<i style>.</i><br></div><div><font color=3D"#000000"><i>.</i></font></div><=
div><font color=3D"#000000"><i>.</i></font></div><div><font color=3D"#00000=
0"><div><i>checking blocks 1932183 to 1951699</i></div><div>
<i>waiting for bad blocks</i></div><div><i>file has bad blocks, ./bad_block=
_43</i></div><div><i>839295</i></div><div><i>file has bad blocks, ./bad_blo=
ck_43</i></div><div><i>839295</i></div><div><i>file has bad blocks, ./bad_b=
lock_43</i></div>

<div><i>839295</i></div><div><i>^<span style=3D"background-color:yellow"><s=
pan>CCTRL</span></span>-C exiting ...</i></div><div><br></div><div>here is =
the <span style=3D"background-color:yellow"><span>dm</span></span>-cache st=
atus at the time of first corrupted block:</div>

<div><br></div><div><div><i>root@<span style=3D"background-color:yellow"><s=
pan>debian</span></span>:~# <span style=3D"background-color:yellow"><span>d=
msetup</span></span> status=A0</i></div>
<div><i>cached: 0 1951744 cache 7/3584 852 126848 1040 166813 0 85 85 71 0 =
2 migration_threshold 2048 4 random_threshold 4 sequential_threshold 51</i>=
2</div></div><div><br></div></font></div><div><font color=3D"#000000"><br>

</font></div><div><font color=3D"#000000">I&#39;ve also tried this test on =
<span style=3D"background-color:yellow">custom</span>=A0build <span style=
=3D"background-color:yellow">kernel</span> &#39;Linux <span style=3D"backgr=
ound-color:yellow"><span>george</span></span> 3.13.0+ #3 <span style=3D"bac=
kground-color:yellow"><span>SMP</span></span> Mon Feb 17 10:44:59 <span sty=
le=3D"background-color:yellow"><span>EET</span></span> 2014 x86_64 x86_64 x=
86_64 GNU/Linux&#39; and there is the same issue=A0</font></div>

<div><br></div><div><font color=3D"#000000">If using ram device for cache a=
nd <span style=3D"background-color:yellow"><span>sata</span></span> for ori=
gin the first corrupted blocks appears almost =A0immediately .</font></div>
<div><font color=3D"#000000"><br></font></div><div><font color=3D"#000000">=
<br></font></div><div><font color=3D"#000000">We been testing <span style=
=3D"background-color:yellow"><span style=3D"background-color:yellow"><span>=
dm</span></span></span>-cache on larger setups (see=A0<a href=3D"https://ww=
w" target=3D"_blank">https://www</a>.<span style=3D"background-color:yellow=
"><span style=3D"background-color:yellow"><span>redhat</span></span></span>=
.com/archives/<span style=3D"background-color:yellow"><span style=3D"backgr=
ound-color:yellow"><span>dm</span></span></span>-<span style=3D"background-=
color:yellow"><span style=3D"background-color:yellow"><span>devel</span></s=
pan></span>/2014-January/msg00135.html</font><span style>) but there we wer=
e able to corrupt cached device after several days under heavy traffic.</sp=
an></div>

</div>
</blockquote></div><br></div>

--089e013c62204f70fd04f2c26a60--

--089e013c62204f710204f2c26a62
Content-Type: application/x-sh; name="dm-stress-test.sh"
Content-Disposition: attachment; filename="dm-stress-test.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hrun3frl0

IyEvYmluL2Jhc2gKdXNhZ2UoKSB7IGVjaG8gIlVzYWdlOiAkMCBbLWQgZGV2XSBbLXAgcmVwZWF0
ZV0gWy1uIG51bV90aF0gWy10IHR5cGUgcHxzd10iIDE+JjI7IGV4aXQgMTsgfQoKCnRyYXAgY3Ry
bF9jIFNJR0lOVAoKZnVuY3Rpb24gY3RybF9jKCkgCnsKICAgIHRyYXAgJycgU0lHSU5UCiAgICBl
Y2hvICJDVFJMLUMgZXhpdGluZyAuLi4iCiAgICBraWxsYWxsIC1LSUxMIGJhZGJsb2NrcwoKICAg
IGZvciAoKGk9MDsgaTwkbnVtX3RoOyBpKyspKTsgZG8KICAgICAgICAgICAgaWYgWyAtZiAuL2Jh
ZF9ibG9ja18ke2l9IF0gJiYgISBbIC1zIC4vYmFkX2Jsb2NrXyR7aX0gXSA7IHRoZW4KICAgICAg
ICAgICAgICAgICAgICBybSAuL2JhZF9ibG9ja18ke2l9CiAgICAgICAgICAgIGZpCiAgICBkb25l
CgogICAgZXhpdCAwCn0KCmZ1bmN0aW9uIHBhcmFsbGVsX3Rlc3QoKQp7CiAgICBlY2hvICJydW5u
aW5nIHBhcmFsbGVsIHRlc3QiCiAgICBzdGVwPSQoKCRkZXZfc3ogLyAkbnVtX3RoIC0gMSkpCgog
ICAgZm9yICgoaT0wOyBpPCRudW1fdGg7IGkrKykpOyBkbwoKICAgICAgICAgICAgdGVuZD0kKCgk
dHN0YXJ0ICsgJHN0ZXApKQogICAgICAgICAgICAKICAgICAgICAgICAgZWNobyAiY2hlY2tpbmcg
YmxvY2tzIiAkdHN0YXJ0ICJ0byIgJHRlbmQKCiAgICAgICAgICAgIGJhZGJsb2NrcyAtdyAke2Rl
dn0gLW8gLi9iYWRfYmxvY2tfJHtpfSAtcCAkcmVwICR0ZW5kICR0c3RhcnQgLWIgJGRldl9wYnMg
Mj4vZGV2L251bGwgJgoKICAgICAgICAgICAgdHN0YXJ0PSQoKCR0ZW5kICsgMSkpCiAgICBkb25l
ICAgICAgICAKfQoKCmZ1bmN0aW9uIHN3ZWVwX3Rlc3QoKQp7CiAgICBlY2hvICJydW5uaW5nIHN3
ZWVwIHRlc3QiCiAgICAKICAgICBzdGVwPSQoKCRkZXZfc3ogLyAkbnVtX3RoIC0gMSkpCiAgICAK
ICAgIGZvciAoKGk9MDsgaTwkbnVtX3RoOyBpKyspKTsgZG8KCiAgICAgICAgICAgIHRlbmQ9JCgo
JHRzdGFydCArICRzdGVwKSkKICAgICAgICAgICAgCiAgICAgICAgICAgIGVjaG8gImNoZWNraW5n
IGJsb2NrcyIgJHRzdGFydCAidG8iICR0ZW5kCgogICAgICAgICAgICBiYWRibG9ja3MgLXdzdiAk
e2Rldn0gLW8gLi9iYWRfYmxvY2tfJHtpfSAtcCAkcmVwICR0ZW5kICR0c3RhcnQgLWIgJGRldl9w
YnMKCiAgICAgICAgICAgIHRzdGFydD0kKCgkdGVuZCArIDEpKQogICAgZG9uZSAKfQoKbnVtX3Ro
PTEKc3RhcnQ9MAplbmQ9MAp0ZXN0X3R5cGU9ImxwIgpyZXA9MTAwMDAwMAoKd2hpbGUgZ2V0b3B0
cyBkOnM6ZTpuOnQ6cjogZmxhZzsgZG8KICAgIGNhc2UgJGZsYWcgaW4KICAgIGQpCiAgICAgICAg
ICAgIGRldj0kT1BUQVJHOzsKICAgIHMpCiAgICAgICAgICAgIHN0YXJ0PSRPUFRBUkc7OwogICAg
ZSkKICAgICAgICAgICAgZW5kPSRPUFRBUkc7OwogICAgbikKICAgICAgICAgICAgbnVtX3RoPSRP
UFRBUkc7OwogICAgdCkKICAgICAgICAgICAgdGVzdF90eXBlPSRPUFRBUkc7OwogICAgcikKICAg
ICAgICAgICAgcmVwPSRPUFRBUkc7OwogICAgPykKICAgICAgICAgICAgdXNhZ2U7OwogICAgZXNh
Ywpkb25lCgpzaGlmdCAkKCggT1BUSU5EIC0gMSApKTsKCmlmICEgWyAtYiAiJGRldiIgXSA7IHRo
ZW4KICAgIGVjaG8gJGRldiAiaXMgbm90IGEgYmxvY2sgZGV2aWNlIgogICAgZXhpdCAtMQpmaQoK
ZGV2X3Bicz0kKGJsb2NrZGV2IC0tZ2V0cGJzeiAkZGV2KQpkZXZfc3o9JChibG9ja2RldiAtLWdl
dHN6ICRkZXYpCgoKZWNobyAkZGV2LCAkZGV2X3BicywgJGRldl9zegoKdHN0YXJ0PTAKZW5kPSQo
KCRkZXZfc3ogLSAxKSkKCmNhc2UgJHRlc3RfdHlwZSBpbgogICAgInAiKQogICAgICAgIHBhcmFs
bGVsX3Rlc3Q7OwogICAgInN3IikKICAgICAgICBzd2VlcF90ZXN0OzsKZXNhYwogICAgCmVjaG8g
IndhaXRpbmcgZm9yIGJhZCBibG9ja3MiCgp3aGlsZSB0cnVlCmRvCiAgICBmb3IgKChpPTA7IGk8
JG51bV90aDsgaSsrKSk7IGRvICAgICAgICAgICAgICAgIAogICAgICAgIGlmIFsgLXMgLi9iYWRf
YmxvY2tfJHtpfSBdOyB0aGVuCiAgICAgICAgICAgICAgICBlY2hvICJmaWxlIGhhcyBiYWQgYmxv
Y2tzIiwgLi9iYWRfYmxvY2tfJHtpfQogICAgICAgICAgICAgICAgY2F0IC4vYmFkX2Jsb2NrXyR7
aX0KICAgICAgICBmaQogICAgZG9uZQogICAgc2xlZXAgMQpkb25lCg==
--089e013c62204f710204f2c26a62
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--089e013c62204f710204f2c26a62--
