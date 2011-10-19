From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 2] DM log userspace: Minor fix-ups
Date: Wed, 19 Oct 2011 01:13:56 +0100
Message-ID: <20111019001355.GP24527@agk-dp.fab.redhat.com>
References: <1318533312.28595.4.camel@f14.redhat.com>
	<1318533394.28595.6.camel@f14.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1318533394.28595.6.camel@f14.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Oct 13, 2011 at 02:16:34PM -0500, Jon Brassow wrote:
> dm-log-userspace: use kzalloc instead of kmalloc
 
But what's the reason?

Is this fixing a bug or not?

The patch header needs to tell us so we know whether this should be
backported to stable or not, for example.

Alasdair
