From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 4/9] multipathd: don't call strlen on NULL
 variables
Date: Thu, 13 Apr 2017 16:12:43 +0200
Message-ID: <1492092763.22602.0.camel@suse.de>
References: <1491545798-22183-1-git-send-email-bmarzins@redhat.com>
	<1491545798-22183-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1491545798-22183-5-git-send-email-bmarzins@redhat.com>
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

T24gRnJpLCAyMDE3LTA0LTA3IGF0IDAxOjE2IC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gc3RybGVuIGhhcyB1bmRlZmluZWQgcmVzdWx0cyB3aGVuIHBhc3NlZCBhIE5VTEwgdmFy
aWFibGUsIHNvIGRvbid0IGRvCj4gaXQuCj4gCj4gU2lnbmVkLW9mZi1ieTogQmVuamFtaW4gTWFy
emluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+IC0tLQoKVGhpcyBpcyBjZXJ0YWlubHkgY29y
cmVjdC4gWWV0IEkgaGF2ZSB0d28gcmVtYXJrczrCoAoKMSkgVGhlcmUgYXJlIG1hbnkgbW9yZSBj
YWxscyB0byBzdHJsZW4oKSBpbiB0aGUgbXVsdGlwYXRoLXRvb2xzIGNvZGUKd2hpY2ggd291bGQg
bmVlZCB0byBiZSBsaWtld2lzZSBwcm90ZWN0ZWQuCgoyKSBJZiBTVFJEVVAoIm9rXG4iKSByZXR1
cm5zIE5VTEwsIHdlJ3JlIGxpa2VseSB0byBiZSBzbyBob3NlZCB0aGF0IHdlCm1pZ2h0IGFzIHdl
bGwgY2FsbCBhYm9ydCgpIGFueXdheSAod2hpY2ggaXMgYSBwaGlsb3NvcGh5IHRoYXQgSQpwZXJz
b25hbGx5IHF1aXRlIGxpa2UgLSBtdWx0aXBhdGhkIGlzIG5vdCBzdWNoIGEgdml0YWwgcGFydCBv
ZiB0aGUKc3lzdGVtIHRoYXQgaXQgY2FuJ3QgcmlzayBkeWluZykuCgpSZWdhcmRzCk1hcnRpbgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cu
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
