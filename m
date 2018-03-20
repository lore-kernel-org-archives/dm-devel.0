From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Tue, 20 Mar 2018 16:19:09 +0100
Message-ID: <1521559149.3798.168.camel@suse.com>
References: <CEB9978CF3252343BE3C67AC9F0086A34295C462@H3CMLB14-EX.srv.huawei-3com.com>
	<1520325779.4131.4.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295C9D0@H3CMLB14-EX.srv.huawei-3com.com>
	<1520349519.4131.20.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CA7D@H3CMLB14-EX.srv.huawei-3com.com>
	<1520426679.11340.5.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CF62@H3CMLB14-EX.srv.huawei-3com.com>
	<20180308154435.GB14513@octiron.msp.redhat.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295D215@H3CMLB14-EX.srv.huawei-3com.com>
	<20180309162243.GE14513@octiron.msp.redhat.com>
	<1521495726.3798.141.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295DF37@H3CMLB14-EX.srv.huawei-3com.com>
	<1521557887.3156.5.camel@wdc.com>
	<3537d472-27ad-53fd-7d13-229359a53849@gmail.com>
	<1521558853.3156.10.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521558853.3156.10.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "wu.chongyun@h3c.com" <wu.chongyun@h3c.com>
Cc: "guozhonghua@h3c.com" <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "changlimin@h3c.com" <changlimin@h3c.com>, "ge.changwei@h3c.com" <ge.changwei@h3c.com>
List-Id: dm-devel.ids

T24gVHVlLCAyMDE4LTAzLTIwIGF0IDE1OjE0ICswMDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gT24gVHVlLCAyMDE4LTAzLTIwIGF0IDE2OjEyICswMTAwLCBYb3NlIFZhenF1ZXogUGVyZXog
d3JvdGU6Cj4gPiAKPiA+IFRoZXJlIGFyZSBzb21lICJyZW1vdmUiIGZsYWdzIGluIHJlc2Nhbi1z
Y3NpLWJ1cy5zaDoKPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9ocmVpbmVja2Uvc2czX3V0aWxzL2Js
b2IvZDRkYmJlZGUwNGRiMjFjMjA2ZTRjMmEKPiA+IGNjMWNmNzY2MTE3ZjAwM2MzL3NjcmlwdHMv
cmVzY2FuLXNjc2ktYnVzLnNoI0wxMDgwCj4gPiAKPiA+IC1yICAgICAgZW5hYmxlcyByZW1vdmlu
ZyBvZiBkZXZpY2VzICAgICAgICBbZGVmYXVsdDogZGlzYWJsZWRdCj4gPiAtLWZvcmNlcmVtb3Zl
OiAgIFJlbW92ZSBzdGFsZSBkZXZpY2VzIChEQU5HRVJPVVMpCj4gPiAtLWZvcmNlcmVzY2FuOiAg
IFJlbW92ZSBhbmQgcmVhZGQgZXhpc3RpbmcgZGV2aWNlcyAoREFOR0VST1VTKQo+IAo+IExhc3Qg
dGltZSBJIGNoZWNrZWQgdGhlIHJlc2Nhbi1zY3NpLWJ1cy5zaCBzY3JpcHQgcmVsaWVkIG9uIHRo
ZSBTQ1NJCj4gc3lzZnMKPiBkZWxldGUgYXR0cmlidXRlIHRvIHJlbW92ZSBzdGFsZSBkZXZpY2Vz
LiBUaGF0IGlzIHRoZSBtZWNoYW5pc20gdGhhdAo+IGNhbgo+IHRyaWdnZXIgYSBkZWFkbG9jayBp
biB0aGUga2VybmVsLgoKSXMgdGhlcmUgYW4gYWx0ZXJuYXRpdmUgdGhlIHNjcmlwdCBjb3VsZCB1
c2U/IEknbSBub3QgYXdhcmUgb2YgYW55LgoKTWFydGluCgotLSAKRHIuIE1hcnRpbiBXaWxjayA8
bXdpbGNrQHN1c2UuY29tPiwgVGVsLiArNDkgKDApOTExIDc0MDUzIDIxMDcKU1VTRSBMaW51eCBH
bWJILCBHRjogRmVsaXggSW1lbmTDtnJmZmVyLCBKYW5lIFNtaXRoYXJkLCBHcmFoYW0gTm9ydG9u
CkhSQiAyMTI4NCAoQUcgTsO8cm5iZXJnKQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVs
