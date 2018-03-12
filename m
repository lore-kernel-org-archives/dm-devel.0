From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm-bufio: move dm-bufio.h to include/linux/
Date: Mon, 12 Mar 2018 00:48:27 -0700
Message-ID: <20180312074827.GA30695@infradead.org>
References: <alpine.LRH.2.02.1803080421030.9508@file01.intranet.prod.int.rdu2.redhat.com>
	<20180308144955.GA23262@infradead.org>
	<20180308203621.GA8133@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180308203621.GA8133@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Thomas Jaskiewicz <tomj@permabit.com>
List-Id: dm-devel.ids

On Thu, Mar 08, 2018 at 03:36:21PM -0500, Mike Snitzer wrote:
> While I appreciate your interest in what constitutes a reasonable change
> for DM, why are you so emphatic about disallowing out-of-tree DM modules
> from using dm-bufio?

Because I'd rather get them into the tree than providing escapes just
for them. 
