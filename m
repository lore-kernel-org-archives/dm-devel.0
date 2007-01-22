From: Christophe Saout <christophe@saout.de>
Subject: Re: [dm-crypt] Re: [stable][PATCH < 2.6.19] Fix data
	corruption with dm-crypt over RAID5
Date: Mon, 22 Jan 2007 14:38:59 +0100
Message-ID: <1169473139.1772.5.camel@leto.intern.saout.de>
References: <456B732F.6080906@lelik.org>
	<20061129145208.GQ4409@agk.surrey.redhat.com>
	<456F46E3.6030702@lelik.org>
	<1164983209.24524.20.camel@leto.intern.saout.de>
	<20061201152143.GE4409@agk.surrey.redhat.com>
	<45704B95.3020308@lelik.org>
	<1165026116.29307.18.camel@leto.intern.saout.de>
	<1165026476.29307.23.camel@leto.intern.saout.de>
	<1169023448.10964.244.camel@piet2.bluelane.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1169023448.10964.244.camel@piet2.bluelane.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: piet@bluelane.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Am Mittwoch, den 17.01.2007, 00:44 -0800 schrieb Piet Delaney:

> I'm wondering about trying out your patch with dm-crypt on 2.6.12. 
> The code in drivers/md/dm-crypt.c`crypt_endio() appears to be the same.

Yes, it should apply as well.

> Is there a reason that this isn't necessary or would be a bad idea.
> Looks like the existing code isn't checking the BIO_UPTODATE flag
> before doing the bio_put(). Looks the the second part of not calling
> kcryptd_queue_io() and forwarding the processing to the cryptd is
> effectively the same. The 1st change will set error if BIO_UPTODATE
> isn't set and that will cause the 2nd change to skip calling 
> kcryptd_queue_io().

Correct.

> I'm not sure about the change in the arg to bio_data_dir() 
> changing from bio to io->bio. Perhaps they are equivalent;
> care to comment on that.

It's just to fix the use-after-free case, apart from that all bio's
involved have the same data direction, of course.

PS: Sorry because of the Wiki defacement, when I find some time I will
look into it. Just reverting won't help this time as the bots are
currently changing the pages at least once per hour.
