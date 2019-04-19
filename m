From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V2 28/29] stacktrace: Provide common infrastructure
Date: Fri, 19 Apr 2019 11:07:17 +0200
Message-ID: <20190419090717.GN7905@worktop.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
 <20190419071843.GM4038@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.21.1904191031390.3174@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904191031390.3174@nanos.tec.linutronix.de>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, Johannes Thumshirn <jthumshirn@suse.de>, Akinobu Mita <akinobu.mita@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Josef Bacik <josef@toxicpanda.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jp>
List-Id: dm-devel.ids

T24gRnJpLCBBcHIgMTksIDIwMTkgYXQgMTA6MzI6MzBBTSArMDIwMCwgVGhvbWFzIEdsZWl4bmVy
IHdyb3RlOgo+IE9uIEZyaSwgMTkgQXByIDIwMTksIFBldGVyIFppamxzdHJhIHdyb3RlOgo+ID4g
T24gVGh1LCBBcHIgMTgsIDIwMTkgYXQgMTA6NDE6NDdBTSArMDIwMCwgVGhvbWFzIEdsZWl4bmVy
IHdyb3RlOgo+ID4gCj4gPiA+ICt0eXBlZGVmIGJvb2wgKCpzdGFja190cmFjZV9jb25zdW1lX2Zu
KSh2b2lkICpjb29raWUsIHVuc2lnbmVkIGxvbmcgYWRkciwKPiA+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgYm9vbCByZWxpYWJsZSk7Cj4gPiAKPiA+ID4gK3ZvaWQg
YXJjaF9zdGFja193YWxrKHN0YWNrX3RyYWNlX2NvbnN1bWVfZm4gY29uc3VtZV9lbnRyeSwgdm9p
ZCAqY29va2llLAo+ID4gPiArCQkgICAgIHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgc3RydWN0
IHB0X3JlZ3MgKnJlZ3MpOwo+ID4gPiAraW50IGFyY2hfc3RhY2tfd2Fsa19yZWxpYWJsZShzdGFj
a190cmFjZV9jb25zdW1lX2ZuIGNvbnN1bWVfZW50cnksIHZvaWQgKmNvb2tpZSwKPiA+ID4gKwkJ
CSAgICAgc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKTsKPiA+IAo+ID4gVGhpcyBidWdzIG1lIGEg
bGl0dGxlOyBpZGVhbGx5IHRoZSBfcmVsaWFibGUoKSB0aGluZyB3b3VsZCBub3QgZXhpc3RzLgo+
ID4gCj4gPiBUaG9tYXMgc2FpZCB0aGF0IHRoZSBleGlzdGluZyBfX3NhdmVfc3RhY2tfdHJhY2Vf
cmVsaWFibGUoKSBpcyBkaWZmZXJlbnQKPiA+IGVub3VnaCBmb3IgdGhlIHVuaWZpY2F0aW9uIHRv
IGJlIG5vbi10cml2aWFsLCBidXQgbWF5YmUgSm9zaCBjYW4gaGVscAo+ID4gb3V0Pwo+ID4gCj4g
PiA+RnJvbSB3aGF0IEkgY2FuIHNlZSB0aGUgYmlnZ2VzdCBzaWduaWZpY2FudCBkaWZmZXJlbmNl
cyBhcmU6Cj4gPiAKPiA+ICAtIGl0IGxvb2tzIGF0IHRoZSByZWdzIHNldHMgb24gdGhlIHN0YWNr
IGFuZCBmb3IgRlAgYmFpbHMgZWFybHkKPiA+ICAtIGJhaWxzIGZvciBraHJlYWRzIGFuZCBpZGxl
IChhZnRlciBpdCBkb2VzIGFsbCB0aGUgaGFyZCB3b3JrIT8hKQo+ID4gCj4gPiBUaGUgZmlyc3Qg
KEZQIGNoZWNraW5nIGZvciBleGNlcHRpb25zKSBzaG91bGQgcHJvYmFibHkgYmUgcmVmbGVjdGVk
IGluCj4gPiBjb25zdW1lX2ZuKC5yZWxpYWJsZSkgYW55d2F5IC0tIGFsdGhvdWdoIHRoYXQgd291
bGQgbWVhbiBhIGxvdCBvZiBleHRyYQo+ID4gJz8nIGVudHJpZXMgd2hlcmUgdGhlcmUgYXJlIG5v
bmUgdG9kYXkuCj4gPiAKPiA+IEFuZCB0aGUgc2Vjb25kIChLVEhSRUFEL0lETEUpIGlzIHNvbWV0
aGluZyB0aGF0IHRoZSBnZW5lcmljIGNvZGUgY2FuCj4gPiBlYXNpbHkgZG8gYmVmb3JlIGNhbGxp
bmcgaW50byB0aGUgYXJjaCB1bndpbmRlci4KPiAKPiBBbmQgbG9va2luZyBhdCB0aGUgcG93ZXJw
YyB2ZXJzaW9uIG9mIGl0LCB0aGF0IGhhcyBldmVuIG1vcmUgaW50ZXJlc3RpbmcKPiBleHRyYSBj
aGVja3MgaW4gdGhhdCBmdW5jdGlvbi4KClJpZ2h0LCBidXQgbm90IGZ1bmRhbWVudGFsbHkgZGlm
ZmVyZW50IGZyb20gZGV0ZXJtaW5pbmcgQHJlbGlhYmxlIEkKdGhpbmsuCgpBbnl3YXksIGl0IHdv
dWxkIGJlIGdvb2QgaWYgc29tZW9uZSBrbm93bGVkZ2FibGUgY291bGQgaGF2ZSBhIGxvb2sgYXQK
dGhpcy4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJp
LWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBz
Oi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVs
