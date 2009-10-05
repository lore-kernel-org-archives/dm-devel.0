From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 12/12]
	dm-snapshot-merge-use-larger-io-when-merging
Date: Mon, 5 Oct 2009 15:12:38 -0400
Message-ID: <20091005191238.GA5796@redhat.com>
References: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
	<1254769367-12111-13-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1254769367-12111-13-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 05 2009 at  3:02pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Here are performance results from some mkfs-based testing:
...
> before:
> -------
> # time lvconvert -M test/testlv_snap
...

> after:
> ------
> # time lvconvert -M test/testlv_snap
...

FYI, the above lvconvert command-line references are stale.  The only
way to start a snapshot-merge is with: lvconvert --merge $SNAP_LV

Mike
