From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: semop failed for cookie?
Date: Thu, 29 Apr 2010 17:23:38 +0100
Message-ID: <20100429162338.GA14077@agk-dp.fab.redhat.com>
References: <4BD74F99.8020605@filteredperception.org>
	<20100427223323.GB29708@agk-dp.fab.redhat.com>
	<4BD8C0B2.7020509@filteredperception.org>
	<20100429000045.GF29708@agk-dp.fab.redhat.com>
	<4BD8FDE6.40507@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BD8FDE6.40507@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Douglas McClendon <dmc.fedora@filteredperception.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 28, 2010 at 10:32:54PM -0500, Douglas McClendon wrote:
> case, literally nothing would happen while both instances were 'live',  

If you had no data written to the snapshot or origin while both
were loaded, you might have got away with it.  But I think the new handover
code give you a safe and supported mechanism now.

Alasdair
