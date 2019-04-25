From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 06/29] latency_top: Simplify stack trace
 handling
Date: Thu, 25 Apr 2019 11:44:59 +0200
Message-ID: <20190425094801.683039030@linutronix.de>
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
ZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgotLS0KIGtlcm5l
bC9sYXRlbmN5dG9wLmMgfCAgIDE3ICsrLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAxNSBkZWxldGlvbnMoLSkKCi0tLSBhL2tlcm5lbC9sYXRlbmN5dG9w
LmMKKysrIGIva2VybmVsL2xhdGVuY3l0b3AuYwpAQCAtMTQxLDIwICsxNDEsNiBAQCBhY2NvdW50
X2dsb2JhbF9zY2hlZHVsZXJfbGF0ZW5jeShzdHJ1Y3QKIAltZW1jcHkoJmxhdGVuY3lfcmVjb3Jk
W2ldLCBsYXQsIHNpemVvZihzdHJ1Y3QgbGF0ZW5jeV9yZWNvcmQpKTsKIH0KIAotLyoKLSAqIEl0
ZXJhdG9yIHRvIHN0b3JlIGEgYmFja3RyYWNlIGludG8gYSBsYXRlbmN5IHJlY29yZCBlbnRyeQot
ICovCi1zdGF0aWMgaW5saW5lIHZvaWQgc3RvcmVfc3RhY2t0cmFjZShzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnRzaywKLQkJCQkJc3RydWN0IGxhdGVuY3lfcmVjb3JkICpsYXQpCi17Ci0Jc3RydWN0IHN0
YWNrX3RyYWNlIHRyYWNlOwotCi0JbWVtc2V0KCZ0cmFjZSwgMCwgc2l6ZW9mKHRyYWNlKSk7Ci0J
dHJhY2UubWF4X2VudHJpZXMgPSBMVF9CQUNLVFJBQ0VERVBUSDsKLQl0cmFjZS5lbnRyaWVzID0g
JmxhdC0+YmFja3RyYWNlWzBdOwotCXNhdmVfc3RhY2tfdHJhY2VfdHNrKHRzaywgJnRyYWNlKTsK
LX0KLQogLyoqCiAgKiBfX2FjY291bnRfc2NoZWR1bGVyX2xhdGVuY3kgLSByZWNvcmQgYW4gb2Nj
dXJyZWQgbGF0ZW5jeQogICogQHRzayAtIHRoZSB0YXNrIHN0cnVjdCBvZiB0aGUgdGFzayBoaXR0
aW5nIHRoZSBsYXRlbmN5CkBAIC0xOTEsNyArMTc3LDggQEAgdm9pZCBfX3NjaGVkCiAJbGF0LmNv
dW50ID0gMTsKIAlsYXQudGltZSA9IHVzZWNzOwogCWxhdC5tYXggPSB1c2VjczsKLQlzdG9yZV9z
dGFja3RyYWNlKHRzaywgJmxhdCk7CisKKwlzdGFja190cmFjZV9zYXZlX3Rzayh0c2ssIGxhdC5i
YWNrdHJhY2UsIExUX0JBQ0tUUkFDRURFUFRILCAwKTsKIAogCXJhd19zcGluX2xvY2tfaXJxc2F2
ZSgmbGF0ZW5jeV9sb2NrLCBmbGFncyk7CiAKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVsLWdmeEBsaXN0
cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9s
aXN0aW5mby9pbnRlbC1nZng=
