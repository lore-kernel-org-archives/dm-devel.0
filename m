From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Thu, 22 Aug 2013 10:32:32 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308221028030.25758@file01.intranet.prod.int.rdu2.redhat.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308081256540.20081@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B724D231DC@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308142022070.14155@file01.intranet.prod.int.rdu2.redhat.com>
	<20847BF06520E04D933186677BF7B72401AF140E@VF2WDEXMB1.verifone.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20847BF06520E04D933186677BF7B72401AF140E@VF2WDEXMB1.verifone.com>
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

Hi

There is a bug in the script - there is:
$VERITYSETUP create $DEV_NAME $DEV_PARAMS $VERIFY_PARAMS $2 >>$DEV_OUT 
2>&1 && \
	fail "activation"

There should be "||" instead of "&&", so that the function fail is 
executed on failure.

If I replace "&&" with "||", the script behaves as expected - it fails and 
writes this:
# check_root_hash  512 9de18652fe74edfb9b805aaed72ae2aa48f94333f1ba5c452ac33b1c39325174 $SALT 1 sha256 2
[root hash][verify][activate][remove]verify fails
FAILED
VERITY header information for verity-hash
UUID:                   613837c4-6ca8-4add-a2e9-c1acfd5c8e96
Hash type:              1
Data blocks:            16384
Data block size:        512
Hash block size:        512
Hash algorithm:         sha256
Salt:                   
e48da609055204e89ae53b655ca2216dd983cf3cb829f34f63a297d106d53e2d
Root hash:              
9de18652fe74edfb9b805aaed72ae2aa48f94333f1ba5c452ac33b1c39325174
Verification failed at position 3072.
Verification of data area failed.
exit

Mikulas


On Thu, 15 Aug 2013, Chaitra Bhat wrote:

> Hi Mikulas,
> 
> I have attached a simple script to demonstrate what I was trying to tell. It is based on the verify-compat-test script. Feel free to modify the script; the script is basically to get the idea across.
> 
> For the Successful Case
> #source script_test
> #check_root_hash  512 9de18652fe74edfb9b805aaed72ae2aa48f94333f1ba5c452ac33b1c39325174 $SALT 1 sha256 2
> 
> For the Failure Case
> #source script_test
> #check_root_hash  512 9de18652fe74edfb9b805aaed72ae2aa48f94333f1ba5c452ac33b1c39325174 $SALT 1 sha256 1
> 
> Regards,
> Chaitra
> ________________________________________
> From: Mikulas Patocka [mpatocka@redhat.com]
> Sent: 15 August 2013 01:23
> To: Chaitra Bhat
> Cc: device-mapper development; Alasdair G Kergon
> Subject: RE: [dm-devel] dm-verity: Verification fails but do not see Input/Output Error on read
> 
> On Tue, 13 Aug 2013, Chaitra Bhat wrote:
> 
> > Hi Mikulas,
> >
> > I figured out what was happening - but I would need your help to explain
> > these behaviours please :)
> >
> > Case I - Format the hash device, verify and create the dm-verity target.
> > Then modify data in the underlying data-device using dd. Read back the
> > data from the modified location from the verity-device.
> >
> > Result: Verify fails but 'NO' I/O error reported when reading back from
> > the location using dd.
> 
> So, create a script that results in this scenario of not reporting I/O
> error and send it to us.
> 
> Mikulas
> 
> > Case II - Format the hash device, verify and create the dm-verity target
> > device. Remove the verity target, then modify the data in the
> > data-device using dd. Load the verity target and read-back the data from
> > the verity-device from the modified location.
> >
> > Result: Verify fails and also get I/O error on reading that location
> > using dd.
> >
> > My understanding was that the verity-device could be created and mounted
> > and then if the underlying data was corrupted somehow, then a read of
> > invalid data from that corrupted location will return -EIO.
> >
> > Chaitra
> >
> > PS: I was following the examples in the verity-compat-test script.
> 
> ________________________________
> This electronic message, including attachments, is intended only for the use of the individual or company named above or to which it is addressed. The information contained in this message shall be considered confidential and proprietary, and may include confidential work product. If you are not the intended recipient, please be aware that any unauthorized use, dissemination, distribution or copying of this message is strictly prohibited. If you have received this email in error, please notify the sender by replying to this message and deleting this email immediately.
> 
