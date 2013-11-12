From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-mpath: push back requests instead of
 queueing
Date: Tue, 12 Nov 2013 10:25:06 +0000
Message-ID: <11AF7C027C4C02408624617A49860784F0B09D@BPXM12GP.gisp.nec.co.jp>
References: <1383901339-81536-1-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784F0A5F4@BPXM12GP.gisp.nec.co.jp>
	<5281E403.5020005@suse.de>
	<11AF7C027C4C02408624617A49860784F0A9D8@BPXM12GP.gisp.nec.co.jp>
	<5281EF56.8030808@suse.de>
	<11AF7C027C4C02408624617A49860784F0AE9C@BPXM12GP.gisp.nec.co.jp>
	<52820047.9090103@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52820047.9090103@suse.de>
Content-Language: ja-JP
Content-ID: <6F47255AC8861D4887A7E54E4FACCB9B@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/12/13 19:17, Hannes Reinecke wrote:
> On 11/12/2013 11:00 AM, Junichi Nomura wrote:
>> On 11/12/13 18:05, Hannes Reinecke wrote:
> [ .. ]
>>> We _could_ optimize this in __switch_pg(), to call pgpath_busy()
>>> when selecting the paths. But that should be done by the path selector.
>>> So for that we would need to separate the functionality of the
>>> path selector and __switch_pg; currently it's unclear whether
>>> we need to call pgpath_busy() in __switch_pg or not.
>>
>> There is no need to call pgpath_busy in __switch_pg.
>>
>> If we call __pgpath_busy() in map function, I think it's here:
>>
>> 	if (pgpath) {
>> + 		if (__pgpath_busy(pgpath))
>> + 			r = DM_MAPIO_REQUEUE;
>> 		else if (pg_ready(m)) {
>> 			... // remap
>> 			r = DM_MAPIO_REMAPPED;
>> 		} else {
>> 			__pg_init_all_paths(m);
>> 			r = DM_MAPIO_REQUEUE;
>> 		}
>> 	...
>>
> Which is what I had in mind.

Great.

>> or in a path selector.
>>
> Hmm. The path selector might have a reason for selecting this
> particular path. So I'd prefer not to have it in there.

Yeah, that's my concern, too.

-- 
Jun'ichi Nomura, NEC Corporation
