From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-io: don't allocate vector larger than
	BIO_MAX_PAGES
Date: Fri, 30 Jan 2009 00:28:09 +0000
Message-ID: <20090130002809.GE1935@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0901212227100.3027@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901212227100.3027@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Pushing to linux-next.

On Wed, Jan 21, 2009 at 10:32:20PM -0500, Mikulas Patocka wrote:
> Very likely this was the reason for bug
> https://bugzilla.redhat.com/show_bug.cgi?id=173153

So with this and the other fixes there've been, do we still have
any arch-dependent restrictions on chunk_size?

Or can a snapshot created on one arch be used successfully on any other
now?
 
Alasdair
-- 
agk@redhat.com
