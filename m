From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes
	for	corrupted blocks
Date: Tue, 17 Mar 2015 00:45:55 +0000
Message-ID: <20150317004555.GB21831@agk-dp.fab.redhat.com>
References: <20150316155559.GA32397@google.com>
	<CABqD9hak_3uhczdpj70WDH9A2FfgT69zdvV8+xDH8omFEhPvSA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABqD9hak_3uhczdpj70WDH9A2FfgT69zdvV8+xDH8omFEhPvSA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Will Drewry <wad@chromium.org>
Cc: Mandeep Baines <msb@chromium.org>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

On Mon, Mar 16, 2015 at 05:13:10PM -0500, Will Drewry wrote:
> Should the dm status reflect the failure even if logging mode isn't
> returning EIOs? I think it makes sense still, but it might be good to
 
The uevents shouldn't be relied upon: 'status' must still tell you
everything you need to know about the internal state of the device.

'table' should show the new parameter and 'status' should probably show
it too if it's needed to interpret the 'status' properly.

Alasdair
