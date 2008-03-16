From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120
 seconds
Date: Sun, 16 Mar 2008 14:08:41 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de> <200803152234.53199.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752723AbYCPNKA@vger.kernel.org>
In-Reply-To: <200803152234.53199.chunkeey@web.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Chr <chunkeey@web.de>
Cc: Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, dm-crypt@saout.de
List-Id: dm-devel.ids

On Sat, 15 Mar 2008, Chr wrote:
> On Saturday 15 March 2008 14:32:10 Chr wrote:
>> reverted:
>>
>> commit  3a7f6c990ad04e6f576a159876c602d14d6f7fef
>> dm crypt: use async crypto
>>
>> dm-crypt: Use crypto ablkcipher interface
>> Move encrypt/decrypt core to async crypto call.
>>
>
> well.... it's much better now, without the async interface.
> Christian Kajau, can you confirm it too?

I reverted the commit above from today's -git and booted....I could not 
notice any hangs more. But when I tried to reproduce these hangs by 
generating disk I/O (mostly reads) ~10 minutes later the box panicked, but
still not netconsole messages :-(

thanks,
C.
-- 
BOFH excuse #233:

TCP/IP UDP alarm threshold is set too low.
