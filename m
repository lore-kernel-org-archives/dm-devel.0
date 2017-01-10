From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: trouble with generic/081
Date: Mon, 9 Jan 2017 21:48:57 -0500
Message-ID: <20170110024857.4nchdtvpjmms3uuv@thunk.org>
References: <a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
	<577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
	<18e7613b-5a83-d802-a38f-35a9a604fdb3@sandeen.net>
	<7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
	<20170105224600.GC4326@dastard>
	<20170109133919.GB19577@infradead.org>
	<15605149-0590-1555-6522-38d2eff69026@redhat.com>
	<0cb45b07-4cae-0dc5-0605-752f2e0dfda1@sandeen.net>
	<fb048316-72f9-5a3d-8a03-4220b25eb028@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fb048316-72f9-5a3d-8a03-4220b25eb028@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, dm-devel@redhat.com, Eric Sandeen <sandeen@sandeen.net>, eguan@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 09, 2017 at 04:11:08PM +0100, Zdenek Kabelac wrote:
> 
> You have the case were application will write to 'different' filesystem,
> while in other cases user will be able to continue to use their filesystem
> and cause irreparable filesystem damage (whatever you want to believe
> is failure if thin-pool or filesystem).

Huh?  Where do you get this fantasy that ENOSPC causes "irreparable
file system damage"?  We have tests in xfstests that repeatedly hammer
file systems ENOSPC handling --- the file system is filled so it is
almost full, and then one thread is constantly creating and deleting
files to keep the file system almost full, and then backing off, while
another thread is trying to continuously allocate space, and retrying
when it gets ENOSPC.

If the file system gets "irreparably damanged", it's a file system
bug.  I can't remember the last time ext4 or xfs has had file system
issues with this.  Btrfs has in the past had issues here --- but this
is a file system bug.  It should be fixed, or no responsible system
administrator should be using btrfs on that enterprise distribution
until it is fixed, Docker or no Docker. 

	     	      	 	       - Ted

P.S.  And no responsible enterprise distro provider should be shipping
btrfs if it is hasn't had all of the bug fixes so it doesn't corrupt
the file system on ENOSPC.  Since I believe Red Hat is a responsible
enterprise distro provider, what's the problem?  :-)
