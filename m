From: amit mehta <gmate.amit@gmail.com>
Subject: Query: Significance of libmultipath/hwtable.c
Date: Wed, 12 Jun 2013 11:45:56 +0530
Message-ID: <CAOUxTKPCj_k9JaAwS9w6zg56mzA+HGQOV_6aw8HzHRU_GpXj-g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6935936343420094128=="
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

--===============6935936343420094128==
Content-Type: multipart/alternative; boundary=089e01293fe260332304deeef2b3

--089e01293fe260332304deeef2b3
Content-Type: text/plain; charset=UTF-8

What is the significance of libmultipath/hwtable.c file. I see there
is a list of vendors mentioned over here.

<snip>
grep -i vendor libmultipath/hwtable.c|uniq
        .vendor        = "COMPELNT",
        .vendor        = "APPLE*",
        .vendor        = "3PARdata",
        .vendor        = "DEC",
        .vendor        = "HP",
        .vendor        = "(COMPAQ|HP)",
        .vendor        = "HP",
        .vendor        = "DDN",
        .vendor        = "EMC",
        .vendor        = "DGC",
        .vendor        = "EMC",
        .vendor        = "FSC",
        .vendor        = "FUJITSU",
        .vendor        = "HITACHI",
        .vendor        = "IBM",
        .vendor        = "IBM",
        .vendor        = "AIX",
        .vendor        = "IBM",
        .vendor        = "AIX",
        .vendor        = "IBM",
        .vendor        = "AIX",
        .vendor        = "DELL",
        .vendor        = "NETAPP",
        .vendor        = "IBM",
        .vendor        = "Pillar",
        .vendor        = "SGI",
        .vendor        = "STK",
        .vendor        = "SUN",
        .vendor        = "PIVOT3",
        .vendor        = "SUN",
        .vendor        = "(LSI|ENGENIO)",
        .vendor        = "STK",
        .vendor        = "EUROLOGC",
        .vendor        = "NEC",
        .vendor        = NULL,
<snip>

Under each of these vendors, there is a list of products from the same
vendor as well. So does that mean, if the vendor and or product is not
mentioned in this file, that particular storage hardware may not be
supported by dm-multipath?

-Amit

--089e01293fe260332304deeef2b3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdj48ZGl2PldoYXQgaXMgdGhlIHNpZ25pZmljYW5jZSBvZiBsaWJt
dWx0aXBhdGgvaHd0YWJsZS5jIGZpbGUuIEkgc2VlIHRoZXJlPGJyPmlzIGEgbGlzdCBvZiB2ZW5k
b3JzIG1lbnRpb25lZCBvdmVyIGhlcmUuPGJyPjxicj4mbHQ7c25pcCZndDs8YnI+PC9kaXY+Z3Jl
cCAtaSB2ZW5kb3IgbGlibXVsdGlwYXRoL2h3dGFibGUuY3x1bmlxPGJyPsKgwqDCoCDCoMKgwqAg
LnZlbmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1b3Q7Q09NUEVMTlQmcXVvdDssPGJyPg0KwqDCoMKg
IMKgwqDCoCAudmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAmcXVvdDtBUFBMRSomcXVvdDssPGJyPsKg
wqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1b3Q7M1BBUmRhdGEmcXVvdDss
PGJyPsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1b3Q7REVDJnF1b3Q7
LDxicj7CoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90O0hQJnF1b3Q7
LDxicj7CoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90OyhDT01QQVF8
SFApJnF1b3Q7LDxicj4NCsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1
b3Q7SFAmcXVvdDssPGJyPsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1
b3Q7REROJnF1b3Q7LDxicj7CoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZx
dW90O0VNQyZxdW90Oyw8YnI+wqDCoMKgIMKgwqDCoCAudmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAm
cXVvdDtER0MmcXVvdDssPGJyPsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKgID0g
JnF1b3Q7RU1DJnF1b3Q7LDxicj4NCsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKg
ID0gJnF1b3Q7RlNDJnF1b3Q7LDxicj7CoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDC
oCA9ICZxdW90O0ZVSklUU1UmcXVvdDssPGJyPsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKg
wqDCoMKgID0gJnF1b3Q7SElUQUNISSZxdW90Oyw8YnI+wqDCoMKgIMKgwqDCoCAudmVuZG9ywqDC
oMKgwqDCoMKgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPsKgwqDCoMKgwqDCoMKgIC52ZW5kb3LC
oMKgwqDCoMKgwqDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+DQrCoMKgwqAgwqDCoMKgIC52ZW5k
b3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90O0FJWCZxdW90Oyw8YnI+wqDCoMKgIMKgwqDCoCAudmVu
ZG9ywqDCoMKgwqDCoMKgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPsKgwqDCoCDCoMKgwqAgLnZl
bmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1b3Q7QUlYJnF1b3Q7LDxicj7CoMKgwqAgwqDCoMKgIC52
ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90O0lCTSZxdW90Oyw8YnI+wqDCoMKgIMKgwqDCoCAu
dmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAmcXVvdDtBSVgmcXVvdDssPGJyPg0KwqDCoMKgIMKgwqDC
oCAudmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAmcXVvdDtERUxMJnF1b3Q7LDxicj7CoMKgwqAgwqDC
oMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90O05FVEFQUCZxdW90Oyw8YnI+wqDCoMKg
IMKgwqDCoCAudmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAmcXVvdDtJQk0mcXVvdDssPGJyPsKgwqDC
oCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1b3Q7UGlsbGFyJnF1b3Q7LDxicj7C
oMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90O1NHSSZxdW90Oyw8YnI+
DQrCoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90O1NUSyZxdW90Oyw8
YnI+wqDCoMKgIMKgwqDCoCAudmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAmcXVvdDtTVU4mcXVvdDss
PGJyPsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKgID0gJnF1b3Q7UElWT1QzJnF1
b3Q7LDxicj7CoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDCoCA9ICZxdW90O1NVTiZx
dW90Oyw8YnI+wqDCoMKgIMKgwqDCoCAudmVuZG9ywqDCoMKgwqDCoMKgwqAgPSAmcXVvdDsoTFNJ
fEVOR0VOSU8pJnF1b3Q7LDxicj4NCsKgwqDCoCDCoMKgwqAgLnZlbmRvcsKgwqDCoMKgwqDCoMKg
ID0gJnF1b3Q7U1RLJnF1b3Q7LDxicj7CoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDCoMKgwqDC
oCA9ICZxdW90O0VVUk9MT0dDJnF1b3Q7LDxicj7CoMKgwqAgwqDCoMKgIC52ZW5kb3LCoMKgwqDC
oMKgwqDCoCA9ICZxdW90O05FQyZxdW90Oyw8YnI+wqDCoMKgIMKgwqDCoCAudmVuZG9ywqDCoMKg
wqDCoMKgwqAgPSBOVUxMLDxicj48L2Rpdj4mbHQ7c25pcCZndDs8YnI+PGRpdj48ZGl2Pjxicj48
L2Rpdj48ZGl2Pg0KVW5kZXIgZWFjaCBvZiB0aGVzZSB2ZW5kb3JzLCB0aGVyZSBpcyBhIGxpc3Qg
b2YgcHJvZHVjdHMgZnJvbSB0aGUgc2FtZTxicj52ZW5kb3IgYXMgd2VsbC4gU28gZG9lcyB0aGF0
IG1lYW4sIGlmIHRoZSB2ZW5kb3IgYW5kIG9yIHByb2R1Y3QgaXMgbm90IDxicj5tZW50aW9uZWQg
aW4gdGhpcyBmaWxlLCB0aGF0IHBhcnRpY3VsYXIgc3RvcmFnZSBoYXJkd2FyZSBtYXkgbm90IGJl
IDxicj4NCnN1cHBvcnRlZCBieSBkbS1tdWx0aXBhdGg/PGJyPjxicj48L2Rpdj48ZGl2Pi1BbWl0
PGJyPjwvZGl2PjwvZGl2PjwvZGl2Pg0K
--089e01293fe260332304deeef2b3--


--===============6935936343420094128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6935936343420094128==--
