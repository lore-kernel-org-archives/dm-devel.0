From: John Utz <John.Utz@wdc.com>
Subject: Re: creating a dm-linear.ko in a current kernel.
Date: Mon, 24 Feb 2014 22:44:19 +0000
Message-ID: <8A51900D08212F40B3DE22453052F6980B97CFA3@wdscexmb02>
References: <8A51900D08212F40B3DE22453052F6980B97CF4E@wdscexmb02>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8A51900D08212F40B3DE22453052F6980B97CF4E@wdscexmb02>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Solved my own issue methinks, the name of the module that i am finding in drivers/md/ is linear.ko, not dm-linear.ko. that was unexpected. i note further that there are other non 'dm- decorated' lkms in md as well, such as multipath, faulty, raid0, etc.

is there an implication associated with things decorated with dm- vs things not decorated with dm- in the md directory?

tnx!

johnu
________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] on behalf of John Utz [John.Utz@wdc.com]
Sent: Monday, February 24, 2014 2:01 PM
To: dm-devel@redhat.com
Subject: [dm-devel] creating a dm-linear.ko in a current kernel.

Hello;

I have a linear device that i am attempting to harness to device mapper.

My expectation that i developed based on my reading was that I could start from a dm-linear.c => dm-linear.ko and go from there.

But dm-linear.c gets linked into dm-mod.ko, not dm-linear.ko.

Has dm-linear always been part of dm-mod? i see some stuff on the net that implies the existence of dm-linear.ko, but i have poked around in menuconfig and i can find no specific entry to create it.

Any suggestions as to how to proceed would be greatly appreciated.

tnx!

johnu

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
