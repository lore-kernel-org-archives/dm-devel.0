From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/7] dm: track the maximum number of bios in
 a cloned request
Date: Thu, 12 Sep 2013 19:09:11 -0400
Message-ID: <20130912230911.GB31577@redhat.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-7-git-send-email-snitzer@redhat.com>
	<alpine.LRH.2.02.1309121851160.31794@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1309121851160.31794@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

On Thu, Sep 12 2013 at  6:55pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> There's a race condition (it's not serious):
> 
> +               if (num_bios > ACCESS_ONCE(peak_rq_based_ios))
> +                       ACCESS_ONCE(peak_rq_based_ios) = num_bios;
> 
> You can double-check it using code like this:
> if (num_bios > ACCESS_ONCE(peak_rq_based_ios)) {
> 	spin_lock_irqsave(&peak_rq_based_ios_lock, flags);
> 	if (num_bios > peak_rq_based_ios)
> 		peak_rq_based_ios = num_bios;
> 	spin_unlock_irqrestore(&peak_rq_based_ios_lock, flags);
> }

Yeah I thought about using double checked locking but didn't want to
incur the extra locking.  Figured precise answer for peak_rq_based_ios
wasn't of utmost importance.  But I'll think about doing it.

> Maybe - reset the value peak_rq_based_ios if the user clears 
> track_peak_rq_based_ios?

Well until patch 7 there isn't a convenient place to trap the change.
And you already took issue with how I did it in that patch.
