From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch V2 18/29] lockdep: Move stack trace logic into
 check_prev_add()
Date: Wed, 24 Apr 2019 21:45:05 +0200
Message-ID: <20190424194505.GR11158@hirez.programming.kicks-ass.net>
References: <20190418084119.056416939@linutronix.de>
 <20190418084254.729689921@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20190418084254.729689921@linutronix.de>
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

T24gVGh1LCBBcHIgMTgsIDIwMTkgYXQgMTA6NDE6MzdBTSArMDIwMCwgVGhvbWFzIEdsZWl4bmVy
IHdyb3RlOgo+IFRoZXJlIGlzIG9ubHkgb25lIGNhbGxlciBvZiBjaGVja19wcmV2X2FkZCgpIHdo
aWNoIGhhbmRzIGluIGEgemVyb2VkIHN0cnVjdAo+IHN0YWNrIHRyYWNlIGFuZCBhIGZ1bmN0aW9u
IHBvaW50ZXIgdG8gc2F2ZV9zdGFjaygpLiBJbnNpZGUgY2hlY2tfcHJldl9hZGQoKQo+IHRoZSBz
dGFja190cmFjZSBzdHJ1Y3QgaXMgY2hlY2tlZCBmb3IgYmVpbmcgZW1wdHksIHdoaWNoIGlzIGFs
d2F5cwo+IHRydWUuIEJhc2VkIG9uIHRoYXQgb25lIGNvZGUgcGF0aCBzdG9yZXMgYSBzdGFjayB0
cmFjZSB3aGljaCBpcyB1bnVzZWQuIFRoZQo+IGNvbW1lbnQgdGhlcmUgZG9lcyBub3QgbWFrZSBz
ZW5zZSBlaXRoZXIuIEl0J3MgYWxsIGxlZnRvdmVycyBmcm9tCj4gaGlzdG9yaWNhbCBsb2NrZGVw
IGNvZGUgKGNyb3NzIHJlbGVhc2UpLgoKSSB3YXMgbW9yZSBvciBsZXNzIGV4cGVjdGluZyBhIHJl
dmVydCBvZjoKCmNlMDdhOTQxNWYyNiAoImxvY2tpbmcvbG9ja2RlcDogTWFrZSBjaGVja19wcmV2
X2FkZCgpIGFibGUgdG8gaGFuZGxlIGV4dGVybmFsIHN0YWNrX3RyYWNlIikKCkFuZCB0aGVuIEkg
cmVhZCB0aGUgY29tbWVudCB0aGF0IHdlbnQgd2l0aCB0aGUgInN0YXRpYyBzdHJ1Y3QKc3RhY2tf
dHJhY2UgdHJhY2UiIHRoYXQgZ290IHJlbW92ZWQgKGluIHRoZSBhYm92ZSBjb21taXQpIGFuZCBy
ZWFsaXplZAp0aGF0IHlvdXIgcGF0Y2ggd2lsbCBjb25zdW1lIG1vcmUgc3RhY2sgZW50cmllcy4K
ClRoZSBwcm9ibGVtIGlzIHdoZW4gdGhlIGhlbGQgbG9jayBzdGFjayBpbiBjaGVja19wcmV2c19h
ZGQoKSBoYXMgbXVsdHBsZQp0cnlsb2NrIGVudHJpZXMgb24gdG9wLCBpbiB0aGF0IGNhc2Ugd2Ug
Y2FsbCBjaGVja19wcmV2X2FkZCgpIG11bHRpcGxlCnRpbWVzLCBhbmQgdGhpcyBwYXRjaCB3aWxs
IHRoZW4gc2F2ZSB0aGUgZXhhY3Qgc2FtZSBzdGFjay10cmFjZSBtdWx0aXBsZQp0aW1lcywgY29u
c3VtaW5nIHN0YXRpYyByZXNvdXJjZXMuCgpQb3NzaWJseSB3ZSBzaG91bGQgY29weSB3aGF0IHN0
YWNrZGVwb3QgZG9lcyAoYnV0IHdlIGNhbm5vdCB1c2UgaXQKZGlyZWN0bHkgYmVjYXVzZSBzdGFj
a2RlcG90IHVzZXMgbG9ja3M7IGJ1dCBwb3NzaWJsZSB3ZSBjYW4gc2hhcmUgYml0cyksCmJ1dCB0
aGF0IGlzIGEgcGF0Y2ggZm9yIGFub3RoZXIgZGF5IEkgdGhpbmsuCgpTbyB3aGlsZSBjb252b2x1
dGVkLCBwZXJoYXBzIHdlIHNob3VsZCByZXRhaW4gdGhpcyBjb2RlIGZvciBub3cuCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRyaS1kZXZlbCBtYWlsaW5n
IGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVk
ZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbA==
