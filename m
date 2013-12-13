From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache questions
Date: Fri, 13 Dec 2013 16:21:56 -0500
Message-ID: <20131213212156.GB11452@redhat.com>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
	<20131210095019.GB32555@debian>
	<0a9401cef5eb$7e32a110$7a97e330$@acm.org>
	<20131211010337.GB4894@agk-dp.fab.redhat.com>
	<0aea01cef615$d688f8d0$839aea70$@acm.org>
	<20131211150644.GA28188@redhat.com>
	<0c4901cef6df$e557cec0$b0076c40$@acm.org>
	<20131213142002.GA9302@redhat.com>
	<0e4a01cef83b$c9afe5b0$5d0fb110$@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0e4a01cef83b$c9afe5b0$5d0fb110$@acm.org>
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

On Fri, Dec 13 2013 at  2:44pm -0500,
Paul B. Henson <henson@acm.org> wrote:

> > From: Mike Snitzer
> > Sent: Friday, December 13, 2013 6:20 AM
> > 
> > But in general it is the task of other distro vendors to backport stable
> > fixes to their products.
> 
> Got it, thanks. I see the recent beta announcement officially confirmed that
> RHEL 7 will be based on 3.10, so I'm guessing somebody in your organization
> is going to be back porting to that stable release at least :). Although I
> suppose that could be in your internal wad-o-patches rather than official
> upstream commits.

All the latest dm-cache changes will be included in RHEL7.  I'm the
lucky guy who brings these changes back.

FYI, the most recent dm-cache fixes should hopefully be available in
linus's tree shortly.  Joe fixed the dm cache metadata leak that he
advised you to wait for before using dm-cache in a more serious way.

See:
http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-linus
