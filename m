From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] Target and deduplication?
Date: Thu, 28 Jan 2016 11:23:01 +0000
Message-ID: <20160128112300.GA21820@rh-vpn>
References: <CAKdSmgsZe_dfhN_7R6P7tLfkciv-9dUJKKNj16xeWYXG8aTVVA@mail.gmail.com>
 <20160128085013.GA18023@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160128085013.GA18023@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Henrik Goldman <hg@x-formation.com>, target-devel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 28, 2016 at 12:50:13AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 28, 2016 at 12:44:25AM +0100, Henrik Goldman wrote:
> > Hello,
> > 
> > Has anyone (possibly except purestorage) managed to make target work
> > with deduplication?
> 
> The iblock drivers works perfectly fine on top of the dm-dedup driver,
> which unfortunately still hasn't made it to mainline despite looking
> rather solid.

I'm working on a userland dedup tool at the moment (thin_archive), and
I think there are serious issues with dm-dedup:

- To do dedup properly you need to use a variable, small chunk size.
  This chunk size depends on the contents of the data (google 'content
  based chunking algorithms).  I did some experiments comparing fixed
  to variable chunk sizes and the difference was huge.  It also varied
  significantly depending on which file system was used.  I don't
  think a fixed sized chunk is going to identify nearly as many
  duplicates as people are expecting.

- Performance depends on being able to take a hash of a data block
  (eg, SHA1) and quickly look it up to see if that chunk has been seen
  before.  There are two plug-ins to dm-dedup that provide this look up:

  i) a ram based one.

  This will be fine on small systems, but as the number of chunks
  stored in the system increases ram consumption will go up
  significantly.  eg, a 4T disk, split into 64k chunks (too big IMO)
  will lead to 2^26 chunks (let's ignore duplicates for the moment).
  Each entry in the hash table needs to store the hash let's say 20
  bytes for SHA1, plus the physical chunk address 8bytes, plus some
  overhead for the hash table itself 4bytes.  Which gives us 32bytes
  per entry.  So our 4T disk is going to eat 2G of RAM, and I'm still
  sceptical that it will identify many duplicates.

  (I'm not sure how the ram based one recovers if there a crash)

  ii) one that uses the btrees from my persistent data library.

  On the face of it this should be better than the ram version since
  it'll just page in the metadata as it needs it.  But we're keying off
  hashes like SHA1, which are designed to be pseudo random, and will
  hit every page of metadata evenly.  So we'll be constantly trying to
  page in the whole tree.

Commercial systems use a couple of tricks to get round these problems:

   i) Use a bloom filter to quickly determine if a chunk is _not_ already
      present, this the common case, and so determining it quickly is very
      important.

   ii) Store the hashes on disk in stream order and page in big blocks of
       these hashes as required.  The reasoning being that similar
       sequences of chunks are likely to be hit again.

- Joe
