From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/2] libmultipath: free allocated value in
 set_int
Date: Thu, 11 Oct 2018 23:46:39 +0200
Message-ID: <d79c37d6d65a421bd3fbab9b9a22ba575eea293d.camel@suse.com>
References: <1539290628-16948-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539290628-16948-1-git-send-email-bmarzins@redhat.com>
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

T24gVGh1LCAyMDE4LTEwLTExIGF0IDE1OjQzIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6Cj4gc2V0X2ludCgpIG5lZWRzIHRvIGZyZWUgdGhlIGJ1ZmZlciBpdCBnb3QgYmFjayBmcm9t
IHNldF92YWx1ZSgpCj4gCj4gRml4ZXM6IDhmOWFjMzBkICgibGlibXVsdGlwYXRoOiBmaXggc2V0
X2ludCBlcnJvciBwYXRoIikKPiBTaWduZWQtb2ZmLWJ5OiBCZW5qYW1pbiBNYXJ6aW5za2kgPGJt
YXJ6aW5zQHJlZGhhdC5jb20+CgpSZXZpZXdlZC1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3Vz
ZS5jb20+CgotLSAKRHIuIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkg
KDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBHbWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVy
LCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9uCkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
