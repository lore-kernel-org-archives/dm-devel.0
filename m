From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 07/29] mm/slub: Simplify stack trace retrieval
Date: Thu, 25 Apr 2019 11:45:00 +0200
Message-ID: <20190425094801.771410441@linutronix.de>
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
ZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgpBY2tlZC1ieTog
Q2hyaXN0b3BoIExhbWV0ZXIgPGNsQGxpbnV4LmNvbT4KQ2M6IEFuZHJldyBNb3J0b24gPGFrcG1A
bGludXgtZm91bmRhdGlvbi5vcmc+CkNjOiBQZWtrYSBFbmJlcmcgPHBlbmJlcmdAa2VybmVsLm9y
Zz4KQ2M6IGxpbnV4LW1tQGt2YWNrLm9yZwpDYzogRGF2aWQgUmllbnRqZXMgPHJpZW50amVzQGdv
b2dsZS5jb20+Ci0tLQogbW0vc2x1Yi5jIHwgICAxMiArKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgotLS0gYS9tbS9zbHViLmMKKysr
IGIvbW0vc2x1Yi5jCkBAIC01NTIsMTggKzU1MiwxNCBAQCBzdGF0aWMgdm9pZCBzZXRfdHJhY2so
c3RydWN0IGttZW1fY2FjaGUKIAogCWlmIChhZGRyKSB7CiAjaWZkZWYgQ09ORklHX1NUQUNLVFJB
Q0UKLQkJc3RydWN0IHN0YWNrX3RyYWNlIHRyYWNlOworCQl1bnNpZ25lZCBpbnQgbnJfZW50cmll
czsKIAotCQl0cmFjZS5ucl9lbnRyaWVzID0gMDsKLQkJdHJhY2UubWF4X2VudHJpZXMgPSBUUkFD
S19BRERSU19DT1VOVDsKLQkJdHJhY2UuZW50cmllcyA9IHAtPmFkZHJzOwotCQl0cmFjZS5za2lw
ID0gMzsKIAkJbWV0YWRhdGFfYWNjZXNzX2VuYWJsZSgpOwotCQlzYXZlX3N0YWNrX3RyYWNlKCZ0
cmFjZSk7CisJCW5yX2VudHJpZXMgPSBzdGFja190cmFjZV9zYXZlKHAtPmFkZHJzLCBUUkFDS19B
RERSU19DT1VOVCwgMyk7CiAJCW1ldGFkYXRhX2FjY2Vzc19kaXNhYmxlKCk7CiAKLQkJaWYgKHRy
YWNlLm5yX2VudHJpZXMgPCBUUkFDS19BRERSU19DT1VOVCkKLQkJCXAtPmFkZHJzW3RyYWNlLm5y
X2VudHJpZXNdID0gMDsKKwkJaWYgKG5yX2VudHJpZXMgPCBUUkFDS19BRERSU19DT1VOVCkKKwkJ
CXAtPmFkZHJzW25yX2VudHJpZXNdID0gMDsKICNlbmRpZgogCQlwLT5hZGRyID0gYWRkcjsKIAkJ
cC0+Y3B1ID0gc21wX3Byb2Nlc3Nvcl9pZCgpOwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxp
c3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2ludGVsLWdmeA==
