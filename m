From: "Erez Zilber" <erezz@voltaire.com>
Subject: RE: About using multipath in SLES 10
Date: Mon, 28 Jan 2008 19:49:52 +0200
Message-ID: <39C75744D164D948A170E9792AF8E7CA110B91@exil.voltaire.com>
References: <479DF5C8.6050909@Voltaire.COM> <20080128163651.GB17040@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C861D6.2F3D788C"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------_=_NextPart_001_01C861D6.2F3D788C
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> > I understand that sdc & sdd are mapped to dm-1. However, I don't
> > understand how to use dm-1. For example, I can't run INQUIRY on it:
> >
> > seed1:~ # sg_inq /dev/dm-1
> > Both SCSI INQUIRY and fetching ATA information failed on /dev/dm-1
>=20
> All things that work on /dev/sdc may not work on /dev/dm-1. You should
> use /dev/sdc instead of /dev/dm-1 for those cases. You should be able =
to
> use /dev/dm-1 for normal I/O (like dd, mounting etc.)

I understand. I've tried disktest, and it work ok. I have another =
question - I'm running a single iSCSI initiator against 2 iSCSI target. =
I started disktest on /dev/dm-1 and after a few seconds, I disconnected =
the primary target. It took ~2 minutes until it failed over to the =
secondary device. During these ~2 minutes, it seemed that disktest is =
still reading data from the target, just slower. That's very strange. =
After failover was completed, I was able to use the secondary device.
=20
I have 2 questions:

1.=09
	Which parameter in  multipath.conf do I need to change in order to =
failover in a few seconds? Is it polling_interval? I saw that the =
default value is 5 seconds, which should be ok.
2.=09
	Before multipath decided that it needs to failover, why did I see that =
traffic is still running? It had no device to work with at that time.

Thanks,

Erez


------_=_NextPart_001_01C861D6.2F3D788C
Content-Type: application/ms-tnef;
	name="winmail.dat"
Content-Transfer-Encoding: base64

eJ8+IjURAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEIgAcAGAAAAElQTS5NaWNy
b3NvZnQgTWFpbC5Ob3RlADEIAQ2ABAACAAAAAgACAAEEgAEAMAAAAFJFOiBbZG0tZGV2ZWxdIEFi
b3V0IHVzaW5nIG11bHRpcGF0aCBpbiBTTEVTIDEwAN8PAQWAAwAOAAAA2AcBABwAEwAxADQAAQB1
AQEggAMADgAAANgHAQAcABMAMQA0AAEAdQEBCYABACEAAAAzMDY2NTdFMzVGMUI5NTRBQUYzODE2
RjE2RkM5QjM3NwAvBwEDkAYAPA8AADgAAAADADYAAAAAAEAAOQCMeD0v1mHIAR4APQABAAAABQAA
AFJFOiAAAAAAAgFHAAEAAAA2AAAAYz1VUzthPSA7cD1Wb2x0YWlyZSBBZHZhbmNlO2w9RVhJTC0w
ODAxMjgxNzQ5NTJaLTUzMjkAAAAeAEkAAQAAADAAAABSZTogW2RtLWRldmVsXSBBYm91dCB1c2lu
ZyBtdWx0aXBhdGggaW4gU0xFUyAxMABAAE4AgFPA+8thyAEeAFoAAQAAABwAAABkbS1kZXZlbC1i
b3VuY2VzQHJlZGhhdC5jb20AAgFbAAEAAABVAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAAAAZG0t
ZGV2ZWwtYm91bmNlc0ByZWRoYXQuY29tAFNNVFAAZG0tZGV2ZWwtYm91bmNlc0ByZWRoYXQuY29t
AAAAAAIBXAABAAAAIQAAAFNNVFA6RE0tREVWRUwtQk9VTkNFU0BSRURIQVQuQ09NAAAAAB4AXQAB
AAAAEwAAAG1hbGFoYWxAdXMuaWJtLmNvbQAAAgFeAAEAAABDAAAAAAAAAIErH6S+oxAZnW4A3QEP
VAIAAAAAbWFsYWhhbEB1cy5pYm0uY29tAFNNVFAAbWFsYWhhbEB1cy5pYm0uY29tAAACAV8AAQAA
ABgAAABTTVRQOk1BTEFIQUxAVVMuSUJNLkNPTQAeAGYAAQAAAAUAAABTTVRQAAAAAB4AZwABAAAA
HAAAAGRtLWRldmVsLWJvdW5jZXNAcmVkaGF0LmNvbQAeAGgAAQAAAAUAAABTTVRQAAAAAB4AaQAB
AAAAEwAAAG1hbGFoYWxAdXMuaWJtLmNvbQAAHgBwAAEAAAAsAAAAW2RtLWRldmVsXSBBYm91dCB1
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
dZDKonYhWUC+clWhS6LLZy+BvDs/RqDzzSDA4XBvg3DDkWrhu/HudpjgMdEkQGFWUcWivhJ/H1B2
8C1hyhCY4LUgxmI1/byIdyaDkNiz4fmv+r/7z//83xgP/v8ADyn/OpQ9gQ9C/wzvDf8PDxAfHh8f
LyA/IU/9FWMyFc8W3zt/GP8aDzmv9xwvHT8RWTNF30bvR/8iP/cjTyRfJW9CNHCYcDcALVf5wtFj
aVMQxXXA4S6Sg/H/MCg2As7BW3C5gmowM8XKkP5mFLCOEcaHthQx0RWQxaDfvfCFsMLVMAKzk3fA
4Caw/zPzM/K+cM8/OE85XzpvS6//PI89nz6vP79oTwlwaYsK079qT2ifaa8Mv0GPQpVQTf+fcc9X
b1h/DDnJsW5rvPD/Yv9kD1Q6Zr9nxAo9dU9rWf90cXIfcy90P38vdl93b+F++kXHAHp7f3yPfZ9+
r3+/uYDPZzKFwnsFgRs1j0JQQk9EWY4+N3BRSBRUTW2BfZLwHgA1EAEAAAA7AAAAPDM5Qzc1NzQ0
RDE2NEQ5NDhBMTcwRTk3OTJBRjhFN0NBMTEwQjkxQGV4aWwudm9sdGFpcmUuY29tPgAAHgA5EAEA
AABEAAAAPDQ3OURGNUM4LjYwNTA5MDlAVm9sdGFpcmUuQ09NPiA8MjAwODAxMjgxNjM2NTEuR0Ix
NzA0MEB1cy5pYm0uY29tPgAeAEcQAQAAAA8AAABtZXNzYWdlL3JmYzgyMgAACwDyEAEAAAAfAPMQ
AQAAAGwAAABSAEUAJQAzAEEAIABbAGQAbQAtAGQAZQB2AGUAbABdACAAQQBiAG8AdQB0ACAAdQBz
AGkAbgBnACAAbQB1AGwAdABpAHAAYQB0AGgAIABpAG4AIABTAEwARQBTACAAMQAwAC4ARQBNAEwA
AAALAPYQAAAAAEAABzDqptgU1WHIAUAACDDwAUcv1mHIAQMA3j+vbwAAAwDxPwkEAAAeAPg/AQAA
AAwAAABFcmV6IFppbGJlcgACAfk/AQAAAGoAAAAAAAAA3KdAyMBCEBq0uQgAKy/hggEAAAAAAAAA
L089Vk9MVEFJUkUgQURWQU5DRUQgREFUQSBTRUNVUklUWS9PVT1WT0xUQUlSRS9DTj1SRUNJUElF
TlRTL0NOPUVSRVpaMDg1MTEzMjAAAAAeAPo/AQAAABUAAABTeXN0ZW0gQWRtaW5pc3RyYXRvcgAA
AAACAfs/AQAAAB4AAAAAAAAA3KdAyMBCEBq0uQgAKy/hggEAAAAAAAAALgAAAAMA/T/kBAAAAwAZ
QAAAAAADABpAAAAAAAMAHUAAAAAAAwAeQAAAAAAeADBAAQAAAA4AAABFUkVaWjA4NTExMzIwAAAA
HgAxQAEAAAAOAAAARVJFWlowODUxMTMyMAAAAB4AMkABAAAAHAAAAGRtLWRldmVsLWJvdW5jZXNA
cmVkaGF0LmNvbQAeADNAAQAAABMAAABtYWxhaGFsQHVzLmlibS5jb20AAB4AOEABAAAADgAAAEVS
RVpaMDg1MTEzMjAAAAAeADlAAQAAAAIAAAAuAAAAAwB2QP////8LACkAAAAAAAsAIwAAAAAAAwAG
EOwEMl4DAAcQ+gMAAAMAEBACAAAAAwAREAAAAAAeAAgQAQAAAGUAAABJVU5ERVJTVEFORFRIQVRT
REMmU0REQVJFTUFQUEVEVE9ETS0xSE9XRVZFUixJRE9OVFVOREVSU1RBTkRIT1dUT1VTRURNLTFG
T1JFWEFNUExFLElDQU5UUlVOSU5RVUlSWU9OAAAAAAIBfwABAAAAOwAAADwzOUM3NTc0NEQxNjRE
OTQ4QTE3MEU5NzkyQUY4RTdDQTExMEI5MUBleGlsLnZvbHRhaXJlLmNvbT4AANLl

------_=_NextPart_001_01C861D6.2F3D788C
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------_=_NextPart_001_01C861D6.2F3D788C--
