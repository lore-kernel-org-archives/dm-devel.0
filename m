From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Wed, 28 Aug 2013 12:23:56 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308281223000.32659@file01.intranet.prod.int.rdu2.redhat.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308081256540.20081@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D231DC@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308142022070.14155@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B72401AF140E@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308221028030.25758@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B72401AF30DF@VF2WDEXMB1.verifone.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20847BF06520E04D933186677BF7B72401AF30DF@VF2WDEXMB1.verifone.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chaitra Bhat <Chaitra.Bhat@VERIFONE.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 28 Aug 2013, Chaitra Bhat wrote:

> Hi Mikulas,
> 
> Thanks for your e-mail. Yes, there was an error in the script which I 
> have fixed now.
> 
> Also, on further analysis found that the behaviour that I was seeing was 
> probably due to the dd command. When I read the verity device in 
> multiple of block-size after having corrupted the underlying verity 
> device, I always got I/O error. But if I tried to read back the specific 
> error location, I did not get an I/O error.

If you can reproduce the misbehavior, send a script that does it.

> Another odd behaviour - Create the verity target, corrupt the underlying 
> device, remove the mapping and establish the mapping again. Then read 
> the specific corrupted location through dd (not even block size), always 
> get an I/O error. Seems like some kind of caching being done when the 
> verity device is mapped - very odd.
> 
> Regards,
> Chaitra

Mikulas
