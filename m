From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-thin: optimize power of two block size
Date: Mon, 25 Jun 2012 15:09:38 +0100
Message-ID: <20120625140938.GB2417@ubuntu>
References: <Pine.LNX.4.64.1206181003170.22564@file.rdu.redhat.com>
	<20120618163536.GA3640@ubuntu>
	<Pine.LNX.4.64.1206242119150.21557@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206242119150.21557@file.rdu.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, Jun 24, 2012 at 09:53:22PM -0400, Mikulas Patocka wrote:
> So the conclusion is that is that that divide instruction degrades 
> transfer speed, especially on dm-stripe with 4k stripe size (on dm-thin it 
> is measurable only with raw read, the difference is smaller because it has 
> a minimum chunk size 64k).
> 
> 
> The question is why do you want to avoid such optimization?

You've conviced me.  I just wanted proof, which you've done very
nicely.  Thankyou.

> BTW. when unloading the dm-thin device with debugging enabled (the tests 
> were done with debugging disabled), I got this message:
> device-mapper: space map checker: free block counts differ, checker 
> 131060, sm-disk:130991
> --- so there is supposedly some bug? The kernel is 3.4.3.

That message is ok.  I'm going to remove the sm-checker in 3.6.  It's
not earning it's keep.

- Joe
