From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 19:48:27 +0100
Message-ID: <20101010184827.GG28828@agk-dp.fab.redhat.com>
References: <20101010115941.GA8539@basil.fritz.box>
	<4CB1B3B9.4030205@redhat.com>
	<20101010130842.GE8256@basil.fritz.box>
	<4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>
	<20101010170151.GD28828@agk-dp.fab.redhat.com>
	<20101010174454.GA21681@basil.fritz.box>
	<20101010181736.GE28828@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101010181736.GE28828@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 10, 2010 at 07:17:36PM +0100, Alasdair G Kergon wrote:
> AFAIK Nested dm-crypt is not extreme for some folk who have routine
> configurations using it.  But if in_interrupt is set how does this code
> work for them now compared to how it worked before?
 
And indeed, even if in_interrupt is not set, is there any performance
impact for this (minority) class of users?

Alasdair
