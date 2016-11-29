From: Martin Wilck <mwilck@suse.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 08:57:18 +0100
Message-ID: <1480406238.7926.5.camel@suse.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<1479979270.13566.7.camel@suse.com>
	<20161128184624.GF1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161128184624.GF1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

T24gTW9uLCAyMDE2LTExLTI4IGF0IDEyOjQ2IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gT24gVGh1LCBOb3YgMjQsIDIwMTYgYXQgMTA6MjE6MTBBTSArMDEwMCwgTWFydGluIFdp
bGNrIHdyb3RlOgo+ID4gCj4gPiBmcm9tIHRoZSB1ZGV2IGRiLiBUaGVyZWZvcmUgSU1PIHdlIGp1
c3QgaGF2ZSB0byBsb29rIGF0IHRoZSBsYXN0Cj4gPiByZWNlaXZlZCBldmVudCBmb3IgYSBnaXZl
biBwYXRoOgo+ID4gCj4gPiDCoC0gREVMRVRFID0+IGRpc2NhcmQgdGhlIGRldmljZQo+ID4gwqAt
IEFERCA9PiB1c2UgdGhlIHVkZXYgcHJvcGVydGllcyBjb21pbmcgd2l0aCB0aGUgZXZlbnQKPiA+
IMKgLSBDSEFOR0UgPT4gcXVlcnkgdWRldiBkYiBmb3IgY3VycmVudCBzZXQgb2YgcHJvcGVydGll
cwo+IAo+IFRoZSBpc3N1ZSBpcyB0aGF0IHdoZW4gd2UgZ2V0IGEgY2hhbmdlIGV2ZW50LCB0aGVy
ZSBtYXkgYmUgdWRldgo+IGVudmlyb25tZW50IHZhcmlhYmxlcyB0aGF0IHRlbGwgdXMgd2hhdCB0
aGF0IHNwZWNpZmljIGV2ZW50IGlzIGZvci4KPiBGb3IKPiBpbnN0YW5jZSwgYSBjaGFuZ2UgaW4g
dGhlIFJlYWQtb25seSBzdGF0dXMgb2YgdGhlIHBhdGggZGV2aWNlLiBGdXR1cmUKPiBjaGFuZ2Ug
ZXZlbnRzIHdpbGwgbm90IGhhdmUgdGhvc2UgZW52aXJvbm1lbnQgdmFyaWFibGVzIHNldC4KCkFu
ZCB0aGUgdWRldiBkYiB3aWxsIG5vdCBoYXZlIHJlY29yZHMgb2YgdGhlIGVudmlyb25tZW50IHZh
cmlhYmxlcyBvZgpwcmV2aW91cyBjaGFuZ2UgZXZlbnRzPyBJT1csIGluIHlvdXIgZXhhbXBsZSwg
d2UgY2FuJ3QgZGVyaXZlIHRoZSByZWFkLQpvbmx5IHN0YXR1cyBvZiBhIGRldmljZSBieSBsb29r
aW5nIGF0IHRoZSBjdXJyZW50IHNldCBvZiB1ZGV2CnByb3BlcnRpZXMgb2YgdGhlIGRldmljZSwg
b25seSBieSB0cmFja2luZyB0aGUgZnVsbCB1ZXZlbnQgaGlzdG9yeT8KClJlZ2FyZHMKTWFydGlu
CgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLsKgKzQ5ICgwKTkx
MSA3NDA1MyAyMTA3ClNVU0UgTGludXggR21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFu
ZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
