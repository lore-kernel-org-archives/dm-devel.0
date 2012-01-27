From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dd to a striped device with 9 disks gets much lower
 throughput when oflag=direct used
Date: Fri, 27 Jan 2012 03:52:26 -0500
Message-ID: <20120127085226.GA16520@infradead.org>
References: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
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

On Thu, Jan 26, 2012 at 05:06:42PM -0800, Richard Sharpe wrote:
> Why do I see such a big performance difference? Does writing to the
> device also use the page cache if I don't specify DIRECT IO?

Yes.  Trying adding conv=fdatasync to both versions to get more
realistic results.
