From: Xinwei Hu <hxinwei@gmail.com>
Subject: Segment fault in datastruct/hash.c
Date: Wed, 28 Oct 2009 11:52:52 +0800
Message-ID: <1cafab770910272052v4a9ec931v893b4925dd0e2e12@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163649a6f3a698e20476f6ba92
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

--00163649a6f3a698e20476f6ba92
Content-Type: text/plain; charset=UTF-8

Hi all,

  Found by Anders Johansson <ajohansson@novell.com>, vgscan may
segment in datastruct/hash.c at
memcmp(key, (*c)->key, len). It happens because the (*c)->key is much
shorter than the key, and the
memory area following (*c)->key is unaccessable at the time.

(gdb) p (*c)->key
$1 = 0x80229fb4 "/dev/disk/by-id/ccw-LXD332"
(gdb) x/80cb 0x80229fb4
0x80229fb4:	47 '/'	100 'd'	101 'e'	118 'v'	47 '/'	100 'd'	105 'i'	115 's'
0x80229fbc:	107 'k'	47 '/'	98 'b'	121 'y'	45 '-'	105 'i'	100 'd'	47 '/'
0x80229fc4:	99 'c'	99 'c'	119 'w'	45 '-'	76 'L'	88 'X'	68 'D'	51 '3'
0x80229fcc:	51 '3'	50 '2'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'
0x80229fd4:	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'
0x80229fdc:	0 '\0'	0 '\0'	0 '\0'	49 '1'	0 '\0'	0 '\0'	0 '\0'	0 '\0'
0x80229fe4:	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'
0x80229fec:	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'
0x80229ff4:	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'	0 '\0'
0x80229ffc:	0 '\0'	0 '\0'	0 '\0'	0 '\0'	Cannot access memory at
address 0x8022a000

  I generate a patch against the latest git tree. Please consider it
for inclusion.

  Thanks.

--00163649a6f3a698e20476f6ba92
Content-Type: text/x-patch; charset=US-ASCII; name="hash.diff"
Content-Disposition: attachment; filename="hash.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g1bjw1x40

ZGlmZiAtLWdpdCBhL2xpYmRtL2RhdGFzdHJ1Y3QvaGFzaC5jIGIvbGliZG0vZGF0YXN0cnVjdC9o
YXNoLmMKaW5kZXggOWY4ZWZmNi4uMTZkODg5NiAxMDA2NDQKLS0tIGEvbGliZG0vZGF0YXN0cnVj
dC9oYXNoLmMKKysrIGIvbGliZG0vZGF0YXN0cnVjdC9oYXNoLmMKQEAgLTE0Myw5ICsxNDMsMTMg
QEAgc3RhdGljIHN0cnVjdCBkbV9oYXNoX25vZGUgKipfZmluZChzdHJ1Y3QgZG1faGFzaF90YWJs
ZSAqdCwgY29uc3QgY2hhciAqa2V5LAogCXVuc2lnbmVkIGggPSBfaGFzaChrZXksIGxlbikgJiAo
dC0+bnVtX3Nsb3RzIC0gMSk7CiAJc3RydWN0IGRtX2hhc2hfbm9kZSAqKmM7CiAKLQlmb3IgKGMg
PSAmdC0+c2xvdHNbaF07ICpjOyBjID0gJigoKmMpLT5uZXh0KSkKKwlmb3IgKGMgPSAmdC0+c2xv
dHNbaF07ICpjOyBjID0gJigoKmMpLT5uZXh0KSkgeworCQlpZiAoKCpjKS0+a2V5bGVuICE9IGxl
bikKKwkJCWNvbnRpbnVlCisKIAkJaWYgKCFtZW1jbXAoa2V5LCAoKmMpLT5rZXksIGxlbikpCiAJ
CQlicmVhazsKKwl9CiAKIAlyZXR1cm4gYzsKIH0K
--00163649a6f3a698e20476f6ba92
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--00163649a6f3a698e20476f6ba92--
