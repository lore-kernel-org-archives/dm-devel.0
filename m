From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm: fix AB-BA deadlock in __dm_destroy()
Date: Fri, 2 Oct 2015 02:45:09 +0000
Message-ID: <20151002024508.GA6581@xzibit.linux.bs1.fc.nec.co.jp>
References: <20151001083149.GA13075@xzibit.linux.bs1.fc.nec.co.jp>
	<20151001204500.GA29966@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151001204500.GA29966@redhat.com>
Content-Language: ja-JP
Content-ID: <9AA9A16C7BAC8C4B9522679708B059F6@gisp.nec.co.jp>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 10/02/15 05:45, Mike Snitzer wrote:
>> The problem could be reproduced with this script but it might take long.
>> (In my environment, it took more than 10 minutes)
> 
> Hi,
> 
> Thanks for fixing this.  What prompted you to chase this down?  Was it
> the work you were doing to reproduce Bart's blk-mq mpath failure that
> exposed this issue?

Yes. 

> FYI, interestingly, your fix looks to be applicable to this issue too:
> https://bugzilla.redhat.com/show_bug.cgi?id=1267650

Oh, good coincidence.

-- 
Jun'ichi Nomura, NEC Corporation
