From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm table: verify each table mapping is HW
	sector aligned
Date: Fri, 10 Apr 2009 00:31:06 -0400
Message-ID: <20090410043106.GA18995@redhat.com>
References: <1239335895-18613-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1239335895-18613-1-git-send-email-snitzer@redhat.com>
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

On Thu, Apr 09 2009 at 11:58pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Each mapping in a DM table must be properly aligned on HW sector
> boundaries.  This is particularly important when a DM table is composed
> of mappings for devices with different HW sector sizes.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-table.c |  112 +++++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 99 insertions(+), 13 deletions(-)

This patch applies cleanly, but with fuzz, to the most recent linux-2.6
(as of this writing: 62b8e680e).

Mike
