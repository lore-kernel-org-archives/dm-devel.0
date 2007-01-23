From: Piet Delaney <piet@bluelane.com>
Subject: Re: [dm-crypt] Re: [stable][PATCH < 2.6.19] Fix data
	corruption with dm-crypt over RAID5
Date: Mon, 22 Jan 2007 18:19:15 -0800
Message-ID: <ep3rb5$qc8$1@sea.gmane.org>
References: <456B732F.6080906@lelik.org>
	<20061129145208.GQ4409@agk.surrey.redhat.com>
	<456F46E3.6030702@lelik.org>
	<1164983209.24524.20.camel@leto.intern.saout.de>
	<20061201152143.GE4409@agk.surrey.redhat.com>
	<45704B95.3020308@lelik.org>
	<1165026116.29307.18.camel@leto.intern.saout.de>
	<1165026476.29307.23.camel@leto.intern.saout.de>
	<1169023448.10964.244.camel@piet2.bluelane.com>
	<1169473139.1772.5.camel@leto.intern.saout.de>
Reply-To: piet@bluelane.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe Saout wrote:

> Am Mittwoch, den 17.01.2007, 00:44 -0800 schrieb Piet Delaney:
> 
>> I'm wondering about trying out your patch with dm-crypt on 2.6.12.
>> The code in drivers/md/dm-crypt.c`crypt_endio() appears to be the same.
> 
> Yes, it should apply as well.

I'll assume that also means that applying the patch is reasonable.

In our case we aren't using raid5; how ever we are using raid to mirror
two root partitions. Your explanation to Andrew indicates the problem should
only occur when using raid5. So applying the patch should be only have the
effect of making it now possible to use raid5 with dm-crypt. Since we are
currently running raid with root encryption it feels like it's better to
include your patch.

-piet

 
