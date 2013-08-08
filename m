From: Chaitra Bhat <Chaitra.Bhat@VERIFONE.com>
Subject: Re: dm-verity: Verification fails but do not see
 Input/Output Error on read
Date: Thu, 8 Aug 2013 13:47:15 +0000
Message-ID: <20847BF06520E04D933186677BF7B724D1F58F@VF2WDEXMB1.verifone.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
	<20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>,
	<alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1308080849500.15699@file01.intranet.prod.int.rdu2.redhat.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi Mikulas,

I get 'Invalid argument' with 'iflag=direct' option when I try to read from a verity device using dd. Before I read from the device, I also did 'echo 3 > /proc/sys/vm/drop_caches' to make sure caches are dropped.

But as I said before, some locations always fail with I/O error when read and others don't.

Regards,
Chaitra
________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] on behalf of Mikulas Patocka [mpatocka@redhat.com]
Sent: 08 August 2013 13:52
To: device-mapper development
Cc: Alasdair G Kergon
Subject: Re: [dm-devel] dm-verity: Verification fails but do not see Input/Output Error on read

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

- --
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

________________________________
This electronic message, including attachments, is intended only for the use of the individual or company named above or to which it is addressed. The information contained in this message shall be considered confidential and proprietary, and may include confidential work product. If you are not the intended recipient, please be aware that any unauthorized use, dissemination, distribution or copying of this message is strictly prohibited. If you have received this email in error, please notify the sender by replying to this message and deleting this email immediately.

-----BEGIN PGP SIGNATURE-----
Version: PGP Universal 3.2.0 (Build 2599)
Charset: us-ascii

wsFVAwUBUgOhd/oDVUR++NlrAQqnvRAAuAbHC7T53cO0nrh9/TlAt0GGuwWNP38G
+Aq0V8688jILCjca8pnMfnzgKlOMV26cTihbw2yhNG4O1+SuXp7Do21kv3VleW7o
fZxPSHoYcdBiJFj4dfGtZjpbECte0nE5xuFpgP18YD5jctixSvpGhQoxaJaWGfcU
lq88sDc5ixygu1f6eFheBZ1pdJJQnJygvMYC+tf1fJm/5rtYlIBRDqQ+L7V359vn
2/10EJE9TIZI4gPaVdJpzyft8pSNj1FKEUynBTZCCx9LuQ0iiC2M9aoMjdV6qXgW
7cACU2EkV+697BFamCLvQ6ZS1C6rWd6Ua5TffNBUon8wsSH2E0PzDRxLPhdPBRr/
wjoWaYz0DBJaCG7szCr0fjY54qX9Mrlc9Q8NMHxl7yCGiMC7rcrFU03/gtngUv+K
Ws6BlBtoy67nJOozaFQ+l5agI4Ces0SYHDebDmBFNBRee3WTHTXdWvJ0v8/sHIhR
cqlKrVqTShjAvWFqnIb8ryfkS8V2bBMp1AgeHHVoSVi+vY0LF4Tg0yDx1MNzPihd
BLGIZxZ6nC/uco6WZK3fMMQjAr/qbAt/VFKkQ7quo7BmNBJA6CnBZMzXV8dj4Gbf
ozaIt1CYlBo+7npfAkP2u7dZU4J0AZ0M9/Q2gMKe1YSf/F1qeaRJ9Je2ItguLrYV
6Y0pNBE5L+E=
=Ld/X
-----END PGP SIGNATURE-----
