From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm-thin f.req. : SEEK_DATA / SEEK_HOLE / SEEK_DISCARD
Date: Tue, 1 May 2012 09:08:16 -0400
Message-ID: <20120501130816.GA14067@infradead.org>
References: <4F9FDCC2.2080905@shiftmail.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F9FDCC2.2080905@shiftmail.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, May 01, 2012 at 02:53:22PM +0200, Spelic wrote:
> Dear dm-thin developers,
> I thought that it would be immensely useful to have a SEEK_DATA /
> SEEK_HOLE implementation for dm-thin and/or even for the older
> non-thin snapshotting mechanism.

You can't implement it direct as device mapper doesn't implement the
file operations.  But I think adding block device operations that back
it would be a good idea, they could also implemented for arrays
implementing thin provisioning using the GET LBA STATUS scsi command.
