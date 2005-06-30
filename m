From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mirroring: [patch 5 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 18:56:45 +0100
Message-ID: <20050630175645.GG27078@agk.surrey.redhat.com>
References: <d459df3fa77e2c972d837f613a137de5@redhat.com>
	<200506301138.29354.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200506301138.29354.kevcorry@us.ibm.com>
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

On Thu, Jun 30, 2005 at 11:38:28AM -0500, Kevin Corry wrote:
> Any time a target's table-format or status-format changes, we also need to 
> increment that target's version number so user-space can figure out which 
> format to expect.
 
Indeed, but I don't want version numbers updating till we know what
sequence things will go upstream.

BTW I've not seen a justification for breaking the existing format here
yet as opposed to simply appending new data to the end of the status line.

Alasdair
-- 
agk@redhat.com
