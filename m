From: laurent cop <laurent.cop@gmail.com>
Subject: LUKS2 - RAID0 - NVME : alignment issue
Date: Fri, 12 Oct 2018 13:56:35 +0200
Message-ID: <CAHzw6onNd8JskiB75PzFd4Zo45dP4fx3emoHFz8eTNkTV2+7+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8739924391892789214=="
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

--===============8739924391892789214==
Content-Type: multipart/alternative; boundary="000000000000ad4094057806c98a"

--000000000000ad4094057806c98a
Content-Type: text/plain; charset="UTF-8"

Hello,

I have trouble while in top of the stack :
mkfs.ext4 /dev/mapper/raid0luks2
/dev/mapper/raid0luks2 alignement is offset by 147456 bytes
This may result in very poor performance (re-) partitioning is suggested.
I have the same pb with mkfs.xfs

I am using following scheme:

LUKS2           => created with cryptsetup -v luksFormat --type luks2
/dev/md127 --cipher aes-gcm-random --integrity aeae
RAID 0           => created with mdadm chunk=32
3 Disks *NVME* => partition with gdisk (fist sector : 2048)

I got this information with lsblk -t for each 3 disks, i got the same
information.
nvmeXn1
       -> NvmeXn1p1                                 ALIGN = 0
                  -> md127                               ALIGN = 0
                           -> raid0luks2_dif           ALIGN = 147456
                                       -> raid0luks2     ALIGN = 147456
1) How can I solve my alignment issue?
2) Is it normal to have low performances while writing with dd. I was using
LUKS previously and I got only one dev mapper. Now I got 2. Does it have a
big impact on performances?

Kind regards.

--000000000000ad4094057806c98a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdiBkaXI9Imx0ciI+PGRpdiBkaXI9Imx0ciI+PGRpdiBkaXI9Imx0
ciI+PGRpdiBkaXI9Imx0ciI+PGRpdj48ZGl2PjxkaXY+SGVsbG8sIDxicj48YnI+PC9kaXY+PGRp
dj5JIGhhdmUgdHJvdWJsZSB3aGlsZSBpbiB0b3Agb2YgdGhlIHN0YWNrIDo8YnI+bWtmcy5leHQ0
IC9kZXYvbWFwcGVyL3JhaWQwbHVrczIgPGJyPjxkaXY+L2Rldi9tYXBwZXIvcmFpZDBsdWtzMiBh
bGlnbmVtZW50IGlzIG9mZnNldCBieSAxNDc0NTYgYnl0ZXM8YnI+PC9kaXY+VGhpcyBtYXkgcmVz
dWx0IGluIHZlcnkgcG9vciBwZXJmb3JtYW5jZSAocmUtKSBwYXJ0aXRpb25pbmcgaXMgc3VnZ2Vz
dGVkLjxicj48L2Rpdj48ZGl2PkkgaGF2ZSB0aGUgc2FtZSBwYiB3aXRoIG1rZnMueGZzPGJyPjwv
ZGl2PjxkaXY+PGJyPjwvZGl2PkkgYW0gdXNpbmcgZm9sbG93aW5nIHNjaGVtZTo8L2Rpdj48ZGl2
Pjxicj48L2Rpdj5MVUtTMsKgwqDCoMKgwqDCoMKgwqDCoMKgID0mZ3Q7IGNyZWF0ZWQgd2l0aCBj
cnlwdHNldHVwIC12IGx1a3NGb3JtYXQgLS10eXBlIGx1a3MyIC9kZXYvbWQxMjcgLS1jaXBoZXIg
YWVzLWdjbS1yYW5kb20gLS1pbnRlZ3JpdHkgYWVhZTxicj48L2Rpdj48ZGl2PlJBSUQgMMKgwqDC
oMKgwqDCoMKgwqDCoMKgID0mZ3Q7IGNyZWF0ZWQgd2l0aCBtZGFkbSBjaHVuaz0zMjxicj48L2Rp
dj4zIERpc2tzIDxiPk5WTUU8L2I+ID0mZ3Q7IHBhcnRpdGlvbiB3aXRoIGdkaXNrIChmaXN0IHNl
Y3RvciA6IDIwNDgpPGJyPjxicj48L2Rpdj48ZGl2PkkgZ290IHRoaXMgaW5mb3JtYXRpb24gd2l0
aCBsc2JsayAtdCBmb3IgZWFjaCAzIGRpc2tzLCBpIGdvdCB0aGUgc2FtZSBpbmZvcm1hdGlvbi48
YnI+PC9kaXY+PGRpdj5udm1lWG4xPGJyPjwvZGl2PjxkaXY+wqDCoMKgwqDCoMKgIC0mZ3Q7IE52
bWVYbjFwMcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgQUxJR04gPSAwPC9kaXY+PGRpdj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIC0mZ3Q7IG1kMTI3wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFMSUdOID0gMDxicj48L2Rpdj48ZGl2PsKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLSZndDsgcmFp
ZDBsdWtzMl9kaWbCoMKgwqDCoMKgwqDCoMKgwqDCoCBBTElHTiA9IDE0NzQ1Njxicj48L2Rpdj48
ZGl2PsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgLSZndDsgcmFpZDBsdWtzMsKgwqDCoMKgIEFMSUdOID0g
MTQ3NDU2PGJyPjwvZGl2PjxkaXY+MSkgSG93IGNhbiBJIHNvbHZlIG15IGFsaWdubWVudCBpc3N1
ZT8gPGJyPjwvZGl2PjxkaXY+MikgSXMgaXQgbm9ybWFsIHRvIGhhdmUgbG93IHBlcmZvcm1hbmNl
cyB3aGlsZSB3cml0aW5nIHdpdGggZGQuIEkgd2FzIHVzaW5nIExVS1MgcHJldmlvdXNseSBhbmQg
SSBnb3Qgb25seSBvbmUgZGV2IG1hcHBlci4gTm93IEkgZ290IDIuIERvZXMgaXQgaGF2ZSBhIGJp
ZyBpbXBhY3Qgb24gcGVyZm9ybWFuY2VzPzxicj48YnI+PC9kaXY+PGRpdj5LaW5kIHJlZ2FyZHMu
PGJyPjwvZGl2PjwvZGl2PjwvZGl2PjwvZGl2PjwvZGl2Pg0K
--000000000000ad4094057806c98a--


--===============8739924391892789214==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8739924391892789214==--
