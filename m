From: Martin Wilck <mwilck@suse.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Fri, 18 Nov 2016 08:39:08 +0100
Message-ID: <1479454748.25031.4.camel@suse.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<OF3A4A70D0.4D2612E4-ON4825806F.00029856-4825806F.0005B3C7@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF3A4A70D0.4D2612E4-ON4825806F.00029856-4825806F.0005B3C7@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

SGkgVGFuZywKCk9uIEZyaSwgMjAxNi0xMS0xOCBhdCAwOTowMiArMDgwMCwgdGFuZy5qdW5odWlA
enRlLmNvbS5jbiB3cm90ZToKPiAKPiB3ZSBhcmUgbW9yZSBjb25jZXJuZWTCoAo+IMKgIMKgYWJv
dXQgdGhlIG1vcmUgY29tbW9uIHNpdHVhdGlvbiBsaWtlIGFkZGl0aW9uIG9yIGRlbGV0aW9uIGRl
dmljZXMKPiB3aGVuwqAKPiDCoCDCoGlTQ1NJIGxvZ2luL2xvZ291dCBvciBGQyBsaW5rIHVwL2Rv
d24gd2l0aCBtYW55IGlTQ1NJIG9yIEZDIGxpbmtzCj4gaW7CoAo+IMKgIMKgZWFjaCBMVU4uIEF0
IHRoaXMgc2l0dWF0aW9uIHdlIG1heSByZWNlaXZlIG1hbnkgdWV2ZW50cyBmcm9tCj4gZGlmZmVy
ZW50wqAKPiDCoCDCoHBhdGhzIG9mIHRoZSBzYW1lIExVTiBkZXZpY2UsIHdlIHdhbnQgbWVyZ2Ug
dGhlc2UgdWV2ZW50cyB0byBvbmUKPiBhbmTCoAo+IMKgIMKgcHJvY2VzcyB0aGVtIHRvZ2V0aGVy
LsKgCgpJJ20gbm90IGFyZ3VpbmcgYWdhaW5zdCB0aGF0LiBCdXQgY29uc2lkZXIgd2hhdCB5b3Un
ZCBkbyBpZiB5b3UgaGF2ZSB0bwpwcm9jZXNzIHRoZSBzZXJpZXMgb2YgdWV2ZW50cyBbIDEgImFk
ZCBzZGEiLCAyICJhZGQgc2RiIiwgMyAiZGVsIHNkYSIsCjQgImFkZCBzZGMiLCA1ICJkZWwgc2Ri
IiwgNiAiYWRkIHNkYSIgXS4gSWYgeW91IG1lcmdlIHRoZXNlLCBhc3N1bWluZwphbGwgYmVsb25n
IHRvIHRoZSBzYW1lIG11bHRpcGF0aCBtYXAsIHdoYXQgd291bGQgYmUgeW91ciBhY3Rpb24/IEkK
d291bGQgc2V0IHVwIGEgbWFwIHdpdGggc2RhIGFuZCBzZGMsIHVzaW5nIHRoZSBkZXZpY2UgcHJv
cGVydGllcyBmcm9tCmV2ZW50IDQgYW5kIDYuIFRoYXQgbWVhbnMgdGhhdCB0aGUgcmVzdCBvZiB0
aGUgZXZlbnRzIGhhcyBiZWVuCiJmaWx0ZXJlZCIgb3V0LiBBbGwgZWxzZSB3b3VsZCBtZWFuIHJl
cGVhdGVkIG1hcCBsb2FkcyBmb3IgdGhlIHNhbWUKbXVsdGlwYXRoIG1hcCwgd2hpY2ggaXMgd2hh
dCB3ZSB3YW50IHRvIGF2b2lkLiBBZ3JlZWQ/CgpSZWdhcmRzLApNYXJ0aW4KCi0tIApEci4gTWFy
dGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+LCBUZWwuwqArNDkgKDApOTExIDc0MDUzIDIxMDcK
U1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBH
cmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVs
