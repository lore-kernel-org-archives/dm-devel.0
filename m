From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Fri, 21 Jan 2011 09:12:05 -0500
Message-ID: <20110121141204.GE30411@redhat.com>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
	<1295599627.23625.16.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1295599627.23625.16.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 21 2011 at  3:47am -0500,
Christophe Varoqui <christophe.varoqui@gmail.com> wrote:

> 
> > 
> > Fortunately, the target version of multipath was also bumped
> > in 2.6.31, from 1.0.5 to 1.1.0 by this commit:
> > 
> > af4874e v2.6.31-rc1 dm target:s introduce iterate devices fn
> > 
> Fortunate indeed.
> 
> Should the 'minio' be a tunable in the request-based multipath context,
> or should we hardcode its value to '1' ?

As my earlier response indicated: I'm not convinced _always_ using 1 for
request-based is appropriate/best.
 
> If we keep it a tunable, I guess we'll have to introduce a different
> 'minio' configuration parameter ('rr_min_io_rq' for example) to permit
> vendors to set their defaults for distributions shipping a rq-capable
> kernel or not. This change would be pretty invasive.

I'm not following why we'd need a different configuration parameter.
It is just that the default rr_min_io that would be used would be
conditional on the multipath target version being >= 1.1.0.

Mike
