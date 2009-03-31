From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: commit 6d2a78e783416ba99e36beb1d4395b785b34e867 avoids
	dm integrity support
Date: Tue, 31 Mar 2009 01:21:49 -0400
Message-ID: <yq1bpriw9le.fsf@sermon.lab.mkp.net>
References: <49D06571.70903@ct.jp.nec.com>
	<yq1k566x3cn.fsf@sermon.lab.mkp.net> <20090330185945.GA5178@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090330185945.GA5178@kernel.dk> (Jens Axboe's message of "Mon\,
	30 Mar 2009 20\:59\:45 +0200")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> The forward progress reference failed to take stacked drivers into
Jens> account, I didn't realize that they need to allocate integrity
Jens> data again as well.

Yup.  We need a bio integrity struct as well as a vector to describe the
integrity pages.

Ideally I'd like to avoid cloning the integrity bio_vec altogether.  The
only reason I do it now is because I have to keep the integrity vector
in sync with the data vector when that gets sliced and diced.  Plus
there's the suck of partial completion.

If we never changed bio_vecs this wouldn't be an issue.  One option
would be to add an offset parameter to the bio.  That way we could
completely avoid cloning bio_vecs.  That would mean a bit more
complexity in building scatterlists at the bottom of the pile but we'd
do fewer memory allocations.

I've been tinkering with that approach this evening.  I almost have it
working for the integrity vector.  Doing it for bios is obviously a much
bigger task.


Jens> Perhaps it would be cleaner to make the integrity allocation more
Jens> explicit in the supported paths, instead of hiding it in bio_set?
Jens> Dunno, haven't thought much about it, just an alternative approach

DM is the only subsystem that manually clones things.  MD uses bio_clone
and has no idea that the integrity fluff is there.  In any case I really
think the bio_set approach is a nicer interface than making every
stacking driver special-case integrity allocations.

-- 
Martin K. Petersen	Oracle Linux Engineering
