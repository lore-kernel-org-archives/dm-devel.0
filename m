From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dmsetup: Remove limitation on table file line
	length
Date: Wed, 10 May 2006 20:50:31 +0100
Message-ID: <20060510195031.GV16180@agk.surrey.redhat.com>
References: <200605081359.32562.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200605081359.32562.kevcorry@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, May 08, 2006 at 01:59:32PM -0500, Kevin Corry wrote:
> To get around this limitation, I wrote a patch that simply changes from using 
> fgets() to getline() in the _parse_file() routine. The getline() routine will 
> automatically allocate (or reallocate) space as needed to read in an entire 
> line from a file.
 
Applied.

Thanks,
Alasdair
-- 
agk@redhat.com
