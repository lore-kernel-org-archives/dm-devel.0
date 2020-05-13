From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] device-mapper: use dynamic debug instead of
 compile-time config option
Date: Wed, 13 May 2020 13:10:51 +0200
Message-ID: <5357d0d6-12cb-9585-36ae-9aec206eebb4@suse.de>
References: <20200513070843.71528-1-hare@suse.de>
	<BY5PR04MB6900AD28F5B6B6C3A8AEAA5EE7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BY5PR04MB6900AD28F5B6B6C3A8AEAA5EE7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gNS8xMy8yMCAxMTo0MSBBTSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gT24gMjAyMC8wNS8x
MyAxNjoxMCwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+PiBTd2l0Y2ggdG8gdXNlIGR5bmFtaWMg
ZGVidWcgdG8gYXZvaWQgaGF2aW5nIHJlY29tcGlsZSB0aGUga2VybmVsCj4+IGp1c3QgdG8gZW5h
YmxlIGRlYnVnZ2luZyBtZXNzYWdlcy4KPj4KPj4gU2lnbmVkLW9mZi1ieTogSGFubmVzIFJlaW5l
Y2tlIDxoYXJlQHN1c2UuZGU+Cj4+IC0tLQo+PiAgIGluY2x1ZGUvbGludXgvZGV2aWNlLW1hcHBl
ci5oIHwgNyArLS0tLS0tCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA2IGRl
bGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVy
LmggYi9pbmNsdWRlL2xpbnV4L2RldmljZS1tYXBwZXIuaAo+PiBpbmRleCBlMmQ1MDZkZDgwNWUu
LjNkNDM2NWZkMzAwMSAxMDA2NDQKPj4gLS0tIGEvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVy
LmgKPj4gKysrIGIvaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmgKPj4gQEAgLTU1NiwxMyAr
NTU2LDggQEAgdm9pZCAqZG1fdmNhbGxvYyh1bnNpZ25lZCBsb25nIG5tZW1iLCB1bnNpZ25lZCBs
b25nIGVsZW1fc2l6ZSk7Cj4+ICAgI2RlZmluZSBETUlORk8oZm10LCAuLi4pIHByX2luZm8oRE1f
Rk1UKGZtdCksICMjX19WQV9BUkdTX18pCj4+ICAgI2RlZmluZSBETUlORk9fTElNSVQoZm10LCAu
Li4pIHByX2luZm9fcmF0ZWxpbWl0ZWQoRE1fRk1UKGZtdCksICMjX19WQV9BUkdTX18pCj4+ICAg
Cj4+IC0jaWZkZWYgQ09ORklHX0RNX0RFQlVHCj4gCj4gQ2FuIHdlIHJlbW92ZSB0aGlzIGZyb20g
S2NvbmZpZyBhcyBhIGNvbmZpZyBvcHRpb24gPwo+IApObywgd2UgY2FuJ3QsIGl0J3MgYmVpbmcg
dXNlZCBieSBkbS1zbmFwIGFuZCBkbS1pbnRlZ3JpdHkuCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRy
LiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2lu
ZwpoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1
MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkg
TsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEZl
bGl4IEltZW5kw7ZyZmZlcgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRo
YXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
