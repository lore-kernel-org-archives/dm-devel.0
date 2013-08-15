From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Wed, 14 Aug 2013 20:23:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308142022070.14155@file01.intranet.prod.int.rdu2.redhat.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308081256540.20081@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D231DC@VF2WDEXMB1.verifone.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20847BF06520E04D933186677BF7B724D231DC@VF2WDEXMB1.verifone.com>
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

On Tue, 13 Aug 2013, Chaitra Bhat wrote:

> Hi Mikulas,
> 
> I figured out what was happening - but I would need your help to explain 
> these behaviours please :)
> 
> Case I - Format the hash device, verify and create the dm-verity target. 
> Then modify data in the underlying data-device using dd. Read back the 
> data from the modified location from the verity-device.
> 
> Result: Verify fails but 'NO' I/O error reported when reading back from 
> the location using dd.

So, create a script that results in this scenario of not reporting I/O 
error and send it to us.

Mikulas

> Case II - Format the hash device, verify and create the dm-verity target 
> device. Remove the verity target, then modify the data in the 
> data-device using dd. Load the verity target and read-back the data from 
> the verity-device from the modified location.
> 
> Result: Verify fails and also get I/O error on reading that location 
> using dd.
> 
> My understanding was that the verity-device could be created and mounted 
> and then if the underlying data was corrupted somehow, then a read of 
> invalid data from that corrupted location will return -EIO.
> 
> Chaitra
> 
> PS: I was following the examples in the verity-compat-test script.
