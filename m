From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Bcache v13 00/16]
Date: Thu, 10 May 2012 09:54:31 -0400
Message-ID: <20120510135431.GC23768@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <cover.1336619038.git.koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, agk@redhat.com, tejun@google.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 09, 2012 at 11:07:29PM -0400, Kent Overstreet wrote:
> bcache: a cache for arbitrary block devices using an SSD.
> 
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself as a
> new block device, a bit like say md. You can cache an arbitrary number of
> block devices with a single cache device, and attach and detach things at
> runtime - it's quite flexible.

So it is still not a device mapper target. I somehow had the impression
that consensus at LSF was to convert it into a device mapper target.

Thanks
Vivek
