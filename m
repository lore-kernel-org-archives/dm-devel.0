From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V2 28/29] stacktrace: Provide common
 infrastructure
Date: Fri, 19 Apr 2019 09:18:43 +0200
Message-ID: <20190419071843.GM4038@hirez.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.652003111@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190418084255.652003111@linutronix.de>
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

T24gVGh1LCBBcHIgMTgsIDIwMTkgYXQgMTA6NDE6NDdBTSArMDIwMCwgVGhvbWFzIEdsZWl4bmVy
IHdyb3RlOgoKPiArdHlwZWRlZiBib29sICgqc3RhY2tfdHJhY2VfY29uc3VtZV9mbikodm9pZCAq
Y29va2llLCB1bnNpZ25lZCBsb25nIGFkZHIsCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgYm9vbCByZWxpYWJsZSk7Cgo+ICt2b2lkIGFyY2hfc3RhY2tfd2FsayhzdGFj
a190cmFjZV9jb25zdW1lX2ZuIGNvbnN1bWVfZW50cnksIHZvaWQgKmNvb2tpZSwKPiArCQkgICAg
IHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgc3RydWN0IHB0X3JlZ3MgKnJlZ3MpOwo+ICtpbnQg
YXJjaF9zdGFja193YWxrX3JlbGlhYmxlKHN0YWNrX3RyYWNlX2NvbnN1bWVfZm4gY29uc3VtZV9l
bnRyeSwgdm9pZCAqY29va2llLAo+ICsJCQkgICAgIHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzayk7
CgpUaGlzIGJ1Z3MgbWUgYSBsaXR0bGU7IGlkZWFsbHkgdGhlIF9yZWxpYWJsZSgpIHRoaW5nIHdv
dWxkIG5vdCBleGlzdHMuCgpUaG9tYXMgc2FpZCB0aGF0IHRoZSBleGlzdGluZyBfX3NhdmVfc3Rh
Y2tfdHJhY2VfcmVsaWFibGUoKSBpcyBkaWZmZXJlbnQKZW5vdWdoIGZvciB0aGUgdW5pZmljYXRp
b24gdG8gYmUgbm9uLXRyaXZpYWwsIGJ1dCBtYXliZSBKb3NoIGNhbiBoZWxwCm91dD8KCkZyb20g
d2hhdCBJIGNhbiBzZWUgdGhlIGJpZ2dlc3Qgc2lnbmlmaWNhbnQgZGlmZmVyZW5jZXMgYXJlOgoK
IC0gaXQgbG9va3MgYXQgdGhlIHJlZ3Mgc2V0cyBvbiB0aGUgc3RhY2sgYW5kIGZvciBGUCBiYWls
cyBlYXJseQogLSBiYWlscyBmb3Iga2hyZWFkcyBhbmQgaWRsZSAoYWZ0ZXIgaXQgZG9lcyBhbGwg
dGhlIGhhcmQgd29yayE/ISkKClRoZSBmaXJzdCAoRlAgY2hlY2tpbmcgZm9yIGV4Y2VwdGlvbnMp
IHNob3VsZCBwcm9iYWJseSBiZSByZWZsZWN0ZWQgaW4KY29uc3VtZV9mbigucmVsaWFibGUpIGFu
eXdheSAtLSBhbHRob3VnaCB0aGF0IHdvdWxkIG1lYW4gYSBsb3Qgb2YgZXh0cmEKJz8nIGVudHJp
ZXMgd2hlcmUgdGhlcmUgYXJlIG5vbmUgdG9kYXkuCgpBbmQgdGhlIHNlY29uZCAoS1RIUkVBRC9J
RExFKSBpcyBzb21ldGhpbmcgdGhhdCB0aGUgZ2VuZXJpYyBjb2RlIGNhbgplYXNpbHkgZG8gYmVm
b3JlIGNhbGxpbmcgaW50byB0aGUgYXJjaCB1bndpbmRlci4KCkhtbT8KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QK
SW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9w
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
