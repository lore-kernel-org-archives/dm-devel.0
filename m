From: Jagan Reddy <gjmsreddy@yahoo.com>
Subject: dm-thin vs lvm performance
Date: Thu, 12 Jan 2012 16:55:16 -0800 (PST)
Message-ID: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
Reply-To: Jagan Reddy <gjmsreddy@yahoo.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="-2114655128-1682974902-1326416116=:56981"
Return-path: <dm-devel-bounces@redhat.com>
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

---2114655128-1682974902-1326416116=:56981
Content-Type: multipart/alternative;
	boundary="-2114655128-1497740683-1326416116=:56981"

---2114655128-1497740683-1326416116=:56981
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,=0AI =A0recently started using dm-thin module and first of all, thank yo=
u for the good work. It works great, well documented and the comments in th=
e code are very useful. =A0I tried to run some performance tests using a hi=
gh performance flash device and the performance of dm thin is about 30% of =
LVM performance on a full allocated thin provisioned volume. ( ie after all=
 pages/blocks are allocated using dd). Performance test does only reads and=
 no writes.=A0=0A=0ATo reproduce the scenario easily, I tried same operatio=
ns using ramdisk and dd.=A0=0A=0ATo read 3.2G of data using dd,=A0=0A=0A=A0=
=A0 Raw Ramdisk takes - 2.5 seconds=0A=A0=A0 LVM Lun - takes 4 seconds=0A=
=A0=A0 TP Lun ( after fully allocated) - takes 18 seconds=0A=0A=0A=0ASteps =
involved=0A------------------=0A1. Linux 3.2.0.rc4 version from=A0kernel.or=
g=0A=A03.2.0-rc4 #1 SMP Fri Dec 16 13:25:02 EST 2011 x86_64 x86_64 x86_64 G=
NU/Linux=0A2.=A0LVM2.2.02.88=0A3. compiling and installing dm thin modules.=
=0A4. Create a ramdisk of size 4G.=0A=0ARamdisk Raw Read Test=0A-----------=
---------------=0A[root@lab-dm-cn4 ~]# dd of=3D/dev/null if=3D/dev/ram bs=
=3D4096 count=3D786432=0A786432+0 records in=0A786432+0 records out=0A32212=
25472 bytes (3.2 GB) copied, 2.56607 s, 1.3 GB/s=0A=0ALVM SETUP=0A---------=
---------------=0A=0ACreate PV with 8M metadata on ramdisk , chunksize=3D8M=
 in VG, lv uses 100%VG.=0A=0Aroot@lab-dm-cn4 ~]# dd of=3D/dev/null if=3D/de=
v/6C067CWX00132-1/engineering bs=3D4096 count=3D$BLOCKS=0A=A0=A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0786432+0 records in=0A=
=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0786432+0 =
records out=0A=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A03221225472 bytes (3.2 GB) copied, 4.06687 s, 792 MB/s=0A=0A=0A=0ADM =
THIN SETUP=0A-----------------------=0ACreate metadata device of size 8M an=
d data device of size 3G using dm-linear on ramdisk.=0ACreate TP Pool using=
 the above devices with page/block size of 8M.=0ACreate TP LUN in the TP Po=
ol.=0AUsing dd, write 4k to every page in the TP LUN so that all pages are =
allocated.=0Ausing "dmsetup status" verify that all pages in the pool are a=
llocated.=0A=0A[root@lab-dm-cn4 ~]# dd of=3D/dev/null if=3D/dev/mapper/thin=
1 bs=3D4096 count=3D$BLOCKS=0A=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0786432+0 records in=0A=A0=A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0786432+0 records out=0A=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A03221225472 bytes (3.2 GB) copied, 18=
.2166 s, 177 MB/s=0A=0A=0A=0AI have attached the output file and the script=
 file used for this test. =A0Any ideas / suggestions on what may be the bot=
tle neck in dm-thin performance is much appreciated.=0A=0AThanks,=0AJagan.
---2114655128-1497740683-1326416116=:56981
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ar=
ial, helvetica, sans-serif;font-size:12pt"><div><span class=3D"Apple-style-=
span" style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family:=
 'Times New Roman'; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; text-inden=
t: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing:=
 0px; font-size: 16px;"><span class=3D"Apple-style-span" style=3D"font-fami=
ly: arial; font-size: 13px;">Hi,<div>I &nbsp;recently started using dm-thin=
 module and first of all, thank you for the good work. It works great, well=
 documented and the comments in the code are very useful. &nbsp;I tried to =
run some performance tests using a high performance flash device and the pe=
rformance of dm thin is about 30% of LVM performance on a full allocated th=
in provisioned volume. ( ie after all pages/blocks are allocated using dd).
 Performance test does only reads and no writes.&nbsp;<div><br></div><div>T=
o reproduce the scenario easily, I tried same operations using ramdisk and =
dd.&nbsp;</div><div><br></div><div>To read 3.2G of data using dd,&nbsp;</di=
v><div><br></div><div>&nbsp;&nbsp; Raw Ramdisk takes - 2.5 seconds</div><di=
v>&nbsp;&nbsp; LVM Lun - takes 4 seconds</div><div>&nbsp;&nbsp; TP Lun ( af=
ter fully allocated) - takes 18 seconds</div><div><br></div><div><br></div>=
<div><br></div><div>Steps involved</div><div>------------------</div><div>1=
. Linux 3.2.0.rc4 version from&nbsp;<a href=3D"http://kernel.org/" target=
=3D"_blank">kernel.org</a></div><div>&nbsp;3.2.0-rc4 #1 SMP Fri Dec 16 13:2=
5:02 EST 2011 x86_64 x86_64 x86_64 GNU/Linux</div><div>2.&nbsp;LVM2.2.02.88=
</div><div>3. compiling and installing dm thin modules.</div><div>4. Create=
 a ramdisk of size 4G.</div><div><br></div><div>Ramdisk Raw Read Test</div>=
<div>--------------------------</div><div>[root@lab-dm-cn4 ~]# dd
 of=3D/dev/null if=3D/dev/ram bs=3D4096 count=3D786432</div><div><div>78643=
2+0 records in</div><div>786432+0 records out</div><div>3221225472 bytes (3=
.2 GB) copied, 2.56607 s, 1.3 GB/s</div></div><div><br></div><div>LVM SETUP=
</div><div>------------------------</div><div><br></div><div>Create PV with=
 8M metadata on ramdisk , chunksize=3D8M in VG, lv uses 100%VG.</div><div><=
br></div><div><div>root@lab-dm-cn4 ~]# dd of=3D/dev/null if=3D/dev/6C067CWX=
00132-1/engineering bs=3D4096 count=3D$BLOCKS</div><div>&nbsp;&nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp;786432+0 records in</div><div>&nbsp;&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;786432+0 records out</div><div>&nbsp;&nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp;3221225472 bytes (3.2 GB) copied, 4.06687 s, 792
 MB/s</div></div><div><br></div><div><br></div><div><br></div><div>DM THIN =
SETUP</div><div>-----------------------</div><div>Create metadata device of=
 size 8M and data device of size 3G using dm-linear on ramdisk.</div><div>C=
reate TP Pool using the above devices with page/block size of 8M.</div><div=
>Create TP LUN in the TP Pool.</div><div>Using dd, write 4k to every page i=
n the TP LUN so that all pages are allocated.</div><div>using "dmsetup stat=
us" verify that all pages in the pool are allocated.</div><div><br></div><d=
iv><div>[root@lab-dm-cn4 ~]# dd of=3D/dev/null if=3D/dev/mapper/thin1 bs=3D=
4096 count=3D$BLOCKS</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp;786432+0 records in</div><div>&nbsp;&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;786432+0
 records out</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp;3221225472 bytes (3.2 GB) copied, 18.2166 s, 177 M=
B/s</div></div><div><br></div><div><br></div><div><br></div><div>I have att=
ached the output file and the script file used for this test. &nbsp;Any ide=
as / suggestions on what may be the bottle neck in dm-thin performance is m=
uch appreciated.</div><div><br></div><div>Thanks,</div><div>Jagan.</div></d=
iv><div><div><br></div><div><br><br class=3D"Apple-interchange-newline"></d=
iv></div></span></span></div></div></body></html>
---2114655128-1497740683-1326416116=:56981--

---2114655128-1682974902-1326416116=:56981
Content-Type: text/plain; name="dm_thin_lvm_compare_output.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dm_thin_lvm_compare_output.txt"

Cltyb290QGxhYi1kbS1jbjQgfl0jICNjb25zdGFudHMKW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgbGV0IE9ORU1FRz0xMDI0KjI7ICN0cmFuc2xhdGVkIHRvIHNl
Y3RvcnMKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgCltyb290QGxhYi1kbS1jbjQg
fl0jICN1c2VyIGRlZmluZWQKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgRE1TRVRV
UD0vaG9tZS9qYWdhbi9zcmMvTFZNMi4yLjAyLjg4L3Rvb2xzL2Rtc2V0dXAK
W3Jvb3RAbGFiLWRtLWNuNCB+XSMgTFVOPTEKW3Jvb3RAbGFiLWRtLWNuNCB+
XSMgTUVUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SPTAgI29uICRERVZJQ0VfUEFU
SCB0aGlzIGlzIHdoZXJlIG1ldGEgZGF0YSBzdGFydHMKW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgREVWSUNFX1BBVEg9L2Rldi9yYW0KW3Jvb3RAbGFiLWRtLWNu
NCB+XSMgbGV0IE1FVEFfREVWX1NJWkU9MSoxMDI0KiRPTkVNRUc7ICMxRyB0
cmFuc2xhdGVkIHRvIHNlY3RvcnMgdXNlZCBpbiBwdmNyZWF0ZSBjb21tYW5k
Cltyb290QGxhYi1kbS1jbjQgfl0jIGxldCBQQUdFU0laRT04KiRPTkVNRUcg
I3BhZ2Ugc2l6ZSBpcyA4TSBpbiBzZWN0b3JzCltyb290QGxhYi1kbS1jbjQg
fl0jIGxldCBEQVRBX0RFVl9TSVpFPTMqMTAyNCokT05FTUVHKyRQQUdFU0la
RTsgIzNHIHRyYW5zbGF0ZWQgdG8gc2VjdG9ycwpbcm9vdEBsYWItZG0tY240
IH5dIyBsZXQgTFZNX0RFVklDRV9TSVpFPSRNRVRBX0RFVl9TSVpFKyREQVRB
X0RFVl9TSVpFOwpbcm9vdEBsYWItZG0tY240IH5dIyBsZXQgRERfQlM9NCox
MDI0ICMgZGQgYmxvY2sgc2l6ZSA9IDRrICBieXRlcwpbcm9vdEBsYWItZG0t
Y240IH5dIyBsZXQgQkxPQ0tTPSgkREFUQV9ERVZfU0laRS0kUEFHRVNJWkUp
KjUxMi8kRERfQlMKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgCltyb290QGxhYi1k
bS1jbjQgfl0jICNzeXN0ZW0gZGVmaW5lZApbcm9vdEBsYWItZG0tY240IH5d
IyBsZXQgREFUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SPSRNRVRBX0RFVklDRV9T
VEFSVF9TRUNUT1IrJE1FVEFfREVWX1NJWkUKW3Jvb3RAbGFiLWRtLWNuNCB+
XSMgbGV0IFBBR0VTPSREQVRBX0RFVl9TSVpFLyRQQUdFU0laRQpbcm9vdEBs
YWItZG0tY240IH5dIyBsZXQgU0VFSz0kUEFHRVNJWkUqNTEyLyRERF9CUwpb
cm9vdEBsYWItZG0tY240IH5dIyAKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgZWNo
byAkRE1TRVRVUCBMVU5JRD0kTFVOIERFVklDRT0kREVWSUNFX1BBVEggREVW
SUNFX1NUQVJUPSRNRVRBX0RFVklDRV9TVEFSVF9TRUNUT1IgTUVUQV9ERVZf
U0laRT0kTUVUQV9ERVZfU0laRSBEQVRBX0RFVl9TSVpFPSREQVRBX0RFVl9T
SVpFICBQQUdFU0laRT0kUEFHRVNJWkUgRERfQlM9JEREX0JTIERBVEFfREVW
SUNFX1NUQVJUX1NFQ1RPUj0kREFUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SIFBB
R0VTPSRQQUdFUyBTRUVLPSRTRUVLIEJMT0NLUz0kQkxPQ0tTIExWTV9ERVZJ
Q0VfU0laRT0kTFZNX0RFVklDRV9TSVpFCi9ob21lL2phZ2FuL3NyYy9MVk0y
LjIuMDIuODgvdG9vbHMvZG1zZXR1cCBMVU5JRD0xIERFVklDRT0vZGV2L3Jh
bSBERVZJQ0VfU1RBUlQ9MCBNRVRBX0RFVl9TSVpFPTIwOTcxNTIgREFUQV9E
RVZfU0laRT02MzA3ODQwIFBBR0VTSVpFPTE2Mzg0IEREX0JTPTQwOTYgREFU
QV9ERVZJQ0VfU1RBUlRfU0VDVE9SPTIwOTcxNTIgUEFHRVM9Mzg1IFNFRUs9
MjA0OCBCTE9DS1M9Nzg2NDMyIExWTV9ERVZJQ0VfU0laRT04NDA0OTkyClty
b290QGxhYi1kbS1jbjQgfl0jIApbcm9vdEBsYWItZG0tY240IH5dIyBwdmNy
ZWF0ZSAgLU0yIC0tZGF0YWFsaWdubWVudCA0SyAtLW1ldGFkYXRhY29waWVz
IDEgLS1tZXRhZGF0YXNpemUgOE0gLS16ZXJvIHkgLXYgL2Rldi9yYW0KICAg
IFNldCB1cCBwaHlzaWNhbCB2b2x1bWUgZm9yICIvZGV2L3JhbSIgd2l0aCA4
Mzg4NjA4IGF2YWlsYWJsZSBzZWN0b3JzCiAgICBaZXJvaW5nIHN0YXJ0IG9m
IGRldmljZSAvZGV2L3JhbQogIFdyaXRpbmcgcGh5c2ljYWwgdm9sdW1lIGRh
dGEgdG8gZGlzayAiL2Rldi9yYW0iCiAgUGh5c2ljYWwgdm9sdW1lICIvZGV2
L3JhbSIgc3VjY2Vzc2Z1bGx5IGNyZWF0ZWQKW3Jvb3RAbGFiLWRtLWNuNCB+
XSMgdmdjcmVhdGUgLWwgMTYzODQgLXMgOE0gLWMgbiAtQSBuIDZDMDY3Q1dY
MDAxMzItMSAvZGV2L3JhbQogIFdBUk5JTkc6IFRoaXMgbWV0YWRhdGEgdXBk
YXRlIGlzIE5PVCBiYWNrZWQgdXAKICBWb2x1bWUgZ3JvdXAgIjZDMDY3Q1dY
MDAxMzItMSIgc3VjY2Vzc2Z1bGx5IGNyZWF0ZWQKW3Jvb3RAbGFiLWRtLWNu
NCB+XSMgbHZjcmVhdGUgLUEgbiAtQyBuIC1sIDEwMCVWRyAtWiB5IC1uIGVu
Z2luZWVyaW5nIC1yIE5vbmUgNkMwNjdDV1gwMDEzMi0xCiAgV0FSTklORzog
VGhpcyBtZXRhZGF0YSB1cGRhdGUgaXMgTk9UIGJhY2tlZCB1cAogIFdBUk5J
Tkc6IFRoaXMgbWV0YWRhdGEgdXBkYXRlIGlzIE5PVCBiYWNrZWQgdXAKICBM
b2dpY2FsIHZvbHVtZSAiZW5naW5lZXJpbmciIGNyZWF0ZWQKW3Jvb3RAbGFi
LWRtLWNuNCB+XSMgCltyb290QGxhYi1kbS1jbjQgfl0jICMgcnVuIGRkIHRl
c3Qgb24gc2V2ZXJhbCBkZXZpY2VzCltyb290QGxhYi1kbS1jbjQgfl0jIApb
cm9vdEBsYWItZG0tY240IH5dIyAjd3JpdGUgc29tZXRoaW5nCltyb290QGxh
Yi1kbS1jbjQgfl0jIGRkIGlmPS9kZXYvemVybyBvZj0vZGV2LzZDMDY3Q1dY
MDAxMzItMS9lbmdpbmVlcmluZyBicz00MDk2IGNvdW50PSRCTE9DS1MKNzg2
NDMyKzAgcmVjb3JkcyBpbgo3ODY0MzIrMCByZWNvcmRzIG91dAozMjIxMjI1
NDcyIGJ5dGVzICgzLjIgR0IpIGNvcGllZCwgNC42MzMxOCBzLCA2OTUgTUIv
cwpbcm9vdEBsYWItZG0tY240IH5dIyAKW3Jvb3RAbGFiLWRtLWNuNCB+XSMg
I25vdGUgdGhlIHRpbWUgb24gbHZtIGRldmljZQpbcm9vdEBsYWItZG0tY240
IH5dIyBkZCBvZj0vZGV2L251bGwgaWY9L2Rldi82QzA2N0NXWDAwMTMyLTEv
ZW5naW5lZXJpbmcgYnM9NDA5NiBjb3VudD0kQkxPQ0tTCjc4NjQzMiswIHJl
Y29yZHMgaW4KNzg2NDMyKzAgcmVjb3JkcyBvdXQKMzIyMTIyNTQ3MiBieXRl
cyAoMy4yIEdCKSBjb3BpZWQsIDQuMDY2ODcgcywgNzkyIE1CL3MKW3Jvb3RA
bGFiLWRtLWNuNCB+XSMgCltyb290QGxhYi1kbS1jbjQgfl0jIGx2cmVtb3Zl
IC1mIC9kZXYvNkMwNjdDV1gwMDEzMi0xL2VuZ2luZWVyaW5nCiAgTG9naWNh
bCB2b2x1bWUgImVuZ2luZWVyaW5nIiBzdWNjZXNzZnVsbHkgcmVtb3ZlZApb
cm9vdEBsYWItZG0tY240IH5dIyB2Z3JlbW92ZSA2QzA2N0NXWDAwMTMyLTEK
ICBWb2x1bWUgZ3JvdXAgIjZDMDY3Q1dYMDAxMzItMSIgc3VjY2Vzc2Z1bGx5
IHJlbW92ZWQKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgcHZyZW1vdmUgL2Rldi9y
YW0KICBMYWJlbHMgb24gcGh5c2ljYWwgdm9sdW1lICIvZGV2L3JhbSIgc3Vj
Y2Vzc2Z1bGx5IHdpcGVkCltyb290QGxhYi1kbS1jbjQgfl0jIGx2ZGlzcGxh
eQogIE5vIHZvbHVtZSBncm91cHMgZm91bmQKW3Jvb3RAbGFiLWRtLWNuNCB+
XSMgdmdkaXNwbGF5CiAgTm8gdm9sdW1lIGdyb3VwcyBmb3VuZApbcm9vdEBs
YWItZG0tY240IH5dIyBwdmRpc3BsYXkKW3Jvb3RAbGFiLWRtLWNuNCB+XSMg
bHMgLWwgL2Rldi9tYXBwZXIKdG90YWwgMApjcnctcnctLS0tLiAxIHJvb3Qg
cm9vdCAxMCwgMjM2IEphbiAxMSAxMTozNCBjb250cm9sCltyb290QGxhYi1k
bS1jbjQgfl0jIApbcm9vdEBsYWItZG0tY240IH5dIyAKW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgCltyb290QGxhYi1kbS1jbjQgfl0jICNjb25zdGFudHMKW3Jv
b3RAbGFiLWRtLWNuNCB+XSMgbGV0IE9ORU1FRz0xMDI0KjI7ICN0cmFuc2xh
dGVkIHRvIHNlY3RvcnMKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgCltyb290QGxh
Yi1kbS1jbjQgfl0jICN1c2VyIGRlZmluZWQKW3Jvb3RAbGFiLWRtLWNuNCB+
XSMgRE1TRVRVUD0vaG9tZS9qYWdhbi9zcmMvTFZNMi4yLjAyLjg4L3Rvb2xz
L2Rtc2V0dXAKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgTFVOPTEKW3Jvb3RAbGFi
LWRtLWNuNCB+XSMgTUVUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SPTAgI29uICRE
RVZJQ0VfUEFUSCB0aGlzIGlzIHdoZXJlIG1ldGEgZGF0YSBzdGFydHMKW3Jv
b3RAbGFiLWRtLWNuNCB+XSMgREVWSUNFX1BBVEg9L2Rldi9yYW0KW3Jvb3RA
bGFiLWRtLWNuNCB+XSMgbGV0IE1FVEFfREVWX1NJWkU9OCokT05FTUVHOyAj
OE0gdHJhbnNsYXRlZCB0byBzZWN0b3JzCltyb290QGxhYi1kbS1jbjQgfl0j
IGxldCBEQVRBX0RFVl9TSVpFPTMqMTAyNCokT05FTUVHOyAjM0cgdHJhbnNs
YXRlZCB0byBzZWN0b3JzCltyb290QGxhYi1kbS1jbjQgfl0jIGxldCBQQUdF
U0laRT04KiRPTkVNRUcgI3BhZ2Ugc2l6ZSBpcyA4TSBpbiBzZWN0b3JzClty
b290QGxhYi1kbS1jbjQgfl0jIGxldCBERF9CUz00KjEwMjQgIyBkZCBibG9j
ayBzaXplID0gNGsgIGJ5dGVzCltyb290QGxhYi1kbS1jbjQgfl0jIApbcm9v
dEBsYWItZG0tY240IH5dIyAjc3lzdGVtIGRlZmluZWQKW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgbGV0IERBVEFfREVWSUNFX1NUQVJUX1NFQ1RPUj0kTUVUQV9E
RVZJQ0VfU1RBUlRfU0VDVE9SKyRNRVRBX0RFVl9TSVpFCltyb290QGxhYi1k
bS1jbjQgfl0jIGxldCBQQUdFUz0kREFUQV9ERVZfU0laRS8kUEFHRVNJWkUK
W3Jvb3RAbGFiLWRtLWNuNCB+XSMgbGV0IFNFRUs9JFBBR0VTSVpFKjUxMi8k
RERfQlMgIyBob3cgbWFueSBibG9ja3Mgd2UgbmVlZCB0byBzZWVrIGluIGRk
IHRvIGdvIHRvIG5leHQgcGFnZQpbcm9vdEBsYWItZG0tY240IH5dIyBsZXQg
QkxPQ0tTPSREQVRBX0RFVl9TSVpFKjUxMi8kRERfQlMKW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgCltyb290QGxhYi1kbS1jbjQgfl0jIGVjaG8gJERNU0VUVVAg
TFVOSUQ9JExVTiBERVZJQ0U9JERFVklDRV9QQVRIIERFVklDRV9TVEFSVD0k
TUVUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SIE1FVEFfREVWX1NJWkU9JE1FVEFf
REVWX1NJWkUgREFUQV9ERVZfU0laRT0kREFUQV9ERVZfU0laRSAgUEFHRVNJ
WkU9JFBBR0VTSVpFIEREX0JTPSRERF9CUyBEQVRBX0RFVklDRV9TVEFSVF9T
RUNUT1I9JERBVEFfREVWSUNFX1NUQVJUX1NFQ1RPUiBQQUdFUz0kUEFHRVMg
U0VFSz0kU0VFSyBCTE9DS1M9JEJMT0NLUwovaG9tZS9qYWdhbi9zcmMvTFZN
Mi4yLjAyLjg4L3Rvb2xzL2Rtc2V0dXAgTFVOSUQ9MSBERVZJQ0U9L2Rldi9y
YW0gREVWSUNFX1NUQVJUPTAgTUVUQV9ERVZfU0laRT0xNjM4NCBEQVRBX0RF
Vl9TSVpFPTYyOTE0NTYgUEFHRVNJWkU9MTYzODQgRERfQlM9NDA5NiBEQVRB
X0RFVklDRV9TVEFSVF9TRUNUT1I9MTYzODQgUEFHRVM9Mzg0IFNFRUs9MjA0
OCBCTE9DS1M9Nzg2NDMyCltyb290QGxhYi1kbS1jbjQgfl0jIApbcm9vdEBs
YWItZG0tY240IH5dIyBlY2hvIDAgJE1FVEFfREVWX1NJWkUgbGluZWFyICRE
RVZJQ0VfUEFUSCAkTUVUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SIHwgJERNU0VU
VVAgY3JlYXRlIHRwX21ldGFfZGlzayRMVU4KW3Jvb3RAbGFiLWRtLWNuNCB+
XSMgCltyb290QGxhYi1kbS1jbjQgfl0jICN6ZXJvIG91dCBmaXJzdCA0ayBv
ZiBtZXRhIGRhdGEgZGlzawpbcm9vdEBsYWItZG0tY240IH5dIyBkZCBpZj0v
ZGV2L3plcm8gb2Y9L2Rldi9tYXBwZXIvdHBfbWV0YV9kaXNrJExVTiBicz00
MDk2IGNvdW50PTEKMSswIHJlY29yZHMgaW4KMSswIHJlY29yZHMgb3V0CjQw
OTYgYnl0ZXMgKDQuMSBrQikgY29waWVkLCAzLjkzMTllLTA1IHMsIDEwNCBN
Qi9zCltyb290QGxhYi1kbS1jbjQgfl0jIApbcm9vdEBsYWItZG0tY240IH5d
IyAjY3JlYXRlIGRhdGEgZGlzawpbcm9vdEBsYWItZG0tY240IH5dIyBlY2hv
IDAgJERBVEFfREVWX1NJWkUgbGluZWFyICRERVZJQ0VfUEFUSCAgJERBVEFf
REVWSUNFX1NUQVJUX1NFQ1RPUiB8ICRETVNFVFVQIGNyZWF0ZSB0cF9kYXRh
X2Rpc2skTFVOCltyb290QGxhYi1kbS1jbjQgfl0jIApbcm9vdEBsYWItZG0t
Y240IH5dIyAKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgI2NyZWF0ZSB0aGluIHBv
b2wKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgJERNU0VUVVAgY3JlYXRlIHBvb2wk
TFVOIC0tdGFibGUgIjAgJERBVEFfREVWX1NJWkUgdGhpbi1wb29sIC9kZXYv
bWFwcGVyL3RwX21ldGFfZGlzayRMVU4gL2Rldi9tYXBwZXIvdHBfZGF0YV9k
aXNrJExVTiAgJFBBR0VTSVpFIDAgIiAjMUcgcGFnZSB3aXRoIDEwMCB3aXRo
IG5vIHdhdGVyIG1hcmsKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgCltyb290QGxh
Yi1kbS1jbjQgfl0jICN2ZXJpZnkgdGhhdCAwIHBhZ2VzIGFyZSBhbGxvY2F0
ZWQKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgJERNU0VUVVAgc3RhdHVzIHBvb2wk
TFVOCjAgNjI5MTQ1NiB0aGluLXBvb2wgMCA5LzIwNDggMC8zODQgLQpbcm9v
dEBsYWItZG0tY240IH5dIyAkRE1TRVRVUCBtZXNzYWdlIC9kZXYvbWFwcGVy
L3Bvb2wkTFVOIDAgImNyZWF0ZV90aGluIDAiCltyb290QGxhYi1kbS1jbjQg
fl0jICRETVNFVFVQIGNyZWF0ZSB0aGluJExVTiAtLXRhYmxlICIwICREQVRB
X0RFVl9TSVpFIHRoaW4gL2Rldi9tYXBwZXIvcG9vbCRMVU4gMCIKW3Jvb3RA
bGFiLWRtLWNuNCB+XSMgI2J5IG5vdyBubyBwYWdlcyBzaG91bGQgYmUgYWxs
b2NhdGVkCltyb290QGxhYi1kbS1jbjQgfl0jICRETVNFVFVQIHN0YXR1cyBw
b29sJExVTgowIDYyOTE0NTYgdGhpbi1wb29sIDAgMTAvMjA0OCAwLzM4NCAt
Cltyb290QGxhYi1kbS1jbjQgfl0jIApbcm9vdEBsYWItZG0tY240IH5dIyAK
W3Jvb3RAbGFiLWRtLWNuNCB+XSMgI3RvdWNoIGFsbCBwYWdlcyBvbiB0aGlu
IHByb3Zpc29uZWQgZGF0YSBkaXNrIHNvIHRoYXQgYWxsIHBhZ2VzIGFyZSBh
bGxvY2F0ZWQKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgaT0wO3doaWxlIFsgJGkg
LWx0ICRQQUdFUyBdOyBkbyBsZXQgaj0kaSokU0VFSzsgZWNobyAkaTsgZGQg
aWY9L2Rldi96ZXJvIG9mPS9kZXYvbWFwcGVyL3RoaW4kTFVOIGJzPTQwOTYg
c2Vlaz0kaiBjb3VudD0xOyBsZXQgaT0kaSsxOyBkb25lID4mL2Rldi9udWxs
Cltyb290QGxhYi1kbS1jbjQgfl0jICNieSBub3cgYWxsIHBhZ2VzIHNob3Vs
ZCBiZSBhbGxvY2F0ZWQKW3Jvb3RAbGFiLWRtLWNuNCB+XSMgJERNU0VUVVAg
c3RhdHVzIHBvb2wkTFVOCjAgNjI5MTQ1NiB0aGluLXBvb2wgMCAxOC8yMDQ4
IDM4NC8zODQgLQpbcm9vdEBsYWItZG0tY240IH5dIyAKW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgCltyb290QGxhYi1kbS1jbjQgfl0jICNub3RlIHRoZSB0aW1l
IG9uIHRoaW4gZGV2aWNlCltyb290QGxhYi1kbS1jbjQgfl0jIGRkIG9mPS9k
ZXYvbnVsbCBpZj0vZGV2L21hcHBlci90aGluMSBicz00MDk2IGNvdW50PSRC
TE9DS1MKNzg2NDMyKzAgcmVjb3JkcyBpbgo3ODY0MzIrMCByZWNvcmRzIG91
dAozMjIxMjI1NDcyIGJ5dGVzICgzLjIgR0IpIGNvcGllZCwgMTguMjE2NiBz
LCAxNzcgTUIvcwpbcm9vdEBsYWItZG0tY240IH5dIyAKW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgCltyb290QGxhYi1kbS1jbjQgfl0jICNjbGVhbnVwCltyb290
QGxhYi1kbS1jbjQgfl0jICRETVNFVFVQIHJlbW92ZSB0aGluJExVTgpbcm9v
dEBsYWItZG0tY240IH5dIyAkRE1TRVRVUCBtZXNzYWdlIC9kZXYvbWFwcGVy
L3Bvb2wkTFVOIDAgImRlbGV0ZSAwIgpbcm9vdEBsYWItZG0tY240IH5dIyAk
RE1TRVRVUCByZW1vdmUgcG9vbCRMVU4KW3Jvb3RAbGFiLWRtLWNuNCB+XSMg
JERNU0VUVVAgcmVtb3ZlIHRwX2RhdGFfZGlzayRMVU4KW3Jvb3RAbGFiLWRt
LWNuNCB+XSMgJERNU0VUVVAgcmVtb3ZlIHRwX21ldGFfZGlzayRMVU4K

---2114655128-1682974902-1326416116=:56981
Content-Type: application/x-sh; name="lvm_thin_compare.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="lvm_thin_compare.sh"

IyEvYmluL2Jhc2ggLWYKI3NldHVwIFRQIERFVklDRSwgUkVBRCAzRyBkYXRh
LiBTZXR1cCBMVk0gREVWSUNFLCByZWFkIDNHIERhdGEKCiNjb25zdGFudHMK
bGV0IE9ORU1FRz0xMDI0KjI7ICN0cmFuc2xhdGVkIHRvIHNlY3RvcnMKCiN1
c2VyIGRlZmluZWQKRE1TRVRVUD0vaG9tZS9qYWdhbi9zcmMvTFZNMi4yLjAy
Ljg4L3Rvb2xzL2Rtc2V0dXAKTFVOPTEKTUVUQV9ERVZJQ0VfU1RBUlRfU0VD
VE9SPTAgI29uICRERVZJQ0VfUEFUSCB0aGlzIGlzIHdoZXJlIG1ldGEgZGF0
YSBzdGFydHMKREVWSUNFX1BBVEg9L2Rldi9yYW0KbGV0IE1FVEFfREVWX1NJ
WkU9OCokT05FTUVHOyAjOE0gdHJhbnNsYXRlZCB0byBzZWN0b3JzCmxldCBE
QVRBX0RFVl9TSVpFPTMqMTAyNCokT05FTUVHOyAjM0cgdHJhbnNsYXRlZCB0
byBzZWN0b3JzCmxldCBQQUdFU0laRT04KiRPTkVNRUcgI3BhZ2Ugc2l6ZSBp
cyA4TSBpbiBzZWN0b3JzCmxldCBERF9CUz00KjEwMjQgIyBkZCBibG9jayBz
aXplID0gNGsgIGJ5dGVzCgojc3lzdGVtIGRlZmluZWQKbGV0IERBVEFfREVW
SUNFX1NUQVJUX1NFQ1RPUj0kTUVUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SKyRN
RVRBX0RFVl9TSVpFCmxldCBQQUdFUz0kREFUQV9ERVZfU0laRS8kUEFHRVNJ
WkUKbGV0IFNFRUs9JFBBR0VTSVpFKjUxMi8kRERfQlMgIyBob3cgbWFueSBi
bG9ja3Mgd2UgbmVlZCB0byBzZWVrIGluIGRkIHRvIGdvIHRvIG5leHQgcGFn
ZQpsZXQgQkxPQ0tTPSREQVRBX0RFVl9TSVpFKjUxMi8kRERfQlMKCmVjaG8g
JERNU0VUVVAgTFVOSUQ9JExVTiBERVZJQ0U9JERFVklDRV9QQVRIIERFVklD
RV9TVEFSVD0kTUVUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SIE1FVEFfREVWX1NJ
WkU9JE1FVEFfREVWX1NJWkUgREFUQV9ERVZfU0laRT0kREFUQV9ERVZfU0la
RSAgUEFHRVNJWkU9JFBBR0VTSVpFIEREX0JTPSRERF9CUyBEQVRBX0RFVklD
RV9TVEFSVF9TRUNUT1I9JERBVEFfREVWSUNFX1NUQVJUX1NFQ1RPUiBQQUdF
Uz0kUEFHRVMgU0VFSz0kU0VFSyBCTE9DS1M9JEJMT0NLUwoKZWNobyAwICRN
RVRBX0RFVl9TSVpFIGxpbmVhciAkREVWSUNFX1BBVEggJE1FVEFfREVWSUNF
X1NUQVJUX1NFQ1RPUiB8ICRETVNFVFVQIGNyZWF0ZSB0cF9tZXRhX2Rpc2sk
TFVOCgojemVybyBvdXQgZmlyc3QgNGsgb2YgbWV0YSBkYXRhIGRpc2sKZGQg
aWY9L2Rldi96ZXJvIG9mPS9kZXYvbWFwcGVyL3RwX21ldGFfZGlzayRMVU4g
YnM9NDA5NiBjb3VudD0xCgojY3JlYXRlIGRhdGEgZGlzawplY2hvIDAgJERB
VEFfREVWX1NJWkUgbGluZWFyICRERVZJQ0VfUEFUSCAgJERBVEFfREVWSUNF
X1NUQVJUX1NFQ1RPUiB8ICRETVNFVFVQIGNyZWF0ZSB0cF9kYXRhX2Rpc2sk
TFVOCgoKI2NyZWF0ZSB0aGluIHBvb2wKJERNU0VUVVAgY3JlYXRlIHBvb2wk
TFVOIC0tdGFibGUgIjAgJERBVEFfREVWX1NJWkUgdGhpbi1wb29sIC9kZXYv
bWFwcGVyL3RwX21ldGFfZGlzayRMVU4gL2Rldi9tYXBwZXIvdHBfZGF0YV9k
aXNrJExVTiAgJFBBR0VTSVpFIDAgIiAjMUcgcGFnZSB3aXRoIDEwMCB3aXRo
IG5vIHdhdGVyIG1hcmsKCiN2ZXJpZnkgdGhhdCAwIHBhZ2VzIGFyZSBhbGxv
Y2F0ZWQKJERNU0VUVVAgc3RhdHVzIHBvb2wkTFVOCiRETVNFVFVQIG1lc3Nh
Z2UgL2Rldi9tYXBwZXIvcG9vbCRMVU4gMCAiY3JlYXRlX3RoaW4gMCIKJERN
U0VUVVAgY3JlYXRlIHRoaW4kTFVOIC0tdGFibGUgIjAgJERBVEFfREVWX1NJ
WkUgdGhpbiAvZGV2L21hcHBlci9wb29sJExVTiAwIgojYnkgbm93IG5vIHBh
Z2VzIHNob3VsZCBiZSBhbGxvY2F0ZWQKJERNU0VUVVAgc3RhdHVzIHBvb2wk
TFVOCgoKI3RvdWNoIGFsbCBwYWdlcyBvbiB0aGluIHByb3Zpc29uZWQgZGF0
YSBkaXNrIHNvIHRoYXQgYWxsIHBhZ2VzIGFyZSBhbGxvY2F0ZWQKaT0wO3do
aWxlIFsgJGkgLWx0ICRQQUdFUyBdOyBkbyBsZXQgaj0kaSokU0VFSzsgZWNo
byAkaTsgZGQgaWY9L2Rldi96ZXJvIG9mPS9kZXYvbWFwcGVyL3RoaW4kTFVO
IGJzPTQwOTYgc2Vlaz0kaiBjb3VudD0xOyBsZXQgaT0kaSsxOyBkb25lID4m
L2Rldi9udWxsCiNieSBub3cgYWxsIHBhZ2VzIHNob3VsZCBiZSBhbGxvY2F0
ZWQKJERNU0VUVVAgc3RhdHVzIHBvb2wkTFVOCgoKI25vdGUgdGhlIHRpbWUg
b24gdGhpbiBkZXZpY2UKZGQgb2Y9L2Rldi9udWxsIGlmPS9kZXYvbWFwcGVy
L3RoaW4xIGJzPTQwOTYgY291bnQ9JEJMT0NLUwoKCiNjbGVhbnVwCiRETVNF
VFVQIHJlbW92ZSB0aGluJExVTgokRE1TRVRVUCBtZXNzYWdlIC9kZXYvbWFw
cGVyL3Bvb2wkTFVOIDAgImRlbGV0ZSAwIgokRE1TRVRVUCByZW1vdmUgcG9v
bCRMVU4KJERNU0VUVVAgcmVtb3ZlIHRwX2RhdGFfZGlzayRMVU4KJERNU0VU
VVAgcmVtb3ZlIHRwX21ldGFfZGlzayRMVU4KCiMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIwojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwoKCiNjb25zdGFudHMKbGV0
IE9ORU1FRz0xMDI0KjI7ICN0cmFuc2xhdGVkIHRvIHNlY3RvcnMKCiN1c2Vy
IGRlZmluZWQKRE1TRVRVUD0vaG9tZS9qYWdhbi9zcmMvTFZNMi4yLjAyLjg4
L3Rvb2xzL2Rtc2V0dXAKTFVOPTEKTUVUQV9ERVZJQ0VfU1RBUlRfU0VDVE9S
PTAgI29uICRERVZJQ0VfUEFUSCB0aGlzIGlzIHdoZXJlIG1ldGEgZGF0YSBz
dGFydHMKREVWSUNFX1BBVEg9L2Rldi9yYW0KbGV0IE1FVEFfREVWX1NJWkU9
MSoxMDI0KiRPTkVNRUc7ICMxRyB0cmFuc2xhdGVkIHRvIHNlY3RvcnMgdXNl
ZCBpbiBwdmNyZWF0ZSBjb21tYW5kCmxldCBQQUdFU0laRT04KiRPTkVNRUcg
I3BhZ2Ugc2l6ZSBpcyA4TSBpbiBzZWN0b3JzCmxldCBEQVRBX0RFVl9TSVpF
PTMqMTAyNCokT05FTUVHKyRQQUdFU0laRTsgIzNHIHRyYW5zbGF0ZWQgdG8g
c2VjdG9ycwpsZXQgTFZNX0RFVklDRV9TSVpFPSRNRVRBX0RFVl9TSVpFKyRE
QVRBX0RFVl9TSVpFOwpsZXQgRERfQlM9NCoxMDI0ICMgZGQgYmxvY2sgc2l6
ZSA9IDRrICBieXRlcwpsZXQgQkxPQ0tTPSgkREFUQV9ERVZfU0laRS0kUEFH
RVNJWkUpKjUxMi8kRERfQlMKCiNzeXN0ZW0gZGVmaW5lZApsZXQgREFUQV9E
RVZJQ0VfU1RBUlRfU0VDVE9SPSRNRVRBX0RFVklDRV9TVEFSVF9TRUNUT1Ir
JE1FVEFfREVWX1NJWkUKbGV0IFBBR0VTPSREQVRBX0RFVl9TSVpFLyRQQUdF
U0laRQpsZXQgU0VFSz0kUEFHRVNJWkUqNTEyLyRERF9CUwoKZWNobyAkRE1T
RVRVUCBMVU5JRD0kTFVOIERFVklDRT0kREVWSUNFX1BBVEggREVWSUNFX1NU
QVJUPSRNRVRBX0RFVklDRV9TVEFSVF9TRUNUT1IgTUVUQV9ERVZfU0laRT0k
TUVUQV9ERVZfU0laRSBEQVRBX0RFVl9TSVpFPSREQVRBX0RFVl9TSVpFICBQ
QUdFU0laRT0kUEFHRVNJWkUgRERfQlM9JEREX0JTIERBVEFfREVWSUNFX1NU
QVJUX1NFQ1RPUj0kREFUQV9ERVZJQ0VfU1RBUlRfU0VDVE9SIFBBR0VTPSRQ
QUdFUyBTRUVLPSRTRUVLIEJMT0NLUz0kQkxPQ0tTIExWTV9ERVZJQ0VfU0la
RT0kTFZNX0RFVklDRV9TSVpFCgpwdmNyZWF0ZSAgLU0yIC0tZGF0YWFsaWdu
bWVudCA0SyAtLW1ldGFkYXRhY29waWVzIDEgLS1tZXRhZGF0YXNpemUgOE0g
LS16ZXJvIHkgLXYgL2Rldi9yYW0KdmdjcmVhdGUgLWwgMTYzODQgLXMgOE0g
LWMgbiAtQSBuIDZDMDY3Q1dYMDAxMzItMSAvZGV2L3JhbQpsdmNyZWF0ZSAt
QSBuIC1DIG4gLWwgMTAwJVZHIC1aIHkgLW4gZW5naW5lZXJpbmcgLXIgTm9u
ZSA2QzA2N0NXWDAwMTMyLTEKCiMgcnVuIGRkIHRlc3Qgb24gc2V2ZXJhbCBk
ZXZpY2VzCgojd3JpdGUgc29tZXRoaW5nCmRkIGlmPS9kZXYvemVybyBvZj0v
ZGV2LzZDMDY3Q1dYMDAxMzItMS9lbmdpbmVlcmluZyBicz00MDk2IGNvdW50
PSRCTE9DS1MKCiNub3RlIHRoZSB0aW1lIG9uIGx2bSBkZXZpY2UKZGQgb2Y9
L2Rldi9udWxsIGlmPS9kZXYvNkMwNjdDV1gwMDEzMi0xL2VuZ2luZWVyaW5n
IGJzPTQwOTYgY291bnQ9JEJMT0NLUwoKbHZyZW1vdmUgLWYgL2Rldi82QzA2
N0NXWDAwMTMyLTEvZW5naW5lZXJpbmcKdmdyZW1vdmUgNkMwNjdDV1gwMDEz
Mi0xCnB2cmVtb3ZlIC9kZXYvcmFtCmx2ZGlzcGxheQp2Z2Rpc3BsYXkKcHZk
aXNwbGF5CmxzIC1sIC9kZXYvbWFwcGVyCgoKCgoKCg==

---2114655128-1682974902-1326416116=:56981
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


---2114655128-1682974902-1326416116=:56981--
