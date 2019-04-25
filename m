From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V3 18/29] lockdep: Remove save argument from
 check_prev_add()
Date: Thu, 25 Apr 2019 11:45:11 +0200
Message-ID: <20190425094802.803362058@linutronix.de>
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

VGhlcmUgaXMgb25seSBvbmUgY2FsbGVyIHdoaWNoIGhhbmRzIGluIHNhdmVfdHJhY2UgYXMgZnVu
Y3Rpb24gcG9pbnRlci4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51
dHJvbml4LmRlPgotLS0KIGtlcm5lbC9sb2NraW5nL2xvY2tkZXAuYyB8ICAgMTYgKysrKysrKyst
LS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkK
Ci0tLSBhL2tlcm5lbC9sb2NraW5nL2xvY2tkZXAuYworKysgYi9rZXJuZWwvbG9ja2luZy9sb2Nr
ZGVwLmMKQEAgLTIxNTgsOCArMjE1OCw3IEBAIGNoZWNrX2RlYWRsb2NrKHN0cnVjdCB0YXNrX3N0
cnVjdCAqY3VyciwKICAqLwogc3RhdGljIGludAogY2hlY2tfcHJldl9hZGQoc3RydWN0IHRhc2tf
c3RydWN0ICpjdXJyLCBzdHJ1Y3QgaGVsZF9sb2NrICpwcmV2LAotCSAgICAgICBzdHJ1Y3QgaGVs
ZF9sb2NrICpuZXh0LCBpbnQgZGlzdGFuY2UsIHN0cnVjdCBzdGFja190cmFjZSAqdHJhY2UsCi0J
ICAgICAgIGludCAoKnNhdmUpKHN0cnVjdCBzdGFja190cmFjZSAqdHJhY2UpKQorCSAgICAgICBz
dHJ1Y3QgaGVsZF9sb2NrICpuZXh0LCBpbnQgZGlzdGFuY2UsIHN0cnVjdCBzdGFja190cmFjZSAq
dHJhY2UpCiB7CiAJc3RydWN0IGxvY2tfbGlzdCAqdW5pbml0aWFsaXplZF92YXIodGFyZ2V0X2Vu
dHJ5KTsKIAlzdHJ1Y3QgbG9ja19saXN0ICplbnRyeTsKQEAgLTIxOTksMTEgKzIxOTgsMTEgQEAg
Y2hlY2tfcHJldl9hZGQoc3RydWN0IHRhc2tfc3RydWN0ICpjdXJyLAogCWlmICh1bmxpa2VseSgh
cmV0KSkgewogCQlpZiAoIXRyYWNlLT5lbnRyaWVzKSB7CiAJCQkvKgotCQkJICogSWYgQHNhdmUg
ZmFpbHMgaGVyZSwgdGhlIHByaW50aW5nIG1pZ2h0IHRyaWdnZXIKLQkJCSAqIGEgV0FSTiBidXQg
YmVjYXVzZSBvZiB0aGUgIW5yX2VudHJpZXMgaXQgc2hvdWxkCi0JCQkgKiBub3QgZG8gYmFkIHRo
aW5ncy4KKwkJCSAqIElmIHNhdmVfdHJhY2UgZmFpbHMgaGVyZSwgdGhlIHByaW50aW5nIG1pZ2h0
CisJCQkgKiB0cmlnZ2VyIGEgV0FSTiBidXQgYmVjYXVzZSBvZiB0aGUgIW5yX2VudHJpZXMgaXQK
KwkJCSAqIHNob3VsZCBub3QgZG8gYmFkIHRoaW5ncy4KIAkJCSAqLwotCQkJc2F2ZSh0cmFjZSk7
CisJCQlzYXZlX3RyYWNlKHRyYWNlKTsKIAkJfQogCQlyZXR1cm4gcHJpbnRfY2lyY3VsYXJfYnVn
KCZ0aGlzLCB0YXJnZXRfZW50cnksIG5leHQsIHByZXYpOwogCX0KQEAgLTIyNTMsNyArMjI1Miw3
IEBAIGNoZWNrX3ByZXZfYWRkKHN0cnVjdCB0YXNrX3N0cnVjdCAqY3VyciwKIAkJcmV0dXJuIHBy
aW50X2Jmc19idWcocmV0KTsKIAogCi0JaWYgKCF0cmFjZS0+ZW50cmllcyAmJiAhc2F2ZSh0cmFj
ZSkpCisJaWYgKCF0cmFjZS0+ZW50cmllcyAmJiAhc2F2ZV90cmFjZSh0cmFjZSkpCiAJCXJldHVy
biAwOwogCiAJLyoKQEAgLTIzMTgsNyArMjMxNyw4IEBAIGNoZWNrX3ByZXZzX2FkZChzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKmN1cnIKIAkJICogYWRkZWQ6CiAJCSAqLwogCQlpZiAoaGxvY2stPnJlYWQg
IT0gMiAmJiBobG9jay0+Y2hlY2spIHsKLQkJCWludCByZXQgPSBjaGVja19wcmV2X2FkZChjdXJy
LCBobG9jaywgbmV4dCwgZGlzdGFuY2UsICZ0cmFjZSwgc2F2ZV90cmFjZSk7CisJCQlpbnQgcmV0
ID0gY2hlY2tfcHJldl9hZGQoY3VyciwgaGxvY2ssIG5leHQsIGRpc3RhbmNlLAorCQkJCQkJICZ0
cmFjZSk7CiAJCQlpZiAoIXJldCkKIAkJCQlyZXR1cm4gMDsKIAoKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50
ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9y
Zy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
