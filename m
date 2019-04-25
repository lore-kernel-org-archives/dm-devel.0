From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 13/29] btrfs: ref-verify: Simplify stack
 trace retrieval
Date: Thu, 25 Apr 2019 11:45:06 +0200
Message-ID: <20190425094802.338890064@linutronix.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, Johannes Thumshirn <jthumshirn@suse.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, David Rientjes <rientjes@google.com>, Josef Bacik <josef@toxicpanda.com>, Steven Rostedt <rostedt@goodmis.org>, Akinobu Mita <akinobu.mita@gmail.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe>
List-Id: dm-devel.ids

UmVwbGFjZSB0aGUgaW5kaXJlY3Rpb24gdGhyb3VnaCBzdHJ1Y3Qgc3RhY2tfdHJhY2Ugd2l0aCBh
biBpbnZvY2F0aW9uIG9mCnRoZSBzdG9yYWdlIGFycmF5IGJhc2VkIGludGVyZmFjZS4KClNpZ25l
ZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgpSZXZpZXdlZC1i
eTogSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1bXNoaXJuQHN1c2UuZGU+CkFja2VkLWJ5OiBEYXZp
ZCBTdGVyYmEgPGRzdGVyYmFAc3VzZS5jb20+CkNjOiBDaHJpcyBNYXNvbiA8Y2xtQGZiLmNvbT4K
Q2M6IEpvc2VmIEJhY2lrIDxqb3NlZkB0b3hpY3BhbmRhLmNvbT4KQ2M6IGxpbnV4LWJ0cmZzQHZn
ZXIua2VybmVsLm9yZwotLS0KIGZzL2J0cmZzL3JlZi12ZXJpZnkuYyB8ICAgMTUgKystLS0tLS0t
LS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkK
Ci0tLSBhL2ZzL2J0cmZzL3JlZi12ZXJpZnkuYworKysgYi9mcy9idHJmcy9yZWYtdmVyaWZ5LmMK
QEAgLTIwNSwyOCArMjA1LDE3IEBAIHN0YXRpYyBzdHJ1Y3Qgcm9vdF9lbnRyeSAqbG9va3VwX3Jv
b3RfZW4KICNpZmRlZiBDT05GSUdfU1RBQ0tUUkFDRQogc3RhdGljIHZvaWQgX19zYXZlX3N0YWNr
X3RyYWNlKHN0cnVjdCByZWZfYWN0aW9uICpyYSkKIHsKLQlzdHJ1Y3Qgc3RhY2tfdHJhY2Ugc3Rh
Y2tfdHJhY2U7Ci0KLQlzdGFja190cmFjZS5tYXhfZW50cmllcyA9IE1BWF9UUkFDRTsKLQlzdGFj
a190cmFjZS5ucl9lbnRyaWVzID0gMDsKLQlzdGFja190cmFjZS5lbnRyaWVzID0gcmEtPnRyYWNl
OwotCXN0YWNrX3RyYWNlLnNraXAgPSAyOwotCXNhdmVfc3RhY2tfdHJhY2UoJnN0YWNrX3RyYWNl
KTsKLQlyYS0+dHJhY2VfbGVuID0gc3RhY2tfdHJhY2UubnJfZW50cmllczsKKwlyYS0+dHJhY2Vf
bGVuID0gc3RhY2tfdHJhY2Vfc2F2ZShyYS0+dHJhY2UsIE1BWF9UUkFDRSwgMik7CiB9CiAKIHN0
YXRpYyB2b2lkIF9fcHJpbnRfc3RhY2tfdHJhY2Uoc3RydWN0IGJ0cmZzX2ZzX2luZm8gKmZzX2lu
Zm8sCiAJCQkJc3RydWN0IHJlZl9hY3Rpb24gKnJhKQogewotCXN0cnVjdCBzdGFja190cmFjZSB0
cmFjZTsKLQogCWlmIChyYS0+dHJhY2VfbGVuID09IDApIHsKIAkJYnRyZnNfZXJyKGZzX2luZm8s
ICIgIHJlZi12ZXJpZnk6IG5vIHN0YWNrdHJhY2UiKTsKIAkJcmV0dXJuOwogCX0KLQl0cmFjZS5u
cl9lbnRyaWVzID0gcmEtPnRyYWNlX2xlbjsKLQl0cmFjZS5lbnRyaWVzID0gcmEtPnRyYWNlOwot
CXByaW50X3N0YWNrX3RyYWNlKCZ0cmFjZSwgMik7CisJc3RhY2tfdHJhY2VfcHJpbnQocmEtPnRy
YWNlLCByYS0+dHJhY2VfbGVuLCAyKTsKIH0KICNlbHNlCiBzdGF0aWMgdm9pZCBpbmxpbmUgX19z
YXZlX3N0YWNrX3RyYWNlKHN0cnVjdCByZWZfYWN0aW9uICpyYSkKCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0Cklu
dGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5v
cmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
