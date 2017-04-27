From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 11/13] dm-mpath: Micro-optimize the hot
	path
Date: Thu, 27 Apr 2017 16:39:48 -0400
Message-ID: <20170427203948.GA70128@redhat.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
	<20170427171126.26814-12-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170427171126.26814-12-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Apr 27 2017 at  1:11P -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Instead of checking MPATHF_QUEUE_IF_NO_PATH,
> MPATHF_SAVED_QUEUE_IF_NO_PATH and the no_flush flag to decide whether
> or not to push back a request if there are no paths available, only
> clear MPATHF_QUEUE_IF_NO_PATH in queue_if_no_path() if no_flush has
> not been set. The result is that only a single bit has to be tested
> in the hot path to decide whether or not a request must be pushed
> back and also that m->lock does not have to be taken in the hot path.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

This patch was very demanding to review.. all that old must_push_back()
code was very tedious.  Happy to see it go.  BUT I'm left nervous that
something might regress.  Not because of something overlooked (though
that could happen).. just that its a particularly delicate portion of
the mpath target's suspend/resume handling.

Kudos to you for tackling this.  Staged in dm-4.12 for 4.12 inclusion
(will push it out once I go back over what I've staged)
