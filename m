From: Xinwei Hu <hxinwei@gmail.com>
Subject: Make device-mapper udev rules more friendly to udev
Date: Wed, 23 Jun 2010 20:45:12 +0800
Message-ID: <AANLkTilaLZ9vortsfcAZzYG0vDTmEpTR55bpkeREu5ZE@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00c09f971cb3b98d930489b1e86c
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--00c09f971cb3b98d930489b1e86c
Content-Type: text/plain; charset=UTF-8

Hi all,

  I found there're changes to udev/10-dm.rules.in, which tries to add
support for uevent triggered outside of libdevmapper.
Think this is a great step.

  In current situation, if an admin calls "echo add >
/sys/block/dm-N/uevent", the symlinks in /dev/mapper and
/dev/$VGNAME/ will still be removed anyway. I'm not sure who many
realistic application will trigger the 'add' event in users
space out side the libdevmapper. But I think it'll be more friendly to udev ;)

  The attached 10-dm.rules.in is an attempt on this direction. It
basically import{db} if the events are not trigged by libdevmapper.

  Please comment.

  Thanks.

--00c09f971cb3b98d930489b1e86c
Content-Type: application/octet-stream; name="lvm-10-dm.rules.in.diff"
Content-Disposition: attachment; filename="lvm-10-dm.rules.in.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gas5q02z0

NzRjNzQsNzcKPCBBQ1RJT049PSJhZGQiLCBFTlZ7U1RBUlRVUH0hPSIxIiwgTkFNRT0iIiwgR09U
Tz0iZG1fZW5kIgotLS0KPiBBQ1RJT049PSJhZGQiLCBFTlZ7U1RBUlRVUH0hPSIxIiwgRU5We0RN
X1VERVZfUFJJTUFSWV9TT1VSQ0VfRkxBR309PSIxIiwgTkFNRT0iIiwgR09UTz0iZG1fZW5kIgo+
IAo+ICMgSWYgaXQncyB0aGUgYXJ0aWZpY2lhbCBldmVudCBmcm9tIG90aGVyIHNvdXJjZQo+IEVO
VntETV9VREVWX1BSSU1BUllfU09VUkNFX0ZMQUd9IT0iMSIsIEdPVE89ImRtX2FydGlmaWNpYWwi
CjkxYTk1LDExMwo+IAo+IEdPVE89ImRtX25vcm1hbHJ1bGUiCj4gCj4gTEFCRUw9ImRtX2FydGlm
aWNpYWwiCj4gSU1QT1JUe2RifT0iRE1fTkFNRSIKPiBJTVBPUlR7ZGJ9PSJETV9VVUlEIgo+IElN
UE9SVHtkYn09IkRNX1NVU1BFTkRFRCIKPiBJTVBPUlR7ZGJ9PSJETV9TVEFURSIKPiBJTVBPUlR7
ZGJ9PSJETV9UQUJMRV9TVEFURSIKPiBJTVBPUlR7ZGJ9PSJETV9PUEVOQ09VTlQiCj4gSU1QT1JU
e2RifT0iRE1fTEFTVF9FVkVOVF9OUiIKPiBJTVBPUlR7ZGJ9PSJETV9NQUpPUiIKPiBJTVBPUlR7
ZGJ9PSJETV9NSU5PUiIKPiBJTVBPUlR7ZGJ9PSJETV9UQVJHRVRfQ09VTlQiCj4gSU1QT1JUe2Ri
fT0iRE1fVEFSR0VUX1RZUEVTIgo+IElNUE9SVHtkYn09IkRNX0RFUFMiCj4gSU1QT1JUe2RifT0i
RE1fVFlQRSIKPiAKPiBMQUJFTD0iZG1fbm9ybWFscnVsZSIK
--00c09f971cb3b98d930489b1e86c
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--00c09f971cb3b98d930489b1e86c--
