From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH][RESEND] dm-zoned: Fix target BIO completion
 handling
Date: Thu, 6 Dec 2018 21:44:52 +0000
Message-ID: <BYAPR04MB5816B617C53829A18D72B7ADE7A90@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20181206212528.19502-1-damien.lemoal@wdc.com>
	<20181206214134.GA16120@redhat.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Mike,

On 2018/12/06 13:41, Mike Snitzer wrote:
> Yeap, I'm working on it. ;)
> 
> Do you have a strong preference for whether this lands in 4.20-rcX or is
> it OK to land in 4.21?

It is tricky to trigger the BUG_ON() but is does happen regularly in some of our
test systems with our test suite since rc3. So I would prefer to get the fix in
4.20-rc if possible.

Thanks !


-- 
Damien Le Moal
Western Digital Research
