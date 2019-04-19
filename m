From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [patch V2 28/29] stacktrace: Provide common
 infrastructure
Date: Fri, 19 Apr 2019 10:50:44 -0500
Message-ID: <20190419155044.2uch7eaj4vzg47w6@treble>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
 <20190418145201.mjzyqbmkjcghqzex@treble>
 <alpine.DEB.2.21.1904181734200.3174@nanos.tec.linutronix.de>
 <20190419070211.GL4038@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190419070211.GL4038@hirez.programming.kicks-ass.net>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, Johannes Thumshirn <jthumshirn@suse.de>, Akinobu Mita <akinobu.mita@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Josef Bacik <josef@toxicpanda.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, David Sterba <dsterba@suse.com>, Thomas Gleixner <tglx@li>
List-Id: dm-devel.ids

T24gRnJpLCBBcHIgMTksIDIwMTkgYXQgMDk6MDI6MTFBTSArMDIwMCwgUGV0ZXIgWmlqbHN0cmEg
d3JvdGU6Cj4gT24gVGh1LCBBcHIgMTgsIDIwMTkgYXQgMDU6NDI6NTVQTSArMDIwMCwgVGhvbWFz
IEdsZWl4bmVyIHdyb3RlOgo+ID4gT24gVGh1LCAxOCBBcHIgMjAxOSwgSm9zaCBQb2ltYm9ldWYg
d3JvdGU6Cj4gCj4gPiA+IEFub3RoZXIgaWRlYSBJIGhhZCAoYnV0IG5ldmVyIGdvdCBhIGNoYW5j
ZSB0byB3b3JrIG9uKSB3YXMgdG8gZXh0ZW5kIHRoZQo+ID4gPiB4ODYgdW53aW5kIGludGVyZmFj
ZSB0byBhbGwgYXJjaGVzLiAgU28gaW5zdGVhZCBvZiB0aGUgY2FsbGJhY2tzLCBlYWNoCj4gPiA+
IGFyY2ggd291bGQgaW1wbGVtZW50IHNvbWV0aGluZyBsaWtlIHRoaXMgQVBJOgo+IAo+ID4gSSBz
dXJlbHkgdGhvdWdodCBhYm91dCB0aGF0LCBidXQgYWZ0ZXIgc3RhcmluZyBhdCBhbGwgaW5jYXJu
YXRpb25zIG9mCj4gPiBhcmNoLyovc3RhY2t0cmFjZS5jIEkganVzdCBnYXZlIHVwLgo+ID4gCj4g
PiBBc2lkZSBvZiB0aGF0IHF1aXRlIHNvbWUgYXJjaHMgYWxyZWFkeSBoYXZlIGNhbGxiYWNrIGJh
c2VkIHVud2luZGVycwo+ID4gYmVjYXVzZSB0aGV5IHVzZSB0aGVtIGZvciBtb3JlIHRoYW4gc3Rh
Y2t0cmFjaW5nIGFuZCBqdXN0IGhhdmUgYSBzaW5nbGUKPiA+IGltcGxlbWVudGF0aW9uIG9mIHRo
YXQgbG9vcC4KPiA+IAo+ID4gSSdtIGZpbmUgZWl0aGVyIHdheS4gV2UgY2FuIHN0YXJ0IHdpdGgg
eDg2IGFuZCB0aGVuIGxldCBhcmNocyBjb252ZXJ0IG92ZXIKPiA+IHRoZWlyIHN0dWZmLCBidXQg
SSB3b3VsZG4ndCBob2xkIG15IGJyZWF0aCB0aGF0IHRoaXMgd2lsbCBiZSBjb21wbGV0ZWQgaW4K
PiA+IHRoZSBmb3JzZWVhYmxlIGZ1dHVyZS4KPiAKPiBJIHN1Z2dlc3RlZCB0aGUgc2FtZSB0byBU
aG9tYXMgZWFybHkgb24sIGFuZCBJIGV2ZW4gc3BlbmQgdGhlIHRpbWUgdG8KPiBjb252ZXJ0IHNv
bWUgJHJhbmRvbSBhcmNoIHRvIHRoZSBpdGVyYXRvciBpbnRlcmZhY2UsIGFuZCB3aGlsZSBpdCBp
cwo+IGluZGVlZCBlbnRpcmVseSBmZWFzaWJsZSwgaXQgaXMgX2Zhcl8gbW9yZSB3b3JrLgo+IAo+
IFRoZSBjYWxsYmFjayB0aGluZyBPVE9IIGlzIGZsZXhpYmxlIGVub3VnaCB0byBkbyB3aGF0IHdl
IHdhbnQgdG8gZG8gbm93LAo+IGFuZCBhbGxvd3MgY29udmVydGluZyBtb3N0IGFyY2hzIHRvIGl0
IHdpdGhvdXQgdG9vIG11Y2ggcGFpbiAoYXMgVGhvbWFzCj4gc2FpZCwgbWFueSBhcmNocyBhcmUg
YWxyZWFkeSBpbiB0aGlzIGZvcm0gYW5kIG9ubHkgbmVlZCBtaW5vciBBUEkKPiBhZGp1c3RtZW50
cyksIHdoaWNoIGdldHMgdXMgaW4gYSBmYXIgYmV0dGVyIHBsYWNlIHRoYW4gd2UgYXJlIG5vdy4K
PiAKPiBBbmQgd2UgY2FuIGFsd2F5cyBnbyB0byBpdGVyYXRvcnMgbGF0ZXIgb24uIEJ1dCBJIHRo
aW5rIGdldHRpbmcgdGhlCj4gZ2VuZXJpYyB1bndpbmRlciBpbXByb3ZlZCBhY3Jvc3MgYWxsIGFy
Y2hzIGlzIGEgcmVhbGx5IGltcG9ydGFudCBmaXJzdAo+IHN0ZXAgaGVyZS4KCkZhaXIgZW5vdWdo
LgoKLS0gCkpvc2gKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3Jn
Cmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4
