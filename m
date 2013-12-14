From: "Paul B. Henson" <henson@acm.org>
Subject: Re: dm-cache questions
Date: Fri, 13 Dec 2013 16:59:06 -0800
Message-ID: <20131214005906.GT4044@bender.unx.csupomona.edu>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
	<20131210095019.GB32555@debian>
	<0a9401cef5eb$7e32a110$7a97e330$@acm.org>
	<20131211010337.GB4894@agk-dp.fab.redhat.com>
	<0aea01cef615$d688f8d0$839aea70$@acm.org>
	<20131211150644.GA28188@redhat.com>
	<0c4901cef6df$e557cec0$b0076c40$@acm.org>
	<20131213142002.GA9302@redhat.com>
	<0e4a01cef83b$c9afe5b0$5d0fb110$@acm.org>
	<20131213212156.GB11452@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131213212156.GB11452@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 13, 2013 at 04:21:56PM -0500, Mike Snitzer wrote:

> FYI, the most recent dm-cache fixes should hopefully be available in
> linus's tree shortly.  Joe fixed the dm cache metadata leak that he
> advised you to wait for before using dm-cache in a more serious way.

Cool, I'm guessing that's the "dm array: fix a reference counting bug in
shadow_ablock" commit? I'll keep an eye out for that in the 3.12.x
changelogs, thanks...
