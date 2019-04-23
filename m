From: Miroslav Benes <mbenes@suse.cz>
Subject: Re: [patch V2 25/29] livepatch: Simplify stack trace
 retrieval
Date: Tue, 23 Apr 2019 10:18:39 +0200 (CEST)
Message-ID: <alpine.LSU.2.21.1904231014200.19172@pobox.suse.cz>
References: <20190418084119.056416939@linutronix.de>
 <20190418084255.364915116@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20190418084255.364915116@linutronix.de>
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

T24gVGh1LCAxOCBBcHIgMjAxOSwgVGhvbWFzIEdsZWl4bmVyIHdyb3RlOgoKPiBSZXBsYWNlIHRo
ZSBpbmRpcmVjdGlvbiB0aHJvdWdoIHN0cnVjdCBzdGFja190cmFjZSBieSB1c2luZyB0aGUgc3Rv
cmFnZQo+IGFycmF5IGJhc2VkIGludGVyZmFjZXMuCj4gCj4gU2lnbmVkLW9mZi1ieTogVGhvbWFz
IEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+CgpBY2tlZC1ieTogTWlyb3NsYXYgQmVuZXMg
PG1iZW5lc0BzdXNlLmN6PgoKRmVlbCBmcmVlIHRvIHRha2UgaXQgdGhyb3VnaCB0aXAgb3IgbGV0
IHVzIGtub3cgdG8gcGljayBpdCB1cC4KCk1pcm9zbGF2Cl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4
QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
