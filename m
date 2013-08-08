From: Chaitra Bhat <Chaitra.Bhat@VERIFONE.com>
Subject: Re: dm-verity: Verification fails but do not
	see	Input/Output Error on read
Date: Thu, 8 Aug 2013 12:35:06 +0000
Message-ID: <20847BF06520E04D933186677BF7B724D1F55D@VF2WDEXMB1.verifone.com>
References: <20847BF06520E04D933186677BF7B724D1F523@VF2WDEXMB1.verifone.com>,
	<20130808121858.GB31819@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130808121858.GB31819@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi Alasdair,

Thanks for your response.

But I am not convinced. Here is why...
1. I tried a bit-more and I was able to get Input/Output Error on certain locations - everytime - I read that location.
(But I still have an open question that on some locations, though the verify reports failure, I do not get an IO Error on read)

2. I do not understand when you say device is live - do you mean mounted? Because I thought that the whole idea of dm-verity was that once the verity device is set-up, it would return EIO when something gets corrupted in the data or hash partitions when that invalid data is read.

Chaitra
________________________________________
From: Alasdair G Kergon [agk@redhat.com]
Sent: 08 August 2013 13:18
To: Chaitra Bhat
Cc: dm-devel@redhat.com; Mikulas Patocka
Subject: Re: [dm-devel] dm-verity: Verification fails but do not see    Input/Output Error on read

On Thu, Aug 08, 2013 at 09:01:44AM +0000, Chaitra Bhat wrote:
> So, any idea why do I not get Input/Output Error message when I know that verification is failing at that location?

I think it only verifies the data the first time it is read and doesn't check
for changes underneath while the device is live.

Alasdair


________________________________
This electronic message, including attachments, is intended only for the use of the individual or company named above or to which it is addressed. The information contained in this message shall be considered confidential and proprietary, and may include confidential work product. If you are not the intended recipient, please be aware that any unauthorized use, dissemination, distribution or copying of this message is strictly prohibited. If you have received this email in error, please notify the sender by replying to this message and deleting this email immediately.

-----BEGIN PGP SIGNATURE-----
Version: PGP Universal 3.2.0 (Build 2599)
Charset: us-ascii

wsFVAwUBUgORJfoDVUR++NlrAQp+ww/+MOcAtZq+aepO/OgxJC04gYombsP3DuvC
JA8nCMBYBOr85BLObkcs5lWQojMV2RWgCRDJjmQcrDiLs+4H6T+rQBirvhByfkQm
WLrX1zmKbGYzYdmhASSpMqrOCpNucfX+IqFKhwHg2cjVFKcQ+SFnkEPjVK1SsQZl
87BUf8RoHkY6Sr6wmaYshrLFgkeS0x2Mx8eLvZX9Cak7guz6b7e8HVz5WKl37mNI
d5ColhZvRLAab+nEJBdlxPGubDguAGmmeShXdsAUrwQRK7wSQYFQthTBh3J4tsv9
PgZGwbEfU6+1/bDZfUX08RdM60t62HyFuPBwXWNplAFKyq7Z5T3OCcmMGqYd0MQA
ApyWAZiB6H9PPsWz9L4CEnuKfMVA45b9kBoL+Zh4Q4Rqvwm0PhoDyxkieVht1o15
WAM4evJsZuKce4ed7lqlqgQHCwYf7A2MVrhUdRTkG3fiqpfrThi2LTngN18PzORI
dEe8/cuxapYsDL+T4dXJSx7PFFHzBwlAjFPVvwr4sv+IzOaBUXNHV4/I9N2rjciO
RvZj4F04kVUjPqdjhqcxbAktwe0fa+GNhwdBrxhFChJ+5emlyyhSeOo5lSD2Wpq5
cXhmOZEjTGXqU4Iz4PTvH72OSceJoO8bi9FHa2+bVMCXsamJv5VnS7E63gkWvLDf
Nkd1ojmA9SE=
=OUWm
-----END PGP SIGNATURE-----
