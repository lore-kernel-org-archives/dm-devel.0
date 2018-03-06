From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 04/23] libmultipath: parser: use
 call-by-value for "snprint" methods
Date: Tue, 6 Mar 2018 08:05:58 +0100
Message-ID: <671fdad0-4949-1d76-72ab-bdcfda34aa4d@suse.de>
References: <20180305231507.10386-1-mwilck@suse.com>
	<20180305231507.10386-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180305231507.10386-5-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

T24gMDMvMDYvMjAxOCAxMjoxNCBBTSwgTWFydGluIFdpbGNrIHdyb3RlOgo+IENvbnZlcnQgdGhl
IHNucHJpbnQgbWV0aG9kcyBmb3IgYWxsIGtleXdvcmRzIHRvIGNhbGwtYnktdmFsdWUsCj4gYW5k
IHVzZSAiY29uc3QiIHF1YWxpZmllciBmb3IgdGhlICJkYXRhIiBhcmd1bWVudC4gVGhpcyBtYWtl
cyBzdXJlCj4gdGhhdCAic25wcmludCIgdHlwZSBmdW5jdGlvbnMgZG9uJ3QgbW9kaWZ5IHRoZSBk
YXRhIHRoZXkncmUgcHJpbnQsCj4gaGVscHMgY29tcGlsZS10aW1lIGNvcnJlY3RuZXNzIGNoZWNr
aW5nLCBhbmQgYWxsb3dzIG1vcmUgcHJvcGVyCj4gImNvbnN0IiBjbGVhbnVwcyBpbiB0aGUgZnV0
dXJlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgo+
IFJldmlld2VkLWJ5OiBCZW5qYW1pbiBNYXJ6aW5za2kgPGJtYXJ6aW5zQHJlZGhhdC5jb20+Cj4g
LS0tCj4gIGxpYm11bHRpcGF0aC9kaWN0LmMgICB8IDIwNiArKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICBsaWJtdWx0aXBhdGgvcGFyc2VyLmMgfCAg
IDkgKystCj4gIGxpYm11bHRpcGF0aC9wYXJzZXIuaCB8ICAxMiArKy0KPiAgMyBmaWxlcyBjaGFu
Z2VkLCAxMTIgaW5zZXJ0aW9ucygrKSwgMTE1IGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTog
SGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuY29tPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4g
SGFubmVzIFJlaW5lY2tlCQkgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2luZwpoYXJlQHN1
c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIExJTlVYIEdtYkgs
IE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBKLiBT
bWl0aGFyZCwgSi4gR3VpbGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7D
vHJuYmVyZykKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
