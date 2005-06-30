From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 19:58:57 +0100
Message-ID: <20050630185857.GH27078@agk.surrey.redhat.com>
References: <d459df3fa77e2c972d837f613a137de5@redhat.com>
	<200506301138.29354.kevcorry@us.ibm.com>
	<20050630175645.GG27078@agk.surrey.redhat.com>
	<81d8053f082764c89f295d2defd3e16c@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <81d8053f082764c89f295d2defd3e16c@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan E Brassow <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 30, 2005 at 01:10:04PM -0500, Jon Brassow wrote:
> mirror_status first calls the log status function and then adds on to 
> that.  If we want to do what you are proposing, we would move the log 
> status function _after_ the DMEMIT's for mirror and it would only print 
> out a char for each log device indicating status.  We would have to 
> remember that STATUSTYPE_INFO and STATUSTYPE_TABLE would call the log 
> status function at different place (one after it's own DMEMITs, the 
> other before).
 
Backwards compatibility has to take precedence over tidiness here if you
want these patches including quickly.  If you don't mind waiting several
months while the necessary userspace support gets widely propagated,
then we can indeed tidy things up now.  But I'm not prepared to see
device-mapper kernel incompatibilities go in ahead of the userspace 
preparation.

Alasdair
-- 
agk@redhat.com
