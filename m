From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath: partitions are not created on IBM 1746
 (SAS connection to DS3512)
Date: Sat, 12 Feb 2011 12:12:23 +0100
Message-ID: <1297509143.25123.3.camel@zezette>
References: <1297244251.10348.14.camel@tablet>
	<1297244976.29348.9.camel@zezette>  <1297246135.13836.6.camel@tablet>
	<1297246940.29348.11.camel@zezette> <1297501926.23532.15.camel@tablet>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1297501926.23532.15.camel@tablet>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Volkov <peter.volkov@gmail.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gc2FtLiwgMjAxMS0wMi0xMiBhdCAxMjoxMiArMDMwMCwgUGV0ZXIgVm9sa292IHdyb3RlOgo+
IFRoYW5rIHlvdSBDaHJpc3RvcGhlIGFuZCBNYWxhaGFsLgo+IAo+INCSINCh0YDQtCwgMDkvMDIv
MjAxMSDQsiAxMToyMiArMDEwMCwgQ2hyaXN0b3BoZSBWYXJvcXVpINC/0LjRiNC10YI6Cj4gPiBP
biBtZXIuLCAyMDExLTAyLTA5IGF0IDEzOjA4ICswMzAwLCBQZXRlciBWb2xrb3Ygd3JvdGU6Cj4g
PiA+IHJvb3RAYnR2MTp+IyBjYXQgL2V0Yy9tdWx0aXBhdGguY29uZiAKPiA+ID4gZGVmYXVsdHMg
ewo+ID4gPiAJcGF0aF9jaGVja2VyCXJkYWMKPiA+ID4gfQo+ID4gPiAKPiA+IHRoZSAncGF0aF9j
aGVja2VyJyBwYXJhbSBkb2VzIG5vdCBzZXQgdGhlIGh3aGFuZGxlci4KPiA+IHRoZSBrZXl3b3Jk
IGZvciB0aGF0IGlzICdoYXJkd2FyZV9oYW5kbGVyJy4KPiAKPiBJcyB0aGlzIGFuIGVycm9yIGlu
IG1hbiBtdWx0aXBhdGguY29uZiB0aGVuIChpdCBtZW50aW9ucyByZGFjIGluCj4gcGF0aF9jaGVj
a2VyIHNlY3Rpb24pPwo+IApObywgcmRhYyBpcyBhbHNvIGEgdmFsaWQgdmFsaWQgdmFsdWUgZm9y
IHBhdGhfY2hlY2tlci4KCj4gQW55d2F5IEkndmUgdXBkYXRlZCBtdWx0aXBhdGgtdG9vbHMgb24g
dWJ1bnR1IGFuZCB0aGlzIGZpeGVkIGluaXRpYWwKPiBpc3N1ZSwgYnV0IG5vdyBJIGV4cGVyaWVu
Y2UgZGlmZmVyZW50IHByb2JsZW0gd2l0aCBtdWx0aXBhdGguIEZvcgo+IHVua25vd24gcmVhc29u
cyBtdWx0aXBhdGggZG9lcyBub3QgYXV0b21hZ2ljYWxseSBjcmVhdGUgcGFydGl0aW9ucyBvbgo+
IEdlbnRvbyBzeXN0ZW0sIGFsdGhvdWdoIGV2ZXJ5dGhpbmcgd29ya3MgaWYgSSBydW4gYGtwYXJ0
eCAtYSAvZGV2L2RtLTBgCj4gbWFudWFsbHkuIENvdWxkIHlvdSBoZWxwIG1lIHRvIGludmVzdGln
YXRlIHRoaXMgaXNzdWU/Cj4gCllvdSBtdXN0IGtlZXAgdGhlIGRpc3RyaWJ1dGlvbiB1ZGV2IHJ1
bGVzLiBBbmQgcmVwb3J0IGJ1Z3MgdG8gdGhlbS4gTm9yCm11bHRpcGF0aCBvciBtdWx0aXBhdGhk
IGNhcmUgYWJvdXQgcGFydGl0aW9ucy4gVGhvc2UgY3JlYXRlIG11bHRpcGF0aApkZXZpY2UgbWFw
cyBhbmQgdXBvbiBjcmVhdGlvbiB1ZGV2IGlzIHJlc3BvbnNpYmxlIGZvciBjYWxsaW5nIGtwYXJ0
eC4KCkNoZWNrIHRoZSBtdWx0aXBhdGgtdG9vbHMgJ21ha2UgaW5zdGFsbCcgb3V0cHV0IHRvIHNl
ZSB3aGF0IGl0IG1heQp1bmR1bHkgaW5zdGFsbCBhcyB1ZGV2IHJ1bGVzLgoKUmVnYXJkcywKY3Zh
cm9xdWkKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
