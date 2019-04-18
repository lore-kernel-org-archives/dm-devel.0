From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 20/29] tracing: Simplify stacktrace retrieval
 in histograms
Date: Thu, 18 Apr 2019 10:41:39 +0200
Message-ID: <20190418084254.910579307@linutronix.de>
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

VGhlIGluZGlyZWN0aW9uIHRocm91Z2ggc3RydWN0IHN0YWNrX3RyYWNlIGlzIG5vdCBuZWNlc3Nh
cnkgYXQgYWxsLiBVc2UgdGhlCnN0b3JhZ2UgYXJyYXkgYmFzZWQgaW50ZXJmYWNlLgoKU2lnbmVk
LW9mZi1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+CkNjOiBTdGV2ZW4g
Um9zdGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4KLS0tCiBrZXJuZWwvdHJhY2UvdHJhY2VfZXZl
bnRzX2hpc3QuYyB8ICAgMTIgKysrLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCA5IGRlbGV0aW9ucygtKQoKLS0tIGEva2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50c19o
aXN0LmMKKysrIGIva2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50c19oaXN0LmMKQEAgLTUxODYsNyAr
NTE4Niw2IEBAIHN0YXRpYyB2b2lkIGV2ZW50X2hpc3RfdHJpZ2dlcihzdHJ1Y3QgZXYKIAl1NjQg
dmFyX3JlZl92YWxzW1RSQUNJTkdfTUFQX1ZBUlNfTUFYXTsKIAljaGFyIGNvbXBvdW5kX2tleVtI
SVNUX0tFWV9TSVpFX01BWF07CiAJc3RydWN0IHRyYWNpbmdfbWFwX2VsdCAqZWx0ID0gTlVMTDsK
LQlzdHJ1Y3Qgc3RhY2tfdHJhY2Ugc3RhY2t0cmFjZTsKIAlzdHJ1Y3QgaGlzdF9maWVsZCAqa2V5
X2ZpZWxkOwogCXU2NCBmaWVsZF9jb250ZW50czsKIAl2b2lkICprZXkgPSBOVUxMOwpAQCAtNTE5
OCwxNCArNTE5Nyw5IEBAIHN0YXRpYyB2b2lkIGV2ZW50X2hpc3RfdHJpZ2dlcihzdHJ1Y3QgZXYK
IAkJa2V5X2ZpZWxkID0gaGlzdF9kYXRhLT5maWVsZHNbaV07CiAKIAkJaWYgKGtleV9maWVsZC0+
ZmxhZ3MgJiBISVNUX0ZJRUxEX0ZMX1NUQUNLVFJBQ0UpIHsKLQkJCXN0YWNrdHJhY2UubWF4X2Vu
dHJpZXMgPSBISVNUX1NUQUNLVFJBQ0VfREVQVEg7Ci0JCQlzdGFja3RyYWNlLmVudHJpZXMgPSBl
bnRyaWVzOwotCQkJc3RhY2t0cmFjZS5ucl9lbnRyaWVzID0gMDsKLQkJCXN0YWNrdHJhY2Uuc2tp
cCA9IEhJU1RfU1RBQ0tUUkFDRV9TS0lQOwotCi0JCQltZW1zZXQoc3RhY2t0cmFjZS5lbnRyaWVz
LCAwLCBISVNUX1NUQUNLVFJBQ0VfU0laRSk7Ci0JCQlzYXZlX3N0YWNrX3RyYWNlKCZzdGFja3Ry
YWNlKTsKLQorCQkJbWVtc2V0KGVudHJpZXMsIDAsIEhJU1RfU1RBQ0tUUkFDRV9TSVpFKTsKKwkJ
CXN0YWNrX3RyYWNlX3NhdmUoZW50cmllcywgSElTVF9TVEFDS1RSQUNFX0RFUFRILAorCQkJCQkg
SElTVF9TVEFDS1RSQUNFX1NLSVApOwogCQkJa2V5ID0gZW50cmllczsKIAkJfSBlbHNlIHsKIAkJ
CWZpZWxkX2NvbnRlbnRzID0ga2V5X2ZpZWxkLT5mbihrZXlfZmllbGQsIGVsdCwgcmJlLCByZWMp
OwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVs
LWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczov
L2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
