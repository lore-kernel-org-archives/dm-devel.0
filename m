From: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 0/10] Snapshot merging back from the dead?
Date: Mon, 14 Apr 2008 09:41:53 +0100
Message-ID: <1208162513.3384.16.camel@muff>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-1-git-send-email-markmc@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Tue, 2008-04-01 at 09:32 +0200, Mark McLoughlin wrote:
> Hi Alasdair,
>         I've gone back and updated my snapshot-merged patches from
> ages ago so that they apply to 2.6.25-rc7.
> 
>         Even though these updated patches are completely untested,
> I've been quite careful in rebasing them and they do build, so I
> figure they're worth posting here for review.
> 
>         Hopefully, I'll soon get a chance to test them at length and
> also update the userland patches.

	I did eventually do a small bit of testing of these and found some
reads hanging which, at a guess, is probably the read-tracking patch
that is broken.

Cheers,
Mark.
