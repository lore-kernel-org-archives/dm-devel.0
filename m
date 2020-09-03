From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 00/14] multipath-tools series: some cleanups
 and fixes checked by codedex tool
Date: Thu, 03 Sep 2020 22:08:53 +0200
Message-ID: <73d14f51e1ca6aeb8dbd40f5a22c21508b6d4401.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-uonpg43clZDklqTjNC2Y"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

--=-uonpg43clZDklqTjNC2Y
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

Hello Lixiaokeng,

On Wed, 2020-09-02 at 14:40 +0800, lixiaokeng wrote:
> Hi:
>     Now, we check multipath-tools codes with codedex tool. Here
> are some some cleanups and fixes.

Thank you. However I'm going to nack all patches that add error
messages after unsuccesful memory allocations. Such messages are
unhelpful most of the time, and increase the code size without a true
benefit. I've actually considered to get rid of all these, and replace
them by a log_oom() macro.

See an untested prototype attached, to better understand what I mean.

Regards
Martin



--=-uonpg43clZDklqTjNC2Y
Content-Disposition: attachment;
	filename="0001-libmultipath-prototype-implementation-of-log_oom.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0001-libmultipath-prototype-implementation-of-log_oom.patch";
	charset="ISO-8859-15"

RnJvbSBmYmJjYTJjNTA3NmE0ODllZTRhZTY0M2Q2ZDkxOTljYTUwODViZTk1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
VGh1LCAzIFNlcCAyMDIwIDIyOjAzOjIyICswMjAwClN1YmplY3Q6IFtQQVRDSF0gbGlibXVsdGlw
YXRoOiBwcm90b3R5cGUgaW1wbGVtZW50YXRpb24gb2YgbG9nX29vbSgpCgpSYXRpb25hbGU6IHdp
dGggVkVSQk9TRV9PT01fTE9HR0lORywgd2UgbG9nIHRoZSBwYXJ0IG9mIHRoZSBjb2RlCndoZXJl
IE9PTSBvY2N1cmVkLCB3aXRoIG1pbmltYWwgcnVudGltZSBlZmZvcnQgKG5vIHN0cmluZyBmb3Jt
YXR0aW5nKS4KV2l0aCBsb3RzIG9mIGxvZ19vb20oKSBpbnZvY2F0aW9ucywgb3VyIGJpbmFyeSB3
aWxsIGluY3JlYXNlIGJ5IG1hbnkKc3RhdGljIHN0cmluZ3MuIFdpdGhvdXQgVkVSQk9TRV9PT01f
TE9HR0lORywgd2UganVzdCBwcmludCBhIG1pbmltYWwKZXJyb3IgbWVzc2FnZSwgd2hpY2ggd2ls
bCBiZSBlbm91Z2ggbW9zdCBvZiB0aGUgdGltZS4KClNpZ25lZC1vZmYtYnk6IE1hcnRpbiBXaWxj
ayA8bXdpbGNrQHN1c2UuY29tPgotLS0KIGxpYm11bHRpcGF0aC9kZWJ1Zy5jIHwgNyArKysrKysr
CiBsaWJtdWx0aXBhdGgvZGVidWcuaCB8IDggKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTUg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9kZWJ1Zy5jIGIvbGlibXVs
dGlwYXRoL2RlYnVnLmMKaW5kZXggNDEyOGNiOS4uOTA2MjU4MSAxMDA2NDQKLS0tIGEvbGlibXVs
dGlwYXRoL2RlYnVnLmMKKysrIGIvbGlibXVsdGlwYXRoL2RlYnVnLmMKQEAgLTQ4LDMgKzQ4LDEw
IEBAIHZvaWQgZGxvZyAoaW50IHNpbmssIGludCBwcmlvLCBjb25zdCBjaGFyICogZm10LCAuLi4p
CiAJfQogCXZhX2VuZChhcCk7CiB9CisKKyNpZm5kZWYgVkVSQk9TRV9PT01fTE9HR0lORwordm9p
ZCBsb2dfb29tKHZvaWQpCit7CisJY29uZGxvZygwLCAiT3V0IG9mIG1lbW9yeSIpOworfQorI2Vu
ZGlmCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvZGVidWcuaCBiL2xpYm11bHRpcGF0aC9kZWJ1
Zy5oCmluZGV4IGM2MTIwYzEuLmY2MWVjYjYgMTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9kZWJ1
Zy5oCisrKyBiL2xpYm11bHRpcGF0aC9kZWJ1Zy5oCkBAIC0xMSwzICsxMSwxMSBAQCBleHRlcm4g
aW50IGxvZ3Npbms7CiAKICNkZWZpbmUgY29uZGxvZyhwcmlvLCBmbXQsIGFyZ3MuLi4pIFwKIAlk
bG9nKGxvZ3NpbmssIHByaW8sIGZtdCAiXG4iLCAjI2FyZ3MpCisKKyNpZmRlZiBWRVJCT1NFX09P
TV9MT0dHSU5HCisjZGVmaW5lIF9fbG9nX29vbShmaWxlLCBsaW5lKSBjb25kbG9nKDAsICJPdXQg
b2YgbWVtb3J5IGluICIgZmlsZSAiOiIgI2xpbmUpCisjZGVmaW5lIF9sb2dfb29tKGZpbGUsIGxp
bmUpIF9fbG9nX29vbShmaWxlLCBsaW5lKQorI2RlZmluZSBsb2dfb29tKCkgX2xvZ19vb20oX19G
SUxFX18sIF9fTElORV9fKQorI2Vsc2UKK3ZvaWQgbG9nX29vbSh2b2lkKTsKKyNlbmRpZgotLSAK
Mi4yOC4wCgo=
--=-uonpg43clZDklqTjNC2Y
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-uonpg43clZDklqTjNC2Y--
