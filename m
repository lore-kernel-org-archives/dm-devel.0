From: =?UTF-8?B?T25kxZllaiBTdm9ib2Rh?= <ondrej@svobodasoft.cz>
Subject: [PATCH] multipathd: Fix for 'Read environment variables
	from systemd'
Date: Tue, 10 Dec 2013 02:41:59 +0100
Message-ID: <52A67167.2060802@svobodasoft.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

VGhlIHJldmlzaW9uICdtdWx0aXBhdGhkOiBSZWFkIGVudmlyb25tZW50IHZhcmlhYmxlcyBmcm9t
IHN5c3RlbWQnIGludHJvZHVjZWQgYSBjb21waWxhdGlvbiBlcnJvciBpbiBtdWx0aXBhdGhkL21h
aW4uYzoKCm1haW4uYzogSW4gZnVuY3Rpb24g4oCYY2hpbGTigJk6Cm1haW4uYzoxNjUxOjI6IGVy
cm9yOiDigJhlbnZw4oCZIHVuZGVjbGFyZWQgKGZpcnN0IHVzZSBpbiB0aGlzIGZ1bmN0aW9uKQog
ICBlbnZwID0gZ2V0ZW52KCJMaW1pdE5PRklMRSIpOwogICBeCgpUaGlzIHBhdGNoIGZpeGVzIGl0
IGJ5IGRlY2xhcmluZyBjaGFyICplbnZwIGZvciB0aGlzIChzZWNvbmQpIGNhc2UuCgpTaWduZWQt
b2ZmLWJ5OiBPbmTFmWVqIFN2b2JvZGEgPG9uZHJlaiBzdm9ib2Rhc29mdCBjej4KCmRpZmYgLS1n
aXQgYS9tdWx0aXBhdGhkL21haW4uYyBiL211bHRpcGF0aGQvbWFpbi5jCmluZGV4IDdjMGUzMTMu
LjJkNmFhYzggMTAwNjQ0Ci0tLSBhL211bHRpcGF0aGQvbWFpbi5jCisrKyBiL211bHRpcGF0aGQv
bWFpbi5jCkBAIC0xNjA5LDYgKzE2MDksNyBAQCBjaGlsZCAodm9pZCAqIHBhcmFtKQogICAgICBz
dHJ1Y3QgbXVsdGlwYXRoICogbXBwOwogICAgICBpbnQgaTsKICAgICAgaW50IHJjLCBwaWRfcmM7
CisgICAgY2hhciAqZW52cDsKICAKCiAgICAgIG1sb2NrYWxsKE1DTF9DVVJSRU5UIHwgTUNMX0ZV
VFVSRSk7CiAgICAgIHNlbV9pbml0KCZleGl0X3NlbSwgMCwgMCk7CgotLQpkbS1kZXZlbCBtYWls
aW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=
