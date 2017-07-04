From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH 1/1] block: Convert hd_struct in_flight from
 atomic to percpu
Date: Tue, 4 Jul 2017 15:58:00 -0500
Message-ID: <f562cc7a-819e-a130-e536-7b80247da49c@linux.vnet.ibm.com>
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
 <ca8ccbe7-beb6-bc0a-046c-b999004f0157@linux.vnet.ibm.com>
 <CACVXFVPpJBB5ieHg5nwyC4NF3Qd+W-TKJMFB-Qm4cVYK2B6M1w@mail.gmail.com>
 <599ba934-902d-d6ce-5a5a-9b32657b4a08@kernel.dk>
 <3053d21a-3619-498f-bf3c-921ee3e8c532@linux.vnet.ibm.com>
 <CACVXFVNQa_6Wrnx7Px1VRU+YuXqX+0y5SwyUvWGrv=ZrF_qPFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CACVXFVNQa_6Wrnx7Px1VRU+YuXqX+0y5SwyUvWGrv=ZrF_qPFg@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 07/03/2017 08:20 PM, Ming Lei wrote:
>> Right. So the two modes I'm running in are:
>>
>> 1. 80 null_blk devices, each with one submit_queue, with one fio job per null_blk device,
>>    so 80 threads total. 80 logical CPUs
>> 2. 1 null_blk device, with 80 submit_queues, 80 fio jobs, 80 logical CPUs.
>>
>> In theory, the two should result in similar numbers.
>>
>> Here are the commands and fio configurations:
>>
>> Scenario #1
>> modprobe null_blk submit_queues=80 nr_devices=1 irqmode=0
>>
>> FIO config:
>> [global]
>> buffered=0
>> invalidate=1
>> bs=4k
>> iodepth=64
>> numjobs=80
>> group_reporting=1
>> rw=randrw
>> rwmixread=100
>> rwmixwrite=0
>> ioengine=libaio
>> runtime=60
>> time_based
>>
>> [job1]
>> filename=/dev/nullb0

> 
> IMO it should be more reasonable to use single null_blk with 80 queues
> via setting submit_queues as 80 than simply 80 null_blks.  So suggest to switch
> to test 80 queues in your future test.

That should be what my Scenario #1 covers. 

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
