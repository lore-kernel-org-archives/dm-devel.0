From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/1] libmultipath: dm_is_mpath cleanup
Date: Tue, 08 Jan 2019 12:26:18 +0100
Message-ID: <68f71e4dca6765e74e113b813ef1ffa0fdabf8da.camel@suse.com>
References: <1544563384-9721-1-git-send-email-bmarzins@redhat.com>
	<1544563384-9721-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1544563384-9721-2-git-send-email-bmarzins@redhat.com>
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

SGkgQ2hyaXN0b3BoZSwKCnlvdSBtaXNzZWQgdGhlIHBhdGNoIGJlbG93IGluIHlvdXIgbGFzdCBt
ZXJnZS4KClRoYW5rcywKTWFydGluCgpPbiBUdWUsIDIwMTgtMTItMTEgYXQgMTU6MjMgLTA2MDAs
ICBCZW5qYW1pbiBNYXJ6aW5za2kgIHdyb3RlOgo+IEFkZCBjb25kbG9nKCkgbWVzc2FnZSBpbiBk
bV9pc19tcGF0aCgpIGZhaWxzIGFuZCBjaGFuZ2UgdGhlCj4gZG1faXNfbXBhdGgoKSBjYWxsIGlu
IHdhdGNoX2RtZXZlbnRzKCkgdG8gY2hlY2sgdGhlIHJldHVybiB2YWx1ZSB3aXRoCj4gdGhlIHNh
bWUgc3ludGF4IGFzIGFsbCB0aGUgb3RoZXIgY2FsbGVycy4KPiAKPiBGaXhlczogOTA1MGNkNWEg
ImxpYm11bHRpcGF0aDogZml4IGZhbHNlIHJlbW92ZXMgaW4gZG1ldmVudHMgcG9sbGluZwo+IGNv
ZGUiCj4gUmV2aWV3ZWQtYnk6IE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPgo+IFNpZ25l
ZC1vZmYtYnk6IEJlbmphbWluIE1hcnppbnNraSA8Ym1hcnppbnNAcmVkaGF0LmNvbT4KPiAtLS0K
PiAgbGlibXVsdGlwYXRoL2Rldm1hcHBlci5jIHwgMjEgKysrKysrKysrKysrLS0tLS0tLS0tCj4g
IG11bHRpcGF0aGQvZG1ldmVudHMuYyAgICB8ICA0ICsrKy0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAx
NSBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8
bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBH
bWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9u
CkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbA==
