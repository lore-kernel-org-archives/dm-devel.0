From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 10:07:11 +0100
Message-ID: <8e062253-9513-bb62-c939-8b065d703cc9@gmail.com>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<OF6D9BF1A7.207DE4FF-ON48258073.002A20D1-48258074.000646A9@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF6D9BF1A7.207DE4FF-ON48258073.002A20D1-48258074.000646A9@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn, Benjamin Marzinski <bmarzins@redhat.com>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

Dne 23.11.2016 v 02:08 tang.junhui@zte.com.cn napsal(a):
> So, now we have at least 4 ways to improve mutliapth efficiency:
> 1)  Filtering uevents;
> 2)  Merger uevents;
> 3)  Using separate locks for mpvec and pathvec;
> 4)  Get rid of the gazillion waiter threads.
>
> This is exciting, but how do we achieve this blueprint?
> Can we set up some working groups and develop it in parallel
> to implement each improvement since most of them are independent?
>

I'm missing here the analysis of impact on performance.

Do we have 'perf' traces and other reports where is the CPU wasted ?

While surely solving all issues make sense - there are some tasks which have 
major impact on speed - while others user will most not notice at all.


Regards

Zdenek
