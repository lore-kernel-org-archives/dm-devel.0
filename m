From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-raid: add RAID discard support
Date: Thu, 25 Sep 2014 14:02:58 -0400
Message-ID: <20140925180258.GA30170@redhat.com>
References: <1411573639-21610-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1411573639-21610-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 24 2014 at 11:47am -0400,
heinzm@redhat.com <heinzm@redhat.com> wrote:

> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> (Folding patches 2+3 of my previous series into one on Mike Snitzers request)

I've tweaked and then folded these 2 new patches too.  I see no need to
"show your work" for such a simple change; especially given the rather
fundamental raid_check_discard() implementation differences that patch 2
introduced.

Anyway, end result is staged in linux-next for v3.18 inclusion, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=d679f9a5582b21eff85f759f5e6a9e2ffb4793e5
