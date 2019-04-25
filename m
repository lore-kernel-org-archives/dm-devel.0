From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 11/29] fault-inject: Simplify stacktrace
 retrieval
Date: Thu, 25 Apr 2019 11:45:04 +0200
Message-ID: <20190425094802.158306076@linutronix.de>
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
ZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgpDYzogQWtpbm9i
dSBNaXRhIDxha2lub2J1Lm1pdGFAZ21haWwuY29tPgotLS0KIGxpYi9mYXVsdC1pbmplY3QuYyB8
ICAgMTIgKysrLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA5IGRl
bGV0aW9ucygtKQoKLS0tIGEvbGliL2ZhdWx0LWluamVjdC5jCisrKyBiL2xpYi9mYXVsdC1pbmpl
Y3QuYwpAQCAtNjUsMjIgKzY1LDE2IEBAIHN0YXRpYyBib29sIGZhaWxfdGFzayhzdHJ1Y3QgZmF1
bHRfYXR0cgogCiBzdGF0aWMgYm9vbCBmYWlsX3N0YWNrdHJhY2Uoc3RydWN0IGZhdWx0X2F0dHIg
KmF0dHIpCiB7Ci0Jc3RydWN0IHN0YWNrX3RyYWNlIHRyYWNlOwogCWludCBkZXB0aCA9IGF0dHIt
PnN0YWNrdHJhY2VfZGVwdGg7CiAJdW5zaWduZWQgbG9uZyBlbnRyaWVzW01BWF9TVEFDS19UUkFD
RV9ERVBUSF07Ci0JaW50IG47CisJaW50IG4sIG5yX2VudHJpZXM7CiAJYm9vbCBmb3VuZCA9IChh
dHRyLT5yZXF1aXJlX3N0YXJ0ID09IDAgJiYgYXR0ci0+cmVxdWlyZV9lbmQgPT0gVUxPTkdfTUFY
KTsKIAogCWlmIChkZXB0aCA9PSAwKQogCQlyZXR1cm4gZm91bmQ7CiAKLQl0cmFjZS5ucl9lbnRy
aWVzID0gMDsKLQl0cmFjZS5lbnRyaWVzID0gZW50cmllczsKLQl0cmFjZS5tYXhfZW50cmllcyA9
IGRlcHRoOwotCXRyYWNlLnNraXAgPSAxOwotCi0Jc2F2ZV9zdGFja190cmFjZSgmdHJhY2UpOwot
CWZvciAobiA9IDA7IG4gPCB0cmFjZS5ucl9lbnRyaWVzOyBuKyspIHsKKwlucl9lbnRyaWVzID0g
c3RhY2tfdHJhY2Vfc2F2ZShlbnRyaWVzLCBkZXB0aCwgMSk7CisJZm9yIChuID0gMDsgbiA8IG5y
X2VudHJpZXM7IG4rKykgewogCQlpZiAoYXR0ci0+cmVqZWN0X3N0YXJ0IDw9IGVudHJpZXNbbl0g
JiYKIAkJCSAgICAgICBlbnRyaWVzW25dIDwgYXR0ci0+cmVqZWN0X2VuZCkKIAkJCXJldHVybiBm
YWxzZTsKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJ
bnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
