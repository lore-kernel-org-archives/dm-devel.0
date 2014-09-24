From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 24 Sep 2014 11:11:21 -0400
Message-ID: <yq1r3z1rr3a.fsf@sermon.lab.mkp.net>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924142149.GA3858@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140924142149.GA3858@infradead.org> (Christoph Hellwig's
	message of "Wed, 24 Sep 2014 07:21:49 -0700")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph>  - start adding a whitelist for ATA

As far as I know the sanity bits have been discussed in T13 but haven't
been agreed upon yet.

The hard part about the whitelist is that bad things only happen in rare
circumstances. However, we may be able to take some hints from here:

http://www.lsi.com/downloads/Public/RAID%20Controllers/RAID%20Controllers%20Common%20Files/MegaRAID_SAS3_936x-938x_Compatibility_List.pdf

Christoph> Alternatively we could get rid of discard_zeroes_data and
Christoph> stop the pretence of any sane behavior from discard, and
Christoph> instead expose an unmap bit through the blkdev_issue_zeroout
Christoph> stack for those callers who want to do a discard, but rely on
Christoph> zeroes. The end effect will be the same, just a different
Christoph> presentation.

Yep.

-- 
Martin K. Petersen	Oracle Linux Engineering
