From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache questions
Date: Wed, 11 Dec 2013 10:06:44 -0500
Message-ID: <20131211150644.GA28188@redhat.com>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
	<20131210095019.GB32555@debian>
	<0a9401cef5eb$7e32a110$7a97e330$@acm.org>
	<20131211010337.GB4894@agk-dp.fab.redhat.com>
	<0aea01cef615$d688f8d0$839aea70$@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0aea01cef615$d688f8d0$839aea70$@acm.org>
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
Cc: 'device-mapper development' <dm-devel@redhat.com>, 'Alasdair G Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Dec 10 2013 at  9:08pm -0500,
Paul B. Henson <henson@acm.org> wrote:

> > From: Alasdair G Kergon [mailto:agk@redhat.com]
> > Sent: Tuesday, December 10, 2013 5:04 PM
> >
> > We send them to mainline and stable then it is up to the distributions
> > concerned to choose to apply them.
> 
> I meant more whether they'd get applied to the LTS kernel upstream; eg, show
> up in a minor patch to 3.10 from kernel.org. 

3.10 is actively maintained by gregkh as a "longterm" stable kernel so
all relevant upstream commits should make their way into that tree:
http://www.linuxfoundation.org/news-media/blogs/browse/2013/08/longterm-kernel-310
