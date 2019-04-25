From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 05/29] proc: Simplify task stack retrieval
Date: Thu, 25 Apr 2019 11:44:58 +0200
Message-ID: <20190425094801.589304463@linutronix.de>
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
eTogQWxleGV5IERvYnJpeWFuIDxhZG9icml5YW5AZ21haWwuY29tPgpDYzogQW5kcmV3IE1vcnRv
biA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCiBmcy9wcm9jL2Jhc2UuYyB8ICAgMTQg
KysrKystLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDkgZGVsZXRp
b25zKC0pCgotLS0gYS9mcy9wcm9jL2Jhc2UuYworKysgYi9mcy9wcm9jL2Jhc2UuYwpAQCAtNDA3
LDcgKzQwNyw2IEBAIHN0YXRpYyB2b2lkIHVubG9ja190cmFjZShzdHJ1Y3QgdGFza19zdHIKIHN0
YXRpYyBpbnQgcHJvY19waWRfc3RhY2soc3RydWN0IHNlcV9maWxlICptLCBzdHJ1Y3QgcGlkX25h
bWVzcGFjZSAqbnMsCiAJCQkgIHN0cnVjdCBwaWQgKnBpZCwgc3RydWN0IHRhc2tfc3RydWN0ICp0
YXNrKQogewotCXN0cnVjdCBzdGFja190cmFjZSB0cmFjZTsKIAl1bnNpZ25lZCBsb25nICplbnRy
aWVzOwogCWludCBlcnI7CiAKQEAgLTQzMCwyMCArNDI5LDE3IEBAIHN0YXRpYyBpbnQgcHJvY19w
aWRfc3RhY2soc3RydWN0IHNlcV9maWwKIAlpZiAoIWVudHJpZXMpCiAJCXJldHVybiAtRU5PTUVN
OwogCi0JdHJhY2UubnJfZW50cmllcwk9IDA7Ci0JdHJhY2UubWF4X2VudHJpZXMJPSBNQVhfU1RB
Q0tfVFJBQ0VfREVQVEg7Ci0JdHJhY2UuZW50cmllcwkJPSBlbnRyaWVzOwotCXRyYWNlLnNraXAJ
CT0gMDsKLQogCWVyciA9IGxvY2tfdHJhY2UodGFzayk7CiAJaWYgKCFlcnIpIHsKLQkJdW5zaWdu
ZWQgaW50IGk7CisJCXVuc2lnbmVkIGludCBpLCBucl9lbnRyaWVzOwogCi0JCXNhdmVfc3RhY2tf
dHJhY2VfdHNrKHRhc2ssICZ0cmFjZSk7CisJCW5yX2VudHJpZXMgPSBzdGFja190cmFjZV9zYXZl
X3Rzayh0YXNrLCBlbnRyaWVzLAorCQkJCQkJICBNQVhfU1RBQ0tfVFJBQ0VfREVQVEgsIDApOwog
Ci0JCWZvciAoaSA9IDA7IGkgPCB0cmFjZS5ucl9lbnRyaWVzOyBpKyspIHsKKwkJZm9yIChpID0g
MDsgaSA8IG5yX2VudHJpZXM7IGkrKykgewogCQkJc2VxX3ByaW50ZihtLCAiWzwwPl0gJXBCXG4i
LCAodm9pZCAqKWVudHJpZXNbaV0pOwogCQl9CisKIAkJdW5sb2NrX3RyYWNlKHRhc2spOwogCX0K
IAlrZnJlZShlbnRyaWVzKTsKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVz
a3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9p
bnRlbC1nZng=
