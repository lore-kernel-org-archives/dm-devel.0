From: Martin Wilck <mwilck@suse.de>
Subject: Re: dm thin pool discarding
Date: Thu, 10 Jan 2019 12:40:11 +0100
Message-ID: <46a8e85e0258cd8ccc328052a428fff0cbdd5ad3.camel@suse.de>
References: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
	<ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
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

On Thu, 2019-01-10 at 10:18 +0100, Zdenek Kabelac wrote:
> Dne 10. 01. 19 v 1:39 james harvey napsal(a):
> > 
> > Q3 - Does a LVM thin volume zero out the bytes that are
> > discarded?  At
> > least for me, queue/discard_zeroes_data is 0.  I see there was
> > discussion on the list of adding this back in 2012, but I'm not
> > sure
> > it was ever added for there to be a way to enable it.
> 
> Unprovisioned chunks always appear as zeroed for reading.
> Once you provision chunk (by write) for thin volume out of thin-pool
> - it 
> depends on thin-pool target setting 'skip_zeroing'.
> 
> So if zeroing is enabled (no skipping) - and you use larger chunks -
> the 
> initial chunk provisioning becomes quite expensive - that's why lvm2
> is by 
> default recommending to not use zeroing for chunk sizes > 512K.

Which begs the question why lvm zeroes at provisioning time, and not at
discard time, where speed matters less (and the operation could be
carried out lazily, taking care only that the discarded blocks aren't
re-provisioned before they are zeroed).

So far my understanding was that even without zeroing, an LVM thin
volume could be considered as a drive with "discard zeroes data"
property. If there's a flaw in the argument below, please point it out
to me.

Firstly, IMO "discard" is not "secure erase". Considering an SSD, the
"discards zeroes data" property doesn't make sure that the data is
unrecoverably wiped. It just means that future attempts to read the
discarded sectors return zeroes. The data may well persist in flash
memory, and be readable to attackers with suitable tools.

Now consider a VM that uses a dm-thin volume as storage. If this VM
issues a discard operation on some chunk of data, future reads on the
discarded chunks through the same LV will return 0 because these chunks
have just become unprovisioned. That looks pretty much like "disard
zeroes data" to me. Right? Whether that data might become visible to
another VM using another thin volume is a different question, more
along the "secure erase" line of thought. The blocks in the thin pool
outside the used thin LV are a bit like the "spare area" of an SSD, at
least from the point of view of a VM.

The point I'm uncertain about is what happens if such a chunk is
(re)provisioned by a partial write (say chunk size is 1M and only 512k
is written). What data would dm-thin return from a read of the non-
overwritten part of that chunk?

Thanks,
Martin
