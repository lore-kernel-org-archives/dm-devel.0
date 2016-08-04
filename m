From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/2] multipath-tools: replace daddr_t type with
	long in kpartx/solaris.c
Date: Thu,  4 Aug 2016 20:24:32 +0200
Message-ID: <1470335072-13867-2-git-send-email-xose.vazquez@gmail.com>
References: <1470335072-13867-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470335072-13867-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

ZGFkZHJfdCBpcyBhbiB1bmtub3cgdHlwZSBmb3IgbXVzbCBsaWJjCgptdXNsLWdjYyBvdXRwdXQ6
CnNvbGFyaXMuYzoxNDoyOiBlcnJvcjogdW5rbm93biB0eXBlIG5hbWUg4oCYZGFkZHJfdOKAmQoK
UmVwbGFjZSBpdCB3aXRoIGxvbmcuCgpDb21waWxlZCB0ZXN0ZWQgb25seSwgcGxlYXNlIHJldmll
dy4KCkNjOiBDaHJpc3RvcGhlIFZhcm9xdWkgPGNocmlzdG9waGUudmFyb3F1aUBvcGVuc3ZjLmNv
bT4KQ2M6IGRldmljZS1tYXBwZXIgZGV2ZWxvcG1lbnQgPGRtLWRldmVsQHJlZGhhdC5jb20+ClNp
Z25lZC1vZmYtYnk6IFhvc2UgVmF6cXVleiBQZXJleiA8eG9zZS52YXpxdWV6QGdtYWlsLmNvbT4K
LS0tCiBrcGFydHgvc29sYXJpcy5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEva3BhcnR4L3NvbGFyaXMuYyBiL2twYXJ0
eC9zb2xhcmlzLmMKaW5kZXggMzU1YTZjYi4uMDFkYTM3OSAxMDA2NDQKLS0tIGEva3BhcnR4L3Nv
bGFyaXMuYworKysgYi9rcGFydHgvc29sYXJpcy5jCkBAIC0xMSw3ICsxMSw3IEBACiBzdHJ1Y3Qg
c29sYXJpc194ODZfc2xpY2UgewogCXVuc2lnbmVkIHNob3J0CXNfdGFnOwkJLyogSUQgdGFnIG9m
IHBhcnRpdGlvbiAqLwogCXVuc2lnbmVkIHNob3J0CXNfZmxhZzsJCS8qIHBlcm1pc2lvbiBmbGFn
cyAqLwotCWRhZGRyX3QJCXNfc3RhcnQ7CS8qIHN0YXJ0IHNlY3RvciBubyBvZiBwYXJ0aXRpb24g
Ki8KKwlsb25nCQlzX3N0YXJ0OwkvKiBzdGFydCBzZWN0b3Igbm8gb2YgcGFydGl0aW9uICovCiAJ
bG9uZwkJc19zaXplOwkJLyogIyBvZiBibG9ja3MgaW4gcGFydGl0aW9uICovCiB9OwogCi0tIAoy
LjcuNAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
