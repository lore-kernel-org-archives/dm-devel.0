From: Dragan Stancevic <dragan.stancevic@canonical.com>
Subject: Subject: [PATCH 1/1] multipath-tools: fix dm- device
	filtering
Date: Thu, 23 Jun 2016 16:06:24 -0500
Message-ID: <CAAZtj82kfWDjnqLYbqi==BRGukYQXCV=mTR3hmD6XOiD-C3-0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c05737e46efaa0535f86d7c
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--94eb2c05737e46efaa0535f86d7c
Content-Type: multipart/alternative; boundary=94eb2c05737e46efa60535f86d7a

--94eb2c05737e46efa60535f86d7a
Content-Type: text/plain; charset=UTF-8

Hi Christophe,

can you please take a look at the attached patch, we are seeing quite a few
cases with the following errors:

failed to get udev uid: Invalid argument
failed to get sysfs uid: Invalid argument
failed to get sgio uid: No such file or directory

It causes a lot of confusion because the devices in question are in the
blacklist but aren't getting filtered. I don't know the code well enough,
but it seems that maybe there should be no condition in the filtering and
the code should just be:
if (dev && (filter_devnode(conf->blist_devnode, conf->elist_devnode, dev) >
0)) {

But I went for smaller change option, by just allowing DEV_UEVENT to also
be filtered.

What do you think?

Thanks.

--94eb2c05737e46efa60535f86d7a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Christophe,<br><div><br></div><div>can you please take =
a look at the attached patch, we are seeing quite a few cases with the foll=
owing errors:</div><div><br></div><div><div>failed to get udev uid: Invalid=
 argument</div><div>failed to get sysfs uid: Invalid argument</div><div>fai=
led to get sgio uid: No such file or directory</div></div><div><br></div><d=
iv>It causes a lot of confusion because the devices in question are in the =
blacklist but aren&#39;t getting filtered. I don&#39;t know the code well e=
nough, but it seems that maybe there should be no condition in the filterin=
g and the code should just be:</div><div>if (dev &amp;&amp; (filter_devnode=
(conf-&gt;blist_devnode, conf-&gt;elist_devnode, dev) &gt; 0)) {<br></div><=
div><br></div><div>But I went for smaller change option, by just allowing=
=C2=A0DEV_UEVENT to also be filtered.</div><div><br></div><div>What do you =
think?</div><div><br></div><div>Thanks.</div></div>

--94eb2c05737e46efa60535f86d7a--

--94eb2c05737e46efaa0535f86d7c
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-multipath-tools-fix-dm-device-filtering.patch"
Content-Disposition: attachment;
	filename="0001-multipath-tools-fix-dm-device-filtering.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ipssfssh0

RnJvbSA3ZGNmOTgyMjIxZjFhYTYzMjI2YmFiYWVlMmM0MWQ4YjA2NTJiNmQ4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEcmFnYW4gU3RhbmNldmljIDxkcmFnYW4uc3RhbmNldmljQGNh
bm9uaWNhbC5jb20+CkRhdGU6IFRodSwgMjMgSnVuIDIwMTYgMTU6Mjk6MzcgLTA1MDAKU3ViamVj
dDogW1BBVENIIDEvMV0gbXVsdGlwYXRoLXRvb2xzOiBmaXggZG0tIGRldmljZSBmaWx0ZXJpbmcK
CkR1cmluZyAic2VydmljZSBtdWx0aXBhdGgtdG9vbHMgc3RhcnQiIC9zYmluL211bHRpcGF0aCBp
cwpjYWxsZWQgb24gZG0tIGRldmljZXMgdGhhdCBhcmUgZmlsdGVyZWQgYnV0IGR1ZSB0byBhIGNv
bmRpdGlvbgpjb25mLT5kZXZfdHlwZSA9PSBERVZfREVWTk9ERSBpbiBmaWx0ZXJpbmcgY29kZSBt
dWx0aXBhdGgKYmluYXJ5IHdhc24ndCBkcm9wcGluZyBvdXQgd2hlbiBoaXR0aW5nIGEgZG0tIGRl
dmljZS4gVGhpcwp3YXMgZHVlIHRvIHRoZSBmYWN0IHRoYXQgaW4gdGhpcyBjYXNlIGNvbmYtPmRl
dl90eXBlIGlzCnNldCB0byBERVZfVUVWRU5ULgoKVGhpcyBpcyBjYXVzaW5nIHRoZSBsb2dzIHRv
IGJlIGZpbGxlZCB3aXRoIGZvbGxvd2luZwptZXNzYWdlczoKCm11bHRpcGF0aDogZG0tNjogZmFp
bGVkIHRvIGdldCB1ZGV2IHVpZDogSW52YWxpZCBhcmd1bWVudAptdWx0aXBhdGg6IGRtLTY6IGZh
aWxlZCB0byBnZXQgc3lzZnMgdWlkOiBJbnZhbGlkIGFyZ3VtZW50Cm11bHRpcGF0aDogZG0tNjog
ZmFpbGVkIHRvIGdldCBzZ2lvIHVpZDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoKVGhpcyBj
aGFuZ2UgYWxvd3MgdGhlIGZpbHRlcmluZyB0byBoYXBwZW4uCgpDYzogQ2hyaXN0b3BoZSBWYXJv
cXVpIDxjaHJpc3RvcGhlLnZhcm9xdWlAb3BlbnN2Yy5jb20+CkNjOiBkZXZpY2UtbWFwcGVyIGRl
dmVsb3BtZW50IDxkbS1kZXZlbEByZWRoYXQuY29tPgoKU2lnbmVkLW9mZi1ieTogRHJhZ2FuIFN0
YW5jZXZpYyA8ZHJhZ2FuLnN0YW5jZXZpY0BjYW5vbmljYWwuY29tPgotLS0KIG11bHRpcGF0aC9t
YWluLmMgfCAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQoKZGlmZiAtLWdpdCBhL211bHRpcGF0aC9tYWluLmMgYi9tdWx0aXBhdGgvbWFpbi5jCmlu
ZGV4IGFhZGViZWMuLmQ4OTI5OGIgMTAwNjQ0Ci0tLSBhL211bHRpcGF0aC9tYWluLmMKKysrIGIv
bXVsdGlwYXRoL21haW4uYwpAQCAtMjY3LDcgKzI2Nyw4IEBAIGNvbmZpZ3VyZSAodm9pZCkKIAkv
KgogCSAqIGlmIHdlIGhhdmUgYSBibGFja2xpc3RlZCBkZXZpY2UgcGFyYW1ldGVyLCBleGl0IGVh
cmx5CiAJICovCi0JaWYgKGRldiAmJiBjb25mLT5kZXZfdHlwZSA9PSBERVZfREVWTk9ERSAmJgor
CWlmIChkZXYgJiYgKGNvbmYtPmRldl90eXBlID09IERFVl9ERVZOT0RFIHx8CisJCSAgICBjb25m
LT5kZXZfdHlwZSA9PSBERVZfVUVWRU5UKSAmJgogCSAgICBjb25mLT5jbWQgIT0gQ01EX1JFTU9W
RV9XV0lEICYmCiAJICAgIChmaWx0ZXJfZGV2bm9kZShjb25mLT5ibGlzdF9kZXZub2RlLAogCQkJ
ICAgIGNvbmYtPmVsaXN0X2Rldm5vZGUsIGRldikgPiAwKSkgewotLSAKMi4xLjAKCg==
--94eb2c05737e46efaa0535f86d7c
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--94eb2c05737e46efaa0535f86d7c--
