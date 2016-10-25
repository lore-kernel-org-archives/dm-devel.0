From: ding.yemin@zte.com.cn
Subject: [PATCH] RCU protection for variable conf in
	add_map_with_path()
Date: Tue, 25 Oct 2016 16:41:52 +0800
Message-ID: <1477384912-10940-1-git-send-email-ding.yemin@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: tang.junhui@zte.com.cn, zhang.kai16@zte.com.cn, "ding.yemin" <ding.yemin@zte.com.cn>, dm-devel@redhat.com
List-Id: dm-devel.ids

RnJvbTogImRpbmcueWVtaW4iIDxkaW5nLnllbWluQHp0ZS5jb20uY24+CgpUYWtlIHRoZSB2YXJp
YWJsZSAiY29uZiIgdW5kZXIgUkNVIHByb3RlY3Rpb24gaW4gYWRkX21hcF93aXRoX3BhdGgoKeOA
ggoKU2lnbmVkLW9mZi1ieTogZGluZy55ZW1pbiA8ZGluZy55ZW1pbkB6dGUuY29tLmNuPgotLS0K
IGxpYm11bHRpcGF0aC9zdHJ1Y3RzX3ZlYy5jIHwgNiArKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRo
L3N0cnVjdHNfdmVjLmMgYi9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYwppbmRleCBhMGM4ODY5
Li5iOGFlODdjIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYworKysgYi9s
aWJtdWx0aXBhdGgvc3RydWN0c192ZWMuYwpAQCAtNDg5LDEyICs0ODksMTQgQEAgYWRkX21hcF93
aXRoX3BhdGggKHN0cnVjdCB2ZWN0b3JzICogdmVjcywKIAljb25mID0gZ2V0X211bHRpcGF0aF9j
b25maWcoKTsKIAltcHAtPm1wZSA9IGZpbmRfbXBlKGNvbmYtPm1wdGFibGUsIHBwLT53d2lkKTsK
IAltcHAtPmh3ZSA9IHBwLT5od2U7Ci0JcHV0X211bHRpcGF0aF9jb25maWcoY29uZik7CiAKIAlz
dHJjcHkobXBwLT53d2lkLCBwcC0+d3dpZCk7CiAJZmluZF9leGlzdGluZ19hbGlhcyhtcHAsIHZl
Y3MpOwotCWlmIChzZWxlY3RfYWxpYXMoY29uZiwgbXBwKSkKKwlpZiAoc2VsZWN0X2FsaWFzKGNv
bmYsIG1wcCkpIHsKKwkJcHV0X211bHRpcGF0aF9jb25maWcoY29uZik7CiAJCWdvdG8gb3V0Owor
CX0KKwlwdXRfbXVsdGlwYXRoX2NvbmZpZyhjb25mKTsKIAltcHAtPnNpemUgPSBwcC0+c2l6ZTsK
IAogCWlmIChhZG9wdF9wYXRocyh2ZWNzLT5wYXRodmVjLCBtcHApKQotLSAKMi44LjEud2luZG93
cy4xCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
