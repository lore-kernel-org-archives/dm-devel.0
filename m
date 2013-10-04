From: Joe Thornber <thornber@redhat.com>
Subject: Re: thin_dump cannot dump the correct data mapping of
	thin pools
Date: Fri, 4 Oct 2013 15:56:30 +0100
Message-ID: <20131004145630.GA25523@debian>
References: <CAKTMprPZ01+JaT0YJhYjPd90gdhfcX-Qa1+wUcv85GffXh74aw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKTMprPZ01+JaT0YJhYjPd90gdhfcX-Qa1+wUcv85GffXh74aw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Teng-Feng Yang <shinrairis@gmail.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

Hi,

Yes, this is a bug, thanks for looking into this.  O_DIRECT was
dropped because it was slow, causing some dump/restores to take minutes.
There should be no problem putting it back in.

Whether O_DIRECT is used or normal buffered IO shouldn't make a
difference with normal offline dumping.

However, you're dumping metadata snapshots from a live system, and
somehow we're getting out of sync with the buffered io, and what's
really on disk.  I'd hoped we'd avoid this, the kernel is *not*
changing the metadata snapshot after all.  But I guess blocks are
being held in the page cache longer than I expected.

For now I'll change it so it uses O_DIRECT if the metadata_snap flag
is given.  Longer term I need to improve my user land cache a bit so
it preemptively flushes dirty data when we get low on space.  This
will make O_DIRECT perform well.

Thanks again,

- Joe


On Fri, Oct 04, 2013 at 03:01:14PM +0800, Teng-Feng Yang wrote:
> Hi folks,
> 
> I have been working on an incremental backup tools of thin volumes
> created by dm-thin for a couple of months.
> This tool relies on the data mappings dumped by thin_dump from the
> thin-provisioing-tools.
> As I update thin_dump from version 0.1.5 to 0.2.7, it cannot work
> correctly as the earlier 0.1.5 version.
> 
> The following things have been observed:
> 1. thin_dump-0.2.7 cannot take user-specified "metadata_snap" as
> v0.1.5. It will always return "bad checksum in superblock".
> 2. If "metadata_snap" is not given by users, thin_dump-0.2.7 only
> dumps the out-dated data mappings which can be recognized by observing
> the wrong "transaction id".
> 
> Since it looked like thin_dump failed to get the most up-to-date
> metadata blocks in version 0.2.7, I dig a little deeper into the
> source code and find something that might cause the problem.
> The open flag used on metadata device has been changed from "O_DIRECT
> | O_SYNC" to "0" in commit 4deb1751a650010ce9c15910a064be1348dec8ba .
> After I changed this back to "O_DIRECT | O_SYNC" in version 0.2.7, it
> works as expected once again.
> 
> So here is my question.
> Can I change this flag back to "O_DIRECT | O_SYNC" in any newer version?
> I am worry about that I might accidentally mess something up by
> changing this flag.
> Also, what's the purpose to get rid of the "O_DIRECT" and "O_SYNC"
> flags when we migrate to version 0.2.x?
> 
> Any help would be highly appreciated.
> 
> Best Regards,
> Dennis
