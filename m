From: Xinwei Hu <hxinwei@gmail.com>
Subject: Fix typo in libdm/ioctl/libdm-iface.c
Date: Wed, 23 Jun 2010 20:21:44 +0800
Message-ID: <AANLkTimZh5WD3Y0IWU2Ne8KLoonpe1EaV38mrNNCHXDd@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00c09f8998d7c702910489b19468
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--00c09f8998d7c702910489b19468
Content-Type: text/plain; charset=UTF-8

Hi all,

  Think this is a obvious typo in libdm/ioctl/libdm-iface.c.

  "INTERNAL ERROR" -> "INTERNAL_ERROR".

  Fix attached. Please comment.

  Thanks.

--00c09f8998d7c702910489b19468
Content-Type: application/octet-stream; name="lvm-fix-typo.diff"
Content-Disposition: attachment; filename="lvm-fix-typo.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gas4u4hz0

Y29tbWl0IDY2YmRmN2I5M2RmOGNkMWU4MTBmZWMyZDRmNGVkZWIxNmYyNzQ4NGIKQXV0aG9yOiBY
aW53ZWkgSHUgPHh3aHVAbm92ZWxsLmNvbT4KRGF0ZTogICBXZWQgSnVuIDIzIDIwOjE4OjA3IDIw
MTAgKzA4MDAKCiAgICBGaXggdHlwbzogIklOVEVSTkFMIEVSUk9SIiAtPiAiSU5URVJOQUxfRVJS
T1IiCgpkaWZmIC0tZ2l0IGEvbGliZG0vaW9jdGwvbGliZG0taWZhY2UuYyBiL2xpYmRtL2lvY3Rs
L2xpYmRtLWlmYWNlLmMKaW5kZXggZWQyMTFmOC4uNWY3MTA5OCAxMDA2NDQKLS0tIGEvbGliZG0v
aW9jdGwvbGliZG0taWZhY2UuYworKysgYi9saWJkbS9pb2N0bC9saWJkbS1pZmFjZS5jCkBAIC03
NzcsNyArNzc3LDcgQEAgc3RhdGljIGludCBfZG1fdGFza19ydW5fdjEoc3RydWN0IGRtX3Rhc2sg
KmRtdCkKIAogCWlmICgodW5zaWduZWQpIGRtdC0+dHlwZSA+PQogCSAgICAoc2l6ZW9mKF9jbWRf
ZGF0YV92MSkgLyBzaXplb2YoKl9jbWRfZGF0YV92MSkpKSB7Ci0JCWxvZ19lcnJvcihJTlRFUk5B
TCBFUlJPUiAidW5rbm93biBkZXZpY2UtbWFwcGVyIHRhc2sgJWQiLAorCQlsb2dfZXJyb3IoSU5U
RVJOQUxfRVJST1IgInVua25vd24gZGV2aWNlLW1hcHBlciB0YXNrICVkIiwKIAkJCSAgZG10LT50
eXBlKTsKIAkJZ290byBiYWQ7CiAJfQo=
--00c09f8998d7c702910489b19468
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--00c09f8998d7c702910489b19468--
