From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: 2.6.11-rc3-udm1
Date: Tue, 8 Feb 2005 14:36:31 +0000
Message-ID: <20050208143631.GR14093@agk.surrey.redhat.com>
References: <20050207184930.GR10195@agk.surrey.redhat.com>
	<200502080821.00728.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200502080821.00728.kevcorry@us.ibm.com>
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

On Tue, Feb 08, 2005 at 08:21:00AM -0600, Kevin Corry wrote:
> We should bump the snapshot version number to 1.0.2 or 1.1.0 so the tools 
> can detect whether this change has been applied. 

Yep, I'll update them, but I normally prefer not to update the version numbers 
until I'm sure what order things will go upstream.  In the past I had to delay
one patch which was ready to submit because it had a later version number 
than another which wasn't.  

Alasdair
-- 
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
