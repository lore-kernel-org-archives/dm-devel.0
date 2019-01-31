From: "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Thu, 31 Jan 2019 08:58:24 +0800
Message-ID: <b9ac025a-87ba-7693-ae4f-943702609ffc@huawei.com>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com> <yq1lg34f4i7.fsf@oracle.com>
	<CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
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
To: John Dorminy <jdorminy@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

CgpPbiAxLzMwLzIwMTkgMTA6MDggUE0sIEpvaG4gRG9ybWlueSB3cm90ZToKPiBBbHRlcm5hdGVs
eSwgY291bGQgcG9zc2libHkgV1JJVEVfU0FNRSBiaW9zIGJlIGFjY2VwdGVkIHdpdGggdGhlCj4g
bWluaW11bSBzZWN0b3Igc2l6ZSBvZiB0aGUgc3RhY2sgcmF0aGVyIHRoYW4gdGhlIG1heCwgZS5n
LiA1MTIgaW4gdGhpcwo+IGV4YW1wbGUgcmF0aGVyIHRoYW4gNGs/IFRoZXknZCBuZWVkIHRvIGhh
dmUgYSBncmFudWxhcml0eSBvZiB0aGUKPiBsYXJnZXIgc2VjdG9yIHNpemUsIHRob3VnaCwgcHJl
c3VtYWJpbHkgbmVjZXNzaXRhdGluZyBuZXcgcXVldWUgbGltaXRzCj4gd3JpdGVfc2FtZV97Z3Jh
bnVsYXJpdHksYmxvY2tfc2l6ZX0sIHdoaWNoIG1pZ2h0IGJlIHRvbyBtdWNoIHdvcmsuIEZvcgo+
IGRldmljZXMgd2l0aCBiaWdnZXIgc2VjdG9ycywgdGhlIGJsb2NrIGxheWVyIG9yIERNIHdvdWxk
IG5lZWQgdG8KPiBleHBhbmQgdGhlIHNtYWxsLXNlY3RvciBwYXlsb2FkIHRvIGFuIGFwcHJvcHJp
YXRlIGxhcmdlci1zZWN0b3IKPiBwYXlsb2FkLCBidXQgaXQgd291bGQgcHJlc2VydmUgdGhlIGFi
aWxpdHkgdG8gdXNlIFdSSVRFX1NBTUUgd2l0aAo+IG5vbi16ZXJvIHBheWxvYWRzLgo+IAo+IChJ
IHVzZSBXUklURV9TQU1FIHRvIGZpbGwgZGV2aWNlcyB3aXRoIGEgcGFydGljdWxhciBwYXR0ZXJu
IGluIG9yZGVyCj4gdG8gY2F0Y2ggZmFpbHVyZXMgdG8gaW5pdGlhbGl6ZSBkaXNrIHN0cnVjdHVy
ZXMgYXBwcm9wcmlhdGVseSwKPiBwZXJzb25hbGx5LCBidXQgaXQncyBqdXN0IGZvciBjb252ZW5p
ZW5jZS9zcGVlZC4pCkkgdGhpbmsgdHdvIExCU3Mgd2lsbCBwcm9kdWNlIGFtYmlndWl0eS4KUmVm
ZXJlbmNlIHNwZWMKCUluZm9ybWF0aW9uIHRlY2hub2xvZ3kgLQoJU0NTSSBCbG9jayBDb21tYW5k
cyDigJMgNCAoU0JDLTQpCglJU08vSUVDIDE0Nzc2LTMyNDoyMDF4CglCU1IgSU5DSVRTIDUwNjoy
MDF4CjUuNTAgV1JJVEUgU0FNRSAoMTApIGNvbW1hbmQKVGhlIFdSSVRFIFNBTUUgKDEwKSBjb21t
YW5kIChzZWUgdGFibGUgMTQ1KSByZXF1ZXN0cyB0aGF0IHRoZSBkZXZpY2Ugc2VydmVyCioqdHJh
bnNmZXIgYSBzaW5nbGUgbG9naWNhbCBibG9jayoqIGZyb20gdGhlIERhdGEtT3V0IEJ1ZmZlciBh
bmQgZm9yIGVhY2ggTEJBIGluCnRoZSBzcGVjaWZpZWQgcmFuZ2Ugb2YgTEJBczoKCgoKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vd3d3LnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==
