From: Chr <chunkeey@web.de>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Date: Sat, 15 Mar 2008 22:34:52 +0100
Message-ID: <200803152234.53199.chunkeey@web.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754752AbYCOVfJ@vger.kernel.org>
In-Reply-To: <200803151432.11125.chunkeey@web.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: David Chinner <dgc@sgi.com>, Christian Kujau <lists@nerdbynature.de>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, dm-crypt@saout.de
List-Id: dm-devel.ids

On Saturday 15 March 2008 14:32:10 Chr wrote:
> reverted:
>
> commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
> dm crypt: use async crypto
>
> dm-crypt: Use crypto ablkcipher interface
> Move encrypt/decrypt core to async crypto call.
>

well.... it's much better now, without the async interface.=20
Christian Kajau, can you confirm it too?=20

Regards,
	Christian
 =A0
