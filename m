From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 0/3][RESEND]multipath-tools: mpathpersist
 utility for managing persistent reservation on dm multipath device.
Date: Sat, 11 Feb 2012 09:43:06 +0100
Message-ID: <1328949786.2617.6.camel@lapoo.opensvc.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D07D9B409@BTCMVEXC2-PRD.hq.netapp.com>
	<4F197EEB.3050805@internyc.net>
	<F200AD42A082BC4088B232D13A916A89E24A@SACEXCMBX02-PRD.hq.netapp.com>
	<4F1E4785.7010806@internyc.net>
	<F200AD42A082BC4088B232D13A916A89EA01@SACEXCMBX02-PRD.hq.netapp.com>
	<4F2022D3.2070609@internyc.net>
	<F200AD42A082BC4088B232D13A916A89EC06@SACEXCMBX02-PRD.hq.netapp.com>
	<4F206C34.4030401@internyc.net>
	<F200AD42A082BC4088B232D13A916A8901045C@SACEXCMBX02-PRD.hq.netapp.com>
	<4F28B517.2030109@internyc.net>
	<F200AD42A082BC4088B232D13A916A89011BC1@SACEXCMBX02-PRD.hq.netapp.com>
	<b0igk7.lz3in5.1hge0zf-qmf@smtp1-g21.free.fr>
	<F200AD42A082BC4088B232D13A916A890124D9@SACEXCMBX02-PRD.hq.netapp.com>
	<1328857210.17706.4.camel@lapoo.opensvc.com>
	<F200AD42A082BC4088B232D13A916A890125CF@SACEXCMBX02-PRD.hq.netapp.com>
	<wi7l65.lz6iq4.31ap0z-qmf@mx.google.com>
	<F200AD42A082BC4088B232D13A916A8901275B@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F200AD42A082BC4088B232D13A916A8901275B@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gdmVuLiwgMjAxMi0wMi0xMCBhdCAxODo0NyArMDAwMCwgQ2hhdWhhbiwgVmlqYXkgd3JvdGU6
Cj4gZ2l0Oi8vZ2l0aHViLmNvbS92aWpheWNoYXVoYW4vbXVsdGlwYXRoLXRvb2xzLmdpdAoKT2su
IFRoaXMgcmVwbyBpcyBtZXJnZWQuCgpJIGhhZCB0byBhZGQgYSBzbWFsbCBidWlsZCBmaXguIENh
biB5b3UgdmVyaWZ5IGl0J3MgY29ycmVjdG5lc3MgPwoKQXJlIHlvdSBzdXJlIHRoZSAtSCAoaGV4
KSBmbGFnIGlzIHVzZWQgPyBnY2MgcmVwb3J0cyB0aGUgZmxhZyBhcyB1bnVzZWQuCklmIGl0J3Mg
bm90IHVzZWQgSSB0aGluayB5b3Ugc2hvdWxkIGVpdGhlciByZW1vdmUgaXQgZnJvbSB0aGUgdXNh
Z2UKbWVzc2FnZSBhbmQgbWFuIG9yIGFkZCB0aGUgZmVhdHVyZS4KCk9uIHRoZSBzYW1lIHRvcGlj
OgppbiBtcGF0aHBlcnNpc3QsCm1haW4uYzo0MDM6NzogYXR0ZW50aW9uIDogdmFyaWFibGUg4oCY
dF9hcnJfbGVu4oCZIHNldCBidXQgbm90IHVzZWQKWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVd
CgphbmQgaW4gbGlibXBhdGhwZXJzaXN0LAptcGF0aF9wZXJzaXN0LmM6IEluIGZ1bmN0aW9uIOKA
mG1wYXRoX3NlbmRfcHJpbl9hY3RpdmVwYXRo4oCZOgptcGF0aF9wZXJzaXN0LmM6Mzk3OjIwOiBh
dHRlbnRpb24gOiB2YXJpYWJsZSDigJhwYXJhbeKAmSBzZXQgYnV0IG5vdCB1c2VkClstV3VudXNl
ZC1idXQtc2V0LXZhcmlhYmxlXQptcGF0aF9wZXJzaXN0LmM6IEluIGZ1bmN0aW9uIOKAmG1wYXRo
X3Byb3V0X2NvbW1vbuKAmToKbXBhdGhfcGVyc2lzdC5jOjU1MzoxNTogYXR0ZW50aW9uIDogdmFy
aWFibGUg4oCYcHB0ZW1w4oCZIHNldCBidXQgbm90IHVzZWQKWy1XdW51c2VkLWJ1dC1zZXQtdmFy
aWFibGVdCm1wYXRoX3ByX2lvY3RsLmM6IEluIGZ1bmN0aW9uIOKAmGR1bXBIZXjigJk6Cm1wYXRo
X3ByX2lvY3RsLmM6NTE5OjE1OiBhdHRlbnRpb24gOiB2YXJpYWJsZSDigJhmb3JtYXRzdHLigJkg
c2V0IGJ1dCBub3QKdXNlZCBbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0KCgpBbHNvIEkgdGhv
dWdoIHNnX3BlcnNpc3QgaGFzIElOIG1vZGUgc2V0IGFzIGRlZmF1bHQsIHNvIHRoYXQgc2ltcGxl
CmNvbW1hbmRzIGFyZSBzaW1wbGUgdG8gd3JpdGUgOiBzZ19wZXJzaXN0IC1yIC9kZXYvc2RhLiBD
YW4gd2UgcmVzdG9yZQp0aGF0IG5pY2UgZmVhdHVyZSA/CgpBbnl3YXksIHRoYW5rcyBmb3IgdGhl
IGdyZWF0IHdvcmsuCgpSZWdhcmRzLApjdmFyb3F1aQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs
