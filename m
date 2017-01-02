From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: [dm-devel] [PATCH v2 1/1] block: fix blk_queue_split() resource exhaustion
Date: Mon, 2 Jan 2017 15:33:02 +0100
Message-ID: <CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
 <20160711141042.GY13335@soda.linbit> <76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com>
 <20161223114553.GP4138@soda.linbit>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c08da88da64b605451d6d02
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161223114553.GP4138@soda.linbit>
Sender: linux-block-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Michael Wang <yun.wang@profitbricks.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, NeilBrown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>
List-Id: dm-devel.ids

--94eb2c08da88da64b605451d6d02
Content-Type: text/plain; charset=UTF-8

2016-12-23 12:45 GMT+01:00 Lars Ellenberg <lars.ellenberg@linbit.com>:
> On Fri, Dec 23, 2016 at 09:49:53AM +0100, Michael Wang wrote:
>> Dear Maintainers
>>
>> I'd like to ask for the status of this patch since we hit the
>> issue too during our testing on md raid1.
>>
>> Split remainder bio_A was queued ahead, following by bio_B for
>> lower device, at this moment raid start freezing, the loop take
>> out bio_A firstly and deliver it, which will hung since raid is
>> freezing, while the freezing never end since it waiting for
>> bio_B to finish, and bio_B is still on the queue, waiting for
>> bio_A to finish...
>>
>> We're looking for a good solution and we found this patch
>> already progressed a lot, but we can't find it on linux-next,
>> so we'd like to ask are we still planning to have this fix
>> in upstream?
>
> I don't see why not, I'd even like to have it in older kernels,
> but did not have the time and energy to push it.
>
> Thanks for the bump.
>
>         Lars
>
Hi folks,

As Michael mentioned, we hit a bug this patch is trying to fix.
Neil suggested another way to fix it.  I attached below.
I personal prefer Neil's version as it's less code change, and straight forward.

Could you share your comments, we can get one fix into mainline.

Thanks,
Jinpu

--94eb2c08da88da64b605451d6d02
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-block-fix-deadlock-between-freeze_array-and-wait_bar.patch"
Content-Disposition: attachment;
	filename="0001-block-fix-deadlock-between-freeze_array-and-wait_bar.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixg6glqx0

RnJvbSA2OWE0ODI5YTU1NTAzZTQ5NmNlOWM3MzBkMmM4ZTNkZDhhMDg4NzRhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOZWlsQnJvd24gPG5laWxiQHN1c2UuY29tPgpEYXRlOiBXZWQs
IDE0IERlYyAyMDE2IDE2OjU1OjUyICswMTAwClN1YmplY3Q6IFtQQVRDSF0gYmxvY2s6IGZpeCBk
ZWFkbG9jayBiZXR3ZWVuIGZyZWV6ZV9hcnJheSgpIGFuZCB3YWl0X2JhcnJpZXIoKQoKV2hlbiB3
ZSBjYWxsIHdhaXRfYmFycmllciwgd2UgbWlnaHQgaGF2ZSBzb21lIGJpb3Mgd2FpdGluZwppbiBj
dXJyZW50LT5iaW9fbGlzdCwgd2hpY2ggcHJldmVudHMgdGhlIGFycmF5X2ZyZWV6ZSBjYWxsIHRv
CmNvbXBsZXRlLiBUaG9zZSBjYW4gb25seSBiZSBpbnRlcm5hbCBSRUFEcywgd2hpY2ggaGF2ZSBh
bHJlYWR5CnBhc3NlZCB0aGUgd2FpdF9iYXJyaWVyIGNhbGwgKHRodXMgaW5jcmVtZW50aW5nIG5y
X3BlbmRpbmcpLCBidXQKc3RpbGwgd2VyZSBub3Qgc3VibWl0dGVkIHRvIHRoZSBsb3dlciBsZXZl
bCwgZHVlIHRvIGdlbmVyaWNfbWFrZV9yZXF1ZXN0CmxvZ2ljIHRvIGF2b2lkIHJlY3Vyc2l2ZSBj
YWxscy4gSW4gc3VjaCBjYXNlLCB3ZSBoYXZlIGEgZGVhZGxvY2s6Ci0gYXJyYXlfZnJvemVuIGlz
IGFscmVhZHkgc2V0IHRvIDEsIHNvIHdhaXRfYmFycmllciB1bmNvbmRpdGlvbmFsbHkgd2FpdHMs
IHNvCi0gaW50ZXJuYWwgUkVBRCBiaW9zIHdpbGwgbm90IGJlIHN1Ym1pdHRlZCwgdGh1cyBmcmVl
emVfYXJyYXkgd2lsbApuZXZlciBjb21wbGV0ZXMuCgpUbyBmaXggdGhpcywgbW9kaWZ5IGdlbmVy
aWNfbWFrZV9yZXF1ZXN0IHRvIGFsd2F5cyBzb3J0IGJpb19saXN0X29uX3N0YWNrCmZpcnN0IHdp
dGggbG93ZXN0IGxldmVsLCB0aGVuIGhpZ2hlciwgdW50aWwgc2FtZSBsZXZlbC4KClNlbnQgdG8g
bGludXgtcmFpZCBtYWlsIGxpc3Q6Cmh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXJhaWQmbT0x
NDgyMzI0NTMxMDc2ODUmdz0yCgpTdWdnZXN0ZWQtYnk6IE5laWxCcm93biA8bmVpbGJAc3VzZS5j
b20+ClNpZ25lZC1vZmYtYnk6IEphY2sgV2FuZyA8amlucHUud2FuZ0Bwcm9maXRicmlja3MuY29t
PgotLS0KIGJsb2NrL2Jsay1jb3JlLmMgfCAyMCArKysrKysrKysrKysrKysrKysrKwogMSBmaWxl
IGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9ibG9jay9ibGstY29yZS5j
IGIvYmxvY2svYmxrLWNvcmUuYwppbmRleCA5ZTNhYzU2Li40N2VmMzczIDEwMDY0NAotLS0gYS9i
bG9jay9ibGstY29yZS5jCisrKyBiL2Jsb2NrL2Jsay1jb3JlLmMKQEAgLTIxMzgsMTAgKzIxMzgs
MzAgQEAgYmxrX3FjX3QgZ2VuZXJpY19tYWtlX3JlcXVlc3Qoc3RydWN0IGJpbyAqYmlvKQogCQlz
dHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSA9IGJkZXZfZ2V0X3F1ZXVlKGJpby0+YmlfYmRldik7CiAK
IAkJaWYgKGxpa2VseShibGtfcXVldWVfZW50ZXIocSwgX19HRlBfRElSRUNUX1JFQ0xBSU0pID09
IDApKSB7CisJCQlzdHJ1Y3QgYmlvX2xpc3QgbG93ZXIsIHNhbWUsIGhvbGQ7CisKKwkJCS8qIENy
ZWF0ZSBhIGZyZXNoIGJpb19saXN0IGZvciBhbGwgc3Vib3JkaW5hdGUgcmVxdWVzdHMgKi8KKwkJ
CWJpb19saXN0X2luaXQoJmhvbGQpOworCQkJYmlvX2xpc3RfbWVyZ2UoJmhvbGQsICZiaW9fbGlz
dF9vbl9zdGFjayk7CisJCQliaW9fbGlzdF9pbml0KCZiaW9fbGlzdF9vbl9zdGFjayk7CiAKIAkJ
CXJldCA9IHEtPm1ha2VfcmVxdWVzdF9mbihxLCBiaW8pOwogCiAJCQlibGtfcXVldWVfZXhpdChx
KTsKKwkJCS8qIHNvcnQgbmV3IGJpb3MgaW50byB0aG9zZSBmb3IgYSBsb3dlciBsZXZlbAorCQkJ
ICogYW5kIHRob3NlIGZvciB0aGUgc2FtZSBsZXZlbAorCQkJICovCisJCQliaW9fbGlzdF9pbml0
KCZsb3dlcik7CisJCQliaW9fbGlzdF9pbml0KCZzYW1lKTsKKwkJCXdoaWxlICgoYmlvID0gYmlv
X2xpc3RfcG9wKCZiaW9fbGlzdF9vbl9zdGFjaykpICE9IE5VTEwpCisJCQkJaWYgKHEgPT0gYmRl
dl9nZXRfcXVldWUoYmlvLT5iaV9iZGV2KSkKKwkJCQkJYmlvX2xpc3RfYWRkKCZzYW1lLCBiaW8p
OworCQkJCWVsc2UKKwkJCQkJYmlvX2xpc3RfYWRkKCZsb3dlciwgYmlvKTsKKwkJCS8qIG5vdyBh
c3NlbWJsZSBzbyB3ZSBoYW5kbGUgdGhlIGxvd2VzdCBsZXZlbCBmaXJzdCAqLworCQkJYmlvX2xp
c3RfbWVyZ2UoJmJpb19saXN0X29uX3N0YWNrLCAmbG93ZXIpOworCQkJYmlvX2xpc3RfbWVyZ2Uo
JmJpb19saXN0X29uX3N0YWNrLCAmc2FtZSk7CisJCQliaW9fbGlzdF9tZXJnZSgmYmlvX2xpc3Rf
b25fc3RhY2ssICZob2xkKTsKIAogCQkJYmlvID0gYmlvX2xpc3RfcG9wKGN1cnJlbnQtPmJpb19s
aXN0KTsKIAkJfSBlbHNlIHsKLS0gCjIuNy40Cgo=
--94eb2c08da88da64b605451d6d02--
