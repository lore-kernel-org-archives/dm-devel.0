From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm thin pool discarding
Date: Thu, 10 Jan 2019 10:18:41 +0100
Message-ID: <ba0c0646-29f3-f876-6454-8c80b613a46a@redhat.com>
References: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+X5Wn4fqXZa_Ecc75CfmA2LBq7y8qFzzdDcdFugZwaPgq-Aeg@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: james harvey <jamespharvey20@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 10. 01. 19 v 1:39 james harvey napsal(a):
> I've been talking with ntfs-3g developers, and they're updating their
> discard code to work when an NTFS volume is within an LVM thin volume.
> 
> It turns out their code was refusing to discard if discard_granularity
> was > the NTFS cluster size.  By default, a LVM thick volume is giving
> a discard_granularity of 512 bytes, and the NTFS cluster size is 4096.
> By default, a LVM thin volume is giving a discard_granularity of 65536
> bytes.
> 
> For thin volumes, LVM seems to be returning a discard_granularity
> equal to the thin pool's chunksize, which totally makes sense.
> 
> Q1 - Is it correct that a filesystem's discard code needs to look for
> an entire block of size discard_granularity to send to the block
> device (dm/LVM)?  That dm/LVM cannot accept discarding smaller amounts
> than this?  (Seems to make sense to me, since otherwise I think the
> metadata would need to keep track of smaller chunks than the
> chunksize, and it doesn't have the metadata space to do that.)


You can always send discard of 512b sector - but it will not really do 
anything useful for thin-pool unless you discard 'whole' chunk.

That's why it is always better to use  'fstrim' - which will always try
to discard 'largest' regions.

There is nothing in thin-pool itself that would track which sectors from 
chunks were trimmed - so if you trim chunk by sectors - the chunk will still 
appear as allocated by thin volume. And obviously there is nothing
that would be 'clearing' such trimmed sectors individually. So when
you trim  512b out of thin volume - after reading same data location you will 
still find there your old data.  Only after 'trimming' whole chunk (on chunk 
boundaries) - you will get zero.  It's worth to note that every thin LV is 
composed from chunks - so to have successful trim - trimming happens only on 
aligned chunks - i.e. chunk_size == 64K and then if you try to trim 64K from 
position 32K - nothing happens....

> Q3 - Does a LVM thin volume zero out the bytes that are discarded?  At
> least for me, queue/discard_zeroes_data is 0.  I see there was
> discussion on the list of adding this back in 2012, but I'm not sure
> it was ever added for there to be a way to enable it.

Unprovisioned chunks always appear as zeroed for reading.
Once you provision chunk (by write) for thin volume out of thin-pool - it 
depends on thin-pool target setting 'skip_zeroing'.

So if zeroing is enabled (no skipping) - and you use larger chunks - the 
initial chunk provisioning becomes quite expensive - that's why lvm2 is by 
default recommending to not use zeroing for chunk sizes > 512K.

When zeroing is disabled (skipped) -  provisioning is 'fast' - but whatever 
content was 'left' on thin-pool data device will be readable from unwritten 
portions of provisioned chunks.  So you need to pick whether you care or do 
not care. Note - modern filesystems track 'written' data - so normal user can 
never see such data by reading files from filesystem - but of course root with 
'dd' command can examine any portion of such device.

I hope this makes it clear.

Zdenek
