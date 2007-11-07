From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Wed, 7 Nov 2007 09:07:41 -0600
Message-ID: <342d47870711070707s7ac0fca2w1fdda12fb73fc548@mail.gmail.com>
References: <342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
	<20071101215726.GB11002@linux.vnet.ibm.com>
	<342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
	<20071106222043.GA23178@linux.vnet.ibm.com>
	<342d47870711061433h6dce42baj705aca5ae7baa466@mail.gmail.com>
	<20071106230157.GA23800@linux.vnet.ibm.com>
	<342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>
	<20071107025935.GA22697@us.ibm.com>
	<20071107050925.GA25156@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_34290_30564644.1194448061826"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071107050925.GA25156@linux.vnet.ibm.com>
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

------=_Part_34290_30564644.1194448061826
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ok, if multipath is grabbing the HBA device so I'm unable to mount it,
that's fine, I will go with that.  So I re-enabled the iSCSI initiator
so that the NIC device would become active and I can see if multipath
will grab both of them.  No luck, but I'm ahead of where I was
previously, so here's my status.

In dmesg, both of the devices are being found on boot...

HBA-

scsi1 : qla4xxx
 QLogic iSCSI HBA Driver version: 5.01.00.08
  QLogic ISP4032 @ 0000:14:01.1 hdma+, host#=1, fw=03.00.01.24
  Vendor: EQLOGIC   Model: 100E-00           Rev: 2.3
  Type:   Direct-Access                      ANSI SCSI revision: 05
qla4xxx 0000:14:01.1: scsi(1:0:1:0): Enabled tagged queuing, queue depth 32.
SCSI device sdb: 8417280 512-byte hdwr sectors (4310 MB)
SCSI device sdb: drive cache: write through
 sdb: sdb1
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0

NIC-

scsi3 : SFNet iSCSI driver
  Vendor: EQLOGIC   Model: 100E-00           Rev: 2.3
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 8417280 512-byte hdwr sectors (4310 MB)
SCSI device sdc: drive cache: write through
 sdc: sdc1
Attached scsi disk sdc at scsi3, channel 0, id 0, lun 0

# multipath -l
30690a018f015191a6472441d1500f057
[size=4 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 1:0:1:0     sdb 8:16 [active][ready]

I'm attaching the output of "multipath -v4" since it's lengthy.
There's some references to sdc (although [faulty]) that I don't
understand, but maybe it will help troubleshoot?

My multipath.conf is setup in accordance with
http://kbase.redhat.com/faq/FAQ_51_7170.shtm .

Thanks,
Scott

------=_Part_34290_30564644.1194448061826
Content-Type: text/plain; name=multipath.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8pzdvf80
Content-Disposition: attachment; filename=multipath.txt

DQojIG11bHRpcGF0aCAtdjQNCmxvYWQgcGF0aCBpZGVudGlmaWVycyBjYWNoZQ0KIw0KIyBhbGwg
cGF0aHMgaW4gY2FjaGUgOg0KIw0KICAjOiM6IzojICBoZGEgMzowICBbZmF1bHR5XSAvLw0KMzA2
OTBhMDE4ZjAxNTE5MWE2NDcyNDQxZDE1MDBmMDU3ICAxOjA6MTowIHNkYiA4OjE2ICBbYWN0aXZl
XVtyZWFkeV0gRVFMT0dJQyAvDQogIDM6MDowOjAgc2RjIDg6MzIgIFtmYXVsdHldIEVRTE9HSUMg
LzEwMEUtMDAgICAgICAgICAvMi4zIA0KPT09PT0gcGF0aCBpbmZvIGhkYSAobWFzayAweDFmKSA9
PT09PQ0KYnVzID0gMg0KZGV2X3QgPSAzOjANCnNpemUgPSA4Mzg4NjA0DQpzZGEgYmxhY2tsaXN0
ZWQNCj09PT09IHBhdGggaW5mbyBzZGIgKG1hc2sgMHgxZikgPT09PT0NCmJ1cyA9IDENCmRldl90
ID0gODoxNg0Kc2l6ZSA9IDg0MTcyODANCnZlbmRvciA9IEVRTE9HSUMgDQpwcm9kdWN0ID0gMTAw
RS0wMCAgICAgICAgIA0KcmV2ID0gMi4zIA0KaDpiOnQ6bCA9IDE6MDoxOjANCnRndF9ub2RlX25h
bWUgPSANCnNlcmlhbCA9IDA2OTBBMDE4RjAxNTE5MUE2NDcyNDQxRDE1MDBGMDU3DQpwYXRoIGNo
ZWNrZXIgPSByZWFkc2VjdG9yMCAoaW50ZXJuYWwgZGVmYXVsdCkNCnN0YXRlID0gMg0KZ2V0cHJp
byA9IC9iaW4vdHJ1ZSAoaW50ZXJuYWwgZGVmYXVsdCkNCnByaW8gPSAwDQp1aWQgPSAzMDY5MGEw
MThmMDE1MTkxYTY0NzI0NDFkMTUwMGYwNTcgKGNhY2hlKQ0KPT09PT0gcGF0aCBpbmZvIHNkYyAo
bWFzayAweDFmKSA9PT09PQ0KYnVzID0gMQ0KZGV2X3QgPSA4OjMyDQpzaXplID0gODQxNzI4MA0K
dmVuZG9yID0gRVFMT0dJQyANCnByb2R1Y3QgPSAxMDBFLTAwICAgICAgICAgDQpyZXYgPSAyLjMg
DQpoOmI6dDpsID0gMzowOjA6MA0KdGd0X25vZGVfbmFtZSA9IA0KIw0KIyBhbGwgcGF0aHMgOg0K
Iw0KICAjOiM6IzojICBoZGEgMzowICBbZmF1bHR5XSAvLw0KMzA2OTBhMDE4ZjAxNTE5MWE2NDcy
NDQxZDE1MDBmMDU3ICAxOjA6MTowIHNkYiA4OjE2ICBbYWN0aXZlXVtyZWFkeV0gRVFMT0dJQyAv
DQogIDM6MDowOjAgc2RjIDg6MzIgIFtmYXVsdHldIEVRTE9HSUMgLzEwMEUtMDAgICAgICAgICAv
Mi4zIA0KcGFyYW1zID0gMCAwIDEgMSByb3VuZC1yb2JpbiAwIDEgMSA4OjE2IDEwMCANCnN0YXR1
cyA9IDEgMCAwIDEgMSBBIDAgMSAwIDg6MTYgQSAwIA0KKndvcmQgPSAwLCBsZW4gPSAxDQoqd29y
ZCA9IDAsIGxlbiA9IDENCip3b3JkID0gMSwgbGVuID0gMQ0KKndvcmQgPSAxLCBsZW4gPSAxDQoq
d29yZCA9IHJvdW5kLXJvYmluLCBsZW4gPSAxMQ0KKndvcmQgPSAwLCBsZW4gPSAxDQoqd29yZCA9
IDEsIGxlbiA9IDENCip3b3JkID0gMSwgbGVuID0gMQ0KKndvcmQgPSA4OjE2LCBsZW4gPSA0DQo9
PT09PSBwYXRoIGluZm8gc2RiIChtYXNrIDB4OCkgPT09PT0NCnByaW8gPSAwDQp1aWQgPSAzMDY5
MGEwMThmMDE1MTkxYTY0NzI0NDFkMTUwMGYwNTcgKGNhY2hlKQ0KKndvcmQgPSAxLCBsZW4gPSAx
DQoqd29yZCA9IDAsIGxlbiA9IDENCip3b3JkID0gMSwgbGVuID0gMQ0KKndvcmQgPSBBLCBsZW4g
PSAxDQoqd29yZCA9IDEsIGxlbiA9IDENCip3b3JkID0gMCwgbGVuID0gMQ0KKndvcmQgPSBBLCBs
ZW4gPSAxDQoqd29yZCA9IDAsIGxlbiA9IDENCnBncG9saWN5ID0gZmFpbG92ZXIgKGNvbmZpZyBm
aWxlIGRlZmF1bHQpDQpzZWxlY3RvciA9IHJvdW5kLXJvYmluIDAgKGludGVybmFsIGRlZmF1bHQp
DQpmZWF0dXJlcyA9IDAgKGludGVybmFsIGRlZmF1bHQpDQpod2hhbmRsZXIgPSAwIChpbnRlcm5h
bCBkZWZhdWx0KQ0KcnJfd2VpZ2h0ID0gMSAoaW50ZXJuYWwgZGVmYXVsdCkNCm5vX3BhdGhfcmV0
cnkgPSBOT05FIChpbnRlcm5hbCBkZWZhdWx0KQ0KcGdfdGltZW91dCA9IE5PTkUgKGludGVybmFs
IGRlZmF1bHQpDQowIDg0MTcyODAgbXVsdGlwYXRoIDAgMCAxIDEgcm91bmQtcm9iaW4gMCAxIDEg
ODoxNiAxMDANCnNldCBBQ1RfTk9USElORzogbWFwIHVuY2hhbmdlZA0K
------=_Part_34290_30564644.1194448061826
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_Part_34290_30564644.1194448061826--
