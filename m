From: Chr <chunkeey@web.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Sat, 15 Mar 2008 01:08:03 +0100
Message-ID: <200803150108.04008.chunkeey@web.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <47DA44EB.8000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757944AbYCOAIV@vger.kernel.org>
In-Reply-To: <47DA44EB.8000307@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: David Chinner <dgc@sgi.com>, Christian Kujau <lists@nerdbynature.de>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Friday 14 March 2008 10:27:07 Milan Broz wrote:
>
> > Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> > history of exposing dm-crypt bugs, and these hangs appear to be I/O
> > congestion/scheduling related and not XFS. Also, we haven't changed
> > anything related to plug/unplug of block devices in XFS recently, so
> > that also points to some other change as well...
>
> Yes, there is bug in dm-crypt...
> Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71
>
hmm, :-/

stuck again... (tried the patch on top of 2.6.25-rc5 and 2.6.25-rc5-git4)

SYS-RQ (several times) T+W+Q 
right here:
http://www.pastebin.ca/943145

Regards,
	Christian
