From: Krzysztof =?UTF-8?Q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: newbie question regarding target_type's map callback
Date: Sun, 19 Jun 2011 14:33:17 +0200
Message-ID: <1308486797.23392.654.camel@linux-zhyd.site>
References: <1308412649.23392.621.camel@linux-zhyd.site>
	<20110619014806.GI19996@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110619014806.GI19996@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, 2011-06-19 at 02:48 +0100, Alasdair G Kergon wrote:
> All I can suggest is studying the existing upstream targets to
> understand better how they work and perhaps avoid problems like the ones
> you are seeing.

How about DM_MAPIO_REQUEUE ?


> 
> What is your target trying to do?

it is just a simple model target now which passes back requests from
inbox queue to dm_io() on a single backend dev in context of target's
work queue.

> (Why is split_io important? 

well, for same reason like dm-stripe. i may need this in the future for
switching backend devices dynamically according to bio LBA. This is why
i want to have a bio of size not bigger than split_io.


>  Did you implement a merge fn?)


no, i didn't. i don't know a purpose of merge fn.

I can see that e.g. dm-stripe doesn't use this callback in 2.6.33 kernel
while dm-stripe from 2.6.39 uses it.

furthermore dm-linear from 2.6.33 and .39 utilize .merge but split_io is
0.

> 
> Alasdair
> 


-- 
Krzysztof Blaszkowski
