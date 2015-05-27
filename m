From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm: Fix oops when clone_and_map_rq returns
	!DM_MAPIO_REMAPPED
Date: Wed, 27 May 2015 22:48:15 +0000
Message-ID: <556649AF.4050303@ce.jp.nec.com>
References: <5565466F.3@ce.jp.nec.com> <20150527132253.GA16050@redhat.com>
	<20150527135012.GB16050@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150527135012.GB16050@redhat.com>
Content-Language: ja-JP
Content-ID: <7736E32F56E7524CB8B8BBF7C8E74955@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/27/15 22:50, Mike Snitzer wrote:
>> Hi Junichi,
>>
>> In reviewing this patch I wondered if it better to xplicitly check for a
>> return of DM_MAPIO_REQUEUE in map_request() since that is the only other
>> return that is possible.  I'm still on the fence but your patch is more
>> conservative and at least we won't go on to try to setup_clone, etc if
>> for some reason in the future a new DM_MAPIO_* were invented and
>> returned from clone_and_map_rq().

Either way should work. But I wanted to make it explicit
to call setup_clone() only when DM_MAPIO_REMAPPED is returned.

>> I do intend to revise the header slightly to make explicit references to
>> function names in some places to improve clarity.  I'll have to double
>> check but I _think_ this should cc stable@ too since blk-mq support was
>> added in Linux 4.0 (IIRC).
> 
> FYI, here is the revised header:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.1&id=3a1407559a593d4360af12dd2df5296bf8eb0d28

Thanks for the nice revision.

-- 
Jun'ichi Nomura, NEC Corporation
