From: Martin Wilck <mwilck@suse.de>
Subject: Re: dm thin pool discarding
Date: Thu, 10 Jan 2019 17:12:17 +0100
Message-ID: <85ffbcfdbe581a73cee0fd5a0044d1a01f8a70f6.camel@suse.de>
References: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
	<ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
	<46a8e85e0258cd8ccc328052a428fff0cbdd5ad3.camel@suse.de>
	<db63baea-269e-e331-a34b-acdffd62839e@redhat.com>
	<7f57a14868a8d365668d7dde9b3aac92e1ffdf64.camel@suse.de>
	<b62b708f-f7ac-d04a-c536-1881d3a8fad7@redhat.com>
	<5f02c1bbae54a3076bfef532f0de9a81f573d0cb.camel@suse.de>
	<01a87b75-d0d7-c801-ebd6-2cf7da74080b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <01a87b75-d0d7-c801-ebd6-2cf7da74080b@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, james harvey <jamespharvey20@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2019-01-10 at 16:55 +0100, Zdenek Kabelac wrote:
> Dne 10. 01. 19 v 16:23 Martin Wilck napsal(a):
> > On Thu, 2019-01-10 at 16:08 +0100, Zdenek Kabelac wrote:
> > > Dne 10. 01. 19 v 14:41 Martin Wilck napsal(a):
> > > > I for one would find it very attractive if dm-thin had a mode
> > > > supporting fast zeroout.
> > > 
> > > I believe '/sys/block/*/queue/discard_zeroes_data  is now always
> > > returning
> > > false for any device as it's been considered as unreliable logic.
> > > 
> > > So using 'discard' for zeroing is not really an option here.
> > 
> > True. But we have "write_zeroes_max_bytes" instead. In device
> > mapper
> > terms, it's "num_write_zeroes_bios", which isn't set for dm-thin.
> > With
> > the logic outlined above, it could be set, AFAICT.
> 
> I assume this is valid request for enhancement of thin-pool target.
> However  this  'WRITE_SAME'  or whatever scsi low-level command is
> that is 
> basically targeted for thinLV user.
> 
> So in this case the most effective 'zeroing' of thinLV areas is its
> discard.

That's what I have in mind. Basically, one could implement a
"write_zeroes" operation in a similar manner as discard is implemented
now. We'd just need to be careful with the case where a write_zeroes
request isn't aligned to chunk size (aka discard_granularity), and
instead of a noop, either return an error, or fall back to "slow"
zeroing for the unaligned pieces. I believe that wouldn't be a big
problem in practice - prudent users would respect the granularity
anyway.

Regards
Martin
