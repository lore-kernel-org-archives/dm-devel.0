From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache writethrough issue.
Date: Tue, 26 Mar 2013 09:39:14 +0000
Message-ID: <20130326093913.GC18061@debian>
References: <20130325102500.GA6340@debian>
	<20130325163654.GF5357@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130325163654.GF5357@blackbox.djwong.org>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 25, 2013 at 09:36:54AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 25, 2013 at 10:25:01AM +0000, Joe Thornber wrote:
> > Alasdair,
> > 
> > Could you push this upstream ASAP please?
> > 
> > I'm not happy that we're now adding such a large structure to the per
> > bio data, at the very least we should only do this if writethrough is
> > enabled.  But I'll improve this later, for now correctness is the
> > important thing.
> > 
> > - Joe
> 
> Makes my problems go away on my setup, so you can add:
> Tested-by: Darrick J. Wong <darrick.wong@oracle.com>

Excellent.  Thank you again for helping out.
