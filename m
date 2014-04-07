From: "Carsten Scholtes" <Carsten_Scholtes@gmx.net>
Subject: kpartx -d fails to delete partition mapping for long
	filenames
Date: Mon, 7 Apr 2014 13:19:53 +0200
Message-ID: <trinity-c7b41696-dd03-456e-807f-11dfb2a5b9e3-1396869592987@3capp-gmx-bs43>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
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

VXNpbmcga3BhcnR4ICh2ZXJzaW9uOiBtdWx0aXBhdGgtdG9vbHMgKDAuNC45LTN1YnVudHU1LjEp
IHByZWNpc2UsIGFzIHByb3ZpZGVkIGluIFVidW50dSAxMi4wNC4zIExUUyA2NCBCaXQpLCBJIG5v
dGljZWQgdGhlIGZvbGxvd2luZyBwcm9ibGVtOgrCoApXaGlsZSBpdCBpcyBwb3NzaWJsZSB0byBh
ZGQgYSBwYXJ0aXRpb24gbWFwcGluZyBmb3IgYSBmaWxlIDxuYW1lPiB3aXRoIGEgbGVuZ3RoIG9m
IG1vcmUgdGhhbiA2NCBjaGFyYWN0ZXJzIChrcGFydHggLWF2IDxuYW1lPiksIGl0IGFwcGVhcnMg
dG8gYmUgaW1wb3NzaWJsZSB0byBkZWxldGUgdGhlIGNyZWF0ZWQgbWFwcGluZyB1c2luZyB0aGUg
c2FtZSBmaWxlbmFtZSAoa3BhcnR4IC1kIDxuYW1lPikuIEZvciBmaWxlbmFtZXMgbG9uZ2VyIHRo
YW4gNjQgY2hhcmFjdGVycywgdGhlIG1hcHBpbmcgaXMgc2lsZW50bHkgX25vdF8gcmVtb3ZlZDog
Tm8gZXJyb3IgbWVzc2FnZSBpcyBpc3N1ZWQgYW5kIHRoZSByZXR1cm4gY29kZSBpcyAwLgoKKFVz
aW5nIHRoZSBjb3JyZWN0IGxvb3AgZGV2aWNlIDxsb29wPiwgdGhlIG1hcHBpbmcgY2FuIHN0aWxs
IGJlIHJlbW92ZWQgKGthcHJ0eCAtZCA8bG9vcD4pLiBBZGRpdGlvbmFsbHksIGluIHRoaXMgY2Fz
ZSwgdGhlIGltcGxpY2l0bHkgYWxsb2NhdGVkIGxvb3AgZGV2aWNlIGhhcyB0byBiZSByZW1vdmVk
IGV4cGxpY2l0bHkgKGxvc2V0dXAgLWQgPGxvb3A+KS4pCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw=
