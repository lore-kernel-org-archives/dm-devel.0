From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 17/29] lockdep: Remove unused trace argument
 from print_circular_bug()
Date: Thu, 18 Apr 2019 10:41:36 +0200
Message-ID: <20190418084254.639634107@linutronix.de>
References: <20190418084119.056416939@linutronix.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, Johannes Thumshirn <jthumshirn@suse.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, David Rientjes <rientjes@google.com>, Akinobu Mita <akinobu.mita@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Josef Bacik <josef@toxicpanda.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, David Sterba <dster>
List-Id: dm-devel.ids

U2lnbmVkLW9mZi1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+Ci0tLQog
a2VybmVsL2xvY2tpbmcvbG9ja2RlcC5jIHwgICAgOSArKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgotLS0gYS9rZXJuZWwvbG9ja2luZy9s
b2NrZGVwLmMKKysrIGIva2VybmVsL2xvY2tpbmcvbG9ja2RlcC5jCkBAIC0xNTIyLDEwICsxNTIy
LDkgQEAgc3RhdGljIGlubGluZSBpbnQgY2xhc3NfZXF1YWwoc3RydWN0IGxvYwogfQogCiBzdGF0
aWMgbm9pbmxpbmUgaW50IHByaW50X2NpcmN1bGFyX2J1ZyhzdHJ1Y3QgbG9ja19saXN0ICp0aGlz
LAotCQkJCXN0cnVjdCBsb2NrX2xpc3QgKnRhcmdldCwKLQkJCQlzdHJ1Y3QgaGVsZF9sb2NrICpj
aGVja19zcmMsCi0JCQkJc3RydWN0IGhlbGRfbG9jayAqY2hlY2tfdGd0LAotCQkJCXN0cnVjdCBz
dGFja190cmFjZSAqdHJhY2UpCisJCQkJICAgICAgIHN0cnVjdCBsb2NrX2xpc3QgKnRhcmdldCwK
KwkJCQkgICAgICAgc3RydWN0IGhlbGRfbG9jayAqY2hlY2tfc3JjLAorCQkJCSAgICAgICBzdHJ1
Y3QgaGVsZF9sb2NrICpjaGVja190Z3QpCiB7CiAJc3RydWN0IHRhc2tfc3RydWN0ICpjdXJyID0g
Y3VycmVudDsKIAlzdHJ1Y3QgbG9ja19saXN0ICpwYXJlbnQ7CkBAIC0yMjA2LDcgKzIyMDUsNyBA
QCBjaGVja19wcmV2X2FkZChzdHJ1Y3QgdGFza19zdHJ1Y3QgKmN1cnIsCiAJCQkgKi8KIAkJCXNh
dmUodHJhY2UpOwogCQl9Ci0JCXJldHVybiBwcmludF9jaXJjdWxhcl9idWcoJnRoaXMsIHRhcmdl
dF9lbnRyeSwgbmV4dCwgcHJldiwgdHJhY2UpOworCQlyZXR1cm4gcHJpbnRfY2lyY3VsYXJfYnVn
KCZ0aGlzLCB0YXJnZXRfZW50cnksIG5leHQsIHByZXYpOwogCX0KIAllbHNlIGlmICh1bmxpa2Vs
eShyZXQgPCAwKSkKIAkJcmV0dXJuIHByaW50X2Jmc19idWcocmV0KTsKCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0
CkludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3Rv
cC5vcmcvbWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZng=
