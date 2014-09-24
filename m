From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Wed, 24 Sep 2014 16:38:02 +0200
Message-ID: <5422D74A.6020502@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924142149.GA3858@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140924142149.GA3858@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On 09/24/2014 04:21 PM, Christoph Hellwig wrote:
> On Tue, Sep 23, 2014 at 07:07:35PM -0400, Martin K. Petersen wrote:
>>>>>>> "Heinz" == heinzm  <heinzm@redhat.com> writes:
>> Heinz> In case of RAID levels 4,5 and 6 we have to check for the
>> Heinz> capability to zero data on discards to avoid stripe data
>> Heinz> corruption.
>>
>> I'm quite concerned about relying on discard_zeroes_data since it's a
>> hint and not a hard guarantee.
> If we want to provide useful discards through raid we need to make
> it a hard guarantee.  That is:
>
>   - only set it when using a WRITE SAME variant on scsi
>   - start adding a whitelist for ATA
>
> Relying on zeroout which also works when it doesn't unmap below is not
> the answer, especially if it may end up doing a physical write of zeroes
> on disk devices.  Alternatively we could get rid of discard_zeroes_data
> and stop the pretence of any sane behavior from discard, and instead
> expose an unmap bit through the blkdev_issue_zeroout stack for those
> callers who want to do a discard, but rely on zeroes.  The end effect
> will be the same, just a different presentation.

Neil already came up with an unmap  bitmap  to add to the RAID4/5/6
personalities in order to harden MD in this regard.
In order to avoid any related data corruption with any future disk types
it seems to be the approprite solution.

Waiting for him to comment more on this.

Heinz
