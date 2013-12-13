From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache questions
Date: Fri, 13 Dec 2013 09:20:03 -0500
Message-ID: <20131213142002.GA9302@redhat.com>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
	<20131210095019.GB32555@debian>
	<0a9401cef5eb$7e32a110$7a97e330$@acm.org>
	<20131211010337.GB4894@agk-dp.fab.redhat.com>
	<0aea01cef615$d688f8d0$839aea70$@acm.org>
	<20131211150644.GA28188@redhat.com>
	<0c4901cef6df$e557cec0$b0076c40$@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0c4901cef6df$e557cec0$b0076c40$@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Paul B. Henson" <henson@acm.org>
Cc: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 11 2013 at  9:14pm -0500,
Paul B. Henson <henson@acm.org> wrote:

> > From: Mike Snitzer [mailto:snitzer@redhat.com]
> > Sent: Wednesday, December 11, 2013 7:07 AM
> >
> > 3.10 is actively maintained by gregkh as a "longterm" stable kernel so
> > all relevant upstream commits should make their way into that tree:
> 
> Right, but as dm-cache changes over time, with new features or other major
> changes being made relative to the version shipped in 3.10, presumably some
> bug fixes that might get committed to mainline would not apply cleanly to
> 3.10 without some potentially non-negligible backporting effort? I don't
> think gregkh does that himself? So if there was a major bug fix that ideally
> would go back to LTS but couldn't be simply cherry picked, one of the
> dm-cache devs would need to submit a separate commit for 3.10? Or perhaps I
> misunderstand the process.

We sometimes cater to the quirks of a specific stable release's codebase:
http://www.redhat.com/archives/dm-devel/2013-December/msg00018.html

Or we add notes to stable for guidance on how to resolve small
differences that'd prevent a clean backport (see bottom of patch
header):
http://www.redhat.com/archives/dm-devel/2013-November/msg00200.html

But in general it is the task of other distro vendors to backport stable
fixes to their products.
