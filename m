From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-cache questions
Date: Wed, 11 Dec 2013 01:03:38 +0000
Message-ID: <20131211010337.GB4894@agk-dp.fab.redhat.com>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
	<20131210095019.GB32555@debian>
	<0a9401cef5eb$7e32a110$7a97e330$@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0a9401cef5eb$7e32a110$7a97e330$@acm.org>
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

On Tue, Dec 10, 2013 at 01:04:58PM -0800, Paul B. Henson wrote:
> Ouch. Life on the bleeding edge ;). Do fixes like this get backported to
> 3.10LTS, or just to the latest mainline/stable kernel? 

We send them to mainline and stable then it is up to the distributions
concerned to choose to apply them.  Sometimes it helps to give the
distribution(s) concerned a gentle prod and ask if they've noticed the
patch(es) and if/when they'll be taking them.

> Any idea when dm-cache support is going to show up in lvm2? 

Various aspects of the design are being debated.  Expect to see progress 
to start to appear on lvm-devel over the next few weeks.  We're
hopeful we'll have something that's beginning to be useful in January.

Alasdair
