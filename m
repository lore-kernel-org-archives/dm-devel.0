From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] reworked dm-switch target
Date: Thu, 16 Aug 2012 08:09:55 +0100
Message-ID: <20120816070955.GA32526@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1208151832280.8587@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Kevin_OKelley@dell.com, Jim_Ramsay@dell.com, Narendran_Ganapathy@dell.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 15, 2012 at 06:36:55PM -0400, Mikulas Patocka wrote:
> For example "dmsetup message switch 0 set-table 0-15:0 16-31:1 32-33:2"

What I think we need to know now is how large this makes a typical message to
set up the table.  Set up can be split between several messages.
Or is typical data sufficiently random and large that a more-compact
might be a better idea?
 
Alasdair
