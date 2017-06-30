From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH RESEND] dm-raid: Do not call BUG() in
 __rdev_sectors()
Date: Fri, 30 Jun 2017 14:33:02 +0200
Message-ID: <317474e6-024d-553d-60ac-95570e70f979@redhat.com>
References: <1498637057-23221-1-git-send-email-hare@suse.de>
	<17f4e017-f3f8-01dd-d305-dae30f93ae06@redhat.com>
	<20170630073310.GD5236@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170630073310.GD5236@linux-x5ow.site>
Content-Language: de-CH
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On 06/30/2017 09:33 AM, Johannes Thumshirn wrote:
> On Thu, Jun 29, 2017 at 04:09:38PM +0200, Heinz Mauelshagen wrote:
>> Hi Hannes,
>>
>> thanks for your patch.
>>
>> BUG() is intentional there to catch what I've already fixed with patch
>>
>> "[dm-devel] [PATCH] dm raid: fix oops on upgrading to extended superblock
>> format"
>>
>> on 06/23/2017.
>>
>> IOW: returning 0 is never right and would hide bugs like that one fixed.
> OTOH panicing systems to catch errors which could've been mitigted is
> never right as well. Not a single time. Never. BUG() and BUG_ON() are not
> for error handling.

Point taken. We'll change that.

>
