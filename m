From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 12/29] dma/debug: Simplify stracktrace
 retrieval
Date: Thu, 25 Apr 2019 11:45:05 +0200
Message-ID: <20190425094802.248658135@linutronix.de>
References: <20190425094453.875139013@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, Johannes Thumshirn <jthumshirn@suse.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, David Rientjes <rientjes@google.com>, Akinobu Mita <akinobu.mita@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Josef Bacik <josef@toxicpanda.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe>
List-Id: dm-devel.ids

UmVwbGFjZSB0aGUgaW5kaXJlY3Rpb24gdGhyb3VnaCBzdHJ1Y3Qgc3RhY2tfdHJhY2Ugd2l0aCBh
biBpbnZvY2F0aW9uIG9mCnRoZSBzdG9yYWdlIGFycmF5IGJhc2VkIGludGVyZmFjZS4KClNpZ25l
ZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgpSZXZpZXdlZC1i
eTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+CkNjOiBpb21tdUBsaXN0cy5saW51eC1m
b3VuZGF0aW9uLm9yZwpDYzogUm9iaW4gTXVycGh5IDxyb2Jpbi5tdXJwaHlAYXJtLmNvbT4KQ2M6
IE1hcmVrIFN6eXByb3dza2kgPG0uc3p5cHJvd3NraUBzYW1zdW5nLmNvbT4KLS0tCiBrZXJuZWwv
ZG1hL2RlYnVnLmMgfCAgIDE0ICsrKysrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKLS0tIGEva2VybmVsL2RtYS9kZWJ1Zy5jCisrKyBi
L2tlcm5lbC9kbWEvZGVidWcuYwpAQCAtODksOCArODksOCBAQCBzdHJ1Y3QgZG1hX2RlYnVnX2Vu
dHJ5IHsKIAlpbnQJCSBzZ19tYXBwZWRfZW50czsKIAllbnVtIG1hcF9lcnJfdHlwZXMgIG1hcF9l
cnJfdHlwZTsKICNpZmRlZiBDT05GSUdfU1RBQ0tUUkFDRQotCXN0cnVjdAkJIHN0YWNrX3RyYWNl
IHN0YWNrdHJhY2U7Ci0JdW5zaWduZWQgbG9uZwkgc3RfZW50cmllc1tETUFfREVCVUdfU1RBQ0tU
UkFDRV9FTlRSSUVTXTsKKwl1bnNpZ25lZCBpbnQJc3RhY2tfbGVuOworCXVuc2lnbmVkIGxvbmcJ
c3RhY2tfZW50cmllc1tETUFfREVCVUdfU1RBQ0tUUkFDRV9FTlRSSUVTXTsKICNlbmRpZgogfTsK
IApAQCAtMTc0LDcgKzE3NCw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBkdW1wX2VudHJ5X3RyYWNl
KHN0cnUKICNpZmRlZiBDT05GSUdfU1RBQ0tUUkFDRQogCWlmIChlbnRyeSkgewogCQlwcl93YXJu
aW5nKCJNYXBwZWQgYXQ6XG4iKTsKLQkJcHJpbnRfc3RhY2tfdHJhY2UoJmVudHJ5LT5zdGFja3Ry
YWNlLCAwKTsKKwkJc3RhY2tfdHJhY2VfcHJpbnQoZW50cnktPnN0YWNrX2VudHJpZXMsIGVudHJ5
LT5zdGFja19sZW4sIDApOwogCX0KICNlbmRpZgogfQpAQCAtNzA0LDEyICs3MDQsMTAgQEAgc3Rh
dGljIHN0cnVjdCBkbWFfZGVidWdfZW50cnkgKmRtYV9lbnRyeQogCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJmZyZWVfZW50cmllc19sb2NrLCBmbGFncyk7CiAKICNpZmRlZiBDT05GSUdfU1RBQ0tU
UkFDRQotCWVudHJ5LT5zdGFja3RyYWNlLm1heF9lbnRyaWVzID0gRE1BX0RFQlVHX1NUQUNLVFJB
Q0VfRU5UUklFUzsKLQllbnRyeS0+c3RhY2t0cmFjZS5lbnRyaWVzID0gZW50cnktPnN0X2VudHJp
ZXM7Ci0JZW50cnktPnN0YWNrdHJhY2Uuc2tpcCA9IDE7Ci0Jc2F2ZV9zdGFja190cmFjZSgmZW50
cnktPnN0YWNrdHJhY2UpOworCWVudHJ5LT5zdGFja19sZW4gPSBzdGFja190cmFjZV9zYXZlKGVu
dHJ5LT5zdGFja19lbnRyaWVzLAorCQkJCQkgICAgQVJSQVlfU0laRShlbnRyeS0+c3RhY2tfZW50
cmllcyksCisJCQkJCSAgICAxKTsKICNlbmRpZgotCiAJcmV0dXJuIGVudHJ5OwogfQogCgoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1h
aWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMu
ZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4
