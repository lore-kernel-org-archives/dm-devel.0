From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH]multipathd: threads cancellation can't work
 if new poll arrival just after restart multipath
Date: Tue, 30 Jan 2018 14:43:52 +0100
Message-ID: <1517319832.4072.44.camel@suse.com>
References: <CEB9978CF3252343BE3C67AC9F0086A342959378@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A342959378@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Wuchongyun <wu.chongyun@h3c.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

T24gVHVlLCAyMDE4LTAxLTMwIGF0IDA5OjU4ICswMDAwLCBXdWNob25neXVuIHdyb3RlOgo+IEhp
IENocmlzdG9waGUsIEhhbm5lcywgTWFydGluLCBYb3NlLCBCZW5qYW1pbiBhbmQgb3RoZXIgcmV2
aWV3ZXJzCj4gCj4gUGxlYXNlIGhlbHAgdG8gcmV2aWV3IHRoaXMgcGF0Y2gsIHRoYW5rcy4KCllv
dXIgYW5hbHlzaXMgbG9va3MgY29ycmVjdCB0byBtZS4gSSdkIGxpa2UgdG8gcHJvcG9zZSBhIHNs
aWdodGx5CmRpZmZlcmVudCBwYXRjaCB3aGljaCBJJ20gZ29pbmcgdG8gcG9zdCBhZnRlciB0aGlz
IGVtYWlsLgoKVGhhbmtzLApNYXJ0aW4KCi0tIApEci4gTWFydGluIFdpbGNrIDxtd2lsY2tAc3Vz
ZS5jb20+LCBUZWwuICs0OSAoMCk5MTEgNzQwNTMgMjEwNwpTVVNFIExpbnV4IEdtYkgsIEdGOiBG
ZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIxMjg0
IChBRyBOw7xybmJlcmcpCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=
