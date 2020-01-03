From: Patrick Dung <patdung100@gmail.com>
Subject: Re: About dm-integrity layer and fsync
Date: Sat, 4 Jan 2020 03:05:59 +0800
Message-ID: <CAJTWkdvOtgzrrJiT+FQccCFu4sXzncHZDo7=RW5TWqiw8rxfLg@mail.gmail.com>
References: <CAJTWkdu1-k5m0F-uzp-EMrncL1w4wLqEi8LgF0U1Js_Nf-YphQ@mail.gmail.com>
	<alpine.LRH.2.02.2001031206190.11685@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000a15a9c059b410184"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2001031206190.11685@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--000000000000a15a9c059b410184
Content-Type: multipart/alternative; boundary="000000000000a15a99059b410182"

--000000000000a15a99059b410182
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Thanks for reply. After performing an additional testing with SSD. I have
more questions.

Firstly, about the additional testing with SSD:
I tested it with SSD (in Linux software raid level 10 setup). The result
shown using dm-integrity is faster than using XFS directly. For using
dm-integrity, fio shows lots of I/O merges by the scheduler. Please find
the attachment for the result.

Finally, please find the questions below:
1) So after the dm-integrity journal is written to the actual back end
storage (hard drive), then fsync would then report completed?

2) To my understanding, for using dm-integrity with journal mode. Data has
to written into the storage device twice (one part is the dm-integrity
journal, the other one is the actual data). For the fio test, the data
should be random and sustained for 60 seconds. But using dm-integrity with
journal mode is still faster.

Thanks,
Patrick

On Sat, Jan 4, 2020 at 1:14 AM Mikulas Patocka <mpatocka@redhat.com> wrote:

>
>
> On Fri, 3 Jan 2020, Patrick Dung wrote:
>
> > Hello,
> >
> > A quick question on dm-integrity. Does dm-integrity layer honors fsync?
>
> Yes it does.
>
> However, it writes data into the journal and when the journal is flushed,
> it reports the fsync function as finished.
>
> On a mechanical disk, writes to contiguous space (i.e. the journal) are
> faster than random writes all over the disk, that's why you see better
> performance with dm-integrity than without it.
>
> Mikulas
>
> > I was testing dm-integrity and performance. It had a strange result tha=
t
> using dm-integrity with journal is faster than a normal file system or
> dm-integrity with
> > bitmap (no journal). fio is used for testing the storage performance.
> The device is a SATA hard disk drive. Then I created a 100GB partition fo=
r
> testing.
> >
> > Below is the test cases:
> >
> > 1) XFS on a partition directly test case
> >
> > 2) dm-integrity: crc32c on a partition with default setting journal
> commit interval is 10 seconds. Then create XFS on it. test case
> >
> > 3) dm-integrity: crc32c on a partition default setting journal commit
> interval set to 5 seconds. Then create XFS on it.
> >
> > 4) dm-integrity:  crc32c on a partition default setting but using bitma=
p
> instead of journal. Then create XFS on it.
> >
> > FIO command:
> >
> > fio --filename=3D./t1 --direct=3D1 --rw=3Drandrw --refill_buffers
> --norandommap --randrepeat=3D0 --ioengine=3Dsync --bs=3D4k --rwmixread=3D=
75
> --iodepth=3D16 --numjobs=3D8 --runtime=3D60
> > --group_reporting --fsync=3D1 --name=3D4ktest --size=3D4G
> >
> > Result:
> >
> >  1. Read/Write IOPS: 117/41. Read/Write Speed 481KB/s 168KB/s
> >  2. Read/Write IOPS: 178/59. Read/Write Speed 732KB/s 244KB/s
> >  3. Read/Write IOPS: 169/57. Read/Write Speed 695KB/s 236KB/s
> >  4. Read/Write IOPS: 97/32. Read/Write Speed 400K/s 131KB/s
> > The original discussion in:
> https://gitlab.com/cryptsetup/cryptsetup/issues/513 . Milan Broz said the
> dm-devel mailing list is a suitable place to discuss the probem.
> >
> > Thanks in advance.
> >
> > Patrick
> >
> >

--000000000000a15a99059b410182
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thanks for reply. After performing an additional test=
ing with SSD. I have more questions.</div><div><br></div><div>Firstly, abou=
t the additional testing with SSD:<br><div>I tested it with SSD (in Linux s=
oftware raid level 10 setup). The result shown using dm-integrity is faster=
 than using XFS directly. For using dm-integrity, fio shows lots of I/O mer=
ges by the scheduler. Please find the attachment for the result.<br></div>

</div><div><br></div><div>Finally, please find the questions below:<br></di=
v><div>1) So after the dm-integrity journal is written to the actual back e=
nd storage (hard drive), then fsync would then report completed?</div><div>=
<br></div><div>2) To my understanding, for using dm-integrity with journal =
mode. Data has to written into the storage device twice (one part is the dm=
-integrity journal, the other one is the actual data). For the fio test, th=
e data should be random and sustained for 60 seconds. But using dm-integrit=
y with journal mode is still faster.<br></div><div><br></div><div>Thanks,</=
div><div>Patrick<br></div></div><br><div class=3D"gmail_quote"><div dir=3D"=
ltr" class=3D"gmail_attr">On Sat, Jan 4, 2020 at 1:14 AM Mikulas Patocka &l=
t;<a href=3D"mailto:mpatocka@redhat.com" target=3D"_blank">mpatocka@redhat.=
com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x"><br>
<br>
On Fri, 3 Jan 2020, Patrick Dung wrote:<br>
<br>
&gt; Hello,<br>
&gt; <br>
&gt; A quick question on dm-integrity. Does dm-integrity layer honors fsync=
?<br>
<br>
Yes it does.<br>
<br>
However, it writes data into the journal and when the journal is flushed, <=
br>
it reports the fsync function as finished.<br>
<br>
On a mechanical disk, writes to contiguous space (i.e. the journal) are <br=
>
faster than random writes all over the disk, that&#39;s why you see better =
<br>
performance with dm-integrity than without it.<br>
<br>
Mikulas<br>
<br>
&gt; I was testing dm-integrity and performance. It had a strange result th=
at using dm-integrity with journal is faster than a normal file system or d=
m-integrity with<br>
&gt; bitmap (no journal). fio is used for testing the storage performance. =
The device is a SATA hard disk drive. Then I created a 100GB partition for =
testing.<br>
&gt; <br>
&gt; Below is the test cases:<br>
&gt; <br>
&gt; 1) XFS on a partition directly test case<br>
&gt; <br>
&gt; 2) dm-integrity: crc32c on a partition with default setting journal co=
mmit interval is 10 seconds. Then create XFS on it. test case<br>
&gt; <br>
&gt; 3) dm-integrity: crc32c on a partition default setting journal commit =
interval set to 5 seconds. Then create XFS on it.<br>
&gt; <br>
&gt; 4) dm-integrity:=C2=A0 crc32c on a partition default setting but using=
 bitmap instead of journal. Then create XFS on it.<br>
&gt; <br>
&gt; FIO command:<br>
&gt; <br>
&gt; fio --filename=3D./t1 --direct=3D1 --rw=3Drandrw --refill_buffers --no=
randommap --randrepeat=3D0 --ioengine=3Dsync --bs=3D4k --rwmixread=3D75 --i=
odepth=3D16 --numjobs=3D8 --runtime=3D60<br>
&gt; --group_reporting --fsync=3D1 --name=3D4ktest --size=3D4G<br>
&gt; <br>
&gt; Result:<br>
&gt; <br>
&gt;=C2=A0 1. Read/Write IOPS: 117/41. Read/Write Speed 481KB/s 168KB/s<br>
&gt;=C2=A0 2. Read/Write IOPS: 178/59. Read/Write Speed 732KB/s 244KB/s<br>
&gt;=C2=A0 3. Read/Write IOPS: 169/57. Read/Write Speed 695KB/s 236KB/s<br>
&gt;=C2=A0 4. Read/Write IOPS: 97/32. Read/Write Speed 400K/s 131KB/s<br>
&gt; The original discussion in: <a href=3D"https://gitlab.com/cryptsetup/c=
ryptsetup/issues/513" rel=3D"noreferrer" target=3D"_blank">https://gitlab.c=
om/cryptsetup/cryptsetup/issues/513</a> . Milan Broz said the dm-devel mail=
ing list is a suitable place to discuss the probem.<br>
&gt; <br>
&gt; Thanks in advance.<br>
&gt; <br>
&gt; Patrick<br>
&gt; <br>
&gt; </blockquote></div>

--000000000000a15a99059b410182--

--000000000000a15a9c059b410184
Content-Type: text/plain; charset=WINDOWS-1252; name=result.txt
Content-Disposition: attachment; filename="result.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_k4yj3al80>
X-Attachment-Id: f_k4yj3al80

VGVzdGluZyB3aXRoIFNTRAoKMSkgV2l0aG91dCBkbS1pbnRlZ3JpdHkKNGt0ZXN0OiAoZz0wKTog
cnc9cmFuZHJ3LCBicz0oUikgNDA5NkItNDA5NkIsIChXKSA0MDk2Qi00MDk2QiwgKFQpIDQwOTZC
LTQwOTZCLCBpb2VuZ2luZT1zeW5jLCBpb2RlcHRoPTE2Ci4uLgpmaW8tMy4xNApTdGFydGluZyA4
IHByb2Nlc3Nlcwo0a3Rlc3Q6IExheWluZyBvdXQgSU8gZmlsZSAoMSBmaWxlIC8gNDA5Nk1pQikK
Sm9iczogOCAoZj04KTogW20oOCldWzEwMC4wJV1bcj0zMzQ3S2lCL3Msdz0xMjA1S2lCL3NdW3I9
ODM2LHc9MzAxIElPUFNdW2V0YSAwMG06MDBzXQo0a3Rlc3Q6IChncm91cGlkPTAsIGpvYnM9OCk6
IGVycj0gMDogcGlkPTQyOTk2NjogU2F0IEphbiAgNCAwMjozNDoyMiAyMDIwCiAgcmVhZDogSU9Q
Uz04MDYsIEJXPTMyMjVLaUIvcyAoMzMwMmtCL3MpKDE4OU1pQi82MDAwN21zZWMpCiAgICBjbGF0
ICh1c2VjKTogbWluPTkxLCBtYXg9MTMzMy4waywgYXZnPTE0NDkuNTAsIHN0ZGV2PTkwNjEuMzMK
ICAgICBsYXQgKHVzZWMpOiBtaW49OTEsIG1heD0xMzMzLjBrLCBhdmc9MTQ0OS44Niwgc3RkZXY9
OTA2MS4zMwogICAgY2xhdCBwZXJjZW50aWxlcyAodXNlYyk6CiAgICAgfCAgMS4wMHRoPVsgIDEw
Nl0sICA1LjAwdGg9WyAgMTE2XSwgMTAuMDB0aD1bICAxMjVdLCAyMC4wMHRoPVsgIDE0NV0sCiAg
ICAgfCAzMC4wMHRoPVsgIDE3NF0sIDQwLjAwdGg9WyAgMjAyXSwgNTAuMDB0aD1bICAyNTNdLCA2
MC4wMHRoPVsgIDM2M10sCiAgICAgfCA3MC4wMHRoPVsgMTQxOF0sIDgwLjAwdGg9WyAzMDMyXSwg
OTAuMDB0aD1bIDQzNTldLCA5NS4wMHRoPVsgNjEyOF0sCiAgICAgfCA5OS4wMHRoPVsgOTI0MV0s
IDk5LjUwdGg9WzEwMjkwXSwgOTkuOTB0aD1bMTMwNDJdLCA5OS45NXRoPVsxNDQ4NF0sCiAgICAg
fCA5OS45OXRoPVsxODc0NF0KICAgYncgKCAgS2lCL3MpOiBtaW49IDE4NDYsIG1heD0gNDE1MCwg
cGVyPTEwMC4wMCUsIGF2Zz0zMjc5LjA5LCBzdGRldj00NC41Niwgc2FtcGxlcz05NDQKICAgaW9w
cyAgICAgICAgOiBtaW49ICA0NjAsIG1heD0gMTAzNywgYXZnPTgxOS4zNywgc3RkZXY9MTEuMTUs
IHNhbXBsZXM9OTQ0CiAgd3JpdGU6IElPUFM9MjcwLCBCVz0xMDgyS2lCL3MgKDExMDhrQi9zKSg2
My40TWlCLzYwMDA3bXNlYyk7IDAgem9uZSByZXNldHMKICAgIGNsYXQgKHVzZWMpOiBtaW49Mzks
IG1heD0xMzM0LjhrLCBhdmc9MjU2MS42Mywgc3RkZXY9MTUwMTguMzAKICAgICBsYXQgKHVzZWMp
OiBtaW49NDAsIG1heD0xMzM0LjhrLCBhdmc9MjU2Mi4wNywgc3RkZXY9MTUwMTguMzAKICAgIGNs
YXQgcGVyY2VudGlsZXMgKHVzZWMpOgogICAgIHwgIDEuMDB0aD1bICAgICA1OF0sICA1LjAwdGg9
WyAgICAgODNdLCAxMC4wMHRoPVsgICAgIDk3XSwKICAgICB8IDIwLjAwdGg9WyAgICAxNTNdLCAz
MC4wMHRoPVsgICAgMjQ5XSwgNDAuMDB0aD1bICAgIDQ2MV0sCiAgICAgfCA1MC4wMHRoPVsgICAx
NTAwXSwgNjAuMDB0aD1bICAgMjgzNV0sIDcwLjAwdGg9WyAgIDMxMzBdLAogICAgIHwgODAuMDB0
aD1bICAgNDE0Nl0sIDkwLjAwdGg9WyAgIDYxMjhdLCA5NS4wMHRoPVsgICA3NTcwXSwKICAgICB8
IDk5LjAwdGg9WyAgMTEwNzZdLCA5OS41MHRoPVsgIDExOTk0XSwgOTkuOTB0aD1bICAxNjU4MV0s
CiAgICAgfCA5OS45NXRoPVsgIDE3OTU3XSwgOTkuOTl0aD1bMTMzMzc4OV0KICAgYncgKCAgS2lC
L3MpOiBtaW49ICA0NTUsIG1heD0gMTcyOCwgcGVyPTEwMC4wMCUsIGF2Zz0xMTAwLjAwLCBzdGRl
dj0zMC4xOCwgc2FtcGxlcz05NDQKICAgaW9wcyAgICAgICAgOiBtaW49ICAxMTMsIG1heD0gIDQz
MiwgYXZnPTI3NC41OSwgc3RkZXY9IDcuNTUsIHNhbXBsZXM9OTQ0CiAgbGF0ICh1c2VjKSAgIDog
NTA9MC4xMSUsIDEwMD0yLjc2JSwgMjUwPTQxLjg2JSwgNTAwPTEzLjk5JSwgNzUwPTMuNTIlCiAg
bGF0ICh1c2VjKSAgIDogMTAwMD0wLjIwJQogIGxhdCAobXNlYykgICA6IDI9Ny42MiUsIDQ9MTYu
NTQlLCAxMD0xMi40NCUsIDIwPTAuOTUlLCA1MD0wLjAxJQogIGxhdCAobXNlYykgICA6IDUwMD0w
LjAxJSwgMjAwMD0wLjAxJQogIGZzeW5jL2ZkYXRhc3luYy9zeW5jX2ZpbGVfcmFuZ2U6CiAgICBz
eW5jICh1c2VjKTogbWluPTE5NCwgbWF4PTEzMzkuN2ssIGF2Zz01Njk3LjI4LCBzdGRldj0xMDAz
Ny4wOQogICAgc3luYyBwZXJjZW50aWxlcyAodXNlYyk6CiAgICAgfCAgMS4wMHRoPVsgIDQ2MV0s
ICA1LjAwdGg9WyAxNDgzXSwgMTAuMDB0aD1bIDI4MzVdLCAyMC4wMHRoPVsgMzE5NV0sCiAgICAg
fCAzMC4wMHRoPVsgNDIyOF0sIDQwLjAwdGg9WyA1MTQ1XSwgNTAuMDB0aD1bIDU3MzVdLCA2MC4w
MHRoPVsgNTk5N10sCiAgICAgfCA3MC4wMHRoPVsgNjc4M10sIDgwLjAwdGg9WyA3NDM5XSwgOTAu
MDB0aD1bIDg3MTddLCA5NS4wMHRoPVsgOTc2NV0sCiAgICAgfCA5OS4wMHRoPVsxMjM4N10sIDk5
LjUwdGg9WzEzODI5XSwgOTkuOTB0aD1bMTY1ODFdLCA5OS45NXRoPVsxNzY5NV0sCiAgICAgfCA5
OS45OXRoPVsyMDU3OV0KICBjcHUgICAgICAgICAgOiB1c3I9MC4yMiUsIHN5cz0xLjI0JSwgY3R4
PTMwODE3MiwgbWFqZj0wLCBtaW5mPTEwOAogIElPIGRlcHRocyAgICA6IDE9MTk5LjklLCAyPTAu
MCUsIDQ9MC4wJSwgOD0wLjAlLCAxNj0wLjAlLCAzMj0wLjAlLCA+PTY0PTAuMCUKICAgICBzdWJt
aXQgICAgOiAwPTAuMCUsIDQ9MTAwLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMyPTAuMCUsIDY0PTAu
MCUsID49NjQ9MC4wJQogICAgIGNvbXBsZXRlICA6IDA9MC4wJSwgND0xMDAuMCUsIDg9MC4wJSwg
MTY9MC4wJSwgMzI9MC4wJSwgNjQ9MC4wJSwgPj02ND0wLjAlCiAgICAgaXNzdWVkIHJ3dHM6IHRv
dGFsPTQ4Mzc3LDE2MjM0LDAsNjQ1NjYgc2hvcnQ9MCwwLDAsMCBkcm9wcGVkPTAsMCwwLDAKICAg
ICBsYXRlbmN5ICAgOiB0YXJnZXQ9MCwgd2luZG93PTAsIHBlcmNlbnRpbGU9MTAwLjAwJSwgZGVw
dGg9MTYKClJ1biBzdGF0dXMgZ3JvdXAgMCAoYWxsIGpvYnMpOgogICBSRUFEOiBidz0zMjI1S2lC
L3MgKDMzMDJrQi9zKSwgMzIyNUtpQi9zLTMyMjVLaUIvcyAoMzMwMmtCL3MtMzMwMmtCL3MpLCBp
bz0xODlNaUIgKDE5OE1CKSwgcnVuPTYwMDA3LTYwMDA3bXNlYwogIFdSSVRFOiBidz0xMDgyS2lC
L3MgKDExMDhrQi9zKSwgMTA4MktpQi9zLTEwODJLaUIvcyAoMTEwOGtCL3MtMTEwOGtCL3MpLCBp
bz02My40TWlCICg2Ni41TUIpLCBydW49NjAwMDctNjAwMDdtc2VjCgpEaXNrIHN0YXRzIChyZWFk
L3dyaXRlKToKICAgIGRtLTE1OiBpb3M9NDgyMTUvOTYwODMsIG1lcmdlPTAvMCwgdGlja3M9MTM5
MTAvMjA0MDUzLCBpbl9xdWV1ZT0yMTc5NjMsIHV0aWw9NTIuNTIlLCBhZ2dyaW9zPTQ4Mzg0LzEw
MDU2MiwgYWdncm1lcmdlPTAvMCwgYWdncnRpY2tzPTAvMCwgYWdncmluX3F1ZXVlPTAsIGFnZ3J1
dGlsPTAuMDAlCiAgICBtZDYzOiBpb3M9NDgzODQvMTAwNTYyLCBtZXJnZT0wLzAsIHRpY2tzPTAv
MCwgaW5fcXVldWU9MCwgdXRpbD0wLjAwJSwgYWdncmlvcz0yNDE5NC80NjkwNSwgYWdncm1lcmdl
PTAvMCwgYWdncnRpY2tzPTAvMCwgYWdncmluX3F1ZXVlPTAsIGFnZ3J1dGlsPTAuMDAlCiAgICBt
ZDYyOiBpb3M9MjQzNjAvNDY4ODAsIG1lcmdlPTAvMCwgdGlja3M9MC8wLCBpbl9xdWV1ZT0wLCB1
dGlsPTAuMDAlLCBhZ2dyaW9zPTEyMTg2LzQ3MTU3LCBhZ2dybWVyZ2U9MC84NiwgYWdncnRpY2tz
PTMzMjgvMjUyNzYsIGFnZ3Jpbl9xdWV1ZT0xNjkzOCwgYWdncnV0aWw9NTIuNzAlCiAgc2RkOiBp
b3M9NzY2NS80NzQyNiwgbWVyZ2U9MC8xNjIsIHRpY2tzPTQ0NTIvNDAwMzUsIGluX3F1ZXVlPTMx
Mzc3LCB1dGlsPTUwLjQ4JQogIHNkZzogaW9zPTE2NzA3LzQ2ODg4LCBtZXJnZT0wLzEwLCB0aWNr
cz0yMjA1LzEwNTE3LCBpbl9xdWV1ZT0yNTAwLCB1dGlsPTUyLjcwJQogICAgbWQ2MTogaW9zPTI0
MDI5LzQ2OTMxLCBtZXJnZT0wLzAsIHRpY2tzPTAvMCwgaW5fcXVldWU9MCwgdXRpbD0wLjAwJSwg
YWdncmlvcz0xMjAyNC80NzE3NCwgYWdncm1lcmdlPTAvMTIyLCBhZ2dydGlja3M9MzUwMi8yNTQz
MiwgYWdncmluX3F1ZXVlPTE3Mjg5LCBhZ2dydXRpbD01Mi4zNiUKICBzZGY6IGlvcz0xNjI1MS80
NjkwNiwgbWVyZ2U9MC80NiwgdGlja3M9MjQ1MC8xMDkwOSwgaW5fcXVldWU9MzI2NSwgdXRpbD01
Mi4zNiUKICBzZGI6IGlvcz03Nzk4LzQ3NDQzLCBtZXJnZT0wLzE5OSwgdGlja3M9NDU1NS8zOTk1
NiwgaW5fcXVldWU9MzEzMTMsIHV0aWw9NTAuNTUlCgoKMikgV2l0aCBkbS1pbnRlZ3JpdHkKNGt0
ZXN0OiAoZz0wKTogcnc9cmFuZHJ3LCBicz0oUikgNDA5NkItNDA5NkIsIChXKSA0MDk2Qi00MDk2
QiwgKFQpIDQwOTZCLTQwOTZCLCBpb2VuZ2luZT1zeW5jLCBpb2RlcHRoPTE2Ci4uLgpmaW8tMy4x
NApTdGFydGluZyA4IHByb2Nlc3Nlcwo0a3Rlc3Q6IExheWluZyBvdXQgSU8gZmlsZSAoMSBmaWxl
IC8gNDA5Nk1pQikKSm9iczogOCAoZj04KTogW20oOCldWzEwMC4wJV1bcj0zMzQ3S2lCL3Msdz0x
MjA1S2lCL3NdW3I9ODM2LHc9MzAxIElPUFNdW2V0YSAwMG06MDBzXQo0a3Rlc3Q6IChncm91cGlk
PTAsIGpvYnM9OCk6IGVycj0gMDogcGlkPTQyOTk2NjogU2F0IEphbiAgNCAwMjozNDoyMiAyMDIw
CiAgcmVhZDogSU9QUz04MDYsIEJXPTMyMjVLaUIvcyAoMzMwMmtCL3MpKDE4OU1pQi82MDAwN21z
ZWMpCiAgICBjbGF0ICh1c2VjKTogbWluPTkxLCBtYXg9MTMzMy4waywgYXZnPTE0NDkuNTAsIHN0
ZGV2PTkwNjEuMzMKICAgICBsYXQgKHVzZWMpOiBtaW49OTEsIG1heD0xMzMzLjBrLCBhdmc9MTQ0
OS44Niwgc3RkZXY9OTA2MS4zMwogICAgY2xhdCBwZXJjZW50aWxlcyAodXNlYyk6CiAgICAgfCAg
MS4wMHRoPVsgIDEwNl0sICA1LjAwdGg9WyAgMTE2XSwgMTAuMDB0aD1bICAxMjVdLCAyMC4wMHRo
PVsgIDE0NV0sCiAgICAgfCAzMC4wMHRoPVsgIDE3NF0sIDQwLjAwdGg9WyAgMjAyXSwgNTAuMDB0
aD1bICAyNTNdLCA2MC4wMHRoPVsgIDM2M10sCiAgICAgfCA3MC4wMHRoPVsgMTQxOF0sIDgwLjAw
dGg9WyAzMDMyXSwgOTAuMDB0aD1bIDQzNTldLCA5NS4wMHRoPVsgNjEyOF0sCiAgICAgfCA5OS4w
MHRoPVsgOTI0MV0sIDk5LjUwdGg9WzEwMjkwXSwgOTkuOTB0aD1bMTMwNDJdLCA5OS45NXRoPVsx
NDQ4NF0sCiAgICAgfCA5OS45OXRoPVsxODc0NF0KICAgYncgKCAgS2lCL3MpOiBtaW49IDE4NDYs
IG1heD0gNDE1MCwgcGVyPTEwMC4wMCUsIGF2Zz0zMjc5LjA5LCBzdGRldj00NC41Niwgc2FtcGxl
cz05NDQKICAgaW9wcyAgICAgICAgOiBtaW49ICA0NjAsIG1heD0gMTAzNywgYXZnPTgxOS4zNywg
c3RkZXY9MTEuMTUsIHNhbXBsZXM9OTQ0CiAgd3JpdGU6IElPUFM9MjcwLCBCVz0xMDgyS2lCL3Mg
KDExMDhrQi9zKSg2My40TWlCLzYwMDA3bXNlYyk7IDAgem9uZSByZXNldHMKICAgIGNsYXQgKHVz
ZWMpOiBtaW49MzksIG1heD0xMzM0LjhrLCBhdmc9MjU2MS42Mywgc3RkZXY9MTUwMTguMzAKICAg
ICBsYXQgKHVzZWMpOiBtaW49NDAsIG1heD0xMzM0LjhrLCBhdmc9MjU2Mi4wNywgc3RkZXY9MTUw
MTguMzAKICAgIGNsYXQgcGVyY2VudGlsZXMgKHVzZWMpOgogICAgIHwgIDEuMDB0aD1bICAgICA1
OF0sICA1LjAwdGg9WyAgICAgODNdLCAxMC4wMHRoPVsgICAgIDk3XSwKICAgICB8IDIwLjAwdGg9
WyAgICAxNTNdLCAzMC4wMHRoPVsgICAgMjQ5XSwgNDAuMDB0aD1bICAgIDQ2MV0sCiAgICAgfCA1
MC4wMHRoPVsgICAxNTAwXSwgNjAuMDB0aD1bICAgMjgzNV0sIDcwLjAwdGg9WyAgIDMxMzBdLAog
ICAgIHwgODAuMDB0aD1bICAgNDE0Nl0sIDkwLjAwdGg9WyAgIDYxMjhdLCA5NS4wMHRoPVsgICA3
NTcwXSwKICAgICB8IDk5LjAwdGg9WyAgMTEwNzZdLCA5OS41MHRoPVsgIDExOTk0XSwgOTkuOTB0
aD1bICAxNjU4MV0sCiAgICAgfCA5OS45NXRoPVsgIDE3OTU3XSwgOTkuOTl0aD1bMTMzMzc4OV0K
ICAgYncgKCAgS2lCL3MpOiBtaW49ICA0NTUsIG1heD0gMTcyOCwgcGVyPTEwMC4wMCUsIGF2Zz0x
MTAwLjAwLCBzdGRldj0zMC4xOCwgc2FtcGxlcz05NDQKICAgaW9wcyAgICAgICAgOiBtaW49ICAx
MTMsIG1heD0gIDQzMiwgYXZnPTI3NC41OSwgc3RkZXY9IDcuNTUsIHNhbXBsZXM9OTQ0CiAgbGF0
ICh1c2VjKSAgIDogNTA9MC4xMSUsIDEwMD0yLjc2JSwgMjUwPTQxLjg2JSwgNTAwPTEzLjk5JSwg
NzUwPTMuNTIlCiAgbGF0ICh1c2VjKSAgIDogMTAwMD0wLjIwJQogIGxhdCAobXNlYykgICA6IDI9
Ny42MiUsIDQ9MTYuNTQlLCAxMD0xMi40NCUsIDIwPTAuOTUlLCA1MD0wLjAxJQogIGxhdCAobXNl
YykgICA6IDUwMD0wLjAxJSwgMjAwMD0wLjAxJQogIGZzeW5jL2ZkYXRhc3luYy9zeW5jX2ZpbGVf
cmFuZ2U6CiAgICBzeW5jICh1c2VjKTogbWluPTE5NCwgbWF4PTEzMzkuN2ssIGF2Zz01Njk3LjI4
LCBzdGRldj0xMDAzNy4wOQogICAgc3luYyBwZXJjZW50aWxlcyAodXNlYyk6CiAgICAgfCAgMS4w
MHRoPVsgIDQ2MV0sICA1LjAwdGg9WyAxNDgzXSwgMTAuMDB0aD1bIDI4MzVdLCAyMC4wMHRoPVsg
MzE5NV0sCiAgICAgfCAzMC4wMHRoPVsgNDIyOF0sIDQwLjAwdGg9WyA1MTQ1XSwgNTAuMDB0aD1b
IDU3MzVdLCA2MC4wMHRoPVsgNTk5N10sCiAgICAgfCA3MC4wMHRoPVsgNjc4M10sIDgwLjAwdGg9
WyA3NDM5XSwgOTAuMDB0aD1bIDg3MTddLCA5NS4wMHRoPVsgOTc2NV0sCiAgICAgfCA5OS4wMHRo
PVsxMjM4N10sIDk5LjUwdGg9WzEzODI5XSwgOTkuOTB0aD1bMTY1ODFdLCA5OS45NXRoPVsxNzY5
NV0sCiAgICAgfCA5OS45OXRoPVsyMDU3OV0KICBjcHUgICAgICAgICAgOiB1c3I9MC4yMiUsIHN5
cz0xLjI0JSwgY3R4PTMwODE3MiwgbWFqZj0wLCBtaW5mPTEwOAogIElPIGRlcHRocyAgICA6IDE9
MTk5LjklLCAyPTAuMCUsIDQ9MC4wJSwgOD0wLjAlLCAxNj0wLjAlLCAzMj0wLjAlLCA+PTY0PTAu
MCUKICAgICBzdWJtaXQgICAgOiAwPTAuMCUsIDQ9MTAwLjAlLCA4PTAuMCUsIDE2PTAuMCUsIDMy
PTAuMCUsIDY0PTAuMCUsID49NjQ9MC4wJQogICAgIGNvbXBsZXRlICA6IDA9MC4wJSwgND0xMDAu
MCUsIDg9MC4wJSwgMTY9MC4wJSwgMzI9MC4wJSwgNjQ9MC4wJSwgPj02ND0wLjAlCiAgICAgaXNz
dWVkIHJ3dHM6IHRvdGFsPTQ4Mzc3LDE2MjM0LDAsNjQ1NjYgc2hvcnQ9MCwwLDAsMCBkcm9wcGVk
PTAsMCwwLDAKICAgICBsYXRlbmN5ICAgOiB0YXJnZXQ9MCwgd2luZG93PTAsIHBlcmNlbnRpbGU9
MTAwLjAwJSwgZGVwdGg9MTYKClJ1biBzdGF0dXMgZ3JvdXAgMCAoYWxsIGpvYnMpOgogICBSRUFE
OiBidz0zMjI1S2lCL3MgKDMzMDJrQi9zKSwgMzIyNUtpQi9zLTMyMjVLaUIvcyAoMzMwMmtCL3Mt
MzMwMmtCL3MpLCBpbz0xODlNaUIgKDE5OE1CKSwgcnVuPTYwMDA3LTYwMDA3bXNlYwogIFdSSVRF
OiBidz0xMDgyS2lCL3MgKDExMDhrQi9zKSwgMTA4MktpQi9zLTEwODJLaUIvcyAoMTEwOGtCL3Mt
MTEwOGtCL3MpLCBpbz02My40TWlCICg2Ni41TUIpLCBydW49NjAwMDctNjAwMDdtc2VjCgpEaXNr
IHN0YXRzIChyZWFkL3dyaXRlKToKICAgIGRtLTE1OiBpb3M9NDgyMTUvOTYwODMsIG1lcmdlPTAv
MCwgdGlja3M9MTM5MTAvMjA0MDUzLCBpbl9xdWV1ZT0yMTc5NjMsIHV0aWw9NTIuNTIlLCBhZ2dy
aW9zPTQ4Mzg0LzEwMDU2MiwgYWdncm1lcmdlPTAvMCwgYWdncnRpY2tzPTAvMCwgYWdncmluX3F1
ZXVlPTAsIGFnZ3J1dGlsPTAuMDAlCiAgICBtZDYzOiBpb3M9NDgzODQvMTAwNTYyLCBtZXJnZT0w
LzAsIHRpY2tzPTAvMCwgaW5fcXVldWU9MCwgdXRpbD0wLjAwJSwgYWdncmlvcz0yNDE5NC80Njkw
NSwgYWdncm1lcmdlPTAvMCwgYWdncnRpY2tzPTAvMCwgYWdncmluX3F1ZXVlPTAsIGFnZ3J1dGls
PTAuMDAlCiAgICBtZDYyOiBpb3M9MjQzNjAvNDY4ODAsIG1lcmdlPTAvMCwgdGlja3M9MC8wLCBp
bl9xdWV1ZT0wLCB1dGlsPTAuMDAlLCBhZ2dyaW9zPTEyMTg2LzQ3MTU3LCBhZ2dybWVyZ2U9MC84
NiwgYWdncnRpY2tzPTMzMjgvMjUyNzYsIGFnZ3Jpbl9xdWV1ZT0xNjkzOCwgYWdncnV0aWw9NTIu
NzAlCiAgc2RkOiBpb3M9NzY2NS80NzQyNiwgbWVyZ2U9MC8xNjIsIHRpY2tzPTQ0NTIvNDAwMzUs
IGluX3F1ZXVlPTMxMzc3LCB1dGlsPTUwLjQ4JQogIHNkZzogaW9zPTE2NzA3LzQ2ODg4LCBtZXJn
ZT0wLzEwLCB0aWNrcz0yMjA1LzEwNTE3LCBpbl9xdWV1ZT0yNTAwLCB1dGlsPTUyLjcwJQogICAg
bWQ2MTogaW9zPTI0MDI5LzQ2OTMxLCBtZXJnZT0wLzAsIHRpY2tzPTAvMCwgaW5fcXVldWU9MCwg
dXRpbD0wLjAwJSwgYWdncmlvcz0xMjAyNC80NzE3NCwgYWdncm1lcmdlPTAvMTIyLCBhZ2dydGlj
a3M9MzUwMi8yNTQzMiwgYWdncmluX3F1ZXVlPTE3Mjg5LCBhZ2dydXRpbD01Mi4zNiUKICBzZGY6
IGlvcz0xNjI1MS80NjkwNiwgbWVyZ2U9MC80NiwgdGlja3M9MjQ1MC8xMDkwOSwgaW5fcXVldWU9
MzI2NSwgdXRpbD01Mi4zNiUKICBzZGI6IGlvcz03Nzk4LzQ3NDQzLCBtZXJnZT0wLzE5OSwgdGlj
a3M9NDU1NS8zOTk1NiwgaW5fcXVldWU9MzEzMTMsIHV0aWw9NTAuNTUlCg==
--000000000000a15a9c059b410184
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--000000000000a15a9c059b410184--
