From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 9/9] dm crypt: sort writes
Date: Tue, 1 Apr 2014 21:15:45 +0100
Message-ID: <20140401201545.GA24739@agk-dp.fab.redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-10-git-send-email-snitzer@redhat.com>
	<53368043.5000808@gmail.com> <20140331123940.GB25683@redhat.com>
	<20140401083755.55afa738d5a98b6bc07aca71@valinux.co.jp>
	<20140401010129.GB9214@redhat.com> <533AF8E0.2040907@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <533AF8E0.2040907@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 01, 2014 at 07:35:28PM +0200, Milan Broz wrote:
> Btw if you don't like sysfs option for disabling this, it can be optional table parameter,
> there is already discard support implemented this way.
> (I could add this myself later... just need to find at least few hours
> of free time:)
 
But apart from using that option for benchmarking purposes, is there any reason
anyone would need to turn this off?

Do we know of any circumstances where the sorting causes a non-neglible
performance hit?

Alasdair
