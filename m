From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 16:03:20 -0600
Message-ID: <6c075b9f-fe5b-739c-e749-c2a1520ba0d8@sandeen.net>
References: <20161214164314.GA25105@infradead.org>
	<20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
	<577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
	<18e7613b-5a83-d802-a38f-35a9a604fdb3@sandeen.net>
	<7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com
List-Id: dm-devel.ids

On 1/5/17 3:12 PM, Zdenek Kabelac wrote:
> Dne 5.1.2017 v 20:29 Eric Sandeen napsal(a):
> 
> So  if I hear all voice correctly now -
> 
> 
> we now want to let user continue to use such systems and let them
> figure out themself something is wrong when they get occasional write
> failure and XFS now avoid destruction by shutting down on any journal
> failure.

No - I'd like to know, specifically, what scenario leads to filesystem
corruption when we run out of space in the thin-pool, because I do
not expect that result.

Anecdotes about "destruction" don't really help.

>> (A journal may not be replayable on mount if it needs to allocate more
>> thin blocks on replay and is unable to do so, but hat should just fail
>> gracefully)
> 
> 
> I don't have a test sample myself - just some guides how to get to it.
> 
> Use  LV and make some thin snapshots.
> 
> Then change various parts of origin - at various moment before pool is out-of-space
> 
> So you will get lots of different scenarios of missing data.

(missing /data/ is not "filesystem destruction" - if we're just talking
about buffered IO which was never fsynced and does not persist on
disk, that is expected with or without thinp on any sort of storage
trouble.)
 
> You will mostly not get into those mentioned trouble if you
> have just single thinLV and you exhaust thin-pool while using it.
> 
> Games with snapshot are needed.

Please formalize that, and I'll be happy to take a look.

-Eric
