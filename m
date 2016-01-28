From: Christoph Hellwig <hch@lst.de>
Subject: Re: reinstate dm target local ioctl support
Date: Thu, 28 Jan 2016 15:00:22 +0100
Message-ID: <20160128140022.GA15941@lst.de>
References: <1453989019-24300-1-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453989019-24300-1-git-send-email-apw@canonical.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, mohan_srinivasan@yahoo.com, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>
List-Id: dm-devel.ids

On Thu, Jan 28, 2016 at 01:50:19PM +0000, Andy Whitcroft wrote:
> However this also removed the possibility of a dm target having targe=
t
> specific ioctls.  Currently this is not used by any in-tree targets b=
ut
> was utilised by the flashcache out-of-tree module.
>=20
> How would we feel about carrying something like the patch below in
> mainline to allow for such target local ioctls.

Bad.  Because a) targets shouldn't have their own ioctls and b) your ou=
t
of tree modules are your problem, don't burden us w=D1=96th upstream
workarounds for it.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
