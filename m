From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-3.19 PATCH 00/17] dm thin: performance
	improvements
Date: Fri, 17 Oct 2014 14:31:19 -0400
Message-ID: <20141017183119.GA31854@redhat.com>
References: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 17 2014 at  2:06am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Here is a patchset that Joe and I have been working on for the past 2
> weeks to address various performance problems reported against DM thin
> provisioning.  DM thinp is now much more capable in the face of heavy
> IO (be it random or sequential, multithreaded, etc).
> 
> I've just added these patches to linux-dm.git's 'for-next' branch so
> that these changes get early exposure/testing for 3.19 inclusion.

Testing with device-mapper-test-suite on really fast storage uncovered
various races.  Joe quickly fixed these and I've folded the fixes into
the patch series.

v2 will be staged staged in linux-dm.git's 'for-next' branch (after
rebase) very soon.  But I'll respond with the full patchset again just
to help anyone who cares to review/respond on list.

Thanks,
Mike
