From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 13:00:47 -0500
Message-ID: <200506301300.47209.kevcorry@us.ibm.com>
References: <d459df3fa77e2c972d837f613a137de5@redhat.com>
	<200506301138.29354.kevcorry@us.ibm.com>
	<20050630175645.GG27078@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050630175645.GG27078@agk.surrey.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu June 30 2005 12:56 pm, Alasdair G Kergon wrote:
> On Thu, Jun 30, 2005 at 11:38:28AM -0500, Kevin Corry wrote:
> > Any time a target's table-format or status-format changes, we also need
> > to increment that target's version number so user-space can figure out
> > which format to expect.
>
> Indeed, but I don't want version numbers updating till we know what
> sequence things will go upstream.

Of course. As long as it gets updated before it hits mainline. :)

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
