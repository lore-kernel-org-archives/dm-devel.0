From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Fri, 21 Jan 2011 08:26:59 -0500
Message-ID: <20110121132658.GA30411@redhat.com>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4D392FBD.5080207@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 21 2011 at  2:03am -0500,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi,
> 
> On 01/21/11 01:07, Mike Snitzer wrote:
> >>> Is it possible to detect request based multipath and change only for
> >>> those configurations?
> ...
> > Unfortunately, the multipath target version wasn't bumped when
> > request-based mpath was introduced (commit f40c67f0f7e2767f).
> 
> Um, sorry I don't remember why..
> 
> > Long story short, it seems we _could_ use the DM ioctl version bump that
> > occurred for 2.6.31 (from commit 60935eb):  4.15.0-ioctl (2009-04-01) 
> 
> Fortunately, the target version of multipath was also bumped
> in 2.6.31, from 1.0.5 to 1.1.0 by this commit:
> 
> af4874e v2.6.31-rc1 dm target:s introduce iterate devices fn

Ah, very good point.  I completely overlooked that.

Thanks,
Mike
