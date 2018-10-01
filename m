From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] multipathd: try SCSI persistent
 reservations for SCSI only
Date: Mon, 1 Oct 2018 13:19:22 -0700
Message-ID: <20181001201922.GA1386@infradead.org>
References: <20181001184507.4162-1-mwilck@suse.com>
	<20181001184507.4162-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181001184507.4162-3-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 01, 2018 at 08:45:07PM +0200, Martin Wilck wrote:
> This avoids error messages when PERSISTENT RESERVE IN ioctls
> are tried on non-SCSI devices.

FYI, the right long term solution is to use the kernel ioctls for PRs, as
they abstract out the underlying transport.  But for this looks good
enough.
