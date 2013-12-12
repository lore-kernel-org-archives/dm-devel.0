From: "Paul B. Henson" <henson@acm.org>
Subject: Re: dm-cache questions
Date: Wed, 11 Dec 2013 18:14:29 -0800
Message-ID: <0c4901cef6df$e557cec0$b0076c40$@acm.org>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
	<20131210095019.GB32555@debian>
	<0a9401cef5eb$7e32a110$7a97e330$@acm.org>
	<20131211010337.GB4894@agk-dp.fab.redhat.com>
	<0aea01cef615$d688f8d0$839aea70$@acm.org>
	<20131211150644.GA28188@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131211150644.GA28188@redhat.com>
Content-Language: en-us
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Mike Snitzer' <snitzer@redhat.com>
Cc: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Wednesday, December 11, 2013 7:07 AM
>
> 3.10 is actively maintained by gregkh as a "longterm" stable kernel so
> all relevant upstream commits should make their way into that tree:

Right, but as dm-cache changes over time, with new features or other major
changes being made relative to the version shipped in 3.10, presumably some
bug fixes that might get committed to mainline would not apply cleanly to
3.10 without some potentially non-negligible backporting effort? I don't
think gregkh does that himself? So if there was a major bug fix that ideally
would go back to LTS but couldn't be simply cherry picked, one of the
dm-cache devs would need to submit a separate commit for 3.10? Or perhaps I
misunderstand the process.
