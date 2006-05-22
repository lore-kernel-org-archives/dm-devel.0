From: <Thomas.vonSteiger@swisscom.com>
Subject: RE: [Consult-list] Re: dm-multipath has greatthroughput
	but we'd like more!
Date: Mon, 22 May 2006 19:21:23 +0200
Message-ID: <D98EDC8DA509404185E74C0DFA2BF42D1EAC52@sg1255z.corproot.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C67DC4.2698A4BF"
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, rgautier@redhat.com
Cc: consult-list@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C67DC4.2698A4BF
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Interessting Discussion!

If you are running in a big enterprise SAN then it's possible that your
server shares the HDS Port with 30 other servers.

I have done
"bonnie++ -d /iotest -s 6g -f -n 0 -u root" on AMD LS20 IBM Blade
2x2Gb's qla HBA's / 3Gb Mem
and
"bonnie++ -d /iotest -s 8g -f -n 0 -u root" on Intel HS20 IBM Blade /
2x2Gb's qla HBA's / 4Gb Mem.
SAN Storage (HDS USP100) with dm-multipath (failover and multibus) for
ext3 and ext2.
OS are RHEL4/U3.

Results are in the att bonnue1.html

Defaults from /etc/multipath.conf:
defaults {
   udev_dir                /dev
   polling_interval        10
   selector                "round-robin 0"
   default_path_grouping_policy   multibus
   getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
   prio_callout            /bin/true
   path_checker            readsector0
   rr_min_io               100
   rr_weight               priorities
   failback                immediate
   no_path_retry           20
   user_friendly_name      yes
}

Thomas



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Nicholas C. Strugnell
Sent: Thursday, May 18, 2006 11:43 AM
To: rgautier@redhat.com
Cc: device-mapper development; consult-list@redhat.com
Subject: Re: [Consult-list] Re: [dm-devel] dm-multipath has
greatthroughput but we'd like more!

On Thu, 2006-05-18 at 10:04 +0200, Nicholas C. Strugnell wrote:=20
> On Thu, 2006-05-18 at 08:44 +0100, Bob Gautier wrote:
> > On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
> > > The system bus isn't a limiting factor is it?  64-bit PCI-X will=20
> > > get
> > > 8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.
> > >=20
> > > Can your disks sustain that much bandwidth? 10 striped drives=20
> > > might get better than 200MB/s if done right, I suppose.
> > >=20
>=20

> It might make sense to test raw writes to a device with dd and see if=20
> that gets comparable performance figures - I'll just try that myself=20
> actually.

write throughput to EVA 8000 (8GB write cache), host DL380 with 2x2Gb/s
HBAs, 2GB RAM

testing 4GB files:

on filesystems: bonnie++ -d /mnt/tmp -s 4g -f -n 0 -u root

ext3: 129MB/s sd=3D0.43

ext2: 202MB/s sd=3D21.34
q
on raw: 216MB/s sd=3D3.93  (dd if=3D/dev/zero
of=3D/dev/mpath/3600508b4001048ba0000b00001400000 bs=3D4k =
count=3D1048576)


NB I did not have exclusive access to the SAN or this particular storage
array - this is a big corp. SAN network under quite heavy load and disk
array under moderate load - not even sure if I had exclusive access to
the disks. All values averaged over 20 runs.=20

The very low deviation of write speed on ext3 vs. exr2 or raw is
interesting - not sure if it means anything.

In any case, we don't manage to get very close to the theoretical
throughput of the 2 HBAs, 512MB/s

Nick



--=20
M: +44 (0)7736 665171           Skype: nstrug
http://europe.redhat.com
GPG FPR: 9C6C 093C 756A 6C57 49A1  E211 BBBA F5F5 C440 5DE0


------_=_NextPart_001_01C67DC4.2698A4BF
Content-Type: text/html;
	name="bonnie1.html"
Content-Transfer-Encoding: base64
Content-Description: bonnie1.html
Content-Disposition: attachment;
	filename="bonnie1.html"

PCFET0NUWVBFIEhUTUwgUFVCTElDICItLy9XM0MvL0RURCBIVE1MIDQuMC8vRU4iICJodHRwOi8v
d3d3LnczLm9yZy9UUi9SRUMtaHRtbDQwL3N0cmljdC5kdGQiPgo8aHRtbD4KPGhlYWQ+CiAgPHRp
dGxlPkJvbm5pZSsrIFYxLjAzIEJlbmNobWFyayByZXN1bHRzPC90aXRsZT4KICA8c3R5bGUgdHlw
ZT0idGV4dC9jc3MiPgpURC5oZWFkZXIge3RleHQtYWxpZ246IGNlbnRlcjsgYmFja2dyb3VuZGNv
bG9yOiAiI0NDRkZGRiIgfQpURC5yb3doZWFkZXIge3RleHQtYWxpZ246IGNlbnRlcjsgYmFja2dy
b3VuZGNvbG9yOiAiI0NDQ0ZGRiIgfQpURC5zaXplIHt0ZXh0LWFsaWduOiBjZW50ZXI7IGJhY2tn
cm91bmRjb2xvcjogIiNDQ0NGRkYiIH0KVEQua3NlYyB7dGV4dC1hbGlnbjogY2VudGVyOyBmb250
c3R5bGU6IGl0YWxpYyB9CiAgPC9zdHlsZT4KPC9oZWFkPgo8Ym9keT4KPHRhYmxlIHN0eWxlPSJ3
aWR0aDogODE5cHg7IGhlaWdodDogNDc0cHg7IiBhbGlnbj0iY2VudGVyIiBib3JkZXI9IjMiCiBj
ZWxscGFkZGluZz0iMiIgY2VsbHNwYWNpbmc9IjEiPgogIDx0Ym9keT4KICAgIDx0cj4KICAgICAg
PHRkIGNvbHNwYW49IjIiIGNsYXNzPSJoZWFkZXIiPjxicj4KICAgICAgPC90ZD4KICAgICAgPHRk
IGNvbHNwYW49IjYiIGNsYXNzPSJoZWFkZXIiPjxmb250IHNpemU9IisyIj48Yj5TZXF1ZW50aWFs
Ck91dHB1dDwvYj48L2ZvbnQ+PC90ZD4KICAgICAgPHRkIGNvbHNwYW49IjQiIGNsYXNzPSJoZWFk
ZXIiPjxmb250IHNpemU9IisyIj48Yj5TZXF1ZW50aWFsIElucHV0PC9iPjwvZm9udD48L3RkPgog
ICAgICA8dGQgY29sc3Bhbj0iMiIgcm93c3Bhbj0iMiIgY2xhc3M9ImhlYWRlciI+PGZvbnQgc2l6
ZT0iKzIiPjxiPlJhbmRvbTxicj4KU2Vla3M8L2I+PC9mb250PjwvdGQ+CiAgICA8L3RyPgogICAg
PHRyPgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8dGQ+U2l6ZTpDaHVuayBTaXpl
PC90ZD4KICAgICAgPHRkIGNvbHNwYW49IjIiPlBlciBDaGFyPC90ZD4KICAgICAgPHRkIGNvbHNw
YW49IjIiPkJsb2NrPC90ZD4KICAgICAgPHRkIGNvbHNwYW49IjIiPlJld3JpdGU8L3RkPgogICAg
ICA8dGQgY29sc3Bhbj0iMiI+UGVyIENoYXI8L3RkPgogICAgICA8dGQgY29sc3Bhbj0iMiI+Qmxv
Y2s8L3RkPgogICAgPC90cj4KICAgIDx0cj4KICAgICAgPHRkIGNvbHNwYW49IjIiPjxicj4KICAg
ICAgPC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+Sy9zZWM8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+JSBDUFU8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+Sy9zZWM8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+JSBDUFU8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+Sy9zZWM8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+JSBDUFU8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+Sy9zZWM8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+JSBDUFU8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+Sy9zZWM8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+JSBDUFU8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+LyBzZWM8L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJrc2VjIj48Zm9udCBzaXplPSItMiI+JSBDUFU8L2Zv
bnQ+PC90ZD4KICAgIDwvdHI+CiAgICA8dHI+CiAgICAgIDx0ZCBjbGFzcz0icm93aGVhZGVyIj48
Zm9udCBzaXplPSIrMSI+PGI+aTY4Ni9leHQzL2RtLW11bHRpcGF0aC9mYWlsb3ZlcjwvYj48L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJzaXplIj44RzwvdGQ+CiAgICAgIDx0ZD48YnI+CiAg
ICAgIDwvdGQ+CiAgICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0ZD4xNDcxMzg8L3Rk
PgogICAgICA8dGQ+Njc8L3RkPgogICAgICA8dGQ+NTc4OTQ8L3RkPgogICAgICA8dGQ+MTg8L3Rk
PgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgog
ICAgICA8dGQ+MTIyMzY1PC90ZD4KICAgICAgPHRkPjE0PC90ZD4KICAgICAgPHRkPjE5MzkuMDwv
dGQ+CiAgICAgIDx0ZD41PC90ZD4KICAgIDwvdHI+CiAgICA8dHI+CiAgICAgIDx0ZCBjbGFzcz0i
cm93aGVhZGVyIj48Zm9udCBzaXplPSIrMSI+PGI+aTY4Ni9leHQyL2RtLW11bHRpcGF0aC9mYWls
b3ZlcjwvYj48L2ZvbnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJzaXplIj44RzwvdGQ+CiAgICAg
IDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0
ZD4xOTI2NDI8L3RkPgogICAgICA8dGQ+Mzg8L3RkPgogICAgICA8dGQ+NTQ2ODQ8L3RkPgogICAg
ICA8dGQ+MTQ8L3RkPgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8dGQ+PGJyPgog
ICAgICA8L3RkPgogICAgICA8dGQ+NjY2OTY8L3RkPgogICAgICA8dGQ+ODwvdGQ+CiAgICAgIDx0
ZD4zNDYuNjwvdGQ+CiAgICAgIDx0ZD4wPC90ZD4KICAgIDwvdHI+CiAgICA8dHI+CiAgICAgIDx0
ZCBjbGFzcz0icm93aGVhZGVyIj48Zm9udCBzaXplPSIrMSI+PGI+aTY4Ni9leHQzL2RtLW11bHRp
cGF0aC9tdWx0aWJ1czwvYj48L2ZvbnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJzaXplIj44Rzwv
dGQ+CiAgICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+
CiAgICAgIDx0ZD4yMDM3Njk8L3RkPgogICAgICA8dGQ+OTI8L3RkPgogICAgICA8dGQ+NTY0MDk8
L3RkPgogICAgICA8dGQ+MTg8L3RkPgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8
dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8dGQ+ODU4Mjc8L3RkPgogICAgICA8dGQ+MTE8L3Rk
PgogICAgICA8dGQ+Njc4LjM8L3RkPgogICAgICA8dGQ+MTwvdGQ+CiAgICA8L3RyPgogICAgPHRy
PgogICAgICA8dGQgY2xhc3M9InJvd2hlYWRlciI+PGZvbnQgc2l6ZT0iKzEiPjxiPmk2ODYvZXh0
Mi9kbS1tdWx0aXBhdGgvbXVsdGlidXM8L2I+PC9mb250PjwvdGQ+CiAgICAgIDx0ZCBjbGFzcz0i
c2l6ZSI+OEc8L3RkPgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8dGQ+PGJyPgog
ICAgICA8L3RkPgogICAgICA8dGQ+MzI1MTQ4PC90ZD4KICAgICAgPHRkPjY4PC90ZD4KICAgICAg
PHRkPjYwMjY2PC90ZD4KICAgICAgPHRkPjE2PC90ZD4KICAgICAgPHRkPjxicj4KICAgICAgPC90
ZD4KICAgICAgPHRkPjxicj4KICAgICAgPC90ZD4KICAgICAgPHRkPjEwMTQ5ODwvdGQ+CiAgICAg
IDx0ZD4xMjwvdGQ+CiAgICAgIDx0ZD43MDkuMTwvdGQ+CiAgICAgIDx0ZD4xPC90ZD4KICAgIDwv
dHI+CiAgICA8dHI+CiAgICAgIDx0ZCBjbGFzcz0icm93aGVhZGVyIj48Zm9udCBzaXplPSIrMSI+
PGI+eDg2XzY0L2V4dDMvZG0tbXVsdGlwYXRoL2ZhaWxvdmVyPC9iPjwvZm9udD48L3RkPgogICAg
ICA8dGQgY2xhc3M9InNpemUiPjZHPC90ZD4KICAgICAgPHRkPjxicj4KICAgICAgPC90ZD4KICAg
ICAgPHRkPjxicj4KICAgICAgPC90ZD4KICAgICAgPHRkPjE4MjcxNjwvdGQ+CiAgICAgIDx0ZD41
NjwvdGQ+CiAgICAgIDx0ZD41ODkzMTwvdGQ+CiAgICAgIDx0ZD4xMjwvdGQ+CiAgICAgIDx0ZD48
YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0ZD4xMTc3
Mzg8L3RkPgogICAgICA8dGQ+MTE8L3RkPgogICAgICA8dGQ+OTcxLjM8L3RkPgogICAgICA8dGQ+
MTwvdGQ+CiAgICA8L3RyPgogICAgPHRyPgogICAgICA8dGQgY2xhc3M9InJvd2hlYWRlciI+PGZv
bnQgc2l6ZT0iKzEiPjxiPng4Nl82NC9leHQyL2RtLW11bHRpcGF0aC9mYWlsb3ZlcjwvYj48L2Zv
bnQ+PC90ZD4KICAgICAgPHRkIGNsYXNzPSJzaXplIj42RzwvdGQ+CiAgICAgIDx0ZD48YnI+CiAg
ICAgIDwvdGQ+CiAgICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0ZD4yMDAwOTA8L3Rk
PgogICAgICA8dGQ+Mjc8L3RkPgogICAgICA8dGQ+NjgwODE8L3RkPgogICAgICA8dGQ+MTM8L3Rk
PgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgog
ICAgICA8dGQ+MTE0MjE5PC90ZD4KICAgICAgPHRkPjEyPC90ZD4KICAgICAgPHRkPjkwMy41PC90
ZD4KICAgICAgPHRkPjE8L3RkPgogICAgPC90cj4KICAgIDx0cj4KICAgICAgPHRkIGNsYXNzPSJy
b3doZWFkZXIiPjxmb250IHNpemU9IisxIj48Yj54ODZfNjQvZXh0My9kbS1tdWx0aXBhdGgvbXVs
dGlidXM8L2I+PC9mb250PjwvdGQ+CiAgICAgIDx0ZCBjbGFzcz0ic2l6ZSI+Nkc8L3RkPgogICAg
ICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8dGQ+PGJyPgogICAgICA8L3RkPgogICAgICA8
dGQ+MjUwMzM0PC90ZD4KICAgICAgPHRkPjg4PC90ZD4KICAgICAgPHRkPjY4ODYxPC90ZD4KICAg
ICAgPHRkPjE2PC90ZD4KICAgICAgPHRkPjxicj4KICAgICAgPC90ZD4KICAgICAgPHRkPjxicj4K
ICAgICAgPC90ZD4KICAgICAgPHRkPjExNzc4NzwvdGQ+CiAgICAgIDx0ZD4xMjwvdGQ+CiAgICAg
IDx0ZD45MTYuMzwvdGQ+CiAgICAgIDx0ZD4xPC90ZD4KICAgIDwvdHI+CiAgICA8dHI+CiAgICAg
IDx0ZCBjbGFzcz0icm93aGVhZGVyIj48Zm9udCBzaXplPSIrMSI+PGI+eDg2XzY0L2V4dDIvZG0t
bXVsdGlwYXRoL211bHRpYnVzPC9iPjwvZm9udD48L3RkPgogICAgICA8dGQgY2xhc3M9InNpemUi
PjZHPC90ZD4KICAgICAgPHRkPjxicj4KICAgICAgPC90ZD4KICAgICAgPHRkPjxicj4KICAgICAg
PC90ZD4KICAgICAgPHRkPjM2MzMyMzwvdGQ+CiAgICAgIDx0ZD40ODwvdGQ+CiAgICAgIDx0ZD42
OTU2MDwvdGQ+CiAgICAgIDx0ZD4xMzwvdGQ+CiAgICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAg
ICAgIDx0ZD48YnI+CiAgICAgIDwvdGQ+CiAgICAgIDx0ZD4xMDg4Nzk8L3RkPgogICAgICA8dGQ+
MTE8L3RkPgogICAgICA8dGQ+ODI4Ljg8L3RkPgogICAgICA8dGQ+MTwvdGQ+CiAgICA8L3RyPgog
IDwvdGJvZHk+CjwvdGFibGU+CjwvYm9keT4KPC9odG1sPgo=

------_=_NextPart_001_01C67DC4.2698A4BF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C67DC4.2698A4BF--
