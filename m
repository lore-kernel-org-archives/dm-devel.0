From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath low performance with blk-mq
Date: Thu, 4 Feb 2016 14:58:06 +0100
Message-ID: <56B358EE.6000007@suse.de>
References: <56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com> <56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com> <56AEFF63.7050606@suse.de>
	<20160203180406.GA11591@redhat.com> <20160203182423.GA12913@redhat.com>
	<56B2F5BC.1010700@suse.de> <20160204135420.GA18227@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160204135420.GA18227@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On 02/04/2016 02:54 PM, Mike Snitzer wrote:
> On Thu, Feb 04 2016 at  1:54am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> =

[ .. ]
>> But anyway, I'll be looking at your patches.
> =

> Thanks, sadly none of the patches are going to fix the performance
> problems but I do think they are a step forward.
> =

Hmm. I've got a slew of patches converting dm-mpath to use atomic_t
and bitops; with that we should be able to move to rcu for path
lookup and do away with most of the locking.
Quite raw, though; drop me a mail if you're interested.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
