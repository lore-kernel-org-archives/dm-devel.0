From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCHv2] dm-verity: Add error handling modes
	for	corrupted blocks
Date: Tue, 17 Mar 2015 18:50:53 +0000
Message-ID: <20150317185053.GC21831@agk-dp.fab.redhat.com>
References: <20150316155559.GA32397@google.com>
	<20150317163707.GA39776@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150317163707.GA39776@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>
Cc: wad@chromium.org, msb@chromium.org, mpatocka@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 17, 2015 at 04:37:07PM +0000, Sami Tolvanen wrote:
> +<mode>
> +    Optional. 

The format needs to remain easily extendable.

Two alternatives:

  Document this as a required field going forward, but say that if
  it is missing the default will be assumed.

  eio|logging|restart  (but those names are confusing)


Or (my preference) use a 'features' approach like most other targets do:

<number of feature> <feature arguments>

"error" is the existing default, so doesn't need stating.

The other two could be:
  restart_on_corruption
  ignore_corruption

Logging and events would happen in all cases, but if they did need
controlling independently, additional feature arguments could do that.

Alasdair
