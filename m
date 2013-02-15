From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-thinp BUG
	at	drivers/md/persistent-data/dm-btree-remove.c:188
Date: Thu, 14 Feb 2013 22:48:11 -0500
Message-ID: <20130215034811.GA10038@redhat.com>
References: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
	<20130215023400.GM24130@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130215023400.GM24130@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@ew.ewheeler.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 14 2013 at  9:34pm -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Feb 14, 2013 at 06:07:56PM -0800, Eric Wheeler wrote:
> > Does this indicate a corrupt volume or metadata volume?
> 
> It could be a software bug.
> It is always worth trying the newest code, but I don't spot any
> obvious change that could be related to this.
...
> The trace shows it's applying a 'discard' to the metadata and releasing
> blocks when the problem occurs.

Right, given that the BUG trace shows active discards it could be that
v3.8 commit e808807 ("dm thin: fix race between simultaneous io and
discards to same block") may help.

(though I never saw that race manifest with the BUG in question)
