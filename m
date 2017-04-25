From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [BUG] multipath-tools: missing internal values
 (multipath -t)
Date: Tue, 25 Apr 2017 13:42:24 -0500
Message-ID: <20170425184224.GV19236@octiron.msp.redhat.com>
References: <5a9ce04c-3996-9f88-1682-822b0d7b9e65@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5a9ce04c-3996-9f88-1682-822b0d7b9e65@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 25, 2017 at 04:26:06PM +0200, Xose Vazquez Perez wrote:
> Hi,
> 
> These values:

What do you think of these?
> no_path_retry

The default if no_path_retry is set is to use the features line to
determine what to do when there are no paths. we could have it
print something like

no_path_retry <undef>

> dev_loss_tmo

The default here is to keep whatever the sysfs value currently is. We
could print

dev_loss_tmo <undef>

or

dev_loss_tmo <sysfs>

or something else. I'm open to ideas.

> reservation_key

The default here is nothing

reservation_key <undef>

probably makes the most sense

> partition_delimite

The default here is an empty string

partition_delm ""

is probably the right answer.

> delay_watch_checks
> delay_wait_checks

These clearly have well defined default values and should be set.


-Ben

> are missing from the "defaults section" of multipath -t output.
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
