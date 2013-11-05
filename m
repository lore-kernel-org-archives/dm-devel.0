From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 4/4] dm-crypt: Fix sparse (different
	base	types) warnings
Date: Tue, 5 Nov 2013 13:41:51 +0000
Message-ID: <20131105134151.GE27505@agk-dp.fab.redhat.com>
References: <20131030181241.GA24325@agk-dp.fab.redhat.com>
	<1383427444-19174-1-git-send-email-gmazyland@gmail.com>
	<1383427444-19174-2-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1383427444-19174-2-git-send-email-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Nov 02, 2013 at 10:24:04PM +0100, Milan Broz wrote:
> N.B. there is still warning about variable length array,
> but this code is common use of hash structure on stack on
> many parts of the kernel.
 
Indeed, I never discovered a satisfactory way to avoid those ones.

Alasdair
