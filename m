From: Vijayendra Suman <vijayendra.suman@oracle.com>
Subject: Re: Revert "dm: always call blk_queue_split() in dm_process_bio()"
Date: Wed, 16 Sep 2020 20:26:17 +0530
Message-ID: <1e90b391-416e-b32d-681c-16a029e8bf54@oracle.com>
References: <529c2394-1b58-b9d8-d462-1f3de1b78ac8@oracle.com>
 <20200910142438.GA21919@redhat.com>
 <5261af10-bf5c-f768-dbeb-2e784a5823f9@oracle.com>
 <20200915013308.GA14877@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200915013308.GA14877@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, Somu Krishnasamy <somasundaram.krishnasamy@oracle.com>, dm-devel@redhat.com, RAMANAN_GOVINDARAJAN <ramanan.govindarajan@oracle.com>
List-Id: dm-devel.ids

Hello Mike,

On 9/15/2020 7:03 AM, Mike Snitzer wrote:
> On Thu, Sep 10 2020 at  3:29pm -0400,
> Vijayendra Suman <vijayendra.suman@oracle.com> wrote:
>
>> Hello Mike,
>>
>> I checked with upstream, performance measurement is similar and
>> shows performance improvement when
>> 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 is reverted.
>>
>> On 9/10/2020 7:54 PM, Mike Snitzer wrote:
>>> [cc'ing dm-devel and linux-block because this is upstream concern too]
>>>
>>> On Wed, Sep 09 2020 at  1:00pm -0400,
>>> Vijayendra Suman <vijayendra.suman@oracle.com> wrote:
>>>
>>>>     Hello Mike,
>>>>
>>>>     While Running pgbench tool with  5.4.17 kernel build
>>>>
>>>>     Following performance degrade is found out
>>>>
>>>>     buffer read/write metric : -17.2%
>>>>     cache read/write metric : -18.7%
>>>>     disk read/write metric : -19%
>>>>
>>>>     buffer
>>>>     number of transactions actually processed: 840972
>>>>     latency average = 24.013 ms
>>>>     tps = 4664.153934 (including connections establishing)
>>>>     tps = 4664.421492 (excluding connections establishing)
>>>>
>>>>     cache
>>>>     number of transactions actually processed: 551345
>>>>     latency average = 36.949 ms
>>>>     tps = 3031.223905 (including connections establishing)
>>>>     tps = 3031.402581 (excluding connections establishing)
>>>>
>>>>     After revert of Commit
>>>>     2892100bc85ae446088cebe0c00ba9b194c0ac9d ( Revert "dm: always call
>>>>     blk_queue_split() in dm_process_bio()")
>>> I assume 2892100bc85ae446088cebe0c00ba9b194c0ac9d is 5.4-stable's
>>> backport of upstream commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 ?
>> Yes
>>
>>>>     Performance is Counter measurement
>>>>
>>>>     buffer ->
>>>>     number of transactions actually processed: 1135735
>>>>     latency average = 17.799 ms
>>>>     tps = 6292.586749 (including connections establishing)
>>>>     tps = 6292.875089 (excluding connections establishing)
>>>>
>>>>     cache ->
>>>>     number of transactions actually processed: 648177
>>>>     latency average = 31.217 ms
>>>>     tps = 3587.755975 (including connections establishing)
>>>>     tps = 3587.966359 (excluding connections establishing)
>>>>
>>>>     Following is your commit
>>>>
>>>>     diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>>>     index cf71a2277d60..1e6e0c970e19 100644
>>>>     --- a/drivers/md/dm.c
>>>>     +++ b/drivers/md/dm.c
>>>>     @@ -1760,8 +1760,9 @@ static blk_qc_t dm_process_bio(struct mapped_device
>>>>     *md,
>>>>              * won't be imposed.
>>>>              */
>>>>             if (current->bio_list) {
>>>>     -               blk_queue_split(md->queue, &bio);
>>>>     -               if (!is_abnormal_io(bio))
>>>>     +               if (is_abnormal_io(bio))
>>>>     +                       blk_queue_split(md->queue, &bio);
>>>>     +               else
>>>>                             dm_queue_split(md, ti, &bio);
>>>>             }
>>>>
>>>>     Could you have a look if it is safe to revert this commit.
>>> No, it really isn't a good idea given what was documented in the commit
>>> header for commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74 -- the
>>> excessive splitting is not conducive to performance either.
>>>
>>> So I think we need to identify _why_ reverting this commit is causing
>>> such a performance improvement.  Why is calling blk_queue_split() before
>>> dm_queue_split() benefiting your pgbench workload?
>> Let me know if you want to check some patch.
> Hi,
>
> Could you please test this branch?:
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-5.10__;!!GqivPVa7Brio!MspX41fnl1XoqlkHjwMuNFk--2a9yMSV9IQMRazyHTKEPls1nuF37bSIum7ZAOLZGxk6kw$
> (or apply at least the first 4 patches, commit 63f85d97be69^..b6a80963621fa)

With above mentioned patch set, I get following results

buffer ->

number of transactions actually processed: 1001957
latency average = 20.135 ms
tps = 5562.323947 (including connections establishing)
tps = 5562.649168 (excluding connections establishing)

cache ->

number of transactions actually processed: 581273
latency average = 34.745 ms
tps = 3223.520038 (including connections establishing)
tps = 3223.717013 (excluding connections establishing)

With above patch there is performance improvement.

> So far I've done various DM regression testing.  But I haven't tested
> with pgbench or with the misaaligned IO scenario documented in the
> header for commit 120c9257f5f19e5d1e87efcbb5531b7cd81b7d74.  But I'll
> test that scenario tomorrow.
>
> Any chance you could provide some hints on how you're running pgbench
> just so I can try to test/reproduce/verify locally?
A PostgreSQL setup script will run as part of the setup within RUN to 
install the PostgreSQL DB, configure the /etc/postgresql.conf file and 
initialize the DB.
The RUN script will start the PostgreSQL service and bind it to running 
on half the cpu's, a DB will be created of a default size (I think 16M) 
and will be scaled up to the required size based on whether it is a 
buffer, cache or disk run.

After this, PostgreSQL pgbench will be run in readonly and readwrite 
modes (and be binded to the other half of the cpu's on the system).

Performance issue was seen on readwrite mode.

>
> Thanks,
> Mike
>
