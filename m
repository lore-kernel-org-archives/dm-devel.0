From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 11/15] libmultipath: change failed path prio
	timeout
Date: Mon, 20 Jan 2020 10:22:48 -0600
Message-ID: <20200120162248.GR30153@octiron.msp.redhat.com>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-12-git-send-email-bmarzins@redhat.com>
	<7b276f0772bf9aeb92d3af16e3072f717de5318e.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7b276f0772bf9aeb92d3af16e3072f717de5318e.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 17, 2020 at 06:18:46PM +0100, Martin Wilck wrote:
> On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> This changes the unit of the first get_prio_timeout() argument from
> seconds to milliseconds. While that's a good thing (it was questionable
> design to have the same function take several "timeout" arguments in
> different units), we should rename the argument there to avoid
> confusion (checker_timeout's unit is seconds all around).

Sure.

-Ben

> 
> Apart from that, ACK.
> 
