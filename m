From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm: submit stacked requests in irq enabled context
Date: Wed, 10 May 2017 00:17:33 -0700
Message-ID: <20170510071733.GA24980@infradead.org>
References: <a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org>
	<dee12838-7b43-2fdd-0644-41c10ecf9148@codeaurora.org>
	<20170509155555.GB2572@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170509155555.GB2572@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Neeraj Soni <neersoni@codeaurora.org>, dm-devel@redhat.com, snitzer@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, May 09, 2017 at 11:55:55AM -0400, Keith Busch wrote:
> >      I have recently started using kernel 4.4 on a Android device and ran
> >      Androbench to check storage read/write performance. I found that the
> >      Random Read (RR) and Random write(RW) performance with Full Disk
> >      Encryption is degraded compared to no Disk Encryption. Initially i

dm-crypt doesn't even use request based device mapper.  Something odd
must be going on with your benchmarks.
