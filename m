From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/12] multipathd: move recovery mode code to
	function
Date: Thu, 07 Dec 2017 23:13:28 +0100
Message-ID: <1512684808.22250.7.camel@suse.com>
References: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
	<1512672546-12785-10-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1512672546-12785-10-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

T24gVGh1LCAyMDE3LTEyLTA3IGF0IDEyOjQ5IC0wNjAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gSW5zdGVhZCBvZiBoYXZpbmcgbXVsdGlwbGUgZnVuY3Rpb25zIGFsbCBydW5uaW5nIHNs
aWdodGx5IGRpZmZlcmVudAo+IGNvZGUgdG8gbW92ZSBhIG11bHRpcGF0aCBkZXZpY2UgdG8gcmVj
b3ZlcnkgbW9kZSwgdGhlcmUgaXMgbm93Cj4gYW4gZW50ZXJfcmVjb3ZlcnlfbW9kZSgpIGZ1bmN0
aW9uIHRoYXQgYWxsIG9mIHRoZW0gY2FsbC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBN
YXJ6aW5za2kgPGJtYXJ6aW5zQHJlZGhhdC5jb20+Cj4gLS0tCgpSZXZpZXdlZC1ieTogTWFydGlu
IFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+CgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1
c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjog
RmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4
NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
