From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Multipath target does not shift block offset?
Date: Fri, 11 Feb 2005 18:29:21 +0000
Message-ID: <20050211182921.GH14093@agk.surrey.redhat.com>
References: <420AEAE4.8090506@anu.edu.au>
	<20050210171832.GC14093@agk.surrey.redhat.com>
	<200502101323.30143.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200502101323.30143.kevcorry@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kevin Corry <kevcorry@us.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 10, 2005 at 01:23:30PM -0600, Kevin Corry wrote:
> Actually, now that you point this out, I think this responsibility should
> really be handled by the core driver's I/O path instead of each target
> module. 

Absolutely - I didn't notice the bug before because I assumed it already 
worked that way:-)

Alasdair
-- 
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
