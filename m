From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Thu, 8 Aug 2013 08:52:21 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 8 Aug 2013, Chaitra Bhat wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> Hi Alasdair,
> 
> Thanks for your response.
> 
> But I am not convinced. Here is why...
>
> 1. I tried a bit-more and I was able to get Input/Output Error on 
> certain locations - everytime - I read that location. (But I still have 
> an open question that on some locations, though the verify reports 
> failure, I do not get an IO Error on read)
> 
> 2. I do not understand when you say device is live - do you mean 
> mounted? Because I thought that the whole idea of dm-verity was that 
> once the verity device is set-up, it would return EIO when something 
> gets corrupted in the data or hash partitions when that invalid data is 
> read.
> 
> Chaitra

It is possible that you are reading data from the buffer cache and not 
from the underlying device.

To not use the buffer cache, use iflag=direct parameter to dd.

Mikulas
