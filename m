From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch V2 01/29] tracing: Cleanup stack trace code
Date: Thu, 18 Apr 2019 17:24:43 -0400
Message-ID: <20190418172443.30ec83e3@gandalf.local.home>
References: <20190418084119.056416939@linutronix.de>
 <20190418084253.142712304@linutronix.de>
 <20190418135721.5vwd6ngxagrrrrtt@treble>
 <alpine.DEB.2.21.1904182313470.3174@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <alpine.DEB.2.21.1904182313470.3174@nanos.tec.linutronix.de>
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

T24gVGh1LCAxOCBBcHIgMjAxOSAyMzoxNDo0NSArMDIwMCAoQ0VTVCkKVGhvbWFzIEdsZWl4bmVy
IDx0Z2x4QGxpbnV0cm9uaXguZGU+IHdyb3RlOgoKPiBPbiBUaHUsIDE4IEFwciAyMDE5LCBKb3No
IFBvaW1ib2V1ZiB3cm90ZToKPiAKPiA+IE9uIFRodSwgQXByIDE4LCAyMDE5IGF0IDEwOjQxOjIw
QU0gKzAyMDAsIFRob21hcyBHbGVpeG5lciB3cm90ZTogIAo+ID4gPiAtIFJlbW92ZSB0aGUgZXh0
cmEgYXJyYXkgbWVtYmVyIG9mIHN0YWNrX2R1bXBfdHJhY2VbXS4gSXQncyBub3QgcmVxdWlyZWQg
YXMKPiA+ID4gICB0aGUgc3RhY2sgdHJhY2VyIHN0b3JlcyBhdCBtYXggYXJyYXkgc2l6ZSAtIDEg
ZW50cmllcyBzbyB0aGVyZSBpcyBzdGlsbAo+ID4gPiAgIGFuIGVtcHR5IHNsb3QuICAKPiA+IAo+
ID4gV2hhdCBpcyB0aGUgZW1wdHkgc2xvdCB1c2VkIGZvcj8gIAo+IAo+IEkgd2FzIHRyeWluZyB0
byBmaW5kIGFuIGFuc3dlciBidXQgZmFpbGVkLiBNYXliZSBpdCdzIGp1c3QgaGlzdG9yaWNhbAo+
IGxlZnRvdmVycyBvciBTdGV2ZW4ga25vd3Mgd2hlcmUgdGhlIG1hZ2ljIGlzIGluIHRoaXMgbWF6
ZS4KPgoKSSBiZWxpZXZlIGl0IHdhcyBmb3IgaGlzdG9yaWNhbCBsZWZ0b3ZlcnMgKHRoZXJlIHdh
cyBhIHRpbWUgaXQgd2FzCnJlcXVpcmVkKSwgYW5kIGxlZnQgdGhlcmUgZm9yICJwYXJhbm9pZCIg
c2FrZS4gQnV0IGxldCBtZSBhcHBseSB0aGUKcGF0Y2ggYW5kIHNlZSBpZiBpdCBpcyByZWFsbHkg
bmVlZGVkLgoKLS0gU3RldmUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0
b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50
ZWwtZ2Z4
