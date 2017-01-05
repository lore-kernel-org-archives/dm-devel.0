From: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource exhaustion
Date: Thu, 5 Jan 2017 11:54:00 +0100
Message-ID: <CAD9gYJ+U7drRjswfOf310v2aSgUKAnYT4STJcfxwqPhBzXEccg@mail.gmail.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
 <20160711141042.GY13335@soda.linbit> <76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com>
 <20161223114553.GP4138@soda.linbit> <CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com>
 <878tqrmmqx.fsf@notabene.neil.brown.name> <20170104185046.GA982@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=94eb2c08804c14c8ca054556b80e
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170104185046.GA982@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Mikulas Patocka <mpatocka@redhat.com>, Jack Wang <jack.wang.usish@gmail.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.>
List-Id: dm-devel.ids

--94eb2c08804c14c8ca054556b80e
Content-Type: text/plain; charset=UTF-8

2017-01-04 19:50 GMT+01:00 Mike Snitzer <snitzer@redhat.com>:
> On Wed, Jan 04 2017 at 12:12am -0500,
> NeilBrown <neilb@suse.com> wrote:
>
>> On Tue, Jan 03 2017, Jack Wang wrote:
>>
>> > 2016-12-23 12:45 GMT+01:00 Lars Ellenberg <lars.ellenberg@linbit.com>:
>> >> On Fri, Dec 23, 2016 at 09:49:53AM +0100, Michael Wang wrote:
>> >>> Dear Maintainers
>> >>>
>> >>> I'd like to ask for the status of this patch since we hit the
>> >>> issue too during our testing on md raid1.
>> >>>
>> >>> Split remainder bio_A was queued ahead, following by bio_B for
>> >>> lower device, at this moment raid start freezing, the loop take
>> >>> out bio_A firstly and deliver it, which will hung since raid is
>> >>> freezing, while the freezing never end since it waiting for
>> >>> bio_B to finish, and bio_B is still on the queue, waiting for
>> >>> bio_A to finish...
>> >>>
>> >>> We're looking for a good solution and we found this patch
>> >>> already progressed a lot, but we can't find it on linux-next,
>> >>> so we'd like to ask are we still planning to have this fix
>> >>> in upstream?
>> >>
>> >> I don't see why not, I'd even like to have it in older kernels,
>> >> but did not have the time and energy to push it.
>> >>
>> >> Thanks for the bump.
>> >>
>> >>         Lars
>> >>
>> > Hi folks,
>> >
>> > As Michael mentioned, we hit a bug this patch is trying to fix.
>> > Neil suggested another way to fix it.  I attached below.
>> > I personal prefer Neil's version as it's less code change, and straight forward.
>> >
>> > Could you share your comments, we can get one fix into mainline.
>> >
>> > Thanks,
>> > Jinpu
>> > From 69a4829a55503e496ce9c730d2c8e3dd8a08874a Mon Sep 17 00:00:00 2001
>> > From: NeilBrown <neilb@suse.com>
>> > Date: Wed, 14 Dec 2016 16:55:52 +0100
>> > Subject: [PATCH] block: fix deadlock between freeze_array() and wait_barrier()
>> >
>> > When we call wait_barrier, we might have some bios waiting
>> > in current->bio_list, which prevents the array_freeze call to
>> > complete. Those can only be internal READs, which have already
>> > passed the wait_barrier call (thus incrementing nr_pending), but
>> > still were not submitted to the lower level, due to generic_make_request
>> > logic to avoid recursive calls. In such case, we have a deadlock:
>> > - array_frozen is already set to 1, so wait_barrier unconditionally waits, so
>> > - internal READ bios will not be submitted, thus freeze_array will
>> > never completes.
>> >
>> > To fix this, modify generic_make_request to always sort bio_list_on_stack
>> > first with lowest level, then higher, until same level.
>> >
>> > Sent to linux-raid mail list:
>> > https://marc.info/?l=linux-raid&m=148232453107685&w=2
>> >
>>
>> This should probably also have
>>
>>   Inspired-by: Lars Ellenberg <lars.ellenberg@linbit.com>
>>
>> or something that, as I was building on Lars' ideas when I wrote this.
>>
>> It would also be worth noting in the description that this addresses
>> issues with dm and drbd as well as md.
>
> I never saw this patch but certainly like the relative simplicity of the
> solution when compared with other approaches taken, e.g. (5 topmost
> commits on this branch):
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip
>
>> In fact, I think that with this patch in place, much of the need for the
>> rescue_workqueue won't exist any more.  I cannot promise it can be
>> removed completely, but it should be to hard to make it optional and
>> only enabled for those few block devices that will still need it.
>> The rescuer should only be needed for a bioset which can be allocated
>> From twice in the one call the ->make_request_fn.  This would include
>> raid0 for example, though raid0_make_reqest could be re-written to not
>> use a loop and to just call generic_make_request(bio) if bio != split.
>
> Mikulas, would you be willing to try the below patch with the
> dm-snapshot deadlock scenario and report back on whether it fixes that?
>
> Patch below looks to be the same as here:
> https://marc.info/?l=linux-raid&m=148232453107685&q=p3
>
> Neil and/or others if that isn't the patch that should be tested please
> provide a pointer to the latest.
>
> Thanks,
> Mike

Thanks Mike,

I've rebased the patch on to Linux-4.10-rc2, and updated the
description as Neil suggested.
If Mikulas get possitive feedback, then we can go with it.

Cheers,
Jinpu

--94eb2c08804c14c8ca054556b80e
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-block-fix-deadlock-between-freeze_array-and-wait_bar.patch"
Content-Disposition: attachment;
	filename="0001-block-fix-deadlock-between-freeze_array-and-wait_bar.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ixk96y180

RnJvbSA0ZmZhZWZiNzE5YzEyOWVkNTFmOWZjYjIzNWI5NDVjYWY1NmRlOGQxIE1vbiBTZXAgMTcg
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
dGggbG93ZXN0IGxldmVsLCB0aGVuIGhpZ2hlciwgdW50aWwgc2FtZSBsZXZlbC4KClRoaXMgd291
bGQgYWRkcmVzcyBpc3N1c2VzIHdpdGggZG0gYW5kIGRyYmQgYXMgd2VsbCBhcyBtZC4KClNlbnQg
dG8gbGludXgtcmFpZCBtYWlsIGxpc3Q6Cmh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXJhaWQm
bT0xNDgyMzI0NTMxMDc2ODUmdz0yCgpJbnNwaXJlZC1ieTogTGFycyBFbGxlbmJlcmcgPGxhcnMu
ZWxsZW5iZXJnQGxpbmJpdC5jb20+ClN1Z2dlc3RlZC1ieTogTmVpbEJyb3duIDxuZWlsYkBzdXNl
LmNvbT4KU2lnbmVkLW9mZi1ieTogSmFjayBXYW5nIDxqaW5wdS53YW5nQHByb2ZpdGJyaWNrcy5j
b20+Ci0tLQogYmxvY2svYmxrLWNvcmUuYyB8IDIxICsrKysrKysrKysrKysrKysrKysrKwogMSBm
aWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9ibG9jay9ibGstY29y
ZS5jIGIvYmxvY2svYmxrLWNvcmUuYwppbmRleCA2MWJhMDhjLi4yZjc0MTI5IDEwMDY0NAotLS0g
YS9ibG9jay9ibGstY29yZS5jCisrKyBiL2Jsb2NrL2Jsay1jb3JlLmMKQEAgLTIwMTksOSArMjAx
OSwzMCBAQCBibGtfcWNfdCBnZW5lcmljX21ha2VfcmVxdWVzdChzdHJ1Y3QgYmlvICpiaW8pCiAJ
CXN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxID0gYmRldl9nZXRfcXVldWUoYmlvLT5iaV9iZGV2KTsK
IAogCQlpZiAobGlrZWx5KGJsa19xdWV1ZV9lbnRlcihxLCBmYWxzZSkgPT0gMCkpIHsKKwkJCXN0
cnVjdCBiaW9fbGlzdCBsb3dlciwgc2FtZSwgaG9sZDsKKworCQkJLyogQ3JlYXRlIGEgZnJlc2gg
YmlvX2xpc3QgZm9yIGFsbCBzdWJvcmRpbmF0ZSByZXF1ZXN0cyAqLworCQkJYmlvX2xpc3RfaW5p
dCgmaG9sZCk7CisJCQliaW9fbGlzdF9tZXJnZSgmaG9sZCwgJmJpb19saXN0X29uX3N0YWNrKTsK
KwkJCWJpb19saXN0X2luaXQoJmJpb19saXN0X29uX3N0YWNrKTsKKwogCQkJcmV0ID0gcS0+bWFr
ZV9yZXF1ZXN0X2ZuKHEsIGJpbyk7CiAKIAkJCWJsa19xdWV1ZV9leGl0KHEpOworCQkJLyogc29y
dCBuZXcgYmlvcyBpbnRvIHRob3NlIGZvciBhIGxvd2VyIGxldmVsCisJCQkgKiBhbmQgdGhvc2Ug
Zm9yIHRoZSBzYW1lIGxldmVsCisJCQkgKi8KKwkJCWJpb19saXN0X2luaXQoJmxvd2VyKTsKKwkJ
CWJpb19saXN0X2luaXQoJnNhbWUpOworCQkJd2hpbGUgKChiaW8gPSBiaW9fbGlzdF9wb3AoJmJp
b19saXN0X29uX3N0YWNrKSkgIT0gTlVMTCkKKwkJCQlpZiAocSA9PSBiZGV2X2dldF9xdWV1ZShi
aW8tPmJpX2JkZXYpKQorCQkJCQliaW9fbGlzdF9hZGQoJnNhbWUsIGJpbyk7CisJCQkJZWxzZQor
CQkJCQliaW9fbGlzdF9hZGQoJmxvd2VyLCBiaW8pOworCQkJLyogbm93IGFzc2VtYmxlIHNvIHdl
IGhhbmRsZSB0aGUgbG93ZXN0IGxldmVsIGZpcnN0ICovCisJCQliaW9fbGlzdF9tZXJnZSgmYmlv
X2xpc3Rfb25fc3RhY2ssICZsb3dlcik7CisJCQliaW9fbGlzdF9tZXJnZSgmYmlvX2xpc3Rfb25f
c3RhY2ssICZzYW1lKTsKKwkJCWJpb19saXN0X21lcmdlKCZiaW9fbGlzdF9vbl9zdGFjaywgJmhv
bGQpOwogCiAJCQliaW8gPSBiaW9fbGlzdF9wb3AoY3VycmVudC0+YmlvX2xpc3QpOwogCQl9IGVs
c2UgewotLSAKMi43LjQKCg==
--94eb2c08804c14c8ca054556b80e--
