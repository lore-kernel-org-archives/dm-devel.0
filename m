From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 07/13] block_dev: propagate
 bio_iov_iter_get_pages error in __blkdev_direct_IO
Date: Fri, 26 May 2017 11:12:31 +0200
Message-ID: <b5bc89a2-a17f-7e98-a767-bfa0c90afaac@suse.de>
References: <20170526085620.3113-1-hch@lst.de>
	<20170526085620.3113-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170526085620.3113-8-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

T24gMDUvMjYvMjAxNyAxMDo1NiBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gT25jZSB3
ZSBtb3ZlIHRoZSBibG9jayBsYXllciB0byBpdHMgb3duIHN0YXR1cyBjb2RlIHdlJ2xsIHN0aWxs
IHdhbnQgdG8KPiBwcm9wYWdhdGUgdGhlIGJpb19pb3ZfaXRlcl9nZXRfcGFnZXMsIHNvIHJlc3Ry
dWN0dXJlIF9fYmxrZGV2X2RpcmVjdF9JTwo+IHRvIHRha2UgcmV0IGludG8gYWNjb3VudCB3aGVu
IHJldHVybmluZyB0aGUgZXJybm8uCj4gLS0tCgoKLUVOT1NJR05PRkY/CgotLSAKSm9oYW5uZXMg
VGh1bXNoaXJuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU3RvcmFn
ZQpqdGh1bXNoaXJuQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5
MTEgNzQwNTMgNjg5ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5i
ZXJnCkdGOiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24K
SFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCktleSBmaW5nZXJwcmludCA9IEVDMzggOUNBQiBDMkM0
IEYyNUQgODYwMCBEMEQwIDAzOTMgOTY5RCAyRDc2IDA4NTAKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbA==
