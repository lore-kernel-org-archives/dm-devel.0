From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/1] block: rework flush sequencing for blk-mq
Date: Mon, 17 Mar 2014 11:55:18 +0000
Message-ID: <5326E2A6.4080405@redhat.com>
References: <20140130132630.GB6031@infradead.org> <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com> <20140308155240.GA32297@infradead.org> <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com> <531B74B6.4070004@suse.de> <20140312102849.GA26509@infradead.org> <20140313161347.GA6598@redhat.com> <20140314092519.GA10139@infradead.org> <20140314130021.GA12589@redhat.com> <20140314132323.GA14606@infradead.org> <20140314141301.GA13112@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140314141301.GA13112@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>
List-Id: dm-devel.ids

On 03/14/2014 02:13 PM, Mike Snitzer wrote:
> Yeah, not sure why single path scsi_debug "just works", maybe it is a
> "feature" of the older multipathd I have kicking around?, but for basic
> data path testing scsi_debug is a quick means to an end.  I can look
> closer at _why_ it gets multipathd in a bit.  But maybe Ben or Hannes
> will have quicker insight?

Do you have find_multipaths set in multipath.conf? It defaults to off.
If it's enabled then multipath will only create maps for WWIDs it
already knows about (listed in /etc/multipath/wwids) unless there are at
least two devices with the same WWID or the user forces the operation:

Mar 17 12:26:50 | checking if sdm should be multipathed
Mar 17 12:26:50 | wwid 35333333000000000 not in wwids file, skipping sdm

Turn it off and multipath will happily map a single path scsi_debug for me:

# multipath
create: mpathg (35333333000000000) undef Linux,scsi_debug
size=1.0G features='0' hwhandler='0' wp=undef
`-+- policy='round-robin 0' prio=1 status=undef
  `- 8:0:0:0 sdm 8:192 undef ready  running

Iirc this is enabled on at least some current distros by default to
avoid creating maps for USB keys and the like.

Regards,
Bryn.
