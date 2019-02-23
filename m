From: Kurt Garloff <kurt@garloff.de>
Subject: bug: dmsetup fails to parse concise tables
Date: Sat, 23 Feb 2019 22:56:59 +0100
Message-ID: <0b154688-762c-b6ac-2925-4ee8a19962a2@garloff.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------C0AF673486902DD0A7BD9402"
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------C0AF673486902DD0A7BD9402
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

if I store device-mapper tables with dmsetup table --concise, I would
expect that dmsetup create --concise would be able to parse the tables.

dmsetup however fails this with a simple three-entry table like this one:=


joined,77f15d24-943c-4dff-91e2-e43a4b0d9a23,1,rw,0 8 linear 7:1 0,8 8
linear 7:2 0,16 8 linear 7:3 0

A full test case to be added to the test/shell/ directory is attached.

PS: I'm not on the list, please copy me on responses.

--=20
Kurt Garloff <kurt@garloff.de>
Cologne, Germany


--------------C0AF673486902DD0A7BD9402
Content-Type: application/x-shellscript;
 name="dmsetup-concise.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmsetup-concise.sh"

IyEvdXNyL2Jpbi9lbnYgYmFzaAoKIyBDb3B5cmlnaHQgKEMpIDIwMTkgS3VydCBHYXJsb2Zm
IDxrdXJ0QGdhcmxvZmYuZGU+CiMKIyBUaGlzIGNvcHlyaWdodGVkIG1hdGVyaWFsIGlzIG1h
ZGUgYXZhaWxhYmxlIHRvIGFueW9uZSB3aXNoaW5nIHRvIHVzZSwKIyBtb2RpZnksIGNvcHks
IG9yIHJlZGlzdHJpYnV0ZSBpdCBzdWJqZWN0IHRvIHRoZSB0ZXJtcyBhbmQgY29uZGl0aW9u
cwojIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSB2LjIuCiMKIyBZb3Ugc2hv
dWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGlj
ZW5zZQojIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRvIHRoZSBG
cmVlIFNvZnR3YXJlIEZvdW5kYXRpb24sCiMgSW5jLiwgNTEgRnJhbmtsaW4gU3RyZWV0LCBG
aWZ0aCBGbG9vciwgQm9zdG9uLCBNQSAwMjExMC0xMzAxIFVTQQoKIyB1bnJlbGF0ZWQgdG8g
bHZtMiBkYWVtb25zCgouIGxpYi9pbml0dGVzdAoKI2F1eCB0YXJnZXRfYXRfbGVhc3QgZG0t
bGluZWFyIDEgMCAwIHx8IHNraXAgIm1pc3NpbmcgZG0tbGluZWFyIHRhcmdldCIKCmZ1bmN0
aW9uIF90ZWFyZG93bigpIHsKCWF1eCB0ZWFyZG93bl9kZXZzX3ByZWZpeGVkICIkUFJFRklY
IgoJbG9zZXR1cCAtZCAvZGV2L2xvb3BbNjc4XSB8fCB0cnVlCglybSAtZiBsb2ZpbGVbNjc4
XSBkbXRibC1jb25jaXNlIGRtdGJsLWNvbmNpc2UyCn0KCnRyYXAgJ190ZWFyZG93bicgRVhJ
VAoKZGQgaWY9L2Rldi96ZXJvIG9mPWxvZmlsZTYgYnM9NDA5NiBjb3VudD0xCmRkIGlmPS9k
ZXYvemVybyBvZj1sb2ZpbGU3IGJzPTQwOTYgY291bnQ9MQpkZCBpZj0vZGV2L3plcm8gb2Y9
bG9maWxlOCBicz00MDk2IGNvdW50PTEKbG9zZXR1cCAvZGV2L2xvb3A2IGxvZmlsZTYKbG9z
ZXR1cCAvZGV2L2xvb3A3IGxvZmlsZTcKbG9zZXR1cCAvZGV2L2xvb3A4IGxvZmlsZTgKCiMg
Q3JlYXRlIDMgZW50cnkgbGluZWFyIG1hcHBpbmcKZWNobyAtZSAiMCA4IGxpbmVhciAvZGV2
L2xvb3A2IDBcbjggOCBsaW5lYXIgL2Rldi9sb29wNyAwXG4gMTYgOCBsaW5lYXIgL2Rldi9s
b29wOCAwIiB8IGRtc2V0dXAgY3JlYXRlICIkUFJFRklYLWxpbmVhciIgLXUgYHV1aWRnZW5g
CiMgU2F2ZSBpbnRvIGNvbmNpc2UgdGFibGUKZG1zZXR1cCB0YWJsZSAtLWNvbmNpc2UgIiRQ
UkVGSVgtbGluZWFyIiA+IGRtdGJsLWNvbmNpc2UKIyBSZW1vdmUgbWFwcGluZwpkbXNldHVw
IHJlbW92ZSAiJFBSRUZJWC1saW5lYXIiCiMgUmVjcmVhdGUgZnJvbSBjb25jaXNlIHRhYmxl
CmRtc2V0dXAgY3JlYXRlIC0tY29uY2lzZSA8IGRtdGJsLWNvbmNpc2UKIyBPdXRwdXQgdGFi
bGUgYWdhaW4KZG1zZXR1cCB0YWJsZSAtLWNvbmNpc2UgIiRQUkVGSVgtbGluZWFyIiA+IGRt
dGJsLWNvbmNpc2UyCiMgQ29tcGFyZQpjbXAgZG10YmwtY29uY2lzZSBkbXRibC1jb25jaXNl
MgoKIyBDbGVhbnVwCiNkbXNldHVwIHJlbW92ZSAiJFBSRUZJWC1saW5lYXIiCl90ZWFyZG93
bgoK
--------------C0AF673486902DD0A7BD9402
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------C0AF673486902DD0A7BD9402--
