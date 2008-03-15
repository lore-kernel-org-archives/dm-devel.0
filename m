From: Chr <chunkeey@web.de>
Subject: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Date: Sat, 15 Mar 2008 14:32:10 +0100
Message-ID: <200803151432.11125.chunkeey@web.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <47DA44EB.8000307@redhat.com> <200803150108.04008.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752982AbYCONc0@vger.kernel.org>
In-Reply-To: <200803150108.04008.chunkeey@web.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: David Chinner <dgc@sgi.com>, Christian Kujau <lists@nerdbynature.de>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, dm-crypt@saout.de
List-Id: dm-devel.ids

>On Sat, Mar 15, 2008 at 01:21:04AM +0100, Ulrich Lukas wrote:
>> With that patch applied, writing seems to work again.
>=A0
> Current version of the patch is below. =A0It's still not quite finish=
ed.
>
:-/, both patches freezes here...=20

I'll try to revert:

commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
dm crypt: use async crypto

dm-crypt: Use crypto ablkcipher interface
Move encrypt/decrypt core to async crypto call.

maybe it isn't the async stuff after all..

>> Btw, is this a regression because of the changed 2.6.25(-rc) code or=
 is
>> it just a coincidence that it worked before?
>
>Introduced during code changes to support async crypto interface.

Regards,
	Chr
=A0
