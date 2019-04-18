From: Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: Re: [patch V2 20/29] tracing: Simplify stacktrace
 retrieval in histograms
Date: Thu, 18 Apr 2019 14:58:55 -0500
Message-ID: <014a7564d606b249a5e50bef0fedf266977a935b.camel@linux.intel.com>
References: <20190418084119.056416939@linutronix.de>
 <20190418084254.910579307@linutronix.de>
 <20190418094014.7d457f29@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20190418094014.7d457f29@gandalf.local.home>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>, Catalin Marinas <catalin.marinas@arm.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, dm-devel@redhat.com, Alexander Potapenko <glider@google.com>, Christoph Lameter <cl@linux.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, linux-arch@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, Johannes Thumshirn <jthumshirn@suse.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexey Dobriyan <adobriyan@gmail.com>, intel-gfx@lists.freedesktop.org, David Rientjes <rientjes@google.com>, Akinobu Mita <akinobu.mita@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, David Sterba <dsterba@suse.com>, Dmitry Vyukov <dvyukov@g>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE5LTA0LTE4IGF0IDA5OjQwIC0wNDAwLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToK
PiBbIEFkZGVkIFRvbSBaYW51c3NpIF0KPiAKPiBPbiBUaHUsIDE4IEFwciAyMDE5IDEwOjQxOjM5
ICswMjAwCj4gVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+IHdyb3RlOgo+IAo+
ID4gVGhlIGluZGlyZWN0aW9uIHRocm91Z2ggc3RydWN0IHN0YWNrX3RyYWNlIGlzIG5vdCBuZWNl
c3NhcnkgYXQgYWxsLgo+ID4gVXNlIHRoZQo+ID4gc3RvcmFnZSBhcnJheSBiYXNlZCBpbnRlcmZh
Y2UuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJv
bml4LmRlPgo+ID4gQ2M6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPgo+IAo+
IExvb2tzIGZpbmUgdG8gbWUKPiAKPiBBY2tlZC1ieTogU3RldmVuIFJvc3RlZHQgKFZNd2FyZSkg
PHJvc3RlZHRAZ29vZG1pcy5vcmc+Cj4gCj4gIEJ1dC4uLgo+IAo+IFRvbSwKPiAKPiBDYW4geW91
IHJldmlldyB0aGlzIHRvbz8KCkxvb2tzIGdvb2QgdG8gbWUgdG9vIQoKQWNrZWQtYnk6IFRvbSBa
YW51c3NpIDx0b20uemFudXNzaUBsaW51eC5pbnRlbC5jb20+CgoKPiAKPiBQYXRjaCBzZXJpZXMg
c3RhcnRzIGhlcmU6Cj4gCj4gICBodHRwOi8vbGttbC5rZXJuZWwub3JnL3IvMjAxOTA0MTgwODQx
MTkuMDU2NDE2OTM5QGxpbnV0cm9uaXguZGUKPiAKPiBUaGFua3MsCj4gCj4gLS0gU3RldmUKPiAK
PiA+IC0tLQo+ID4gIGtlcm5lbC90cmFjZS90cmFjZV9ldmVudHNfaGlzdC5jIHwgICAxMiArKyst
LS0tLS0tLS0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9u
cygtKQo+ID4gCj4gPiAtLS0gYS9rZXJuZWwvdHJhY2UvdHJhY2VfZXZlbnRzX2hpc3QuYwo+ID4g
KysrIGIva2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50c19oaXN0LmMKPiA+IEBAIC01MTg2LDcgKzUx
ODYsNiBAQCBzdGF0aWMgdm9pZCBldmVudF9oaXN0X3RyaWdnZXIoc3RydWN0IGV2Cj4gPiAgCXU2
NCB2YXJfcmVmX3ZhbHNbVFJBQ0lOR19NQVBfVkFSU19NQVhdOwo+ID4gIAljaGFyIGNvbXBvdW5k
X2tleVtISVNUX0tFWV9TSVpFX01BWF07Cj4gPiAgCXN0cnVjdCB0cmFjaW5nX21hcF9lbHQgKmVs
dCA9IE5VTEw7Cj4gPiAtCXN0cnVjdCBzdGFja190cmFjZSBzdGFja3RyYWNlOwo+ID4gIAlzdHJ1
Y3QgaGlzdF9maWVsZCAqa2V5X2ZpZWxkOwo+ID4gIAl1NjQgZmllbGRfY29udGVudHM7Cj4gPiAg
CXZvaWQgKmtleSA9IE5VTEw7Cj4gPiBAQCAtNTE5OCwxNCArNTE5Nyw5IEBAIHN0YXRpYyB2b2lk
IGV2ZW50X2hpc3RfdHJpZ2dlcihzdHJ1Y3QgZXYKPiA+ICAJCWtleV9maWVsZCA9IGhpc3RfZGF0
YS0+ZmllbGRzW2ldOwo+ID4gIAo+ID4gIAkJaWYgKGtleV9maWVsZC0+ZmxhZ3MgJiBISVNUX0ZJ
RUxEX0ZMX1NUQUNLVFJBQ0UpIHsKPiA+IC0JCQlzdGFja3RyYWNlLm1heF9lbnRyaWVzID0gSElT
VF9TVEFDS1RSQUNFX0RFUFRIOwo+ID4gLQkJCXN0YWNrdHJhY2UuZW50cmllcyA9IGVudHJpZXM7
Cj4gPiAtCQkJc3RhY2t0cmFjZS5ucl9lbnRyaWVzID0gMDsKPiA+IC0JCQlzdGFja3RyYWNlLnNr
aXAgPSBISVNUX1NUQUNLVFJBQ0VfU0tJUDsKPiA+IC0KPiA+IC0JCQltZW1zZXQoc3RhY2t0cmFj
ZS5lbnRyaWVzLCAwLAo+ID4gSElTVF9TVEFDS1RSQUNFX1NJWkUpOwo+ID4gLQkJCXNhdmVfc3Rh
Y2tfdHJhY2UoJnN0YWNrdHJhY2UpOwo+ID4gLQo+ID4gKwkJCW1lbXNldChlbnRyaWVzLCAwLCBI
SVNUX1NUQUNLVFJBQ0VfU0laRSk7Cj4gPiArCQkJc3RhY2tfdHJhY2Vfc2F2ZShlbnRyaWVzLAo+
ID4gSElTVF9TVEFDS1RSQUNFX0RFUFRILAo+ID4gKwkJCQkJIEhJU1RfU1RBQ0tUUkFDRV9TS0lQ
KTsKPiA+ICAJCQlrZXkgPSBlbnRyaWVzOwo+ID4gIAkJfSBlbHNlIHsKPiA+ICAJCQlmaWVsZF9j
b250ZW50cyA9IGtleV9maWVsZC0+Zm4oa2V5X2ZpZWxkLCBlbHQsCj4gPiByYmUsIHJlYyk7Cj4g
PiAKPiAKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpo
dHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
