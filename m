From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/1] block: Convert hd_struct in_flight from atomic to percpu
Date: Fri, 30 Jun 2017 00:25:36 +0800
Message-ID: <CACVXFVPvbJ1vD5-7aBeNQ6D6bDvhhd8aQQJ++vVZwJ5AM8TMjg@mail.gmail.com>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk> <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
 <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="001a11376f0037963005531bc0ea"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--001a11376f0037963005531bc0ea
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 29, 2017 at 11:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/29/2017 02:40 AM, Ming Lei wrote:
>> On Thu, Jun 29, 2017 at 5:49 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 06/28/2017 03:12 PM, Brian King wrote:
>>>> This patch converts the in_flight counter in struct hd_struct from a
>>>> pair of atomics to a pair of percpu counters. This eliminates a couple
>>>> of atomics from the hot path. When running this on a Power system, to
>>>> a single null_blk device with 80 submission queues, irq mode 0, with
>>>> 80 fio jobs, I saw IOPs go from 1.5M IO/s to 11.4 IO/s.
>>>
>>> This has been done before, but I've never really liked it. The reason is
>>> that it means that reading the part stat inflight count now has to
>>> iterate over every possible CPU. Did you use partitions in your testing?
>>> How many CPUs were configured? When I last tested this a few years ago
>>> on even a quad core nehalem (which is notoriously shitty for cross-node
>>> latencies), it was a net loss.
>>
>> One year ago, I saw null_blk's IOPS can be decreased to 10%
>> of non-RQF_IO_STAT on a dual socket ARM64(each CPU has
>> 96 cores, and dual numa nodes) too, the performance can be
>> recovered basically if per numa-node counter is introduced and
>> used in this case, but the patch was never posted out.
>> If anyone is interested in that, I can rebase the patch on current
>> block tree and post out. I guess the performance issue might be
>> related with system cache coherency implementation more or less.
>> This issue on ARM64 can be observed with the following userspace
>> atomic counting test too:
>>
>>        http://kernel.ubuntu.com/~ming/test/cache/
>
> How well did the per-node thing work? Doesn't seem to me like it would

Last time, on ARM64, I remembered that the IOPS was basically recovered,
but now I don't have a such machine to test. Could Brian test the attached patch
to see if it works on big Power machine?

And the idea is simple, just make the atomic counter per-node.

> go far enough. And per CPU is too much. One potential improvement would
> be to change the part_stat_read() to just loop online CPUs, instead of
> all possible CPUs. When CPUs go on/offline, use that as the slow path to
> ensure the stats are sane. Often there's a huge difference between
> NR_CPUS configured and what the system has. As Brian states, RH ships
> with 2048, while I doubt a lot of customers actually run that...

One observation I saw on arm64 dual socket before is that atomic inc/dec on
counter stored in local numa node is much cheaper than cross-node, that is
why I tried the per-node counter. And wrt. in-flight atomic counter, both inc
and dec should happen on CPUs belonging to same numa node in case of
blk-mq.

>
> Outside of coming up with a more clever data structure that is fully
> CPU topology aware, one thing that could work is just having X cache
> line separated read/write inflight counters per node, where X is some
> suitable value (like 4). That prevents us from having cross node
> traffic, and it also keeps the cross cpu traffic fairly low. That should
> provide a nice balance between cost of incrementing the inflight
> counting, and the cost of looping for reading it.
>
> And that brings me to the next part...
>
>>> I do agree that we should do something about it, and it's one of those
>>> items I've highlighted in talks about blk-mq on pending issues to fix
>>> up. It's just not great as it currently stands, but I don't think per
>>> CPU counters is the right way to fix it, at least not for the inflight
>>> counter.
>>
>> Yeah, it won't be a issue for non-mq path, and for blk-mq path, maybe
>> we can use some blk-mq knowledge(tagset?) to figure out the
>> 'in_flight' counter. I thought about it before, but never got a
>> perfect solution, and looks it is a bit hard, :-)
>
> The tags are already a bit spread out, so it's worth a shot. That would
> remove the need to do anything in the inc/dec path, as the tags already
> do that. The inlight count could be easily retrieved with
> sbitmap_weight(). The only issue here is that we need separate read and
> write counters, and the weight would obviously only get us the total
> count. But we can have a slower path for that, just iterate the tags and
> count them. The fast path only cares about total count.
>
> Let me try that out real quick.
>
> --
> Jens Axboe
>



Thanks,
Ming Lei

--001a11376f0037963005531bc0ea
Content-Type: text/x-patch; charset="US-ASCII"; name="per-node-atomic-counter.patch"
Content-Disposition: attachment; filename="per-node-atomic-counter.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j4in1vhp0

ZGlmZiAtLWdpdCBhL2Jsb2NrL3BhcnRpdGlvbi1nZW5lcmljLmMgYi9ibG9jay9wYXJ0aXRpb24t
Z2VuZXJpYy5jCmluZGV4IGM1ZWM4MjQ2ZTI1ZS4uYmQ2NjQ0YmY5NjQzIDEwMDY0NAotLS0gYS9i
bG9jay9wYXJ0aXRpb24tZ2VuZXJpYy5jCisrKyBiL2Jsb2NrL3BhcnRpdGlvbi1nZW5lcmljLmMK
QEAgLTE0MCw4ICsxNDAsOSBAQCBzc2l6ZV90IHBhcnRfaW5mbGlnaHRfc2hvdyhzdHJ1Y3QgZGV2
aWNlICpkZXYsCiB7CiAJc3RydWN0IGhkX3N0cnVjdCAqcCA9IGRldl90b19wYXJ0KGRldik7CiAK
LQlyZXR1cm4gc3ByaW50ZihidWYsICIlOHUgJTh1XG4iLCBhdG9taWNfcmVhZCgmcC0+aW5fZmxp
Z2h0WzBdKSwKLQkJYXRvbWljX3JlYWQoJnAtPmluX2ZsaWdodFsxXSkpOworCXJldHVybiBzcHJp
bnRmKGJ1ZiwgIiU4dSAlOHVcbiIsCisJCXBub2RlX2NvdW50ZXJfcmVhZF9hbGwoJnAtPmluX2Zs
aWdodFswXSksCisJCXBub2RlX2NvdW50ZXJfcmVhZF9hbGwoJnAtPmluX2ZsaWdodFsxXSkpOwog
fQogCiAjaWZkZWYgQ09ORklHX0ZBSUxfTUFLRV9SRVFVRVNUCmRpZmYgLS1naXQgYS9kcml2ZXJz
L21kL2RtLmMgYi9kcml2ZXJzL21kL2RtLmMKaW5kZXggOTZiZDEzZTU4MWNkLi5hYWMwYjIyMzU0
MTAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvZG0uYworKysgYi9kcml2ZXJzL21kL2RtLmMKQEAg
LTUyMSw3ICs1MjEsNyBAQCBzdGF0aWMgdm9pZCBzdGFydF9pb19hY2N0KHN0cnVjdCBkbV9pbyAq
aW8pCiAJY3B1ID0gcGFydF9zdGF0X2xvY2soKTsKIAlwYXJ0X3JvdW5kX3N0YXRzKGNwdSwgJmRt
X2Rpc2sobWQpLT5wYXJ0MCk7CiAJcGFydF9zdGF0X3VubG9jaygpOwotCWF0b21pY19zZXQoJmRt
X2Rpc2sobWQpLT5wYXJ0MC5pbl9mbGlnaHRbcnddLAorCXBub2RlX2NvdW50ZXJfc2V0KCZkbV9k
aXNrKG1kKS0+cGFydDAuaW5fZmxpZ2h0W3J3XSwKIAkJYXRvbWljX2luY19yZXR1cm4oJm1kLT5w
ZW5kaW5nW3J3XSkpOwogCiAJaWYgKHVubGlrZWx5KGRtX3N0YXRzX3VzZWQoJm1kLT5zdGF0cykp
KQpAQCAtNTUwLDcgKzU1MCw3IEBAIHN0YXRpYyB2b2lkIGVuZF9pb19hY2N0KHN0cnVjdCBkbV9p
byAqaW8pCiAJICogYSBmbHVzaC4KIAkgKi8KIAlwZW5kaW5nID0gYXRvbWljX2RlY19yZXR1cm4o
Jm1kLT5wZW5kaW5nW3J3XSk7Ci0JYXRvbWljX3NldCgmZG1fZGlzayhtZCktPnBhcnQwLmluX2Zs
aWdodFtyd10sIHBlbmRpbmcpOworCXBub2RlX2NvdW50ZXJfc2V0KCZkbV9kaXNrKG1kKS0+cGFy
dDAuaW5fZmxpZ2h0W3J3XSwgcGVuZGluZyk7CiAJcGVuZGluZyArPSBhdG9taWNfcmVhZCgmbWQt
PnBlbmRpbmdbcndeMHgxXSk7CiAKIAkvKiBudWRnZSBhbnlvbmUgd2FpdGluZyBvbiBzdXNwZW5k
IHF1ZXVlICovCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2dlbmhkLmggYi9pbmNsdWRlL2xp
bnV4L2dlbmhkLmgKaW5kZXggZTYxOWZhZTJmMDM3Li40MGM5YmM3NGExMjAgMTAwNjQ0Ci0tLSBh
L2luY2x1ZGUvbGludXgvZ2VuaGQuaAorKysgYi9pbmNsdWRlL2xpbnV4L2dlbmhkLmgKQEAgLTE1
LDYgKzE1LDcgQEAKICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CiAjaW5jbHVkZSA8bGludXgvcGVy
Y3B1LXJlZmNvdW50Lmg+CiAjaW5jbHVkZSA8bGludXgvdXVpZC5oPgorI2luY2x1ZGUgPGxpbnV4
L3Blcm5vZGVfY291bnRlci5oPgogCiAjaWZkZWYgQ09ORklHX0JMT0NLCiAKQEAgLTEyMCw3ICsx
MjEsNyBAQCBzdHJ1Y3QgaGRfc3RydWN0IHsKIAlpbnQgbWFrZV9pdF9mYWlsOwogI2VuZGlmCiAJ
dW5zaWduZWQgbG9uZyBzdGFtcDsKLQlhdG9taWNfdCBpbl9mbGlnaHRbMl07CisJc3RydWN0IHBu
b2RlX2NvdW50ZXIgaW5fZmxpZ2h0WzJdOwogI2lmZGVmCUNPTkZJR19TTVAKIAlzdHJ1Y3QgZGlz
a19zdGF0cyBfX3BlcmNwdSAqZGtzdGF0czsKICNlbHNlCkBAIC0zNjQsMjEgKzM2NSwyMiBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgZnJlZV9wYXJ0X3N0YXRzKHN0cnVjdCBoZF9zdHJ1Y3QgKnBhcnQp
CiAKIHN0YXRpYyBpbmxpbmUgdm9pZCBwYXJ0X2luY19pbl9mbGlnaHQoc3RydWN0IGhkX3N0cnVj
dCAqcGFydCwgaW50IHJ3KQogewotCWF0b21pY19pbmMoJnBhcnQtPmluX2ZsaWdodFtyd10pOwor
CXBub2RlX2NvdW50ZXJfaW5jKCZwYXJ0LT5pbl9mbGlnaHRbcnddKTsKIAlpZiAocGFydC0+cGFy
dG5vKQotCQlhdG9taWNfaW5jKCZwYXJ0X3RvX2Rpc2socGFydCktPnBhcnQwLmluX2ZsaWdodFty
d10pOworCQlwbm9kZV9jb3VudGVyX2luYygmcGFydF90b19kaXNrKHBhcnQpLT5wYXJ0MC5pbl9m
bGlnaHRbcnddKTsKIH0KIAogc3RhdGljIGlubGluZSB2b2lkIHBhcnRfZGVjX2luX2ZsaWdodChz
dHJ1Y3QgaGRfc3RydWN0ICpwYXJ0LCBpbnQgcncpCiB7Ci0JYXRvbWljX2RlYygmcGFydC0+aW5f
ZmxpZ2h0W3J3XSk7CisJcG5vZGVfY291bnRlcl9kZWMoJnBhcnQtPmluX2ZsaWdodFtyd10pOwog
CWlmIChwYXJ0LT5wYXJ0bm8pCi0JCWF0b21pY19kZWMoJnBhcnRfdG9fZGlzayhwYXJ0KS0+cGFy
dDAuaW5fZmxpZ2h0W3J3XSk7CisJCXBub2RlX2NvdW50ZXJfZGVjKCZwYXJ0X3RvX2Rpc2socGFy
dCktPnBhcnQwLmluX2ZsaWdodFtyd10pOwogfQogCiBzdGF0aWMgaW5saW5lIGludCBwYXJ0X2lu
X2ZsaWdodChzdHJ1Y3QgaGRfc3RydWN0ICpwYXJ0KQogewotCXJldHVybiBhdG9taWNfcmVhZCgm
cGFydC0+aW5fZmxpZ2h0WzBdKSArIGF0b21pY19yZWFkKCZwYXJ0LT5pbl9mbGlnaHRbMV0pOwor
CXJldHVybiBwbm9kZV9jb3VudGVyX3JlYWRfYWxsKCZwYXJ0LT5pbl9mbGlnaHRbMF0pICsgXAor
CQlwbm9kZV9jb3VudGVyX3JlYWRfYWxsKCZwYXJ0LT5pbl9mbGlnaHRbMV0pOwogfQogCiBzdGF0
aWMgaW5saW5lIHN0cnVjdCBwYXJ0aXRpb25fbWV0YV9pbmZvICphbGxvY19wYXJ0X2luZm8oc3Ry
dWN0IGdlbmRpc2sgKmRpc2spCkBAIC02MjcsMTEgKzYyOSwzNCBAQCBleHRlcm4gc3NpemVfdCBw
YXJ0X2ZhaWxfc3RvcmUoc3RydWN0IGRldmljZSAqZGV2LAogCQkJICAgICAgIGNvbnN0IGNoYXIg
KmJ1Ziwgc2l6ZV90IGNvdW50KTsKICNlbmRpZiAvKiBDT05GSUdfRkFJTF9NQUtFX1JFUVVFU1Qg
Ki8KIAorc3RhdGljIGlubGluZSBpbnQgaGRfY291bnRlcl9pbml0KHN0cnVjdCBoZF9zdHJ1Y3Qg
KnBhcnQpCit7CisJaWYgKHBub2RlX2NvdW50ZXJfaW5pdCgmcGFydC0+aW5fZmxpZ2h0WzBdLCBH
RlBfS0VSTkVMKSkKKwkJcmV0dXJuIC1FTk9NRU07CisJaWYgKHBub2RlX2NvdW50ZXJfaW5pdCgm
cGFydC0+aW5fZmxpZ2h0WzFdLCBHRlBfS0VSTkVMKSkgeworCQlwbm9kZV9jb3VudGVyX2RlaW5p
dCgmcGFydC0+aW5fZmxpZ2h0WzBdKTsKKwkJcmV0dXJuIC1FTk9NRU07CisJfQorCisJcmV0dXJu
IDA7Cit9CisKK3N0YXRpYyBpbmxpbmUgdm9pZCBoZF9jb3VudGVyX2RlaW5pdChzdHJ1Y3QgaGRf
c3RydWN0ICpwYXJ0KQoreworCXBub2RlX2NvdW50ZXJfZGVpbml0KCZwYXJ0LT5pbl9mbGlnaHRb
MF0pOworCXBub2RlX2NvdW50ZXJfZGVpbml0KCZwYXJ0LT5pbl9mbGlnaHRbMV0pOworfQorCiBz
dGF0aWMgaW5saW5lIGludCBoZF9yZWZfaW5pdChzdHJ1Y3QgaGRfc3RydWN0ICpwYXJ0KQogewor
CWlmIChoZF9jb3VudGVyX2luaXQocGFydCkpCisJCXJldHVybiAtRU5PTUVNOworCiAJaWYgKHBl
cmNwdV9yZWZfaW5pdCgmcGFydC0+cmVmLCBfX2RlbGV0ZV9wYXJ0aXRpb24sIDAsCi0JCQkJR0ZQ
X0tFUk5FTCkpCisJCQkJR0ZQX0tFUk5FTCkpIHsKKwkJaGRfY291bnRlcl9kZWluaXQocGFydCk7
CiAJCXJldHVybiAtRU5PTUVNOworCX0KIAlyZXR1cm4gMDsKIH0KIApAQCAtNjU5LDYgKzY4NCw3
IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBoZF9mcmVlX3BhcnQoc3RydWN0IGhkX3N0cnVjdCAqcGFy
dCkKIHsKIAlmcmVlX3BhcnRfc3RhdHMocGFydCk7CiAJZnJlZV9wYXJ0X2luZm8ocGFydCk7CisJ
aGRfY291bnRlcl9kZWluaXQocGFydCk7CiAJcGVyY3B1X3JlZl9leGl0KCZwYXJ0LT5yZWYpOwog
fQogCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3Blcm5vZGVfY291bnRlci5oIGIvaW5jbHVk
ZS9saW51eC9wZXJub2RlX2NvdW50ZXIuaApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAw
MDAwMDAwMDAuLjEyNzYzOWZiYzI1ZgotLS0gL2Rldi9udWxsCisrKyBiL2luY2x1ZGUvbGludXgv
cGVybm9kZV9jb3VudGVyLmgKQEAgLTAsMCArMSwxMTggQEAKKyNpZm5kZWYgX0xJTlVYX1BFUk5P
REVfQ09VTlRFUl9ICisjZGVmaW5lIF9MSU5VWF9QRVJOT0RFX0NPVU5URVJfSAorLyoKKyAqIEEg
c2ltcGxlIHBlciBub2RlIGF0b21pYyBjb3VudGVyIGZvciB1c2UgaW4gYmxvY2sgaW8gYWNjb3Vu
dGluZy4KKyAqLworCisjaW5jbHVkZSA8bGludXgvc21wLmg+CisjaW5jbHVkZSA8bGludXgvcGVy
Y3B1Lmg+CisjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4KKyNpbmNsdWRlIDxsaW51eC9nZnAuaD4K
Kworc3RydWN0IG5vZGVfY291bnRlciB7CisJYXRvbWljX3QgY291bnRlcl9pbl9ub2RlOworfTsK
Kworc3RydWN0IHBub2RlX2NvdW50ZXIgeworCXN0cnVjdCBub2RlX2NvdW50ZXIgKiBfX3BlcmNw
dSAgKmNvdW50ZXI7CisJc3RydWN0IG5vZGVfY291bnRlciAqKm5vZGVzOworfTsKKworc3RhdGlj
IGlubGluZSBpbnQgcG5vZGVfY291bnRlcl9pbml0KHN0cnVjdCBwbm9kZV9jb3VudGVyICpwbmMs
IGdmcF90IGdmcCkKK3sKKwlzdHJ1Y3Qgbm9kZV9jb3VudGVyICoqbm9kZXM7CisJaW50IGksIGos
IGNwdTsKKworCW5vZGVzID0ga3phbGxvYyhucl9ub2RlX2lkcyAqIHNpemVvZihzdHJ1Y3Qgbm9k
ZV9jb3VudGVyICopLCBnZnApOworCWlmICghbm9kZXMpCisJCWdvdG8gZXJyX25vZGVzOworCisJ
Zm9yX2VhY2hfbm9kZShpKSB7CisJCW5vZGVzW2ldID0ga3phbGxvY19ub2RlKHNpemVvZihzdHJ1
Y3Qgbm9kZV9jb3VudGVyKSwgZ2ZwLCBpKTsKKwkJaWYgKCFub2Rlc1tpXSkKKwkJCWdvdG8gZXJy
X25vZGVfY291bnRlcjsKKwl9CisKKwlwbmMtPmNvdW50ZXIgPSBhbGxvY19wZXJjcHVfZ2ZwKHN0
cnVjdCBub2RlX2NvdW50ZXIgKiwgZ2ZwKTsKKwlpZiAoIXBuYy0+Y291bnRlcikKKwkJZ290byBl
cnJfbm9kZV9jb3VudGVyOworCisJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkKKwkJKnBlcl9j
cHVfcHRyKHBuYy0+Y291bnRlciwgY3B1KSA9IG5vZGVzW2NwdV90b19ub2RlKGNwdSldOworCisJ
cG5jLT5ub2RlcyA9IG5vZGVzOworCisJcmV0dXJuIDA7CisKKyBlcnJfbm9kZV9jb3VudGVyOgor
CWZvciAoaiA9IDA7IGogPCBpOyBqKyspCisJCWtmcmVlKG5vZGVzW2pdKTsKKwlrZnJlZShub2Rl
cyk7CisgZXJyX25vZGVzOgorCXJldHVybiAtRU5PTUVNOworfQorCitzdGF0aWMgaW5saW5lIHZv
aWQgcG5vZGVfY291bnRlcl9kZWluaXQoc3RydWN0IHBub2RlX2NvdW50ZXIgKnBuYykKK3sKKwlp
bnQgY3B1OworCisJZm9yX2VhY2hfcG9zc2libGVfY3B1KGNwdSkgeworCQlzdHJ1Y3Qgbm9kZV9j
b3VudGVyICpub2RlID0gKnBlcl9jcHVfcHRyKHBuYy0+Y291bnRlciwgY3B1KTsKKworCQlrZnJl
ZShub2RlKTsKKwkJKnBlcl9jcHVfcHRyKHBuYy0+Y291bnRlciwgY3B1KSA9IE5VTEw7CisJfQor
CWZyZWVfcGVyY3B1KHBuYy0+Y291bnRlcik7CisJa2ZyZWUocG5jLT5ub2Rlcyk7Cit9CisKK3N0
YXRpYyBpbmxpbmUgdm9pZCBwbm9kZV9jb3VudGVyX2luYyhzdHJ1Y3QgcG5vZGVfY291bnRlciAq
cG5jKQoreworCXN0cnVjdCBub2RlX2NvdW50ZXIgKm5vZGUgPSB0aGlzX2NwdV9yZWFkKCpwbmMt
PmNvdW50ZXIpOworCisJYXRvbWljX2luYygmbm9kZS0+Y291bnRlcl9pbl9ub2RlKTsKK30KKwor
c3RhdGljIGlubGluZSB2b2lkIHBub2RlX2NvdW50ZXJfaW5jX2NwdShzdHJ1Y3QgcG5vZGVfY291
bnRlciAqcG5jLCBpbnQgY3B1KQoreworCXN0cnVjdCBub2RlX2NvdW50ZXIgKm5vZGUgPSAqcGVy
X2NwdV9wdHIocG5jLT5jb3VudGVyLCBjcHUpOworCisJYXRvbWljX2luYygmbm9kZS0+Y291bnRl
cl9pbl9ub2RlKTsKK30KKworc3RhdGljIGlubGluZSB2b2lkIHBub2RlX2NvdW50ZXJfZGVjKHN0
cnVjdCBwbm9kZV9jb3VudGVyICpwbmMpCit7CisJc3RydWN0IG5vZGVfY291bnRlciAqbm9kZSA9
IHRoaXNfY3B1X3JlYWQoKnBuYy0+Y291bnRlcik7CisKKwlhdG9taWNfZGVjKCZub2RlLT5jb3Vu
dGVyX2luX25vZGUpOworfQorCitzdGF0aWMgaW5saW5lIHZvaWQgcG5vZGVfY291bnRlcl9kZWNf
Y3B1KHN0cnVjdCBwbm9kZV9jb3VudGVyICpwbmMsIGludCBjcHUpCit7CisJc3RydWN0IG5vZGVf
Y291bnRlciAqbm9kZSA9ICpwZXJfY3B1X3B0cihwbmMtPmNvdW50ZXIsIGNwdSk7CisKKwlhdG9t
aWNfZGVjKCZub2RlLT5jb3VudGVyX2luX25vZGUpOworfQorCitzdGF0aWMgaW5saW5lIHZvaWQg
cG5vZGVfY291bnRlcl9zZXQoc3RydWN0IHBub2RlX2NvdW50ZXIgKnBuYywgaW50IHZhbCkKK3sK
KwlpbnQgaTsKKwlzdHJ1Y3Qgbm9kZV9jb3VudGVyICpub2RlID0gdGhpc19jcHVfcmVhZCgqcG5j
LT5jb3VudGVyKTsKKworCWZvcl9lYWNoX25vZGUoaSkKKwkJYXRvbWljX3NldCgmcG5jLT5ub2Rl
c1tpXS0+Y291bnRlcl9pbl9ub2RlLCAwKTsKKwlhdG9taWNfc2V0KCZub2RlLT5jb3VudGVyX2lu
X25vZGUsIHZhbCk7Cit9CisKK3N0YXRpYyBpbmxpbmUgbG9uZyBwbm9kZV9jb3VudGVyX3JlYWRf
YWxsKHN0cnVjdCBwbm9kZV9jb3VudGVyICpwbmMpCit7CisJaW50IGk7CisJbG9uZyB2YWwgPSAw
OworCisJZm9yX2VhY2hfbm9kZShpKQorCQl2YWwgKz0gYXRvbWljX3JlYWQoJnBuYy0+bm9kZXNb
aV0tPmNvdW50ZXJfaW5fbm9kZSk7CisKKwlyZXR1cm4gdmFsOworfQorCisjZW5kaWYgLyogX0xJ
TlVYX1BFUk5PREVfQ09VTlRFUl9IICovCg==
--001a11376f0037963005531bc0ea--
