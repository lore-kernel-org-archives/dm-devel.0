From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] libmultipath: simplify failed wwid code
Date: Fri, 8 May 2020 09:15:32 +0000
Message-ID: <55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986.camel@suse.com>
References: <1588372766-21317-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986camelsusecom_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1588372766-21317-1-git-send-email-bmarzins@redhat.com>
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
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--_002_55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986camelsusecom_
Content-Type: text/plain; charset=ISO-8859-15
Content-ID: <7D09121A6E76E548BA8A587202C4C8A2@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-05-01 at 17:39 -0500, Benjamin Marzinski wrote:
> The (is|mark|unmark)_failed_wwid code is needlessly complicated.
> Locking a file is necssary if multiple processes could otherwise be
> writing to it at the same time. That is not the case with the
> failed_wwids files. They can simply be empty files in a
> directory.  Even
> with all the locking in place, two processes accessing or modifying a
> file at the same time will still race. And even without the locking,
> if
> two processes try to access or modify a file at the same time, they
> will
> both see a reasonable result, and will leave the files in a valid
> state
> afterwards.
>=20
> Instead of doing all the locking work (which made it necessary to
> write
> a file, even just to check if a file existed), simply check for files
> with lstat(), create them with open(), and remove them with unlink().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/wwids.c | 131 ++++++++++++++++++-----------------------
> --
>  1 file changed, 56 insertions(+), 75 deletions(-)

I agree, almost :-)

Please consider adding the attached patch on top, which switches back
to atomic creation of the failed_wwids file, with just a little bit
more compexity. I prefer the creation of the file to be atomic on the
file system level. IMO that's how "flag" files like this should be
handled in principle, and doing it correctly makes me feel better, even
though I have to concur that an actual race is hardly possible.

Regards,
Martin


--_002_55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986camelsusecom_
Content-Type: text/x-patch;
	name="0001-libmultipath-use-atomic-linkat-in-mark_failed_wwid.patch"
Content-Description: 0001-libmultipath-use-atomic-linkat-in-mark_failed_wwid.patch
Content-Disposition: attachment;
	filename="0001-libmultipath-use-atomic-linkat-in-mark_failed_wwid.patch";
	size=2840; creation-date="Fri, 08 May 2020 09:15:32 GMT";
	modification-date="Fri, 08 May 2020 09:15:32 GMT"
Content-ID: <81B85FF2FFFB4B47A76B0C9E39F22AFF@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSBkMGU0NjY5YzkyODYzZjk4Y2RiZTdiNDFhOGE5YjY0MjIzOTU4YmVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
RnJpLCA4IE1heSAyMDIwIDAwOjUxOjUwICswMjAwClN1YmplY3Q6IFtQQVRDSF0gbGlibXVsdGlw
YXRoOiB1c2UgYXRvbWljIGxpbmthdCgpIGluIG1hcmtfZmFpbGVkX3d3aWQoKQoKVGhpcyBrZWVw
cyAoYWxtb3N0KSB0aGUgc2ltcGxpY2l0eSBvZiB0aGUgcHJldmlvdXMgcGF0Y2gsIHdoaWxlCm1h
a2luZyBzdXJlIHRoYXQgdGhlIHJldHVybiB2YWx1ZSBvZiBtYXJrX2ZhaWxlZF93d2lkKCkKKFdX
SURfRkFJTEVEX0NIQU5HRUQgdnMuIFdXSURfRkFJTEVEX1VOQ0hBTkdFRCkgaXMgY29ycmVjdCwg
ZXZlbgppZiBzZXZlcmFsIHByb2Nlc3NlcyBhY2Nlc3MgdGhpcyBXV0lEIGF0IHRoZSBzYW1lIHRp
bWUuCgpTaWduZWQtb2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KLS0tCiBs
aWJtdWx0aXBhdGgvd3dpZHMuYyB8IDQyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC93d2lkcy5jIGIvbGlibXVsdGlwYXRoL3d3
aWRzLmMKaW5kZXggYjE1YjE0NmIuLmNjZGQxM2QyIDEwMDY0NAotLS0gYS9saWJtdWx0aXBhdGgv
d3dpZHMuYworKysgYi9saWJtdWx0aXBhdGgvd3dpZHMuYwpAQCAtMzc0LDcgKzM3NCw3IEBAIGlu
dCBpc19mYWlsZWRfd3dpZChjb25zdCBjaGFyICp3d2lkKQogCiAJaWYgKHNhZmVfc3ByaW50Zihw
YXRoLCAiJXMvJXMiLCBzaG1fZGlyLCB3d2lkKSkgewogCQljb25kbG9nKDEsICIlczogcGF0aCBu
YW1lIG92ZXJmbG93IiwgX19mdW5jX18pOwotCQlyZXR1cm4gLTE7CisJCXJldHVybiBXV0lEX0ZB
SUxFRF9FUlJPUjsKIAl9CiAKIAlpZiAobHN0YXQocGF0aCwgJnN0KSA9PSAwKQpAQCAtMzkwLDI3
ICszOTAsNDMgQEAgaW50IGlzX2ZhaWxlZF93d2lkKGNvbnN0IGNoYXIgKnd3aWQpCiAKIGludCBt
YXJrX2ZhaWxlZF93d2lkKGNvbnN0IGNoYXIgKnd3aWQpCiB7Ci0JY2hhciBwYXRoW1BBVEhfTUFY
XTsKLQlpbnQgciwgZmQ7CisJY2hhciB0bXBmaWxlW1dXSURfU0laRSArIDIgKiBzaXplb2YobG9u
ZykgKyAxXTsKKwlpbnQgciA9IFdXSURfRkFJTEVEX0VSUk9SLCBmZCwgZGZkOwogCi0JaWYgKHNh
ZmVfc3ByaW50ZihwYXRoLCAiJXMvJXMiLCBzaG1fZGlyLCB3d2lkKSkgewotCQljb25kbG9nKDEs
ICIlczogcGF0aCBuYW1lIG92ZXJmbG93IiwgX19mdW5jX18pOwotCQlyZXR1cm4gLTE7CisJZGZk
ID0gb3BlbihzaG1fZGlyLCBPX1JET05MWXxPX0RJUkVDVE9SWSk7CisJaWYgKGRmZCA9PSAtMSAm
JiBlcnJubyA9PSBFTk9FTlQpIHsKKwkJY2hhciBwYXRoW3NpemVvZihzaG1fZGlyKSArIDJdOwor
CisJCS8qIGFyZyBmb3IgZW5zdXJlX2RpcmVjdG9yaWVzX2V4aXN0KCkgbXVzdCBub3QgZW5kIHdp
dGggIi8iICovCisJCXNhZmVfc3ByaW50ZihwYXRoLCAiJXMvXyIsIHNobV9kaXIpOworCQllbnN1
cmVfZGlyZWN0b3JpZXNfZXhpc3QocGF0aCwgMDcwMCk7CisJCWRmZCA9IG9wZW4oc2htX2Rpciwg
T19SRE9OTFl8T19ESVJFQ1RPUlkpOwogCX0KLQlpZiAoZW5zdXJlX2RpcmVjdG9yaWVzX2V4aXN0
KHBhdGgsIDA3MDApIDwgMCkgewotCQljb25kbG9nKDEsICIlczogY2FuJ3Qgc2V0dXAgZGlyZWN0
b3JpZXMiLCBfX2Z1bmNfXyk7Ci0JCXJldHVybiAtMTsKKwlpZiAoZGZkID09IC0xKSB7CisJCWNv
bmRsb2coMSwgIiVzOiBjYW4ndCBzZXR1cCAlczogJW0iLCBfX2Z1bmNfXywgc2htX2Rpcik7CisJ
CXJldHVybiBXV0lEX0ZBSUxFRF9FUlJPUjsKIAl9CiAKLQlmZCA9IG9wZW4ocGF0aCwgT19SRE9O
TFkgfCBPX0NSRUFUIHwgT19FWENMLCBTX0lSVVNSKTsKLQlpZiAoZmQgPj0gMCkgeworCXNhZmVf
c3ByaW50Zih0bXBmaWxlLCAiJXMuJWx4Iiwgd3dpZCwgKGxvbmcpZ2V0cGlkKCkpOworCWZkID0g
b3BlbmF0KGRmZCwgdG1wZmlsZSwgT19SRE9OTFkgfCBPX0NSRUFUIHwgT19FWENMLCBTX0lSVVNS
KTsKKwlpZiAoZmQgPj0gMCkKIAkJY2xvc2UoZmQpOworCWVsc2UKKwkJZ290byBvdXRfY2xvc2Vk
aXI7CisKKwlpZiAobGlua2F0KGRmZCwgdG1wZmlsZSwgZGZkLCB3d2lkLCAwKSA9PSAwKQogCQly
ID0gV1dJRF9GQUlMRURfQ0hBTkdFRDsKLQl9IGVsc2UgaWYgKGVycm5vID09IEVFWElTVCkKKwll
bHNlIGlmIChlcnJubyA9PSBFRVhJU1QpCiAJCXIgPSBXV0lEX0ZBSUxFRF9VTkNIQU5HRUQ7CiAJ
ZWxzZQogCQlyID0gV1dJRF9GQUlMRURfRVJST1I7CiAKKwlpZiAodW5saW5rYXQoZGZkLCB0bXBm
aWxlLCAwKSA9PSAtMSkKKwkJY29uZGxvZygyLCAiJXM6IGZhaWxlZCB0byB1bmxpbmsgJXMvJXM6
ICVtIiwKKwkJCV9fZnVuY19fLCBzaG1fZGlyLCB0bXBmaWxlKTsKKworb3V0X2Nsb3NlZGlyOgor
CWNsb3NlKGRmZCk7CiAJcHJpbnRfZmFpbGVkX3d3aWRfcmVzdWx0KCJtYXJrX2ZhaWxlZCIsIHd3
aWQsIHIpOwogCXJldHVybiByOwogfQpAQCAtNDIyLDcgKzQzOCw3IEBAIGludCB1bm1hcmtfZmFp
bGVkX3d3aWQoY29uc3QgY2hhciAqd3dpZCkKIAogCWlmIChzYWZlX3NwcmludGYocGF0aCwgIiVz
LyVzIiwgc2htX2Rpciwgd3dpZCkpIHsKIAkJY29uZGxvZygxLCAiJXM6IHBhdGggbmFtZSBvdmVy
ZmxvdyIsIF9fZnVuY19fKTsKLQkJcmV0dXJuIC0xOworCQlyZXR1cm4gV1dJRF9GQUlMRURfRVJS
T1I7CiAJfQogCiAJaWYgKHVubGluayhwYXRoKSA9PSAwKQotLSAKMi4yNi4yCgo=
--_002_55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986camelsusecom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_55e6cd5b0826a0393bbd2cd15e3cf9f31f8f0986camelsusecom_--
