From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: bio's bi_size bug also be founded at dm-stripe.c and
	dm-snap.c (resend in correct charset)
Date: Wed, 29 Jun 2005 15:42:53 +0100
Message-ID: <20050629144253.GR27078@agk.surrey.redhat.com>
References: <00a501c57c92$c3041020$1f000064@polaris>
	<200506290630.57441.kevcorry@us.ibm.com>
	<200506290646.00118.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200506290646.00118.kevcorry@us.ibm.com>
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
Cc: Zhao Qian <zhaoqian@aaastor.com>
List-Id: dm-devel.ids

On Wed, Jun 29, 2005 at 06:46:00AM -0500, Kevin Corry wrote:
> Alasdair, should that field be set for dm-mirror targets? 

Like you, I assumed it already was:-)

Zhao, does Kevin's patch fix things for you?

Alasdair
-- 
agk@redhat.com
