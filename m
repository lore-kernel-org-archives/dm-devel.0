From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 1] dm table cleanup warning message
Date: Thu, 14 May 2009 14:43:52 +0100
Message-ID: <20090514134352.GH25793@agk-dp.fab.redhat.com>
References: <200903201511.n2KFBIVp016118@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200903201511.n2KFBIVp016118@hydrogen.msp.redhat.com>
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

On Fri, Mar 20, 2009 at 10:11:18AM -0500, Jon Brassow wrote:
> +		DMWARN("dm_put_device calls missing for:");
> +		list_for_each_entry(dd, &t->devices, list)
> +			DMWARN(" - %s", dd->dm_dev.name);

The multi-line format is unnecessary there: I'm changing it.
(Think what happens if it gets intermingled with other similar-looking
multi-line output.  Each line of output should make sense in isolation.)

Alasdair
