From: Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
Subject: Re: [PATCH 1/8] block: Remove REQ_OP_ZONE_RESET plugging
Date: Tue, 29 Oct 2019 13:13:16 +0100
Message-ID: <20191029121316.o7o7cjurn6qp2gse@MacBook-Pro.gnusmas>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
	<20191027140549.26272-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191027140549.26272-2-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ajay Joshi <ajay.joshi@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>, Hans Holmberg <Hans.Holmberg@wdc.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: dm-devel.ids

T24gMjcuMTAuMjAxOSAyMzowNSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj5SRVFfT1BfWk9ORV9S
RVNFVCBvcGVyYXRpb25zIGNhbm5vdCBiZSBtZXJnZWQgYXMgdGhlc2UgYmlvcyBhbmQgcmVxdWVz
dHMKPmRvIG5vdCBoYXZlIGEgc2l6ZSBhbmQgYXJlIG5ldmVyIHNlcXVlbnRpYWwgZHVlIHRvIHRo
ZSB6b25lIHN0YXJ0IHNlY3Rvcgo+cG9zaXRpb24gcmVxdWlyZWQgZm9yIHRoZWlyIGV4ZWN1dGlv
bi4gQXMgYSByZXN1bHQsIHRoZXJlIGlzIG5vIHBvaW50IGluCj51c2luZyBhIHBsdWcgYXJvdW5k
IGJsa2Rldl9yZXNldF96b25lcygpIGJpbyBpc3N1aW5nIGxvb3AuIFRoaXMgcGF0Y2gKPnJlbW92
ZXMgdGhpcyB1bm5lY2Vzc2FyeSBwbHVnZ2luZy4KPgo+U2lnbmVkLW9mZi1ieTogRGFtaWVuIExl
IE1vYWwgPGRhbWllbi5sZW1vYWxAd2RjLmNvbT4KPi0tLQo+IGJsb2NrL2Jsay16b25lZC5jIHwg
NCAtLS0tCj4gMSBmaWxlIGNoYW5nZWQsIDQgZGVsZXRpb25zKC0pCj4KPmRpZmYgLS1naXQgYS9i
bG9jay9ibGstem9uZWQuYyBiL2Jsb2NrL2Jsay16b25lZC5jCj5pbmRleCA0YmM1ZjI2MDI0OGEu
LjdmZTM3NmVlZGU4NiAxMDA2NDQKPi0tLSBhL2Jsb2NrL2Jsay16b25lZC5jCj4rKysgYi9ibG9j
ay9ibGstem9uZWQuYwo+QEAgLTI1OCw3ICsyNTgsNiBAQCBpbnQgYmxrZGV2X3Jlc2V0X3pvbmVz
KHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCj4gCXNlY3Rvcl90IHpvbmVfc2VjdG9yczsKPiAJ
c2VjdG9yX3QgZW5kX3NlY3RvciA9IHNlY3RvciArIG5yX3NlY3RvcnM7Cj4gCXN0cnVjdCBiaW8g
KmJpbyA9IE5VTEw7Cj4tCXN0cnVjdCBibGtfcGx1ZyBwbHVnOwo+IAlpbnQgcmV0Owo+Cj4gCWlm
ICghYmxrX3F1ZXVlX2lzX3pvbmVkKHEpKQo+QEAgLTI4Myw3ICsyODIsNiBAQCBpbnQgYmxrZGV2
X3Jlc2V0X3pvbmVzKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsCj4gCSAgICBlbmRfc2VjdG9y
ICE9IGJkZXYtPmJkX3BhcnQtPm5yX3NlY3RzKQo+IAkJcmV0dXJuIC1FSU5WQUw7Cj4KPi0JYmxr
X3N0YXJ0X3BsdWcoJnBsdWcpOwo+IAl3aGlsZSAoc2VjdG9yIDwgZW5kX3NlY3Rvcikgewo+Cj4g
CQliaW8gPSBibGtfbmV4dF9iaW8oYmlvLCAwLCBnZnBfbWFzayk7Cj5AQCAtMzAxLDggKzI5OSw2
IEBAIGludCBibGtkZXZfcmVzZXRfem9uZXMoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwKPiAJ
cmV0ID0gc3VibWl0X2Jpb193YWl0KGJpbyk7Cj4gCWJpb19wdXQoYmlvKTsKPgo+LQlibGtfZmlu
aXNoX3BsdWcoJnBsdWcpOwo+LQo+IAlyZXR1cm4gcmV0Owo+IH0KPiBFWFBPUlRfU1lNQk9MX0dQ
TChibGtkZXZfcmVzZXRfem9uZXMpOwo+LS0gCj4yLjIxLjAKPgoKTG9va3MgZ29vZCB0byBtZS4K
ClJldmlld2VkLWJ5OiBKYXZpZXIgR29uesOhbGV6IDxqYXZpZXJAamF2aWdvbi5jb20+CgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
