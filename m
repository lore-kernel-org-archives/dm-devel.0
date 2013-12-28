From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCG]DM: dm-compression: a compressed DM target
	for SSD
Date: Sat, 28 Dec 2013 13:22:48 +0000
Message-ID: <20131228132248.GB16613@agk-dp.fab.redhat.com>
References: <20131227062421.GA21053@kernel.org> <20131228125725.GA16613@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131228125725.GA16613@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Sat, Dec 28, 2013 at 12:57:25PM +0000, Alasdair G Kergon wrote:
> To use this compression target above dm-thin (likely to prefer larger
> block sizes), for example, could the block sizes be adapatable /
> configurable?

So a key feature of the underlying thin provisioning needs to be
efficient tracking of a small sector size (which doesn't suit the
existing dm-thin target).  This compression target could sometimes
benefit from a larger block size though, particularly where the 
data above has large blocks.

(Could we name this something like 'microcompression'?)
 
Alasdair
