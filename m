From: Martin Wilck <mwilck@suse.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 09:02:08 +0100
Message-ID: <1480406528.7926.7.camel@suse.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<1479979270.13566.7.camel@suse.com>
	<20161128184624.GF1972@octiron.msp.redhat.com>
	<fba771cb-222d-88a9-5e9f-35e57206aecd@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fba771cb-222d-88a9-5e9f-35e57206aecd@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

T24gVHVlLCAyMDE2LTExLTI5IGF0IDA3OjQ3ICswMTAwLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6
Cj4gT24gMTEvMjgvMjAxNiAwNzo0NiBQTSwgQmVuamFtaW4gTWFyemluc2tpIHdyb3RlOgo+ID4g
T24gVGh1LCBOb3YgMjQsIDIwMTYgYXQgMTA6MjE6MTBBTSArMDEwMCwgTWFydGluIFdpbGNrIHdy
b3RlOgo+ID4gPiBPbiBGcmksIDIwMTYtMTEtMTggYXQgMTY6MjYgLTA2MDAsIEJlbmphbWluIE1h
cnppbnNraSB3cm90ZToKPiA+ID4gCj4gPiA+ID4gQXQgYW55IHJhdGUsIEknZCByYXRoZXIgZ2V0
IHJpZCBvZiB0aGUgZ2F6aWxsaW9uIHdhaXRlciB0aHJlYWRzCj4gPiA+ID4gZmlyc3QuCj4gPiA+
IAo+ID4gPiBIbSwgSSB0aG91Z2h0IHRoZSB0aHJlYWRzIGFyZSBnb29kIGJlY2F1c2UgdGhpcyBh
dm9pZHMgb25lCj4gPiA+IHVucmVzcG9uc2l2ZQo+ID4gPiBkZXZpY2UgdG8gc3RhbGwgZXZlcnl0
aGluZz8KPiA+IAo+ID4gVGhlcmUgaXMgd29yayBtYWtpbmcgZG0gZXZlbnRzIHBvbGxhYmxlLCBz
byB0aGF0IHlvdSBjYW4gd2FpdCBmb3IKPiA+IGFueQo+ID4gbnVtYmVyIG9mIHRoZW0gd2l0aCBv
bmUgdGhyZWFkLiBBdCB0aGUgbW9tZW50LCBvbmNlIHdlIGdldCBhbgo+ID4gZXZlbnQsIHdlCj4g
PiBsb2NrIHRoZSB2ZWNzIGxvY2ssIHdoaWNoIHByZXR0eSBtdWNoIGtlZXBzIGV2ZXJ5dGhpbmcg
ZWxzZSBmcm9tCj4gPiBydW5uaW5nLCBzbyB0aGlzIGRvZXNuJ3QgcmVhbGx5IGNoYW5nZSB0aGF0
Lgo+ID4gCj4gCj4gV2hpY2ggYWdhaW4gbGVhZHMgbWUgdG8gdGhlIHF1ZXN0aW9uOgo+IFdoeSBh
cmUgd2Ugd2FpdGluZyBmb3IgZG0gZXZlbnRzPwo+IFRoZSBjb2RlIGhhbmRsaW5nIHRoZW0gaXMg
cHJldHR5IGFyY2FuZSwgYW5kIGZyb20gd2hhdCBJJ3ZlIHNlZW4KPiB0aGVyZQo+IGlzIG5vdGhp
bmcgaW4gdGhlcmUgd2hpY2ggd2Ugd291bGRuJ3QgYmUgaW5mb3JtZWQgdmlhIG90aGVyCj4gbWVj
aGFuaXNtcwo+IChwYXRoIGNoZWNrZXIsIHVldmVudHMpLgo+IFNvIHdoeSBkbyB3ZSBzdGlsbCBi
b3RoZXIgd2l0aCB0aGVtPwoKSSB3YXMgYXNraW5nIG15c2VsZiB0aGUgc2FtZSBxdWVzdGlvbi4g
RnJvbSBteSBpbnNwZWN0aW9uIG9mIHRoZSBrZXJuZWwKY29kZSwgdGhlcmUgYXJlIHR3byBjb2Rl
IHBhdGhzIHRoYXQgdHJpZ2dlciBhIGRtIGV2ZW50IGJ1dCBubyB1ZXZlbnQKKGJ5cGFzc19wZygp
IGFuZCBzd2l0Y2hfcGdfbnVtKCksIGJvdGggcmVsYXRlZCB0byBwYXRoIGdyb3VwCnN3aXRjaGlu
ZykuIElmIHRoZXNlIGFyZSBjb3ZlcmVkIGJ5IHRoZSBwYXRoIGNoZWNrZXIsIEkgc2VlIG5vIHBv
aW50IGluCndhaXRpbmcgZm9yIERNIGV2ZW50cy4gQnV0IG9mIGNvdXJzZSwgSSBtYXkgYmUgbWlz
c2luZyBzb21ldGhpbmcuCgpSZWdhcmRzLApNYXJ0aW4KCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8
bXdpbGNrQHN1c2UuY29tPiwgVGVsLsKgKzQ5ICgwKTkxMSA3NDA1MyAyMTA3ClNVU0UgTGludXgg
R21iSCwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRv
bgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbA==
