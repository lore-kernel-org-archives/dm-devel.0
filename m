From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/2] dm-zoned: add 'status' and 'message'
	callbacks
Date: Tue, 24 Mar 2020 04:01:35 +0000
Message-ID: <CO2PR04MB2343C57FF66849427AE3098EE7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200323150352.107826-1-hare@suse.de>
	<20200323150352.107826-3-hare@suse.de>
	<CO2PR04MB23435B2F65967957A5055580E7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
	<20200324035945.GF30700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Johannes Thumshirn <jth@kernel.org>
List-Id: dm-devel.ids

On 2020/03/24 13:00, Mike Snitzer wrote:
> On Mon, Mar 23 2020 at 11:54pm -0400,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> On 2020/03/24 0:04, Hannes Reinecke wrote:
>>> Add callbacks to supply information for 'dmsetup status'
>>> and 'dmsetup info', and implement the message 'reclaim'
>>> to start the reclaim worker.
>>
>> This one is nice ! Can you send it out minus the cache changes ? We can use it
>> with unmodified dm-zoned :)
> 
> Yeah, I'm kind of stunned dm-zoned's lack of .status went unnoticeed
> until now ;)

My fault. I didn't notice that such feature existed in dm !
Sometimes I miss the most obvious :)

> 
> 


-- 
Damien Le Moal
Western Digital Research
