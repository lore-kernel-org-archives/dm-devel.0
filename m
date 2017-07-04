From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [dm-devel] [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Tue, 4 Jul 2017 15:57:01 -0600
Message-ID: <2538d533-0518-98f7-4bbd-716599a19c9a@kernel.dk>
References: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
 <c91629be-26db-96bb-9a55-18a6861888b2@kernel.dk>
 <CACVXFVMG=gD1Dq2SRKxhfPS33mzCC_dkSpVoYskaLE7PXV7xGQ@mail.gmail.com>
 <7f0a852e-5f90-4c63-9a43-a4180557530c@kernel.dk>
 <07ba10a8-6369-c1bc-dc9a-b550d9394c22@kernel.dk>
 <8f4ff428-e158-0df5-cf54-ae3cdea7ad1f@kernel.dk>
 <CACVXFVOW21vSOM0RGa-g0UFPRm91b9U16bruqXXYd=D+u7GKFQ@mail.gmail.com>
 <b462c167-53e9-11f8-583a-9984ef81fe0c@kernel.dk>
 <3729482c-fcca-2af5-4d05-7e44bcd71159@linux.vnet.ibm.com>
 <0759ff58-caa0-9e55-b5ac-6324d9ba521b@kernel.dk>
 <cf23ad83-5938-8256-5b32-f40c0d261508@kernel.dk>
 <0aedc83b-17a0-14bd-bacd-e11e1b7c263c@kernel.dk>
 <5cfc618b-eb03-fe1b-6429-189c0b3d3fc1@kernel.dk>
 <1c4c3849-ab98-9d5b-a31d-8ff35416ac23@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1c4c3849-ab98-9d5b-a31d-8ff35416ac23@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, Ming Lei <tom.leiming@gmail.com>
Cc: linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 07/04/2017 02:55 PM, Brian King wrote:
> On 07/01/2017 11:43 AM, Jens Axboe wrote:
>> Now:
>>
>> http://git.kernel.dk/cgit/linux-block/commit/?h=mq-inflight&id=87f73ef2b9edb6834001df8f7cb48c7a116e8cd3
>>
>>> And updated the branch here:
>>>
>>> http://git.kernel.dk/cgit/linux-block/log/?h=mq-inflight
>>>
>>> to include that, and be based on top of for-4.13/block. If you prefer just
>>> pulling a branch, pull:
>>>
>>> git://git.kernel.dk/linux-block mq-inflight
>>
>> I've tested it, and made a few adjustments and fixes. The branches are
>> the same, just rebased. Works fine for me, even with partitions now.
>>
>> Let me know how it works for you.
> 
> This is looking very nice. This is what I'm seeing now:
> 
> 1 null_blk device / 80 submit_queues / fio numjobs=80
> 9.4M IOPs
> 
> 80 null_blk devices / 1 submit_queue per null_blk / fio numjobs=1 (1 per null_blk)
> 9.3M IOPs
> 
> 1 null_blk device / 160 submit_queues / fio numjobs=160
> 9.8M IOPs
> 
> 160 null_blk devices / 1 submit_queue per null_blk / fio numjobs=1 (1 per null_blk)
> 8.9M IOPs
> 
> What is queued in mq-inflight looks to resolve the issue I've been seeing.

Good to hear! I'll test some corner cases and post a "real" version
for review. Thanks for all your testing.

-- 
Jens Axboe
