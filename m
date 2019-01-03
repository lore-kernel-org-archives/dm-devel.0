From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [git pull] device mapper changes for 4.21
Date: Thu, 3 Jan 2019 08:45:27 +0100
Message-ID: <b527fb75-340e-c3ba-7cc7-97dd466e6780@gmail.com>
References: <20181227160944.GA12190@redhat.com>
	<20181230090646.GB1022@infradead.org>
	<alpine.LRH.2.02.1812301413220.7178@file01.intranet.prod.int.rdu2.redhat.com>
	<CAHk-=wh89gmqGaK4K7+ns9S6CSeCfuUmiy8GPeVz8_ntMz-DYg@mail.gmail.com>
	<20190103072754.GA2667@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190103072754.GA2667@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sweet Tea <sweettea@redhat.com>, wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, AliOS system security <alios_sys_security@linux.alibaba.com>, Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Shenghui Wang <shhuiw@foxmail.com>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Colin Ian King <colin.king@canonical.com>, Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 03/01/2019 08:27, Christoph Hellwig wrote:
> On Sun, Dec 30, 2018 at 04:25:46PM -0800, Linus Torvalds wrote:
>> On Sun, Dec 30, 2018 at 11:15 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>
>>> But you're right that 2TiB devices are common and that perhaps this option
>>> should go away.
>>
>> 2TiB devices are definitely not common in the one situation where this
>> option might matter: small embedded devices.
>>
>> I don't think the cost of 64 bit is in the arithmetic, but it might be
>> in some of the data structures.
>>
>> But my gut feel is that it probably doesn't much matter, and we could
>> get rid of the config option without anybody ever noticing. I don't
>> think we have that many data structures with 'sector_t' in them.
>>
>> We might try to first just force the option on, and see if anybody even cares.
> 
> Our smallest embedded devices use raw flash using the MTD subsystem,
> and even that is using 64-bit size types everywhere.  So I'd be really
> surprised if it is an issue.

I agree with Christoph here.

(I fixed some CONFIG_LBDAF problems in DM in this pull request because
the code was apparently wrong, but it was a pain to see all these possible
sector overflow checks...)

If it helps anything, we require 64-bit calculations for cryptsetup userspace for >5 years
(you cannot compile it with 32bit support; everything uses 64bit, including these
DM table sector calculations for kernel) and NOBODY complained since we enforced it.
(Ok, it is not a hot path, but....)

Please, if possible, go with 64-bit sector size types by default in future.

Thanks,
Milan
