From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V2 28/29] stacktrace: Provide common
 infrastructure
Date: Fri, 19 Apr 2019 09:02:11 +0200
Message-ID: <20190419070211.GL4038@hirez.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
 <20190418145201.mjzyqbmkjcghqzex@treble>
 <alpine.DEB.2.21.1904181734200.3174@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904181734200.3174@nanos.tec.linutronix.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, Johannes Thumshirn <jthumshirn@suse.de>, Akinobu Mita <akinobu.mita@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Josef Bacik <josef@toxicpanda.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, David Sterba <dster>
List-Id: dm-devel.ids

T24gVGh1LCBBcHIgMTgsIDIwMTkgYXQgMDU6NDI6NTVQTSArMDIwMCwgVGhvbWFzIEdsZWl4bmVy
IHdyb3RlOgo+IE9uIFRodSwgMTggQXByIDIwMTksIEpvc2ggUG9pbWJvZXVmIHdyb3RlOgoKPiA+
IEFub3RoZXIgaWRlYSBJIGhhZCAoYnV0IG5ldmVyIGdvdCBhIGNoYW5jZSB0byB3b3JrIG9uKSB3
YXMgdG8gZXh0ZW5kIHRoZQo+ID4geDg2IHVud2luZCBpbnRlcmZhY2UgdG8gYWxsIGFyY2hlcy4g
IFNvIGluc3RlYWQgb2YgdGhlIGNhbGxiYWNrcywgZWFjaAo+ID4gYXJjaCB3b3VsZCBpbXBsZW1l
bnQgc29tZXRoaW5nIGxpa2UgdGhpcyBBUEk6Cgo+IEkgc3VyZWx5IHRob3VnaHQgYWJvdXQgdGhh
dCwgYnV0IGFmdGVyIHN0YXJpbmcgYXQgYWxsIGluY2FybmF0aW9ucyBvZgo+IGFyY2gvKi9zdGFj
a3RyYWNlLmMgSSBqdXN0IGdhdmUgdXAuCj4gCj4gQXNpZGUgb2YgdGhhdCBxdWl0ZSBzb21lIGFy
Y2hzIGFscmVhZHkgaGF2ZSBjYWxsYmFjayBiYXNlZCB1bndpbmRlcnMKPiBiZWNhdXNlIHRoZXkg
dXNlIHRoZW0gZm9yIG1vcmUgdGhhbiBzdGFja3RyYWNpbmcgYW5kIGp1c3QgaGF2ZSBhIHNpbmds
ZQo+IGltcGxlbWVudGF0aW9uIG9mIHRoYXQgbG9vcC4KPiAKPiBJJ20gZmluZSBlaXRoZXIgd2F5
LiBXZSBjYW4gc3RhcnQgd2l0aCB4ODYgYW5kIHRoZW4gbGV0IGFyY2hzIGNvbnZlcnQgb3Zlcgo+
IHRoZWlyIHN0dWZmLCBidXQgSSB3b3VsZG4ndCBob2xkIG15IGJyZWF0aCB0aGF0IHRoaXMgd2ls
bCBiZSBjb21wbGV0ZWQgaW4KPiB0aGUgZm9yc2VlYWJsZSBmdXR1cmUuCgpJIHN1Z2dlc3RlZCB0
aGUgc2FtZSB0byBUaG9tYXMgZWFybHkgb24sIGFuZCBJIGV2ZW4gc3BlbmQgdGhlIHRpbWUgdG8K
Y29udmVydCBzb21lICRyYW5kb20gYXJjaCB0byB0aGUgaXRlcmF0b3IgaW50ZXJmYWNlLCBhbmQg
d2hpbGUgaXQgaXMKaW5kZWVkIGVudGlyZWx5IGZlYXNpYmxlLCBpdCBpcyBfZmFyXyBtb3JlIHdv
cmsuCgpUaGUgY2FsbGJhY2sgdGhpbmcgT1RPSCBpcyBmbGV4aWJsZSBlbm91Z2ggdG8gZG8gd2hh
dCB3ZSB3YW50IHRvIGRvIG5vdywKYW5kIGFsbG93cyBjb252ZXJ0aW5nIG1vc3QgYXJjaHMgdG8g
aXQgd2l0aG91dCB0b28gbXVjaCBwYWluIChhcyBUaG9tYXMKc2FpZCwgbWFueSBhcmNocyBhcmUg
YWxyZWFkeSBpbiB0aGlzIGZvcm0gYW5kIG9ubHkgbmVlZCBtaW5vciBBUEkKYWRqdXN0bWVudHMp
LCB3aGljaCBnZXRzIHVzIGluIGEgZmFyIGJldHRlciBwbGFjZSB0aGFuIHdlIGFyZSBub3cuCgpB
bmQgd2UgY2FuIGFsd2F5cyBnbyB0byBpdGVyYXRvcnMgbGF0ZXIgb24uIEJ1dCBJIHRoaW5rIGdl
dHRpbmcgdGhlCmdlbmVyaWMgdW53aW5kZXIgaW1wcm92ZWQgYWNyb3NzIGFsbCBhcmNocyBpcyBh
IHJlYWxseSBpbXBvcnRhbnQgZmlyc3QKc3RlcCBoZXJlLgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdm
eEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFp
bG1hbi9saXN0aW5mby9pbnRlbC1nZng=
