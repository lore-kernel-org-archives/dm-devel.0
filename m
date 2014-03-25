From: Akira Hayakawa <hayakawa@valinux.co.jp>
Subject: Re: [dm-devel] [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for
 open firmware SSDs
Date: Tue, 25 Mar 2014 11:22:17 +0900
Message-ID: <20140325112217.a3d34601d745ace3fbc07c0f@valinux.co.jp>
References: <1395383538-18019-1-git-send-email-m@bjorling.me>
	<1395383538-18019-2-git-send-email-m@bjorling.me>
	<20140321153749.GA17155@infradead.org>
	<532C67D0.4020501@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <532C67D0.4020501@bjorling.me>
Sender: linux-fsdevel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Matias Bjorling <m@bjorling.me>, Christoph Hellwig <hch@infradead.org>, snitzer@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

Hi, Matias,

Sorry for jumping in. I am interested in this new feature, too.

> > Does it even make sense to expose the underlying devices as block
> > devices?  It surely would help to send this together with a driver
> > that you plan to use it on top of.
> > 
> 
> Agree, an underlying driver is missing. My first plan is to get a draft
> firmware for the OpenSSD to be stable and expose its primitives
> (read/write/erase) up through the ATA/SCSI stack. Communicating using
> vendor specific codes.

Exposing FTL to the host layer has potential to share mapping in cache software (or driver) and the device.
The "Unified Address Space" in the slides below addresses the problem of two levels of indirection.
http://www1.unine.ch/eurosys2012/posters/saxena.pdf

Developing API to share mapping between driver and the device sounds interesting, too.

--
Akira
