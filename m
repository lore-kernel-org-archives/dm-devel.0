From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Mon, 18 Apr 2011 05:19:59 -0400
Message-ID: <20110418091959.GA32013@infradead.org>
References: <20110411205928.13915719@notabene.brown>
 <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110418081922.1651474a@notabene.brown>
 <4DABDC60.2090009@fusionio.com>
 <20110418172551.55629fc6@notabene.brown>
 <4DABF1EA.3070301@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DABF1EA.3070301@fusionio.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Btw, I really start to wonder if the request level is the right place
to do this on-stack plugging.  Wouldn't it be better to just plug
bios in the on-stack queue?  That way we could also stop doing the
special case merging when adding to the plug list, and leave all the
merging / I/O schedule logic in the __make_request path.  Probably
not .39 material, but worth a prototype?

Also what this dicussion brought up is that the block layer data
structures are highly confusing.  Using a small subset of the
request_queue also for make_request based driver just doesn't make
sense.  It seems like we should try to migrate the required state
to struct gendisk, and submit I/O through a block_device_ops.submit
method, leaving the request_queue as an internal abstraction for
the request based drivers.

