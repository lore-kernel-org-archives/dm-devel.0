From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch V2 14/29] dm bufio: Simplify stack trace
 retrieval
Date: Thu, 18 Apr 2019 13:54:37 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904181353420.3174@nanos.tec.linutronix.de>
References: <20190418084119.056416939@linutronix.de>
 <20190418084254.361284697@linutronix.de>
 <CAG_fn=WP9+bVv9hedoaTzWK+xBzedxaGJGVOPnF0o115s-oWvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <CAG_fn=WP9+bVv9hedoaTzWK+xBzedxaGJGVOPnF0o115s-oWvg@mail.gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Alexander Potapenko <glider@google.com>
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, Linux Memory Management List <linux-mm@kvack.org>, dm-devel@redhat.com, Christoph Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev <kasan-dev@googlegroups.com>, David Rientjes <rientjes@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, Johannes Thumshirn <jthumshirn@suse.de>, Akinobu Mita <akinobu.mita@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Josef Bacik <josef@toxicpanda.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, David Sterba <dste>
List-Id: dm-devel.ids

T24gVGh1LCAxOCBBcHIgMjAxOSwgQWxleGFuZGVyIFBvdGFwZW5rbyB3cm90ZToKPiBPbiBUaHUs
IEFwciAxOCwgMjAxOSBhdCAxMTowNiBBTSBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25p
eC5kZT4gd3JvdGU6Cj4gPiAtICAgICAgIHNhdmVfc3RhY2tfdHJhY2UoJmItPnN0YWNrX3RyYWNl
KTsKPiA+ICsgICAgICAgYi0+c3RhY2tfbGVuID0gc3RhY2tfdHJhY2Vfc2F2ZShiLT5zdGFja19l
bnRyaWVzLCBNQVhfU1RBQ0ssIDIpOwo+IEFzIG5vdGVkIGluIG9uZSBvZiBzaW1pbGFyIHBhdGNo
ZXMgYmVmb3JlLCBjYW4gd2UgaGF2ZSBhbiBpbmxpbmUKPiBjb21tZW50IHRvIGluZGljYXRlIHdo
YXQgZG9lcyB0aGlzICIyIiBzdGFuZCBmb3I/CgpDb21lIG9uLiBXZSBoYXZlIGdhemlsbGlvbiBv
ZiBmdW5jdGlvbnMgd2hpY2ggdGFrZSBudW1lcmljYWwgY29uc3RhbnQKYXJndW1lbnRzLiBTaG91
bGQgd2UgYWRkIGNvbW1lbnRzIHRvIGFsbCBvZiB0aGVtPwoKVGhhbmtzLAoKCXRnbHgKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxp
bmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4
