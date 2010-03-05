From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
	checks
Date: Fri, 5 Mar 2010 22:27:48 +0000
Message-ID: <20100305222748.GT27852@agk-dp.fab.redhat.com>
References: <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com> <87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com> <87lje9kx9i.fsf@openvz.org> <20100303200734.GW5768@kernel.dk> <Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com> <20100304121931.GB5768@kernel.dk> <Pine.LNX.4.64.1003041615120.17032@hs20-bc2-1.build.redhat.com> <20100305073059.GI5768@kernel.dk> <20100306085651.1a571571@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100306085651.1a571571@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@red>
List-Id: dm-devel.ids

On Sat, Mar 06, 2010 at 08:56:51AM +1100, Neil Brown wrote:
> My preferred end-game would be to allow a bio of any size to be submitted to
> any device.  The device would be responsible for cutting it up if necessary.

From the dm point of view, splitting is undesirable - memory allocations from
separate mempools, submitting the split-off parts could reorder/delay but must
still respect barrier constraints etc.  Splitting is the 'slow and complicated'
path for us.  We support it, but it is simpler and more efficient if the bio is
created a suitable size in the first place - and the merge_bvec_fn does this
for us most of the time.

Alasdair
