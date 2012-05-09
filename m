From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Does dm-thin support GC (garbage collection) ?
Date: Wed, 9 May 2012 09:47:11 -0400
Message-ID: <20120509134710.GA25513@redhat.com>
References: <CAJv3x-Xk-aODfJtqCEBKPM1jkwXEFVN40EEu_hnnDZB9o4dBWw@mail.gmail.com>
	<20120507132242.GA27715@redhat.com>
	<CAJv3x-USC=8z7Kz_-p8uOiQkdE21Oe0isMeDOBKRc4semHbLCA@mail.gmail.com>
	<CAJv3x-U1VRyq1m6oJQ0X8nn4WSiAzVnqm7CLuPGj-xmDh8c1AQ@mail.gmail.com>
	<20120508103032.GB4034@ubuntu>
	<CAJv3x-WpO85tOG0Gt8ZS5JV9Z_81G4F=_gHzSjtroVogAtgm4A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAJv3x-WpO85tOG0Gt8ZS5JV9Z_81G4F=_gHzSjtroVogAtgm4A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Busby <chaimvy@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, May 09 2012 at  2:03am -0400,
Busby <chaimvy@gmail.com> wrote:

> I created pool without ignore_discard feature, is this the way to
> enable discard? I mounted the ext4 with '--discard' args, I will trace
> whether the ext4 really issue discard later.

thin-pool's discard support (and discard passdown) are enabled by
default.  But again, if the underlying storage doesn't support discards
you'll get this warning when you load the thin-pool's table:

device-mapper: thin: Discard unsupported by data device: Disabling discard passdown.
