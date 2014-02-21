From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 4/8] dm thin: error out I/O
 if inappropriate for it to be retried
Date: Fri, 21 Feb 2014 09:48:36 -0500
Message-ID: <20140221144836.GG4578@redhat.com>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-5-git-send-email-snitzer@redhat.com>
	<20140221142244.GD13298@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140221142244.GD13298@debian>
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
List-Id: dm-devel.ids

On Fri, Feb 21 2014 at  9:22am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> NACK (but close).
> 
> On Thu, Feb 20, 2014 at 09:56:01PM -0500, Mike Snitzer wrote:
> > If the pool is in fail mode, error_if_no_space is enabled or the
> > metadata space is exhausted do _not_ allow IO to be retried.
> 
> This should be:
> 
> "If the pool is in fail mode, error_if_no_space is enabled or a
> transaction has been aborted, do _not_ allow IO to be retried."
> 
> (In practise 'transaction has been aborted' is the same as the
> needs_check flag we've discussed.)

Yeah, which is made available in patch 7.  These are all building to the
final state in patch 7.  No shipping kernel should have the intermediate
state that these incremental patches introduce.

I left them split out to see the progression, as I think it useful.
If I folded all of these changes together it would be difficult to see
the progression.
