From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: fix corrupted thin pool
Date: Sat, 25 Oct 2014 14:43:09 +0200
Message-ID: <544B9ADD.6040607@redhat.com>
References: <CACaajQsU_z8pwUGMHfD1y2dVkP_gKgajM6bBV1wFpxpF_7m1nA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACaajQsU_z8pwUGMHfD1y2dVkP_gKgajM6bBV1wFpxpF_7m1nA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, LVM <linux-lvm@redhat.com>
List-Id: dm-devel.ids

Dne 24.10.2014 v 21:59 Vasiliy Tolstov napsal(a):
> Hello! By mistake i'm restore by vcfgrestore thin volume, after that i
> have errors on this thin pool on all volumes like :
>   lvchange -ay vg1/2735
>    Thin pool transaction_id=120, while expected: 114.
> Does it possible to recovery from this? I'm try lvconvert --recover
> and get tp1_tmeta0 but i'm don't understand whan i need to do next..?
>
>

Hi

I'm not sure how you could do that 'by a mistake' since LVM is printing pretty 
BIG WARNING that any vgcfgrestore with thin should be done after big thinking 
and requires even extra --force option.

But anyway -  if you have  /etc/lvm/archive - you should probably be able to
find the 'right' version of lvm2 metadata for your kernel metadata.

However 'normally' you could be off the sequence number only by one! so
I'm quite curious what you've been able to make such big difference.

If you could - package /etc/lvm/archive  so I could get closer look where the 
lvm2 has holes to allow such operations ?

Which version of lvm2 and kernel is here in use ?

Have you been manipulating with  thin-pool's metadata in any way ?

Regards

Zdenek
