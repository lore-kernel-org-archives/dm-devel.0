From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch V2 01/29] tracing: Cleanup stack trace code
Date: Thu, 18 Apr 2019 20:39:54 -0400
Message-ID: <20190418203954.631914cb@oasis.local.home>
References: <20190418084119.056416939@linutronix.de>
 <20190418084253.142712304@linutronix.de>
 <20190418181938.2e2a9a04@gandalf.local.home>
 <alpine.DEB.2.21.1904190040510.3174@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <alpine.DEB.2.21.1904190040510.3174@nanos.tec.linutronix.de>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, Johannes Thumshirn <jthumshirn@suse.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, David Rientjes <rientjes@google.com>, Akinobu Mita <akinobu.mita@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, David Sterba <dsterba@suse.com>, Dmitry Vyukov <dvyukov@g>
List-Id: dm-devel.ids

T24gRnJpLCAxOSBBcHIgMjAxOSAwMDo0NDoxNyArMDIwMCAoQ0VTVCkKVGhvbWFzIEdsZWl4bmVy
IDx0Z2x4QGxpbnV0cm9uaXguZGU+IHdyb3RlOgoKPiBPbiBUaHUsIDE4IEFwciAyMDE5LCBTdGV2
ZW4gUm9zdGVkdCB3cm90ZToKPiA+IE9uIFRodSwgMTggQXByIDIwMTkgMTA6NDE6MjAgKzAyMDAK
PiA+IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPiB3cm90ZToKPiA+ICAgCj4g
PiA+IEBAIC00MTIsMjMgKzQwNCwyMCBAQCBzdGFja190cmFjZV9zeXNjdGwoc3RydWN0IGN0bF90
YWJsZSAqdGFiCj4gPiA+ICAJCSAgIHZvaWQgX191c2VyICpidWZmZXIsIHNpemVfdCAqbGVucCwK
PiA+ID4gIAkJICAgbG9mZl90ICpwcG9zKQo+ID4gPiAgewo+ID4gPiAtCWludCByZXQ7Cj4gPiA+
ICsJaW50IHJldCwgd2FzX2VuYWJsZWQ7ICAKPiA+IAo+ID4gT25lIHNtYWxsIG5pdC4gQ291bGQg
dGhpcyBiZToKPiA+IAo+ID4gCWludCB3YXNfZW5hYmxlZDsKPiA+IAlpbnQgcmV0Owo+ID4gCj4g
PiBJIHByZWZlciBvbmx5IGpvaW5pbmcgdmFyaWFibGVzIHRoYXQgYXJlIHJlbGF0ZWQgb24gdGhl
IHNhbWUgbGluZS4KPiA+IE1ha2VzIGl0IGxvb2sgY2xlYW5lciBJTU8uICAKPiAKPiBJZiB5b3Ug
d2lzaCBzby4gVG8gbWUgaXQncyB3YXN0ZSBvZiBzY3JlZW4gc3BhY2UgOikKCkF0IGxlYXN0IHlv
dSBkaWRuJ3Qgc2F5IGl0IGhlbHBzIHRoZSBjb21waWxlciA7LSkKCj4gCj4gPiA+ICAKPiA+ID4g
IAltdXRleF9sb2NrKCZzdGFja19zeXNjdGxfbXV0ZXgpOwo+ID4gPiArCXdhc19lbmFibGVkID0g
ISFzdGFja190cmFjZXJfZW5hYmxlZDsKPiA+ID4gICAgCj4gPiAKPiA+IEJhaCwgbm90IHN1cmUg
d2h5IEkgZGlkbid0IGRvIGl0IHRoaXMgd2F5IHRvIGJlZ2luIHdpdGguIEkgdGhpbmsgSQo+ID4g
Y29waWVkIHNvbWV0aGluZyBlbHNlIHRoYXQgY291bGRuJ3QgZG8gaXQgdGhpcyB3YXkgZm9yIHNv
bWUgcmVhc29uIGFuZAo+ID4gZGlkbid0IHB1dCBhbnkgYnJhaW4gcG93ZXIgYmVoaW5kIHRoZSBj
b3B5LiA6LS8gQnV0IHRoYXQgd2FzIGJhY2sgaW4KPiA+IDIwMDggc28gSSBibGFtZSBpdCBvbiBi
ZWluZyAieW91bmcgYW5kIHN0dXBpZCIgOy0pICAKPiAKPiBUaGUgeW91bmcgcGFydCBpcyBnb25l
IGZvciBzdXJlIDopCgpJIHB1cnBvc2VseSBzZXQgeW91IHVwIGZvciB0aGF0IHJlc3BvbnNlLgoK
PiAKPiA+IE90aGVyIHRoZW4gdGhlIGFib3ZlIG5pdCBhbmQgcmVtb3ZpbmcgdGhlIHVubmVlZGVk
ICsxIGluIG1heF9lbnRyaWVzOiAgCj4gCj4gcy8rMS8tMS8KClRoYXQgd2FzIGFuIG9kZSB0byBH
KwoKLS0gU3RldmUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
Cmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4
