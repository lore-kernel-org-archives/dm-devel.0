From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm-crypt performance
Date: Tue, 26 Mar 2013 02:52:29 -0400
Message-ID: <20130326065229.GA2884@infradead.org>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
> If I sort the requests in dm-crypt to come out in the same order as they 
> were received, there is no longer any slowdown, the new crypt performs as 
> well as the old crypt, but the last time I submitted the patches, people 
> objected to sorting requests in dm-crypt, saying that the I/O scheduler 
> should sort them. But it doesn't. This problem still persists in the 
> current kernels.

FYI, XFS also does it's own request ordering for the metadata buffers,
because it knows the needed ordering and has a bigger view than than
than especially CFQ.  You at least have precedence in a widely used
subsystem for this code.
