From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Constructing RAID 1+0 w/ LVM2/DM
Date: Thu, 24 Jan 2008 14:35:40 +0000
Message-ID: <20080124143540.GZ8075@agk.fab.redhat.com>
References: <47989DA2.1070201@hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <47989DA2.1070201@hp.com>
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

On Thu, Jan 24, 2008 at 09:16:02AM -0500, Alan D. Brunelle wrote:
>        /dev/dm-2: Skipping: Suspended dm device

That code was never completed.  It applies a stronger test than
necessary and assumes no mirrors are safe to use, even though some
would be.

Alasdair
-- 
agk@redhat.com
