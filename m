From: mwilck@suse.com
Subject: [PATCH 16/35] libmultipath: fix gcc -Wstringop-overflow
	warning
Date: Thu,  9 Jul 2020 12:16:01 +0200
Message-ID: <20200709101620.6786-17-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

RnJvbTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+CgpUaGlzIGZpeGVzIHRoaXMgZ2Nj
IGVycm9yIG1lc3NhZ2U6CgplcnJvcjog4oCYc3RybmNhdOKAmSBzcGVjaWZpZWQgYm91bmQgMSBl
cXVhbHMgc291cmNlIGxlbmd0aAogICBbLVdlcnJvcj1zdHJpbmdvcC1vdmVyZmxvdz1dClNpZ25l
ZC1vZmYtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgotLS0KIGxpYm11bHRpcGF0
aC9wYXJzZXIuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxl
dGlvbigtKQoKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9wYXJzZXIuYyBiL2xpYm11bHRpcGF0
aC9wYXJzZXIuYwppbmRleCAxMWE2MTY4Li40ZjY1YmExIDEwMDY0NAotLS0gYS9saWJtdWx0aXBh
dGgvcGFyc2VyLmMKKysrIGIvbGlibXVsdGlwYXRoL3BhcnNlci5jCkBAIC0zNzQsNyArMzc0LDcg
QEAgc2V0X3ZhbHVlKHZlY3RvciBzdHJ2ZWMpCiAJCQlnb3RvIG9vbTsKIAkJfQogCQlpZiAoKmFs
bG9jICE9ICdcMCcpCi0JCQlzdHJuY2F0KGFsbG9jLCAiICIsIDEpOworCQkJc3RybmNhdChhbGxv
YywgIiAiLCBsZW4gLSBzdHJsZW4oYWxsb2MpKTsKIAkJc3RybmNhdChhbGxvYywgc3RyLCBsZW4g
LSBzdHJsZW4oYWxsb2MpIC0gMSk7CiAJfQogCXJldHVybiBhbGxvYzsKLS0gCjIuMjYuMgoKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
