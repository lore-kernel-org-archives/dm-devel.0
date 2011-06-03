From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
	structure
Date: Fri, 3 Jun 2011 11:54:31 -0400
Message-ID: <20110603155431.GB30477@redhat.com>
References: <Pine.LNX.4.64.1105311802330.9322@hs20-bc2-1.build.redhat.com>
	<20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110603110111.GA4969@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 03 2011 at  7:01am -0400,
Joe Thornber <thornber@redhat.com> wrote:

> On Thu, Jun 02, 2011 at 03:55:16PM -0400, Mikulas Patocka wrote:
> > > iv) you haven't explained how the sys admin works out the correct
> > > throttle value.
> > 
> > There is no "correct" value. The "correct" value depends on how important 
> > is copying itself v.s. other i/o.
> 
> So who is going to set this?  Do you really have no advice for them
> beyond 'there is no correct value'?
> 
> > In theory (if disk scheduler were perfect), we wouldn't need any 
> > throttling. The disk scheduler should recognize that the kcopyd process is 
> > sending way more requests than any other process and should lower the 
> > i/o priority of kcopyd process.
> > 
> > In practice, the disk scheduler doesn't do it well, so kcopyd hurts the 
> > users. If you want an automated fix, fix the disk scheduler. But don't put 
> > disk scheduler logic into device mapper --- it dosn't belong there.
> 
> I totally agree with these two paragraphs.  Any throttling you add to
> kcopyd is always going to be a hack.

Wouldn't it be better to tie in to the block layer's new throttling
infrastructure that Vivek added?  Possibly expose a callback that
enables kcopyd consuming devices to throttle kcopyd as a side-effect of
the higher-level throttle?

Mike
