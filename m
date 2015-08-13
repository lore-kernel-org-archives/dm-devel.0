From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Thu, 13 Aug 2015 08:04:42 +0200
Message-ID: <55CC337A.1050608@suse.de>
References: <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com> <20150731213831.GA16464@redhat.com> <1438412290.26596.14.camel@hasee> <20150801163356.GA21478@redhat.com> <1438581502.26596.24.camel@hasee> <20150804113626.GA12682@lst.de> <1438754604.29731.31.camel@hasee> <20150807073001.GA17485@lst.de> <1438990806.24452.8.camel@ssi> <55C5C348.1070307@suse.de> <20150808090205.GA15061@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150808090205.GA15061@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Neil@redhat.com, Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@canonical.com>, Al@redhat.com, Alasdair Kergon <agk@redhat.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, Nitin Gupta <ngupta@vflare.org>, Ming Lin <ming.l@ssi.samsung.com>, Oleg Drokin <oleg.drokin@intel.com>, Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Andreas Dilger <andreas.dilger@intel.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, Dongsu Park <dpark@posteo.net>, drbd-user@lists.linbit.com
List-Id: dm-devel.ids

On 08/08/2015 11:02 AM, Kent Overstreet wrote:
> On Sat, Aug 08, 2015 at 10:52:24AM +0200, Hannes Reinecke wrote:
>> Wouldn't it be easier to move both max_write_same_sectors and
>> max_discard sectors to 64 bit (ie to type sector_t) and be done with=
 the
>> overflow?
>> Seems to me this is far too much coding around self-imposed restrict=
ions...
>=20
> It's bio->bi_iter.bi_size that would have to be increased to 64 bits.=
 Which I
> suppose wouldn't actually increase the size of struct bio (when secto=
r_t is 64
> bits), since struct bvec_iter has padding right now...
>=20
Which I guess we should be doing anyway.
Devices are getting larger and larger, so in the long run in need to
be moved to 64 bits.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
