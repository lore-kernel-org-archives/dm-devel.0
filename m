From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 04/29] backtrace-test: Simplify stack trace
 handling
Date: Thu, 25 Apr 2019 11:44:57 +0200
Message-ID: <20190425094801.501919093@linutronix.de>
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

UmVwbGFjZSB0aGUgaW5kaXJlY3Rpb24gdGhyb3VnaCBzdHJ1Y3Qgc3RhY2tfdHJhY2UgYnkgdXNp
bmcgdGhlIHN0b3JhZ2UKYXJyYXkgYmFzZWQgaW50ZXJmYWNlcy4KClNpZ25lZC1vZmYtYnk6IFRo
b21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgotLS0KIGtlcm5lbC9iYWNrdHJhY2V0
ZXN0LmMgfCAgIDExICsrKy0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCA4IGRlbGV0aW9ucygtKQoKLS0tIGEva2VybmVsL2JhY2t0cmFjZXRlc3QuYworKysgYi9rZXJu
ZWwvYmFja3RyYWNldGVzdC5jCkBAIC00OCwxOSArNDgsMTQgQEAgc3RhdGljIHZvaWQgYmFja3Ry
YWNlX3Rlc3RfaXJxKHZvaWQpCiAjaWZkZWYgQ09ORklHX1NUQUNLVFJBQ0UKIHN0YXRpYyB2b2lk
IGJhY2t0cmFjZV90ZXN0X3NhdmVkKHZvaWQpCiB7Ci0Jc3RydWN0IHN0YWNrX3RyYWNlIHRyYWNl
OwogCXVuc2lnbmVkIGxvbmcgZW50cmllc1s4XTsKKwl1bnNpZ25lZCBpbnQgbnJfZW50cmllczsK
IAogCXByX2luZm8oIlRlc3RpbmcgYSBzYXZlZCBiYWNrdHJhY2UuXG4iKTsKIAlwcl9pbmZvKCJU
aGUgZm9sbG93aW5nIHRyYWNlIGlzIGEga2VybmVsIHNlbGYgdGVzdCBhbmQgbm90IGEgYnVnIVxu
Iik7CiAKLQl0cmFjZS5ucl9lbnRyaWVzID0gMDsKLQl0cmFjZS5tYXhfZW50cmllcyA9IEFSUkFZ
X1NJWkUoZW50cmllcyk7Ci0JdHJhY2UuZW50cmllcyA9IGVudHJpZXM7Ci0JdHJhY2Uuc2tpcCA9
IDA7Ci0KLQlzYXZlX3N0YWNrX3RyYWNlKCZ0cmFjZSk7Ci0JcHJpbnRfc3RhY2tfdHJhY2UoJnRy
YWNlLCAwKTsKKwlucl9lbnRyaWVzID0gc3RhY2tfdHJhY2Vfc2F2ZShlbnRyaWVzLCBBUlJBWV9T
SVpFKGVudHJpZXMpLCAwKTsKKwlzdGFja190cmFjZV9wcmludChlbnRyaWVzLCBucl9lbnRyaWVz
LCAwKTsKIH0KICNlbHNlCiBzdGF0aWMgdm9pZCBiYWNrdHJhY2VfdGVzdF9zYXZlZCh2b2lkKQoK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdm
eCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xp
c3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
